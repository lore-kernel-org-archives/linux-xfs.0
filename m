Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D1FE7F5D
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:26:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B00030407B
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:26:44 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id o3VPsWAEG2kNgbFw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 11:26:43 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DA04B7C0427
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:26:42 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 6/8] xfstests: generic/311: add a few more test cases
Date: Fri, 18 Oct 2013 14:26:28 -0400
Message-ID: <1382120790-31060-6-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Btrfs had some issues with fsync()'ing directories and fsync()'ing after
renames.  These three new tests cover the 3 different issues we were seeing.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/311     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/generic/311.out |  8 +++++
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/tests/generic/311 b/tests/generic/311
index 675d927..002ad57 100644
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -70,6 +70,8 @@ testfile=$SCRATCH_MNT/$seq.fsync
 FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 180 0"
 FLAKEY_TABLE_DROP="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 drop_writes"
 _TEST_OPTIONS=""
+allow_writes=0
+drop_writes=1
 
 _mount_flakey()
 {
@@ -104,8 +106,6 @@ _load_flakey_table()
 _run_test()
 {
 	# _run_test <testnum> <0 - buffered | 1 - O_DIRECT>
-	allow_writes=0
-	drop_writes=1
 	test_num=$1
 
 	direct_opt=""
@@ -131,6 +131,83 @@ _run_test()
 	_mount_flakey
 }
 
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
+	_load_flakey_table $drop_writes
+	_unmount_flakey
+
+	_load_flakey_table $allow_writes
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
+	_load_flakey_table $drop_writes
+	_unmount_flakey
+
+	_load_flakey_table $allow_writes
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
+	_load_flakey_table $drop_writes
+	_unmount_flakey
+
+	_load_flakey_table $allow_writes
+	_mount_flakey
+	_ls_l $SCRATCH_MNT | tail -n +2 | awk '{ print $1, $9 }'
+	_ls_l $SCRATCH_MNT/bar | tail -n +2 | awk '{ print $1, $9 }'
+	_unmount_flakey
+	_check_scratch_fs $FLAKEY_DEV
+	[ $? -ne 0 ] && _fatal "fsck failed"
+}
+
 _scratch_mkfs >> $seqres.full 2>&1
 
 # Create a basic flakey device that will never error out
@@ -157,5 +234,13 @@ for i in $(seq 1 20); do
 	_run_test $i $direct
 done
 
+rm -rf $SCRATCH_MNT/*
+_unmount_flakey
+_directory_test
+_clean_working_dir
+_rename_test
+_clean_working_dir
+_replay_rename_test
+
 status=0
 exit
diff --git a/tests/generic/311.out b/tests/generic/311.out
index 5bad6a7..8a0d5c8 100644
--- a/tests/generic/311.out
+++ b/tests/generic/311.out
@@ -319,3 +319,11 @@ Running test 20 direct, nolockfs
 Random seed is 20
 a16ac2b84456d41a15a1a4cc1202179f
 a16ac2b84456d41a15a1a4cc1202179f
+fsync new directory
+drwxr-xr-x bar
+rename fsync test
+drwxr-xr-x bar
+-rw-r--r-- foo
+replay rename fsync test
+drwxr-xr-x bar
+-rw-r--r-- foo
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
