extends Area2D

var tiles = []
var solved = []
var mouse = false
var offset = 267

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()
	
func start_game():
	$Label.visible = false
	tiles = [$Tile1, $Tile2, $Tile3, $Tile4, $Tile5, $Tile6, $Tile7, $Tile8, $Tile9]
	solved = tiles.duplicate()
	shuffle_tiles()
	
func shuffle_tiles():
	var previous = 99
	var previous_1 = 98
	for t in range(0, 100):
		var tile = randi() % 9
		if tiles[tile] != $Tile9 and tile != previous and tile != previous_1:
			var rows = int(tiles[tile].position.y/offset)
			var cols = int(tiles[tile].position.x/offset)
			check_neighbours(rows, cols)
			previous_1 = previous
			previous = tile

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var rows = int(mouse_copy.position.y/offset)
		var cols = int(mouse_copy.position.x/offset)
		#print("[", rows, ", ", cols, "]")
		check_neighbours(rows, cols)
		if tiles == solved:
			$Label.visible = true
			print("You win!")
		else:
			$Label.visible = false

func check_neighbours(rows, cols):
	var pos = rows * 3 + cols
	var directions = [
		Vector2(1, 0),  # Down
		Vector2(-1, 0), # Up
		Vector2(0, 1),  # Right
		Vector2(0, -1)  # Left
	]

	for dir in directions:
		var new_rows = rows + dir.x
		var new_cols = cols + dir.y
		var new_pos = new_rows * 3 + new_cols
		
		if new_rows >= 0 and new_rows < 3 and new_cols >= 0 and new_cols < 3:
			if find_empty(Vector2(new_rows * offset, new_cols * offset), pos):
				return

			
func find_empty(position, pos):
	var new_rows = int(position.x / offset)
	var new_cols = int(position.y / offset)
	var new_pos = new_rows * 3 + new_cols 

	if new_pos < 0 or new_pos >= tiles.size():
		return false
	
	if (tiles[new_pos] == $Tile9):
		swap_tiles(pos, new_pos)
		return true
	else:
		return false
	
func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event
