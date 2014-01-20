Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6559B7F5F
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 00:22:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D0D7304048
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 22:22:50 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aSB5LT2aCMmkUdty for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 22:22:48 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W58Fs-0004Km-Kn
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W58Fs-0004Tz-K7
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] xfs: New _require_* tests for CRC enabled filesystems
Date: Mon, 20 Jan 2014 17:22:32 +1100
Message-Id: <1390198957-17184-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1390198957-17184-1-git-send-email-david@fromorbit.com>
References: <1390198957-17184-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

CRCs always enabled 32 bit project inodes and attr2 formats, hence
they cannot be turned off. Add new require rules for the tests that
require attr and 16 bit project IDs so these tests are avoided on
CRC enabled filesystems.

Also, add a xfs_db write check so that we can avoid tests that are
dependent on xfs_db modifying filesystem structures as they will
fail on CRC enabled filessystems right now. This is just temporary
until full write xfs_db support is available.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/attr      |  6 ++++++
 common/rc        | 11 ++++++++---
 tests/shared/298 |  2 +-
 tests/xfs/186    |  1 +
 tests/xfs/187    | 32 ++++++++++++++++++--------------
 tests/xfs/244    |  1 +
 tests/xfs/278    |  1 +
 tests/xfs/287    |  3 ++-
 tests/xfs/291    |  2 +-
 9 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/common/attr b/common/attr
index 4a3ac9e..1f3e57f 100644
--- a/common/attr
+++ b/common/attr
@@ -190,6 +190,12 @@ _require_attrs()
     rm -f $TEST_DIR/syscalltest.out
 }
 
+_require_attr_v1()
+{
+	_scratch_mkfs_xfs_supported -i attr=1 >/dev/null 2>&1 \
+		|| _notrun "attr v1 not supported on $SCRATCH_DEV"
+}
+
 # getfattr -R returns info in readdir order which varies from fs to fs.
 # This sorts the output by filename
 _sort_getfattr_output()
diff --git a/common/rc b/common/rc
index 7a96484..d497818 100644
--- a/common/rc
+++ b/common/rc
@@ -1144,13 +1144,18 @@ _require_dm_flakey()
     fi
 }
 
-# this test requires the projid32bit feature to be available in
-# mkfs.xfs
+# this test requires the projid32bit feature to be available in mkfs.xfs.
 #
 _require_projid32bit()
 {
+       _scratch_mkfs_xfs_supported -i projid32bit=1 >/dev/null 2>&1 \
+	   || _notrun "mkfs.xfs doesn't have projid32bit feature"
+}
+
+_require_projid16bit()
+{
 	_scratch_mkfs_xfs_supported -i projid32bit=0 >/dev/null 2>&1 \
-		|| _notrun "mkfs.xfs doesn't have projid32bit feature"
+	   || _notrun "16 bit project IDs not supported on $SCRATCH_DEV"
 }
 
 # this test requires the crc feature to be available in mkfs.xfs
diff --git a/tests/shared/298 b/tests/shared/298
index 4541798..6b5402c 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -70,7 +70,7 @@ get_free_sectors()
 	agsize=`xfs_info $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
 	# Convert free space (agno, block, length) to (start sector, end sector)
 	$UMOUNT_PROG $loop_mnt
-	$XFS_DB_PROG -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
+	$XFS_DB_PROG -r -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
 		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
 		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
 	;;
diff --git a/tests/xfs/186 b/tests/xfs/186
index 960aed1..8e18975 100755
--- a/tests/xfs/186
+++ b/tests/xfs/186
@@ -147,6 +147,7 @@ _supported_os Linux
 
 _require_scratch
 _require_attrs
+_require_attr_v1
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/187 b/tests/xfs/187
index 9cf1305..700ab04 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -58,20 +58,24 @@ _supported_os Linux
 
 _require_scratch
 _require_attrs
+_require_attr_v1
+_require_projid16bit
 
 rm -f $seqres.full
 
-# lazysb and attr2 are in features2 and will require morebitsbit on
-# So test with lazysb and without it to see if the morebitsbit is
-# okay etc....
 # Reset the options so that we can control what is going on here
 export MKFS_OPTIONS=""
 export MOUNT_OPTIONS=""
 
+# lazysb, attr2 and other feature bits are held in features2 and will require
+# morebitsbit on So test with lazysb and without it to see if the morebitsbit is
+# okay etc. If the mkfs defaults change, these need to change as well.
+export MKFS_NO_LAZY="-l lazy-count=0 -i projid32bit=0"
+export MKFS_LAZY="-l lazy-count=1 -i projid32bit=0"
+
 # Make sure that when we think we are testing with morebits off
 # that we really are.
-# Trying to future-proof in case mkfs defaults change.
-_scratch_mkfs -i attr=1 -l lazy-count=0 >/dev/null 2>&1
+_scratch_mkfs -i attr=1 $MKFS_NO_LAZY  >/dev/null 2>&1
 $XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
 if grep -i morebits $tmp.db
 then
@@ -86,14 +90,14 @@ echo "*** 1. test attr2 mkfs and then noattr2 mount ***"
 echo ""
 echo "attr2 fs"
 echo ""
-_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
+$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
 _scratch_mount -o noattr2
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 
 # adding an EA will ensure the ATTR1 flag is turned on
 echo ""
@@ -101,8 +105,8 @@ echo "*** 2. test attr2 mkfs and then noattr2 mount with 1 EA ***"
 echo ""
 echo "attr2 fs"
 echo ""
-_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
+$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
@@ -113,7 +117,7 @@ $SETFATTR_PROG -n user.test -v 0xbabe testfile
 $GETFATTR_PROG testfile
 cd $here
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 
 echo ""
 echo "*** 3. test noattr2 mount and lazy sb ***"
@@ -121,8 +125,8 @@ echo ""
 echo ""
 echo "attr2 fs"
 echo ""
-_scratch_mkfs -i attr=2 -l lazy-count=1 >/dev/null 2>&1
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_mkfs -i attr=2 $MKFS_LAZY >/dev/null 2>&1
+$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
@@ -131,7 +135,7 @@ cd $SCRATCH_MNT
 touch testfile
 cd $here
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 
 # success, all done
 status=0
diff --git a/tests/xfs/244 b/tests/xfs/244
index d899a3d..6dd8224 100755
--- a/tests/xfs/244
+++ b/tests/xfs/244
@@ -48,6 +48,7 @@ _supported_fs xfs
 _require_xfs_quota
 _require_scratch
 _require_projid32bit
+_require_projid16bit
 
 export MOUNT_OPTIONS="-opquota"
 
diff --git a/tests/xfs/278 b/tests/xfs/278
index 938717d..dacd1fc 100755
--- a/tests/xfs/278
+++ b/tests/xfs/278
@@ -46,6 +46,7 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux
 _require_scratch
+
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
diff --git a/tests/xfs/287 b/tests/xfs/287
index 10853d1..445610b 100755
--- a/tests/xfs/287
+++ b/tests/xfs/287
@@ -45,7 +45,7 @@ _cleanup()
 
 _print_projid()
 {
-	$XFS_DB_PROG -c "inode $1" \
+	$XFS_DB_PROG -r -c "inode $1" \
 		-c "print core.projid_lo" \
 		-c "print core.projid_hi" \
 		$SCRATCH_DEV
@@ -56,6 +56,7 @@ _supported_fs xfs
 _require_xfs_quota
 _require_scratch
 _require_projid32bit
+_require_projid16bit
 
 # create xfs fs without projid32bit ability, will be gained by xfs_admin
 _scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seqres.full \
diff --git a/tests/xfs/291 b/tests/xfs/291
index 7723b9e..03c4de9 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -70,7 +70,7 @@ xfs_io -f -c "pwrite 0 16m" -c "fsync" $SCRATCH_MNT/space_file.large >> $seqres.
 
 # Take a look at freespace for any post-mortem on the test
 _scratch_unmount
-xfs_db -c freesp $SCRATCH_DEV >> $seqres.full 2>&1
+xfs_db -r -c freesp $SCRATCH_DEV >> $seqres.full 2>&1
 _scratch_mount
 
 # Step 2: Make a bunch of (hopefully fragmented) multiblock
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
