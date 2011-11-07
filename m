Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7HMNM0068717 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 11:22:23 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2] xfstests: add 059 and 060 for multi-stream xfsdump
Date: Mon,  7 Nov 2011 11:22:16 -0600
Message-Id: <1320686536-1399-1-git-send-email-wkendall@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Implement the multi-stream placeholder tests 059 and 060. The comments
imply that these tests existed on IRIX, but I was unable to find them.

Test 059 does a simple 4-way dump and restore. Test 060 does a 4-way
dump, then restores each dump file individually (in a cumulative
fashion).

The tests are skipped if the installed xfsdump does not support
multi-stream output.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
Changed for v2:
  - Included the expected-output files.

 059         |   23 +++++++----
 059.out     |   76 +++++++++++++++++++++++++++++++++++++
 060         |   29 ++++++++++----
 060.out     |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.dump |   40 +++++++++++++++++++-
 group       |    4 +-
 6 files changed, 270 insertions(+), 22 deletions(-)
 create mode 100644 059.out
 create mode 100644 060.out

diff --git a/059 b/059
index 6348f0e..1f3f8e3 100755
--- a/059
+++ b/059
@@ -1,10 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 059
 #
-# place holder for IRIX 059 test for xfsdump/xfsrestore multi streams
+# Test multi-stream xfsdump/xfsrestore.
 #
 #-----------------------------------------------------------------------
-# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2000-2001, 2011 SGI.  All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
@@ -22,26 +22,31 @@
 #-----------------------------------------------------------------------
 #
 # creator
-owner=ivanr@sgi.com
+owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
-status=1	# failure is the default!
+status=0	# success is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
-. ./common.filter
-
-_notrun "Place holder for IRIX test 059"
+. ./common.dump
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX
+_supported_os Linux
+
+_require_multi_stream
+
+_create_dumpdir_fill_multi
+_do_dump_multi_file --multi 4
+_do_restore_multi_file --multi 4
+_ls_compare_sub
+_diff_compare
 
 # success, all done
-status=0
 exit
diff --git a/059.out b/059.out
new file mode 100644
index 0000000..7d670e1
--- /dev/null
+++ b/059.out
@@ -0,0 +1,76 @@
+QA output created by 059
+Creating directory system to dump using src/fill.
+Setup .......................................
+Dumping to files...
+xfsdump   -f DUMP_FILE.0 -M stress_tape_media.0 -f DUMP_FILE.1 -M stress_tape_media.1 -f DUMP_FILE.2 -M stress_tape_media.2 -f DUMP_FILE.3 -M stress_tape_media.3 -L stress_059 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_059"
+xfsdump: ino map <PHASES>
+xfsdump: stream 0: ino INO offset NUM to ino INO offset NUM
+xfsdump: stream 1: ino INO offset NUM to ino INO offset NUM
+xfsdump: stream 2: ino INO offset NUM to ino INO offset NUM
+xfsdump: stream 3: ino INO offset NUM to end
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: estimated dump size per stream: NUM bytes
+xfsdump: /var/xfsdump/inventory created
+xfsdump: dump size (non-dir files) : NUM bytes
+xfsdump: dump complete: SECS seconds elapsed
+xfsdump: Dump Status: SUCCESS
+Restoring from file...
+xfsrestore   -f DUMP_FILE.0 -f DUMP_FILE.1 -f DUMP_FILE.2 -f DUMP_FILE.3 -L stress_059 RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+Comparing listing of dump directory with restore directory
+Files TMP.dump_dir and TMP.restore_dir are identical
+Comparing dump directory with restore directory
+Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical
+Files DUMP_DIR/large000 and RESTORE_DIR/DUMP_SUBDIR/large000 are identical
+Files DUMP_DIR/large111 and RESTORE_DIR/DUMP_SUBDIR/large111 are identical
+Files DUMP_DIR/large222 and RESTORE_DIR/DUMP_SUBDIR/large222 are identical
+Files DUMP_DIR/small and RESTORE_DIR/DUMP_SUBDIR/small are identical
+Files DUMP_DIR/sub/a and RESTORE_DIR/DUMP_SUBDIR/sub/a are identical
+Files DUMP_DIR/sub/a00 and RESTORE_DIR/DUMP_SUBDIR/sub/a00 are identical
+Files DUMP_DIR/sub/a000 and RESTORE_DIR/DUMP_SUBDIR/sub/a000 are identical
+Files DUMP_DIR/sub/b and RESTORE_DIR/DUMP_SUBDIR/sub/b are identical
+Files DUMP_DIR/sub/b00 and RESTORE_DIR/DUMP_SUBDIR/sub/b00 are identical
+Files DUMP_DIR/sub/big and RESTORE_DIR/DUMP_SUBDIR/sub/big are identical
+Files DUMP_DIR/sub/c and RESTORE_DIR/DUMP_SUBDIR/sub/c are identical
+Files DUMP_DIR/sub/c00 and RESTORE_DIR/DUMP_SUBDIR/sub/c00 are identical
+Files DUMP_DIR/sub/d and RESTORE_DIR/DUMP_SUBDIR/sub/d are identical
+Files DUMP_DIR/sub/d00 and RESTORE_DIR/DUMP_SUBDIR/sub/d00 are identical
+Files DUMP_DIR/sub/e and RESTORE_DIR/DUMP_SUBDIR/sub/e are identical
+Files DUMP_DIR/sub/e00 and RESTORE_DIR/DUMP_SUBDIR/sub/e00 are identical
+Files DUMP_DIR/sub/e000 and RESTORE_DIR/DUMP_SUBDIR/sub/e000 are identical
+Files DUMP_DIR/sub/f and RESTORE_DIR/DUMP_SUBDIR/sub/f are identical
+Files DUMP_DIR/sub/f00 and RESTORE_DIR/DUMP_SUBDIR/sub/f00 are identical
+Files DUMP_DIR/sub/g and RESTORE_DIR/DUMP_SUBDIR/sub/g are identical
+Files DUMP_DIR/sub/g00 and RESTORE_DIR/DUMP_SUBDIR/sub/g00 are identical
+Files DUMP_DIR/sub/h and RESTORE_DIR/DUMP_SUBDIR/sub/h are identical
+Files DUMP_DIR/sub/h00 and RESTORE_DIR/DUMP_SUBDIR/sub/h00 are identical
+Files DUMP_DIR/sub/h000 and RESTORE_DIR/DUMP_SUBDIR/sub/h000 are identical
+Files DUMP_DIR/sub/i and RESTORE_DIR/DUMP_SUBDIR/sub/i are identical
+Files DUMP_DIR/sub/i00 and RESTORE_DIR/DUMP_SUBDIR/sub/i00 are identical
+Files DUMP_DIR/sub/j and RESTORE_DIR/DUMP_SUBDIR/sub/j are identical
+Files DUMP_DIR/sub/j00 and RESTORE_DIR/DUMP_SUBDIR/sub/j00 are identical
+Files DUMP_DIR/sub/k and RESTORE_DIR/DUMP_SUBDIR/sub/k are identical
+Files DUMP_DIR/sub/k00 and RESTORE_DIR/DUMP_SUBDIR/sub/k00 are identical
+Files DUMP_DIR/sub/k000 and RESTORE_DIR/DUMP_SUBDIR/sub/k000 are identical
+Files DUMP_DIR/sub/l and RESTORE_DIR/DUMP_SUBDIR/sub/l are identical
+Files DUMP_DIR/sub/l00 and RESTORE_DIR/DUMP_SUBDIR/sub/l00 are identical
+Files DUMP_DIR/sub/m and RESTORE_DIR/DUMP_SUBDIR/sub/m are identical
+Files DUMP_DIR/sub/m00 and RESTORE_DIR/DUMP_SUBDIR/sub/m00 are identical
+Files DUMP_DIR/sub/n and RESTORE_DIR/DUMP_SUBDIR/sub/n are identical
+Files DUMP_DIR/sub/n00 and RESTORE_DIR/DUMP_SUBDIR/sub/n00 are identical
+Files DUMP_DIR/sub/small and RESTORE_DIR/DUMP_SUBDIR/sub/small are identical
+Only in SCRATCH_MNT: RESTORE_SUBDIR
diff --git a/060 b/060
index 6e58e5b..4adc00f 100755
--- a/060
+++ b/060
@@ -1,10 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 060
 #
-# place holder for IRIX 060 test for xfsdump/xfsrestore multi streams
+# Test multi-stream xfsdump and restoring one stream at a time.
 #
 #-----------------------------------------------------------------------
-# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2000-2001, 2011 SGI.  All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
@@ -22,26 +22,37 @@
 #-----------------------------------------------------------------------
 #
 # creator
-owner=ivanr@sgi.com
+owner=wkendall@sgi.com
 
 seq=`basename $0`
 echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
-status=1	# failure is the default!
+status=0	# success is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
-. ./common.filter
-
-_notrun "Place holder for IRIX test 060"
+. ./common.dump
 
 # real QA test starts here
 _supported_fs xfs
-_supported_os IRIX
+_supported_os Linux
+
+_require_multi_stream
+
+_create_dumpdir_fill_multi
+_do_dump_multi_file --multi 4
+_prepare_restore_dir
+base=$dump_file
+opts=""
+for x in 0 1 2 3; do
+    _do_restore_file_cum -f $base.$x $opts
+    opts=-R
+done
+_ls_compare_sub
+_diff_compare
 
 # success, all done
-status=0
 exit
diff --git a/060.out b/060.out
new file mode 100644
index 0000000..29a1c5e
--- /dev/null
+++ b/060.out
@@ -0,0 +1,120 @@
+QA output created by 060
+Creating directory system to dump using src/fill.
+Setup .......................................
+Dumping to files...
+xfsdump   -f DUMP_FILE.0 -M stress_tape_media.0 -f DUMP_FILE.1 -M stress_tape_media.1 -f DUMP_FILE.2 -M stress_tape_media.2 -f DUMP_FILE.3 -M stress_tape_media.3 -L stress_060 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_060"
+xfsdump: ino map <PHASES>
+xfsdump: stream 0: ino INO offset NUM to ino INO offset NUM
+xfsdump: stream 1: ino INO offset NUM to ino INO offset NUM
+xfsdump: stream 2: ino INO offset NUM to ino INO offset NUM
+xfsdump: stream 3: ino INO offset NUM to end
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: estimated dump size per stream: NUM bytes
+xfsdump: /var/xfsdump/inventory created
+xfsdump: dump size (non-dir files) : NUM bytes
+xfsdump: dump complete: SECS seconds elapsed
+xfsdump: Dump Status: SUCCESS
+Restoring cumumlative from file...
+xfsrestore  -f DUMP_FILE -r RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: searching media for dump
+xfsrestore: examining media file 0
+xfsrestore: dump description: 
+xfsrestore: hostname: HOSTNAME
+xfsrestore: mount point: SCRATCH_MNT
+xfsrestore: volume: SCRATCH_DEV
+xfsrestore: session time: TIME
+xfsrestore: level: 0
+xfsrestore: session label: "stress_060"
+xfsrestore: media label: "stress_tape_media.0"
+xfsrestore: file system ID: ID
+xfsrestore: session id: ID
+xfsrestore: media ID: ID
+xfsrestore: using online session inventory
+xfsrestore: searching media for directory dump
+xfsrestore: reading directories
+xfsrestore: 3 directories and 41 entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: NOTE: restore interrupted: SECS seconds elapsed: may resume later using -R option
+xfsrestore: Restore Status: INCOMPLETE
+Restoring cumumlative from file...
+xfsrestore  -R -f DUMP_FILE -r RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: resuming restore previously begun DATE
+xfsrestore: examining media file 0
+xfsrestore: seeking past media file directory dump
+xfsrestore: restoring non-directory files
+xfsrestore: NOTE: restore interrupted: SECS seconds elapsed: may resume later using -R option
+xfsrestore: Restore Status: INCOMPLETE
+Restoring cumumlative from file...
+xfsrestore  -R -f DUMP_FILE -r RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: resuming restore previously begun DATE
+xfsrestore: examining media file 0
+xfsrestore: seeking past media file directory dump
+xfsrestore: restoring non-directory files
+xfsrestore: NOTE: restore interrupted: SECS seconds elapsed: may resume later using -R option
+xfsrestore: Restore Status: INCOMPLETE
+Restoring cumumlative from file...
+xfsrestore  -R -f DUMP_FILE -r RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: resuming restore previously begun DATE
+xfsrestore: examining media file 0
+xfsrestore: seeking past media file directory dump
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+Comparing listing of dump directory with restore directory
+Files TMP.dump_dir and TMP.restore_dir are identical
+Comparing dump directory with restore directory
+Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical
+Files DUMP_DIR/large000 and RESTORE_DIR/DUMP_SUBDIR/large000 are identical
+Files DUMP_DIR/large111 and RESTORE_DIR/DUMP_SUBDIR/large111 are identical
+Files DUMP_DIR/large222 and RESTORE_DIR/DUMP_SUBDIR/large222 are identical
+Files DUMP_DIR/small and RESTORE_DIR/DUMP_SUBDIR/small are identical
+Files DUMP_DIR/sub/a and RESTORE_DIR/DUMP_SUBDIR/sub/a are identical
+Files DUMP_DIR/sub/a00 and RESTORE_DIR/DUMP_SUBDIR/sub/a00 are identical
+Files DUMP_DIR/sub/a000 and RESTORE_DIR/DUMP_SUBDIR/sub/a000 are identical
+Files DUMP_DIR/sub/b and RESTORE_DIR/DUMP_SUBDIR/sub/b are identical
+Files DUMP_DIR/sub/b00 and RESTORE_DIR/DUMP_SUBDIR/sub/b00 are identical
+Files DUMP_DIR/sub/big and RESTORE_DIR/DUMP_SUBDIR/sub/big are identical
+Files DUMP_DIR/sub/c and RESTORE_DIR/DUMP_SUBDIR/sub/c are identical
+Files DUMP_DIR/sub/c00 and RESTORE_DIR/DUMP_SUBDIR/sub/c00 are identical
+Files DUMP_DIR/sub/d and RESTORE_DIR/DUMP_SUBDIR/sub/d are identical
+Files DUMP_DIR/sub/d00 and RESTORE_DIR/DUMP_SUBDIR/sub/d00 are identical
+Files DUMP_DIR/sub/e and RESTORE_DIR/DUMP_SUBDIR/sub/e are identical
+Files DUMP_DIR/sub/e00 and RESTORE_DIR/DUMP_SUBDIR/sub/e00 are identical
+Files DUMP_DIR/sub/e000 and RESTORE_DIR/DUMP_SUBDIR/sub/e000 are identical
+Files DUMP_DIR/sub/f and RESTORE_DIR/DUMP_SUBDIR/sub/f are identical
+Files DUMP_DIR/sub/f00 and RESTORE_DIR/DUMP_SUBDIR/sub/f00 are identical
+Files DUMP_DIR/sub/g and RESTORE_DIR/DUMP_SUBDIR/sub/g are identical
+Files DUMP_DIR/sub/g00 and RESTORE_DIR/DUMP_SUBDIR/sub/g00 are identical
+Files DUMP_DIR/sub/h and RESTORE_DIR/DUMP_SUBDIR/sub/h are identical
+Files DUMP_DIR/sub/h00 and RESTORE_DIR/DUMP_SUBDIR/sub/h00 are identical
+Files DUMP_DIR/sub/h000 and RESTORE_DIR/DUMP_SUBDIR/sub/h000 are identical
+Files DUMP_DIR/sub/i and RESTORE_DIR/DUMP_SUBDIR/sub/i are identical
+Files DUMP_DIR/sub/i00 and RESTORE_DIR/DUMP_SUBDIR/sub/i00 are identical
+Files DUMP_DIR/sub/j and RESTORE_DIR/DUMP_SUBDIR/sub/j are identical
+Files DUMP_DIR/sub/j00 and RESTORE_DIR/DUMP_SUBDIR/sub/j00 are identical
+Files DUMP_DIR/sub/k and RESTORE_DIR/DUMP_SUBDIR/sub/k are identical
+Files DUMP_DIR/sub/k00 and RESTORE_DIR/DUMP_SUBDIR/sub/k00 are identical
+Files DUMP_DIR/sub/k000 and RESTORE_DIR/DUMP_SUBDIR/sub/k000 are identical
+Files DUMP_DIR/sub/l and RESTORE_DIR/DUMP_SUBDIR/sub/l are identical
+Files DUMP_DIR/sub/l00 and RESTORE_DIR/DUMP_SUBDIR/sub/l00 are identical
+Files DUMP_DIR/sub/m and RESTORE_DIR/DUMP_SUBDIR/sub/m are identical
+Files DUMP_DIR/sub/m00 and RESTORE_DIR/DUMP_SUBDIR/sub/m00 are identical
+Files DUMP_DIR/sub/n and RESTORE_DIR/DUMP_SUBDIR/sub/n are identical
+Files DUMP_DIR/sub/n00 and RESTORE_DIR/DUMP_SUBDIR/sub/n00 are identical
+Files DUMP_DIR/sub/small and RESTORE_DIR/DUMP_SUBDIR/sub/small are identical
+Only in SCRATCH_MNT: RESTORE_SUBDIR
+Only in RESTORE_DIR: xfsrestorehousekeepingdir
diff --git a/common.dump b/common.dump
index 076517d..31a75c5 100644
--- a/common.dump
+++ b/common.dump
@@ -75,6 +75,14 @@ done
 have_mtvariable=false
 [ `uname` = "Linux" ] && have_mtvariable=true
 
+
+_require_multi_stream()
+{
+    $XFSDUMP_PROG -JF -f /dev/null -f /dev/null 2> /dev/null |
+    grep -q "too many -f arguments" &&
+    _notrun "xfsdump multi-stream support required"
+}
+
 #
 # do a remote/local mt
 #
@@ -536,6 +544,18 @@ _do_create_dumpdir_fill()
     cd $here
 }
 
+_mk_fillconfig_multi()
+{
+    _mk_fillconfig1
+    cat <<End-of-File >>$tmp.config
+# pathname	size in bytes
+#
+large000	8874368	$nobody	$nobody
+large111	2582912	$nobody	$nobody
+large222	7825792	$nobody	$nobody
+End-of-File
+}
+
 _create_dumpdir_largefile()
 {
     _wipe_fs
@@ -580,6 +600,17 @@ _create_dumpdir_fill_ea()
     _stable_fs
 }
 
+#
+# Create enough files, and a few large enough files, so that
+# some files are likely to be split across streams.
+#
+_create_dumpdir_fill_multi()
+{
+    _wipe_fs
+    _mk_fillconfig_multi
+    _do_create_dumpdir_fill
+    _stable_fs
+}
 
 #
 # Append a subset of the fill'ed files
@@ -802,9 +833,11 @@ _dump_filter_main()
       -e 's/time:[ 	].*/time: TIME/'		\
       -e 's/date:[ 	].*/date: DATE/'		\
       -e 's/dump begun .*/dump begun DATE/'		\
+      -e 's/previously begun .*/previously begun DATE/'	\
       -e 's/[0-9][0-9]* seconds/SECS seconds/'		\
       -e 's/restore.[0-9][0-9]*/restore.PID/'		\
-      -e 's/ino [0-9][0-9]*/ino INO/'			\
+      -e 's/ino [0-9][0-9]*/ino INO/g'			\
+      -e '/stream [0-9]:/s/offset [0-9][0-9]*/offset NUM/g'	\
       -e '/: dump size/s/[0-9][0-9]*/NUM/'		\
       -e '/dump size:/s/[0-9][0-9]*/NUM/'		\
       -e '/dump size per stream:/s/[0-9][0-9]*/NUM/'	\
@@ -862,7 +895,7 @@ _invutil_filter()
 _dir_filter()
 {
   sed \
-    -e "s#$dump_file#DUMP_FILE#"      \
+    -e "s#$dump_file#DUMP_FILE#g"      \
     -e "s#$SCRATCH_DEV#SCRATCH_DEV#"        \
     -e "s#$SCRATCH_RAWDEV#SCRATCH_DEV#"    \
     -e "s#$dumptape#TAPE_DEV#"         \
@@ -959,6 +992,9 @@ _parse_restore_args()
         --no-check-quota)
             do_quota_check=false
             ;;
+	-R)
+	    restore_args="$restore_args $1"
+            ;;
 	*)
             _fail "invalid argument to common.dump function: $1"
             ;;
diff --git a/group b/group
index 616cbdd..79b8c8c 100644
--- a/group
+++ b/group
@@ -169,8 +169,8 @@ deprecated
 056 dump ioctl auto quick
 057 acl auto
 058 acl auto
-059 dump ioctl
-060 dump ioctl
+059 dump ioctl auto quick
+060 dump ioctl auto quick
 061 dump ioctl auto quick
 062 attr udf auto quick
 063 dump attr auto quick
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
