Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754573AbdDEMth (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 08:49:37 -0400
Subject: [PATCH 3/4] xfstests: Partially expand the documentation [ver #6]
From: David Howells <dhowells@redhat.com>
Date: Wed, 05 Apr 2017 13:49:35 +0100
Message-ID: <149139657522.12368.11999050309508445957.stgit@warthog.procyon.org.uk>
In-Reply-To: <149139655968.12368.18434671350530288572.stgit@warthog.procyon.org.uk>
References: <149139655968.12368.18434671350530288572.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org

Partially expand the documentation available in xfstests to include
requirements checking and auxiliary programs for testing.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---

 doc/auxiliary-programs.txt   |   56 +++++++++++++++++++++++++++++++
 doc/requirement-checking.txt |   77 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)
 create mode 100644 doc/auxiliary-programs.txt
 create mode 100644 doc/requirement-checking.txt

diff --git a/doc/auxiliary-programs.txt b/doc/auxiliary-programs.txt
new file mode 100644
index 0000000..17797b0
--- /dev/null
+++ b/doc/auxiliary-programs.txt
@@ -0,0 +1,56 @@
+			==============================
+			AUXILIARY PROGRAMS FOR TESTING
+			==============================
+
+Not everything a test script can do is easily done within a test script;
+sometimes it makes a lot more sense to write auxiliary program in C and have
+the test script call them.  Auxiliary commands can be found in the src/
+directory and in other packages.
+
+Tests wanting to use an auxiliary program found in the src/ directory should
+note the dependency with:
+
+	_require_test_program "<program-name>"
+
+
+Contents:
+
+ - af_unix	-- Create an AF_UNIX socket
+ - stat_test	-- statx syscall exercise
+ - xfs_io	-- General I/O operation exercise
+
+
+==================
+QUICK DESCRIPTIONS
+==================
+
+af_unix
+
+	The af_unix program creates an AF_UNIX socket at the given location.
+
+stat_test
+
+	The stat_test program is primarily designed to exercise the statx()
+	system call.  It can check statx() against fstatat() and it can
+	compare and check various file attributes.
+
+	See also:
+		_require_statx
+
+
+xfs_io
+
+	The xfs_io program can be found in the xfsprogs package and can be used
+	to perform sequences of I/O commands, though it is limited to what it
+	can do on open files.
+
+	xfs_io is a debugging tool that is aimed at examining regular file I/O
+	paths rather than a raw XFS volume itself.  These code paths include
+	not only the obvious read/write/mmap interfaces for manipulating files,
+	but also cover all of the XFS extensions (such as space preallocation,
+	additional inode flags, etc).
+
+	Most of its commands can also be used with other filesystems.
+
+	See also:
+		_require_xfs_io_command
diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
new file mode 100644
index 0000000..f3fc9f4
--- /dev/null
+++ b/doc/requirement-checking.txt
@@ -0,0 +1,77 @@
+		   ========================================
+		   TESTING FOR REQUIREMENTS IN TEST SCRIPTS
+		   ========================================
+
+Test scripts need to indicate to the infrastructure what sorts of requirements
+they have.  This is done with _require_<xxx> macros, which may take parameters.
+
+ (1) General requirements.
+
+	_require_command "$<NAME_PROG>" <name>
+	_require_test
+	_require_test_program <name>
+	_require_xfs_io_command <name> [<switch>]
+
+ (2) System call requirements.
+
+	_require_statx
+
+
+====================
+GENERAL REQUIREMENTS
+====================
+
+_require_command "$NAME_PROG" name
+
+     The test requires an external command, called 'name' be present on the
+     system and that '$VAR' should be set with the path to that command.  $VAR
+     should then be used to refer to the command when executing it.  For
+     example:
+
+	_require_command "KILLALL_PROG" killall
+
+     to locate the killall command and then:
+
+	$KILLALL_PROG -q $FSSTRESS_PROG
+
+     to make use of it.
+
+
+_require_test
+
+     The test requires that the block device specified by $TEST_DEV be mounted
+     on $TEST_DIR.
+
+
+_require_test_program <name>
+
+     The test requires a program by the name of 'name' be present and built in
+     the src/ directory.  For example:
+
+	_require_test_program "stat_test"
+
+     requires that src/stat_test be built.
+
+
+_require_xfs_io_command <name> [<switch>]
+
+     The test requires that the xfs_io command be available, that it supports
+     command <name> and, optionally, that that command supports the specified
+     switch.  For example:
+
+	_require_xfs_io_command "falloc"
+	_require_xfs_io_command "chattr" "+/-x"
+
+     The first requires that xfs_io support the falloc command and the second
+     that it supports the chattr command and that the chattr command supports
+     the +x and -x arguments (DAX attribute).
+
+
+========================
+SYSTEM CALL REQUIREMENTS
+========================
+
+_require_statx
+
+     The test requires the use of the statx() system call and will be skipped
+     if it isn't available in the kernel.

