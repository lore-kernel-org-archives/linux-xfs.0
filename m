Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787502;
	b=3qKbtCGyB3iCGBosLaRtGOWLCDMa3AFj+TiCgyr36RyX2PC74M2Prh8snzP+6tqlsDT1
	 1cloR2wqaCoOiQObOqY4HReVu70YwgR/vLSDU9MHYtqX4AVNzZe4SV3WbUR+z94781J5A
	 MWz1iFLXemTDEoXDOTjBaHmpWVCkXDzk+JKda0uBYE4AnCmm0TqZQQFOf0rw3nOZzBuGB
	 xrh0v6aJBjOaLnYPU20gfGDEErBNeZSpFN+cwt5zBWbFyXcEXOaDbpRH07OfV/9D/g7N6
	 D72FnQUy2M1hbZCQypuOY54QGDqMPOXceJDYhUZ/B8kKRhUDUoYCXD2cAMaXr1p2Mig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1/1HecssCeLrwIPyr3j/LqOWXW8H4LZyuRbZpctSnXI=;
	b=aiPOkIhsQSsDixOYVDpbAi0FFB8enJ6pBDgANJw7mNdm2GIGfYJusYI04SktlBoGeBiW
	 uj8yfp/rNaUaaYygVo4mLp3f5NhzGDNsGb7LXb3incVRh4I86qsp2FWeE2eAxDgsAOAfl
	 dzldexgTqUejijhHLHU6XAuWnpXmIbTkZlJkSBgdLU5DPfDkEsBKmtSc8vS4jjPHdV+rh
	 xVW8GfRfvWau98sqO4peQgzPARNnhmhOWnzf4PUeEqDntkke8zsPRp/8QVCftiVsZIAFE
	 389CjwKb4NpmZ4c09I5d/Tl+9dlL51PgKQu2XdcAVjjwBvej0HMb26+DeImfe3c2hhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="PhsI/pRl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59848606A325;
	Fri, 23 Oct 2026 20:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhsI/pRl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9ABC1F01825;
	Fri, 23 Oct 2026 20:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787501;
	bh=1/1HecssCeLrwIPyr3j/LqOWXW8H4LZyuRbZpctSnXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhsI/pRlcwQ21c9HrhVKSF2IamhJZiDEO4Eh3uzZ5aPaluemaLvtdcwEjCN+KKBhl
	 x/GwFu1DdnCK7va1aMXxNXHgVBni/e6MKKIFvh/be5wfS+uPT8StTix3eYjiI7eLm3
	 cis08RtD8iVKFA/dT65UizzpY/2Coj1+vhkvoQI+C7pKwygiQ9KpgibEkgzFzwFN37
	 qgUei6XNxYtDAzBq2K7ssrt8JNpGGB3r/tgASS3DZx7r2Q6yha/ALCW/M/eUOhSnW0
	 A1qT82ux+uYBERHo/X2BKwxUrfdXkaG5NhzNZWnnuPAUfQ4xd+gZCjzTj2IxanCRQM
	 lChtHzJvalR3g==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 6/6] fstests: replace btrfs specific helpers with common sysfs helpers
Date: Sat, 24 Oct 2026 04:31:14 +0800
Message-ID: <20261023203114.1655019-7-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023203114.1655019-1-zlang@kernel.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
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

Switch from btrfs specific helpers to the generic sysfs helpers
across btrfs test cases, reduce code duplication.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/btrfs      | 37 ++-----------------------------------
 common/rc         |  3 ++-
 tests/btrfs/010   |  3 ++-
 tests/btrfs/055   |  2 +-
 tests/btrfs/056   |  2 +-
 tests/btrfs/112   |  2 +-
 tests/btrfs/131   |  2 +-
 tests/btrfs/165   |  2 +-
 tests/btrfs/188   |  2 +-
 tests/btrfs/192   |  2 +-
 tests/btrfs/201   |  2 +-
 tests/btrfs/205   |  2 +-
 tests/btrfs/209   |  2 +-
 tests/btrfs/211   |  2 +-
 tests/btrfs/219   |  3 +--
 tests/btrfs/231   |  2 +-
 tests/btrfs/285   |  1 -
 tests/btrfs/296   |  8 +-------
 tests/btrfs/304   |  4 ++--
 tests/btrfs/305   |  4 ++--
 tests/btrfs/306   |  4 ++--
 tests/btrfs/307   |  4 ++--
 tests/btrfs/308   |  4 ++--
 tests/btrfs/311   |  2 +-
 tests/btrfs/313   |  2 +-
 tests/btrfs/314   |  2 +-
 tests/btrfs/315   |  2 +-
 tests/btrfs/342   |  2 +-
 tests/btrfs/352   |  2 +-
 tests/generic/098 |  2 +-
 tests/generic/101 |  2 +-
 31 files changed, 38 insertions(+), 77 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 38658a11..0bbcb830 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -100,26 +100,6 @@ _require_btrfs_mkfs_uuid_option()
 	fi
 }
 
-_require_btrfs_fs_feature()
-{
-	if [ -z $1 ]; then
-		echo "Missing feature name argument for _require_btrfs_fs_feature"
-		_exit 1
-	fi
-	feat=$1
-	modprobe btrfs > /dev/null 2>&1
-	[ -e /sys/fs/btrfs/features/$feat ] || \
-		_notrun "Feature $feat not supported by the available btrfs version"
-}
-
-_require_btrfs_fs_sysfs()
-{
-	modprobe btrfs > /dev/null 2>&1
-	[ -e /sys/fs/btrfs/features ] || \
-		_notrun "Sysfs not supported by the available btrfs version"
-
-}
-
 _require_btrfs_no_compress()
 {
 	if _normalize_mount_options "$MOUNT_OPTIONS" | grep -q "compress"; then
@@ -962,18 +942,6 @@ _require_scratch_enable_simple_quota()
 	_scratch_unmount
 }
 
-_has_btrfs_sysfs_feature_attr()
-{
-	local feature_attr=$1
-
-	[ -z $feature_attr ] && \
-		_fail "Missing feature name argument for _has_btrfs_sysfs_attr"
-
-	modprobe btrfs &> /dev/null
-
-	test -e /sys/fs/btrfs/features/$feature_attr
-}
-
 # Print the fsid and metadata uuid replaced with constant strings FSID and
 # METADATA_UUID. Compare temp_fsid with fsid and metadata_uuid, then echo what
 # it matches to or TEMP_FSID. This helps in comparing with the golden output.
@@ -983,9 +951,8 @@ _check_temp_fsid()
 	local fsid
 	local metadata_uuid
 
-	_require_btrfs_fs_sysfs
-	_require_btrfs_fs_feature temp_fsid
-	_require_btrfs_fs_feature metadata_uuid
+	_require_fs_sysfs_feature_attr temp_fsid
+	_require_fs_sysfs_feature_attr metadata_uuid
 	_require_btrfs_command inspect-internal dump-super
 
 	# on disk fsid
diff --git a/common/rc b/common/rc
index 66a4209d..36f3ce6c 100644
--- a/common/rc
+++ b/common/rc
@@ -5618,6 +5618,7 @@ _require_fs_sysfs_feature_attr()
 {
 	local attr=$1
 
+	modprobe $FSTYP > /dev/null 2>&1
 	_has_fs_sysfs_feature_attr "$attr" && return
 
 	_notrun "This test requires /sys/fs/${FSTYP}/features/${attr}"
@@ -6120,7 +6121,7 @@ _require_duplicate_fsid()
 {
 	case "$FSTYP" in
 	"btrfs")
-		_require_btrfs_fs_feature temp_fsid
+		_require_fs_sysfs_feature_attr temp_fsid
 		;;
 	"ext4")
 		;;
diff --git a/tests/btrfs/010 b/tests/btrfs/010
index d27c6dd2..10d30b70 100755
--- a/tests/btrfs/010
+++ b/tests/btrfs/010
@@ -23,7 +23,8 @@ _cleanup()
 . ./common/filter
 
 _require_test
-_require_btrfs_fs_sysfs
+_require_fs_sysfs_dev_attr $TEST_DEV allocation/metadata/bytes_may_use
+_require_fs_sysfs_dev_attr $TEST_DEV allocation/global_rsv_reserved
 
 # Create 32k extents. All of these extents will be accounted as outstanding and
 # reserved.
diff --git a/tests/btrfs/055 b/tests/btrfs/055
index bd0755d2..5d6fba4b 100755
--- a/tests/btrfs/055
+++ b/tests/btrfs/055
@@ -25,7 +25,7 @@ _cleanup()
 
 _require_scratch
 _require_cloner
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 
 test_btrfs_clone_with_holes()
diff --git a/tests/btrfs/056 b/tests/btrfs/056
index 08f9aac6..10e676a7 100755
--- a/tests/btrfs/056
+++ b/tests/btrfs/056
@@ -29,7 +29,7 @@ _cleanup()
 
 _require_scratch
 _require_cloner
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_dm_target flakey
 
diff --git a/tests/btrfs/112 b/tests/btrfs/112
index 1326b824..5ff5eb73 100755
--- a/tests/btrfs/112
+++ b/tests/btrfs/112
@@ -15,7 +15,7 @@ _begin_fstest auto quick clone prealloc compress
 
 _require_scratch
 _require_cloner
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_xfs_io_command "falloc"
 
diff --git a/tests/btrfs/131 b/tests/btrfs/131
index b54b8326..fa9c00ae 100755
--- a/tests/btrfs/131
+++ b/tests/btrfs/131
@@ -16,7 +16,7 @@ _begin_fstest auto quick
 
 _require_scratch
 _require_btrfs_command inspect-internal dump-super
-_require_btrfs_fs_feature free_space_tree
+_require_fs_sysfs_feature_attr free_space_tree
 _require_btrfs_v1_cache
 
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/btrfs/165 b/tests/btrfs/165
index a1099d88..9dc8afab 100755
--- a/tests/btrfs/165
+++ b/tests/btrfs/165
@@ -34,7 +34,7 @@ rm_r_subvol() {
 . ./common/filter
 
 _require_scratch
-_require_btrfs_fs_feature "rmdir_subvol"
+_require_fs_sysfs_feature_attr "rmdir_subvol"
 
 _scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount
diff --git a/tests/btrfs/188 b/tests/btrfs/188
index 6a3e9831..24169040 100755
--- a/tests/btrfs/188
+++ b/tests/btrfs/188
@@ -24,7 +24,7 @@ _cleanup()
 
 _require_test
 _require_scratch
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_xfs_io_command "fpunch"
 _require_xfs_io_command "falloc" "-k"
diff --git a/tests/btrfs/192 b/tests/btrfs/192
index 56ec2b28..f40ef46e 100755
--- a/tests/btrfs/192
+++ b/tests/btrfs/192
@@ -28,7 +28,7 @@ _cleanup()
 
 
 _require_command "$BLKDISCARD_PROG" blkdiscard
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_log_writes
 _require_scratch
diff --git a/tests/btrfs/201 b/tests/btrfs/201
index 50262086..a40bd77b 100755
--- a/tests/btrfs/201
+++ b/tests/btrfs/201
@@ -27,7 +27,7 @@ _require_scratch
 _require_dm_target flakey
 _require_attrs
 _require_xfs_io_command "fpunch"
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_odirect
 
diff --git a/tests/btrfs/205 b/tests/btrfs/205
index a557ab14..4f5161a6 100755
--- a/tests/btrfs/205
+++ b/tests/btrfs/205
@@ -22,7 +22,7 @@ _begin_fstest auto quick clone compress prealloc
 _require_scratch_reflink
 _require_xfs_io_command "falloc" "-k"
 _require_command "$CHATTR_PROG" chattr
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 # We want to create a compressed inline extent representing 4K of data for file
 # foo1 and then clone it into a file without compression, and since compression
diff --git a/tests/btrfs/209 b/tests/btrfs/209
index bd98b635..10876731 100755
--- a/tests/btrfs/209
+++ b/tests/btrfs/209
@@ -26,7 +26,7 @@ _cleanup()
 
 _require_scratch
 _require_dm_target flakey
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_xfs_io_command "sync_range"
 
diff --git a/tests/btrfs/211 b/tests/btrfs/211
index 38dbadf9..3a8b22a1 100755
--- a/tests/btrfs/211
+++ b/tests/btrfs/211
@@ -27,7 +27,7 @@ _require_scratch
 _require_xfs_io_command "falloc" "-k"
 # fiemap needed by _count_extents()
 _require_xfs_io_command "fiemap"
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_dm_target flakey
 
diff --git a/tests/btrfs/219 b/tests/btrfs/219
index 052f61a3..358cccb4 100755
--- a/tests/btrfs/219
+++ b/tests/btrfs/219
@@ -47,7 +47,6 @@ loop_dev2=""
 
 _require_test
 _require_loop
-_require_btrfs_fs_sysfs
 _require_btrfs_forget_or_module_loadable
 _fixed_by_kernel_commit 5f58d783fd78 \
 	"btrfs: free device in btrfs_close_devices for a single device filesystem"
@@ -91,7 +90,7 @@ _btrfs_forget_or_module_reload
 
 _mount $loop_dev1 $loop_mnt1 > /dev/null 2>&1 || \
 	_fail "Failed to mount the third time"
-if ! _has_btrfs_sysfs_feature_attr temp_fsid; then
+if ! _has_fs_sysfs_feature_attr temp_fsid; then
 	_mount $loop_dev2 $loop_mnt2 > /dev/null 2>&1 && \
 		_fail "We were allowed to mount when we should have failed"
 fi
diff --git a/tests/btrfs/231 b/tests/btrfs/231
index 5ebb2fdd..9e7f3eb1 100755
--- a/tests/btrfs/231
+++ b/tests/btrfs/231
@@ -25,7 +25,7 @@ _cleanup()
 . ./common/dmflakey
 
 _require_scratch
-_require_btrfs_fs_feature "no_holes"
+_require_fs_sysfs_feature_attr "no_holes"
 _require_btrfs_mkfs_feature "no-holes"
 _require_dm_target flakey
 
diff --git a/tests/btrfs/285 b/tests/btrfs/285
index 6a1eb236..d45779d5 100755
--- a/tests/btrfs/285
+++ b/tests/btrfs/285
@@ -15,7 +15,6 @@ sysfs_size_classes() {
 }
 
 _require_scratch
-_require_btrfs_fs_sysfs
 _require_fs_sysfs_dev_attr allocation/data/size_classes
 
 f="$SCRATCH_MNT/f"
diff --git a/tests/btrfs/296 b/tests/btrfs/296
index 0baf89c0..19e3fdea 100755
--- a/tests/btrfs/296
+++ b/tests/btrfs/296
@@ -14,14 +14,8 @@ _require_scratch_dev_pool 3
 _fixed_by_kernel_commit b7625f461da6 \
 	"btrfs: sysfs: update fs features directory asynchronously"
 
-# We need the global features support
-_require_btrfs_fs_sysfs
-
-global_features="/sys/fs/btrfs/features"
 # Make sure we have support RAID1C34 first
-if [ ! -f "${global_features}/raid1c34" ]; then
-	_notrun "no RAID1C34 support"
-fi
+_require_fs_sysfs_feature_attr raid1c34
 
 _scratch_dev_pool_get 3
 
diff --git a/tests/btrfs/304 b/tests/btrfs/304
index 18f73590..ec165a21 100755
--- a/tests/btrfs/304
+++ b/tests/btrfs/304
@@ -16,8 +16,8 @@ _begin_fstest auto quick raid remount volume raid-stripe-tree
 _require_btrfs_command inspect-internal dump-tree
 _require_btrfs_mkfs_feature "raid-stripe-tree"
 _require_scratch_dev_pool 4
-_require_btrfs_fs_feature "raid_stripe_tree"
-_require_btrfs_fs_feature "free_space_tree"
+_require_fs_sysfs_feature_attr "raid_stripe_tree"
+_require_fs_sysfs_feature_attr "free_space_tree"
 _require_btrfs_free_space_tree
 _require_btrfs_no_compress
 _require_btrfs_support_sectorsize 4096
diff --git a/tests/btrfs/305 b/tests/btrfs/305
index 45747627..ddb3a8ee 100755
--- a/tests/btrfs/305
+++ b/tests/btrfs/305
@@ -17,8 +17,8 @@ _begin_fstest auto quick raid remount volume raid-stripe-tree
 _require_btrfs_command inspect-internal dump-tree
 _require_btrfs_mkfs_feature "raid-stripe-tree"
 _require_scratch_dev_pool 4
-_require_btrfs_fs_feature "raid_stripe_tree"
-_require_btrfs_fs_feature "free_space_tree"
+_require_fs_sysfs_feature_attr "raid_stripe_tree"
+_require_fs_sysfs_feature_attr "free_space_tree"
 _require_btrfs_free_space_tree
 _require_btrfs_no_compress
 _require_btrfs_support_sectorsize 4096
diff --git a/tests/btrfs/306 b/tests/btrfs/306
index db3defc8..ebc21190 100755
--- a/tests/btrfs/306
+++ b/tests/btrfs/306
@@ -17,8 +17,8 @@ _begin_fstest auto quick raid remount volume raid-stripe-tree
 _require_btrfs_command inspect-internal dump-tree
 _require_btrfs_mkfs_feature "raid-stripe-tree"
 _require_scratch_dev_pool 4
-_require_btrfs_fs_feature "raid_stripe_tree"
-_require_btrfs_fs_feature "free_space_tree"
+_require_fs_sysfs_feature_attr "raid_stripe_tree"
+_require_fs_sysfs_feature_attr "free_space_tree"
 _require_btrfs_free_space_tree
 _require_btrfs_no_compress
 _require_btrfs_support_sectorsize 4096
diff --git a/tests/btrfs/307 b/tests/btrfs/307
index 02a9d4d3..552fdf19 100755
--- a/tests/btrfs/307
+++ b/tests/btrfs/307
@@ -16,8 +16,8 @@ _begin_fstest auto quick raid remount volume raid-stripe-tree
 _require_btrfs_command inspect-internal dump-tree
 _require_btrfs_mkfs_feature "raid-stripe-tree"
 _require_scratch_dev_pool 4
-_require_btrfs_fs_feature "raid_stripe_tree"
-_require_btrfs_fs_feature "free_space_tree"
+_require_fs_sysfs_feature_attr "raid_stripe_tree"
+_require_fs_sysfs_feature_attr "free_space_tree"
 _require_btrfs_free_space_tree
 _require_btrfs_no_compress
 
diff --git a/tests/btrfs/308 b/tests/btrfs/308
index c4ccaa0f..9fab9795 100755
--- a/tests/btrfs/308
+++ b/tests/btrfs/308
@@ -17,8 +17,8 @@ _begin_fstest auto quick raid remount volume raid-stripe-tree
 _require_btrfs_command inspect-internal dump-tree
 _require_btrfs_mkfs_feature "raid-stripe-tree"
 _require_scratch_dev_pool 4
-_require_btrfs_fs_feature "raid_stripe_tree"
-_require_btrfs_fs_feature "free_space_tree"
+_require_fs_sysfs_feature_attr "raid_stripe_tree"
+_require_fs_sysfs_feature_attr "free_space_tree"
 _require_btrfs_free_space_tree
 _require_btrfs_no_compress
 _require_btrfs_no_nodatacow
diff --git a/tests/btrfs/311 b/tests/btrfs/311
index 9ac997db..81d57da1 100755
--- a/tests/btrfs/311
+++ b/tests/btrfs/311
@@ -24,7 +24,7 @@ _cleanup()
 
 _require_cp_reflink
 _require_scratch
-_require_btrfs_fs_feature temp_fsid
+_require_fs_sysfs_feature_attr temp_fsid
 
 mnt1=$TEST_DIR/$seq/mnt1
 mkdir -p $mnt1
diff --git a/tests/btrfs/313 b/tests/btrfs/313
index 7d09aaad..4729d2a4 100755
--- a/tests/btrfs/313
+++ b/tests/btrfs/313
@@ -22,7 +22,7 @@ _cleanup()
 
 _require_cp_reflink
 _require_scratch_dev_pool 2
-_require_btrfs_fs_feature temp_fsid
+_require_fs_sysfs_feature_attr temp_fsid
 
 _scratch_dev_pool_get 2
 
diff --git a/tests/btrfs/314 b/tests/btrfs/314
index 01646157..8f4dfd82 100755
--- a/tests/btrfs/314
+++ b/tests/btrfs/314
@@ -22,7 +22,7 @@ _cleanup()
 . ./common/filter.btrfs
 
 _require_scratch_dev_pool 2
-_require_btrfs_fs_feature temp_fsid
+_require_fs_sysfs_feature_attr temp_fsid
 
 _scratch_dev_pool_get 2
 
diff --git a/tests/btrfs/315 b/tests/btrfs/315
index b9fdba6a..74574bdd 100755
--- a/tests/btrfs/315
+++ b/tests/btrfs/315
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/filter
 
 _require_scratch_dev_pool 3
-_require_btrfs_fs_feature temp_fsid
+_require_fs_sysfs_feature_attr temp_fsid
 
 _scratch_dev_pool_get 3
 
diff --git a/tests/btrfs/342 b/tests/btrfs/342
index e88b47e0..96446640 100755
--- a/tests/btrfs/342
+++ b/tests/btrfs/342
@@ -13,7 +13,7 @@ _begin_fstest auto quick
 
 _require_scratch
 _require_btrfs_command inspect-internal dump-super
-_require_btrfs_fs_feature free_space_tree
+_require_fs_sysfs_feature_attr free_space_tree
 
 # The block-group-tree feature relies on v2 cache, thus it doesn't support
 # "nospace_cache" mount option.
diff --git a/tests/btrfs/352 b/tests/btrfs/352
index 1d40c09c..9551f3d4 100755
--- a/tests/btrfs/352
+++ b/tests/btrfs/352
@@ -14,7 +14,7 @@ _begin_fstest auto quick remount
 _fixed_by_kernel_commit XXXXXXXXXXXX \
 	"btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag"
 
-_require_btrfs_fs_feature supported_rescue_options
+_require_fs_sysfs_feature_attr supported_rescue_options
 
 if ! grep -q "ignorebadroots" "/sys/fs/btrfs/features/supported_rescue_options"; then
 	_notrun "\"rescue=ignorebadroots\" mount option not supported"
diff --git a/tests/generic/098 b/tests/generic/098
index ff6cf908..ff003f60 100755
--- a/tests/generic/098
+++ b/tests/generic/098
@@ -24,7 +24,7 @@ _require_scratch
 # feature is enabled (introduced in kernel 3.14). So enable the feature if the
 # fs being tested is btrfs.
 if [ $FSTYP == "btrfs" ]; then
-	_require_btrfs_fs_feature "no_holes"
+	_require_fs_sysfs_feature_attr "no_holes"
 	_require_btrfs_mkfs_feature "no-holes"
 	MKFS_OPTIONS="$MKFS_OPTIONS -O no-holes"
 fi
diff --git a/tests/generic/101 b/tests/generic/101
index 31660277..e51be5b5 100755
--- a/tests/generic/101
+++ b/tests/generic/101
@@ -32,7 +32,7 @@ _require_dm_target flakey
 # feature is enabled (introduced in kernel 3.14). So enable the feature if the
 # fs being tested is btrfs.
 if [ $FSTYP == "btrfs" ]; then
-	_require_btrfs_fs_feature "no_holes"
+	_require_fs_sysfs_feature_attr "no_holes"
 	_require_btrfs_mkfs_feature "no-holes"
 	MKFS_OPTIONS="$MKFS_OPTIONS -O no-holes"
 fi
-- 
2.55.0

