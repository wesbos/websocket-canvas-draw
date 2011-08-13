# setup our application with its own namespace 
App = {}

###
	Init 
###
App.init = -> 
	App.canvas = document.createElement 'canvas' #create the canvas element 
	App.canvas.height = 400
	App.canvas.width = 800  #size it up
	document.getElementsByTagName('article')[0].appendChild(App.canvas) #append it into the DOM 
	
	App.ctx = App.canvas.getContext("2d") # Store the context 
	
	# set some preferences for our line drawing.
	App.ctx.fillStyle = "solid" 		
	App.ctx.strokeStyle = "#ECD018"		
	App.ctx.lineWidth = 5				
	App.ctx.lineCap = "round"
		
	# Sockets!
	App.socket = io.connect('http://localhost:4000')
	
	App.socket.on 'draw', (data) ->
		App.draw(data.x,data.y,data.type)
		
	# Draw Function
	App.draw = (x,y,type) ->
		if type is "dragstart"
			App.ctx.beginPath()
			App.ctx.moveTo(x,y)
		else if type is "drag"
			App.ctx.lineTo(x,y)
			App.ctx.stroke()
		else
			App.ctx.closePath()
	return
	

	

###
	Draw Events
###
$('canvas').live 'drag dragstart dragend', (e) ->
	type = e.handleObj.type
	offset = $(this).offset()
	
	e.offsetX = e.layerX - offset.left
	e.offsetY = e.layerY - offset.top
	x = e.offsetX 
	y = e.offsetY
	App.draw(x,y,type)
	App.socket.emit('drawClick', { x : x, y : y, type : type})
	return



# jQuery document.ready
$ ->	
	App.init()
