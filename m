Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE7E1E524;
	Tue, 27 Feb 2024 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709055593; cv=none; b=MHTYfPgBUG25mMmx6V17vns4rUq7JmdRcRd2781y/VkEDm2b9bj0LPjIyGnWC2+ZURd7ViQxClaCTSnMbw37gzbLaTmWKH/haMSQ3up/efiNM1fvaRjRa86zCjsTklxnUMwg3fuOszNIxVnFf3svt10AEV6SqhTHbjBhnSOFqCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709055593; c=relaxed/simple;
	bh=NUO1fbCVpTdnfpRJXiVoCMpZ59lUklRGopKuw2lmwb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EIlwNK+AkDeNRIecHTVeepTvzcfUY8Ct9MA6J7YYNAlJp60qh1+/n2m4CRCGT+nTzGFLU8ZeqORNh53P4KGPV3mZ+fkGZh8Mg7gPkt6dIQlihO+fkIw20JuG9oybTVTY5lbAeix28Tdye6vM+UOarm3cGbKLrAbr2A1JTCaO6Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=ANtcYDc4; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="ANtcYDc4"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Tkl9b69Nmz9snX;
	Tue, 27 Feb 2024 18:39:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1709055587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1CiCVwaleWC2YUOVh+KoNl0CZIWYfyojkpNBszrhIn0=;
	b=ANtcYDc4Dz2k5uYS4op4CizUZMH/MpVcvCLnz/B8Y+ZJDrvXLE6rimvqkIjNv+31qOe/kU
	4L/MobyiLmV12Otf5g/0zz4L7S3Q6OWRb4Bi7MftOuBBvPEqiHOexHomJlqWQ2gxdofZoM
	ceHVhnxoPfwXWe5Lwkk2gQrp+deehKQRNH/WMCiDKx84mkzrGcSqL20+nxh2HNz62AoU9n
	lIbXtj2Ix6W8LmbT87Qo81Dq4EOw++j2uuM4JSljMSgJb6iuHGxtuiPInKZm3COhzG1vwe
	rzNJeNFhZ4adSjNyD3gR3CHSqQYC08IYj7+EDvMzEjBK0AMYfECwg97YLC3T7A==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: fstests@vger.kernel.org,
	zlang@redhat.com
Cc: gost.dev@samsung.com,
	mcgrof@kernel.org,
	djwong@kernel.org,
	p.raghav@samsung.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] misc: fix test that fail formatting with 64k blocksize
Date: Tue, 27 Feb 2024 18:39:45 +0100
Message-ID: <20240227173945.2945637-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4Tkl9b69Nmz9snX

From: "Darrick J. Wong" <djwong@kernel.org>

There's a bunch of tests that fail the formatting step when the test run
is configured to use XFS with a 64k blocksize.  This happens because XFS
doesn't really support that combination due to minimum log size
constraints. Fix the test to format larger devices in that case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
@Darrick I added more tests that were failing, and increased 512m to 600m
as generic/081 and generic/108 were still failing with 512m with
the following on 64k page size system:                          
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=64k,'

 common/rc         | 29 +++++++++++++++++++++++++++++
 tests/generic/042 |  9 +--------
 tests/generic/081 |  7 +++++--
 tests/generic/108 |  6 ++++--
 tests/generic/455 |  3 ++-
 tests/generic/457 |  3 ++-
 tests/generic/482 |  3 ++-
 tests/generic/704 |  3 ++-
 tests/generic/730 |  3 ++-
 tests/generic/731 |  3 ++-
 tests/shared/298  |  2 +-
 tests/xfs/279     |  7 ++++---
 12 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/common/rc b/common/rc
index 30c44ddd..f1a27bcd 100644
--- a/common/rc
+++ b/common/rc
@@ -923,6 +923,35 @@ _check_minimal_fs_size()
 	fi
 }
 
+# Round a proposed filesystem size up to the minimium supported size.  The
+# input is in MB and so is the output.
+_small_fs_size_mb()
+{
+	local size="$1"
+	local runner_min_size=0
+	local fs_min_size=0
+
+	case "$FSTYP" in
+	xfs)
+		# xfs no longer supports filesystems smaller than 600m
+		fs_min_size=600
+		;;
+	f2fs)
+		# f2fs-utils 1.9.0 needs at least 38 MB space for f2fs image.
+		# However, f2fs-utils 1.14.0 needs at least 52 MB. Not sure if
+		# it will change again. So just set it 128M.
+		fs_min_size=128
+		;;
+	esac
+	(( size < fs_min_size )) && size="$fs_min_size"
+
+	# If the test runner wanted a minimum size, enforce that here.
+	test -n "$MIN_FSSIZE" && runner_min_size=$((MIN_FSSIZE / 1048576))
+	(( size < runner_min_size)) && size="$runner_min_size"
+
+	echo "$size"
+}
+
 # Create fs of certain size on scratch device
 # _scratch_mkfs_sized <size in bytes> [optional blocksize]
 _scratch_mkfs_sized()
diff --git a/tests/generic/042 b/tests/generic/042
index 5116183f..63a46d6b 100755
--- a/tests/generic/042
+++ b/tests/generic/042
@@ -27,14 +27,7 @@ _crashtest()
 	img=$SCRATCH_MNT/$seq.img
 	mnt=$SCRATCH_MNT/$seq.mnt
 	file=$mnt/file
-	size=25M
-
-	# f2fs-utils 1.9.0 needs at least 38 MB space for f2fs image. However,
-	# f2fs-utils 1.14.0 needs at least 52 MB. Not sure if it will change
-	# again. So just set it 128M.
-	if [ $FSTYP == "f2fs" ]; then
-		size=128M
-	fi
+	size=$(_small_fs_size_mb 25)M
 
 	# Create an fs on a small, initialized image. The pattern is written to
 	# the image to detect stale data exposure.
diff --git a/tests/generic/081 b/tests/generic/081
index 22ac94de..0996f221 100755
--- a/tests/generic/081
+++ b/tests/generic/081
@@ -62,13 +62,16 @@ snapname=snap_$seq
 mnt=$TEST_DIR/mnt_$seq
 mkdir -p $mnt
 
+size=$(_small_fs_size_mb 300)
+lvsize=$((size * 85 / 100))	 # ~256M
+
 # make sure there's enough disk space for 256M lv, test for 300M here in case
 # lvm uses some space for metadata
-_scratch_mkfs_sized $((300 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((size * 1024 * 1024)) >>$seqres.full 2>&1
 $LVM_PROG vgcreate -f $vgname $SCRATCH_DEV >>$seqres.full 2>&1
 # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
 # (like 2.02.95 in RHEL6) don't support --yes option
-yes | $LVM_PROG lvcreate -L 256M -n $lvname $vgname >>$seqres.full 2>&1
+yes | $LVM_PROG lvcreate -L ${lvsize}M -n $lvname $vgname >>$seqres.full 2>&1
 # wait for lvcreation to fully complete
 $UDEV_SETTLE_PROG >>$seqres.full 2>&1
 
diff --git a/tests/generic/108 b/tests/generic/108
index efe66ba5..07703fc8 100755
--- a/tests/generic/108
+++ b/tests/generic/108
@@ -44,9 +44,11 @@ vgname=vg_$seq
 
 physical=`blockdev --getpbsz $SCRATCH_DEV`
 logical=`blockdev --getss $SCRATCH_DEV`
+size=$(_small_fs_size_mb 300)
+lvsize=$((size * 91 / 100))
 
 # _get_scsi_debug_dev returns a scsi debug device with 128M in size by default
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 300`
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
 echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
 
@@ -55,7 +57,7 @@ $LVM_PROG pvcreate -f $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
 $LVM_PROG vgcreate -f $vgname $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
 # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
 # (like 2.02.95 in RHEL6) don't support --yes option
-yes | $LVM_PROG lvcreate -i 2 -I 4m -L 275m -n $lvname $vgname \
+yes | $LVM_PROG lvcreate -i 2 -I 4m -L ${lvsize}m -n $lvname $vgname \
 	>>$seqres.full 2>&1
 # wait for lv creation to fully complete
 $UDEV_SETTLE_PROG >>$seqres.full 2>&1
diff --git a/tests/generic/455 b/tests/generic/455
index c13d872c..da803de0 100755
--- a/tests/generic/455
+++ b/tests/generic/455
@@ -51,7 +51,8 @@ SANITY_DIR=$TEST_DIR/fsxtests
 rm -rf $SANITY_DIR
 mkdir $SANITY_DIR
 
-devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
+size=$(_small_fs_size_mb 200)           # 200m phys/virt size
+devsize=$((1024*1024*size / 512))
 csize=$((1024*64 / 512))                # 64k cluster size
 lowspace=$((1024*1024 / 512))           # 1m low space threshold
 
diff --git a/tests/generic/457 b/tests/generic/457
index ca0f5e62..03aeb814 100755
--- a/tests/generic/457
+++ b/tests/generic/457
@@ -55,7 +55,8 @@ SANITY_DIR=$TEST_DIR/fsxtests
 rm -rf $SANITY_DIR
 mkdir $SANITY_DIR
 
-devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
+size=$(_small_fs_size_mb 200)           # 200m phys/virt size
+devsize=$((1024*1024*size / 512))
 csize=$((1024*64 / 512))                # 64k cluster size
 lowspace=$((1024*1024 / 512))           # 1m low space threshold
 
diff --git a/tests/generic/482 b/tests/generic/482
index 6d8396d9..c647d24c 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -65,7 +65,8 @@ fi
 fsstress_args=$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $nr_cpus \
 		$FSSTRESS_AVOID)
 
-devsize=$((1024*1024*200 / 512))	# 200m phys/virt size
+size=$(_small_fs_size_mb 200)           # 200m phys/virt size
+devsize=$((1024*1024*size / 512))
 csize=$((1024*64 / 512))		# 64k cluster size
 lowspace=$((1024*1024 / 512))		# 1m low space threshold
 
diff --git a/tests/generic/704 b/tests/generic/704
index c0142a60..6cc4bb4a 100755
--- a/tests/generic/704
+++ b/tests/generic/704
@@ -30,8 +30,9 @@ _require_scsi_debug
 _require_test
 _require_block_device $TEST_DEV
 
+size=$(_small_fs_size_mb 256)
 echo "Get a device with 4096 physical sector size and 512 logical sector size"
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 $size`
 blockdev --getpbsz --getss $SCSI_DEBUG_DEV
 
 echo "mkfs and mount"
diff --git a/tests/generic/730 b/tests/generic/730
index 11308cda..988c47e1 100755
--- a/tests/generic/730
+++ b/tests/generic/730
@@ -27,7 +27,8 @@ _require_test
 _require_block_device $TEST_DEV
 _require_scsi_debug
 
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 256`
+size=$(_small_fs_size_mb 256)
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
 echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
 
diff --git a/tests/generic/731 b/tests/generic/731
index e1400d06..b279e3f7 100755
--- a/tests/generic/731
+++ b/tests/generic/731
@@ -27,7 +27,8 @@ _require_block_device $TEST_DEV
 _supported_fs generic
 _require_scsi_debug
 
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 256`
+size=$(_small_fs_size_mb 256)
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
 echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
 
diff --git a/tests/shared/298 b/tests/shared/298
index 807d4c87..52bfffb8 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -20,7 +20,7 @@ if [ "$FSTYP" = "btrfs" ]; then
 	fssize=3000
 else
 	_require_fs_space $TEST_DIR 307200
-	fssize=300
+	fssize=$(_small_fs_size_mb 300)           # 200m phys/virt size
 fi
 
 [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
diff --git a/tests/xfs/279 b/tests/xfs/279
index 835d187f..9f366d1e 100755
--- a/tests/xfs/279
+++ b/tests/xfs/279
@@ -26,6 +26,7 @@ _cleanup()
 _supported_fs xfs
 
 _require_scsi_debug
+size=$(_small_fs_size_mb 128)
 
 # Remove xfs signature so -f isn't needed to re-mkfs
 _wipe_device()
@@ -55,7 +56,7 @@ _check_mkfs()
 (
 echo "==================="
 echo "4k physical 512b logical aligned"
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
 # sector size should default to 4k
 _check_mkfs $SCSI_DEBUG_DEV
@@ -68,7 +69,7 @@ _put_scsi_debug_dev
 (
 echo "==================="
 echo "4k physical 512b logical unaligned"
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 128`
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
 # should fail on misalignment
 _check_mkfs $SCSI_DEBUG_DEV
@@ -85,7 +86,7 @@ _put_scsi_debug_dev
 (
 echo "==================="
 echo "hard 4k physical / 4k logical"
-SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 128`
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
 # block size smaller than sector size should fail 
 _check_mkfs -b size=2048 $SCSI_DEBUG_DEV

base-commit: 386c7b6aa69ebe8017a4728a994f80d55c660de4
-- 
2.43.0

