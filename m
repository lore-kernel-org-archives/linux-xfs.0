Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A59F7F6F
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 04:08:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AA7F304043
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 02:08:45 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.141]) by
	cuda.sgi.com with ESMTP id X8BzHslOPBbGM3Ys (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 02:08:43 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH V2] xfstests: don't remove the two first devices from
	SCRATCH_DEV_POOL
Date: Mon, 19 Aug 2013 11:08:37 +0200
Message-Id: <1376903317-28006-1-git-send-email-sbehrens@giantdisaster.de>
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

Since common/config is executed twice, if SCRATCH_DEV_POOL is configured
via the environment, the current code removes the first device entry twice
which means that you lose the second device for the test.

The fix is to not remove anything from SCRATCH_DEV_POOL anymore.
That used to be done (I can only guess) to allow to pass the
SCRATCH_DEV_POOL as an argument to _scratch_mkfs. Since _scratch_mkfs adds
the SCRATCH_DEV, the pool mustn't contain that device anymore.

A new function _scratch_pool_mkfs is introduced that does the expected
thing.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
V1 -> V2:
- rebased.
- fixed a missing adaption to the new way to deal with SCRATCH_DEV_POOL
  in  _test_replace() in tests/btrfs/003.

 common/config   |  3 +--
 common/rc       | 12 ++++++++++++
 tests/btrfs/002 |  3 ++-
 tests/btrfs/003 | 18 +++++++++---------
 tests/btrfs/006 |  4 ++--
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/common/config b/common/config
index 67c1498..1bc9233 100644
--- a/common/config
+++ b/common/config
@@ -252,14 +252,13 @@ if [ ! -d "$TEST_DIR" ]; then
 fi
 
 # a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
-# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
+# to SCRATCH_DEV to maintain the backward compatibility
 if [ ! -z "$SCRATCH_DEV_POOL" ]; then
     if [ ! -z "$SCRATCH_DEV" ]; then
         echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
         exit 1
     fi
     SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
-    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
 fi
 
 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
diff --git a/common/rc b/common/rc
index a761833..80266b4 100644
--- a/common/rc
+++ b/common/rc
@@ -550,6 +550,18 @@ _scratch_mkfs()
     esac
 }
 
+_scratch_pool_mkfs()
+{
+    case $FSTYP in
+    btrfs)
+	$MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV_POOL > /dev/null
+	;;
+    *)
+	echo "_scratch_pool_mkfs is not implemented for $FSTYP" 1>&2
+	;;
+    esac
+}
+
 # Create fs of certain size on scratch device
 # _scratch_mkfs_sized <size in bytes> [optional blocksize]
 _scratch_mkfs_sized()
diff --git a/tests/btrfs/002 b/tests/btrfs/002
index 03e9137..f4389ae 100755
--- a/tests/btrfs/002
+++ b/tests/btrfs/002
@@ -45,8 +45,9 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_scratch_dev_pool
 
-_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
 # Create and save sha256sum
diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 5c88651..a23d3a0 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -58,7 +58,7 @@ rm -f $seqres.full
 _test_raid0()
 {
 	export MKFS_OPTIONS="-m raid0 -d raid0"
-	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -68,7 +68,7 @@ _test_raid0()
 _test_raid1()
 {
 	export MKFS_OPTIONS="-m raid1 -d raid1"
-	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -78,7 +78,7 @@ _test_raid1()
 _test_raid10()
 {
 	export MKFS_OPTIONS="-m raid10 -d raid10"
-	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -88,7 +88,7 @@ _test_raid10()
 _test_single()
 {
 	export MKFS_OPTIONS="-m single -d single"
-	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -108,7 +108,7 @@ _test_add()
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
-	for i in `seq 1 $n`; do
+	for i in `seq 2 $n`; do
 		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "device add failed"
 	done
 	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "balance failed"
@@ -124,9 +124,9 @@ _test_replace()
 	local d
 	local DEVHTL=""
 
-	# exclude the last disk in the disk pool
-	n=$(($n-1))
-	ds=${devs[@]:0:$n}
+	# exclude the first and the last disk in the disk pool
+	n=$(($n-2))
+	ds=${devs[@]:1:$n}
 
 	export MKFS_OPTIONS="-m raid1 -d raid1"
 	_scratch_mkfs "$ds" >> $seqres.full 2>&1 || _fail "tr: mkfs failed"
@@ -164,7 +164,7 @@ _test_replace()
 
 _test_remove()
 {
-	_scratch_mkfs "$SCRATCH_DEV_POOL" >> $seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
diff --git a/tests/btrfs/006 b/tests/btrfs/006
index f323cc4..8de815d 100755
--- a/tests/btrfs/006
+++ b/tests/btrfs/006
@@ -53,12 +53,12 @@ rm -f $seqres.full
 
 FIRST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
 LAST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $NF}'`
-TOTAL_DEVS=`echo $SCRATCH_DEV $SCRATCH_DEV_POOL | wc -w`
+TOTAL_DEVS=`echo $SCRATCH_DEV_POOL | wc -w`
 LABEL=TestLabel.$seq
 
 echo "Scratch $SCRATCH_DEV First $FIRST_POOL_DEV last $LAST_POOL_DEV Total $TOTAL_DEVS" > $seqres.full
 
-_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 
 # These have to be done unmounted...?
 echo "== Set filesystem label to $LABEL"
-- 
1.8.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
