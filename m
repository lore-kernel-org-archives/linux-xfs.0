Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9VF3sJP042523 for <xfs@oss.sgi.com>; Mon, 31 Oct 2011 10:03:54 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: add 265 and 266 for multiple media files
Date: Mon, 31 Oct 2011 10:03:49 -0500
Message-Id: <1320073429-27865-1-git-send-email-wkendall@sgi.com>
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

This patch adds a couple of tests for xfsdump when multiple media files
are used. 265 tests the case where a file is split across multiple media
files, and 266 tests the case where a file ends on one media file and
the next media file starts on another file. These tests use a small
media file size (xfsdump -d) so that they don't rely on having to hit
end-of-tape.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 265         |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 266         |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 266.out     |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.dump |    6 ++--
 group       |    2 +
 6 files changed, 332 insertions(+), 3 deletions(-)
 create mode 100755 265
 create mode 100644 265.out
 create mode 100755 266
 create mode 100644 266.out

diff --git a/265 b/265
new file mode 100755
index 0000000..65d773e
--- /dev/null
+++ b/265
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test No. 265
+#
+# Test xfsdump with a file spanning multiple media files.
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
+# create a 40 MiB file with an extended attr.
+# xfsdump writes file data in "extent groups", currently 16 MiB in size. After
+# writing an extent group or finishing a file, xfsdump will start a new media
+# file if it is over the suggested size. With a single 40 MiB file and using a
+# suggested media file size of 12 MiB below, this dump will be contained in 3
+# media files.
+#
+_create_files()
+{
+    cat <<End-of-File >$tmp.config
+# pathname	size            user    group    perm   name value namespace
+biggg		41943040	$nobody	$nobody  777    attr1 some_text1  root
+End-of-File
+
+    _wipe_fs
+    _do_create_dumpdir_fill
+    _stable_fs
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.dump
+. ./common.attr
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_tape $TAPE_DEV
+_require_attrs
+
+_create_files
+_erase_hard
+_do_dump -d 12
+_do_restore
+_ls_compare_sub
+_diff_compare
+_diff_compare_eas
+
+# success, all done
+exit
diff --git a/265.out b/265.out
new file mode 100644
index 0000000..863d6e6
--- /dev/null
+++ b/265.out
@@ -0,0 +1,88 @@
+QA output created by 265
+Put scsi tape driver into variable block size mode
+Creating directory system to dump using src/fill.
+Setup Attribute "attr1" set to a 10 byte value for biggg:
+some_text1
+.
+Erasing tape
+Dumping to tape...
+xfsdump  -d12 -f TAPE_DEV -M stress_tape_media -L stress_265 SCRATCH_MNT
+xfsdump: using scsi tape (drive_scsitape) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_265"
+xfsdump: ino map <PHASES>
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: /var/xfsdump/inventory created
+xfsdump: preparing drive
+xfsdump: creating dump session media file 0 (media 0, file 0)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: creating dump session media file 1 (media 0, file 1)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: creating dump session media file 2 (media 0, file 2)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: dumping session inventory
+xfsdump: beginning inventory media file
+xfsdump: media file 3 (media 0, file 3)
+xfsdump: ending inventory media file
+xfsdump: inventory media file size NUM bytes
+xfsdump: writing stream terminator
+xfsdump: beginning media stream terminator
+xfsdump: media file 4 (media 0, file 4)
+xfsdump: ending media stream terminator
+xfsdump: media stream terminator size BLOCKSZ bytes
+xfsdump: dump size (non-dir files) : NUM bytes
+xfsdump: dump complete: SECS seconds elapsed
+xfsdump: Dump Status: SUCCESS
+Rewinding tape
+Restoring from tape...
+xfsrestore  -f TAPE_DEV  -L stress_265 RESTORE_DIR
+xfsrestore: using scsi tape (drive_scsitape) strategy
+xfsrestore: using online session inventory
+xfsrestore: searching media for directory dump
+xfsrestore: preparing drive
+xfsrestore: examining media file 0
+xfsrestore: reading directories
+xfsrestore: 2 directories and 2 entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: examining media file 1
+xfsrestore: seeking past media file directory dump
+xfsrestore: restoring non-directory files
+xfsrestore: examining media file 2
+xfsrestore: seeking past media file directory dump
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+Comparing listing of dump directory with restore directory
+Files TMP.dump_dir and TMP.restore_dir are identical
+Comparing dump directory with restore directory
+Files DUMP_DIR/biggg and RESTORE_DIR/DUMP_SUBDIR/biggg are identical
+Only in SCRATCH_MNT: RESTORE_SUBDIR
+Comparing dump directory with restore directory
+Looking at the extended attributes (EAs)
+EAs on dump
+User names
+Root names
+Attribute "attr1" had a 10 byte value for DUMP_DIR/biggg:
+some_text1
+EAs on restore
+User names
+Root names
+Attribute "attr1" had a 10 byte value for DUMP_DIR/biggg:
+some_text1
+Files 265.ea1 and 265.ea2 are identical
diff --git a/266 b/266
new file mode 100755
index 0000000..46e40c4
--- /dev/null
+++ b/266
@@ -0,0 +1,78 @@
+#! /bin/bash
+# FS QA Test No. 266
+#
+# Test xfsdump with multiple media files where a file ends
+# at the end of the first media file (i.e., no file is split
+# across media files).
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
+# create two 12 MiB files with extended attrs.
+# xfsdump writes file data in "extent groups", currently 16 MiB in size. After
+# writing an extent group or finishing a file, xfsdump will start a new media
+# file if it is over the suggested size. A media file size of 8 MiB is used
+# below, so after dumping a 12 MiB file xfsdump will start a new media file and
+# no file will be split across a media file.
+#
+_create_files()
+{
+    cat <<End-of-File >$tmp.config
+# pathname	size            user    group    perm   name value namespace
+bigg1		12582912	$nobody	$nobody  777    attr1 some_text1  root
+bigg2		12582912	$nobody	$nobody  777    attr2 some_text2  user
+End-of-File
+
+    _wipe_fs
+    _do_create_dumpdir_fill
+    _stable_fs
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.dump
+. ./common.attr
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_tape $TAPE_DEV
+_require_attrs
+
+_create_files
+_erase_hard
+_do_dump -d 8
+_do_restore
+_ls_compare_sub
+_diff_compare
+_diff_compare_eas
+
+# success, all done
+exit
diff --git a/266.out b/266.out
new file mode 100644
index 0000000..853dc96
--- /dev/null
+++ b/266.out
@@ -0,0 +1,86 @@
+QA output created by 266
+Put scsi tape driver into variable block size mode
+Creating directory system to dump using src/fill.
+Setup Attribute "attr1" set to a 10 byte value for bigg1:
+some_text1
+.Attribute "attr2" set to a 10 byte value for bigg2:
+some_text2
+.
+Erasing tape
+Dumping to tape...
+xfsdump  -d8 -f TAPE_DEV -M stress_tape_media -L stress_266 SCRATCH_MNT
+xfsdump: using scsi tape (drive_scsitape) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: "stress_266"
+xfsdump: ino map <PHASES>
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: /var/xfsdump/inventory created
+xfsdump: preparing drive
+xfsdump: creating dump session media file 0 (media 0, file 0)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: creating dump session media file 1 (media 0, file 1)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: dumping session inventory
+xfsdump: beginning inventory media file
+xfsdump: media file 2 (media 0, file 2)
+xfsdump: ending inventory media file
+xfsdump: inventory media file size NUM bytes
+xfsdump: writing stream terminator
+xfsdump: beginning media stream terminator
+xfsdump: media file 3 (media 0, file 3)
+xfsdump: ending media stream terminator
+xfsdump: media stream terminator size BLOCKSZ bytes
+xfsdump: dump size (non-dir files) : NUM bytes
+xfsdump: dump complete: SECS seconds elapsed
+xfsdump: Dump Status: SUCCESS
+Rewinding tape
+Restoring from tape...
+xfsrestore  -f TAPE_DEV  -L stress_266 RESTORE_DIR
+xfsrestore: using scsi tape (drive_scsitape) strategy
+xfsrestore: using online session inventory
+xfsrestore: searching media for directory dump
+xfsrestore: preparing drive
+xfsrestore: examining media file 0
+xfsrestore: reading directories
+xfsrestore: 2 directories and 3 entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: examining media file 1
+xfsrestore: seeking past media file directory dump
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+Comparing listing of dump directory with restore directory
+Files TMP.dump_dir and TMP.restore_dir are identical
+Comparing dump directory with restore directory
+Files DUMP_DIR/bigg1 and RESTORE_DIR/DUMP_SUBDIR/bigg1 are identical
+Files DUMP_DIR/bigg2 and RESTORE_DIR/DUMP_SUBDIR/bigg2 are identical
+Only in SCRATCH_MNT: RESTORE_SUBDIR
+Comparing dump directory with restore directory
+Looking at the extended attributes (EAs)
+EAs on dump
+User names
+Attribute "attr2" had a 10 byte value for DUMP_DIR/bigg2:
+some_text2
+Root names
+Attribute "attr1" had a 10 byte value for DUMP_DIR/bigg1:
+some_text1
+EAs on restore
+User names
+Attribute "attr2" had a 10 byte value for DUMP_DIR/bigg2:
+some_text2
+Root names
+Attribute "attr1" had a 10 byte value for DUMP_DIR/bigg1:
+some_text1
+Files 266.ea1 and 266.ea2 are identical
diff --git a/common.dump b/common.dump
index d9e6565..3942e83 100644
--- a/common.dump
+++ b/common.dump
@@ -909,9 +909,9 @@ _parse_args()
         -Q)
             do_quota_check=false
             ;;
-        -l)
-            [ -z "$2" ] && _fail "missing argument for -l"
-	    dump_args="$dump_args -l$2"
+        -l|-d)
+            [ -z "$2" ] && _fail "missing argument for $1"
+	    dump_args="$dump_args $1$2"
 	    shift
             ;;
 	*)
diff --git a/group b/group
index 70ea462..8a23320 100644
--- a/group
+++ b/group
@@ -378,3 +378,5 @@ deprecated
 262 auto quick quota
 263 rw auto quick
 264 dump ioctl auto quick
+265 dump ioctl tape
+266 dump ioctl tape
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
