Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD7B1B0425;
	Tue, 31 Dec 2024 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689426; cv=none; b=iSK6we1tApgu2lDuVGwN2mlBYzdODjsTJRPdpx6Td6QdzXGrAc7eeFBgG45j8hfjPRlOWDvdxI3pvQIY4QwPbEoUSgkyD/HVgJfevIeL34vd3VsYlvF0f3oqkp31h4oHEaVk4sGdWZZAeWqwpEIDc8JgwRUGnW73yrS2RpykOyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689426; c=relaxed/simple;
	bh=+UnN2MMPTWY8SLRHTqy1HvplDZKcYScHRaQtidC8IRc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cUYML6jw5QFkIGTfiKUyFgpGk8jmI3S+Nlc6adjThxMPQ9PZcQ4nh0s9g6lXLMLGzSBylSJrmY0872atZfcOzn3/FpEJBWeKyrdI6bstM2+qTNsRPuoUBXH0oVzccajlP+pv50syShKr38w/tX/sGHqBbxcy5+Q2u7SI1q8kR08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUZu4lO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUZu4lO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D628EC4CED2;
	Tue, 31 Dec 2024 23:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689426;
	bh=+UnN2MMPTWY8SLRHTqy1HvplDZKcYScHRaQtidC8IRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MUZu4lO99oiFwx9xZlA7WWtl0BGlMBvhaxXG/fVArW8leoLkXojOmNapehF4A7SgK
	 zfh190xy5EyW/fiWxULAzVIY/uM2Z/GETRnd33D4XF7/QuDgfRysGSeMrIXGzTbyTI
	 3ljGjSwQcjKTE+F9Gh19sXYBe9V3wkUxUR7UVZ0coJCvJe5EsylywIFT/jrfC/8Z9H
	 5QJV59hPqtNQra8vpC9A39jaQYgT4XATs/7H0hzHHyNM6Ztgs5fkNPY66HPjpp6bRw
	 /+l4ksLmQlb1sTupStnoyi0ZYKsB9sqHRX6nxWdQJ3dnA6A9fiYFq/sTIrRXU+5LKG
	 tLu8ZZ2yJKIXQ==
Date: Tue, 31 Dec 2024 15:57:05 -0800
Subject: [PATCH 1/6] misc: convert all $UMOUNT_PROG to a _umount helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783146.2712254.8173054699669385864.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
References: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're going to start collecting ephemeral(ish) filesystem stats in the
next patch, so switch all the $UMOUNT_PROG to a helper.

sed -e 's/$UMOUNT_PROG/_umount/g' -i $(git ls-files common tests check)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/btrfs       |    2 +-
 common/dmdelay     |    4 ++--
 common/dmdust      |    4 ++--
 common/dmerror     |    2 +-
 common/dmflakey    |    4 ++--
 common/dmhugedisk  |    2 +-
 common/dmlogwrites |    4 ++--
 common/dmthin      |    4 ++--
 common/overlay     |   10 +++++-----
 common/rc          |   33 +++++++++++++++++++--------------
 tests/btrfs/020    |    2 +-
 tests/btrfs/029    |    2 +-
 tests/btrfs/031    |    2 +-
 tests/btrfs/060    |    2 +-
 tests/btrfs/065    |    2 +-
 tests/btrfs/066    |    2 +-
 tests/btrfs/067    |    2 +-
 tests/btrfs/068    |    2 +-
 tests/btrfs/075    |    2 +-
 tests/btrfs/089    |    2 +-
 tests/btrfs/124    |    2 +-
 tests/btrfs/125    |    2 +-
 tests/btrfs/185    |    4 ++--
 tests/btrfs/197    |    4 ++--
 tests/btrfs/219    |   12 ++++++------
 tests/btrfs/254    |    2 +-
 tests/ext4/032     |    4 ++--
 tests/ext4/052     |    4 ++--
 tests/ext4/053     |   32 ++++++++++++++++----------------
 tests/ext4/056     |    2 +-
 tests/generic/042  |    4 ++--
 tests/generic/067  |    6 +++---
 tests/generic/081  |    2 +-
 tests/generic/085  |    4 ++--
 tests/generic/108  |    2 +-
 tests/generic/361  |    2 +-
 tests/generic/373  |    2 +-
 tests/generic/374  |    2 +-
 tests/generic/459  |    2 +-
 tests/generic/604  |    2 ++
 tests/generic/648  |    6 +++---
 tests/generic/698  |    4 ++--
 tests/generic/699  |    8 ++++----
 tests/generic/704  |    2 +-
 tests/generic/730  |    2 +-
 tests/generic/731  |    2 +-
 tests/generic/732  |    4 ++--
 tests/generic/746  |    8 ++++----
 tests/overlay/003  |    2 +-
 tests/overlay/004  |    2 +-
 tests/overlay/005  |    6 +++---
 tests/overlay/014  |    4 ++--
 tests/overlay/022  |    2 +-
 tests/overlay/025  |    4 ++--
 tests/overlay/029  |    6 +++---
 tests/overlay/031  |    8 ++++----
 tests/overlay/035  |    2 +-
 tests/overlay/036  |    8 ++++----
 tests/overlay/037  |    6 +++---
 tests/overlay/040  |    2 +-
 tests/overlay/041  |    2 +-
 tests/overlay/042  |    2 +-
 tests/overlay/043  |    2 +-
 tests/overlay/044  |    2 +-
 tests/overlay/048  |    4 ++--
 tests/overlay/049  |    2 +-
 tests/overlay/050  |    2 +-
 tests/overlay/051  |    4 ++--
 tests/overlay/052  |    2 +-
 tests/overlay/053  |    4 ++--
 tests/overlay/054  |    2 +-
 tests/overlay/055  |    4 ++--
 tests/overlay/056  |    2 +-
 tests/overlay/057  |    4 ++--
 tests/overlay/059  |    2 +-
 tests/overlay/060  |    2 +-
 tests/overlay/062  |    2 +-
 tests/overlay/063  |    2 +-
 tests/overlay/065  |   22 +++++++++++-----------
 tests/overlay/067  |    2 +-
 tests/overlay/068  |    4 ++--
 tests/overlay/069  |    6 +++---
 tests/overlay/070  |    6 +++---
 tests/overlay/071  |    6 +++---
 tests/overlay/076  |    2 +-
 tests/overlay/077  |    2 +-
 tests/overlay/078  |    2 +-
 tests/overlay/079  |    2 +-
 tests/overlay/080  |    2 +-
 tests/overlay/081  |   14 +++++++-------
 tests/overlay/083  |    2 +-
 tests/overlay/084  |   10 +++++-----
 tests/overlay/085  |    2 +-
 tests/overlay/086  |    8 ++++----
 tests/xfs/078      |    4 ++--
 tests/xfs/148      |    6 +++---
 tests/xfs/149      |    4 ++--
 tests/xfs/186      |    4 ++--
 tests/xfs/289      |    4 ++--
 tests/xfs/507      |    2 +-
 tests/xfs/513      |    4 ++--
 tests/xfs/544      |    2 +-
 tests/xfs/806      |    4 ++--
 103 files changed, 226 insertions(+), 219 deletions(-)


diff --git a/common/btrfs b/common/btrfs
index 64f38cc240ab8b..b82c8f5a934cfd 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -352,7 +352,7 @@ _btrfs_stress_subvolume()
 	while [ ! -e $stop_file ]; do
 		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
 		_mount -o subvol=$subvol_name $btrfs_dev $subvol_mnt
-		$UMOUNT_PROG $subvol_mnt
+		_umount $subvol_mnt
 		$BTRFS_UTIL_PROG subvolume delete $btrfs_mnt/$subvol_name
 	done
 }
diff --git a/common/dmdelay b/common/dmdelay
index 794ea37ba200ce..691e22538a622b 100644
--- a/common/dmdelay
+++ b/common/dmdelay
@@ -26,7 +26,7 @@ _mount_delay()
 
 _unmount_delay()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 _cleanup_delay()
@@ -34,7 +34,7 @@ _cleanup_delay()
 	# If dmsetup load fails then we need to make sure to do resume here
 	# otherwise the umount will hang
 	$DMSETUP_PROG resume delay-test > /dev/null 2>&1
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_dmsetup_remove delay-test
 }
 
diff --git a/common/dmdust b/common/dmdust
index 56fcc0e0fffa1e..13461c2dd3a006 100644
--- a/common/dmdust
+++ b/common/dmdust
@@ -22,7 +22,7 @@ _mount_dust()
 
 _unmount_dust()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 _cleanup_dust()
@@ -30,6 +30,6 @@ _cleanup_dust()
 	# If dmsetup load fails then we need to make sure to do resume here
 	# otherwise the umount will hang
 	$DMSETUP_PROG resume dust-test > /dev/null 2>&1
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_dmsetup_remove dust-test
 }
diff --git a/common/dmerror b/common/dmerror
index 2f006142a309fe..1e6a35230f3ccb 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -106,7 +106,7 @@ _dmerror_cleanup()
 	test -n "$NON_ERROR_RTDEV" && $DMSETUP_PROG resume error-rttest &>/dev/null
 	$DMSETUP_PROG resume error-test > /dev/null 2>&1
 
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 
 	test -n "$NON_ERROR_LOGDEV" && _dmsetup_remove error-logtest
 	test -n "$NON_ERROR_RTDEV" && _dmsetup_remove error-rttest
diff --git a/common/dmflakey b/common/dmflakey
index 52da3b100fbe45..64723f983b27ec 100644
--- a/common/dmflakey
+++ b/common/dmflakey
@@ -67,7 +67,7 @@ _mount_flakey()
 
 _unmount_flakey()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 _cleanup_flakey()
@@ -78,7 +78,7 @@ _cleanup_flakey()
 	test -n "$NON_FLAKEY_RTDEV" && $DMSETUP_PROG resume flakey-rttest &> /dev/null
 	$DMSETUP_PROG resume flakey-test > /dev/null 2>&1
 
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 
 	_dmsetup_remove flakey-test
 	test -n "$NON_FLAKEY_LOGDEV" && _dmsetup_remove flakey-logtest
diff --git a/common/dmhugedisk b/common/dmhugedisk
index 502f0243772d52..a02bff4351d9be 100644
--- a/common/dmhugedisk
+++ b/common/dmhugedisk
@@ -39,7 +39,7 @@ _dmhugedisk_init()
 
 _dmhugedisk_cleanup()
 {
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_dmsetup_remove huge-test
 	_dmsetup_remove huge-test-zero
 }
diff --git a/common/dmlogwrites b/common/dmlogwrites
index c054acb875a384..a1a5c415338276 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -145,7 +145,7 @@ _log_writes_mount()
 
 _log_writes_unmount()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # _log_writes_replay_log <mark>
@@ -177,7 +177,7 @@ _log_writes_remove()
 
 _log_writes_cleanup()
 {
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_log_writes_remove
 }
 
diff --git a/common/dmthin b/common/dmthin
index 7107d50804896e..38d561c8eb25d6 100644
--- a/common/dmthin
+++ b/common/dmthin
@@ -23,7 +23,7 @@ DMTHIN_VOL_DEV="/dev/mapper/$DMTHIN_VOL_NAME"
 
 _dmthin_cleanup()
 {
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_dmsetup_remove $DMTHIN_VOL_NAME
 	_dmsetup_remove $DMTHIN_POOL_NAME
 	_dmsetup_remove $DMTHIN_META_NAME
@@ -32,7 +32,7 @@ _dmthin_cleanup()
 
 _dmthin_check_fs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_check_scratch_fs $DMTHIN_VOL_DEV
 }
 
diff --git a/common/overlay b/common/overlay
index da1d8d2c3183f4..2877f31e22ebd9 100644
--- a/common/overlay
+++ b/common/overlay
@@ -142,18 +142,18 @@ _overlay_base_unmount()
 
 	[ -n "$dev" -a -n "$mnt" ] || return 0
 
-	$UMOUNT_PROG $mnt
+	_umount $mnt
 }
 
 _overlay_test_unmount()
 {
-	$UMOUNT_PROG $TEST_DIR
+	_umount $TEST_DIR
 	_overlay_base_unmount "$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR"
 }
 
 _overlay_scratch_unmount()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_overlay_base_unmount "$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT"
 }
 
@@ -342,7 +342,7 @@ _overlay_check_scratch_dirs()
 
 	# Need to umount overlay for scratch dir check
 	local ovl_mounted=`_is_dir_mountpoint $SCRATCH_MNT`
-	[ -z "$ovl_mounted" ] || $UMOUNT_PROG $SCRATCH_MNT
+	[ -z "$ovl_mounted" ] || _umount $SCRATCH_MNT
 
 	# Check dirs with extra overlay options
 	_overlay_check_dirs $lowerdir $upperdir $workdir $*
@@ -387,7 +387,7 @@ _overlay_check_fs()
 	else
 		# Check and umount overlay for dir check
 		ovl_mounted=`_is_dir_mountpoint $ovl_mnt`
-		[ -z "$ovl_mounted" ] || $UMOUNT_PROG $ovl_mnt
+		[ -z "$ovl_mounted" ] || _umount $ovl_mnt
 	fi
 
 	_overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
diff --git a/common/rc b/common/rc
index 0ede68eb912440..d3ee76e01db892 100644
--- a/common/rc
+++ b/common/rc
@@ -233,6 +233,11 @@ _mount()
 	return $ret
 }
 
+_umount()
+{
+	$UMOUNT_PROG $*
+}
+
 # Call _mount to do mount operation but also save mountpoint to
 # MOUNTED_POINT_STACK. Note that the mount point must be the last parameter
 _get_mount()
@@ -266,7 +271,7 @@ _put_mount()
 	local last_mnt=`echo $MOUNTED_POINT_STACK | awk '{print $1}'`
 
 	if [ -n "$last_mnt" ]; then
-		$UMOUNT_PROG $last_mnt
+		_umount $last_mnt
 	fi
 	MOUNTED_POINT_STACK=`echo $MOUNTED_POINT_STACK | cut -d\  -f2-`
 }
@@ -275,7 +280,7 @@ _put_mount()
 _clear_mount_stack()
 {
 	if [ -n "$MOUNTED_POINT_STACK" ]; then
-		$UMOUNT_PROG $MOUNTED_POINT_STACK
+		_umount $MOUNTED_POINT_STACK
 	fi
 	MOUNTED_POINT_STACK=""
 }
@@ -420,20 +425,20 @@ _scratch_unmount()
 		_overlay_scratch_unmount
 		;;
 	btrfs)
-		$UMOUNT_PROG $SCRATCH_MNT
+		_umount $SCRATCH_MNT
 		;;
 	tmpfs)
 		$UMOUNT_PROG $SCRATCH_MNT
 		;;
 	*)
-		$UMOUNT_PROG $SCRATCH_DEV
+		_umount $SCRATCH_DEV
 		;;
 	esac
 }
 
 _scratch_umount_idmapped()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 _scratch_remount()
@@ -457,7 +462,7 @@ _scratch_cycle_mount()
         ;;
     overlay)
         if [ "$OVL_BASE_FSTYP" = tmpfs ]; then
-            $UMOUNT_PROG $SCRATCH_MNT
+            _umount $SCRATCH_MNT
             unmounted=true
         fi
         ;;
@@ -505,9 +510,9 @@ _move_mount()
 
 	# Replace $mnt with $tmp. Use a temporary bind-mount because
 	# mount --move will fail with certain mount propagation layouts.
-	$UMOUNT_PROG $mnt || _fail "Failed to unmount $mnt"
+	_umount $mnt || _fail "Failed to unmount $mnt"
 	_mount --bind $tmp $mnt || _fail "Failed to bind-mount $tmp to $mnt"
-	$UMOUNT_PROG $tmp || _fail "Failed to unmount $tmp"
+	_umount $tmp || _fail "Failed to unmount $tmp"
 	rmdir $tmp
 }
 
@@ -573,7 +578,7 @@ _test_unmount()
 	if [ "$FSTYP" == "overlay" ]; then
 		_overlay_test_unmount
 	else
-		$UMOUNT_PROG $TEST_DEV
+		_umount $TEST_DEV
 	fi
 }
 
@@ -587,7 +592,7 @@ _test_cycle_mount()
         ;;
     overlay)
         if [ "$OVL_BASE_FSTYP" = tmpfs ]; then
-            $UMOUNT_PROG $TEST_DIR
+            _umount $TEST_DIR
             unmounted=true
         fi
         ;;
@@ -1375,7 +1380,7 @@ _repair_scratch_fs()
 		# Fall through to repair base fs
 		dev=$OVL_BASE_SCRATCH_DEV
 		fstyp=$OVL_BASE_FSTYP
-		$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT
+		_umount $OVL_BASE_SCRATCH_MNT
 	fi
 	# Let's hope fsck -y suffices...
 	fsck -t $fstyp -y $dev 2>&1
@@ -2189,7 +2194,7 @@ _require_logdev()
         _notrun "This test requires USE_EXTERNAL to be enabled"
 
     # ensure its not mounted
-    $UMOUNT_PROG $SCRATCH_LOGDEV 2>/dev/null
+    _umount $SCRATCH_LOGDEV 2>/dev/null
 }
 
 # This test requires that an external log device is not in use
@@ -3281,7 +3286,7 @@ _umount_or_remount_ro()
     local mountpoint=`_is_dev_mounted $device`
 
     if [ $USE_REMOUNT -eq 0 ]; then
-        $UMOUNT_PROG $device
+        _umount $device
     else
         _remount $device ro
     fi
@@ -3799,7 +3804,7 @@ _require_scratch_dev_pool()
 			_notrun "$i is part of TEST_DEV, this test requires unique disks"
 		fi
 		if _mount | grep -q $i; then
-			if ! $UMOUNT_PROG $i; then
+			if ! _umount $i; then
 		            echo "failed to unmount $i - aborting"
 		            exit 1
 		        fi
diff --git a/tests/btrfs/020 b/tests/btrfs/020
index 7e5c6fd7b25229..f6fadab1f00bdb 100755
--- a/tests/btrfs/020
+++ b/tests/btrfs/020
@@ -17,7 +17,7 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	$UMOUNT_PROG $loop_mnt
+	_umount $loop_mnt
 	_destroy_loop_device $loop_dev1
 	losetup -d $loop_dev2 >/dev/null 2>&1
 	_destroy_loop_device $loop_dev3
diff --git a/tests/btrfs/029 b/tests/btrfs/029
index c37ad63fb613db..9799b275250e5a 100755
--- a/tests/btrfs/029
+++ b/tests/btrfs/029
@@ -74,7 +74,7 @@ cp --reflink=always $orig_file $copy_file >> $seqres.full 2>&1 || echo "cp refli
 md5sum $orig_file | _filter_testdir_and_scratch
 md5sum $copy_file | _filter_testdir_and_scratch
 
-$UMOUNT_PROG $reflink_test_dir
+_umount $reflink_test_dir
 
 # success, all done
 status=0
diff --git a/tests/btrfs/031 b/tests/btrfs/031
index 8ac73d3a86e70b..92c1d26f865ba9 100755
--- a/tests/btrfs/031
+++ b/tests/btrfs/031
@@ -99,7 +99,7 @@ mv $testdir2/file* $subvol2/
 echo "Verify the file contents:"
 _checksum_files
 
-$UMOUNT_PROG $cross_mount_test_dir
+_umount $cross_mount_test_dir
 
 # success, all done
 status=0
diff --git a/tests/btrfs/060 b/tests/btrfs/060
index 75c10bd23c36f5..0bf88f86ca822b 100755
--- a/tests/btrfs/060
+++ b/tests/btrfs/060
@@ -82,7 +82,7 @@ run_test()
 	fi
 
 	# in case the subvolume is still mounted
-	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_umount $subvol_mnt >/dev/null 2>&1
 	_scratch_unmount
 	# we called _require_scratch_nocheck instead of _require_scratch
 	# do check after test for each profile config
diff --git a/tests/btrfs/065 b/tests/btrfs/065
index b87c66d6e3d45e..9cd38fefe46875 100755
--- a/tests/btrfs/065
+++ b/tests/btrfs/065
@@ -90,7 +90,7 @@ run_test()
 	fi
 
 	# in case the subvolume is still mounted
-	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_umount $subvol_mnt >/dev/null 2>&1
 	_scratch_unmount
 	# we called _require_scratch_nocheck instead of _require_scratch
 	# do check after test for each profile config
diff --git a/tests/btrfs/066 b/tests/btrfs/066
index cc7cd9b7273d1c..b3db57049714ad 100755
--- a/tests/btrfs/066
+++ b/tests/btrfs/066
@@ -82,7 +82,7 @@ run_test()
 	fi
 
 	# in case the subvolume is still mounted
-	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_umount $subvol_mnt >/dev/null 2>&1
 	_scratch_unmount
 	# we called _require_scratch_nocheck instead of _require_scratch
 	# do check after test for each profile config
diff --git a/tests/btrfs/067 b/tests/btrfs/067
index 0b473050027a0a..ede9abbc689fe0 100755
--- a/tests/btrfs/067
+++ b/tests/btrfs/067
@@ -83,7 +83,7 @@ run_test()
 	fi
 
 	# in case the subvolume is still mounted
-	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_umount $subvol_mnt >/dev/null 2>&1
 	_scratch_unmount
 	# we called _require_scratch_nocheck instead of _require_scratch
 	# do check after test for each profile config
diff --git a/tests/btrfs/068 b/tests/btrfs/068
index 83e932e8417c0d..82dac5fd90ba85 100755
--- a/tests/btrfs/068
+++ b/tests/btrfs/068
@@ -83,7 +83,7 @@ run_test()
 	fi
 
 	# in case the subvolume is still mounted
-	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_umount $subvol_mnt >/dev/null 2>&1
 	_scratch_unmount
 	# we called _require_scratch_nocheck instead of _require_scratch
 	# do check after test for each profile config
diff --git a/tests/btrfs/075 b/tests/btrfs/075
index 737c4ffdd57865..8e78bd3d4b2336 100755
--- a/tests/btrfs/075
+++ b/tests/btrfs/075
@@ -15,7 +15,7 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_umount $subvol_mnt >/dev/null 2>&1
 }
 
 . ./common/filter
diff --git a/tests/btrfs/089 b/tests/btrfs/089
index 8f8e37b6fde87b..ade38a6d189eaa 100755
--- a/tests/btrfs/089
+++ b/tests/btrfs/089
@@ -35,7 +35,7 @@ mount --bind "$SCRATCH_MNT/testvol/testdir" "$SCRATCH_MNT/testvol/mnt"
 $BTRFS_UTIL_PROG subvolume delete "$SCRATCH_MNT/testvol" >>$seqres.full 2>&1
 
 # Unmount the bind mount, which should still be alive.
-$UMOUNT_PROG "$SCRATCH_MNT/testvol/mnt"
+_umount "$SCRATCH_MNT/testvol/mnt"
 
 echo "Silence is golden"
 status=0
diff --git a/tests/btrfs/124 b/tests/btrfs/124
index af079c2864de8e..19f8bbfc6b922e 100755
--- a/tests/btrfs/124
+++ b/tests/btrfs/124
@@ -132,7 +132,7 @@ if [ "$checkpoint1" != "$checkpoint3" ]; then
 	echo "Inital sum does not match with data on dev2 written by balance"
 fi
 
-$UMOUNT_PROG $dev2
+_umount $dev2
 _scratch_dev_pool_put
 _btrfs_rescan_devices
 _test_mount
diff --git a/tests/btrfs/125 b/tests/btrfs/125
index c8c0dd422f72b6..7acef2d38cda46 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -144,7 +144,7 @@ if [ "$checkpoint1" != "$checkpoint3" ]; then
 	echo "Inital sum does not match with data on dev2 written by balance"
 fi
 
-$UMOUNT_PROG $dev2
+_umount $dev2
 _scratch_dev_pool_put
 _btrfs_rescan_devices
 _test_mount
diff --git a/tests/btrfs/185 b/tests/btrfs/185
index 8d0643450f5d7d..c3b52fc2dbff66 100755
--- a/tests/btrfs/185
+++ b/tests/btrfs/185
@@ -15,7 +15,7 @@ mnt=$TEST_DIR/$seq.mnt
 # Override the default cleanup function.
 _cleanup()
 {
-	$UMOUNT_PROG $mnt > /dev/null 2>&1
+	_umount $mnt > /dev/null 2>&1
 	rm -rf $mnt > /dev/null 2>&1
 	cd /
 	rm -f $tmp.*
@@ -62,7 +62,7 @@ $BTRFS_UTIL_PROG device scan $device_1 >> $seqres.full 2>&1
 	_fail "if it fails here, then it means subvolume mount at boot may fail "\
 	      "in some configs."
 
-$UMOUNT_PROG $mnt > /dev/null 2>&1
+_umount $mnt > /dev/null 2>&1
 _scratch_dev_pool_put
 
 # success, all done
diff --git a/tests/btrfs/197 b/tests/btrfs/197
index 9f1d879a4e267a..913dbb2d3a50ef 100755
--- a/tests/btrfs/197
+++ b/tests/btrfs/197
@@ -15,7 +15,7 @@ _begin_fstest auto quick volume
 # Override the default cleanup function.
 _cleanup()
 {
-	$UMOUNT_PROG $TEST_DIR/$seq.mnt >/dev/null 2>&1
+	_umount $TEST_DIR/$seq.mnt >/dev/null 2>&1
 	rm -rf $TEST_DIR/$seq.mnt
 	cd /
 	rm -f $tmp.*
@@ -67,7 +67,7 @@ workout()
 	grep -q "${SCRATCH_DEV_NAME[1]}" $tmp.output && _fail "found stale device"
 
 	$BTRFS_UTIL_PROG device remove "${SCRATCH_DEV_NAME[1]}" "$TEST_DIR/$seq.mnt"
-	$UMOUNT_PROG $TEST_DIR/$seq.mnt
+	_umount $TEST_DIR/$seq.mnt
 	_scratch_unmount
 	_spare_dev_put
 	_scratch_dev_pool_put
diff --git a/tests/btrfs/219 b/tests/btrfs/219
index 052f61a399ae66..efe5096746652a 100755
--- a/tests/btrfs/219
+++ b/tests/btrfs/219
@@ -21,8 +21,8 @@ _cleanup()
 	rm -f $tmp.*
 
 	# The variables are set before the test case can fail.
-	$UMOUNT_PROG ${loop_mnt1} &> /dev/null
-	$UMOUNT_PROG ${loop_mnt2} &> /dev/null
+	_umount ${loop_mnt1} &> /dev/null
+	_umount ${loop_mnt2} &> /dev/null
 	rm -rf $loop_mnt1
 	rm -rf $loop_mnt2
 
@@ -66,7 +66,7 @@ loop_dev2=`_create_loop_device $fs_img2`
 # Normal single device case, should pass just fine
 _mount $loop_dev1 $loop_mnt1 > /dev/null  2>&1 || \
 	_fail "Couldn't do initial mount"
-$UMOUNT_PROG $loop_mnt1
+_umount $loop_mnt1
 
 _btrfs_forget_or_module_reload
 
@@ -75,15 +75,15 @@ _btrfs_forget_or_module_reload
 # measure.
 _mount $loop_dev1 $loop_mnt1 > /dev/null 2>&1 || \
 	_fail "Failed to mount the second time"
-$UMOUNT_PROG $loop_mnt1
+_umount $loop_mnt1
 
 _mount $loop_dev2 $loop_mnt2 > /dev/null 2>&1 || \
 	_fail "We couldn't mount the old generation"
-$UMOUNT_PROG $loop_mnt2
+_umount $loop_mnt2
 
 _mount $loop_dev1 $loop_mnt1 > /dev/null 2>&1 || \
 	_fail "Failed to mount the second time"
-$UMOUNT_PROG $loop_mnt1
+_umount $loop_mnt1
 
 # Now try mount them at the same time, if kernel does not support
 # temp-fsid feature then mount will fail.
diff --git a/tests/btrfs/254 b/tests/btrfs/254
index d9c9eea9c7bf23..eda32be1c2b1d1 100755
--- a/tests/btrfs/254
+++ b/tests/btrfs/254
@@ -96,7 +96,7 @@ test_add_device()
 	$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | \
 					_filter_btrfs_filesystem_show
 
-	$UMOUNT_PROG $seq_mnt
+	_umount $seq_mnt
 	_scratch_unmount
 	cleanup_dmdev
 }
diff --git a/tests/ext4/032 b/tests/ext4/032
index 9a1b9312cc42cc..6e98f4f4ebb8de 100755
--- a/tests/ext4/032
+++ b/tests/ext4/032
@@ -63,7 +63,7 @@ ext4_online_resize()
 	fi
 	cat $tmp.resize2fs >> $seqres.full
 	echo "+++ umount fs" | tee -a $seqres.full
-	$UMOUNT_PROG ${IMG_MNT}
+	_umount ${IMG_MNT}
 
 	echo "+++ check fs" | tee -a $seqres.full
 	_check_generic_filesystem $LOOP_DEVICE >> $seqres.full 2>&1 || \
@@ -77,7 +77,7 @@ _cleanup()
 	cd /
 	[ -n "$LOOP_DEVICE" ] && _destroy_loop_device $LOOP_DEVICE > /dev/null 2>&1
 	rm -f $tmp.*
-	$UMOUNT_PROG ${IMG_MNT} > /dev/null 2>&1
+	_umount ${IMG_MNT} > /dev/null 2>&1
 	rm -f ${IMG_FILE} > /dev/null 2>&1
 }
 
diff --git a/tests/ext4/052 b/tests/ext4/052
index edcdc02515f725..ce3f90eb7e6d02 100755
--- a/tests/ext4/052
+++ b/tests/ext4/052
@@ -18,7 +18,7 @@ _cleanup()
 	cd /
 	rm -r -f $tmp.*
 	if [ ! -z "$loop_mnt" ]; then
-		$UMOUNT_PROG $loop_mnt
+		_umount $loop_mnt
 		rm -rf $loop_mnt
 	fi
 	[ ! -z "$fs_img" ] && rm -rf $fs_img
@@ -63,7 +63,7 @@ then
     status=1
 fi
 
-$UMOUNT_PROG $loop_mnt || _fail "umount failed"
+_umount $loop_mnt || _fail "umount failed"
 loop_mnt=
 
 $E2FSCK_PROG -fn $fs_img >> $seqres.full 2>&1 || _fail "file system corrupted"
diff --git a/tests/ext4/053 b/tests/ext4/053
index 4f20d217d5fd7a..0beb2201260162 100755
--- a/tests/ext4/053
+++ b/tests/ext4/053
@@ -20,7 +20,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	if [ -n "$LOOP_LOGDEV" ];then
 		_destroy_loop_device $LOOP_LOGDEV 2>/dev/null
 	fi
@@ -237,7 +237,7 @@ not_mnt() {
 	if simple_mount -o $1 $SCRATCH_DEV $SCRATCH_MNT; then
 		print_log "(mount unexpectedly succeeded)"
 		fail
-		$UMOUNT_PROG $SCRATCH_MNT
+		_umount $SCRATCH_MNT
 		return
 	fi
 	ok
@@ -248,7 +248,7 @@ not_mnt() {
 		return
 	fi
 	not_remount $1
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 mnt_only() {
@@ -270,7 +270,7 @@ mnt() {
 	fi
 
 	mnt_only $*
-	$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
+	_umount $SCRATCH_MNT 2> /dev/null
 
 	[ "$t2fs" -eq 0 ] && return
 
@@ -289,7 +289,7 @@ mnt() {
 				    -e 's/data=writeback/journal_data_writeback/')
 	$TUNE2FS_PROG -o $op_set $SCRATCH_DEV > /dev/null 2>&1
 	mnt_only "defaults" $check
-	$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
+	_umount $SCRATCH_MNT 2> /dev/null
 	if [ "$op_set" = ^* ]; then
 		op_set=${op_set#^}
 	else
@@ -309,12 +309,12 @@ remount() {
 	do_mnt remount,$2 $3
 	if [ $? -ne 0 ]; then
 		fail
-		$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
+		_umount $SCRATCH_MNT 2> /dev/null
 		return
 	else
 		ok
 	fi
-	$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
+	_umount $SCRATCH_MNT 2> /dev/null
 
 	# Now just specify mnt
 	print_log "mounting $fstype \"$1\" "
@@ -328,7 +328,7 @@ remount() {
 		ok
 	fi
 
-	$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
+	_umount $SCRATCH_MNT 2> /dev/null
 }
 
 # Test that the filesystem cannot be remounted with option(s) $1 (meaning that
@@ -364,7 +364,7 @@ mnt_then_not_remount() {
 		return
 	fi
 	not_remount $2
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 
@@ -400,8 +400,8 @@ LOGDEV_DEVNUM=`echo "${majmin%:*}*2^8 + ${majmin#*:}" | bc`
 fstype=
 for fstype in ext2 ext3 ext4; do
 
-	$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
-	$UMOUNT_PROG $SCRATCH_DEV 2> /dev/null
+	_umount $SCRATCH_MNT 2> /dev/null
+	_umount $SCRATCH_DEV 2> /dev/null
 
 	do_mkfs $SCRATCH_DEV ${SIZE}k
 
@@ -418,7 +418,7 @@ for fstype in ext2 ext3 ext4; do
 		continue
 	fi
 
-	$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
+	_umount $SCRATCH_MNT 2> /dev/null
 
 	not_mnt failme
 	mnt
@@ -552,7 +552,7 @@ for fstype in ext2 ext3 ext4; do
 	# dax mount options
 	simple_mount -o dax=always $SCRATCH_DEV $SCRATCH_MNT > /dev/null 2>&1
 	if [ $? -eq 0 ]; then
-		$UMOUNT_PROG $SCRATCH_MNT 2> /dev/null
+		_umount $SCRATCH_MNT 2> /dev/null
 		mnt dax
 		mnt dax=always
 		mnt dax=never
@@ -633,7 +633,7 @@ for fstype in ext2 ext3 ext4; do
 	not_remount jqfmt=vfsv1
 	not_remount noquota
 	mnt_only remount,usrquota,grpquota ^usrquota,^grpquota
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 
 	# test clearing/changing quota when enabled
 	do_mkfs -E quotatype=^prjquota $SCRATCH_DEV ${SIZE}k
@@ -654,7 +654,7 @@ for fstype in ext2 ext3 ext4; do
 	mnt_only remount,usrquota,grpquota usrquota,grpquota
 	quotaoff -f $SCRATCH_MNT >> $seqres.full 2>&1
 	mnt_only remount,noquota ^usrquota,^grpquota,quota
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 
 	# Quota feature
 	echo "== Testing quota feature " >> $seqres.full
@@ -696,7 +696,7 @@ for fstype in ext2 ext3 ext4; do
 
 done #for fstype in ext2 ext3 ext4; do
 
-$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+_umount $SCRATCH_MNT > /dev/null 2>&1
 echo "$ERR errors encountered" >> $seqres.full
 
 status=$ERR
diff --git a/tests/ext4/056 b/tests/ext4/056
index 8a290b11d69772..f9cb690fdfc80b 100755
--- a/tests/ext4/056
+++ b/tests/ext4/056
@@ -70,7 +70,7 @@ do_resize()
 	# delay
 	sleep 0.2
 	_scratch_unmount >> $seqres.full 2>&1 \
-		|| _fail "$UMOUNT_PROG failed. Exiting"
+		|| _fail "_umount failed. Exiting"
 }
 
 run_test()
diff --git a/tests/generic/042 b/tests/generic/042
index fd0ef705a18c3e..bea23ce29ac327 100755
--- a/tests/generic/042
+++ b/tests/generic/042
@@ -44,7 +44,7 @@ _crashtest()
 		_filter_xfs_io
 	$here/src/godown -f $mnt
 
-	$UMOUNT_PROG $mnt
+	_umount $mnt
 	_mount $img $mnt
 
 	# We should /never/ see 0xCD in the file, because we wrote that pattern
@@ -54,7 +54,7 @@ _crashtest()
 		_hexdump $file
 	fi
 
-	$UMOUNT_PROG $mnt
+	_umount $mnt
 }
 
 # Modify as appropriate.
diff --git a/tests/generic/067 b/tests/generic/067
index b6e984f5231753..19ee28d2cd945e 100755
--- a/tests/generic/067
+++ b/tests/generic/067
@@ -66,7 +66,7 @@ umount_symlink_device()
 	rm -f $symlink
 	echo "# umount symlink to device, which is not mounted" >>$seqres.full
 	ln -s $SCRATCH_DEV $symlink
-	$UMOUNT_PROG $symlink >>$seqres.full 2>&1
+	_umount $symlink >>$seqres.full 2>&1
 }
 
 # umount a path name that is 256 bytes long, this should fail gracefully,
@@ -78,7 +78,7 @@ umount_toolong_name()
 	_scratch_mount 2>&1 | tee -a $seqres.full
 
 	echo "# umount a too-long name" >>$seqres.full
-	$UMOUNT_PROG $longname >>$seqres.full 2>&1
+	_umount $longname >>$seqres.full 2>&1
 	_scratch_unmount 2>&1 | tee -a $seqres.full
 }
 
@@ -93,7 +93,7 @@ lazy_umount_symlink()
 	rm -f $symlink
 	ln -s $SCRATCH_MNT/testdir $symlink
 
-	$UMOUNT_PROG -l $symlink >>$seqres.full 2>&1
+	_umount -l $symlink >>$seqres.full 2>&1
 	# _scratch_unmount should not be blocked
 	_scratch_unmount 2>&1 | tee -a $seqres.full
 }
diff --git a/tests/generic/081 b/tests/generic/081
index 468c87ac9a9f0a..57dc07a36395f8 100755
--- a/tests/generic/081
+++ b/tests/generic/081
@@ -32,7 +32,7 @@ _cleanup()
 	# other tests to fail.
 	while test -e /dev/mapper/$vgname-$snapname || \
 	      test -e /dev/mapper/$vgname-$lvname; do
-		$UMOUNT_PROG $mnt >> $seqres.full 2>&1
+		_umount $mnt >> $seqres.full 2>&1
 		$LVM_PROG lvremove -f $vgname/$snapname >>$seqres.full 2>&1
 		$LVM_PROG lvremove -f $vgname/$lvname >>$seqres.full 2>&1
 		$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
diff --git a/tests/generic/085 b/tests/generic/085
index cbabd257cad8f0..8c33386b7c383e 100755
--- a/tests/generic/085
+++ b/tests/generic/085
@@ -27,7 +27,7 @@ cleanup_dmdev()
 	$DMSETUP_PROG resume $lvdev >/dev/null 2>&1
 	[ -n "$pid" ] && kill -9 $pid 2>/dev/null
 	wait $pid
-	$UMOUNT_PROG $lvdev >/dev/null 2>&1
+	_umount $lvdev >/dev/null 2>&1
 	_dmsetup_remove $node
 }
 
@@ -70,7 +70,7 @@ done &
 pid=$!
 for ((i=0; i<100; i++)); do
 	_mount $lvdev $SCRATCH_MNT >/dev/null 2>&1
-	$UMOUNT_PROG $lvdev >/dev/null 2>&1
+	_umount $lvdev >/dev/null 2>&1
 done &
 pid="$pid $!"
 
diff --git a/tests/generic/108 b/tests/generic/108
index da13715f27ac21..e1df7ee1886cde 100755
--- a/tests/generic/108
+++ b/tests/generic/108
@@ -18,7 +18,7 @@ _cleanup()
 {
 	cd /
 	echo running > /sys/block/`_short_dev $SCSI_DEBUG_DEV`/device/state
-	$UMOUNT_PROG $SCRATCH_MNT >>$seqres.full 2>&1
+	_umount $SCRATCH_MNT >>$seqres.full 2>&1
 	$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
 	$LVM_PROG pvremove -f $SCRATCH_DEV $SCSI_DEBUG_DEV >>$seqres.full 2>&1
 	$UDEV_SETTLE_PROG
diff --git a/tests/generic/361 b/tests/generic/361
index c2ebda3c1a01ad..456271b8d80308 100755
--- a/tests/generic/361
+++ b/tests/generic/361
@@ -16,7 +16,7 @@ _begin_fstest auto quick
 # Override the default cleanup function.
 _cleanup()
 {
-	$UMOUNT_PROG $fs_mnt
+	_umount $fs_mnt
 	_destroy_loop_device $loop_dev
 	cd /
 	rm -f $tmp.*
diff --git a/tests/generic/373 b/tests/generic/373
index 0d5a50cbee40b8..6ede189ead70bd 100755
--- a/tests/generic/373
+++ b/tests/generic/373
@@ -60,7 +60,7 @@ md5sum $testdir/file | _filter_scratch
 md5sum $othertestdir/otherfile | filter_otherdir
 
 echo "Unmount otherdir"
-$UMOUNT_PROG $otherdir
+_umount $otherdir
 rm -rf $otherdir
 
 # success, all done
diff --git a/tests/generic/374 b/tests/generic/374
index 977a2b268bbc98..bbdd8e66b4897b 100755
--- a/tests/generic/374
+++ b/tests/generic/374
@@ -59,7 +59,7 @@ echo "Check output"
 md5sum $testdir/file $othertestdir/otherfile | filter_md5
 
 echo "Unmount otherdir"
-$UMOUNT_PROG $otherdir
+_umount $otherdir
 rm -rf $otherdir
 
 # success, all done
diff --git a/tests/generic/459 b/tests/generic/459
index 32ee899f929819..e8799f75bf8e05 100755
--- a/tests/generic/459
+++ b/tests/generic/459
@@ -28,7 +28,7 @@ _cleanup()
 	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
 	cd /
 	rm -f $tmp.*
-	$UMOUNT_PROG $SCRATCH_MNT >>$seqres.full 2>&1
+	_umount $SCRATCH_MNT >>$seqres.full 2>&1
 	$LVM_PROG vgremove -ff $vgname >>$seqres.full 2>&1
 	$LVM_PROG pvremove -ff $SCRATCH_DEV >>$seqres.full 2>&1
 	$UDEV_SETTLE_PROG
diff --git a/tests/generic/604 b/tests/generic/604
index c2e03c2eabb871..124eea853ecf70 100755
--- a/tests/generic/604
+++ b/tests/generic/604
@@ -26,6 +26,8 @@ done
 # mount the base fs.  Delay the mount attempt by a small amount in the hope
 # that the mount() call will try to lock s_umount /after/ umount has already
 # taken it.
+# This is the /one/ place in fstests where we need to call the umount binary
+# directly.
 $UMOUNT_PROG $SCRATCH_MNT &
 sleep 0.01s ; _scratch_mount
 wait
diff --git a/tests/generic/648 b/tests/generic/648
index 29d1b470bded4a..3e995a02983931 100755
--- a/tests/generic/648
+++ b/tests/generic/648
@@ -20,7 +20,7 @@ _cleanup()
 	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
 	wait
 	if [ -n "$loopmnt" ]; then
-		$UMOUNT_PROG $loopmnt 2>/dev/null
+		_umount $loopmnt 2>/dev/null
 		rm -r -f $loopmnt
 	fi
 	rm -f $tmp.*
@@ -111,7 +111,7 @@ while _soak_loop_running $((25 * TIME_FACTOR)); do
 
 	# Mount again to replay log after loading working table, so we have a
 	# consistent fs after test.
-	$UMOUNT_PROG $loopmnt
+	_umount $loopmnt
 	is_unmounted=1
 	# We must unmount dmerror at here, or whole later testing will crash.
 	# So try to umount enough times, before we have no choice.
@@ -137,7 +137,7 @@ done
 # Make sure the fs image file is ok
 if [ -f "$loopimg" ]; then
 	if _mount $loopimg $loopmnt -o loop; then
-		$UMOUNT_PROG $loopmnt &> /dev/null
+		_umount $loopmnt &> /dev/null
 	else
 		_metadump_dev $DMERROR_DEV $seqres.scratch.final.md
 		echo "final scratch mount failed"
diff --git a/tests/generic/698 b/tests/generic/698
index 28928b2fb32532..f432837a216f82 100755
--- a/tests/generic/698
+++ b/tests/generic/698
@@ -17,8 +17,8 @@ _begin_fstest auto quick perms attr idmapped mount
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $SCRATCH_MNT/target-mnt 2>/dev/null
-	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+	_umount $SCRATCH_MNT/target-mnt 2>/dev/null
+	_umount $SCRATCH_MNT 2>/dev/null
 	rm -r -f $tmp.*
 }
 
diff --git a/tests/generic/699 b/tests/generic/699
index 677307538a484b..5cff1cbaa67c4e 100755
--- a/tests/generic/699
+++ b/tests/generic/699
@@ -15,9 +15,9 @@ _begin_fstest auto quick perms attr idmapped mount
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $SCRATCH_MNT/target-mnt
-	$UMOUNT_PROG $SCRATCH_MNT/ovl-merge 2>/dev/null
-	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+	_umount $SCRATCH_MNT/target-mnt
+	_umount $SCRATCH_MNT/ovl-merge 2>/dev/null
+	_umount $SCRATCH_MNT 2>/dev/null
 	rm -r -f $tmp.*
 }
 
@@ -113,7 +113,7 @@ setup_overlayfs_idmapped_lower_metacopy_on()
 
 reset_overlayfs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT/ovl-merge 2>/dev/null
+	_umount $SCRATCH_MNT/ovl-merge 2>/dev/null
 	rm -rf $upper $work $merge
 }
 
diff --git a/tests/generic/704 b/tests/generic/704
index f39d47066ccc4a..31d52a97b37f9d 100755
--- a/tests/generic/704
+++ b/tests/generic/704
@@ -14,7 +14,7 @@ _cleanup()
 {
 	cd /
 	rm -r -f $tmp.*
-	[ -d "$SCSI_DEBUG_MNT" ] && $UMOUNT_PROG $SCSI_DEBUG_MNT 2>/dev/null
+	[ -d "$SCSI_DEBUG_MNT" ] && _umount $SCSI_DEBUG_MNT 2>/dev/null
 	_put_scsi_debug_dev
 }
 
diff --git a/tests/generic/730 b/tests/generic/730
index 062314ea01e7b5..650c604d5fbefd 100755
--- a/tests/generic/730
+++ b/tests/generic/730
@@ -12,7 +12,7 @@ _begin_fstest auto quick
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $SCSI_DEBUG_MNT >>$seqres.full 2>&1
+	_umount $SCSI_DEBUG_MNT >>$seqres.full 2>&1
 	_put_scsi_debug_dev
 	rm -f $tmp.*
 }
diff --git a/tests/generic/731 b/tests/generic/731
index cd39e8b09e3906..2621f6e237741d 100755
--- a/tests/generic/731
+++ b/tests/generic/731
@@ -13,7 +13,7 @@ _begin_fstest auto quick
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $SCSI_DEBUG_MNT >>$seqres.full 2>&1
+	_umount $SCSI_DEBUG_MNT >>$seqres.full 2>&1
 	_put_scsi_debug_dev
 	rm -f $tmp.*
 }
diff --git a/tests/generic/732 b/tests/generic/732
index d08028c2333d1b..63406ddc163f2c 100755
--- a/tests/generic/732
+++ b/tests/generic/732
@@ -15,8 +15,8 @@ _begin_fstest auto quick rename
 # Override the default cleanup function.
 _cleanup()
 {
-	$UMOUNT_PROG $testdir1 2>/dev/null
-	$UMOUNT_PROG $testdir2 2>/dev/null
+	_umount $testdir1 2>/dev/null
+	_umount $testdir2 2>/dev/null
 	cd /
 	rm -r -f $tmp.*
 }
diff --git a/tests/generic/746 b/tests/generic/746
index 651affe07b40bc..2b40c964371175 100755
--- a/tests/generic/746
+++ b/tests/generic/746
@@ -38,7 +38,7 @@ esac
 # Override the default cleanup function.
 _cleanup()
 {
-	$UMOUNT_PROG $loop_dev &> /dev/null
+	_umount $loop_dev &> /dev/null
 	_destroy_loop_device $loop_dev
 	if [ $status -eq 0 ]; then
 		rm -rf $tmp
@@ -53,7 +53,7 @@ get_holes()
 	# in-core state that will perturb the free space map on umount.  Stick
 	# to established convention which requires the filesystem to be
 	# unmounted while we probe the underlying file.
-	$UMOUNT_PROG $loop_mnt
+	_umount $loop_mnt
 
 	# FIEMAP only works on regular files, so call it on the backing file
 	# and not the loop device like everything else
@@ -66,7 +66,7 @@ get_free_sectors()
 {
 	case $FSTYP in
 	ext4)
-	$UMOUNT_PROG $loop_mnt
+	_umount $loop_mnt
 	$DUMPE2FS_PROG $loop_dev  2>&1 | grep " Free blocks" | cut -d ":" -f2- | \
 		tr ',' '\n' | $SED_PROG 's/^ //' | \
 		$AWK_PROG -v spb=$sectors_per_block 'BEGIN{FS="-"};
@@ -80,7 +80,7 @@ get_free_sectors()
 	xfs)
 	agsize=`$XFS_INFO_PROG $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
 	# Convert free space (agno, block, length) to (start sector, end sector)
-	$UMOUNT_PROG $loop_mnt
+	_umount $loop_mnt
 	$XFS_DB_PROG -r -c "freesp -d" $loop_dev | $SED_PROG '/^.*from/,$d'| \
 		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
 		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
diff --git a/tests/overlay/003 b/tests/overlay/003
index 41ad99e794d8ee..0a2cb928ea5c58 100755
--- a/tests/overlay/003
+++ b/tests/overlay/003
@@ -56,7 +56,7 @@ rm -rf ${SCRATCH_MNT}/*
 ls ${SCRATCH_MNT}/
 
 # unmount overlayfs but not base fs
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 echo "Silence is golden"
 # success, all done
diff --git a/tests/overlay/004 b/tests/overlay/004
index bea4bb543f3611..4591d4e8487ce2 100755
--- a/tests/overlay/004
+++ b/tests/overlay/004
@@ -53,7 +53,7 @@ _user_do "chmod u-X ${SCRATCH_MNT}/attr_file2 > /dev/null 2>&1"
 stat -c %a ${SCRATCH_MNT}/attr_file2
 
 # unmount overlayfs but not base fs
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # check mode bits of the file that has been copied up, and
 # the file that should not have been copied up.
diff --git a/tests/overlay/005 b/tests/overlay/005
index 01914ee17b9a30..6b382ddb50d873 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -75,14 +75,14 @@ $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
 	>>$seqres.full 2>&1
 
 # unmount overlayfs
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # check overlayfs
 _overlay_check_scratch_dirs $lowerd $upperd $workd
 
 # unmount undelying xfs, this tiggers panic if memleak happens
-$UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/uppermnt
-$UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/lowermnt
+_umount ${OVL_BASE_SCRATCH_MNT}/uppermnt
+_umount ${OVL_BASE_SCRATCH_MNT}/lowermnt
 
 # success, all done
 echo "Silence is golden"
diff --git a/tests/overlay/014 b/tests/overlay/014
index f07fc685572b92..08850d489e4b49 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -46,7 +46,7 @@ _overlay_scratch_mount_dirs $lowerdir1 $lowerdir2 $workdir2
 rm -rf $SCRATCH_MNT/testdir
 mkdir -p $SCRATCH_MNT/testdir/visibledir
 # unmount overlayfs but not base fs
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # check overlayfs
 _overlay_check_scratch_dirs $lowerdir1 $lowerdir2 $workdir2
@@ -59,7 +59,7 @@ touch $SCRATCH_MNT/testdir/visiblefile
 
 # umount and mount overlay again, buggy kernel treats the copied-up dir as
 # opaque, visibledir is not seen in merged dir.
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 ls $SCRATCH_MNT/testdir
 
diff --git a/tests/overlay/022 b/tests/overlay/022
index d33bd29781a356..40b0dd64f6fc6c 100755
--- a/tests/overlay/022
+++ b/tests/overlay/022
@@ -17,7 +17,7 @@ _begin_fstest auto quick mount nested
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $tmp/mnt > /dev/null 2>&1
+	_umount $tmp/mnt > /dev/null 2>&1
 	rm -rf $tmp
 	rm -f $tmp.*
 }
diff --git a/tests/overlay/025 b/tests/overlay/025
index 6ba46191b557be..0abc8bf80b1716 100755
--- a/tests/overlay/025
+++ b/tests/overlay/025
@@ -19,8 +19,8 @@ _begin_fstest auto quick attr
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $tmpfsdir/mnt
-	$UMOUNT_PROG $tmpfsdir
+	_umount $tmpfsdir/mnt
+	_umount $tmpfsdir
 	rm -rf $tmpfsdir
 	rm -f $tmp.*
 }
diff --git a/tests/overlay/029 b/tests/overlay/029
index 4bade9a0e129a4..007973dc075923 100755
--- a/tests/overlay/029
+++ b/tests/overlay/029
@@ -22,7 +22,7 @@ _begin_fstest auto quick nested
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $tmp/mnt
+	_umount $tmp/mnt
 	rm -rf $tmp
 	rm -f $tmp.*
 }
@@ -56,7 +56,7 @@ _overlay_mount_dirs $SCRATCH_MNT/up $tmp/{upper,work} \
   overlay $tmp/mnt
 # accessing file in the second mount
 cat $tmp/mnt/foo
-$UMOUNT_PROG $tmp/mnt
+_umount $tmp/mnt
 
 # re-create upper/work to avoid ovl_verify_origin() mount failure
 # when index is enabled
@@ -66,7 +66,7 @@ mkdir -p $tmp/{upper,work}
 _overlay_mount_dirs $SCRATCH_MNT/low $tmp/{upper,work} \
   overlay $tmp/mnt
 cat $tmp/mnt/bar
-$UMOUNT_PROG $tmp/mnt
+_umount $tmp/mnt
 
 rm -rf $tmp/{upper,work}
 mkdir -p $tmp/{upper,work}
diff --git a/tests/overlay/031 b/tests/overlay/031
index dd9dfcdb970ac7..31d22d1cadae41 100755
--- a/tests/overlay/031
+++ b/tests/overlay/031
@@ -28,7 +28,7 @@ create_whiteout()
 
 	rm -f $SCRATCH_MNT/testdir/$file
 
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Import common functions.
@@ -68,7 +68,7 @@ rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 
 # umount overlay again, create a new file with the same name and
 # mount overlay again.
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 touch $lowerdir1/testdir
 
 _overlay_scratch_mount_dirs $lowerdir1 $upperdir $workdir
@@ -77,7 +77,7 @@ _overlay_scratch_mount_dirs $lowerdir1 $upperdir $workdir
 # it will not clean up the dir and lead to residue.
 rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # let lower dir have invalid whiteouts, repeat ls and rmdir test again.
 rm -rf $lowerdir1/testdir
@@ -92,7 +92,7 @@ _overlay_scratch_mount_dirs "$lowerdir1:$lowerdir2" $upperdir $workdir
 ls $SCRATCH_MNT/testdir
 rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # let lower dir and upper dir both have invalid whiteouts, repeat ls and rmdir again.
 rm -rf $lowerdir1/testdir
diff --git a/tests/overlay/035 b/tests/overlay/035
index cede58790e1b9d..c6ce1318fbbb37 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -43,7 +43,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 _overlay_scratch_mount_opts -o"lowerdir=$lowerdir2:$lowerdir1"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
 _mount -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Make workdir immutable to prevent workdir re-create on mount
 $CHATTR_PROG +i $workdir
diff --git a/tests/overlay/036 b/tests/overlay/036
index 19a181bbdd9361..f902617d4ab0a2 100755
--- a/tests/overlay/036
+++ b/tests/overlay/036
@@ -34,8 +34,8 @@ _cleanup()
 	cd /
 	rm -f $tmp.*
 	# unmount the two extra mounts in case they did not fail
-	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
-	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+	_umount $SCRATCH_MNT 2>/dev/null
+	_umount $SCRATCH_MNT 2>/dev/null
 }
 
 # Import common functions.
@@ -66,13 +66,13 @@ _overlay_mount_dirs $lowerdir $upperdir $workdir \
 # with index=off - expect success
 _overlay_mount_dirs $lowerdir $upperdir $workdir2 \
 		    overlay0 $SCRATCH_MNT -oindex=off && \
-		    $UMOUNT_PROG $SCRATCH_MNT
+		    _umount $SCRATCH_MNT
 
 # Try to mount another overlay with the same workdir
 # with index=off - expect success
 _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
 		    overlay1 $SCRATCH_MNT -oindex=off && \
-		    $UMOUNT_PROG $SCRATCH_MNT
+		    _umount $SCRATCH_MNT
 
 # Try to mount another overlay with the same upperdir
 # with index=on - expect EBUSY
diff --git a/tests/overlay/037 b/tests/overlay/037
index 834e176380ebea..c278e7cab1fe05 100755
--- a/tests/overlay/037
+++ b/tests/overlay/037
@@ -39,17 +39,17 @@ mkdir -p $lowerdir $lowerdir2 $upperdir $upperdir2 $workdir
 # Mount overlay with lowerdir, upperdir, workdir and index=on
 # to store the file handles of lowerdir and upperdir in overlay.origin xattr
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -oindex=on
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Try to mount an overlay with the same upperdir and different lowerdir - expect ESTALE
 _overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir -oindex=on \
 	2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 # Try to mount an overlay with the same workdir and different upperdir - expect ESTALE
 _overlay_scratch_mount_dirs $lowerdir $upperdir2 $workdir -oindex=on \
 	2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 # Mount overlay with original lowerdir, upperdir, workdir and index=on - expect success
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -oindex=on
diff --git a/tests/overlay/040 b/tests/overlay/040
index 11c7bf129a3626..47f50eb0638da0 100755
--- a/tests/overlay/040
+++ b/tests/overlay/040
@@ -48,7 +48,7 @@ _scratch_mount
 # modify lower origin file.
 $CHATTR_PROG +i $SCRATCH_MNT/foo > /dev/null 2>&1
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # touching origin file in lower, should succeed
 touch $lowerdir/foo
diff --git a/tests/overlay/041 b/tests/overlay/041
index 36491b8fa0edf6..52ca351b66d86c 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -142,7 +142,7 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
 [[ $subdir_d == "subdir d" ]] || \
 	echo "Merged dir: Invalid d_ino reported for subdir"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # check overlayfs
 _overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o xino=on
diff --git a/tests/overlay/042 b/tests/overlay/042
index aaa10da33e0249..ddd4173abee8ce 100755
--- a/tests/overlay/042
+++ b/tests/overlay/042
@@ -45,7 +45,7 @@ _scratch_mount -o index=off
 # Copy up lower and create upper hardlink with no index
 ln $SCRATCH_MNT/0 $SCRATCH_MNT/1
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Add lower hardlinks while overlay is offline
 ln $lowerdir/0 $lowerdir/2
diff --git a/tests/overlay/043 b/tests/overlay/043
index 7325c653ab5cab..15cb9bf4bafaca 100755
--- a/tests/overlay/043
+++ b/tests/overlay/043
@@ -126,7 +126,7 @@ echo 3 > /proc/sys/vm/drop_caches
 check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
 
 # Verify that the inode numbers survive a mount cycle
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on,xino=on
 
 # Compare inode numbers before/after mount cycle
diff --git a/tests/overlay/044 b/tests/overlay/044
index 4d04d883efd695..5f09cc31c32a1e 100755
--- a/tests/overlay/044
+++ b/tests/overlay/044
@@ -99,7 +99,7 @@ cat $FILES
 check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
 
 # Verify that the hardlinks survive a mount cycle
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on,xino=on
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on,xino=on
 
diff --git a/tests/overlay/048 b/tests/overlay/048
index 897e797e2ff549..4bd9753666bf6c 100755
--- a/tests/overlay/048
+++ b/tests/overlay/048
@@ -32,7 +32,7 @@ report_nlink()
 		_ls_l $SCRATCH_MNT/$f | awk '{ print $2, $9 }' | _filter_scratch
 	done
 
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Create lower hardlinks
@@ -101,7 +101,7 @@ touch $SCRATCH_MNT/1
 touch $SCRATCH_MNT/2
 
 # Perform the rest of the changes offline
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 test_hardlinks_offline
 
diff --git a/tests/overlay/049 b/tests/overlay/049
index 3ee500c5dd13b8..b091330ea26e2c 100755
--- a/tests/overlay/049
+++ b/tests/overlay/049
@@ -32,7 +32,7 @@ create_redirect()
 	touch $SCRATCH_MNT/origin/file
 	mv $SCRATCH_MNT/origin $SCRATCH_MNT/$redirect
 
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Import common functions.
diff --git a/tests/overlay/050 b/tests/overlay/050
index ec936e2a758f81..7c8ed1a4e96e8c 100755
--- a/tests/overlay/050
+++ b/tests/overlay/050
@@ -76,7 +76,7 @@ mount_dirs()
 # Unmount the overlay without unmounting base fs
 unmount_dirs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Check non-stale file handles of lower/upper files and verify
diff --git a/tests/overlay/051 b/tests/overlay/051
index 9404dbbab90f15..2dadb5a3027180 100755
--- a/tests/overlay/051
+++ b/tests/overlay/051
@@ -28,7 +28,7 @@ _cleanup()
 	# Cleanup overlay scratch mount that is holding base test mount
 	# to prevent _check_test_fs and _test_umount from failing before
 	# _check_scratch_fs _scratch_umount
-	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+	_umount $SCRATCH_MNT 2>/dev/null
 }
 
 # Import common functions.
@@ -103,7 +103,7 @@ mount_dirs()
 # underlying dirs
 unmount_dirs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 
 	_overlay_check_scratch_dirs $middle:$lower $upper $work \
 				-o "index=on,nfs_export=on"
diff --git a/tests/overlay/052 b/tests/overlay/052
index 37402067dbe65e..e3366ea44147cb 100755
--- a/tests/overlay/052
+++ b/tests/overlay/052
@@ -73,7 +73,7 @@ mount_dirs()
 # Unmount the overlay without unmounting base fs
 unmount_dirs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Check non-stale file handles of lower/upper moved files
diff --git a/tests/overlay/053 b/tests/overlay/053
index f7891aceda7246..87f748cefd3338 100755
--- a/tests/overlay/053
+++ b/tests/overlay/053
@@ -30,7 +30,7 @@ _cleanup()
 	# Cleanup overlay scratch mount that is holding base test mount
 	# to prevent _check_test_fs and _test_umount from failing before
 	# _check_scratch_fs _scratch_umount
-	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+	_umount $SCRATCH_MNT 2>/dev/null
 }
 
 # Import common functions.
@@ -99,7 +99,7 @@ mount_dirs()
 # underlying dirs
 unmount_dirs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 
 	_overlay_check_scratch_dirs $middle:$lower $upper $work \
 				-o "index=on,nfs_export=on,redirect_dir=on"
diff --git a/tests/overlay/054 b/tests/overlay/054
index 8d7f026a2d9b00..566d266a1ad788 100755
--- a/tests/overlay/054
+++ b/tests/overlay/054
@@ -87,7 +87,7 @@ mount_dirs()
 # Unmount the overlay without unmounting base fs
 unmount_dirs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Check encode/decode/read file handles of dir with non-indexed ancestor
diff --git a/tests/overlay/055 b/tests/overlay/055
index 87a348c94489b8..a5b169956f4c09 100755
--- a/tests/overlay/055
+++ b/tests/overlay/055
@@ -37,7 +37,7 @@ _cleanup()
 	# Cleanup overlay scratch mount that is holding base test mount
 	# to prevent _check_test_fs and _test_umount from failing before
 	# _check_scratch_fs _scratch_umount
-	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+	_umount $SCRATCH_MNT 2>/dev/null
 }
 
 # Import common functions.
@@ -109,7 +109,7 @@ mount_dirs()
 # underlying dirs
 unmount_dirs()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 
 	_overlay_check_scratch_dirs $middle:$lower $upper $work \
 				-o "index=on,nfs_export=on,redirect_dir=on"
diff --git a/tests/overlay/056 b/tests/overlay/056
index 158f34d05c22e9..01c319d7263f3c 100755
--- a/tests/overlay/056
+++ b/tests/overlay/056
@@ -73,7 +73,7 @@ mkdir $lowerdir/testdir2/subdir
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
 touch $SCRATCH_MNT/testdir1/foo
 touch $SCRATCH_MNT/testdir2/subdir
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 remove_impure $upperdir/testdir1
 remove_impure $upperdir/testdir2
 
diff --git a/tests/overlay/057 b/tests/overlay/057
index da7ffda30277d9..b631d431a37b47 100755
--- a/tests/overlay/057
+++ b/tests/overlay/057
@@ -48,7 +48,7 @@ _overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2 -o redirect_dir=on
 # Create opaque parent with absolute redirect child in middle layer
 mkdir $SCRATCH_MNT/pure
 mv $SCRATCH_MNT/origin $SCRATCH_MNT/pure/redirect
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir -o redirect_dir=on
 mv $SCRATCH_MNT/pure/redirect $SCRATCH_MNT/redirect
 # List content of renamed merge dir before mount cycle
@@ -56,7 +56,7 @@ ls $SCRATCH_MNT/redirect/
 
 # Verify that redirects are followed by listing content of renamed merge dir
 # after mount cycle
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir -o redirect_dir=on
 ls $SCRATCH_MNT/redirect/
 
diff --git a/tests/overlay/059 b/tests/overlay/059
index c48d2a82c76ec4..84b5c80eb984de 100755
--- a/tests/overlay/059
+++ b/tests/overlay/059
@@ -33,7 +33,7 @@ create_origin_ref()
 	_scratch_mount -o redirect_dir=on
 	mv $SCRATCH_MNT/origin $SCRATCH_MNT/$ref
 
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Import common functions.
diff --git a/tests/overlay/060 b/tests/overlay/060
index bb61fcfa644342..3d0ea353feaa9a 100755
--- a/tests/overlay/060
+++ b/tests/overlay/060
@@ -130,7 +130,7 @@ mount_ro_overlay()
 
 umount_overlay()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 # Assumes it is called with overlay mounted.
diff --git a/tests/overlay/062 b/tests/overlay/062
index 9a1db7419c4ca2..97a1bd8c12f20e 100755
--- a/tests/overlay/062
+++ b/tests/overlay/062
@@ -18,7 +18,7 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	$UMOUNT_PROG $lowertestdir
+	_umount $lowertestdir
 }
 
 # Import common functions.
diff --git a/tests/overlay/063 b/tests/overlay/063
index d9f30606a92d44..a50e63665202f0 100755
--- a/tests/overlay/063
+++ b/tests/overlay/063
@@ -40,7 +40,7 @@ rm ${upperdir}/file
 mkdir ${SCRATCH_MNT}/file > /dev/null 2>&1
 
 # unmount overlayfs
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 echo "Silence is golden"
 # success, all done
diff --git a/tests/overlay/065 b/tests/overlay/065
index fb6d6dd1bfcc0e..26f1c4bde4da90 100755
--- a/tests/overlay/065
+++ b/tests/overlay/065
@@ -30,7 +30,7 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	$UMOUNT_PROG $mnt2 2>/dev/null
+	_umount $mnt2 2>/dev/null
 }
 
 # Import common functions.
@@ -63,7 +63,7 @@ mkdir -p $lowerdir/lower $upperdir $workdir
 echo Conflicting upperdir/lowerdir
 _overlay_scratch_mount_dirs $upperdir $upperdir $workdir \
 	2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 # Use new upper/work dirs for each test to avoid ESTALE errors
 # on mismatch lowerdir/upperdir (see test overlay/037)
@@ -75,7 +75,7 @@ mkdir $upperdir $workdir
 echo Conflicting workdir/lowerdir
 _overlay_scratch_mount_dirs $workdir $upperdir $workdir \
 	-oindex=off 2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir $workdir
 mkdir -p $upperdir/lower $workdir
@@ -85,7 +85,7 @@ mkdir -p $upperdir/lower $workdir
 echo Overlapping upperdir/lowerdir
 _overlay_scratch_mount_dirs $upperdir/lower $upperdir $workdir \
 	2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir $workdir
 mkdir $upperdir $workdir
@@ -94,7 +94,7 @@ mkdir $upperdir $workdir
 echo Conflicting lower layers
 _overlay_scratch_mount_dirs $lowerdir:$lowerdir $upperdir $workdir \
 	2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir $workdir
 mkdir $upperdir $workdir
@@ -103,7 +103,7 @@ mkdir $upperdir $workdir
 echo Overlapping lower layers below
 _overlay_scratch_mount_dirs $lowerdir:$lowerdir/lower $upperdir $workdir \
 	2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir $workdir
 mkdir $upperdir $workdir
@@ -112,7 +112,7 @@ mkdir $upperdir $workdir
 echo Overlapping lower layers above
 _overlay_scratch_mount_dirs $lowerdir/lower:$lowerdir $upperdir $workdir \
 	2>&1 | _filter_error_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir $workdir
 mkdir -p $upperdir/upper $workdir $mnt2
@@ -129,14 +129,14 @@ mkdir -p $upperdir2 $workdir2 $mnt2
 echo "Overlapping with upperdir of another instance (index=on)"
 _overlay_scratch_mount_dirs $upperdir/upper $upperdir2 $workdir2 \
 	-oindex=on 2>&1 | _filter_busy_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir2 $workdir2
 mkdir -p $upperdir2 $workdir2
 
 echo "Overlapping with upperdir of another instance (index=off)"
 _overlay_scratch_mount_dirs $upperdir/upper $upperdir2 $workdir2 \
-	-oindex=off && $UMOUNT_PROG $SCRATCH_MNT
+	-oindex=off && _umount $SCRATCH_MNT
 
 rm -rf $upperdir2 $workdir2
 mkdir -p $upperdir2 $workdir2
@@ -146,14 +146,14 @@ mkdir -p $upperdir2 $workdir2
 echo "Overlapping with workdir of another instance (index=on)"
 _overlay_scratch_mount_dirs $workdir/work $upperdir2 $workdir2 \
 	-oindex=on 2>&1 | _filter_busy_mount
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir2 $workdir2
 mkdir -p $upperdir2 $workdir2
 
 echo "Overlapping with workdir of another instance (index=off)"
 _overlay_scratch_mount_dirs $workdir/work $upperdir2 $workdir2 \
-	-oindex=off && $UMOUNT_PROG $SCRATCH_MNT
+	-oindex=off && _umount $SCRATCH_MNT
 
 # Move upper layer root into lower layer after mount
 echo Overlapping upperdir/lowerdir after mount
diff --git a/tests/overlay/067 b/tests/overlay/067
index bb09a6042b275d..12a1781c149644 100755
--- a/tests/overlay/067
+++ b/tests/overlay/067
@@ -70,7 +70,7 @@ stat $testfile >>$seqres.full
 diff -q $realfile $testfile >>$seqres.full &&
 	echo "diff with middle layer file doesn't know right from wrong! (cold cache)"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 # check overlayfs
 _overlay_check_scratch_dirs $middle:$lower $upper $work -o xino=off
 
diff --git a/tests/overlay/068 b/tests/overlay/068
index 0d33cf12de8550..480ba67e33ea74 100755
--- a/tests/overlay/068
+++ b/tests/overlay/068
@@ -28,7 +28,7 @@ _cleanup()
 	cd /
 	rm -f $tmp.*
 	# Unmount the nested overlay mount
-	$UMOUNT_PROG $mnt2 2>/dev/null
+	_umount $mnt2 2>/dev/null
 }
 
 # Import common functions.
@@ -100,7 +100,7 @@ mount_dirs()
 unmount_dirs()
 {
 	# unmount & check nested overlay
-	$UMOUNT_PROG $mnt2
+	_umount $mnt2
 	_overlay_check_dirs $SCRATCH_MNT $upper2 $work2 \
 		-o "index=on,nfs_export=on,redirect_dir=on"
 
diff --git a/tests/overlay/069 b/tests/overlay/069
index 373ab1ee3dc115..67969eebbfcaa3 100755
--- a/tests/overlay/069
+++ b/tests/overlay/069
@@ -28,7 +28,7 @@ _cleanup()
 	cd /
 	rm -f $tmp.*
 	# Unmount the nested overlay mount
-	$UMOUNT_PROG $mnt2 2>/dev/null
+	_umount $mnt2 2>/dev/null
 }
 
 # Import common functions.
@@ -108,12 +108,12 @@ mount_dirs()
 unmount_dirs()
 {
 	# unmount & check nested overlay
-	$UMOUNT_PROG $mnt2
+	_umount $mnt2
 	_overlay_check_dirs $SCRATCH_MNT $upper2 $work2 \
 		-o "index=on,nfs_export=on,redirect_dir=on"
 
 	# unmount & check underlying overlay
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_overlay_check_dirs $lower $upper $work \
 		-o "index=on,nfs_export=on,redirect_dir=on"
 }
diff --git a/tests/overlay/070 b/tests/overlay/070
index 36991229f28fe7..104b5f492088d6 100755
--- a/tests/overlay/070
+++ b/tests/overlay/070
@@ -26,7 +26,7 @@ _cleanup()
 	cd /
 	rm -f $tmp.*
 	# Unmount the nested overlay mount
-	$UMOUNT_PROG $mnt2 2>/dev/null
+	_umount $mnt2 2>/dev/null
 	[ -z "$loopdev" ] || _destroy_loop_device $loopdev
 }
 
@@ -93,12 +93,12 @@ mount_dirs()
 unmount_dirs()
 {
 	# unmount & check nested overlay
-	$UMOUNT_PROG $mnt2
+	_umount $mnt2
 	_overlay_check_dirs $SCRATCH_MNT $upper2 $work2 \
 		-o "redirect_dir=on,index=on,xino=on"
 
 	# unmount & check underlying overlay
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_overlay_check_scratch_dirs $lower $upper $work \
 		-o "index=on,nfs_export=on"
 }
diff --git a/tests/overlay/071 b/tests/overlay/071
index 2a6313142d09d2..c58347f6cdb1c6 100755
--- a/tests/overlay/071
+++ b/tests/overlay/071
@@ -29,7 +29,7 @@ _cleanup()
 	cd /
 	rm -f $tmp.*
 	# Unmount the nested overlay mount
-	$UMOUNT_PROG $mnt2 2>/dev/null
+	_umount $mnt2 2>/dev/null
 	[ -z "$loopdev" ] || _destroy_loop_device $loopdev
 }
 
@@ -103,12 +103,12 @@ mount_dirs()
 unmount_dirs()
 {
 	# unmount & check nested overlay
-	$UMOUNT_PROG $mnt2
+	_umount $mnt2
 	_overlay_check_dirs $SCRATCH_MNT $upper2 $work2 \
 		-o "redirect_dir=on,index=on,xino=on"
 
 	# unmount & check underlying overlay
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_overlay_check_dirs $lower $upper $work \
 		-o "index=on,nfs_export=on"
 }
diff --git a/tests/overlay/076 b/tests/overlay/076
index fb94dff685b6cc..28bf2d305b94d7 100755
--- a/tests/overlay/076
+++ b/tests/overlay/076
@@ -47,7 +47,7 @@ _scratch_mount
 # on kernel v5.10..v5.10.14.  Anything but hang is considered a test success.
 $CHATTR_PROG +i $SCRATCH_MNT/foo > /dev/null 2>&1
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # success, all done
 echo "Silence is golden"
diff --git a/tests/overlay/077 b/tests/overlay/077
index 00de0825aea6dc..cff24800469362 100755
--- a/tests/overlay/077
+++ b/tests/overlay/077
@@ -65,7 +65,7 @@ mv $SCRATCH_MNT/f100 $SCRATCH_MNT/former/
 
 # Remove the lower directory and mount overlay again to create
 # a "former merge dir"
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 rm -rf $lowerdir/former
 _scratch_mount
 
diff --git a/tests/overlay/078 b/tests/overlay/078
index d6df11f6852f45..bcc5aff1b7dc89 100755
--- a/tests/overlay/078
+++ b/tests/overlay/078
@@ -61,7 +61,7 @@ do_check()
 
 	echo "Test chattr +$1 $2" >> $seqres.full
 
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 
 	# Add attribute to lower file
 	$CHATTR_PROG +$attr $lowertestfile
diff --git a/tests/overlay/079 b/tests/overlay/079
index cfcafceea56e66..f8926e091ca137 100755
--- a/tests/overlay/079
+++ b/tests/overlay/079
@@ -156,7 +156,7 @@ mount_ro_overlay()
 
 umount_overlay()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 test_no_access()
diff --git a/tests/overlay/080 b/tests/overlay/080
index ce5c2375fb3154..94fe33ae7db4d2 100755
--- a/tests/overlay/080
+++ b/tests/overlay/080
@@ -264,7 +264,7 @@ mount_overlay()
 
 umount_overlay()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 
diff --git a/tests/overlay/081 b/tests/overlay/081
index 2270a04750da1f..454eea2cd96576 100755
--- a/tests/overlay/081
+++ b/tests/overlay/081
@@ -46,7 +46,7 @@ ovl_fsid=$(stat -f -c '%i' $test_dir)
 	echo "Overlayfs (uuid=null) and upper fs fsid differ"
 
 # Keep base fs mounted in case it has a volatile fsid (e.g. tmpfs)
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Test legacy behavior is preserved by default for existing "impure" overlayfs
 _scratch_mount
@@ -55,7 +55,7 @@ ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$upper_fsid" ]] || \
 	echo "Overlayfs (after uuid=null) and upper fs fsid differ"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Test unique fsid on explicit opt-in for existing "impure" overlayfs
 _scratch_mount -o uuid=on
@@ -65,7 +65,7 @@ ovl_unique_fsid=$ovl_fsid
 [[ "$ovl_fsid" != "$upper_fsid" ]] || \
 	echo "Overlayfs (uuid=on) and upper fs fsid are the same"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Test unique fsid is persistent by default after it was created
 _scratch_mount
@@ -74,7 +74,7 @@ ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
 	echo "Overlayfs (after uuid=on) unique fsid is not persistent"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Test ignore existing persistent fsid on explicit opt-out
 _scratch_mount -o uuid=null
@@ -83,7 +83,7 @@ ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$upper_fsid" ]] || \
 	echo "Overlayfs (uuid=null) and upper fs fsid differ"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Test fallback to uuid=null with non-upper ovelray
 _overlay_scratch_mount_dirs "$upperdir:$lowerdir" "-" "-" -o ro,uuid=on
@@ -110,7 +110,7 @@ ovl_unique_fsid=$ovl_fsid
 [[ "$ovl_fsid" != "$upper_fsid" ]] || \
 	echo "Overlayfs (new) and upper fs fsid are the same"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 # Test unique fsid is persistent by default after it was created
 _scratch_mount -o uuid=on
@@ -119,7 +119,7 @@ ovl_fsid=$(stat -f -c '%i' $test_dir)
 [[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
 	echo "Overlayfs (uuid=on) unique fsid is not persistent"
 
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 echo "Silence is golden"
 status=0
diff --git a/tests/overlay/083 b/tests/overlay/083
index 56e02f8cc77d73..aaa3fdb9ad139a 100755
--- a/tests/overlay/083
+++ b/tests/overlay/083
@@ -52,7 +52,7 @@ _mount -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces &&
 
 # Re-create the upper/work dirs to mount them with a different lower
 # This is required in case index feature is enabled
-$UMOUNT_PROG $SCRATCH_MNT
+_umount $SCRATCH_MNT
 rm -rf "$upperdir" "$workdir"
 mkdir -p "$upperdir" "$workdir"
 
diff --git a/tests/overlay/084 b/tests/overlay/084
index 28e9a76dc734c0..67321bc7618389 100755
--- a/tests/overlay/084
+++ b/tests/overlay/084
@@ -15,7 +15,7 @@ _cleanup()
 {
 	cd /
 	# Unmount nested mounts if things fail
-	$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/nested  2>/dev/null
+	_umount $OVL_BASE_SCRATCH_MNT/nested  2>/dev/null
 	rm -rf $tmp
 }
 
@@ -44,7 +44,7 @@ nesteddir=$OVL_BASE_SCRATCH_MNT/nested
 
 umount_overlay()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 test_escape()
@@ -88,12 +88,12 @@ test_escape()
 	echo "nested xattr mount with trusted.overlay"
 	_overlay_mount_dirs $SCRATCH_MNT/layer2:$SCRATCH_MNT/layer1 - - overlayfs $nesteddir
 	stat $nesteddir/dir/file  2>&1 | _filter_scratch
-	$UMOUNT_PROG $nesteddir
+	_umount $nesteddir
 
 	echo "nested xattr mount with user.overlay"
 	_overlay_mount_dirs $SCRATCH_MNT/layer2:$SCRATCH_MNT/layer1 - - -o userxattr overlayfs $nesteddir
 	stat $nesteddir/dir/file  2>&1 | _filter_scratch
-	$UMOUNT_PROG $nesteddir
+	_umount $nesteddir
 
 	# Also ensure propagate the escaped xattr when we copy-up layer2/dir
 	echo "copy-up of escaped xattrs"
@@ -164,7 +164,7 @@ test_escaped_xwhiteout()
 
 	do_test_xwhiteout $prefix $nesteddir
 
-	$UMOUNT_PROG $nesteddir
+	_umount $nesteddir
 }
 
 test_escaped_xwhiteout trusted
diff --git a/tests/overlay/085 b/tests/overlay/085
index 046d01d161d829..8396ceb7c72b90 100755
--- a/tests/overlay/085
+++ b/tests/overlay/085
@@ -157,7 +157,7 @@ mount_ro_overlay()
 
 umount_overlay()
 {
-	$UMOUNT_PROG $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 test_no_access()
diff --git a/tests/overlay/086 b/tests/overlay/086
index 23c56d074ff34a..45e5b45a279853 100755
--- a/tests/overlay/086
+++ b/tests/overlay/086
@@ -38,21 +38,21 @@ _mount -t overlay none $SCRATCH_MNT \
 	2>> $seqres.full && \
 	echo "ERROR: invalid combination of lowerdir and lowerdir+ mount options"
 
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 _mount -t overlay none $SCRATCH_MNT \
 	-o"lowerdir=$lowerdir,datadir+=$lowerdir_colons" \
 	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
 	echo "ERROR: invalid combination of lowerdir and datadir+ mount options"
 
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 _mount -t overlay none $SCRATCH_MNT \
 	-o"datadir+=$lowerdir,lowerdir+=$lowerdir_colons" \
 	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
 	echo "ERROR: invalid order of lowerdir+ and datadir+ mount options"
 
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 # mount is expected to fail with escaped colons.
 _mount -t overlay none $SCRATCH_MNT \
@@ -60,7 +60,7 @@ _mount -t overlay none $SCRATCH_MNT \
 	2>> $seqres.full && \
 	echo "ERROR: incorrect parsing of escaped colons in lowerdir+ mount option"
 
-$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+_umount $SCRATCH_MNT 2>/dev/null
 
 # mount is expected to succeed without escaped colons.
 _mount -t overlay ovl_esc_test $SCRATCH_MNT \
diff --git a/tests/xfs/078 b/tests/xfs/078
index 4224fd40bc9fea..799d8881220582 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -16,7 +16,7 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
+	_umount $LOOP_MNT 2>/dev/null
 	[ -n "$LOOP_DEV" ] && _destroy_loop_device $LOOP_DEV 2>/dev/null
 	# try to keep the image file if test fails
 	[ $status -eq 0 ] && rm -f $LOOP_IMG
@@ -81,7 +81,7 @@ _grow_loop()
 	$XFS_GROWFS_PROG $LOOP_MNT 2>&1 |  _filter_growfs 2>&1
 
 	echo "*** unmount"
-	$UMOUNT_PROG -d $LOOP_MNT && LOOP_DEV=
+	_umount -d $LOOP_MNT && LOOP_DEV=
 
 	# Large grows takes forever to check..
 	if [ "$check" -gt "0" ]
diff --git a/tests/xfs/148 b/tests/xfs/148
index 9e6798f999b356..7c9badd3c1b3a0 100755
--- a/tests/xfs/148
+++ b/tests/xfs/148
@@ -14,7 +14,7 @@ _begin_fstest auto quick fuzzers
 _cleanup()
 {
 	cd /
-	$UMOUNT_PROG $mntpt > /dev/null 2>&1
+	_umount $mntpt > /dev/null 2>&1
 	_destroy_loop_device $loopdev > /dev/null 2>&1
 	rm -r -f $tmp.*
 }
@@ -90,7 +90,7 @@ cat $tmp.log >> $seqres.full
 cat $tmp.log | _filter_test_dir
 
 # Corrupt the entries
-$UMOUNT_PROG $mntpt
+_umount $mntpt
 _destroy_loop_device $loopdev
 cp $imgfile $imgfile.old
 sed -b \
@@ -121,7 +121,7 @@ fi
 echo "does repair complain?" >> $seqres.full
 
 # Does repair complain about this?
-$UMOUNT_PROG $mntpt
+_umount $mntpt
 $XFS_REPAIR_PROG -n $loopdev >> $seqres.full 2>&1
 res=$?
 test $res -eq 1 || \
diff --git a/tests/xfs/149 b/tests/xfs/149
index bbaf86132dff37..ceb80b646f5784 100755
--- a/tests/xfs/149
+++ b/tests/xfs/149
@@ -22,7 +22,7 @@ loop_symlink=$TEST_DIR/loop_symlink.$$
 # Override the default cleanup function.
 _cleanup()
 {
-    $UMOUNT_PROG $mntdir
+    _umount $mntdir
     [ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
     rmdir $mntdir
     rm -f $loop_symlink
@@ -73,7 +73,7 @@ echo "=== xfs_growfs - check device symlink ==="
 $XFS_GROWFS_PROG -D 12288 $loop_symlink > /dev/null
 
 echo "=== unmount ==="
-$UMOUNT_PROG $mntdir || _fail "!!! failed to unmount"
+_umount $mntdir || _fail "!!! failed to unmount"
 
 echo "=== mount device symlink ==="
 _mount $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
diff --git a/tests/xfs/186 b/tests/xfs/186
index 88f02585e7f667..2bd4fe10ab8930 100755
--- a/tests/xfs/186
+++ b/tests/xfs/186
@@ -87,7 +87,7 @@ _do_eas()
 		_create_eas $2 $3
 	fi
 	echo ""
-	cd /; $UMOUNT_PROG $SCRATCH_MNT
+	cd /; _umount $SCRATCH_MNT
 	_print_inode
 }
 
@@ -99,7 +99,7 @@ _do_dirents()
 	echo ""
 	_scratch_mount
 	_create_dirents $1 $2
-	cd /; $UMOUNT_PROG $SCRATCH_MNT
+	cd /; _umount $SCRATCH_MNT
 	_print_inode
 }
 
diff --git a/tests/xfs/289 b/tests/xfs/289
index 089a3f8cc14a68..aab5f96293b3a5 100755
--- a/tests/xfs/289
+++ b/tests/xfs/289
@@ -13,8 +13,8 @@ _begin_fstest growfs auto quick
 # Override the default cleanup function.
 _cleanup()
 {
-    $UMOUNT_PROG $tmpdir
-    $UMOUNT_PROG $tmpbind
+    _umount $tmpdir
+    _umount $tmpbind
     rmdir $tmpdir
     rm -f $tmpsymlink
     rmdir $tmpbind
diff --git a/tests/xfs/507 b/tests/xfs/507
index 75c183c07a9fce..60542112fbd5a1 100755
--- a/tests/xfs/507
+++ b/tests/xfs/507
@@ -22,7 +22,7 @@ _register_cleanup "_cleanup" BUS
 _cleanup()
 {
 	cd /
-	test -n "$loop_mount" && $UMOUNT_PROG $loop_mount > /dev/null 2>&1
+	test -n "$loop_mount" && _umount $loop_mount > /dev/null 2>&1
 	test -n "$loop_dev" && _destroy_loop_device $loop_dev
 	rm -rf $tmp.*
 }
diff --git a/tests/xfs/513 b/tests/xfs/513
index 5585a9c8e76703..cb8d0aca841530 100755
--- a/tests/xfs/513
+++ b/tests/xfs/513
@@ -14,7 +14,7 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
+	_umount $LOOP_MNT 2>/dev/null
 	if [ -n "$LOOP_DEV" ];then
 		_destroy_loop_device $LOOP_DEV 2>/dev/null
 	fi
@@ -89,7 +89,7 @@ get_mount_info()
 
 force_unmount()
 {
-	$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
+	_umount $LOOP_MNT >/dev/null 2>&1
 }
 
 # _do_test <mount options> <should be mounted?> [<key string> <key should be found?>]
diff --git a/tests/xfs/544 b/tests/xfs/544
index a3a23c1726ca1c..f1b5cc74983a62 100755
--- a/tests/xfs/544
+++ b/tests/xfs/544
@@ -15,7 +15,7 @@ _cleanup()
 	_cleanup_dump
 	cd /
 	rm -r -f $tmp.*
-	$UMOUNT_PROG $TEST_DIR/dest.$seq 2> /dev/null
+	_umount $TEST_DIR/dest.$seq 2> /dev/null
 	rmdir $TEST_DIR/src.$seq 2> /dev/null
 	rmdir $TEST_DIR/dest.$seq 2> /dev/null
 }
diff --git a/tests/xfs/806 b/tests/xfs/806
index 09c55332cc8800..9334d1780c6855 100755
--- a/tests/xfs/806
+++ b/tests/xfs/806
@@ -23,7 +23,7 @@ _cleanup()
 {
 	cd /
 	rm -r -f $tmp.*
-	umount $dummymnt &>/dev/null
+	_umount $dummymnt &>/dev/null
 	rmdir $dummymnt &>/dev/null
 	rm -f $dummyfile
 }
@@ -46,7 +46,7 @@ testme() {
 	XFS_SCRUB_PHASE=7 $XFS_SCRUB_PROG -d -o autofsck $dummymnt 2>&1 | \
 		grep autofsck | _filter_test_dir | \
 		sed -e 's/\(directive.\).*$/\1/g'
-	umount $dummymnt
+	_umount $dummymnt
 }
 
 # We don't test the absence of an autofsck directive because xfs_scrub behaves

