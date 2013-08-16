Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 061797F5A
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 10:18:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BA79AC005
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 08:18:51 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.138]) by
	cuda.sgi.com with ESMTP id 5JcWLONBHEXZaWiQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Aug 2013 08:18:48 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH V2] xfstests: redirect output in btrfs/003
Date: Fri, 16 Aug 2013 17:18:43 +0200
Message-Id: <1376666323-27012-1-git-send-email-sbehrens@giantdisaster.de>
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
Cc: linux-btrfs@vger.kernel.org

This test failed for me with output from 'btrfs balance':
     QA output created by 003
    +Done, had to relocate 4 out of 4 chunks
    +Done, had to relocate 5 out of 5 chunks
     Silence is golden

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
V1 -> V2:
Redirect errors to $seqres.full as proposed by Eric.

 tests/btrfs/003 | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 3790935..5c88651 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -52,11 +52,13 @@ _require_scratch
 _require_scratch_dev_pool
 _require_deletable_scratch_dev_pool
 
+rm -f $seqres.full
+
 # Test cases related to raid in btrfs
 _test_raid0()
 {
 	export MKFS_OPTIONS="-m raid0 -d raid0"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -66,7 +68,7 @@ _test_raid0()
 _test_raid1()
 {
 	export MKFS_OPTIONS="-m raid1 -d raid1"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -76,7 +78,7 @@ _test_raid1()
 _test_raid10()
 {
 	export MKFS_OPTIONS="-m raid10 -d raid10"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -86,7 +88,7 @@ _test_raid10()
 _test_single()
 {
 	export MKFS_OPTIONS="-m single -d single"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -102,14 +104,14 @@ _test_add()
 	n=$(($n-1))
 
 	export MKFS_OPTIONS=""
-	_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
 	for i in `seq 1 $n`; do
-		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
+		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "device add failed"
 	done
-	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "balance failed"
 	umount $SCRATCH_MNT
 }
 
@@ -127,7 +129,7 @@ _test_replace()
 	ds=${devs[@]:0:$n}
 
 	export MKFS_OPTIONS="-m raid1 -d raid1"
-	_scratch_mkfs "$ds" > /dev/null 2>&1 || _fail "tr: mkfs failed"
+	_scratch_mkfs "$ds" >> $seqres.full 2>&1 || _fail "tr: mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -143,16 +145,16 @@ _test_replace()
 	_devmgt_remove ${DEVHTL}
 	dev_removed=1
 
-	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null || _fail \
+	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
 							"btrfs did not report device missing"
 
 	# add a new disk to btrfs
 	ds=${devs[@]:$(($n)):1}
-	$BTRFS_UTIL_PROG device add ${ds} $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev add failed"
+	$BTRFS_UTIL_PROG device add ${ds} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "dev add failed"
 	# in some system balance fails if there is no delay (a bug)
 	# putting sleep 10 to work around as of now
 	# sleep 10
-	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "dev balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "dev balance failed"
 
 	# cleaup. add the removed disk
 	umount $SCRATCH_MNT
@@ -162,7 +164,7 @@ _test_replace()
 
 _test_remove()
 {
-	_scratch_mkfs "$SCRATCH_DEV_POOL" > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mkfs "$SCRATCH_DEV_POOL" >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -170,7 +172,7 @@ _test_remove()
 	# pick last dev in the list
 	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
 	$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
-	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del > /dev/null && _fail "btrfs still shows the deleted dev"
+	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del >> $seqres.full && _fail "btrfs still shows the deleted dev"
 	umount $SCRATCH_MNT
 }
 
-- 
1.8.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
