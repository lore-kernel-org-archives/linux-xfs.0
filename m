Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3CEXE3007653 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 07:14:33 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: add 059 and 060 for multi-stream xfsdump
Date: Thu,  3 Nov 2011 07:14:24 -0500
Message-Id: <1320322464-6559-1-git-send-email-wkendall@sgi.com>
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
 059         |   23 ++++++++++++++---------
 060         |   29 ++++++++++++++++++++---------
 common.dump |   40 ++++++++++++++++++++++++++++++++++++++--
 group       |    4 ++--
 4 files changed, 74 insertions(+), 22 deletions(-)

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
index 8a23320..efeb977 100644
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
