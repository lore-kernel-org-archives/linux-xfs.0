Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbcIULA0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Sep 2016 07:00:26 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] fstests: test xfs_copy V5 XFS without -d option
Date: Wed, 21 Sep 2016 19:00:20 +0800
Message-Id: <1474455620-25982-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>

>From linux v4.3 and xfsprogs v4.2, xfs_copy support to copy a V5 XFS.
Before that, copy a V5 XFS will cause target fs corruption, and only
use "-d" option can resolve that problem.

For this old reason, xfstests use below patch to add '-d' option to
xfs_copy, make sure xfs_copy always use that option if it try to copy
a V5 XFS:

  8346e53 common: append -d option to XFS_COPY_PROG when testing v5 xfs

But xfs_copy full support v5 xfs now. So xfstest miss the coverage of
copy a V5 XFS without '-d'. For test this feature I did below things:

  1. Revert commit 8346e53
  2. Add a new common function _require_xfs_copy(), if a test try to
     use old xfsprogs to copy a V5 xfs, it'll skip that test.
  3. Add above common function into all xfs_copy related cases.
  4. xfs/073 test V4 xfs forcibly by specify "-m crc=0" in case. I
     think it's useless now, so remove it.

There's a xfs_copy related case I didn't add _require_xfs_copy()
to it -- xfs/032, due to it tests "xfs_copy -d" directly.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 common/rc     | 27 ++++++++++++++++++++++-----
 tests/xfs/073 |  9 +++------
 tests/xfs/077 |  1 +
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/common/rc b/common/rc
index 13afc6a..9ba073b 100644
--- a/common/rc
+++ b/common/rc
@@ -3789,11 +3789,6 @@ init_rc()
 	# Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
 	xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
 	export XFS_IO_PROG="$XFS_IO_PROG -F"
-
-	# xfs_copy doesn't work on v5 xfs yet without -d option
-	if [ "$FSTYP" == "xfs" ] && [[ $MKFS_OPTIONS =~ crc=1 ]]; then
-		export XFS_COPY_PROG="$XFS_COPY_PROG -d"
-	fi
 }
 
 # get real device path name by following link
@@ -3994,6 +3989,28 @@ _require_xfs_mkfs_without_validation()
 	fi
 }
 
+# Make sure xfs_copy full support to copy V5 XFS, due to old xfs_copy can't
+# yet copy V5 xfs without '-d'. But if xfs_copy can't copy V4 XFS, that's a
+# bug.
+_require_xfs_copy()
+{
+	_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+	. $tmp.mkfs
+
+	${XFS_COPY_PROG} $SCRATCH_DEV $tmp.copy >/dev/null 2>&1
+	local rc=$?
+
+	rm -f $tmp.mkfs
+	rm -f $tmp.copy 2>/dev/null
+	if [ $rc -ne 0 ]; then
+		if [ $_fs_has_crcs -eq 1 ]; then
+			_notrun "This test requires xfs_copy support to copy V5 xfs without -d"
+		else
+			_fail "xfs_copy can't copy a V4 xfs"
+		fi
+	fi
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/xfs/073 b/tests/xfs/073
index 9e29223..02e45d5 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -134,11 +134,12 @@ _require_attrs
 [ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
 
 _require_scratch
+_require_xfs_copy
 _require_loop
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 >>$seqres.full 2>&1
+_scratch_mkfs_xfs -dsize=41m,agcount=2 >>$seqres.full 2>&1
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
 echo
@@ -158,11 +159,7 @@ _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
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
diff --git a/tests/xfs/077 b/tests/xfs/077
index 007d05d..7bcbfb5 100755
--- a/tests/xfs/077
+++ b/tests/xfs/077
@@ -51,6 +51,7 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux
 _require_scratch
+_require_xfs_copy
 _require_xfs_crc
 _require_meta_uuid
 
-- 
2.7.4

