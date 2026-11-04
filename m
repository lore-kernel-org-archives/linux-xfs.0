Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818075;
	b=xvHAan4KyLM7QPjm01OtG0yurcWOy/WdN2c566TY5KomuUwvh5xs0WDs0ktIKAyL/1z3
	 fJxB3h2xzcd9z8Z7gef9rsMljFzufEwZheKmumyVSXAz/h3FXklL8F8xerQDXBRduFgK6
	 B+pyR5YRalAasO2tiUezA9CDa3XMIZ72p6/yNafh8twVl4G3xqHjxNpvmuBDAktzuR0XW
	 0rRQyn1SLveeIsY6XUd1+NrzK9I3FUQiV7kJD0xXqiIBVYDA2IJ2Syw7X03ghEuO5FCrp
	 fokX53u87FbxoCXUkRjnKl1Ektg0Sri/hzCgDfLDB0fk8fk9C+zzV9jd8IHiJk3FNqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ys/2zSf63P0U1y8dSq39V/vmN736YNx+y30b8Wp+P6g=;
	b=AQAqMSw98zKKB8aJIOyahDlAGB0smU+CPcIDWcPg0e0R7R5fX9gQALpNvNQH7X8mKxHD
	 9ZzZHeOR8Qzc+itc+RMewsnkVCt1kAxfa0ORDt98PCcmcfSChXIcvYRBV/g9R0SA95d6y
	 Kw02SqXwWxOyjf90xm2tuGQB3OqAL/T5xmQFGVdPWrfOAawNdSc8QnayanGT3dEUatrhU
	 M1EqyihVBKEjebFluFjgpepz0+WRzjOTWxhjZQoMZ+KawTN7ovbezVKGTvmXwMoQ7Ao4i
	 /wjAwA3NdnNLZxKhpOoZC0vX5xguBsQxnBpcTJbCpdzu1LxJhmPmm4ikLGFCjen8Rwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lPv48D0n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B8606A339;
	Wed,  4 Nov 2026 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lPv48D0n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE281F000C1;
	Wed,  4 Nov 2026 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793818074;
	bh=Ys/2zSf63P0U1y8dSq39V/vmN736YNx+y30b8Wp+P6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPv48D0nxbx9wPp5j0LvVqUrotPttdS4kxag6g+fpDlzy1BDG48aEqzU8WSK5NjgV
	 6Ih/a4hteX87Tj6lrAYXFj5HKvvD/aiStX/7vW61PkgJso9XfcT/GBkanB9EszHShQ
	 rn7JHLbsh1oPdWmoZ+ko4uAcx2oUQz+Anb3XULffaZLpWI+5RLCjdYN/i10pkdtufR
	 VysJOjTKIodLqaUVs8OUwciOLsbXi/hUKbTojFDXfi2kmiPkE8e2YW0p3V55gH6DuH
	 4Y18IY0gPkAhp2/69k2lE7zLWXcXkUlu419drWM/5oajhN+TmzBPJswnm6ZFG36d4b
	 rK4XPaB5g4HFg==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 2/6] fstests: consolidate _require_fs_sysfs and _require_fs_sysfs_dev_attr
Date: Thu,  5 Nov 2026 02:47:32 +0800
Message-ID: <20261104184736.1564283-3-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104184736.1564283-1-zlang@kernel.org>
References: <20261104184736.1564283-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is heavy overlap between _require_fs_sysfs and
_require_fs_sysfs_dev_attr, and their ambiguous names make it
difficult to tell them apart.

Make _require_fs_sysfs_dev_attr a generic helper that requires both
a device and an attribute, remove _has_fs_sysfs and _require_fs_sysfs,
and add _require_test_sysfs_dev_attr and _require_scratch_sysfs_dev_attr
wrappers.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/rc       | 28 +++++++++++++++-------------
 common/xfs      |  6 ++++--
 tests/btrfs/253 |  4 ++--
 tests/btrfs/285 |  2 +-
 tests/btrfs/334 |  2 +-
 tests/f2fs/025  |  2 +-
 tests/xfs/006   |  2 +-
 tests/xfs/177   |  2 +-
 tests/xfs/264   |  6 +++---
 9 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/common/rc b/common/rc
index 43c95930..036b75d4 100644
--- a/common/rc
+++ b/common/rc
@@ -5545,6 +5545,7 @@ _has_fs_sysfs_dev_attr()
 }
 
 # Require the existence of a sysfs entry at /sys/fs/$FSTYP/$DEV/$ATTR
+#
 # All arguments are necessary, and in this order:
 #  - dev: device name, e.g. $SCRATCH_DEV
 #  - attr: path name under /sys/fs/$FSTYP/$dev
@@ -5562,27 +5563,28 @@ _require_fs_sysfs_dev_attr()
 	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
 }
 
-# Test for the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
+# Require the existence of a sysfs entry at /sys/fs/$FSTYP/$TEST_DEV/$ATTR
 #
 # Only one argument is needed:
-#  - attr: path name under /sys/fs/$FSTYP/DEV
+#  - attr: path name under /sys/fs/$FSTYP/$TEST_DEV
 #
 # Usage example:
-#   _has_fs_sysfs error/fail_at_unmount
-_has_fs_sysfs()
+#   _require_test_sysfs_dev_attr error/fail_at_unmount
+_require_test_sysfs_dev_attr()
 {
-	_has_fs_sysfs_dev_attr $TEST_DEV "$@"
+	_require_fs_sysfs_dev_attr $TEST_DEV "$1"
 }
 
-# Require the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
-_require_fs_sysfs()
+# Require the existence of a sysfs entry at /sys/fs/$FSTYP/$SCRATCH_DEV/$ATTR
+#
+# Only one argument is needed:
+#  - attr: path name under /sys/fs/$FSTYP/$SCRATCH_DEV
+#
+# Usage example:
+#   _require_scratch_sysfs_dev_attr error/fail_at_unmount
+_require_scratch_sysfs_dev_attr()
 {
-	_has_fs_sysfs "$@" && return
-
-	local attr=$1
-	local dname=$(_short_dev $TEST_DEV)
-
-	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
+	_require_fs_sysfs_dev_attr $SCRATCH_DEV "$1"
 }
 
 # Generic test for specific filesystem feature.
diff --git a/common/xfs b/common/xfs
index 8bd144e3..d569566f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1226,13 +1226,15 @@ _xfs_prepare_for_eio_shutdown()
 	_add_dmesg_filter "Internal error"
 
 	# Don't retry any writes during the (presumably) post-shutdown unmount
-	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 1
+	_has_fs_sysfs_dev_attr $dev "$ctlfile" && \
+		_set_fs_sysfs_dev_attr $dev "$ctlfile" 1
 
 	# Disable retry of metadata writes that fail with EIO
 	for ctl in max_retries retry_timeout_seconds; do
 		ctlfile="error/metadata/EIO/$ctl"
 
-		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
+		_has_fs_sysfs_dev_attr $dev "$ctlfile" && \
+			_set_fs_sysfs_dev_attr $dev "$ctlfile" 0
 	done
 }
 
diff --git a/tests/btrfs/253 b/tests/btrfs/253
index d8b58f49..88ac0b4d 100755
--- a/tests/btrfs/253
+++ b/tests/btrfs/253
@@ -90,8 +90,8 @@ _scratch_mkfs_sized $((10 * 1024 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 # Check if there is sufficient sysfs support.
-_require_fs_sysfs allocation/metadata/chunk_size
-_require_fs_sysfs allocation/metadata/force_chunk_alloc
+_require_test_sysfs_dev_attr allocation/metadata/chunk_size
+_require_test_sysfs_dev_attr allocation/metadata/force_chunk_alloc
 
 # Get free space.
 free_space  FREE_SPACE_MB
diff --git a/tests/btrfs/285 b/tests/btrfs/285
index 5ceb69d4..d8a70572 100755
--- a/tests/btrfs/285
+++ b/tests/btrfs/285
@@ -16,7 +16,7 @@ sysfs_size_classes() {
 
 _require_scratch
 _require_btrfs_fs_sysfs
-_require_fs_sysfs allocation/data/size_classes
+_require_test_sysfs_dev_attr allocation/data/size_classes
 
 f="$SCRATCH_MNT/f"
 small=$((16 * 1024))
diff --git a/tests/btrfs/334 b/tests/btrfs/334
index 08b66dc7..5f97ec20 100755
--- a/tests/btrfs/334
+++ b/tests/btrfs/334
@@ -13,7 +13,7 @@ _begin_fstest auto quick
 . ./common/filter
 
 _require_test
-_require_fs_sysfs_dev_attr $TEST_DEV allocation/data/chunk_size
+_require_test_sysfs_dev_attr allocation/data/chunk_size
 
 _verify_sysfs_syntax $TEST_DEV allocation/data/chunk_size 256m
 
diff --git a/tests/f2fs/025 b/tests/f2fs/025
index 31dd56a8..433f900e 100755
--- a/tests/f2fs/025
+++ b/tests/f2fs/025
@@ -21,7 +21,7 @@ _require_scratch_shutdown
 _require_xfs_io_command "pwrite"
 _require_xfs_io_command "truncate"
 _require_f2fs_io_command gc_urgent
-_require_fs_sysfs_dev_attr $TEST_DEV gc_urgent
+_require_test_sysfs_dev_attr gc_urgent
 _require_check_dmesg
 
 # Clear options to avoid interference from external configurations
diff --git a/tests/xfs/006 b/tests/xfs/006
index e03ade1d..b9816051 100755
--- a/tests/xfs/006
+++ b/tests/xfs/006
@@ -25,7 +25,7 @@ _cleanup()
 
 _require_scratch
 _require_dm_target error
-_require_fs_sysfs error/fail_at_unmount
+_require_test_sysfs_dev_attr error/fail_at_unmount
 
 _scratch_mkfs > $seqres.full 2>&1
 _dmerror_init
diff --git a/tests/xfs/177 b/tests/xfs/177
index 38b68a7d..33030f42 100755
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -48,7 +48,7 @@ _require_scratch
 
 # We require /sys/fs/xfs/$device/stats/stats to monitor per-filesystem inode
 # cache usage.
-_require_fs_sysfs stats/stats
+_require_test_sysfs_dev_attr stats/stats
 
 count_xfs_inode_objs() {
 	_get_fs_sysfs_dev_attr $SCRATCH_DEV stats/stats | awk '/vnodes/ {print $2}'
diff --git a/tests/xfs/264 b/tests/xfs/264
index c8a2f714..171e703d 100755
--- a/tests/xfs/264
+++ b/tests/xfs/264
@@ -24,9 +24,9 @@ _cleanup()
 
 _require_scratch
 _require_dm_target error
-_require_fs_sysfs error/fail_at_unmount
-_require_fs_sysfs error/metadata/EIO/max_retries
-_require_fs_sysfs error/metadata/EIO/retry_timeout_seconds
+_require_test_sysfs_dev_attr error/fail_at_unmount
+_require_test_sysfs_dev_attr error/metadata/EIO/max_retries
+_require_test_sysfs_dev_attr error/metadata/EIO/retry_timeout_seconds
 
 _scratch_mkfs >> $seqres.full 2>&1
 _dmerror_init
-- 
2.56.0

