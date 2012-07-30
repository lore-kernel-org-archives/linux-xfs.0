Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6U9gLmX016587 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 04:42:21 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id essWSGS5AE6hX1zk for
	<xfs@oss.sgi.com>; Mon, 30 Jul 2012 02:42:17 -0700 (PDT)
Message-ID: <501653D2.1090607@cn.fujitsu.com>
Date: Mon, 30 Jul 2012 17:28:50 +0800
From: zhoubo <zhoub-fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstests: add btrfs snapshot function test
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
To: xfs@oss.sgi.com
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org

From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

This patch adds btrfs snapshot function test to xfstests

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
---
v2: address comments from David Sterba

 285     |  387 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 285.out |    2 +
 group   |    1 +
 3 files changed, 390 insertions(+), 0 deletions(-)
 create mode 100755 285
 create mode 100644 285.out

diff --git a/285 b/285
new file mode 100755
index 0000000..2842384
--- /dev/null
+++ b/285
@@ -0,0 +1,387 @@
+#! /bin/bash
+# FS QA Test No. 285
+#
+# Snapshot QA test with different mount options and stress:
+# mount options: default, ro, nodatacow
+# stress: balance
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
+# file size is 2G
+_scratch_mkfs_sized `expr 2 \* 1024 \* 1024 \* 1024` > /dev/null 2>&1
+_scratch_mount
+
+_prepare_snapshot()
+{
+	_scratch_remount > /dev/null
+	btrfs subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/basesnapshot > /dev/null 2>>$here/$seq.full
+	btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/readonlysnapshot > /dev/null 2>>$here/$seq.full
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
+	SOURCE_RO="$2"
+	case $SOURCE_RO in
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
+	DESTINATION_RO="$4"
+	case $DESTINATION_RO in
+		"1")
+			SNAPSHOT_OPT_STR="-r"
+			;;
+		"2")
+			SNAPSHOT_OPT_STR=""
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
+_do_balance_operation()
+{
+	btrfs filesystem balance start $SCRATCH_MNT > /dev/null 2>&1 &
+}
+
+_do_file_operation()
+{
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
+}
+
+_check_file()
+{
+	cd $DESTINATION_SUBVOLUME
+	if [ "$FILE_OPERATION_OPT" == 2 ];then
+		if [ -d "$TEST_DIR1" ];then
+			echo "case $n fails, before snapshot we delete dir in src, but it exists in snap" >>\
+				$here/$seq.full
+			status=1
+		fi
+		if [ -f "$TEST_FILE1" ];then
+			echo "case $n fails, before snapshot we delete file in src, but it exists in snap" >>\
+				$here/$seq.full
+			status=1
+		fi
+		if [ -d "$TEST_DIR2" -o ! -d "$TEST_MVDIR2" ];then
+			echo "case $n fails, before snapshot we rename dir in src, but it remains in snap" >>\
+				$here/$seq.full
+			status=1
+
+		fi
+		if [ -f "$TEST_FILE2" -o ! -f "$TEST_MVFILE2" ];then
+			echo "case $n fails, before snapshot we rename file in src,but it remains in snap" >>\
+				$here/$seq.full
+			status=1
+		fi
+
+	else
+		if [ ! -d "$TEST_DIR1" ];then
+			echo "case $n fails, after snapshot we delete dir in src, but it does't exist in snap" >>\
+				$here/$seq.full
+			status=1
+		fi
+		if [ ! -f "$TEST_FILE1" ];then
+			echo "case $n fails, after snapshot we delete file in src, but it does't exist in snap" >>\
+				$here/$seq.full
+			status=1
+
+		fi
+		if [ ! -d "$TEST_DIR2" -o -d "$TEST_MVDIR2" ];then
+			echo "case $n fails, after snapshot we rename dir in src, but it also changes in snap" >>\
+				$here/$seq.full
+			status=1
+		fi
+		if [ ! -f "$TEST_FILE2" -o -f "$TEST_MVFILE2" ];then
+			echo "case $n fails, after snapshot we rename file in src, but it also changes in snap" >>\
+				$here/$seq.full
+			status=1
+		fi
+	fi
+	btrfs filesystem balance cancel $SCRATCH_MNT > /dev/null 2>&1
+	cd $SCRATCH_MNT
+}
+
+_test_snapshot_ro()
+{
+	btrfs subvolume snapshot $SNAPSHOT_OPT_STR $SOURCE_SUBVOLUME $DESTINATION_SUBVOLUME > /dev/null 2>&1
+	if [ "$?" == 0  ];then
+		if [ "$MOUNT_OPT" != 1 ];then
+			echo "case $n fails, btrfs snapshot fails." >> $here/$seq.full
+			status=1
+		else
+			if [ "$DESTINATION_RO" == 1 ];then
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
+	fi
+}
+
+_test_snapshot_operation()
+{
+	btrfs subvolume create $SRC_SUBVOLUME > /dev/null 2>>$here/$seq.full
+	_create_file
+	# for stress test
+	_do_balance_operation
+	if [ "$FILE_OPERATION_OPT" == 2 ];then
+		_do_file_operation
+	fi
+	btrfs subvolume snapshot $SRC_SUBVOLUME $DESTINATION_SUBVOLUME > /dev/null 2>>$here/$seq.full
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
+	_parse_options $@
+	_scratch_mount "$MOUNT_OPT_STR"
+	cd $SCRATCH_MNT
+	if [ "$FILE_OPERATION_OPT" == 0 ];then
+			_test_snapshot_ro
+	else
+			_test_snapshot_operation
+	fi
+	cd $TEST_DIR
+	_scratch_unmount
+	_check_scratch_fs
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
+# Test to check if we can create a readonly snapshot from a readonly src with default mount options
+# Valid Src | RO | Valid Des | RO | Default | Nothing | Create
+_test_process 1 1 1 1 1 0 0
+
+# case 2
+# Test to check if we can create a writable snapshot from a readonly src with default mount options
+# Valid Src | RO | Valid Des | Writable | Default | Nothing | Create
+_test_process 1 1 1 2 1 0 0
+
+# case 3
+# Test to check if we can create a readonly snapshot from a writable src with default mount options
+# Valid Src | Writable | Valid Des | RO | Default | Nothing | Create
+_test_process 1 2 1 1 1 0 0
+
+# case 4
+# Test to check if we can create a writable snapshot from a writable src with default mount options
+# Valid Src | Writable | Valid Des | Writable | Default | Nothing | Create
+_test_process 1 2 1 2 1 0 0
+
+# case 5
+# Test to check if we can create a readonly snapshot from a readonly src with -r mount options
+# Valid Src | RO | Valid Des | RO | -r | Nothing | Create
+_test_process 1 1 1 1 2 0 0
+
+# case 6
+# Test to check if we can create a writable snapshot from a readonly src with -r  mount options
+# Valid Src | RO | Valid Des | Writable | -r | Nothing | Create
+_test_process 1 1 1 2 2 0 0
+
+# case 7
+# Test to check if we can create a readonly snapshot from a writable src with -r mount options
+# Valid Src | Writable | Valid Des | RO | -r | Nothing | Create
+_test_process 1 2 1 1 2 0 0
+
+# case 8
+# Test to check if we can create a writable snapshot from a readonly src with -r mount options
+# Valid Src | Writable | Valid Des | Writable | -r | Nothing | Create
+_test_process 1 2 1 2 2 0 0
+
+# case 9
+# Test to check if we do file operations in src before creating snap with default mount options, \
+# these changes exist in the snap, and check delete snap operation
+# Valid Src | Writable | Valid Des | Writable | Default | Before snap | Delete
+_test_process 1 2 1 2 1 2 2
+
+# case 10
+# Test to check if we do file operations in src before creating snap with default mount options, \
+# these changes exist in the snap, and check rename snap operation
+# Valid Src | Writable | Valid Des | Writable | Default | Before snap | Rename
+_test_process 1 2 1 2 1 2 3
+
+# case 11
+# Test to check if we do file operations in src after creating snap with default mount options, \
+# these changes do not exist in the snap, and check delete snap operation
+# Valid Src | Writable | Valid Des | Writable | Default | After snap | Delete
+_test_process 1 2 1 2 1 3 2
+
+# case 12
+# Test to check if we do file operations in src after creating snap with default mount options, \
+# these changes do not exist in the snap, and check rename snap operation
+# Valid Src | Writable | Valid Des | Writable | Default | After snap | Rename
+_test_process 1 2 1 2 1 3 3
+
+# case 13
+# Test to check if we do file operations in src before creating snap with nodatacow mount options,\
+# these changes exist in the snap, and check delete snap operation
+# Valid Src | Writable | Valid Des | Writable | nodatacow | Before snap | Delete
+_test_process 1 2 1 2 3 2 2
+
+# case 14
+# Test to check if we do file operations in src before creating snap with nodatacow mount options,\
+# these changes exist in the snap, and check rename snap operation
+# Valid Src | Writable | Valid Des | Writable | nodatacow | Before snap | Rename
+_test_process 1 2 1 2 3 2 3
+
+# case 15
+# Test to check if we do file operations in src after creating snap with nodatacow mount options,\
+# these changes do not exist in the snap, and check delete snap operation
+# Valid Src | Writable | Valid Des | Writable | nodatacow | After snap | Delete
+_test_process 1 2 1 2 3 3 2
+
+# case 16
+# Test to check if we do file operations in src after creating snap with nodatacow mount options,\
+# these changes do not exist in the snap, and check rename snap operation
+# Valid Src | Writable | Valid Des | Writable | nodatacow | After snap | Rename
+_test_process 1 2 1 2 3 3 3
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
