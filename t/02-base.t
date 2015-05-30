use v6;

use Readline;
use Test;

plan 17;

my $r = Readline.new;

lives-ok { my $rv = $r.rl-initialize },
         'rl-initialize';

subtest sub {
  my $readable = False;

#  lives-ok { $r.rl-function-dumper( $readable ) }, # XXX Noisy
#           'rl-function-dumper lives';
  lives-ok { $r.rl-macro-dumper( $readable ) },
           'rl-macro-dumper lives';
#  lives-ok { $r.rl-variable-dumper( $readable ) }, # XXX Noisy
#           'rl-variable-dumper lives';
}, 'dumpers';

subtest sub {
  my $prompt = 'readline$ ';

  lives-ok { my $rv = $r.rl-set-prompt( $prompt ) },
           'rl-set-prompt lives';
  lives-ok { my $rv = $r.rl-expand-prompt( $prompt ) },
           'rl-expand-prompt lives';
  lives-ok { my $rv = $r.rl-on-new-line-with-prompt },
           'rl-on-new-line-with-prompt lives';
  lives-ok { $r.rl-save-prompt },
           'rl-save-prompt lives';
  lives-ok { $r.rl-restore-prompt },
           'rl-restore-prompt lives';
}, 'prompt';

subtest sub {
  my $str = 'foo';
  my $filename = 'test.txt';
  my $src-offset;
  my ( $offset, $p-offset ) = ( 0, \$src-offset );

  lives-ok { my $rv = $r.tilde-expand( $str ) },
           'tilde-expand lives';
  lives-ok { my $rv = $r.tilde-expand-word( $filename ) },
           'tilde-expand-word lives';
#  lives-ok { my $rv = $r.tilde-find-word( $str, $offset, $p-offset ) }; # XXX Wrap the pointer
#           'tilde-find-word lives';
}, 'tilde';

subtest sub {
  my $meta-flag = 1; # XXX Fix the type
  my $terminal-name = 'vt100';

  lives-ok { $r.rl-prep-terminal( $meta-flag ) },
           'rl-prep-terminal lives';
  lives-ok { $r.rl-deprep-terminal },
           'rl-deprep-terminal lives';
  lives-ok { my $rv = $r.rl-reset-terminal( $terminal-name ) },
           'rl-reset-terminal';
#  lives-ok { $r.rl-resize-terminal }, # XXX Noisy
#           'rl-resize-terminal lives';
}, 'terminal';

subtest sub {
  my $readline-state;
  lives-ok { my $rv = $r.rl-reset-line-state },
           'rl-reset-line-state lives';
#  lives-ok { $r.rl-free-line-state }, # XXX Noisy
#           'rl-free-line-state lives';
#  lives-ok { my $rv = $r.rl-save-state( $readline-state ) },
#           'rl-save-state lives';
#  lives-ok { my $rv = $r.rl-restore-state( $readline-state ) },
#           'rl-save-state lives';
}, 'state';

subtest sub {
  lives-ok { $r.rl-free-undo-list },
           'rl-free-undo-list lives';
  lives-ok { my $rv = $r.rl-do-undo },
           'rl-do-undo lives';
  lives-ok { my $rv = $r.rl-begin-undo-group },
           'rl-begin-undo-group lives';
  lives-ok { my $rv = $r.rl-end-undo-group },
           'rl-end-undo-group lives';
}, 'undo';

subtest sub {
  my $name = 'foo';
  sub my-callback( Int, Int ) returns Int { };

#  lives-ok { $r.rl-list-funmap-names }, # XXX Noisy
#           'rl-list-funmap-names lives';
#  lives-ok { my $rv = $r.rl-add-funmap-entry( $name, &my-callback ) }, # XXX Blows chunks in valgrind
#           'rl-add-funmap-entry lives';
  lives-ok { my @rv = $r.rl-funmap-names },
           'rl-funmap-names lives';
}, 'funmap';

subtest sub {
  my ( $rows, $cols ) = ( 80, 24 );

  lives-ok { $r.rl-set-screen-size( $rows, $cols ) },
           'rl-set-screen-size';
#  lives-ok { $r.rl-get-screen-size( \$rows, \$cols ) }, # XXX Rewrite
#           'rl-get-screen-size lives';
  lives-ok { $r.rl-reset-screen-size },
           'rl-reset-screen-size lives';
}, 'screen';

subtest sub {
  my $text = 'food';
  my ( $start, $end ) = ( 1, 2 );

  lives-ok { my $rv = $r.rl-insert-text( $text ) },
           'rl-insert-text lives';
  lives-ok { my $rv = $r.rl-delete-text( $start, $end ) },
           'rl-delete-text lives';
  lives-ok { my $rv = $r.rl-kill-text( $start, $end ) },
           'rl-kill-text lives';
  lives-ok { my $rv = $r.rl-copy-text( $start, $end ) },
           'rl-copy-text lives';
}, 'text';

subtest sub {
  my $keymap;
  my $name = 'emacs';

  lives-ok { $keymap = $r.rl-make-bare-keymap },
           'rl-make-bare-keymap lives';
  lives-ok { my $copy-keymap = $r.rl-copy-keymap( $keymap ) },
           'rl-copy-keymap lives';
  lives-ok { my $keymap = $r.rl-make-keymap },
           'rl-make-keymap lives';
  lives-ok { $r.rl-discard-keymap( $keymap ) },
           'rl-discard-keymap lives';
  lives-ok { $r.rl-free-keymap( $keymap ) },
           'rl-free-keymap lives';
  lives-ok { my $keymap = $r.rl-get-keymap-by-name( $name ) },
           'rl-get-keymap-by-name lives';
  lives-ok { my $keymap = $r.rl-get-keymap },
           'rl-get-keymap lives';
  lives-ok { my $name = $r.rl-get-keymap-name( $keymap ) },
           'rl-get-keymap-name lives';
  lives-ok { $r.rl-set-keymap( $keymap ) },
           'rl-set-keymap lives';
}, 'keymap';

subtest sub {
  my $key = 'x';
  sub my-callback( Int $a, Int $b ) returns Int { }
  my $keyseq = 'xx';
  my $line = 'foo';

  subtest sub {
    my $keymap = $r.rl-make-bare-keymap;
    my $index = 0;
    my $macro = 'xx';
    lives-ok { my $rv = $r.rl-bind-key-in-map( $key, &my-callback, $keymap ) },
             'rl-bind-key-in-map lives';
    lives-ok { my $rv = $r.rl-bind-key-if-unbound-in-map(
                           $key, &my-callback, $keymap ) },
             'rl-bind-key-if-unbound-in-map lives';
    lives-ok { my $rv = $r.rl-bind-keyseq-in-map(
                           $keyseq, &my-callback, $keymap ) },
             'rl-bind-keyseq-in-map lives';
#    lives-ok { my $rv = $r.rl-bind-keyseq-if-unbound-in-map( # XXX Blows chunks under valgrid by cascading to rl_generic_bind
#                           $keyseq, &my-callback, $keymap ) },
#             'rl-bind-keyseq-if-unbound-in-map lives';
#    lives-ok { my $rv = $r.rl-generic-bind( $index, $keyseq, $line, $keymap ) }, # XXX Blows chunks under valgrind
#             'rl-generic-bind lives';
    lives-ok { my $rv = $r.rl-macro-bind( $keyseq, $macro, $keymap ) },
             'rl-macro-bind lives';
  }, 'bind keymaps';
#  lives-ok { my $rv = $r.rl-bind-key( $key, &my-callback ) }, # XXX Blows chunks under valgrind
#           'rl-bind-key lives';
#  lives-ok { my $rv = $r.rl-bind-key-if-unbound( $key, &my-callback ) }, # XXX Blows chunks under valgrind
#           'rl-bind-key-if-unbound lives';
#  lives-ok { my $rv = $r.rl-bind-keyseq( $keyseq, &my-callback ) }, # XXX Blows chunks under valgrind by cascading to rl_generic_bind
#           'rl-bind-keyseq lives';
#  lives-ok { my $rv = $r.rl-bind-keyseq-if-unbound( $keyseq, &my-callback ) }, # XXX Blows chunks under valgrind by cascading to rl_generic_bind
#           'rl-bind-keyseq-if-unbound lives';
#  lives-ok { my $rv = $r.rl-parse-and-bind( $line ) }, # XXX Blows chunks in valgrind by cascading to rl_generic_bind
#           'rl-parse-and-bind lives';
}, 'bind';

subtest sub {
  my $key = 'x';
  my $keymap = $r.rl-make-bare-keymap;
  sub my-callback( Int $a, Int $b ) returns Int { }

#  lives-ok { my $rv = $r.rl-unbind-key( $key ) }, # XXX Blows chunks under valgrind?
#           'rl-unbind-key lives';
  lives-ok { my $rv = $r.rl-unbind-key-in-map( $key, $keymap ) },
           'rl-unbind-key-in-map lives';
  lives-ok { my $rv = $r.rl-unbind-function-in-map( &my-callback, $keymap ) },
           'rl-unbind-function-in-map lives';
}, 'unbind';

subtest sub {
  my $history = 'foo';
  my $HISTORY-STATE;
  my $timestamp = '2015-01-01 00:00:00';
  my $index = 0;
  my $HIST-ENTRY;
  my $line = 'foo';
  my $data = 'foo data';
  my $dir = 0;
  my $filename = 'doesnt-exist.txt';
  my ( $from, $to ) = ( 1, 2 );

  lives-ok { $r.using-history },
           'using-history lives';
  lives-ok { $r.add-history( $history ) },
           'add-history lives';
  lives-ok { $HISTORY-STATE = $r.history-get-history-state },
           'history-get-history-state lives';
  lives-ok { $r.history-set-history-state( $HISTORY-STATE ) },
           'history-set-history-state lives';
  lives-ok { $r.add-history-time( $timestamp ) },
           'add-history-time lives';
  lives-ok { $HIST-ENTRY = $r.remove-history( $index ) },
           'remove-history lives';
  lives-ok { my $rv = $r.free-history-entry( $HIST-ENTRY ) },
           'free-history-entry lives';
  lives-ok { my $HIST-ENTRY = $r.replace-history-entry(
                                 $index, $line, $data ) },
           'replace-history-entry lives';
  lives-ok { $r.clear-history };
           'clear-history lives';
  subtest sub {
    lives-ok { my $rv = $r.history-is-stifled },
             'history-is-stifled lives';
    lives-ok { $r.stifle-history( 0 ) },
             'stifle-history lives';
    lives-ok { $r.unstifle-history },
             'unstifle-history lives';
  }, 'Stifling';

  #
  # The next few calls don't like having an empty history list, fill it.
  #
  $r.add-history( $history );
  lives-ok { my @rv = $r.history-list },
           'history-list lives';
  lives-ok { my $index = $r.where-history },
           'where-history lives';
  lives-ok { my $HIST-ENTRY = $r.current-history( $index ) },
           'current-history lives';
  lives-ok { my $HIST-ENTRY = $r.history-get( $index ) },
           'history-get lives';
  $HIST-ENTRY = $r.current-history( $index );
  lives-ok { my $rv = $r.history-get-time( $HIST-ENTRY ) },
           'history-get-time lives';
  lives-ok { my $size = $r.history-total-bytes },
           'history-total-bytes lives';
  lives-ok { my $rv = $r.history-set-pos( $index ) },
           'history-set-pos lives';
  lives-ok { my $HIST-ENTRY = $r.next-history },
           'next-history lives';
  lives-ok { my $HIST-ENTRY = $r.previous-history },
           'previous-history lives';
  lives-ok { my $rv = $r.history-search( $line, $index ) },
           'history-search lives';
  lives-ok { my $rv = $r.history-search-prefix( $line, $index ) },
           'history-search-prefix lives';
  lives-ok { my $rv = $r.history-search-pos( $line, $index, $dir ) },
           'history-search-pos lives';
  lives-ok { my $rv = $r.read-history( $filename ) },
           'read-history lives';
  lives-ok { my $rv = $r.read-history-range( $filename, $from, $to ) },
           'read-history-range lives';
####  lives-ok { my $rv = $r.write-history( Str $filename ) },
####           'write-history lives';
####  lives-ok { my $rv = $r.append-history( $offset, $filename ) };
####           'append-history lives';
####  lives-ok { my $rv = $r.history-truncate-file( $filename, $nLines ) },
####           'history-truncate-file lives';
#  lives-ok { my $rv = $r.history-expand( $string, Pointer[Str] $output ) returns Int };
#  lives-ok { my $rv = $r.history-arg-extract( $from, $to, $line ) },
#           'history-arg-extract lives';
#  lives-ok { my $rv = $r.get-history-event( $line, Pointer[Int] $cIndex, Str $delimiting-quote ) returns Str }; # XXX fix later
  lives-ok { my @rv = $r.history-tokenize( $line ) }, # XXX fix later
           'history-tokenize lives';
}, 'history';

subtest sub {
  my $username = 'jgoff';
  my $filename = 'sample.txt';
  my $index = 0;

#  lives-ok { my $rv = $r.rl-username-completion-function(
#                         $username, $index ) }; # XXX doesn't exist?
#  lives-ok { my $rv = $r.rl-filename-completion-function (
#                         $filename, $index ) }; # XXX Doesn't exist?
#  lives-ok { my $rv = $r.rl-completion-mode(
#                         Pointer[&callback (Int, Int --> Int)] $cfunc ) };
}, 'completion';

#subtest sub {
#  lives-ok { $r.rl-callback-handler-install( Str $prompt, &callback (Str) ) };
#  lives-ok { $r.rl-callback-read-char };
#  lives-ok { $r.rl-callback-handler-remove };
#}, 'callback';

subtest sub {
  my $username = 'jgoff';
  my $filename = 'sample.txt';
  my $index = 0;

#  lives-ok { my $rv = $r.rl-username-completion-function( $username, $index ) }; # XXX doesn't exist?
#  lives-ok { my $rv = $r.rl-filename-completion-function ( $filename, $index ) }; # XXX Doesn't exist?
#  lives-ok { my $rv = $r.rl-completion-mode( Pointer[&callback (Int, Int --> Int)] $cfunc ) };
}, 'completion';

##subtest sub {
##  lives-ok { my $rv = $r.rl-function-of-keyseq( $keyseq, $map, Pointer[Int] $type ) returns &callback (Int, Int --> Int) };
##  lives-ok { my $rv = $r.rl-invoking-keyseqs-in-map( Pointer[&callback (Int, Int --> Int)] $p-cmd, Keymap $map ) returns CArray[Str] };
##  lives-ok { my $rv = $r.rl-invoking-keyseqs( Pointer[&callback (Int, Int --> Int)] $p-cmd ) returns CArray[Str] };
##}, 'keyseq';

##
## These tests apparently mess with terminal settings. They pass, though.
##
##subtest sub {
##  lives-ok { my $rv = $r.rl-set-signals }, 'rl-set-signals lives';
##  lives-ok { my $rv = $r.rl-clear-signals }, 'rl-clear-signals lives';
##  lives-ok { $r.rl-cleanup-after-signal }, 'rl-cleanup-after-signal lives';
##  lives-ok { $r.rl-reset-after-signal }, 'rl-reset-after-signal lives';
##}, 'signal';

subtest sub {
####  lives-ok { my $rv = $r.readline( Str $prompt ) returns Str };
####  lives-ok { my $rv = $r.rl-ding }; # XXX Don't annoy the user.
##  lives-ok { my $rv = $r.rl-add-defun( Str $str, &callback (Int, Int --> Int), Str $key ) returns Int };
##  lives-ok { my $rv = $r.rl-variable-value( Str $variable ) returns Str };
##  lives-ok { $r.rl-set-key( Str $str, &callback (Int, Int --> Int), Keymap $map ) };
##  lives-ok { my $rv = $r.rl-named-function( Str $s ) returns &callback (Int, Int --> Int) };
  my $filename = 'doesnt-exist.txt';
  my $macro = 'xx';
  my ( $start, $end ) = ( 1, 2 );
  lives-ok { $r.rl-read-init-file( $filename ) },
           'rl-read-init-file lives';
  lives-ok { $r.rl-push-macro-input( $macro ) },
         'rl-push-macro-input lives';
  lives-ok { my $rv = $r.rl-modifying( $start, $end ) },
           'rl-modifying lives';
##  lives-ok { $r.rl-redisplay }, # XXX Noisy
##           'rl-redisplay lives';
##  lives-ok { my $rv = $r.rl-on-new-line }, # XXX Noisy
##           'rl-on-new-line lives';
##  lives-ok { my $rv = $r.rl-forced-update-display }, # XXX Noisy
##           'rl-forced-update-display lives';
##  lives-ok { my $rv = $r.rl-clear-message }, # XXX Noisy
##           'rl-clear-message lives';
##  lives-ok { my $rv = $r.rl-crlf }, # XXX Noisy
##           'rl-crlf lives';
  my $c = 'x';
  my $line = 'foo';
  my $clear-undo = 1;
  my $keymap = $r.rl-make-bare-keymap;
  my $cap = 'termcap.1';
  my $len = 1;
  my $timeout = 3;
##  lives-ok { my $rv = $r.rl-show-char( $c ) }, # XXX Noisy
##           'rl-show-char lives';
  lives-ok { $r.rl-replace-line( $line, $clear-undo ) },
           'rl-replace-line';
  lives-ok { $r.rl-tty-set-default-bindings( $keymap ) },
           'rl-tty-set-default-bindings lives';
  lives-ok { $r.rl-tty-unset-default-bindings( $keymap ) },
           'rl-tty-unset-default-bindings lives';
  lives-ok { my $rv = $r.rl-get-termcap( $cap ) },
           'rl-get-termcap lives';
  lives-ok { my $rv = $r.rl-extend-line-buffer( $len ) },
           'rl-extend-line-buffer lives';
  lives-ok { my $rv = $r.rl-alphabetic( $c ) },
           'rl-alphabetic lives';
###  lives-ok { $r.rl-free( Pointer $mem ) }
###           'rl-free lives';
  lives-ok { my $rv = $r.rl-set-paren-blink-timeout( $timeout ) },
           'rl-set-paren-blink-timeout lives';
  my $what-to-do = 1;
  lives-ok { my $rv = $r.rl-complete-internal( $what-to-do ) },
           'rl-complete-internal lives';
}, 'Miscellaneous';
