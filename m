Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187F329415;
	Tue, 31 Dec 2024 23:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689395; cv=none; b=ba+SMRlZsIJQ9kZM6RTARsBjnxuoSDbQ22wRRadJEZlnWMQVHqdVfqBUvn3bhNLrmjVbpu8GEIgJWhkvMzjqnAPiJ9BKvgCn+QjTNWJGXTGdIDvKjE2pfBXcyTEbU9qOJ99/9Xui1b6J7mmgQkv1dEFbUeSRIf94Bsl8+nzuYtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689395; c=relaxed/simple;
	bh=hI+UzDrtdvHyRtEVHq7UDBfrNKySdaifvUgxu+jReXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QkrkAxScjAEjNFHzLby6yPWgos/t5YcOyaiCFopT+qZLpSgx5YEpn7/wbUcjEHb3QZm+iPWSJ+cUY4KVYtJr7fgpejZVAVIKxt2xstpSASfCVL050MfzltHxcl3Ex0N0j7Elbd0AeOWRiiYthLbTJ1zvmdPMtRLd9PSNE5zZD78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaIJ2uVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaIJ2uVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2A9C4CED2;
	Tue, 31 Dec 2024 23:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689394;
	bh=hI+UzDrtdvHyRtEVHq7UDBfrNKySdaifvUgxu+jReXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UaIJ2uVdbAJ9diqf9JVNpGfZ8yItJ5J3tHvPYigagkpCEDYpDZPmondtreggYMbFw
	 9thn9pMk+EJYNqJZuKPZTJ0L+8xSwJ+gFw2fg/lQeTIpyIStu5Gv90mnQm/cz/c8Ll
	 xbDnFKUWKBxfhWegOXCQfrr2gpLttnqrkS5fcGLcLdehbIjspbE/INvSzGPnkOsIRj
	 Yg4ITkOXvlasXrzcFD9rJ8/4LMD995FLNHnpmdCBMxOnmIlvQT0zCrZ1BftPDauAQv
	 OhqCZi9BtJp2Sy32vdW+k1yLH5KPsKGFDI9nXY59TxIJLcn6tRXzWU7oSX2/6ri+g7
	 TETGOuD0J2uyg==
Date: Tue, 31 Dec 2024 15:56:34 -0800
Subject: [PATCH 1/2] treewide: convert all $MOUNT_PROG to _mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568782742.2712126.2747370406566328587.stgit@frogsfrogsfrogs>
In-Reply-To: <173568782724.2712126.2021149328064840091.stgit@frogsfrogsfrogs>
References: <173568782724.2712126.2021149328064840091.stgit@frogsfrogsfrogs>
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
 tests/btrfs/075    |    2 +-
 tests/btrfs/208    |    2 +-
 tests/ext4/032     |    2 +-
 tests/generic/067  |    6 +++---
 tests/generic/085  |    2 +-
 tests/generic/361  |    2 +-
 tests/generic/373  |    2 +-
 tests/generic/374  |    2 +-
 tests/generic/409  |    6 +++---
 tests/generic/410  |    8 ++++----
 tests/generic/411  |    8 ++++----
 tests/generic/589  |    8 ++++----
 tests/overlay/005  |    4 ++--
 tests/overlay/025  |    2 +-
 tests/overlay/035  |    2 +-
 tests/overlay/062  |    2 +-
 tests/overlay/083  |    6 +++---
 tests/overlay/086  |   12 ++++++------
 tests/xfs/078      |    2 +-
 tests/xfs/149      |    4 ++--
 tests/xfs/289      |    4 ++--
 tests/xfs/544      |    2 +-
 27 files changed, 53 insertions(+), 53 deletions(-)


diff --git a/common/btrfs b/common/btrfs
index 95a9c8e6c7f448..64f38cc240ab8b 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -351,7 +351,7 @@ _btrfs_stress_subvolume()
 	mkdir -p $subvol_mnt
 	while [ ! -e $stop_file ]; do
 		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
-		$MOUNT_PROG -o subvol=$subvol_name $btrfs_dev $subvol_mnt
+		_mount -o subvol=$subvol_name $btrfs_dev $subvol_mnt
 		$UMOUNT_PROG $subvol_mnt
 		$BTRFS_UTIL_PROG subvolume delete $btrfs_mnt/$subvol_name
 	done
@@ -437,7 +437,7 @@ _btrfs_stress_remount_compress()
 	local btrfs_mnt=$1
 	while true; do
 		for algo in no zlib lzo; do
-			$MOUNT_PROG -o remount,compress=$algo $btrfs_mnt
+			_mount -o remount,compress=$algo $btrfs_mnt
 		done
 	done
 }
diff --git a/common/dmdelay b/common/dmdelay
index 66cac1a70c14c8..794ea37ba200ce 100644
--- a/common/dmdelay
+++ b/common/dmdelay
@@ -20,7 +20,7 @@ _init_delay()
 _mount_delay()
 {
 	_scratch_options mount
-	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options` $SCRATCH_OPTIONS \
+	_mount -t $FSTYP `_common_dev_mount_options` $SCRATCH_OPTIONS \
 		$DELAY_DEV $SCRATCH_MNT
 }
 
diff --git a/common/dmerror b/common/dmerror
index 3494b6dd3b9479..2f006142a309fe 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -91,7 +91,7 @@ _dmerror_init()
 _dmerror_mount()
 {
 	_scratch_options mount
-	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
+	_mount -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
 		$DMERROR_DEV $SCRATCH_MNT
 }
 
diff --git a/common/dmlogwrites b/common/dmlogwrites
index 7a8a9078cb8b65..c054acb875a384 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -139,7 +139,7 @@ _log_writes_mkfs()
 _log_writes_mount()
 {
 	_scratch_options mount
-	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
+	_mount -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
 		$LOGWRITES_DMDEV $SCRATCH_MNT
 }
 
diff --git a/common/overlay b/common/overlay
index faa9339a6477f7..da1d8d2c3183f4 100644
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
@@ -127,7 +127,7 @@ _overlay_base_scratch_mount()
 _overlay_scratch_mount()
 {
 	if echo "$*" | grep -q remount; then
-		$MOUNT_PROG $SCRATCH_MNT $*
+		_mount $SCRATCH_MNT $*
 		return
 	fi
 
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
 
diff --git a/tests/ext4/032 b/tests/ext4/032
index 238ab178363c12..9a1b9312cc42cc 100755
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
index b561b7bc5946a2..b6e984f5231753 100755
--- a/tests/generic/067
+++ b/tests/generic/067
@@ -34,7 +34,7 @@ mount_nonexistent_mnt()
 {
 	echo "# mount to nonexistent mount point" >>$seqres.full
 	rm -rf $TEST_DIR/nosuchdir
-	$MOUNT_PROG $SCRATCH_DEV $TEST_DIR/nosuchdir >>$seqres.full 2>&1
+	_mount $SCRATCH_DEV $TEST_DIR/nosuchdir >>$seqres.full 2>&1
 }
 
 # fs driver should be able to handle mounting a free loop device gracefully
@@ -43,7 +43,7 @@ mount_free_loopdev()
 {
 	echo "# mount a free loop device" >>$seqres.full
 	loopdev=`losetup -f`
-	$MOUNT_PROG -t $FSTYP $loopdev $SCRATCH_MNT >>$seqres.full 2>&1
+	_mount -t $FSTYP $loopdev $SCRATCH_MNT >>$seqres.full 2>&1
 }
 
 # mount with wrong fs type specified.
@@ -55,7 +55,7 @@ mount_wrong_fstype()
 		fs=xfs
 	fi
 	echo "# mount with wrong fs type" >>$seqres.full
-	$MOUNT_PROG -t $fs $SCRATCH_DEV $SCRATCH_MNT >>$seqres.full 2>&1
+	_mount -t $fs $SCRATCH_DEV $SCRATCH_MNT >>$seqres.full 2>&1
 }
 
 # umount a symlink to device, which is not mounted.
diff --git a/tests/generic/085 b/tests/generic/085
index cfe6112d6b444d..cbabd257cad8f0 100755
--- a/tests/generic/085
+++ b/tests/generic/085
@@ -69,7 +69,7 @@ for ((i=0; i<100; i++)); do
 done &
 pid=$!
 for ((i=0; i<100; i++)); do
-	$MOUNT_PROG $lvdev $SCRATCH_MNT >/dev/null 2>&1
+	_mount $lvdev $SCRATCH_MNT >/dev/null 2>&1
 	$UMOUNT_PROG $lvdev >/dev/null 2>&1
 done &
 pid="$pid $!"
diff --git a/tests/generic/361 b/tests/generic/361
index c56157391d3209..c2ebda3c1a01ad 100755
--- a/tests/generic/361
+++ b/tests/generic/361
@@ -52,7 +52,7 @@ fi
 $XFS_IO_PROG -fc "pwrite 0 520m" $fs_mnt/testfile >>$seqres.full 2>&1
 
 # remount should not hang
-$MOUNT_PROG -o remount,ro $fs_mnt >>$seqres.full 2>&1
+_mount -o remount,ro $fs_mnt >>$seqres.full 2>&1
 
 # success, all done
 echo "Silence is golden"
diff --git a/tests/generic/373 b/tests/generic/373
index 3bd46963a76686..0d5a50cbee40b8 100755
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
index acb23d17289784..977a2b268bbc98 100755
--- a/tests/generic/374
+++ b/tests/generic/374
@@ -41,7 +41,7 @@ blksz=65536
 sz=$((blocks * blksz))
 
 echo "Mount otherdir"
-$MOUNT_PROG --bind $SCRATCH_MNT $otherdir
+_mount --bind $SCRATCH_MNT $otherdir
 
 echo "Create file"
 _pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
diff --git a/tests/generic/409 b/tests/generic/409
index b7edc2ac664461..79468e2b0ddb41 100755
--- a/tests/generic/409
+++ b/tests/generic/409
@@ -87,7 +87,7 @@ start_test()
 
 	_scratch_mkfs >$seqres.full 2>&1
 	_get_mount -t $FSTYP $SCRATCH_DEV $MNTHEAD
-	$MOUNT_PROG --make-"${type}" $MNTHEAD
+	_mount --make-"${type}" $MNTHEAD
 	mkdir $mpA $mpB $mpC $mpD
 }
 
@@ -107,9 +107,9 @@ bind_run()
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
index 902f27144285e4..db8c97dbac7701 100755
--- a/tests/generic/410
+++ b/tests/generic/410
@@ -93,7 +93,7 @@ start_test()
 
 	_scratch_mkfs >>$seqres.full 2>&1
 	_get_mount -t $FSTYP $SCRATCH_DEV $MNTHEAD
-	$MOUNT_PROG --make-"${type}" $MNTHEAD
+	_mount --make-"${type}" $MNTHEAD
 	mkdir $mpA $mpB $mpC
 }
 
@@ -117,14 +117,14 @@ run()
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
@@ -145,7 +145,7 @@ run()
 			_put_mount # umount C
 		fi
 		if [ "$i" = "before" ];then
-			$MOUNT_PROG --make-"${cmd}" $mpB
+			_mount --make-"${cmd}" $mpB
 		fi
 	done
 
diff --git a/tests/generic/411 b/tests/generic/411
index c35436c82e988e..09a813f5d3028e 100755
--- a/tests/generic/411
+++ b/tests/generic/411
@@ -76,7 +76,7 @@ start_test()
 
 	_scratch_mkfs >$seqres.full 2>&1
 	_get_mount -t $FSTYP $SCRATCH_DEV $MNTHEAD
-	$MOUNT_PROG --make-"${type}" $MNTHEAD
+	_mount --make-"${type}" $MNTHEAD
 	mkdir $mpA $mpB $mpC
 }
 
@@ -99,11 +99,11 @@ crash_test()
 
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
 
diff --git a/tests/generic/589 b/tests/generic/589
index 0ce16556a05df9..6f69abd17ab01e 100755
--- a/tests/generic/589
+++ b/tests/generic/589
@@ -80,12 +80,12 @@ start_test()
 
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
 
@@ -105,10 +105,10 @@ move_run()
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
diff --git a/tests/overlay/005 b/tests/overlay/005
index 4c11d5e1b6f701..01914ee17b9a30 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -50,8 +50,8 @@ $MKFS_XFS_PROG -f -n ftype=1 $upper_loop_dev >>$seqres.full 2>&1
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
diff --git a/tests/overlay/035 b/tests/overlay/035
index 0b3257c4cce09e..cede58790e1b9d 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -42,7 +42,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 # Verify that overlay is mounted read-only and that it cannot be remounted rw.
 _overlay_scratch_mount_opts -o"lowerdir=$lowerdir2:$lowerdir1"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
-$MOUNT_PROG -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
+_mount -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
 $UMOUNT_PROG $SCRATCH_MNT
 
 # Make workdir immutable to prevent workdir re-create on mount
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
 
diff --git a/tests/xfs/078 b/tests/xfs/078
index 834c99a0020153..4224fd40bc9fea 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -75,7 +75,7 @@ _grow_loop()
 	$XFS_IO_PROG -c "pwrite $new_size $bsize" $LOOP_IMG | _filter_io
 	LOOP_DEV=`_create_loop_device $LOOP_IMG`
 	echo "*** mount loop filesystem"
-	$MOUNT_PROG -t xfs $LOOP_DEV $LOOP_MNT
+	_mount -t xfs $LOOP_DEV $LOOP_MNT
 
 	echo "*** grow loop filesystem"
 	$XFS_GROWFS_PROG $LOOP_MNT 2>&1 |  _filter_growfs 2>&1
diff --git a/tests/xfs/149 b/tests/xfs/149
index f1b2405e7bff11..bbaf86132dff37 100755
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
 $UMOUNT_PROG $mntdir || _fail "!!! failed to unmount"
 
 echo "=== mount device symlink ==="
-$MOUNT_PROG $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
+_mount $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
 
 echo "=== xfs_growfs - check device symlink ==="
 $XFS_GROWFS_PROG -D 16384 $loop_symlink > /dev/null
diff --git a/tests/xfs/289 b/tests/xfs/289
index cf0f2883c4f373..089a3f8cc14a68 100755
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
diff --git a/tests/xfs/544 b/tests/xfs/544
index bd694453d5409f..a3a23c1726ca1c 100755
--- a/tests/xfs/544
+++ b/tests/xfs/544
@@ -35,7 +35,7 @@ mkdir $TEST_DIR/dest.$seq
 # Test
 echo "*** dump with bind-mounted test ***" >> $seqres.full
 
-$MOUNT_PROG --bind $TEST_DIR/src.$seq $TEST_DIR/dest.$seq || _fail "Bind mount failed"
+_mount --bind $TEST_DIR/src.$seq $TEST_DIR/dest.$seq || _fail "Bind mount failed"
 
 $XFSDUMP_PROG -L session -M test -f $tmp.dump $TEST_DIR/dest.$seq \
 	>> $seqres.full 2>&1 && echo "dump with bind-mounted should be failed, but passed."

