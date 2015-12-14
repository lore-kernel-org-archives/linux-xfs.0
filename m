Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B4CC07F6C
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 17:41:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 103E7AC005
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:41:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sHvN5gys5dcHjFjz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:41:20 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 41686347A42
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 23:41:20 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v3 6/6] Remove the obsolete nfs4acl tests
Date: Tue, 15 Dec 2015 00:41:02 +0100
Message-Id: <1450136462-11521-7-git-send-email-agruenba@redhat.com>
In-Reply-To: <1450136462-11521-1-git-send-email-agruenba@redhat.com>
References: <1450136462-11521-1-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

The nfs4acl tests don't make sense anymore as they have been obsoleted
by richacls.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 nfs4acl/Makefile             |  29 ----
 nfs4acl/apply-mask.test      | 143 -------------------
 nfs4acl/basic.test           |  70 ----------
 nfs4acl/chmod.test           |  31 -----
 nfs4acl/chown.test           |  63 ---------
 nfs4acl/computed-mode.test   |  62 ---------
 nfs4acl/create.test          |  35 -----
 nfs4acl/ctime.test           |  36 -----
 nfs4acl/delete.test          |  77 ----------
 nfs4acl/run                  | 298 ---------------------------------------
 nfs4acl/unrepresentable.test |  20 ---
 nfs4acl/write-vs-append.test |  46 ------
 tests/xfs/191                |  75 ----------
 tests/xfs/191.out            | 324 -------------------------------------------
 tests/xfs/group              |   1 -
 15 files changed, 1310 deletions(-)
 delete mode 100644 nfs4acl/Makefile
 delete mode 100644 nfs4acl/apply-mask.test
 delete mode 100644 nfs4acl/basic.test
 delete mode 100644 nfs4acl/chmod.test
 delete mode 100644 nfs4acl/chown.test
 delete mode 100644 nfs4acl/computed-mode.test
 delete mode 100644 nfs4acl/create.test
 delete mode 100644 nfs4acl/ctime.test
 delete mode 100644 nfs4acl/delete.test
 delete mode 100755 nfs4acl/run
 delete mode 100644 nfs4acl/unrepresentable.test
 delete mode 100644 nfs4acl/write-vs-append.test
 delete mode 100755 tests/xfs/191
 delete mode 100644 tests/xfs/191.out

diff --git a/nfs4acl/Makefile b/nfs4acl/Makefile
deleted file mode 100644
index 42313f3..0000000
--- a/nfs4acl/Makefile
+++ /dev/null
@@ -1,29 +0,0 @@
-#-----------------------------------------------------------------------
-# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-
-TOPDIR = ..
-include $(TOPDIR)/include/builddefs
-
-LSRCFILES = run \
-	    apply-mask.test chmod.test computed-mode.test ctime.test \
-	    unrepresentable.test basic.test chown.test create.test \
-	    delete.test write-vs-append.test
-
-include $(BUILDRULES)
-
-default install install-dev install-lib:
diff --git a/nfs4acl/apply-mask.test b/nfs4acl/apply-mask.test
deleted file mode 100644
index 9b9483a..0000000
--- a/nfs4acl/apply-mask.test
+++ /dev/null
@@ -1,143 +0,0 @@
-$ rm -rf d
-$ mkdir d
-$ cd d
-
-$ touch x
-
-$ nfs4acl --set 'owner@:rw::allow group@:rw::allow everyone@:r::allow' x
-$ nfs4acl --get x
-> x:
-> owner@:rw::allow
-> group@:rw::allow
-> everyone@:r::allow
->
-
-$ nfs4acl --set 'everyone@:w::allow owner@:r::allow group@:r::allow' x
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> owner@:rw::allow
-> group@:rw::allow
->
-
-$ nfs4acl --set 'everyone@:w::deny owner@:rw::allow group@:rw::allow' x
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> owner@:r::allow
-> group@:r::allow
->
-
-$ nfs4acl --set 'owner@:rwmo::allow' x
-$ nfs4acl --get x
-> x:
-> owner@:rwmo::allow
->
-
-$ chmod 644 x
-$ nfs4acl --get x
-> x:
-> owner@:rw::allow
->
-
-$ nfs4acl --set 'root:rw::allow' x
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> root:rw::allow
->
-
-$ chmod 644 x
-$ nfs4acl --get x
-> x:
-> root:r::allow
->
-
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> root:rw::allow
->
-
-$ nfs4acl --set 'root:rw::allow everyone@:r::allow' x
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> root:rw::allow
-> everyone@:r::allow
->
-
-$ nfs4acl --set 'root:r::allow everyone@:rw::allow' x
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> root:rw::allow
-> owner@:rw::allow
-> group@:rw::allow
-> everyone@:r::allow
->
-
-$ nfs4acl --set 'root:w::deny everyone@:rw::allow' x
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> root:w::deny
-> owner@:rw::allow
-> group@:rw::allow
-> root:r::allow
-> everyone@:r::allow
->
-
-$ nfs4acl --set 'root:rw::allow root:w::deny everyone@:rw::allow' x
-$ chmod 664 x
-$ nfs4acl --get x
-> x:
-> root:rw::allow
-> root:w::deny
-> owner@:rw::allow
-> group@:rw::allow
-> everyone@:r::allow
->
-
-$ nfs4acl --set 'everyone@:rw::allow' x
-$ chmod 066 x
-$ nfs4acl --get x
-> x:
-> owner@:rw::deny
-> everyone@:rw::allow
-> 
-
-$ chmod 006 x
-$ nfs4acl --get x
-> x:
-> owner@:rw::deny
-> group@:rw::deny
-> everyone@:rw::allow
-> 
-
-$ chmod 606 x
-$ nfs4acl --get x
-> x:
-> group@:rw::deny
-> everyone@:rw::allow
-> 
-
-$ nfs4acl --set 'root:rw::allow everyone@:rw::allow' x
-$ chmod 606 x
-$ nfs4acl --get x
-> x:
-> group@:rw::deny
-> everyone@:rw::allow
-> 
-
-$ chmod 646 x
-$ nfs4acl --get x
-> x:
-> root:r::allow
-> group@:w::deny
-> root:w::deny
-> everyone@:rw::allow
-> 
-
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/basic.test b/nfs4acl/basic.test
deleted file mode 100644
index 1ae2896..0000000
--- a/nfs4acl/basic.test
+++ /dev/null
@@ -1,70 +0,0 @@
-$ rm -rf d
-$ mkdir d
-$ cd d
-
-$ chown bin .
-$ su bin
-
-$ touch x
-$ nfs4acl --set 'everyone@:rw::allow' x
-$ ls -l x | cut -d ' ' -f 1
-> -rw-rw-rw-
-
-$ nfs4acl --get x
-> x:
-> everyone@:rw::allow
->
-
-$ chmod 664 x
-$ ls -l x | cut -d ' ' -f 1
-> -rw-rw-r--
-
-$ nfs4acl --get x
-> x:
-> owner@:rw::allow
-> group@:rw::allow
-> everyone@:r::allow
->
-
-$ mkdir sub 
-$ nfs4acl --set 'everyone@:rwax:fd:allow' sub
-$ ls -dl sub | cut -d ' ' -f 1
-> drwxrwxrwx
-
-$ nfs4acl --get sub
-> sub:
-> everyone@:rwax:fd:allow
->
-
-$ chmod 775 sub
-$ ls -dl sub | cut -d ' ' -f 1
-> drwxrwxr-x
-$ nfs4acl --get sub
-> sub:
-> owner@:rwax::allow
-> group@:rwax::allow
-> everyone@:rwax:fdi:allow
-> everyone@:rx::allow
->
-
-$ touch sub/f
-$ ls -l sub/f | cut -d ' ' -f 1
-> -rw-rw-rw-
-
-$ nfs4acl --get sub/f
-> sub/f:
-> everyone@:rwa::allow
->
-
-$ mkdir sub/sub2
-$ ls -dl sub/sub2 | cut -d ' ' -f 1
-> drwxrwxrwx
-
-$ nfs4acl --get sub/sub2
-> sub/sub2:
-> everyone@:rwax:fd:allow
->
-
-$ su
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/chmod.test b/nfs4acl/chmod.test
deleted file mode 100644
index f4238b0..0000000
--- a/nfs4acl/chmod.test
+++ /dev/null
@@ -1,31 +0,0 @@
-$ mkdir d
-$ cd d
-
-$ whoami
-> root
-
-$ touch a
-	
-Neet to have write_acl permission to chmod or set the acl:
-	$ su bin
-	$ chmod 666 a
-	> chmod: changing permissions of `a': Operation not permitted
-	$ nfs4acl --set 'bin:rwM::allow' a
-	> a: Operation not permitted
-	
-$ su
-$ nfs4acl --set 'bin:rwm::allow' a
-	
-Can set the acl now:
-	$ su bin
-	$ nfs4acl --set 'bin:rwm::allow' a
-	
-A chmod limits the permissions to the specified mode, which always disables
-write_acl:
-	$ chmod 666 a
-	$ nfs4acl --set 'bin:rwm::allow' a
-	> a: Operation not permitted
-
-$ su
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/chown.test b/nfs4acl/chown.test
deleted file mode 100644
index df29bf4..0000000
--- a/nfs4acl/chown.test
+++ /dev/null
@@ -1,63 +0,0 @@
-$ mkdir d
-$ cd d
-
-$ whoami
-> root
-
-$ id -Gn daemon
-> daemon bin
-
-$ touch a
-
-Chown and chgrp with no take ownership permission fails:
-	$ su daemon
-	$ chown daemon a
-	> chown: changing ownership of `a': Operation not permitted
-	$ chgrp daemon a
-	> chgrp: changing group of `a': Operation not permitted
-	$ nfs4acl --set 'daemon:rwo::allow' a
-	> a: Operation not permitted
-
-Add the take_ownership permission. This is reflected in the file masks; the
-file mode cannot show this though:
-	$ su
-	$ nfs4acl --set 'daemon:rwo::allow' a
-
-Chown and chgrp to an arbitrary other user or group fails:
-	$ su daemon
-	$ chown root a
-	> chown: changing ownership of `a': Operation not permitted
-	$ chgrp root a
-	> chgrp: changing group of `a': Operation not permitted
-
-Changing the mode makes that an upper bound of the permissions granted, even
-when the file mode stays the same:
-	$ su
-	$ ls -l a | cut -d ' ' -f1
-	> -rw-rw----
-	$ chmod 660 a
-
-Chown and chgrp to the same user or a group the process is in now fails
-because the masks now do not grant change_ownership access:
-	$ su daemon
-	$ chown daemon a
-	> chown: changing ownership of `a': Operation not permitted
-	$ chgrp daemon a
-	> chgrp: changing group of `a': Operation not permitted
-	$ chgrp bin a
-	> chgrp: changing group of `a': Operation not permitted
-
-Add back change_ownership:
-	$ su
-	$ nfs4acl --set 'daemon:rwo::allow' a
-
-Now, chgrp to one of the groups the process is in and chown to the same user
-succeeds:
-	$ su daemon
-	$ chgrp daemon a
-	$ chgrp bin a
-	$ chown daemon a
-
-$ su
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/computed-mode.test b/nfs4acl/computed-mode.test
deleted file mode 100644
index baa68d6..0000000
--- a/nfs4acl/computed-mode.test
+++ /dev/null
@@ -1,62 +0,0 @@
-$ rm -rf d
-$ mkdir d
-$ cd d
-
-$ mkdir e
-
-$ nfs4acl --set 'owner@:rwx:f:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -rw-------
-$ rm e/f
-
-$ nfs4acl --set 'group@:rwx:f:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -rw-rw----
-$ rm e/f
-
-$ nfs4acl --set 'everyone@:rwx:f:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -rw-rw-rw-
-$ rm e/f
-
-$ nfs4acl --set 'owner@:rwx:f:allow root:rx:f:deny root:rx:f:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -rw-------
-$ rm e/f
-
-$ nfs4acl --set 'owner@:rwx::allow everyone@:w:fi:deny everyone@:rwx:fi:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -r--r--r--
-$ rm e/f
-
-$ nfs4acl --set 'owner@:rwx::allow root:rx:fi:deny root:rx:fi:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> ----------
-$ rm e/f
-
-$ nfs4acl --set 'owner@:rx:fi:allow group@:rwx:fi:deny everyone@:rwx:f:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -rw----rw-
-$ rm e/f
-
-$ nfs4acl --set 'owner@:rx:fi:allow root:rwx:fi:deny everyone@:rwx:f:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -rw-rw-rw-
-$ rm e/f
-
-$ nfs4acl --set 'everyone@:w:fi:deny root:rx:fi:allow everyone@:rwx:f:allow' e
-$ touch e/f
-$ ls -l e/f | cut -d ' ' -f 1
-> -r--r--r--
-$ rm e/f
-
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/create.test b/nfs4acl/create.test
deleted file mode 100644
index e140f4b..0000000
--- a/nfs4acl/create.test
+++ /dev/null
@@ -1,35 +0,0 @@
-$ mkdir d
-$ cd d
-
-$ whoami
-> root
-
-$ mkdir d1 d2 d3 d4
-$ nfs4acl --set 'daemon:wx::allow' d2
-$ nfs4acl --set 'daemon:ax::allow' d3
-$ nfs4acl --set 'daemon:wax::allow' d4
-
-$ su daemon
-
-Cannot create files or directories without permissions:
-	$ touch d1/f
-	> touch: cannot touch `d1/f': Permission denied
-	$ mkdir d1/d
-	> mkdir: cannot create directory `d1/d': Permission denied
-
-Can create files with add_file (w) permission:
-	$ touch d2/f
-	$ mkdir d2/d
-	> mkdir: cannot create directory `d2/d': Permission denied
-
-Can create directories with add_subdirectory (p) permission:
-	$ touch d3/f
-	> touch: cannot touch `d3/f': Permission denied
-	$ mkdir d3/d
-
-Both permissions at the same time:
-	$ touch d4/f
-	$ mkdir d4/d
-$ su
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/ctime.test b/nfs4acl/ctime.test
deleted file mode 100644
index 614d79b..0000000
--- a/nfs4acl/ctime.test
+++ /dev/null
@@ -1,36 +0,0 @@
-$ mkdir d
-$ cd d
-
-$ whoami
-> root
-
-$ touch a b
-$ sleep 1
-
-Without write access, the ctime cannot be changed.
-	$ su bin
-	$ touch a
-	> touch: cannot touch `a': Permission denied
-
-With write access, the ctime can be set to the current time, but not to
-any other time:
-	$ su
-	$ nfs4acl --set 'bin:rw::allow' a
-
-	$ su bin
-	$ touch a
-	$ [ b -ot a ] || echo 'b should be older than a'
-	$ touch -r b a
-	> touch: setting times of `a': Operation not permitted
-
-With set_attributes access, the ctime can be set to an arbitrary time:
-	$ su
-	$ nfs4acl --set 'bin:rwt::allow' a
-
-	$ su bin
-	$ touch -r b a
-	$ [ b -ot a -o a -ot b ] && echo 'a should be as old as b'
-
-$ su
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/delete.test b/nfs4acl/delete.test
deleted file mode 100644
index 9c5f24f..0000000
--- a/nfs4acl/delete.test
+++ /dev/null
@@ -1,77 +0,0 @@
-$ mkdir d
-$ cd d
-
-$ whoami
-> root
-
-$ id -Gn daemon
-> daemon bin
-
-$ mkdir n1
-$ touch n1/f
-
-$ mkdir d2 d3 d4 d5 d6 d7
-$ touch d2/f d3/f d4/f d5/f d6/f d7/f d7/g
-$ chown daemon d2
-$ chgrp bin d3
-$ chmod g+w d3
-$ nfs4acl --set 'daemon:wx::allow' d4
-$ nfs4acl --set 'daemon:d::allow' d5
-$ nfs4acl --set 'daemon:xd::allow' d6
-$ nfs4acl --set 'daemon:D::allow' d7/f d7/g
-$ chmod 664 d7/g
-
-$ mkdir s2 s3 s4 s5 s6 s7
-$ chmod +t s2 s3 s4 s5 s6 s7
-$ touch s2/f s3/f s4/f s5/f s6/f s7/f s7/g
-$ chown daemon s2
-$ chgrp bin s3
-$ chmod g+w s3
-$ nfs4acl --set 'daemon:wx::allow' s4
-$ nfs4acl --set 'daemon:d::allow' s5
-$ nfs4acl --set 'daemon:xd::allow' s6
-$ nfs4acl --set 'daemon:D::allow' s7/f
-$ nfs4acl --set 'daemon:D::allow' s7/g s7/g
-$ chmod 664 s7/g
-
-$ su daemon
-
-Cannot delete files without permissions:
-	$ rm n1/f
-	> rm: cannot remove `n1/f': Permission denied
-
-Can delete files we own:
-	$ rm d2/f s2/f
-
-Cannot delete files where we are in the owning group in a non-sticky directory,
-but not in a sticky one:
-	$ rm d3/f s3/f
-	> rm: cannot remove `s3/f': Operation not permitted
-
-"Write_data/execute" access does not include delete_child access, and so this
-is not enough for deleting:
-	$ rm d4/f s4/f
-	> rm: cannot remove `d4/f': Permission denied
-	> rm: cannot remove `s4/f': Permission denied
-
-"Delete_child" access alone also is not sufficient:
-	$ rm d5/f s5/f
-	> rm: cannot remove `d5/f': Permission denied
-	> rm: cannot remove `s5/f': Permission denied
-
-"Execute/delete_child" on the directory does allow that, though, but only in
-a non-sticky directory:
-	$ rm d6/f s6/f
-	> rm: cannot remove `s6/f': Operation not permitted
-
-"Delete" on the child itself overrides the sticky check as well:
-	$ rm d7/f s7/f
-
-But Delete is not a subset of POSIX read/write, so chmod turns it off:
-	$ rm d7/g s7/g
-	> rm: cannot remove `d7/g': Permission denied
-	> rm: cannot remove `s7/g': Permission denied
-
-$ su
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/run b/nfs4acl/run
deleted file mode 100755
index 360739e..0000000
--- a/nfs4acl/run
+++ /dev/null
@@ -1,298 +0,0 @@
-#!/usr/bin/perl -w -U
-
-#
-# Possible improvements:
-#
-# - distinguish stdout and stderr output
-# - add environment variable like assignments
-# - run up to a specific line
-# - resume at a specific line
-#
-
-use strict;
-use FileHandle;
-use Getopt::Std;
-use POSIX qw(isatty setuid getcwd);
-use vars qw($opt_l $opt_v);
-
-no warnings qw(taint);
-
-$opt_l = ~0;  # a really huge number
-getopts('l:v');
-
-my ($OK, $FAILED) = ("ok", "failed");
-if (isatty(fileno(STDOUT))) {
-	$OK = "\033[32m" . $OK . "\033[m";
-	$FAILED = "\033[31m\033[1m" . $FAILED . "\033[m";
-}
-
-sub exec_test($$);
-sub process_test($$$$);
-
-my ($prog, $in, $out) = ([], [], []);
-my $prog_line = 0;
-my ($tests, $failed) = (0,0);
-my $lineno;
-my $width = ($ENV{COLUMNS} || 80) >> 1;
-
-for (;;) {
-  my $line = <>; $lineno++;
-  if (defined $line) {
-    # Substitute %VAR and %{VAR} with environment variables.
-    $line =~ s[%(\w+)][$ENV{$1}]eg;
-    $line =~ s[%{(\w+)}][$ENV{$1}]eg;
-  }
-  if (defined $line) {
-    if ($line =~ s/^\s*< ?//) {
-      push @$in, $line;
-    } elsif ($line =~ s/^\s*> ?//) {
-      push @$out, $line;
-    } else {
-      process_test($prog, $prog_line, $in, $out);
-      last if $prog_line >= $opt_l;
-
-      $prog = [];
-      $prog_line = 0;
-    }
-    if ($line =~ s/^\s*\$ ?//) {
-      $line =~ s/\s+#.*//;  # remove comments here...
-      $prog = [ map { s/\\(.)/$1/g; $_ } split /(?<!\\)\s+/, $line ];
-      $prog_line = $lineno;
-      $in = [];
-      $out = [];
-    }
-  } else {
-    process_test($prog, $prog_line, $in, $out);
-    last;
-  }
-}
-
-my $status = sprintf("%d commands (%d passed, %d failed)",
-	$tests, $tests-$failed, $failed);
-if (isatty(fileno(STDOUT))) {
-	if ($failed) {
-		$status = "\033[31m\033[1m" . $status . "\033[m";
-	} else {
-		$status = "\033[32m" . $status . "\033[m";
-	}
-}
-print $status, "\n";
-exit $failed ? 1 : 0;
-
-
-sub process_test($$$$) {
-  my ($prog, $prog_line, $in, $out) = @_;
-
-  return unless @$prog;
-
-       my $p = [ @$prog ];
-       print "[$prog_line] \$ ", join(' ',
-             map { s/\s/\\$&/g; $_ } @$p), " -- ";
-       my $result = exec_test($prog, $in);
-       my @good = ();
-       my $nmax = (@$out > @$result) ? @$out : @$result;
-       for (my $n=0; $n < $nmax; $n++) {
-	   my $use_re;
-	   if (defined $out->[$n] && $out->[$n] =~ /^~ /) {
-		$use_re = 1;
-		$out->[$n] =~ s/^~ //g;
-	   }
-
-           if (!defined($out->[$n]) || !defined($result->[$n]) ||
-               (!$use_re && $result->[$n] ne $out->[$n]) ||
-               ( $use_re && $result->[$n] !~ /^$out->[$n]/)) {
-               push @good, ($use_re ? '!~' : '!=');
-	   }
-	   else {
-               push @good, ($use_re ? '=~' : '==');
-           }
-       }
-       my $good = !(grep /!/, @good);
-       $tests++;
-       $failed++ unless $good;
-       print $good ? $OK : $FAILED, "\n";
-       if (!$good || $opt_v) {
-         for (my $n=0; $n < $nmax; $n++) {
-	   my $l = defined($out->[$n]) ? $out->[$n] : "~";
-	   chomp $l;
-	   my $r = defined($result->[$n]) ? $result->[$n] : "~";
-	   chomp $r;
-	   print sprintf("%-" . ($width-3) . "s %s %s\n",
-			 $r, $good[$n], $l);
-         }
-       }
-}
-
-
-sub su($) {
-  my ($user) = @_;
-
-  $user ||= "root";
-
-  my ($login, $pass, $uid, $gid) = getpwnam($user)
-    or return [ "su: user $user does not exist\n" ];
-  my @groups = ();
-  my $fh = new FileHandle("/etc/group")
-    or return [ "opening /etc/group: $!\n" ];
-  while (<$fh>) {
-    chomp;
-    my ($group, $passwd, $gid, $users) = split /:/;
-    foreach my $u (split /,/, $users) {
-      push @groups, $gid
-	if ($user eq $u);
-    }
-  }
-  $fh->close;
-
-  my $groups = join(" ", ($gid, $gid, @groups));
-  #print STDERR "[[$groups]]\n";
-  $! = 0;  # reset errno
-  $> = 0;
-  $( = $gid;
-  $) = $groups;
-  if ($!) {
-    return [ "su: $!\n" ];
-  }
-  if ($uid != 0) {
-    $> = $uid;
-    #$< = $uid;
-    if ($!) {
-      return [ "su: $prog->[1]: $!\n" ];
-    }
-  }
-  #print STDERR "[($>,$<)($(,$))]";
-  return [];
-}
-
-
-sub sg($) {
-  my ($group) = @_;
-
-  my $gid = getgrnam($group)
-    or return [ "sg: group $group does not exist\n" ];
-  my %groups = map { $_ eq $gid ? () : ($_ => 1) } (split /\s/, $));
-  
-  #print STDERR "<<", join("/", keys %groups), ">>\n";
-  my $groups = join(" ", ($gid, $gid, keys %groups));
-  #print STDERR "[[$groups]]\n";
-  $! = 0;  # reset errno
-  if ($> != 0) {
-	  my $uid = $>;
-	  $> = 0;
-	  $( = $gid;
-	  $) = $groups;
-	  $> = $uid;
-  } else {
-	  $( = $gid;
-	  $) = $groups;
-  }
-  if ($!) {
-    return [ "sg: $!\n" ];
-  }
-  print STDERR "[($>,$<)($(,$))]";
-  return [];
-}
-
-
-sub exec_test($$) {
-  my ($prog, $in) = @_;
-  local (*IN, *IN_DUP, *IN2, *OUT_DUP, *OUT, *OUT2);
-  my $needs_shell = (join('', @$prog) =~ /[][|<>"'`\$\*\?]/);
-
-  if ($prog->[0] eq "umask") {
-    umask oct $prog->[1];
-    return [];
-  } elsif ($prog->[0] eq "cd") {
-    if (!chdir $prog->[1]) {
-      return [ "chdir: $prog->[1]: $!\n" ];
-    }
-    $ENV{PWD} = getcwd;
-    return [];
-  } elsif ($prog->[0] eq "su") {
-    return su($prog->[1]);
-  } elsif ($prog->[0] eq "sg") {
-    return sg($prog->[1]);
-  } elsif ($prog->[0] eq "export") {
-    my ($name, $value) = split /=/, $prog->[1];
-    # FIXME: need to evaluate $value, so that things like this will work:
-    # export dir=$PWD/dir
-    $ENV{$name} = $value;
-    return [];
-  } elsif ($prog->[0] eq "unset") {
-    delete $ENV{$prog->[1]};
-    return [];
-  }
-
-  pipe *IN2, *OUT
-    or die "Can't create pipe for reading: $!";
-  open *IN_DUP, "<&STDIN"
-    or *IN_DUP = undef;
-  open *STDIN, "<&IN2"
-    or die "Can't duplicate pipe for reading: $!";
-  close *IN2;
-
-  open *OUT_DUP, ">&STDOUT"
-    or die "Can't duplicate STDOUT: $!";
-  pipe *IN, *OUT2
-    or die "Can't create pipe for writing: $!";
-  open *STDOUT, ">&OUT2"
-    or die "Can't duplicate pipe for writing: $!";
-  close *OUT2;
-
-  *STDOUT->autoflush();
-  *OUT->autoflush();
-
-  if (fork()) {
-    # Server
-    if (*IN_DUP) {
-      open *STDIN, "<&IN_DUP"
-        or die "Can't duplicate STDIN: $!";
-      close *IN_DUP
-        or die "Can't close STDIN duplicate: $!";
-    }
-    open *STDOUT, ">&OUT_DUP"
-      or die "Can't duplicate STDOUT: $!";
-    close *OUT_DUP
-      or die "Can't close STDOUT duplicate: $!";
-
-    foreach my $line (@$in) {
-      #print "> $line";
-      print OUT $line;
-    }
-    close *OUT
-      or die "Can't close pipe for writing: $!";
-
-    my $result = [];
-    while (<IN>) {
-      #print "< $_";
-      if ($needs_shell) {
-	s#^/bin/sh: line \d+: ##;
-      }
-      push @$result, $_;
-    }
-    return $result;
-  } else {
-    # Client
-    $< = $>;
-    close IN
-      or die "Can't close read end for input pipe: $!";
-    close OUT
-      or die "Can't close write end for output pipe: $!";
-    close OUT_DUP
-      or die "Can't close STDOUT duplicate: $!";
-    local *ERR_DUP;
-    open ERR_DUP, ">&STDERR"
-      or die "Can't duplicate STDERR: $!";
-    open STDERR, ">&STDOUT"
-      or die "Can't join STDOUT and STDERR: $!";
-
-    if ($needs_shell) {
-      exec ('/bin/sh', '-c', join(" ", @$prog));
-    } else {
-      exec @$prog;
-    }
-    print STDERR $prog->[0], ": $!\n";
-    exit;
-  }
-}
-
diff --git a/nfs4acl/unrepresentable.test b/nfs4acl/unrepresentable.test
deleted file mode 100644
index 17fe5d4..0000000
--- a/nfs4acl/unrepresentable.test
+++ /dev/null
@@ -1,20 +0,0 @@
-Test cases for (acl, masks) pairs that cannot be represented as
-pure ACLs
-
-$ rm -rf d
-$ mkdir d
-$ cd d
-
-$ touch x
-
-$ nfs4acl --set 'group@:rw::allow' x
-$ chmod 600 x
-$ ls -l x | cut -d ' ' -f 1
-> -rw-------
-$ nfs4acl --get x
-> x:
->
-$ rm -f x
-
-$ cd ..
-$ rm -rf d
diff --git a/nfs4acl/write-vs-append.test b/nfs4acl/write-vs-append.test
deleted file mode 100644
index f1f940a..0000000
--- a/nfs4acl/write-vs-append.test
+++ /dev/null
@@ -1,46 +0,0 @@
-$ mkdir d
-$ cd d
-
-$ whoami
-> root
-
-$ touch a b c d e f
-$ nfs4acl --set 'owner@:*::allow' a
-$ nfs4acl --set 'owner@:*::allow bin:w::allow' b
-$ nfs4acl --set 'owner@:*::allow bin:a::allow' c
-$ nfs4acl --set 'owner@:*::allow bin:wa::allow' d
-$ nfs4acl --set 'bin:a::deny owner@:*::allow bin:w::allow' e
-$ nfs4acl --set 'bin:w::deny owner@:*::allow bin:a::allow' f
-
-$ su bin
-$ echo a > a
-> /bin/sh: a: Permission denied
-$ echo b > b
-$ echo c > c
-> /bin/sh: c: Permission denied
-$ echo d > d
-$ echo e > e
-$ echo f > f
-> /bin/sh: f: Permission denied
-
-$ echo A >> a
-> /bin/sh: a: Permission denied
-$ echo B >> b
-> /bin/sh: b: Permission denied
-$ echo C >> c
-$ echo D >> d
-$ echo E >> e
-> /bin/sh: e: Permission denied
-$ echo F >> f
-
-$ su
-$ cat a b c d e f
-> b
-> C
-> d
-> D
-> e
-> F
-
-$ cd ..
-$ rm -rf d
diff --git a/tests/xfs/191 b/tests/xfs/191
deleted file mode 100755
index e9aef20..0000000
--- a/tests/xfs/191
+++ /dev/null
@@ -1,75 +0,0 @@
-#!/bin/bash
-# FS QA Test No. 191
-#
-# To call into the nfs4acl qa suite of Andreas Gruenbacher.
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-
-# real QA test starts here
-
-# Modify as appropriate.
-_supported_fs xfs
-_supported_os Linux
-
-_require_scratch
-_scratch_mkfs_xfs -i nfs4acl 1>$tmp.mkfs 2>$seqres.full
-if [ $? -ne 0 ]
-then
-	_notrun "no mkfs support for NFS v4 ACLs"
-fi
-
-_scratch_mount 2>/dev/null
-if [ $? -ne 0 ]
-then
-	_notrun "no kernel mount support for NFS v4 ACLs"
-fi
-
-set_prog_path nfs4acl >>$seqres.full
-if [ $? -ne 0 ]
-then
-	_notrun "no nfs4acl utility found"
-fi
-
-cd $SCRATCH_MNT
-for file in $here/nfs4acl/*.test
-do
-	print_file=`echo $file | sed 's/.*nfs4acl/nfs4acl/'`
-	echo ""
-	echo "*** $print_file ***"
-	echo ""
-	$here/nfs4acl/run $file
-done
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/191.out b/tests/xfs/191.out
deleted file mode 100644
index 7a37ec8..0000000
--- a/tests/xfs/191.out
+++ /dev/null
@@ -1,324 +0,0 @@
-QA output created by 191
-
-*** nfs4acl/apply-mask.test ***
-
-[1] $ rm -rf d -- ok
-[2] $ mkdir d -- ok
-[3] $ cd d -- ok
-[5] $ touch x -- ok
-[7] $ nfs4acl --set 'owner@:rw::allow group@:rw::allow everyone@:r::allow' x -- ok
-[8] $ nfs4acl --get x -- ok
-[15] $ nfs4acl --set 'everyone@:w::allow owner@:r::allow group@:r::allow' x -- ok
-[16] $ chmod 664 x -- ok
-[17] $ nfs4acl --get x -- ok
-[23] $ nfs4acl --set 'everyone@:w::deny owner@:rw::allow group@:rw::allow' x -- ok
-[24] $ chmod 664 x -- ok
-[25] $ nfs4acl --get x -- ok
-[31] $ nfs4acl --set 'owner@:rwmo::allow' x -- ok
-[32] $ nfs4acl --get x -- ok
-[37] $ chmod 644 x -- ok
-[38] $ nfs4acl --get x -- ok
-[43] $ nfs4acl --set 'root:rw::allow' x -- ok
-[44] $ chmod 664 x -- ok
-[45] $ nfs4acl --get x -- ok
-[50] $ chmod 644 x -- ok
-[51] $ nfs4acl --get x -- ok
-[56] $ chmod 664 x -- ok
-[57] $ nfs4acl --get x -- ok
-[62] $ nfs4acl --set 'root:rw::allow everyone@:r::allow' x -- ok
-[63] $ chmod 664 x -- ok
-[64] $ nfs4acl --get x -- ok
-[70] $ nfs4acl --set 'root:r::allow everyone@:rw::allow' x -- ok
-[71] $ chmod 664 x -- ok
-[72] $ nfs4acl --get x -- ok
-[80] $ nfs4acl --set 'root:w::deny everyone@:rw::allow' x -- ok
-[81] $ chmod 664 x -- ok
-[82] $ nfs4acl --get x -- ok
-[91] $ nfs4acl --set 'root:rw::allow root:w::deny everyone@:rw::allow' x -- ok
-[92] $ chmod 664 x -- ok
-[93] $ nfs4acl --get x -- ok
-[102] $ nfs4acl --set 'everyone@:rw::allow' x -- ok
-[103] $ chmod 066 x -- ok
-[104] $ nfs4acl --get x -- ok
-[110] $ chmod 006 x -- ok
-[111] $ nfs4acl --get x -- ok
-[118] $ chmod 606 x -- ok
-[119] $ nfs4acl --get x -- ok
-[125] $ nfs4acl --set 'root:rw::allow everyone@:rw::allow' x -- ok
-[126] $ chmod 606 x -- ok
-[127] $ nfs4acl --get x -- ok
-[133] $ chmod 646 x -- ok
-[134] $ nfs4acl --get x -- ok
-[142] $ cd .. -- ok
-[143] $ rm -rf d -- ok
-49 commands (49 passed, 0 failed)
-
-*** nfs4acl/basic.test ***
-
-[1] $ rm -rf d -- ok
-[2] $ mkdir d -- ok
-[3] $ cd d -- ok
-[5] $ chown bin . -- ok
-[6] $ su bin -- ok
-[8] $ touch x -- ok
-[9] $ nfs4acl --set 'everyone@:rw::allow' x -- ok
-[10] $ ls -l x | cut -d ' ' -f 1 -- ok
-[13] $ nfs4acl --get x -- ok
-[18] $ chmod 664 x -- ok
-[19] $ ls -l x | cut -d ' ' -f 1 -- ok
-[22] $ nfs4acl --get x -- ok
-[29] $ mkdir sub -- ok
-[30] $ nfs4acl --set 'everyone@:rwax:fd:allow' sub -- ok
-[31] $ ls -dl sub | cut -d ' ' -f 1 -- ok
-[34] $ nfs4acl --get sub -- ok
-[39] $ chmod 775 sub -- ok
-[40] $ ls -dl sub | cut -d ' ' -f 1 -- ok
-[42] $ nfs4acl --get sub -- ok
-[50] $ touch sub/f -- ok
-[51] $ ls -l sub/f | cut -d ' ' -f 1 -- ok
-[54] $ nfs4acl --get sub/f -- ok
-[59] $ mkdir sub/sub2 -- ok
-[60] $ ls -dl sub/sub2 | cut -d ' ' -f 1 -- ok
-[63] $ nfs4acl --get sub/sub2 -- ok
-[68] $ su -- ok
-[69] $ cd .. -- ok
-[70] $ rm -rf d -- ok
-28 commands (28 passed, 0 failed)
-
-*** nfs4acl/chmod.test ***
-
-[1] $ mkdir d -- ok
-[2] $ cd d -- ok
-[4] $ whoami -- ok
-[7] $ touch a -- ok
-[10] $ su bin -- ok
-[11] $ chmod 666 a -- ok
-[13] $ nfs4acl --set 'bin:rwM::allow' a -- ok
-[16] $ su -- ok
-[17] $ nfs4acl --set 'bin:rwm::allow' a -- ok
-[20] $ su bin -- ok
-[21] $ nfs4acl --set 'bin:rwm::allow' a -- ok
-[25] $ chmod 666 a -- ok
-[26] $ nfs4acl --set 'bin:rwm::allow' a -- ok
-[29] $ su -- ok
-[30] $ cd .. -- ok
-[31] $ rm -rf d -- ok
-16 commands (16 passed, 0 failed)
-
-*** nfs4acl/chown.test ***
-
-[1] $ mkdir d -- ok
-[2] $ cd d -- ok
-[4] $ whoami -- ok
-[7] $ id -Gn daemon -- ok
-[10] $ touch a -- ok
-[13] $ su daemon -- ok
-[14] $ chown daemon a -- ok
-[16] $ chgrp daemon a -- ok
-[18] $ nfs4acl --set 'daemon:rwo::allow' a -- ok
-[23] $ su -- ok
-[24] $ nfs4acl --set 'daemon:rwo::allow' a -- ok
-[27] $ su daemon -- ok
-[28] $ chown root a -- ok
-[30] $ chgrp root a -- ok
-[35] $ su -- ok
-[36] $ ls -l a | cut -d ' ' -f1 -- ok
-[38] $ chmod 660 a -- ok
-[42] $ su daemon -- ok
-[43] $ chown daemon a -- ok
-[45] $ chgrp daemon a -- ok
-[47] $ chgrp bin a -- ok
-[51] $ su -- ok
-[52] $ nfs4acl --set 'daemon:rwo::allow' a -- ok
-[56] $ su daemon -- ok
-[57] $ chgrp daemon a -- ok
-[58] $ chgrp bin a -- ok
-[59] $ chown daemon a -- ok
-[61] $ su -- ok
-[62] $ cd .. -- ok
-[63] $ rm -rf d -- ok
-30 commands (30 passed, 0 failed)
-
-*** nfs4acl/computed-mode.test ***
-
-[1] $ rm -rf d -- ok
-[2] $ mkdir d -- ok
-[3] $ cd d -- ok
-[5] $ mkdir e -- ok
-[7] $ nfs4acl --set 'owner@:rwx:f:allow' e -- ok
-[8] $ touch e/f -- ok
-[9] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[11] $ rm e/f -- ok
-[13] $ nfs4acl --set 'group@:rwx:f:allow' e -- ok
-[14] $ touch e/f -- ok
-[15] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[17] $ rm e/f -- ok
-[19] $ nfs4acl --set 'everyone@:rwx:f:allow' e -- ok
-[20] $ touch e/f -- ok
-[21] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[23] $ rm e/f -- ok
-[25] $ nfs4acl --set 'owner@:rwx:f:allow root:rx:f:deny root:rx:f:allow' e -- ok
-[26] $ touch e/f -- ok
-[27] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[29] $ rm e/f -- ok
-[31] $ nfs4acl --set 'owner@:rwx::allow everyone@:w:fi:deny everyone@:rwx:fi:allow' e -- ok
-[32] $ touch e/f -- ok
-[33] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[35] $ rm e/f -- ok
-[37] $ nfs4acl --set 'owner@:rwx::allow root:rx:fi:deny root:rx:fi:allow' e -- ok
-[38] $ touch e/f -- ok
-[39] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[41] $ rm e/f -- ok
-[43] $ nfs4acl --set 'owner@:rx:fi:allow group@:rwx:fi:deny everyone@:rwx:f:allow' e -- ok
-[44] $ touch e/f -- ok
-[45] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[47] $ rm e/f -- ok
-[49] $ nfs4acl --set 'owner@:rx:fi:allow root:rwx:fi:deny everyone@:rwx:f:allow' e -- ok
-[50] $ touch e/f -- ok
-[51] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[53] $ rm e/f -- ok
-[55] $ nfs4acl --set 'everyone@:w:fi:deny root:rx:fi:allow everyone@:rwx:f:allow' e -- ok
-[56] $ touch e/f -- ok
-[57] $ ls -l e/f | cut -d ' ' -f 1 -- ok
-[59] $ rm e/f -- ok
-[61] $ cd .. -- ok
-[62] $ rm -rf d -- ok
-42 commands (42 passed, 0 failed)
-
-*** nfs4acl/create.test ***
-
-[1] $ mkdir d -- ok
-[2] $ cd d -- ok
-[4] $ whoami -- ok
-[7] $ mkdir d1 d2 d3 d4 -- ok
-[8] $ nfs4acl --set 'daemon:wx::allow' d2 -- ok
-[9] $ nfs4acl --set 'daemon:ax::allow' d3 -- ok
-[10] $ nfs4acl --set 'daemon:wax::allow' d4 -- ok
-[12] $ su daemon -- ok
-[15] $ touch d1/f -- ok
-[17] $ mkdir d1/d -- ok
-[21] $ touch d2/f -- ok
-[22] $ mkdir d2/d -- ok
-[26] $ touch d3/f -- ok
-[28] $ mkdir d3/d -- ok
-[31] $ touch d4/f -- ok
-[32] $ mkdir d4/d -- ok
-[33] $ su -- ok
-[34] $ cd .. -- ok
-[35] $ rm -rf d -- ok
-19 commands (19 passed, 0 failed)
-
-*** nfs4acl/ctime.test ***
-
-[1] $ mkdir d -- ok
-[2] $ cd d -- ok
-[4] $ whoami -- ok
-[7] $ touch a b -- ok
-[8] $ sleep 1 -- ok
-[11] $ su bin -- ok
-[12] $ touch a -- ok
-[17] $ su -- ok
-[18] $ nfs4acl --set 'bin:rw::allow' a -- ok
-[20] $ su bin -- ok
-[21] $ touch a -- ok
-[22] $ [ b -ot a ] || echo 'b should be older than a' -- ok
-[23] $ touch -r b a -- ok
-[27] $ su -- ok
-[28] $ nfs4acl --set 'bin:rwt::allow' a -- ok
-[30] $ su bin -- ok
-[31] $ touch -r b a -- ok
-[32] $ [ b -ot a -o a -ot b ] && echo 'a should be as old as b' -- ok
-[34] $ su -- ok
-[35] $ cd .. -- ok
-[36] $ rm -rf d -- ok
-21 commands (21 passed, 0 failed)
-
-*** nfs4acl/delete.test ***
-
-[1] $ mkdir d -- ok
-[2] $ cd d -- ok
-[4] $ whoami -- ok
-[7] $ id -Gn daemon -- ok
-[10] $ mkdir n1 -- ok
-[11] $ touch n1/f -- ok
-[13] $ mkdir d2 d3 d4 d5 d6 d7 -- ok
-[14] $ touch d2/f d3/f d4/f d5/f d6/f d7/f d7/g -- ok
-[15] $ chown daemon d2 -- ok
-[16] $ chgrp bin d3 -- ok
-[17] $ chmod g+w d3 -- ok
-[18] $ nfs4acl --set 'daemon:wx::allow' d4 -- ok
-[19] $ nfs4acl --set 'daemon:d::allow' d5 -- ok
-[20] $ nfs4acl --set 'daemon:xd::allow' d6 -- ok
-[21] $ nfs4acl --set 'daemon:D::allow' d7/f d7/g -- ok
-[22] $ chmod 664 d7/g -- ok
-[24] $ mkdir s2 s3 s4 s5 s6 s7 -- ok
-[25] $ chmod +t s2 s3 s4 s5 s6 s7 -- ok
-[26] $ touch s2/f s3/f s4/f s5/f s6/f s7/f s7/g -- ok
-[27] $ chown daemon s2 -- ok
-[28] $ chgrp bin s3 -- ok
-[29] $ chmod g+w s3 -- ok
-[30] $ nfs4acl --set 'daemon:wx::allow' s4 -- ok
-[31] $ nfs4acl --set 'daemon:d::allow' s5 -- ok
-[32] $ nfs4acl --set 'daemon:xd::allow' s6 -- ok
-[33] $ nfs4acl --set 'daemon:D::allow' s7/f -- ok
-[34] $ nfs4acl --set 'daemon:D::allow' s7/g s7/g -- ok
-[35] $ chmod 664 s7/g -- ok
-[37] $ su daemon -- ok
-[40] $ rm n1/f -- ok
-[44] $ rm d2/f s2/f -- ok
-[48] $ rm d3/f s3/f -- ok
-[53] $ rm d4/f s4/f -- ok
-[58] $ rm d5/f s5/f -- ok
-[64] $ rm d6/f s6/f -- ok
-[68] $ rm d7/f s7/f -- ok
-[71] $ rm d7/g s7/g -- ok
-[75] $ su -- ok
-[76] $ cd .. -- ok
-[77] $ rm -rf d -- ok
-40 commands (40 passed, 0 failed)
-
-*** nfs4acl/unrepresentable.test ***
-
-[4] $ rm -rf d -- ok
-[5] $ mkdir d -- ok
-[6] $ cd d -- ok
-[8] $ touch x -- ok
-[10] $ nfs4acl --set 'group@:rw::allow' x -- ok
-[11] $ chmod 600 x -- ok
-[12] $ ls -l x | cut -d ' ' -f 1 -- ok
-[14] $ nfs4acl --get x -- ok
-[17] $ rm -f x -- ok
-[19] $ cd .. -- ok
-[20] $ rm -rf d -- ok
-11 commands (11 passed, 0 failed)
-
-*** nfs4acl/write-vs-append.test ***
-
-[1] $ mkdir d -- ok
-[2] $ cd d -- ok
-[4] $ whoami -- ok
-[7] $ touch a b c d e f -- ok
-[8] $ nfs4acl --set 'owner@:*::allow' a -- ok
-[9] $ nfs4acl --set 'owner@:*::allow bin:w::allow' b -- ok
-[10] $ nfs4acl --set 'owner@:*::allow bin:a::allow' c -- ok
-[11] $ nfs4acl --set 'owner@:*::allow bin:wa::allow' d -- ok
-[12] $ nfs4acl --set 'bin:a::deny owner@:*::allow bin:w::allow' e -- ok
-[13] $ nfs4acl --set 'bin:w::deny owner@:*::allow bin:a::allow' f -- ok
-[15] $ su bin -- ok
-[16] $ echo a > a -- ok
-[18] $ echo b > b -- ok
-[19] $ echo c > c -- ok
-[21] $ echo d > d -- ok
-[22] $ echo e > e -- ok
-[23] $ echo f > f -- ok
-[26] $ echo A >> a -- ok
-[28] $ echo B >> b -- ok
-[30] $ echo C >> c -- ok
-[31] $ echo D >> d -- ok
-[32] $ echo E >> e -- ok
-[34] $ echo F >> f -- ok
-[36] $ su -- ok
-[37] $ cat a b c d e f -- ok
-[45] $ cd .. -- ok
-[46] $ rm -rf d -- ok
-27 commands (27 passed, 0 failed)
diff --git a/tests/xfs/group b/tests/xfs/group
index 9884329..4a67df1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -176,7 +176,6 @@
 188 ci dir auto
 189 mount auto quick
 190 rw auto quick
-191 nfs4acl auto
 194 rw auto
 195 ioctl dump auto quick
 196 quota auto quick
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
