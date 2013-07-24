Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D8BC7F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 12:01:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F7CD8F8049
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 10:01:54 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.136]) by
	cuda.sgi.com with ESMTP id nGrXInwqkHrsNQ1E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 10:01:49 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] xfstest: don't remove the two first devices from
	SCRATCH_DEV_POOL
Date: Wed, 24 Jul 2013 19:01:44 +0200
Message-Id: <1374685304-2510-1-git-send-email-sbehrens@giantdisaster.de>
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
 common/config   |  3 +--
 common/rc       | 12 ++++++++++++
 tests/btrfs/264 |  3 ++-
 tests/btrfs/265 | 12 ++++++------
 tests/btrfs/307 |  4 ++--
 5 files changed, 23 insertions(+), 11 deletions(-)

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
index 5cb1fe2..1caf9cc 100644
--- a/common/rc
+++ b/common/rc
@@ -546,6 +546,18 @@ _scratch_mkfs()
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
diff --git a/tests/btrfs/264 b/tests/btrfs/264
index b08667a..996c187 100755
--- a/tests/btrfs/264
+++ b/tests/btrfs/264
@@ -45,8 +45,9 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_scratch_dev_pool
 
-_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
 # Create and save sha256sum
diff --git a/tests/btrfs/265 b/tests/btrfs/265
index 79a9ddf..5bd6944 100755
--- a/tests/btrfs/265
+++ b/tests/btrfs/265
@@ -56,7 +56,7 @@ _require_deletable_scratch_dev_pool
 _test_raid0()
 {
 	export MKFS_OPTIONS="-m raid0 -d raid0"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -66,7 +66,7 @@ _test_raid0()
 _test_raid1()
 {
 	export MKFS_OPTIONS="-m raid1 -d raid1"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -76,7 +76,7 @@ _test_raid1()
 _test_raid10()
 {
 	export MKFS_OPTIONS="-m raid10 -d raid10"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -86,7 +86,7 @@ _test_raid10()
 _test_single()
 {
 	export MKFS_OPTIONS="-m single -d single"
-	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
@@ -106,7 +106,7 @@ _test_add()
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
-	for i in `seq 1 $n`; do
+	for i in `seq 2 $n`; do
 		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
 	done
 	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
@@ -162,7 +162,7 @@ _test_replace()
 
 _test_remove()
 {
-	_scratch_mkfs "$SCRATCH_DEV_POOL" > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
diff --git a/tests/btrfs/307 b/tests/btrfs/307
index 87314c6..20d8664 100755
--- a/tests/btrfs/307
+++ b/tests/btrfs/307
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
1.8.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
