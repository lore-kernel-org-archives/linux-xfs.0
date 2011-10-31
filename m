Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9VF27qm042465 for <xfs@oss.sgi.com>; Mon, 31 Oct 2011 10:02:07 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: add test 264 for testing xfsdump -D
Date: Mon, 31 Oct 2011 10:02:01 -0500
Message-Id: <1320073321-27662-1-git-send-email-wkendall@sgi.com>
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

Add a test for xfsdump -D, which skips unchanged directories during
an incremental backup. After doing an initial backup, a new file is
added to one directory (to verify that changed directories are
backed up) and several files are appended to. Then an incremental
backup is done with -D set. The test verifies the original and
restored filesystems match after applying the base and incremental
backups, and that the incremental restore output indicates that only
the one changed directory was backed up.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 264         |   74 +++++++++++++++++++++++++++++++++
 264.out     |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.dump |    7 +--
 group       |    1 +
 4 files changed, 210 insertions(+), 5 deletions(-)
 create mode 100755 264
 create mode 100644 264.out

diff --git a/264 b/264
new file mode 100755
index 0000000..9544a58
--- /dev/null
+++ b/264
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 264
+#
+# Test incremental dumps with -D (skip unchanged dirs)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 SGI.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+# creator
+owner=wkendall@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+#
+# Add a new file and append a subset of the fill'ed files
+# So we can see if just these get dumped on an incremental
+#
+_add_and_append_dumpdir_fill()
+{
+    cd $dump_dir
+    echo 'New file' >> newfile
+    _append_dumpdir_fill
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.dump
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+$XFSDUMP_PROG -h 2>&1 | grep -q -e -D
+if [ $? -ne 0 ]; then
+    _notrun "requires xfsdump -D"
+fi
+
+_create_dumpdir_fill
+# ensure file/dir timestamps precede dump timestamp
+sleep 2
+dump_file=$tmp.df.0
+_do_dump_file
+_add_and_append_dumpdir_fill
+dump_file=$tmp.df.1
+_do_dump_file -l 1 -D
+dump_file=$tmp.df.0
+_do_restore_file_cum -l 0
+dump_file=$tmp.df.1
+_do_restore_file_cum -l 1
+_ls_compare_sub
+_diff_compare
+
+# success, all done
+exit
diff --git a/264.out b/264.out
new file mode 100644
index 0000000..b2c3c09
--- /dev/null
+++ b/264.out
@@ -0,0 +1,133 @@
+QA output created by 264
+Creating directory system to dump using src/fill.
+Setup ....................................
+Dumping to file...
+xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_264 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_264"
+xfsdump: ino map <PHASES>
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: /var/xfsdump/inventory created
+xfsdump: creating dump session media file 0 (media 0, file 0)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: dump size (non-dir files) : NUM bytes
+xfsdump: dump complete: SECS seconds elapsed
+xfsdump: Dump Status: SUCCESS
+Dumping to file...
+xfsdump  -l1 -D -f DUMP_FILE -M stress_tape_media -L stress_264 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 1 incremental dump of HOSTNAME:SCRATCH_MNT based on level 0 dump begun DATE
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_264"
+xfsdump: ino map <PHASES>
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: creating dump session media file 0 (media 0, file 0)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
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
+xfsrestore: session label: "stress_264"
+xfsrestore: media label: "stress_tape_media"
+xfsrestore: file system ID: ID
+xfsrestore: session id: ID
+xfsrestore: media ID: ID
+xfsrestore: using online session inventory
+xfsrestore: searching media for directory dump
+xfsrestore: reading directories
+xfsrestore: 3 directories and 38 entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
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
+xfsrestore: level: 1
+xfsrestore: session label: "stress_264"
+xfsrestore: media label: "stress_tape_media"
+xfsrestore: file system ID: ID
+xfsrestore: session id: ID
+xfsrestore: media ID: ID
+xfsrestore: using online session inventory
+xfsrestore: searching media for directory dump
+xfsrestore: reading directories
+xfsrestore: NOTE: dump is not self-contained, orphaned files expected if base dump(s) was not applied
+xfsrestore: 1 directories and 4 entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+Comparing listing of dump directory with restore directory
+Files TMP.dump_dir and TMP.restore_dir are identical
+Comparing dump directory with restore directory
+Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical
+Files DUMP_DIR/newfile and RESTORE_DIR/DUMP_SUBDIR/newfile are identical
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
index c1eb675..d9e6565 100644
--- a/common.dump
+++ b/common.dump
@@ -896,11 +896,8 @@ _parse_args()
 	    session_label=$2
 	    shift
             ;;
-	-o)
-	    dump_args="$dump_args -o"
-            ;;
-	-F)
-	    dump_args="$dump_args -F"
+	-o|-D|-F)
+	    dump_args="$dump_args $1"
             ;;
 	--multi)
 	    multi=$2
diff --git a/group b/group
index 2a8970c..70ea462 100644
--- a/group
+++ b/group
@@ -377,3 +377,4 @@ deprecated
 261 auto quick quota
 262 auto quick quota
 263 rw auto quick
+264 dump ioctl auto quick
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
