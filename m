Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6JARclE008939 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 05:27:38 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id HDAkJ4W6tTHyO9be for
	<xfs@oss.sgi.com>; Thu, 19 Jul 2012 03:27:35 -0700 (PDT)
Message-ID: <5007E0FB.9040208@cn.fujitsu.com>
Date: Thu, 19 Jul 2012 18:27:07 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] Xfstests/254: add more cases for testing btrfs snapshot in 254
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

This patch adds more cases in 254 for testing btrfs snapshot.

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
---
 254 |  321 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 317 insertions(+), 4 deletions(-)

diff --git a/254 b/254
index 7b74a02..9c320d0 100755
--- a/254
+++ b/254
@@ -23,13 +23,14 @@
 #
 # creator
 owner=josef@redhat.com
-
+owner=zhoub-fnst@cn.fujitsu.com
+n=0
 seq=`basename $0`
 echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
-status=1	# failure is the default!
+status=0	# success is the default!
 
 _cleanup()
 {
@@ -47,7 +48,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 
-_scratch_mkfs > /dev/null 2>&1
+_scratch_mkfs_sized `expr 1024 \* 1024 \* 1024` > /dev/null 2>&1
 _scratch_mount
 
 # First test basic snapshotting
@@ -105,4 +106,316 @@ _scratch_remount
 echo "List root dir"
 ls $SCRATCH_MNT
 
-status=0 ; exit
+# The following is added in 2012/07/12, add more cases for testing snapshot 
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
+			echo "case $n fails, after snapshot we delete dir in src, but it does't exist in snap" >> $here/$seq.full
+			status=1
+		fi
+		if [ ! -f "$TEST_FILE1" ];then
+			echo "case $n fails, after snapshot we delete file in src, but it does't exist in snap" >> $here/$seq.full
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
+rm -rf $here/$seq.full
+_prepare_snapshot
+
+# Src subvol | Src readonly | Des subvol | Des readonly | Mount opt | File operation | Snap operation
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
+exit
-- 
1.6.0.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
