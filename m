Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E326A36EA9F;
	Mon, 13 Apr 2026 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102671; cv=none; b=EqfrREo8gBQJATpsGoquCMRY30yiL7y8a9a7Eu9FbbKTzix22x7Zl5abysUs0zSm6OgQx6ur8LfVjweqSIsUMf3sgbxKxDcw+4JSr5PFJ6SDbra4ti275nGzBvgdAliMuimSZilm0MEQ4JTGVE/1geLuoM0EJc1lTJVKRyz99wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102671; c=relaxed/simple;
	bh=yyps4JDdPPxB8YB1jPcxHL7DGYNiV6nPY1Ycprg14bs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKgVgpSYP4IKVlgXjP6ne1ua/BPrTHlOpRj3aHPKUahTd5WwZ8xazpWZudZpMdyutdA39DqpOTj9oTX05z2qOoxg6M99KcLEFEEcVnTgvrRiIUlfOnLUl5GfT47YpRfu8S7FImapHIORpurMmxBTfoohOoaPRQbJFW3KK6/tRAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j34RXxA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j34RXxA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A3EC2BCAF;
	Mon, 13 Apr 2026 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102670;
	bh=yyps4JDdPPxB8YB1jPcxHL7DGYNiV6nPY1Ycprg14bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j34RXxA3cw0rEMTUxbDRKjBdz4tv2EdaWnUpe/P8lX5nJNYXENIGEw9hYt7+KechS
	 8AY4D9N7qkASkman3BZA8EMTme4dOuIkKZ8bDTjBzP/wOIXKqyIoZXV4GJJOBKDW1x
	 Y9fqv8BBLeEUVPRApl27a/uNV3nZ2rrF9Mz/oeTI51bxG3OITfnwGGBzs8soGvwlKo
	 MoWtJ6sFDe4eFAy75cGuPNnnlLAIrU5e4fclqYVgH+M4zARNyRpR75+mWiu9N1UuiW
	 kfzFrteYciLs769DjbYoSODvqJ1YfgtzeVE0hgIpEjkbm1YFl09sCp5aM/ZGx+fMUV
	 yGRHDSu1LFz0Q==
Date: Mon, 13 Apr 2026 10:51:09 -0700
Subject: [PATCH 1/2] treewide: convert all $MOUNT_PROG to _mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177610262425.115381.16374107672753586865.stgit@frogsfrogsfrogs>
In-Reply-To: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Going to add some new log scraping functionality when mount failures
occur, so we need everyone to use _mount instead of $MOUNT_PROG.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/btrfs       |    4 ++--
 common/dmdelay     |    2 +-
 common/dmerror     |    2 +-
 common/dmlogwrites |    2 +-
 common/overlay     |    6 +++---
 tests/btrfs/012    |    6 +++---
 tests/btrfs/075    |    2 +-
 tests/btrfs/089    |    2 +-
 tests/btrfs/136    |    4 ++--
 tests/btrfs/208    |    2 +-
 tests/btrfs/330    |    2 +-
 tests/btrfs/335    |    2 +-
 tests/ext4/032     |    2 +-
 tests/generic/067  |    4 ++--
 tests/generic/089  |    2 +-
 tests/generic/120  |    2 +-
 tests/generic/306  |    2 +-
 tests/generic/361  |    2 +-
 tests/generic/373  |    2 +-
 tests/generic/374  |    2 +-
 tests/generic/395  |    4 ++--
 tests/generic/409  |    6 +++---
 tests/generic/410  |    8 ++++----
 tests/generic/411  |    8 ++++----
 tests/generic/504  |    4 ++--
 tests/generic/589  |    8 ++++----
 tests/generic/631  |    2 +-
 tests/generic/717  |    2 +-
 tests/overlay/005  |    4 ++--
 tests/overlay/025  |    2 +-
 tests/overlay/062  |    2 +-
 tests/overlay/083  |    6 +++---
 tests/overlay/086  |   12 ++++++------
 tests/xfs/044      |    2 +-
 tests/xfs/049      |    8 ++++----
 tests/xfs/149      |    4 ++--
 tests/xfs/206      |    2 +-
 tests/xfs/250      |    2 +-
 tests/xfs/289      |    4 ++--
 tests/xfs/300      |    2 +-
 tests/xfs/507      |    2 +-
 tests/xfs/544      |    2 +-
 42 files changed, 75 insertions(+), 75 deletions(-)


diff --git a/common/btrfs b/common/btrfs
index c2d616aa26e4be..30288f07b61a3e 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -358,7 +358,7 @@ _btrfs_stress_subvolume()
 	mkdir -p $subvol_mnt
 	while [ ! -e $stop_file ]; do
 		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
-		$MOUNT_PROG -o subvol=$subvol_name $btrfs_dev $subvol_mnt
+		_mount -o subvol=$subvol_name $btrfs_dev $subvol_mnt
 		_unmount $subvol_mnt
 		$BTRFS_UTIL_PROG subvolume delete $btrfs_mnt/$subvol_name
 	done
@@ -444,7 +444,7 @@ _btrfs_stress_remount_compress()
 	local btrfs_mnt=$1
 	while true; do
 		for algo in no zlib lzo; do
-			$MOUNT_PROG -o remount,compress=$algo $btrfs_mnt
+			_mount -o remount,compress=$algo $btrfs_mnt
 		done
 	done
 }
diff --git a/common/dmdelay b/common/dmdelay
index 848afb993faa19..ff0b8adf8bfc72 100644
--- a/common/dmdelay
+++ b/common/dmdelay
@@ -22,7 +22,7 @@ _init_delay()
 _mount_delay()
 {
 	_scratch_options mount
-	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options` $SCRATCH_OPTIONS \
+	_mount -t $FSTYP `_common_dev_mount_options` $SCRATCH_OPTIONS \
 		$DELAY_DEV $SCRATCH_MNT
 }
 
diff --git a/common/dmerror b/common/dmerror
index 309129c03c8d87..5c99fc1629b4ae 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -95,7 +95,7 @@ _dmerror_init()
 _dmerror_mount()
 {
 	_scratch_options mount
-	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
+	_mount -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
 		$DMERROR_DEV $SCRATCH_MNT
 }
 
diff --git a/common/dmlogwrites b/common/dmlogwrites
index a27e1966a933a6..278656269584b3 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -104,7 +104,7 @@ _log_writes_mkfs()
 _log_writes_mount()
 {
 	_scratch_options mount
-	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
+	_mount -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
 		$LOGWRITES_DMDEV $SCRATCH_MNT
 }
 
diff --git a/common/overlay b/common/overlay
index 67ae11f883ee68..d32f3219a5285a 100644
--- a/common/overlay
+++ b/common/overlay
@@ -29,13 +29,13 @@ _overlay_mount_dirs()
 	[ -n "$upperdir" ] && [ "$upperdir" != "-" ] && \
 		diropts+=",upperdir=$upperdir,workdir=$workdir"
 
-	$MOUNT_PROG -t overlay $diropts `_common_dev_mount_options $*`
+	_mount -t overlay $diropts `_common_dev_mount_options $*`
 }
 
 # Mount with mnt/dev of scratch mount and custom mount options
 _overlay_scratch_mount_opts()
 {
-	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
+	_mount -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
 }
 
 # Mount with same options/mnt/dev of scratch mount, but optionally
@@ -130,7 +130,7 @@ _overlay_scratch_mount()
 		# By default, libmount merges remount options with old mount options.
 		# overlayfs does not support re-configuring the same mount options.
 		# We workaround this problem with --options-mode ignore.
-		$MOUNT_PROG $SCRATCH_MNT --options-mode ignore $*
+		_mount $SCRATCH_MNT --options-mode ignore $*
 		return
 	fi
 
diff --git a/tests/btrfs/012 b/tests/btrfs/012
index 6914fba6ebe2cf..b3ca4190ecd117 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -41,7 +41,7 @@ export SELINUX_MOUNT_OPTIONS=""
 $MKFS_EXT4_PROG -F -b $BLOCK_SIZE $SCRATCH_DEV > $seqres.full 2>&1 || \
 	_notrun "Could not create ext4 filesystem"
 # Manual mount so we don't use -t btrfs or selinux context
-mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
+_mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
 if [ $? -ne 0 -a $BLOCK_SIZE -gt $(_get_page_size) ]; then
 	_notrun "block size $BLOCK_SIZE is not supported by ext4"
 fi
@@ -68,7 +68,7 @@ $E2FSCK_PROG -fn $SCRATCH_MNT/ext2_saved/image >> $seqres.full 2>&1 || \
 
 # And the files in that image should match
 mkdir -p $SCRATCH_MNT/mnt
-mount -o loop $SCRATCH_MNT/ext2_saved/image $SCRATCH_MNT/mnt || \
+_mount -o loop $SCRATCH_MNT/ext2_saved/image $SCRATCH_MNT/mnt || \
 	_fail "could not loop mount saved ext4 image"
 
 echo "Checking saved ext2 image against the original one:"
@@ -90,7 +90,7 @@ $E2FSCK_PROG -fn $SCRATCH_DEV >> $seqres.full 2>&1 || \
         _fail "restored ext4 image is corrupt"
 
 # Mount the un-converted ext4 device & check the contents
-mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
+_mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
 echo "Checking rolled back ext2 against the original one:"
 $FSSUM_PROG -r $tmp.original $SCRATCH_MNT/$BASENAME
 
diff --git a/tests/btrfs/075 b/tests/btrfs/075
index 917993ca2da3a6..737c4ffdd57865 100755
--- a/tests/btrfs/075
+++ b/tests/btrfs/075
@@ -37,7 +37,7 @@ _scratch_mount
 subvol_mnt=$TEST_DIR/$seq.mnt
 mkdir -p $subvol_mnt
 $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/subvol >>$seqres.full 2>&1
-$MOUNT_PROG -o subvol=subvol $SELINUX_MOUNT_OPTIONS $SCRATCH_DEV $subvol_mnt
+_mount -o subvol=subvol $SELINUX_MOUNT_OPTIONS $SCRATCH_DEV $subvol_mnt
 status=$?
 
 exit
diff --git a/tests/btrfs/089 b/tests/btrfs/089
index 8f8e37b6fde87b..9e8d8ea3a5e097 100755
--- a/tests/btrfs/089
+++ b/tests/btrfs/089
@@ -29,7 +29,7 @@ $BTRFS_UTIL_PROG subvolume set-default $testvol_id "$SCRATCH_MNT" >>$seqres.full
 # Bind-mount a directory under the default subvolume.
 mkdir "$SCRATCH_MNT/testvol/testdir"
 mkdir "$SCRATCH_MNT/testvol/mnt"
-mount --bind "$SCRATCH_MNT/testvol/testdir" "$SCRATCH_MNT/testvol/mnt"
+_mount --bind "$SCRATCH_MNT/testvol/testdir" "$SCRATCH_MNT/testvol/mnt"
 
 # Now attempt to delete the default subvolume.
 $BTRFS_UTIL_PROG subvolume delete "$SCRATCH_MNT/testvol" >>$seqres.full 2>&1
diff --git a/tests/btrfs/136 b/tests/btrfs/136
index fd24d3f8c1fa45..97c110981adebb 100755
--- a/tests/btrfs/136
+++ b/tests/btrfs/136
@@ -44,7 +44,7 @@ $MKFS_EXT4_PROG -F -t ext3 -b $BLOCK_SIZE $SCRATCH_DEV > $seqres.full 2>&1 || \
 	_notrun "Could not create ext3 filesystem"
 
 # mount and populate non-extent file
-mount -t ext3 $SCRATCH_DEV $SCRATCH_MNT
+_mount -t ext3 $SCRATCH_DEV $SCRATCH_MNT
 if [ $? -ne 0 -a $BLOCK_SIZE -gt $(_get_page_size) ]; then
 	_notrun "block size $BLOCK_SIZE is not supported by ext3"
 fi
@@ -57,7 +57,7 @@ $TUNE2FS_PROG -O extents,uninit_bg,dir_index $SCRATCH_DEV >> $seqres.full 2>&1
 $E2FSCK_PROG -fyD $SCRATCH_DEV >> $seqres.full 2>&1
 
 # mount and populate extent file
-mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
+_mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
 populate_data "$SCRATCH_MNT/ext3_ext4_data/ext4"
 
 # Compute md5 of ext3,ext4 files.
diff --git a/tests/btrfs/208 b/tests/btrfs/208
index 5ea732ae8f71a7..93a999541dab06 100755
--- a/tests/btrfs/208
+++ b/tests/btrfs/208
@@ -45,7 +45,7 @@ _scratch_unmount
 
 # Now we mount the subvol2, which makes subvol3 not accessible for this mount
 # point, but we should be able to delete it using it's subvolume id
-$MOUNT_PROG -o subvol=subvol2 $SCRATCH_DEV $SCRATCH_MNT
+_mount -o subvol=subvol2 $SCRATCH_DEV $SCRATCH_MNT
 _delete_and_list subvol3 "Last remaining subvolume:"
 _scratch_unmount
 
diff --git a/tests/btrfs/330 b/tests/btrfs/330
index 3a311a5affc0a0..10c4466707f3a3 100755
--- a/tests/btrfs/330
+++ b/tests/btrfs/330
@@ -17,7 +17,7 @@ _cleanup()
 # Import common functions.
 . ./common/filter.btrfs
 
-$MOUNT_PROG -V | grep -q 'fd-based-mount'
+_mount -V | grep -q 'fd-based-mount'
 if [ "$?" -eq 0 ]; then
 	_fixed_by_kernel_commit cda7163d4e3d \
 		"btrfs: fix per-subvolume RO/RW flags with new mount API"
diff --git a/tests/btrfs/335 b/tests/btrfs/335
index 34764e4aa6c8c1..edc5c0ab3374b8 100755
--- a/tests/btrfs/335
+++ b/tests/btrfs/335
@@ -49,7 +49,7 @@ $BTRFS_UTIL_PROG balance start -mconvert=raid1 $SCRATCH_MNT 2>&1 |\
 
 _scratch_unmount
 
-$MOUNT_PROG -t btrfs -odegraded ${devs[0]} $SCRATCH_MNT
+_mount -t btrfs -odegraded ${devs[0]} $SCRATCH_MNT
 
 $BTRFS_UTIL_PROG device remove --force missing $SCRATCH_MNT >> $seqres.full
 $BTRFS_UTIL_PROG balance start --full-balance $SCRATCH_MNT >> $seqres.full
diff --git a/tests/ext4/032 b/tests/ext4/032
index 043ae4f5350530..ef050ec0fb421c 100755
--- a/tests/ext4/032
+++ b/tests/ext4/032
@@ -48,7 +48,7 @@ ext4_online_resize()
 		$seqres.full 2>&1 || _fail "mkfs failed"
 
 	echo "+++ mount image file" | tee -a $seqres.full
-	$MOUNT_PROG -t ${FSTYP} ${LOOP_DEVICE} ${IMG_MNT} > \
+	_mount -t ${FSTYP} ${LOOP_DEVICE} ${IMG_MNT} > \
 		/dev/null 2>&1 || _fail "mount failed"
 
 	echo "+++ resize fs to $final_size" | tee -a $seqres.full
diff --git a/tests/generic/067 b/tests/generic/067
index b45ae834f918d2..99d10ee0be0a0f 100755
--- a/tests/generic/067
+++ b/tests/generic/067
@@ -34,7 +34,7 @@ mount_nonexistent_mnt()
 {
 	echo "# mount to nonexistent mount point" >>$seqres.full
 	rm -rf $TEST_DIR/nosuchdir
-	$MOUNT_PROG $SCRATCH_DEV $TEST_DIR/nosuchdir >>$seqres.full 2>&1
+	_mount $SCRATCH_DEV $TEST_DIR/nosuchdir >>$seqres.full 2>&1
 }
 
 # fs driver should be able to handle mounting a free loop device gracefully xfs
@@ -60,7 +60,7 @@ mount_wrong_fstype()
 		fs=xfs
 	fi
 	echo "# mount with wrong fs type" >>$seqres.full
-	$MOUNT_PROG -t $fs $SCRATCH_DEV $SCRATCH_MNT >>$seqres.full 2>&1
+	_mount -t $fs $SCRATCH_DEV $SCRATCH_MNT >>$seqres.full 2>&1
 }
 
 # umount a symlink to device, which is not mounted.
diff --git a/tests/generic/089 b/tests/generic/089
index 89c19484fd7b8a..9998457fb5baf1 100755
--- a/tests/generic/089
+++ b/tests/generic/089
@@ -34,7 +34,7 @@ cd $TEST_DIR
 rm -fr test
 mkdir test || exit 1
 cd $TEST_DIR/test
-mount > t_mtab
+_mount > t_mtab
 
 mtab()
 {
diff --git a/tests/generic/120 b/tests/generic/120
index 7527bd4a078423..d11b90b809f240 100755
--- a/tests/generic/120
+++ b/tests/generic/120
@@ -29,7 +29,7 @@ _compare_access_times()
 		cat $tmp.out
 		echo "---------------------------------------------------"
 		$here/src/lstat64 $1
-		mount | grep $SCRATCH_MNT
+		_mount | grep $SCRATCH_MNT
 	fi
 
 }
diff --git a/tests/generic/306 b/tests/generic/306
index 8e118472d8bef0..14c07e0bda4afa 100755
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -66,7 +66,7 @@ $XFS_IO_PROG -f -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
 $XFS_IO_PROG -t -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
 
 echo "== write to bind-mounted rw file on ro fs"
-mount --bind $TARGET $BINDFILE
+_mount --bind $TARGET $BINDFILE
 # with and without -f (adds O_CREAT)
 $XFS_IO_PROG -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
 $XFS_IO_PROG -f -c "pwrite 0 512" $BINDFILE | _filter_xfs_io
diff --git a/tests/generic/361 b/tests/generic/361
index b584af47540020..70dba3a0ca8b75 100755
--- a/tests/generic/361
+++ b/tests/generic/361
@@ -52,7 +52,7 @@ fi
 $XFS_IO_PROG -fc "pwrite 0 520m" $fs_mnt/testfile >>$seqres.full 2>&1
 
 # remount should not hang
-$MOUNT_PROG -o remount,ro $fs_mnt >>$seqres.full 2>&1
+_mount -o remount,ro $fs_mnt >>$seqres.full 2>&1
 
 _unmount $fs_mnt &>/dev/null
 _destroy_loop_device $loop_dev
diff --git a/tests/generic/373 b/tests/generic/373
index 04ec642518ce70..42bdc1be0757ac 100755
--- a/tests/generic/373
+++ b/tests/generic/373
@@ -42,7 +42,7 @@ blksz=65536
 sz=$((blksz * blocks))
 
 echo "Mount otherdir"
-$MOUNT_PROG --bind $SCRATCH_MNT $otherdir
+_mount --bind $SCRATCH_MNT $otherdir
 
 echo "Create file"
 _pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
diff --git a/tests/generic/374 b/tests/generic/374
index 9a85091e29886e..8f7d17152c84be 100755
--- a/tests/generic/374
+++ b/tests/generic/374
@@ -41,7 +41,7 @@ blksz=65536
 sz=$((blocks * blksz))
 
 echo "Mount otherdir"
-$MOUNT_PROG --bind $SCRATCH_MNT $otherdir
+_mount --bind $SCRATCH_MNT $otherdir
 
 echo "Create file"
 _pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
diff --git a/tests/generic/395 b/tests/generic/395
index f9c331adb969ac..261f468f397c8c 100755
--- a/tests/generic/395
+++ b/tests/generic/395
@@ -71,8 +71,8 @@ _scratch_remount ro
 _set_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
 _get_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
 _scratch_remount rw
-mount --bind $SCRATCH_MNT $SCRATCH_MNT/ro_bind_mnt
-mount -o remount,ro,bind $SCRATCH_MNT/ro_bind_mnt
+_mount --bind $SCRATCH_MNT $SCRATCH_MNT/ro_bind_mnt
+_mount -o remount,ro,bind $SCRATCH_MNT/ro_bind_mnt
 _set_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
 _get_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
 _unmount $SCRATCH_MNT/ro_bind_mnt
diff --git a/tests/generic/409 b/tests/generic/409
index ac1b14ad60f723..eff7c3584b413b 100755
--- a/tests/generic/409
+++ b/tests/generic/409
@@ -88,7 +88,7 @@ start_test()
 
 	_scratch_mkfs >$seqres.full 2>&1
 	_get_mount -t $FSTYP $SCRATCH_DEV $MNTHEAD
-	$MOUNT_PROG --make-"${type}" $MNTHEAD
+	_mount --make-"${type}" $MNTHEAD
 	mkdir $mpA $mpB $mpC $mpD
 }
 
@@ -108,9 +108,9 @@ bind_run()
 	echo "bind $source on $dest"
 	_get_mount -t $FSTYP $SCRATCH_DEV $mpA
 	mkdir -p $mpA/dir 2>/dev/null
-	$MOUNT_PROG --make-shared $mpA
+	_mount --make-shared $mpA
 	_get_mount --bind $mpA $mpB
-	$MOUNT_PROG --make-"$source" $mpB
+	_mount --make-"$source" $mpB
 	# maybe unbindable at here
 	_get_mount --bind $mpB $mpC 2>/dev/null
 	if [ $? -ne 0 ]; then
diff --git a/tests/generic/410 b/tests/generic/410
index e0d0c57eba2950..69f9dbe97f182d 100755
--- a/tests/generic/410
+++ b/tests/generic/410
@@ -94,7 +94,7 @@ start_test()
 
 	_scratch_mkfs >>$seqres.full 2>&1
 	_get_mount -t $FSTYP $SCRATCH_DEV $MNTHEAD
-	$MOUNT_PROG --make-"${type}" $MNTHEAD
+	_mount --make-"${type}" $MNTHEAD
 	mkdir $mpA $mpB $mpC
 }
 
@@ -118,14 +118,14 @@ run()
 	echo "make-$cmd a $orgs mount"
 	_get_mount -t $FSTYP $SCRATCH_DEV $mpA
 	mkdir -p $mpA/dir 2>/dev/null
-	$MOUNT_PROG --make-shared $mpA
+	_mount --make-shared $mpA
 
 	# prepare the original status on mpB
 	_get_mount --bind $mpA $mpB
 	# shared&slave status need to do make-slave then make-shared
 	# two operations.
 	for t in $orgs; do
-		$MOUNT_PROG --make-"$t" $mpB
+		_mount --make-"$t" $mpB
 	done
 
 	# "before" for prepare and check original status
@@ -146,7 +146,7 @@ run()
 			_put_mount # umount C
 		fi
 		if [ "$i" = "before" ];then
-			$MOUNT_PROG --make-"${cmd}" $mpB
+			_mount --make-"${cmd}" $mpB
 		fi
 	done
 
diff --git a/tests/generic/411 b/tests/generic/411
index 0a80554cd4d3b9..b099940f3fa704 100755
--- a/tests/generic/411
+++ b/tests/generic/411
@@ -77,7 +77,7 @@ start_test()
 
 	_scratch_mkfs >$seqres.full 2>&1
 	_get_mount -t $FSTYP $SCRATCH_DEV $MNTHEAD
-	$MOUNT_PROG --make-"${type}" $MNTHEAD
+	_mount --make-"${type}" $MNTHEAD
 	mkdir $mpA $mpB $mpC
 }
 
@@ -100,11 +100,11 @@ crash_test()
 
 	_get_mount -t $FSTYP $SCRATCH_DEV $mpA
 	mkdir $mpA/mnt1
-	$MOUNT_PROG --make-shared $mpA
+	_mount --make-shared $mpA
 	_get_mount --bind $mpA $mpB
 	_get_mount --bind $mpA $mpC
-	$MOUNT_PROG --make-slave $mpB
-	$MOUNT_PROG --make-slave $mpC
+	_mount --make-slave $mpB
+	_mount --make-slave $mpC
 	_get_mount -t $FSTYP $SCRATCH_DEV $mpA/mnt1
 	mkdir $mpA/mnt1/mnt2
 
diff --git a/tests/generic/504 b/tests/generic/504
index 611e6c283e215a..931f231504b702 100755
--- a/tests/generic/504
+++ b/tests/generic/504
@@ -41,7 +41,7 @@ exec {test_fd}> $testfile
 if [ "$FSTESTS_ISOL" = "privatens" ]; then
 	move_proc="$tmp.procdir"
 	mkdir -p "$move_proc"
-	mount --move /proc "$move_proc"
+	_mount --move /proc "$move_proc"
 fi
 flock -x $test_fd
 cat /proc/locks >> $seqres.full
@@ -50,7 +50,7 @@ cat /proc/locks >> $seqres.full
 grep -q ":$tf_inode " /proc/locks || echo "lock info not found"
 
 if [ -n "$move_proc" ]; then
-	mount --move "$move_proc" /proc
+	_mount --move "$move_proc" /proc
 fi
 
 # success, all done
diff --git a/tests/generic/589 b/tests/generic/589
index 0384083bbf4251..e7627f26c75996 100755
--- a/tests/generic/589
+++ b/tests/generic/589
@@ -81,12 +81,12 @@ start_test()
 
 	_get_mount -t $FSTYP $SCRATCH_DEV $SRCHEAD
 	# make sure $SRCHEAD is private
-	$MOUNT_PROG --make-private $SRCHEAD
+	_mount --make-private $SRCHEAD
 
 	_get_mount -t $FSTYP $SCRATCH_DEV $DSTHEAD
 	# test start with a bind, then make-shared $DSTHEAD
 	_get_mount --bind $DSTHEAD $DSTHEAD
-	$MOUNT_PROG --make-"${type}" $DSTHEAD
+	_mount --make-"${type}" $DSTHEAD
 	mkdir $mpA $mpB $mpC $mpD
 }
 
@@ -106,10 +106,10 @@ move_run()
 	echo "move $source to $dest"
 	_get_mount -t $FSTYP $SCRATCH_DEV $mpA
 	mkdir -p $mpA/dir 2>/dev/null
-	$MOUNT_PROG --make-shared $mpA
+	_mount --make-shared $mpA
 	# need a peer for slave later
 	_get_mount --bind $mpA $mpB
-	$MOUNT_PROG --make-"$source" $mpB
+	_mount --make-"$source" $mpB
 	# maybe unbindable at here
 	_get_mount --move $mpB $mpC 2>/dev/null
 	if [ $? -ne 0 ]; then
diff --git a/tests/generic/631 b/tests/generic/631
index 8b12b8f247ee81..96e917e8c25314 100755
--- a/tests/generic/631
+++ b/tests/generic/631
@@ -80,7 +80,7 @@ worker() {
 		mkdir $SCRATCH_MNT/workdir$tag
 		mkdir $SCRATCH_MNT/upperdir$tag
 
-		mount -t overlay overlay -o "$l,$u,$w,$i" $mergedir
+		_mount -t overlay overlay -o "$l,$u,$w,$i" $mergedir
 		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
 		touch $mergedir/etc/access.conf
 		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
diff --git a/tests/generic/717 b/tests/generic/717
index 2ecd2888d4590e..acbe787c5e42c1 100755
--- a/tests/generic/717
+++ b/tests/generic/717
@@ -82,7 +82,7 @@ $XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/c" $dir/a
 
 echo Files on different mounts
 mkdir -p $SCRATCH_MNT/xyz
-mount --bind $dir $SCRATCH_MNT/xyz --bind
+_mount --bind $dir $SCRATCH_MNT/xyz --bind
 _pwrite_byte 0x60 0 $((blksz * (nrblks + 2))) $dir/c >> $seqres.full
 $XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/xyz/c" $dir/a
 _unmount $SCRATCH_MNT/xyz
diff --git a/tests/overlay/005 b/tests/overlay/005
index d396b5cb213048..809154d9c66caa 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -51,8 +51,8 @@ $MKFS_XFS_PROG -f -n ftype=1 $upper_loop_dev >>$seqres.full 2>&1
 # mount underlying xfs
 mkdir -p ${OVL_BASE_SCRATCH_MNT}/lowermnt
 mkdir -p ${OVL_BASE_SCRATCH_MNT}/uppermnt
-$MOUNT_PROG $fs_loop_dev ${OVL_BASE_SCRATCH_MNT}/lowermnt
-$MOUNT_PROG $upper_loop_dev ${OVL_BASE_SCRATCH_MNT}/uppermnt
+_mount $fs_loop_dev ${OVL_BASE_SCRATCH_MNT}/lowermnt
+_mount $upper_loop_dev ${OVL_BASE_SCRATCH_MNT}/uppermnt
 
 # prepare dirs
 mkdir -p ${OVL_BASE_SCRATCH_MNT}/lowermnt/lower
diff --git a/tests/overlay/025 b/tests/overlay/025
index dc819a39348b69..6ba46191b557be 100755
--- a/tests/overlay/025
+++ b/tests/overlay/025
@@ -36,7 +36,7 @@ _require_extra_fs tmpfs
 # create a tmpfs in $TEST_DIR
 tmpfsdir=$TEST_DIR/tmpfs
 mkdir -p $tmpfsdir
-$MOUNT_PROG -t tmpfs tmpfs $tmpfsdir
+_mount -t tmpfs tmpfs $tmpfsdir
 
 mkdir -p $tmpfsdir/{lower,upper,work,mnt}
 mkdir -p -m 0 $tmpfsdir/upper/testd
diff --git a/tests/overlay/062 b/tests/overlay/062
index e44628b7459bfb..9a1db7419c4ca2 100755
--- a/tests/overlay/062
+++ b/tests/overlay/062
@@ -60,7 +60,7 @@ lowertestdir=$lower2/testdir
 create_test_files $lowertestdir
 
 # bind mount to pin lower test dir dentry to dcache
-$MOUNT_PROG --bind $lowertestdir $lowertestdir
+_mount --bind $lowertestdir $lowertestdir
 
 # For non-upper overlay mount, nfs_export requires disabling redirect_dir.
 _overlay_scratch_mount_opts \
diff --git a/tests/overlay/083 b/tests/overlay/083
index d037d4c858e6a6..56e02f8cc77d73 100755
--- a/tests/overlay/083
+++ b/tests/overlay/083
@@ -40,14 +40,14 @@ mkdir -p "$lowerdir_spaces" "$lowerdir_colons" "$lowerdir_commas"
 
 # _overlay_mount_* helpers do not handle special chars well, so execute mount directly.
 # if escaped colons are not parsed correctly, mount will fail.
-$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
+_mount -t overlay ovl_esc_test $SCRATCH_MNT \
 	-o"upperdir=$upperdir,workdir=$workdir" \
 	-o"lowerdir=$lowerdir_colons_esc:$lowerdir_spaces" \
 	2>&1 | tee -a $seqres.full
 
 # if spaces are not escaped when showing mount options,
 # mount command will not show the word 'spaces' after the spaces
-$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces && \
+_mount -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces && \
 	echo "ERROR: escaped spaces truncated from lowerdir mount option"
 
 # Re-create the upper/work dirs to mount them with a different lower
@@ -65,7 +65,7 @@ mkdir -p "$upperdir" "$workdir"
 # and this test will fail, but the failure would indicate a libmount issue, not
 # a kernel issue.  Therefore, force libmount to use mount(2) syscall, so we only
 # test the kernel fix.
-LIBMOUNT_FORCE_MOUNT2=always $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_DEV $SCRATCH_MNT \
+LIBMOUNT_FORCE_MOUNT2=always _mount -t overlay $OVL_BASE_SCRATCH_DEV $SCRATCH_MNT \
 	-o"upperdir=$upperdir,workdir=$workdir,lowerdir=$lowerdir_commas_esc" 2>> $seqres.full || \
 	echo "ERROR: incorrect parsing of escaped comma in lowerdir mount option"
 
diff --git a/tests/overlay/086 b/tests/overlay/086
index 9c8a00588595f6..23c56d074ff34a 100755
--- a/tests/overlay/086
+++ b/tests/overlay/086
@@ -33,21 +33,21 @@ mkdir -p "$lowerdir_spaces" "$lowerdir_colons"
 # _overlay_mount_* helpers do not handle lowerdir+,datadir+, so execute mount directly.
 
 # check illegal combinations and order of lowerdir,lowerdir+,datadir+
-$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+_mount -t overlay none $SCRATCH_MNT \
 	-o"lowerdir=$lowerdir,lowerdir+=$lowerdir_colons" \
 	2>> $seqres.full && \
 	echo "ERROR: invalid combination of lowerdir and lowerdir+ mount options"
 
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
-$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+_mount -t overlay none $SCRATCH_MNT \
 	-o"lowerdir=$lowerdir,datadir+=$lowerdir_colons" \
 	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
 	echo "ERROR: invalid combination of lowerdir and datadir+ mount options"
 
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
-$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+_mount -t overlay none $SCRATCH_MNT \
 	-o"datadir+=$lowerdir,lowerdir+=$lowerdir_colons" \
 	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
 	echo "ERROR: invalid order of lowerdir+ and datadir+ mount options"
@@ -55,7 +55,7 @@ $MOUNT_PROG -t overlay none $SCRATCH_MNT \
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 # mount is expected to fail with escaped colons.
-$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+_mount -t overlay none $SCRATCH_MNT \
 	-o"lowerdir+=$lowerdir_colons_esc" \
 	2>> $seqres.full && \
 	echo "ERROR: incorrect parsing of escaped colons in lowerdir+ mount option"
@@ -63,14 +63,14 @@ $MOUNT_PROG -t overlay none $SCRATCH_MNT \
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 # mount is expected to succeed without escaped colons.
-$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
+_mount -t overlay ovl_esc_test $SCRATCH_MNT \
 	-o"lowerdir+=$lowerdir_colons,datadir+=$lowerdir_spaces" \
 	-o redirect_dir=follow,metacopy=on \
 	2>&1 | tee -a $seqres.full
 
 # if spaces are not escaped when showing mount options,
 # mount command will not show the word 'spaces' after the spaces
-$MOUNT_PROG -t overlay | grep ovl_esc_test | tee -a $seqres.full | \
+_mount -t overlay | grep ovl_esc_test | tee -a $seqres.full | \
 	grep -q 'datadir+'.*spaces || \
 	echo "ERROR: escaped spaces truncated from datadir+ mount option"
 
diff --git a/tests/xfs/044 b/tests/xfs/044
index 3ecb3479302e22..e8280f382ae3b6 100755
--- a/tests/xfs/044
+++ b/tests/xfs/044
@@ -49,7 +49,7 @@ _check_no_mount()
 _check_require_logdev()
 {
     echo "    *** mount without logdev (expect failure)"
-    if mount -t xfs $SCRATCH_DEV $SCRATCH_MNT >$tmp.err 2>&1
+    if _mount -t xfs $SCRATCH_DEV $SCRATCH_MNT >$tmp.err 2>&1
     then
         cat $tmp.err
         echo "        !!! mount succeeded (expecting failure)"
diff --git a/tests/xfs/049 b/tests/xfs/049
index a3f478fa9351ab..64667a0d8baab2 100755
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -21,7 +21,7 @@ _cleanup()
 
 	if [ -w $seqres.full ]; then
 		echo "--- mounts at end (after cleanup)" >> $seqres.full
-		mount >> $seqres.full
+		_mount >> $seqres.full
 	fi
 }
 
@@ -47,14 +47,14 @@ echo "(dev=$SCRATCH_DEV, mount=$SCRATCH_MNT)" >> $seqres.full
 echo "" >> $seqres.full
 
 echo "--- mounts" >> $seqres.full
-mount >> $seqres.full
+_mount >> $seqres.full
 
 _log "Create ext2 fs on scratch"
 mkfs -t ext2 -F $SCRATCH_DEV >> $seqres.full 2>&1 \
     || _fail "!!! failed to mkfs ext2"
 
 _log "Mount ext2 fs on scratch"
-mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seqres.full 2>&1 \
+_mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seqres.full 2>&1 \
     || _fail "!!! failed to mount"
 
 _log "Create xfs fs in file on scratch"
@@ -114,7 +114,7 @@ _destroy_loop_device $loop_dev1
 unset loop_dev1
 
 echo "--- mounts at end (before cleanup)" >> $seqres.full
-mount >> $seqres.full
+_mount >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/xfs/149 b/tests/xfs/149
index 28dfc7f04c1773..baf6e22b98e289 100755
--- a/tests/xfs/149
+++ b/tests/xfs/149
@@ -64,7 +64,7 @@ $XFS_GROWFS_PROG $loop_symlink 2>&1 | sed -e s:$loop_symlink:LOOPSYMLINK:
 # These mounted operations should pass
 
 echo "=== mount ==="
-$MOUNT_PROG $loop_dev $mntdir || _fail "!!! failed to loopback mount"
+_mount $loop_dev $mntdir || _fail "!!! failed to loopback mount"
 
 echo "=== xfs_growfs - check device node ==="
 $XFS_GROWFS_PROG -D 8192 $loop_dev > /dev/null
@@ -76,7 +76,7 @@ echo "=== unmount ==="
 _unmount $mntdir || _fail "!!! failed to unmount"
 
 echo "=== mount device symlink ==="
-$MOUNT_PROG $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
+_mount $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
 
 echo "=== xfs_growfs - check device symlink ==="
 $XFS_GROWFS_PROG -D 16384 $loop_symlink > /dev/null
diff --git a/tests/xfs/206 b/tests/xfs/206
index bfd2dee939ddd7..a515c6c8838cff 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -75,7 +75,7 @@ echo "=== mkfs.xfs ==="
 mkfs.xfs -f -bsize=4096 -l size=32m -dagsize=76288719b,size=3905982455b \
 	 $tmpfile  | mkfs_filter
 
-mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
+_mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
 
 # see what happens when we growfs it
 echo "=== xfs_growfs ==="
diff --git a/tests/xfs/250 b/tests/xfs/250
index 2554e1e91c4c6f..0c3f6f075c1cb2 100755
--- a/tests/xfs/250
+++ b/tests/xfs/250
@@ -57,7 +57,7 @@ _test_loop()
 
 	echo "*** mount loop filesystem"
 	loop_dev=$(_create_loop_device $LOOP_IMG)
-	mount $loop_dev $LOOP_MNT
+	_mount $loop_dev $LOOP_MNT
 
 	echo "*** preallocate large file"
 	$XFS_IO_PROG -f -c "resvsp 0 $fsize" $LOOP_MNT/foo | _filter_io
diff --git a/tests/xfs/289 b/tests/xfs/289
index d234f212d49b83..c2216f2826a9d1 100755
--- a/tests/xfs/289
+++ b/tests/xfs/289
@@ -56,7 +56,7 @@ echo "=== xfs_growfs - plain file - should be rejected ==="
 $XFS_GROWFS_PROG $tmpfile 2>&1 | _filter_test_dir
 
 echo "=== mount ==="
-$MOUNT_PROG -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
+_mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
 
 echo "=== xfs_growfs - mounted - check absolute path ==="
 $XFS_GROWFS_PROG -D 8192 $tmpdir | _filter_test_dir > /dev/null
@@ -79,7 +79,7 @@ $XFS_GROWFS_PROG -D 28672 tmpsymlink.$$ > /dev/null
 
 echo "=== xfs_growfs - bind mount ==="
 mkdir $tmpbind
-$MOUNT_PROG -o bind $tmpdir $tmpbind
+_mount -o bind $tmpdir $tmpbind
 $XFS_GROWFS_PROG -D 32768 $tmpbind | _filter_test_dir > /dev/null
 
 echo "=== xfs_growfs - bind mount - relative path ==="
diff --git a/tests/xfs/300 b/tests/xfs/300
index c4c3b1ab86c200..534a0e9d059b91 100755
--- a/tests/xfs/300
+++ b/tests/xfs/300
@@ -27,7 +27,7 @@ getenforce | grep -q "Enforcing\|Permissive" || _notrun "SELinux not enabled"
 _scratch_mkfs_xfs -m crc=0 -i size=256 >> $seqres.full 2>&1
 
 # Manually mount to avoid fs-wide context set by default in xfstests
-mount $SCRATCH_DEV $SCRATCH_MNT
+_mount $SCRATCH_DEV $SCRATCH_MNT
 
 touch $SCRATCH_MNT/$seq.test
 
diff --git a/tests/xfs/507 b/tests/xfs/507
index 52d9b94b4dd903..e1450f4f8f9495 100755
--- a/tests/xfs/507
+++ b/tests/xfs/507
@@ -86,7 +86,7 @@ loop_dev=$(_create_loop_device $loop_file)
 
 _mkfs_dev -d cowextsize=$MAXEXTLEN -l size=256m $loop_dev >> $seqres.full
 mkdir $loop_mount
-mount $loop_dev $loop_mount
+_mount $loop_dev $loop_mount
 
 echo "Create crazy huge file"
 huge_file="$loop_mount/a"
diff --git a/tests/xfs/544 b/tests/xfs/544
index b7eef51c7fddbe..9e4e0d255bd3c9 100755
--- a/tests/xfs/544
+++ b/tests/xfs/544
@@ -35,7 +35,7 @@ mkdir $TEST_DIR/dest.$seq
 # Test
 echo "*** dump with bind-mounted test ***" >> $seqres.full
 
-$MOUNT_PROG --bind $TEST_DIR/src.$seq $TEST_DIR/dest.$seq || _fail "Bind mount failed"
+_mount --bind $TEST_DIR/src.$seq $TEST_DIR/dest.$seq || _fail "Bind mount failed"
 
 $XFSDUMP_PROG -L session -M test -f $tmp.dump $TEST_DIR/dest.$seq \
 	>> $seqres.full 2>&1 && echo "dump with bind-mounted should be failed, but passed."

