Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E712A7F72
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 08:39:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38993AC003
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 06:39:11 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id lbJueYjWdlhl6A7D (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 06:39:09 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 712C9AC65
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 14:39:08 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: clean command names in btrfs tests
Date: Wed, 22 Jan 2014 15:39:07 +0100
Message-Id: <1390401547-13538-1-git-send-email-dsterba@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: David Sterba <dsterba@suse.cz>

- expand shortened command names
- use $BTRFS_UTIL_PROG instead of 'btrfs'
- fix test 024 header number

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 tests/btrfs/003 |  2 +-
 tests/btrfs/004 |  2 +-
 tests/btrfs/007 |  4 ++--
 tests/btrfs/008 | 12 ++++++------
 tests/btrfs/009 |  6 +++---
 tests/btrfs/013 |  2 +-
 tests/btrfs/014 |  6 +++---
 tests/btrfs/015 |  2 +-
 tests/btrfs/016 | 14 +++++++-------
 tests/btrfs/017 |  2 +-
 tests/btrfs/019 | 14 +++++++-------
 tests/btrfs/022 |  6 +++---
 tests/btrfs/024 |  2 +-
 tests/btrfs/025 |  4 ++--
 14 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 29f947b631cd..d559f8ed1df9 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -148,7 +148,7 @@ _test_replace()
 	_devmgt_remove ${DEVHTL} $ds
 	dev_removed=1
 
-	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
+	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
 							"btrfs did not report device missing"
 
 	# add a new disk to btrfs
diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 6e58b03ccf47..14da9f1a33f6 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -182,7 +182,7 @@ workout()
 	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 2000 \
 		$FSSTRESS_AVOID
 
-	run_check $BTRFS_UTIL_PROG subvol snap $SCRATCH_MNT \
+	run_check $BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT \
 		$SCRATCH_MNT/$snap_name
 
 	run_check umount $SCRATCH_DEV >/dev/null 2>&1
diff --git a/tests/btrfs/007 b/tests/btrfs/007
index 1617977c2be8..5df9ccba0888 100755
--- a/tests/btrfs/007
+++ b/tests/btrfs/007
@@ -72,9 +72,9 @@ workout()
 	run_check _scratch_mount "-o noatime"
 
 	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n $ops $FSSTRESS_AVOID -x \
-		"$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/base"
+		"$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/base"
 
-	run_check $BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/incr
+	run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/incr
 
 	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap" \
 		>> $seqres.full
diff --git a/tests/btrfs/008 b/tests/btrfs/008
index fa61cb1bfe79..9fa36a613667 100755
--- a/tests/btrfs/008
+++ b/tests/btrfs/008
@@ -34,9 +34,9 @@ status=1	# failure is the default!
 
 _cleanup()
 {
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send/snapshots/backup2 > /dev/null 2>&1
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send/snapshots/backup3 > /dev/null 2>&1
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/send/snapshots/backup2 > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/send/snapshots/backup3 > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
 	rm -rf $TEST_DIR/$tmp_dir
 	rm -f $tmp.*
 }
@@ -62,7 +62,7 @@ export SELINUX_MOUNT_OPTIONS=""
 _scratch_mount
 
 mkdir $TEST_DIR/$tmp_dir
-$BTRFS_UTIL_PROG subvol create $TEST_DIR/$tmp_dir/send \
+$BTRFS_UTIL_PROG subvolume create $TEST_DIR/$tmp_dir/send \
 	> $seqres.full 2>&1 || _fail "failed subvol create"
 work_dir="$TEST_DIR/$tmp_dir/send"
 mkdir $work_dir/testdir
@@ -72,9 +72,9 @@ dd if=/dev/urandom  of=$work_dir/testdir/aa count=16 > /dev/null 2>&1
 dd if=/dev/urandom  of=$work_dir/testdir/bb count=16 > /dev/null 2>&1
 
 mkdir $work_dir/snapshots
-$BTRFS_UTIL_PROG sub snap -r $work_dir $work_dir/snapshots/backup2 \
+$BTRFS_UTIL_PROG subvolume snapshot -r $work_dir $work_dir/snapshots/backup2 \
 	>> $seqres.full 2>&1 || _fail "failed backup2"
-$BTRFS_UTIL_PROG sub snap -r $work_dir $work_dir/snapshots/backup3 \
+$BTRFS_UTIL_PROG subvolume snapshot -r $work_dir $work_dir/snapshots/backup3 \
 	>> $seqres.full 2>&1 || _fail "failed backup3"
 $BTRFS_UTIL_PROG send $work_dir/snapshots/backup3/ -f $TEST_DIR/$tmp_dir/blah \
 	>> $seqres.full 2>&1 || _fail "send failed"
diff --git a/tests/btrfs/009 b/tests/btrfs/009
index 08aa5081b46f..2ffb81730d24 100755
--- a/tests/btrfs/009
+++ b/tests/btrfs/009
@@ -52,12 +52,12 @@ rm -f $seqres.full
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
-$BTRFS_UTIL_PROG sub create $SCRATCH_MNT/newvol >> $seqres.full 2>&1 \
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/newvol >> $seqres.full 2>&1 \
 	|| _fail "couldn't create subvol"
 subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT newvol)
-$BTRFS_UTIL_PROG sub set-default $subvolid $SCRATCH_MNT >> $seqres.full 2>&1 \
+$BTRFS_UTIL_PROG subvolume set-default $subvolid $SCRATCH_MNT >> $seqres.full 2>&1 \
 	|| _fail "couldn't set default"
-$BTRFS_UTIL_PROG sub delete $SCRATCH_MNT/newvol >> $seqres.full 2>&1
+$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/newvol >> $seqres.full 2>&1
 _scratch_unmount
 _scratch_mount || _fail "mount should have succeeded"
 
diff --git a/tests/btrfs/013 b/tests/btrfs/013
index 5bbd7a3118e6..7620fcc450f3 100644
--- a/tests/btrfs/013
+++ b/tests/btrfs/013
@@ -72,7 +72,7 @@ _check_csum_error()
 }
 $XFS_IO_PROG -f -c "falloc 0 1M" -c "pwrite 16k 8k" -c "fsync" \
 	$SCRATCH_MNT/foo > $seqres.full 2>&1
-$BTRFS_UTIL_PROG fi ba $SCRATCH_MNT >> $seqres.full 2>&1 || \
+$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || \
 	_fail "balance failed"
 _scratch_unmount
 _scratch_mount
diff --git a/tests/btrfs/014 b/tests/btrfs/014
index aa3edbb0ad14..142423f7910d 100755
--- a/tests/btrfs/014
+++ b/tests/btrfs/014
@@ -33,8 +33,8 @@ _create_snapshot()
 {
 	for i in $(seq 20)
 	do
-		btrfs sub snapshot $SCRATCH_MNT $SCRATCH_MNT/snapshot0 >/dev/null
-		btrfs sub delete $SCRATCH_MNT/snapshot0 >/dev/null
+		$BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snapshot0 >/dev/null
+		$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snapshot0 >/dev/null
 	done
 }
 
@@ -42,7 +42,7 @@ _balance()
 {
 	for i in $(seq 20)
 	do
-		btrfs balance start $SCRATCH_MNT >/dev/null
+		$BTRFS_UTIL_PROG balance start $SCRATCH_MNT >/dev/null
 	done
 }
 
diff --git a/tests/btrfs/015 b/tests/btrfs/015
index b7b502144889..0b5fdfd5b951 100644
--- a/tests/btrfs/015
+++ b/tests/btrfs/015
@@ -54,7 +54,7 @@ _scratch_mkfs > /dev/null 2>&1
 _scratch_mount -o ro
 _scratch_mount -o rw,remount
 
-$BTRFS_UTIL_PROG sub snap $SCRATCH_MNT $SCRATCH_MNT/snap >> $seqres.full 2>&1 \
+$BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap >> $seqres.full 2>&1 \
 	|| _fail "couldn't create snapshot"
 
 echo "Silence is golden"
diff --git a/tests/btrfs/016 b/tests/btrfs/016
index d711ecb63c14..6faead1070d7 100644
--- a/tests/btrfs/016
+++ b/tests/btrfs/016
@@ -34,9 +34,9 @@ status=1	# failure is the default!
 
 _cleanup()
 {
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap > /dev/null 2>&1
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap1 > /dev/null 2>&1
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/snap > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/snap1 > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
 	rm -rf $TEST_DIR/$tmp_dir
 	rm -f $tmp.*
 }
@@ -65,15 +65,15 @@ export SELINUX_MOUNT_OPTIONS=""
 _scratch_mount
 
 mkdir $TEST_DIR/$tmp_dir
-$BTRFS_UTIL_PROG subvol create $TEST_DIR/$tmp_dir/send \
-	> $seqres.full 2>&1 || _fail "failed subvol create"
+$BTRFS_UTIL_PROG subvolume create $TEST_DIR/$tmp_dir/send \
+	> $seqres.full 2>&1 || _fail "failed subvolume create"
 
 dd if=/dev/urandom of=$TEST_DIR/$tmp_dir/send/foo bs=1M count=10 >> $seqres.full \
 	2>&1 || _fail "dd failed"
-$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
+$BTRFS_UTIL_PROG subvolume snapshot -r $TEST_DIR/$tmp_dir/send \
 	$TEST_DIR/$tmp_dir/snap >> $seqres.full 2>&1 || _fail "failed snap"
 $XFS_IO_PROG -c "fpunch 1m 1m" $TEST_DIR/$tmp_dir/send/foo
-$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
+$BTRFS_UTIL_PROG subvolume snapshot -r $TEST_DIR/$tmp_dir/send \
 	$TEST_DIR/$tmp_dir/snap1 >> $seqres.full 2>&1 || _fail "failed snap"
 
 $FSSUM_PROG -A -f -w $tmp/fssum.snap $TEST_DIR/$tmp_dir/snap >> $seqres.full \
diff --git a/tests/btrfs/017 b/tests/btrfs/017
index d45f32a863d1..1f31e8a7bb33 100644
--- a/tests/btrfs/017
+++ b/tests/btrfs/017
@@ -54,7 +54,7 @@ _scratch_mkfs > /dev/null 2>&1
 _scratch_mount -o ro
 _scratch_mount -o rw,remount
 
-$BTRFS_UTIL_PROG sub snap $SCRATCH_MNT $SCRATCH_MNT/snap >> $seqres.full 2>&1 \
+$BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap >> $seqres.full 2>&1 \
 	|| _fail "couldn't create snapshot"
 
 echo "Silence is golden"
diff --git a/tests/btrfs/019 b/tests/btrfs/019
index c20ed9b5c153..45bba5ef98a3 100755
--- a/tests/btrfs/019
+++ b/tests/btrfs/019
@@ -34,9 +34,9 @@ status=1	# failure is the default!
 
 _cleanup()
 {
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap1 > /dev/null 2>&1
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap2 > /dev/null 2>&1
-	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/snap1 > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/snap2 > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvolume delete $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
 	rm -rf $TEST_DIR/$tmp_dir
 	rm -f $tmp.*
 }
@@ -62,8 +62,8 @@ export SELINUX_MOUNT_OPTIONS=""
 _scratch_mount
 
 mkdir $TEST_DIR/$tmp_dir
-$BTRFS_UTIL_PROG subvol create $TEST_DIR/$tmp_dir/send \
-	> $seqres.full 2>&1 || _fail "failed subvol create"
+$BTRFS_UTIL_PROG subvolume create $TEST_DIR/$tmp_dir/send \
+	> $seqres.full 2>&1 || _fail "failed subvolume create"
 
 SEND_TEST_DIR=$TEST_DIR/$tmp_dir/send
 
@@ -73,7 +73,7 @@ touch $SEND_TEST_DIR/test/blah
 mkdir $SEND_TEST_DIR/test/foo
 touch $SEND_TEST_DIR/test/foo/bar
 
-$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
+$BTRFS_UTIL_PROG subvolume snapshot -r $TEST_DIR/$tmp_dir/send \
 	$TEST_DIR/$tmp_dir/snap1 >> $seqres.full 2>&1 || _fail "failed snap1"
 
 $BTRFS_UTIL_PROG send -f $TEST_DIR/$tmp_dir/send1.dump \
@@ -91,7 +91,7 @@ mkdir $SEND_TEST_DIR/test/foo
 touch $SEND_TEST_DIR/test/foo/bar
 touch $SEND_TEST_DIR/test/blah
 
-$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
+$BTRFS_UTIL_PROG subvolume snapshot -r $TEST_DIR/$tmp_dir/send \
 	$TEST_DIR/$tmp_dir/snap2 >> $seqres.full 2>&1 || _fail "failed snap2"
 
 $BTRFS_UTIL_PROG send -f $TEST_DIR/$tmp_dir/send2.dump \
diff --git a/tests/btrfs/022 b/tests/btrfs/022
index 41d8588d1023..ab256a39d890 100755
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -75,7 +75,7 @@ _basic_test()
 _rescan_test()
 {
 	# first with a blank subvol
-	run_check $BTRFS_UTIL_PROG subvol create $SCRATCH_MNT/a
+	run_check $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/a
 	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT/a
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
 	run_check $FSSTRESS_PROG -d $SCRATCH_MNT/a -w -p 1 -n 2000 \
@@ -97,7 +97,7 @@ _rescan_test()
 #basic exceed limit testing
 _limit_test_exceed()
 {
-	run_check $BTRFS_UTIL_PROG subvol create $SCRATCH_MNT/a
+	run_check $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/a
 	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
 	run_check $BTRFS_UTIL_PROG qgroup limit 5M 0/$subvolid $SCRATCH_MNT
@@ -109,7 +109,7 @@ _limit_test_exceed()
 #basic noexceed limit testing
 _limit_test_noexceed()
 {
-	run_check $BTRFS_UTIL_PROG subvol create $SCRATCH_MNT/a
+	run_check $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/a
 	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
 	run_check $BTRFS_UTIL_PROG qgroup limit 5M 0/$subvolid $SCRATCH_MNT
diff --git a/tests/btrfs/024 b/tests/btrfs/024
index 1b619918a929..cb8a6e452376 100755
--- a/tests/btrfs/024
+++ b/tests/btrfs/024
@@ -1,5 +1,5 @@
 #! /bin/bash
-# FS QA Test No. btrfs/008
+# FS QA Test No. btrfs/024
 #
 # btrfs wrong compression type regression test. This test is used to check
 # the oops will happen when the users write some data into the files whose
diff --git a/tests/btrfs/025 b/tests/btrfs/025
index 5f13832be89c..482467ffc2d6 100755
--- a/tests/btrfs/025
+++ b/tests/btrfs/025
@@ -63,13 +63,13 @@ $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
 $XFS_IO_PROG -f -c "pwrite 1482752 2978" $SCRATCH_MNT/foo | _filter_xfs_io
 $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
 
-$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
     _filter_scratch
 
 $XFS_IO_PROG -f -c "truncate 883305" $SCRATCH_MNT/foo | _filter_xfs_io
 $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
 
-$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
     _filter_scratch
 
 $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap 2>&1 | _filter_scratch
-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
