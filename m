Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SKADjp183258 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 15:10:13 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: add tests 281-283 for old xfsdump format
Date: Wed, 28 Mar 2012 15:09:40 -0500
Message-Id: <1332965380-30070-1-git-send-email-wkendall@sgi.com>
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

Add three tests for verifying compatibility with xfsdump format 2.

Test 281 generates a format 2 dump and restores it.

Test 282 does a restore of a level 0 dump in the old dump format
followed by a restore of a level 1 dump in the current dump format.

Test 283 does a restore of a level 0 dump in the current dump format
followed by a restore of a level 1 dump in the old dump format.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 281         |   59 ++++++++++++++++++++++++++
 281.out     |   77 ++++++++++++++++++++++++++++++++++
 282         |   71 +++++++++++++++++++++++++++++++
 282.out     |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 283         |   74 +++++++++++++++++++++++++++++++++
 283.out     |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.dump |   15 ++++++-
 group       |    3 +
 8 files changed, 563 insertions(+), 2 deletions(-)
 create mode 100755 281
 create mode 100644 281.out
 create mode 100755 282
 create mode 100644 282.out
 create mode 100755 283
 create mode 100644 283.out

diff --git a/281 b/281
new file mode 100755
index 0000000..137f69f
--- /dev/null
+++ b/281
@@ -0,0 +1,59 @@
+#! /bin/bash
+# FS QA Test No. 281
+#
+# Test that xfsdump can generate a format 2 dump.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 SGI.  All Rights Reserved.
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
+#
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
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.dump
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_legacy_v2_format
+
+_create_dumpdir_fill
+
+echo "*** Dump using format 2"
+_do_dump_file -K
+
+echo "*** Verify it's a format 2 dump"
+file $dump_file | cut -d: -f 2
+
+echo "*** Restoring format 2 dump"
+_do_restore_file
+_diff_compare
+
+# success, all done
+status=0
+exit
diff --git a/281.out b/281.out
new file mode 100644
index 0000000..97caa4e
--- /dev/null
+++ b/281.out
@@ -0,0 +1,77 @@
+QA output created by 281
+Creating directory system to dump using src/fill.
+Setup ....................................
+*** Dump using format 2
+Dumping to file...
+xfsdump  -K -f DUMP_FILE -M stress_tape_media -L stress_281 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_281"
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
+*** Verify it's a format 2 dump
+ xfsdump archive (version 2)
+*** Restoring format 2 dump
+Restoring from file...
+xfsrestore  -f DUMP_FILE  -L stress_281 RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: using online session inventory
+xfsrestore: searching media for directory dump
+xfsrestore: examining media file 0
+xfsrestore: reading directories
+xfsrestore: 3 directories and 38 entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+Comparing dump directory with restore directory
+Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical
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
diff --git a/282 b/282
new file mode 100755
index 0000000..024bad8
--- /dev/null
+++ b/282
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. 282
+#
+# Test incremental dumps containing a mix of dump formats.
+# level 0 - format 2
+# level 1 - current format
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 SGI.  All Rights Reserved.
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
+#
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
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.dump
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_legacy_v2_format
+
+_create_dumpdir_fill
+# ensure file/dir timestamps precede dump timestamp
+sleep 2
+src/bstat $SCRATCH_MNT >>$here/$seq.full
+
+echo "*** Level 0 dump, format 2"
+_do_dump_file -f $tmp.l0 -K
+
+_append_dumpdir_fill
+src/bstat $SCRATCH_MNT >>$here/$seq.full
+
+echo "*** Level 1 dump, current format"
+_do_dump_file -l 1 -f $tmp.l1
+
+echo "*** Restore using format 2 level 0"
+_prepare_restore_dir
+_do_restore_file_cum -f $tmp.l0
+
+echo "*** Restore using current format level 1"
+_do_restore_file_cum -f $tmp.l1
+_diff_compare
+
+# success, all done
+status=0
+exit
diff --git a/282.out b/282.out
new file mode 100644
index 0000000..dacbda6
--- /dev/null
+++ b/282.out
@@ -0,0 +1,133 @@
+QA output created by 282
+Creating directory system to dump using src/fill.
+Setup ....................................
+*** Level 0 dump, format 2
+Dumping to file...
+xfsdump  -K -f DUMP_FILE -M stress_tape_media -L stress_282 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_282"
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
+*** Level 1 dump, current format
+Dumping to file...
+xfsdump  -l1 -f DUMP_FILE -M stress_tape_media -L stress_282 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 1 incremental dump of HOSTNAME:SCRATCH_MNT based on level 0 dump begun DATE
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_282"
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
+*** Restore using format 2 level 0
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
+xfsrestore: session label: "stress_282"
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
+*** Restore using current format level 1
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
+xfsrestore: session label: "stress_282"
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
+Comparing dump directory with restore directory
+Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical
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
diff --git a/283 b/283
new file mode 100755
index 0000000..27251bb
--- /dev/null
+++ b/283
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 283
+#
+# Test incremental dumps containing a mix of dump formats.
+# level 0 - current format
+# level 1 - format 2
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 SGI.  All Rights Reserved.
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
+#
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
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.dump
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_legacy_v2_format
+
+_create_dumpdir_fill
+# ensure file/dir timestamps precede dump timestamp
+sleep 2
+src/bstat $SCRATCH_MNT >>$here/$seq.full
+
+echo "*** Level 0 dump, current format"
+_do_dump_file -f $tmp.l0
+
+_append_dumpdir_fill
+src/bstat $SCRATCH_MNT >>$here/$seq.full
+
+echo "*** Level 1 dump, format 2"
+_do_dump_file -l 1 -f $tmp.l1 -K
+
+# note the first restore has to be told to use format
+# 2 generation numbers due to the unusual case of
+# having a new-format dump followed by an old-format.
+echo "*** Restore using current format level 0"
+_prepare_restore_dir
+_do_restore_file_cum -f $tmp.l0 -K
+
+echo "*** Restore using format 2 level 1"
+_do_restore_file_cum -f $tmp.l1
+_diff_compare
+
+# success, all done
+status=0
+exit
diff --git a/283.out b/283.out
new file mode 100644
index 0000000..3aaa50b
--- /dev/null
+++ b/283.out
@@ -0,0 +1,133 @@
+QA output created by 283
+Creating directory system to dump using src/fill.
+Setup ....................................
+*** Level 0 dump, current format
+Dumping to file...
+xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_283 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_283"
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
+*** Level 1 dump, format 2
+Dumping to file...
+xfsdump  -l1 -K -f DUMP_FILE -M stress_tape_media -L stress_283 SCRATCH_MNT
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 1 incremental dump of HOSTNAME:SCRATCH_MNT based on level 0 dump begun DATE
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_283"
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
+*** Restore using current format level 0
+Restoring cumumlative from file...
+xfsrestore  -K -f DUMP_FILE -r RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: searching media for dump
+xfsrestore: examining media file 0
+xfsrestore: dump description: 
+xfsrestore: hostname: HOSTNAME
+xfsrestore: mount point: SCRATCH_MNT
+xfsrestore: volume: SCRATCH_DEV
+xfsrestore: session time: TIME
+xfsrestore: level: 0
+xfsrestore: session label: "stress_283"
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
+*** Restore using format 2 level 1
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
+xfsrestore: session label: "stress_283"
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
+Comparing dump directory with restore directory
+Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical
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
index 493a5f7..ca09ec1 100644
--- a/common.dump
+++ b/common.dump
@@ -83,6 +83,17 @@ _require_multi_stream()
     _notrun "xfsdump multi-stream support required"
 }
 
+_require_legacy_v2_format()
+{
+    $XFSDUMP_PROG 2>&1 |
+    grep -q "generate format 2 dump" ||
+    _notrun "xfsdump -K option required"
+
+    $XFSRESTORE_PROG 2>&1 |
+    grep -q "force use of format 2 generation" ||
+    _notrun "xfsrestore -K option required"
+}
+
 #
 # do a remote/local mt
 #
@@ -942,7 +953,7 @@ _parse_dump_args()
         --no-check-quota)
             do_quota_check=false
             ;;
-	-o|-D|-F)
+	-o|-D|-F|-K)
 	    dump_args="$dump_args $1"
             ;;
         -l|-d)
@@ -992,7 +1003,7 @@ _parse_restore_args()
         --no-check-quota)
             do_quota_check=false
             ;;
-	-R)
+	-K|-R)
 	    restore_args="$restore_args $1"
             ;;
 	*)
diff --git a/group b/group
index 01f406d..a909301 100644
--- a/group
+++ b/group
@@ -394,3 +394,6 @@ deprecated
 278 repair auto
 279 auto mkfs
 280 auto quota
+281 dump ioctl auto quick
+282 dump ioctl auto quick
+283 dump ioctl auto quick
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
