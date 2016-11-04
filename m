Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932299AbcKDQHy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Nov 2016 12:07:54 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v4] fstests: test xfs_copy V5 XFS without -d option
Date: Sat,  5 Nov 2016 00:07:46 +0800
Message-Id: <1478275666-7908-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Before xfsprogs commit a872b62 (xfs_copy: band-aids for CRC
filesystems), xfs_copy requires the "-d" option to copy a V5 XFS,
because it can't rewrite the UUID of V5 XFS properly.

Now xfs_copy already full support to copy a V5 XFS. But for above
old problem, xfstests use below patch to make sure xfs_copy always
use "-d" option to copy a V5 XFS:

  8346e53 common: append -d option to XFS_COPY_PROG when testing v5 xfs

That cause xfstests miss the coverage of copying a V5 XFS without
"-d". For test this feature I did below things:

  1. Changed init_rc(), add "-d" to $XFS_COPY_PROG if xfs_copy can't
     copy a V5 XFS properly.
  2. xfs/073 test V4 xfs forcibly by specify "-m crc=0" in case. I
     think it's useless now, so remove it.
  3. Changed xfs/032. If xfs_copy full support to copy a V5 XFS, test
     with and without "-d" option, or only test with "-d" option.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2:
1. remove require_xfs_copy() function
2. change the code logic of init_rc function about how to add "-d" to
   $XFS_COPY_PROG
3. remove xfs_copy "-d" option of xfs/032

V3:
add comments to explain the change in init_rc()

V4:
Due to xfs/032 test "xfs_copy -d" by default, I don't want to
change the original test coverage. So if xfs_copy full support to
copy a V5 XFS, then test with and without "-d" option twice.

Thanks,
Zorro

 common/rc     | 15 ++++++++++++---
 tests/xfs/032 | 11 ++++++++++-
 tests/xfs/073 |  8 ++------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/common/rc b/common/rc
index a84efe4..7ff4f5d 100644
--- a/common/rc
+++ b/common/rc
@@ -3808,9 +3808,18 @@ init_rc()
 	$XFS_IO_PROG -i -c quit 2>/dev/null && \
 		export XFS_IO_PROG="$XFS_IO_PROG -i"
 
-	# xfs_copy doesn't work on v5 xfs yet without -d option
-	if [ "$FSTYP" == "xfs" ] && [[ $MKFS_OPTIONS =~ crc=1 ]]; then
-		export XFS_COPY_PROG="$XFS_COPY_PROG -d"
+	# xfs_copy on v5 filesystems do not require the "-d" option if xfs_db
+	# can change the UUID on v5 filesystems
+	if [ "$FSTYP" == "xfs" ]; then
+		touch $tmp.img
+		$MKFS_XFS_PROG $MKFS_OPTIONS -d file,name=$tmp.img,size=512m \
+							>/dev/null 2>&1
+		# xfs_db will return 0 even if it can't generate a new uuid, so
+		# check the output to make sure if it can change UUID of V5 xfs
+		$XFS_DB_PROG -x -c "uuid generate" $tmp.img \
+			| grep -q "invalid UUID\|supported on V5 fs" \
+			&& export XFS_COPY_PROG="$XFS_COPY_PROG -d"
+		rm -f $tmp.img
 	fi
 }
 
diff --git a/tests/xfs/032 b/tests/xfs/032
index 4b675ee..9fe9c23 100755
--- a/tests/xfs/032
+++ b/tests/xfs/032
@@ -70,12 +70,21 @@ while [ $SECTORSIZE -le $PAGESIZE ]; do
 		$FSSTRESS_PROG -n 100 -d $SCRATCH_MNT >> $seqres.full 2>&1
 		_scratch_unmount
 
-		$XFS_COPY_PROG -d $SCRATCH_DEV $IMGFILE >> $seqres.full 2>&1 || \
+		$XFS_COPY_PROG $SCRATCH_DEV $IMGFILE >> $seqres.full 2>&1 || \
 			_fail "Copy failed for Sector size $SECTORSIZE Block size $BLOCKSIZE"
 		# Must use "-n" to get exit code; without it xfs_repair always returns 0
 		$XFS_REPAIR_PROG -n -f $IMGFILE >> $seqres.full 2>&1 || \
 			_fail "Copy corrupted for Sector size $SECTORSIZE Block size $BLOCKSIZE"
 
+		# Test creating a duplicate filesystem, if last 2 steps didn't test it
+		if ! echo $$XFS_COPY_PROG | grep -q "xfs_copy .*-d"; then
+			$XFS_COPY_PROG -d $SCRATCH_DEV $IMGFILE >> $seqres.full 2>&1 || \
+				_fail "Duplicate(-d) copy failed for Sector size $SECTORSIZE Block size $BLOCKSIZE"
+			# Must use "-n" to get exit code; without it xfs_repair always returns 0
+			$XFS_REPAIR_PROG -n -f $IMGFILE >> $seqres.full 2>&1 || \
+				_fail "Duplicate(-d) copy corrupted for Sector size $SECTORSIZE Block size $BLOCKSIZE"
+		fi
+
 		BLOCKSIZE=$(($BLOCKSIZE * 2));
 	done
 	SECTORSIZE=$(($SECTORSIZE * 2));
diff --git a/tests/xfs/073 b/tests/xfs/073
index 9e29223..7228dd9 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -138,7 +138,7 @@ _require_loop
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 >>$seqres.full 2>&1
+_scratch_mkfs_xfs -dsize=41m,agcount=2 >>$seqres.full 2>&1
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
 echo
@@ -158,11 +158,7 @@ _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo 
 echo === copying scratch device to single target, large ro device
-mkfs_crc_opts="-m crc=0"
-if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-	mkfs_crc_opts=""
-fi
-${MKFS_XFS_PROG} $mkfs_crc_opts -dfile,name=$imgs.source,size=100g \
+${MKFS_XFS_PROG} -dfile,name=$imgs.source,size=100g \
 	| _filter_mkfs 2>/dev/null
 rmdir $imgs.source_dir 2>/dev/null
 mkdir $imgs.source_dir
-- 
2.7.4

