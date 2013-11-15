Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB5AF7FAB
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 12:01:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE7B28F8059
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 10:01:09 -0800 (PST)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id GzIKwm6x2DSuUdIx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 10:01:08 -0800 (PST)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 9DF529A0371
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 11:01:07 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 1/2] xfstests: add generic/321 to test fsync() on directories
	V2
Date: Fri, 15 Nov 2013 13:01:03 -0500
Message-ID: <1384538464-7384-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

Btrfs had some issues with fsync()'ing directories and fsync()'ing after
renames.  These three new tests cover the 3 different issues we were seeing.
This breaks out the dmflakey stuff into a common helper to be shared between
generic/311 and generic/321. Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: rename test to generic/321
-removed an extraneous command

 tests/generic/311     |  56 +++-----------------
 tests/generic/321     | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/321.out |   9 ++++
 tests/generic/group   |   1 +
 4 files changed, 157 insertions(+), 49 deletions(-)
 create mode 100644 tests/generic/321
 create mode 100644 tests/generic/321.out

diff --git a/tests/generic/311 b/tests/generic/311
index 675d927..6802a96 100644
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -41,17 +41,14 @@ status=1	# failure is the default!
 
 _cleanup()
 {
-	# If dmsetup load fails then we need to make sure to do resume here
-	# otherwise the umount will hang
-	$DMSETUP_PROG resume flakey-test > /dev/null 2>&1
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
-	$DMSETUP_PROG remove flakey-test > /dev/null 2>&1
+	_cleanup_flakey
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/dmflakey
 
 # real QA test starts here
 _supported_fs generic
@@ -63,49 +60,12 @@ _require_dm_flakey
 [ -x $here/src/fsync-tester ] || _notrun "fsync-tester not build"
 
 rm -f $seqres.full
-BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-FLAKEY_DEV=/dev/mapper/flakey-test
 SEED=1
 testfile=$SCRATCH_MNT/$seq.fsync
-FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 180 0"
-FLAKEY_TABLE_DROP="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 drop_writes"
-_TEST_OPTIONS=""
-
-_mount_flakey()
-{
-	mount -t $FSTYP $MOUNT_OPTIONS $FLAKEY_DEV $SCRATCH_MNT
-}
-
-_unmount_flakey()
-{
-	$UMOUNT_PROG $SCRATCH_MNT
-}
-
-_load_flakey_table()
-{
-	# _load_flakey_table <table>
-
-	table="$FLAKEY_TABLE"
-	[ $1 -eq 1 ] && table="$FLAKEY_TABLE_DROP"
-
-	suspend_opt=""
-	[ $nolockfs -eq 1 ] && suspend_opt="--nolockfs"
-
-	$DMSETUP_PROG suspend $suspend_opt flakey-test
-	[ $? -ne 0 ] && _fatal "failed to suspend flakey-test"
-
-	$DMSETUP_PROG load flakey-test --table "$table"
-	[ $? -ne 0 ] && _fatal "failed to load table into flakey-test"
-
-	$DMSETUP_PROG resume flakey-test
-	[ $? -ne 0 ] && _fatal  "failed to resumeflakey-test"
-}
 
 _run_test()
 {
 	# _run_test <testnum> <0 - buffered | 1 - O_DIRECT>
-	allow_writes=0
-	drop_writes=1
 	test_num=$1
 
 	direct_opt=""
@@ -115,11 +75,11 @@ _run_test()
 	[ $? -ne 0 ] && _fatal "fsync tester exited abnormally"
 
 	_md5_checksum $testfile
-	_load_flakey_table $drop_writes
+	_load_flakey_table $FLAKEY_DROP_WRITES $lockfs
 	_unmount_flakey
 
 	#Ok mount so that any recovery that needs to happen is done
-	_load_flakey_table $allow_writes
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
 	_mount_flakey
 	_md5_checksum $testfile
 
@@ -134,23 +94,21 @@ _run_test()
 _scratch_mkfs >> $seqres.full 2>&1
 
 # Create a basic flakey device that will never error out
-$DMSETUP_PROG create flakey-test --table "$FLAKEY_TABLE"
-[ $? -ne 0 ] && _fatal "failed to create flakey device"
-
+_init_flakey
 _mount_flakey
 
 buffered=0
 direct=1
 
 for i in $(seq 1 20); do
-	nolockfs=0
+	lockfs=1
 	SEED=$i
 	echo "Running test $i buffered, normal suspend"
 	_run_test $i $buffered
 	echo "Running test $i direct, normal suspend"
 	_run_test $i $direct
 
-	nolockfs=1
+	lockfs=0
 	echo "Running test $i buffered, nolockfs"
 	_run_test $i $buffered
 	echo "Running test $i direct, nolockfs"
diff --git a/tests/generic/321 b/tests/generic/321
new file mode 100644
index 0000000..1d17147
--- /dev/null
+++ b/tests/generic/321
@@ -0,0 +1,140 @@
+#! /bin/bash
+# FS QA Test No. 321
+#
+# Runs various dir fsync tests to cover fsync'ing directory corner cases.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO. All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_flakey
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+
+rm -f $seqres.full
+
+_clean_working_dir()
+{
+	_mount_flakey
+	rm -rf $SCRATCH_MNT/*
+	_unmount_flakey
+}
+
+# Btrfs wasn't making sure the directory survived fsync
+_directory_test()
+{
+	echo "fsync new directory"
+	_mount_flakey
+	mkdir $SCRATCH_MNT/bar
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+	_load_flakey_table $FLAKEY_DROP_WRITES
+	_unmount_flakey
+
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+	_ls_l $SCRATCH_MNT | tail -n +2 | awk '{ print $1, $9 }'
+	_unmount_flakey
+	_check_scratch_fs $FLAKEY_DEV
+	[ $? -ne 0 ] && _fatal "fsck failed"
+}
+
+# Btrfs was losing a rename into a new directory
+_rename_test()
+{
+	echo "rename fsync test"
+	_mount_flakey
+	touch $SCRATCH_MNT/foo
+	mkdir $SCRATCH_MNT/bar
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+	mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar/foo
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar/foo
+	_load_flakey_table $FLAKEY_DROP_WRITES
+	_unmount_flakey
+
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+	_ls_l $SCRATCH_MNT | tail -n +2 | awk '{ print $1, $9 }'
+	_ls_l $SCRATCH_MNT/bar | tail -n +2 | awk '{ print $1, $9 }'
+	_unmount_flakey
+	_check_scratch_fs $FLAKEY_DEV
+	[ $? -ne 0 ] && _fatal "fsck failed"
+}
+
+# Btrfs was failing to replay a log when we had a inode with a smaller inode
+# number that is renamed into a directory with a higher inode number
+_replay_rename_test()
+{
+	echo "replay rename fsync test"
+	_mount_flakey
+	touch $SCRATCH_MNT/foo
+	mkdir $SCRATCH_MNT/bar
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+	mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar/foo
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+
+	# This is to force btrfs to relog the entire inode including the ref so
+	# we are sure to try and replay the ref along with the dir_index item
+	setfattr -n user.foo -v blah $SCRATCH_MNT/bar/foo >> $seqres.full 2>&1
+
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar/foo
+	_load_flakey_table $FLAKEY_DROP_WRITES
+	_unmount_flakey
+
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+	_ls_l $SCRATCH_MNT | tail -n +2 | awk '{ print $1, $9 }'
+	_ls_l $SCRATCH_MNT/bar | tail -n +2 | awk '{ print $1, $9 }'
+	_unmount_flakey
+	_check_scratch_fs $FLAKEY_DEV
+	[ $? -ne 0 ] && _fatal "fsck failed"
+}
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+# Create a basic flakey device that will never error out
+_init_flakey
+
+_directory_test
+_clean_working_dir
+_rename_test
+_clean_working_dir
+_replay_rename_test
+
+status=0
+exit
diff --git a/tests/generic/321.out b/tests/generic/321.out
new file mode 100644
index 0000000..9ed630f
--- /dev/null
+++ b/tests/generic/321.out
@@ -0,0 +1,9 @@
+QA output created by 321
+fsync new directory
+drwxr-xr-x bar
+rename fsync test
+drwxr-xr-x bar
+-rw-r--r-- foo
+replay rename fsync test
+drwxr-xr-x bar
+-rw-r--r-- foo
diff --git a/tests/generic/group b/tests/generic/group
index 40da6dc..25dddd8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -123,3 +123,4 @@
 318 acl attr auto quick
 319 acl auto quick
 320 auto rw
+321 auto quick metadata log
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
