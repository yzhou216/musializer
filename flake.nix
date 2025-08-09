{
  description = "Flake for building and running Musializer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        compileTimeDeps = xorgDeps;
        runtimeDeps = xorgDeps ++ (with pkgs; [ libGL ]);
        xorgDeps = with pkgs.xorg; [
          libX11
          libXcursor
          libXrandr
          libXinerama
          libXi
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          packages = compileTimeDeps;
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath runtimeDeps}:$LD_LIBRARY_PATH";
          PATH = "${pkgs.lib.makeBinPath (with pkgs; [ ffmpeg ])}:$PATH";
        };
      }
    );
}
