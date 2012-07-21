Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6L3kdew184809 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 22:46:39 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 8sz2rVbA52cZfwbI for
	<xfs@oss.sgi.com>; Fri, 20 Jul 2012 20:46:36 -0700 (PDT)
Message-ID: <500A25F8.9070005@cn.fujitsu.com>
Date: Sat, 21 Jul 2012 11:46:00 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] Xfstests: add btrfs snapshot function test
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>

From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

This patch adds btrfs snapshot function test to xfstests.

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
---
 285     |  365 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 285.out |    2 +
 group   |    1 +
 3 files changed, 368 insertions(+), 0 deletions(-)
 create mode 100755 285
 create mode 100644 285.out

diff --git a/285 b/285
new file mode 100755
index 0000000..d247af3
--- /dev/null
+++ b/285
@@ -0,0 +1,365 @@
+#! /bin/bash
+# FS QA Test No. 285
+#
+# Test btrfs's subvolume and snapshot function
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Fujitsu.  All Rights Reserved.
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
+owner=zhoub-fnst@cn.fujitsu.com
+
+n=0
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs_sized `expr 1024 \* 1024 \* 1024` > /dev/null 2>&1
+_scratch_mount
+
+_prepare_snapshot()
+{
+	_scratch_remount > /dev/null
+	btrfs sub snap $SCRATCH_MNT $SCRATCH_MNT/basesnapshot > /dev/null 2>>$here/$seq.full
+	btrfs sub snap -r $SCRATCH_MNT $SCRATCH_MNT/readonlysnapshot > /dev/null 2>>$here/$seq.full
+	_scratch_unmount > /dev/null 2>>$here/$seq.full
+	VALID_SUBVOLUME="basesnapshot"
+	VALID_RO_SUBVOLUME="readonlysnapshot"
+	SNAPSHOTSTR="snapshot"
+	FILE1="file1-"
+	FILE2="file2-"
+	MVFILE2="newfile2-"
+	DIR1="dir1-"
+	DIR2="dir2-"
+	MVDIR2="newdir2-"
+	MVSNAPSHOT="mvsnapshot-"
+	SRCSUBVOL="srcsubvol-"
+}
+
+_parse_options()
+{
+	SOURCE_TARGET="$1"
+	case $SOURCE_TARGET in
+		"1")
+			SOURCE_SUBVOLUME="$VALID_SUBVOLUME"
+			;;
+	esac
+	SOURCE_READ="$2"
+	case $SOURCE_READ in
+		"1")
+			SOURCE_SUBVOLUME="$VALID_RO_SUBVOLUME"
+			;;
+	esac
+	DESTINATION_TARGET="$3"
+	case $DESTINATION_TARGET in
+		"1")
+			DESTINATION_SUBVOLUME=$SNAPSHOTSTR$n
+			;;
+	esac
+	DESTINATION_READ="$4"
+	case $DESTINATION_READ in
+		"1")
+			SNAPSHOTOPT_STR="-r"
+			;;
+		"2")
+			SNAPSHOTOPT_STR=""
+			;;
+	esac
+	MOUNT_OPT="$5"
+	case $MOUNT_OPT in
+		"1")
+			MOUNT_OPT_STR=""
+			;;
+		"2")
+			MOUNT_OPT_STR="-r"
+			;;
+		"3")
+			MOUNT_OPT_STR="-o nodatacow"
+			;;
+	esac
+	FILE_OPERATION_OPT="$6"
+	SNAPSHOT_ACTION_OPT="$7"
+	TEST_DIR1=$DIR1$n
+	TEST_DIR2=$DIR2$n
+	TEST_MVDIR2=$MVDIR2$n
+	TEST_FILE1=$FILE1$n
+	TEST_FILE2=$FILE2$n
+	TEST_MVFILE2=$MVFILE2$n
+	TEST_MVSNAPSHOT=$MVSNAPSHOT$n
+	SRC_SUBVOLUME=$SRCSUBVOL$n
+	n=$[n+1]
+}
+
+_create_file()
+{
+	mkdir $SRC_SUBVOLUME/$TEST_DIR1 $SRC_SUBVOLUME/$TEST_DIR2 > /dev/null
+	touch $SRC_SUBVOLUME/$TEST_FILE1 $SRC_SUBVOLUME/$TEST_FILE2 > /dev/null
+}
+
+_do_file_operation()
+{
+	btrfs filesystem balance $SCRATCH_MNT > /dev/null 2>&1 &
+	rm -rf $SRC_SUBVOLUME/$TEST_DIR1 $SRC_SUBVOLUME/$TEST_FILE1 > /dev/null
+	mv $SRC_SUBVOLUME/$TEST_DIR2 $SRC_SUBVOLUME/$TEST_MVDIR2 > /dev/null
+	mv $SRC_SUBVOLUME/$TEST_FILE2 $SRC_SUBVOLUME/$TEST_MVFILE2 > /dev/null
+}
+
+_do_snapshot_action()
+{
+	if [ "$SNAPSHOT_ACTION_OPT" == 2 ];then
+		btrfs subvolume delete $DESTINATION_SUBVOLUME > /dev/null 2>>$here/$seq.full
+	fi
+	if [ "$SNAPSHOT_ACTION_OPT" == 3 ];then
+		mv $DESTINATION_SUBVOLUME $TEST_MVSNAPSHOT > /dev/null 2>>$here/$seq.full
+	fi
+}
+
+_check_snapshot()
+{
+	if [ "$SNAPSHOT_ACTION_OPT" == 2 ];then
+		if [ -d "$DESTINATION_SUBVOLUME" ];then
+			echo "case $n fails, deleting snapshot fails." >> $here/$seq.full
+			status=1
+		fi
+	fi
+	if [ "$SNAPSHOT_ACTION_OPT" == 3 ];then
+		if [ ! -d "$TEST_MVSNAPSHOT" ];then
+			echo "case $n fails, renaming snapshot fails." >> $here/$seq.full
+			status=1
+		fi
+	fi
+
+}
+
+_check_file()
+{
+	cd $DESTINATION_SUBVOLUME
+	if [ "$FILE_OPERATION_OPT" == 2 ];then
+		if [ -d "$TEST_DIR1" ];then
+			echo "case $n fails, before snapshot we delete dir in src, but it exists in snap" >> $here/$seq.full
+			status=1
+		fi
+		if [ -f "$TEST_FILE1" ];then
+			echo "case $n fails, before snapshot we delete file in src, but it exists in snap" >> $here/$seq.full
+			status=1
+		fi
+		if [ -d "$TEST_DIR2" -o ! -d "$TEST_MVDIR2" ];then
+			echo "case $n fails, before snapshot we rename dir in src, but it remains in snap" >> $here/$seq.full
+			status=1
+
+		fi
+		if [ -f "$TEST_FILE2" -o ! -f "$TEST_MVFILE2" ];then
+			echo "case $n fails, before snapshot we rename file in src,but it remains in snap" >> $here/$seq.full
+			status=1
+		fi
+
+	else
+		if [ ! -d "$TEST_DIR1" ];then
+			echo "case $n fails, after snapshot we delete dir in src, but it doesn't exist in snap" >> $here/$seq.full
+			status=1
+		fi
+		if [ ! -f "$TEST_FILE1" ];then
+			echo "case $n fails, after snapshot we delete file in src, but it doesn't exist in snap" >> $here/$seq.full
+			status=1
+
+		fi
+		if [ ! -d "$TEST_DIR2" -o -d "$TEST_MVDIR2" ];then
+			echo "case $n fails, after snapshot we rename dir in src, but it also changes in snap" >> $here/$seq.full
+			status=1
+		fi
+		if [ ! -f "$TEST_FILE2" -o -f "$TEST_MVFILE2" ];then
+			echo "case $n fails, after snapshot we rename file in src, but it also changes in snap" >> $here/$seq.full
+			status=1
+		fi
+	fi
+	btrfs filesystem balance cancel $SCRATCH_MNT > /dev/null 2>&1
+	wait 
+	cd ..
+}
+
+_test_snapshot_ro()
+{
+	btrfs sub snap $SNAPSHOTOPT_STR $SOURCE_SUBVOLUME $DESTINATION_SUBVOLUME > /dev/null 2>&1
+	if [ "$?" == 0  ];then
+		if [ "$MOUNT_OPT" != 1 ];then
+			echo "case $n fails, btrfs snapshot fails." >> $here/$seq.full
+			status=1
+		else
+			if [ "$DESTINATION_READ" == 1 ];then
+				if [ -w "$DESTINATION_SUBVOLUME" ];then
+					echo "case $n fails, snapshot should be readonly." >> $here/$seq.full
+					status=1
+				fi
+			else
+				if [ ! -w "$DESTINATION_SUBVOLUME" ];then
+					echo  "case $n fails, snapshot should be writable." >> $here/$seq.full
+					status=1
+				fi
+			fi
+		fi
+		
+	fi
+}
+
+_test_snapshot_operation()
+{	
+	btrfs sub create $SRC_SUBVOLUME > /dev/null 2>>$here/$seq.full
+	_create_file
+	if [ "$FILE_OPERATION_OPT" == 2 ];then
+		_do_file_operation
+	fi
+	btrfs sub snap $SRC_SUBVOLUME $DESTINATION_SUBVOLUME > /dev/null 2>>$here/$seq.full
+	if [ "$?" == 0 ];then
+		if [ "$FILE_OPERATION_OPT" == 3 ];then
+			_do_file_operation
+		fi 
+		if [ "$FILE_OPERATION_OPT" -eq "2" -o "$FILE_OPERATION_OPT" -eq "3" ];then
+			_check_file
+		fi
+		_do_snapshot_action
+		_check_snapshot
+	else
+		status=1
+		echo "case $n fails, btrfs snapshot fails." >> $here/$seq.full
+	fi
+}
+
+_test_process()
+{
+	_scratch_mount "$MOUNT_OPT_STR"
+	cd $SCRATCH_MNT
+	if [ "$FILE_OPERATION_OPT" == 0 ];then
+			_test_snapshot_ro
+	else
+			_test_snapshot_operation
+	fi
+	cd ~
+	_scratch_unmount 
+	_check_test_fs 
+	if [ "$?" != 0 ];then
+		echo "case $n fails, btrfsck fails." >> $here/$seq.full
+		status=1
+	fi
+}
+
+rm -f $here/$seq.full
+_prepare_snapshot
+
+# Src subvol | Src readonly | Des subvol | Des Readonly | Mount opt | File operation | Snap operation
+
+# case 1	
+# Valid Src | RO | Valid Des | RO | Default | Nothing | Create
+_parse_options 1 1 1 1 1 0 0
+_test_process
+
+# case 2
+# Valid Src | RO | Valid Des | Writable | Default | Nothing | Create
+_parse_options 1 1 1 2 1 0 0
+_test_process
+
+# case 3
+# Valid Src | Writable | Valid Des | RO | Default | Nothing | Create
+_parse_options 1 2 1 1 1 0 0
+_test_process
+
+# case 4
+# Valid Src | Writable | Valid Des | Writable | Default | Nothing | Create
+_parse_options 1 2 1 2 1 0 0
+_test_process
+
+# case 5
+# Valid Src | RO | Valid Des | RO | -r | Nothing | Create
+_parse_options 1 1 1 1 2 0 0
+_test_process
+
+# case 6
+# Valid Src | RO | Valid Des | Writable | -r | Nothing | Create
+_parse_options 1 1 1 2 2 0 0
+_test_process
+
+# case 7
+# Valid Src | Writable | Valid Des | RO | -r | Nothing | Create
+_parse_options 1 2 1 1 2 0 0
+_test_process
+
+# case 8
+# Valid Src | Writable | Valid Des | Writable | -r | Nothing | Create
+_parse_options 1 2 1 2 2 0 0
+_test_process
+
+# case 9
+# Valid Src | Writable | Valid Des | Writable | Default | Before snap | Delete
+_parse_options 1 2 1 2 1 2 2
+_test_process
+
+# case 10
+# Valid Src | Writable | Valid Des | Writable | Default | Before snap | Rename
+_parse_options 1 2 1 2 1 2 3
+_test_process
+
+# case 11
+# Valid Src | Writable | Valid Des | Writable | Default | After snap | Delete
+_parse_options 1 2 1 2 1 3 2
+_test_process
+
+# case 12
+# Valid Src | Writable | Valid Des | Writable | Default | After snap | Rename
+_parse_options 1 2 1 2 1 3 3
+_test_process
+
+# case 13
+# Valid Src | Writable | Valid Des | Writable | no datacow | Before snap | Delete
+_parse_options 1 2 1 2 3 2 2
+_test_process
+
+# case 14
+# Valid Src | Writable | Valid Des | Writable | no datacow | Before snap | Rename
+_parse_options 1 2 1 2 3 2 3
+_test_process
+
+# case 15
+# Valid Src | Writable | Valid Des | Writable | no datacow | After snap | Delete
+_parse_options 1 2 1 2 3 3 2
+_test_process
+
+# case 16
+# Valid Src | Writable | Valid Des | Writable | no datacow | After snap | Rename
+_parse_options 1 2 1 2 3 3 3
+_test_process
+
+echo "Silence is golden"
+exit
diff --git a/285.out b/285.out
new file mode 100644
index 0000000..ab12da9
--- /dev/null
+++ b/285.out
@@ -0,0 +1,2 @@
+QA output created by 285
+Silence is golden
diff --git a/group b/group
index 104ed35..0b33178 100644
--- a/group
+++ b/group
@@ -403,3 +403,4 @@ deprecated
 282 dump ioctl auto quick
 283 dump ioctl auto quick
 284 auto
+285 auto
-- 
1.6.0.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
