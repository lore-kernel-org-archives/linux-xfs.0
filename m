Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C8F467F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 23:48:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4090304053
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 21:48:22 -0800 (PST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
	by cuda.sgi.com with ESMTP id YABerI0jxSeP7t32 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 21:48:16 -0800 (PST)
Message-ID: <530C2E91.9050707@huawei.com>
Date: Tue, 25 Feb 2014 13:48:01 +0800
From: ZhangZhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: cleanup tests btrfs/004,007,022 and 025
References: <1393335609-21114-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1393335609-21114-1-git-send-email-zhenzhang.zhang@huawei.com>
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
To: david@fromorbit.com
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

As recently suggested by Dave Chinner, make use of the new function
named _run_btrfs_util_prog() to run the btrfs util program.
Filipe David Borba Manana have cleaned up  btrfs/030 and btrfs/034.
I have done the same for the rest ones.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 tests/btrfs/004 |  2 +-
 tests/btrfs/007 |  6 +++---
 tests/btrfs/022 | 24 ++++++++++++------------
 tests/btrfs/025 | 20 ++++++++++----------
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 14da9f1..135f804 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -182,7 +182,7 @@ workout()
 	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 2000 \
 		$FSSTRESS_AVOID

-	run_check $BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT \
+	_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT \
 		$SCRATCH_MNT/$snap_name

 	run_check umount $SCRATCH_DEV >/dev/null 2>&1
diff --git a/tests/btrfs/007 b/tests/btrfs/007
index 5df9ccb..f022130 100755
--- a/tests/btrfs/007
+++ b/tests/btrfs/007
@@ -74,7 +74,7 @@ workout()
 	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n $ops $FSSTRESS_AVOID -x \
 		"$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/base"

-	run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/incr
+	_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/incr

 	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap" \
 		>> $seqres.full
@@ -97,10 +97,10 @@ workout()
 		|| _fail "size=$fsz mkfs failed"
 	run_check _scratch_mount "-o noatime"

-	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/base.snap
+	_run_btrfs_util_prog receive $SCRATCH_MNT < $tmp/base.snap
 	run_check $FSSUM_PROG -r $tmp/base.fssum $SCRATCH_MNT/base

-	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/incr.snap
+	_run_btrfs_util_prog receive $SCRATCH_MNT < $tmp/incr.snap
 	run_check $FSSUM_PROG -r $tmp/incr.fssum $SCRATCH_MNT/incr
 }

diff --git a/tests/btrfs/022 b/tests/btrfs/022
index ab256a3..16e1ead 100755
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -49,15 +49,15 @@ rm -f $seqres.full
 # Test to make sure we can actually turn it on and it makes sense
 _basic_test()
 {
-	run_check $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/a
-	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT/a
+	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
+	_run_btrfs_util_prog quota enable $SCRATCH_MNT/a
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
 	$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | grep $subvolid >> \
 		$seqres.full 2>&1
 	[ $? -eq 0 ] || _fail "couldn't find our subvols quota group"
 	run_check $FSSTRESS_PROG -d $SCRATCH_MNT/a -w -p 1 -n 2000 \
 		$FSSTRESS_AVOID
-	run_check $BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT/a \
+	_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT/a \
 		$SCRATCH_MNT/b

 	# the shared values of both the original subvol and snapshot should
@@ -75,8 +75,8 @@ _basic_test()
 _rescan_test()
 {
 	# first with a blank subvol
-	run_check $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/a
-	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT/a
+	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
+	_run_btrfs_util_prog quota enable $SCRATCH_MNT/a
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
 	run_check $FSSTRESS_PROG -d $SCRATCH_MNT/a -w -p 1 -n 2000 \
 		$FSSTRESS_AVOID
@@ -85,7 +85,7 @@ _rescan_test()
 	echo $output >> $seqres.full
 	refer=$(echo $output | awk '{ print $2 }')
 	excl=$(echo $output | awk '{ print $3 }')
-	run_check $BTRFS_UTIL_PROG quota rescan -w $SCRATCH_MNT
+	_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
 	output=$($BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | grep $subvolid)
 	echo $output >> $seqres.full
 	[ $refer -eq $(echo $output | awk '{ print $2 }') ] || \
@@ -97,10 +97,10 @@ _rescan_test()
 #basic exceed limit testing
 _limit_test_exceed()
 {
-	run_check $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/a
-	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
+	_run_btrfs_util_prog quota enable $SCRATCH_MNT
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
-	run_check $BTRFS_UTIL_PROG qgroup limit 5M 0/$subvolid $SCRATCH_MNT
+	_run_btrfs_util_prog qgroup limit 5M 0/$subvolid $SCRATCH_MNT
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=10M count=1 >> \
 		$seqres.full 2>&1
 	[ $? -ne 0 ] || _fail "quota should have limited us"
@@ -109,10 +109,10 @@ _limit_test_exceed()
 #basic noexceed limit testing
 _limit_test_noexceed()
 {
-	run_check $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/a
-	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+	_run_btrfs_util_prog subvolume create $SCRATCH_MNT/a
+	_run_btrfs_util_prog quota enable $SCRATCH_MNT
 	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
-	run_check $BTRFS_UTIL_PROG qgroup limit 5M 0/$subvolid $SCRATCH_MNT
+	_run_btrfs_util_prog qgroup limit 5M 0/$subvolid $SCRATCH_MNT
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
 		$seqres.full 2>&1
 	[ $? -eq 0 ] || _fail "should have been allowed to write"
diff --git a/tests/btrfs/025 b/tests/btrfs/025
index 01b1f86..76ec2dd 100755
--- a/tests/btrfs/025
+++ b/tests/btrfs/025
@@ -55,25 +55,25 @@ _scratch_mkfs >/dev/null 2>&1
 _scratch_mount

 run_check $XFS_IO_PROG -f -c "truncate 819200" $SCRATCH_MNT/foo
-run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT

 run_check $XFS_IO_PROG -c "falloc -k 819200 667648" $SCRATCH_MNT/foo
-run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT

 run_check $XFS_IO_PROG -c "pwrite 1482752 2978" $SCRATCH_MNT/foo
-run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT

-run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT \
     $SCRATCH_MNT/mysnap1

 run_check $XFS_IO_PROG -c "truncate 883305" $SCRATCH_MNT/foo
-run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT

-run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT \
     $SCRATCH_MNT/mysnap2

-run_check $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
-run_check $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
     -f $tmp/2.snap 2>&1

 md5sum $SCRATCH_MNT/foo | _filter_scratch
@@ -85,10 +85,10 @@ _check_btrfs_filesystem $SCRATCH_DEV
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount

-run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
 md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch

-run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
 md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch

 _scratch_unmount
-- 
1.8.1.4


.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
