Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B734F168BA;
	Wed, 13 Mar 2024 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710342995; cv=none; b=AvlNVDCAgLVxwyALRSFaTgUr5HnkExJP0EImO5p87aUUCCaSsxx9/RfsVf+g4bkU9otkpgcW5rlhnG2AO0D0qKGvVjvRG5P6IA5Vu7M8KLXymtW4MMH6yd07zlE/LuDRw48nEQrlTWsA7GbcwZDb0pnqJtf+/Cj57fKxeOQ+NTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710342995; c=relaxed/simple;
	bh=/VfMSVuJ0LRMn1QZy8MUAk06JYgIqoLg9IKfCNVoUy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSQI0c9ol6Scs5469gdIZZrSP7P1ZAlaVGLjnqLja79rYnC1xo+rZ3KH/o5hgKBT8jDTKJ9qeuwSCFfdbq35bEyqOhiveCtsz9ccX/fHL3BmmAMa99MI3TM3AtUWf3itJyZAdHO6POYwB7uc1zvbnSZZnfmGZqcOC1UjtALctmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erNcUTyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erNcUTyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11031C433F1;
	Wed, 13 Mar 2024 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710342995;
	bh=/VfMSVuJ0LRMn1QZy8MUAk06JYgIqoLg9IKfCNVoUy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=erNcUTySZB0tub9HBGqt7YdOzzM/sjUGnReg718qpPKDNYgpSpI+loJR5fiEoYoqs
	 EXPkMOxsYq2TxBgc6+LqVe8LF64smYdVV3WimAU+6XVKzkitBcm80s1A/8kgkZSFIc
	 BP7R0ret4AVB3nJEJj1DMg72ge1A/TGxhDXe3Nemr/WBsC1XCFI+wszIa3Jh0MsrIH
	 /1OjaCGKY05AqzEMFfa5eOyZlDrWWydD+qv8cMpFJ9lQ+6jijjDZUVcpIWFIDFg4po
	 DxhjzB+Wa8nmDtoj3T0n3mQirARru/qtbNEtQsWBX1sfTqW25d+Ql9PxUhoHRC8T8o
	 rnvsqFzFnW/yg==
Date: Wed, 13 Mar 2024 23:16:29 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: fstests@vger.kernel.org, zlang@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: fix test that fail formatting with 64k blocksize
Message-ID: <20240313151629.i23ing6hbsghpm4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240227173945.2945637-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227173945.2945637-1-kernel@pankajraghav.com>

On Tue, Feb 27, 2024 at 06:39:45PM +0100, Pankaj Raghav (Samsung) wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> There's a bunch of tests that fail the formatting step when the test run
> is configured to use XFS with a 64k blocksize.  This happens because XFS
> doesn't really support that combination due to minimum log size
> constraints. Fix the test to format larger devices in that case.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---

This change looks good to me, and it really fixes some testing failures.

Reviewed-by: Zorro Lang <zlang@redhat.com>

BTW, I tested 64k blocksize xfs with this patch, there're still some failed
test cases. If you're still interested in it, I'd like to list some of them
as below (diff *.out *.out.bad output).

Thanks,
Zorro

*generic/209 failed as:*

--- /dev/fd/63	2024-03-12 13:21:39.068413534 -0400
+++ generic/219.out.bad	2024-03-12 13:21:38.898422979 -0400
@@ -16,7 +16,7 @@
   Size: 49152        Filetype: Regular File
   File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
-Usage OK (type=u)
+Too many blocks used (type=u)
 
 ### test group accounting
 
@@ -34,4 +34,4 @@
   Size: 49152        Filetype: Regular File
   File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
-Usage OK (type=g)
+Too many blocks used (type=g)

*generic/305 failed as:*

--- /dev/fd/63	2024-03-12 14:23:31.267112014 -0400
+++ generic/305.out.bad	2024-03-12 14:23:31.187112447 -0400
@@ -11,7 +11,7 @@
 CoW one of the files
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 3584 0 0
 Remount the FS to see if accounting changes
 root 0 0 0
 nobody 0 0 0

*generic/326 failed as:*

--- /dev/fd/63	2024-03-12 14:31:14.114629354 -0400
+++ generic/326.out.bad	2024-03-12 14:31:14.034629780 -0400
@@ -11,7 +11,7 @@
 CoW one of the files
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 3584 0 0
 Remount the FS to see if accounting changes
 root 0 0 0
 nobody 0 0 0

*generic/619 failed as:*

--- /dev/fd/63	2024-03-12 15:59:59.575021573 -0400
+++ generic/619.out.bad	2024-03-12 15:59:59.505021947 -0400
@@ -1,2 +1,6 @@
 QA output created by 619
-Silence is golden
+FAIL: ENOSPC BUS faliure
+Small-file-ftruncate-test failed at iteration count: 2
+Filesystem     Type  Size  Used Avail Use% Mounted on
+/dev/vda3      xfs   208M  140M   69M  68% /mnt/xfstests/scratch
+Allocated: 70.0% Used: 68%

*generic/645 failed as:*

--- /dev/fd/63	2024-03-12 16:04:51.623473964 -0400
+++ generic/645.out.bad	2024-03-12 16:04:51.553474333 -0400
@@ -1,2 +1,4 @@
 QA output created by 645
 Silence is golden
+idmapped-mounts.c: 6671: nested_userns - Invalid argument - failure: sys_mount_setattr
+vfstest.c: 2418: run_test - Invalid argument - failure: test that nested user namespaces behave correctly when attached to idmapped mounts

*xfs/435 failed as:*

--- /dev/fd/63	2024-03-12 18:36:55.121259810 -0400
+++ xfs/435.out.bad	2024-03-12 18:36:55.051260220 -0400
@@ -3,3 +3,4 @@
 Create a many-block file
 Remount to check recovery
 See if we leak
+custom patient module removal for xfs timed out waiting for refcnt to become 0 using timeout of 50

*xfs/508 failed as:*

--- /dev/fd/63	2024-03-12 19:04:12.742260242 -0400
+++ xfs/508.out.bad	2024-03-12 19:04:12.672260624 -0400
@@ -1,12 +1,15 @@
 QA output created by 508
 == The parent directory has Project inheritance bit by default ==
+touch: cannot touch '/mnt/xfstests/scratch/dir/foo': No space left on device
+mkdir: cannot create directory '/mnt/xfstests/scratch/dir/dir_inherit': No space left on device
+touch: cannot touch '/mnt/xfstests/scratch/dir/dir_inherit/foo': No such file or directory
 Checking project test (path [SCR_MNT]/dir)...
 Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
 
 Write SCRATCH_MNT/dir/foo, expect ENOSPC:
-pwrite: No space left on device
+/mnt/xfstests/scratch/dir/foo: No space left on device
 Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
-pwrite: No space left on device
+/mnt/xfstests/scratch/dir/dir_inherit/foo: No such file or directory
 
 == After removing parent directory has Project inheritance bit ==
 Checking project test (path [SCR_MNT]/dir)...
@@ -19,5 +22,5 @@
 
 Write SCRATCH_MNT/dir/foo, expect Success:
 Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
-pwrite: No space left on device
+/mnt/xfstests/scratch/dir/dir_inherit/foo: No such file or directory
 Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:

*xfs/558 failed as:*

--- /dev/fd/63	2024-03-12 19:13:26.569223817 -0400
+++ xfs/558.out.bad	2024-03-12 19:13:26.489224254 -0400
@@ -1,2 +1,3 @@
 QA output created by 558
+Expected to hear about writeback iomap invalidations?
 Silence is golden



> @Darrick I added more tests that were failing, and increased 512m to 600m
> as generic/081 and generic/108 were still failing with 512m with
> the following on 64k page size system:                          
> MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=64k,'
> 
>  common/rc         | 29 +++++++++++++++++++++++++++++
>  tests/generic/042 |  9 +--------
>  tests/generic/081 |  7 +++++--
>  tests/generic/108 |  6 ++++--
>  tests/generic/455 |  3 ++-
>  tests/generic/457 |  3 ++-
>  tests/generic/482 |  3 ++-
>  tests/generic/704 |  3 ++-
>  tests/generic/730 |  3 ++-
>  tests/generic/731 |  3 ++-
>  tests/shared/298  |  2 +-
>  tests/xfs/279     |  7 ++++---
>  12 files changed, 56 insertions(+), 22 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 30c44ddd..f1a27bcd 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -923,6 +923,35 @@ _check_minimal_fs_size()
>  	fi
>  }
>  
> +# Round a proposed filesystem size up to the minimium supported size.  The
> +# input is in MB and so is the output.
> +_small_fs_size_mb()
> +{
> +	local size="$1"
> +	local runner_min_size=0
> +	local fs_min_size=0
> +
> +	case "$FSTYP" in
> +	xfs)
> +		# xfs no longer supports filesystems smaller than 600m
> +		fs_min_size=600
> +		;;
> +	f2fs)
> +		# f2fs-utils 1.9.0 needs at least 38 MB space for f2fs image.
> +		# However, f2fs-utils 1.14.0 needs at least 52 MB. Not sure if
> +		# it will change again. So just set it 128M.
> +		fs_min_size=128
> +		;;
> +	esac
> +	(( size < fs_min_size )) && size="$fs_min_size"
> +
> +	# If the test runner wanted a minimum size, enforce that here.
> +	test -n "$MIN_FSSIZE" && runner_min_size=$((MIN_FSSIZE / 1048576))
> +	(( size < runner_min_size)) && size="$runner_min_size"
> +
> +	echo "$size"
> +}
> +
>  # Create fs of certain size on scratch device
>  # _scratch_mkfs_sized <size in bytes> [optional blocksize]
>  _scratch_mkfs_sized()
> diff --git a/tests/generic/042 b/tests/generic/042
> index 5116183f..63a46d6b 100755
> --- a/tests/generic/042
> +++ b/tests/generic/042
> @@ -27,14 +27,7 @@ _crashtest()
>  	img=$SCRATCH_MNT/$seq.img
>  	mnt=$SCRATCH_MNT/$seq.mnt
>  	file=$mnt/file
> -	size=25M
> -
> -	# f2fs-utils 1.9.0 needs at least 38 MB space for f2fs image. However,
> -	# f2fs-utils 1.14.0 needs at least 52 MB. Not sure if it will change
> -	# again. So just set it 128M.
> -	if [ $FSTYP == "f2fs" ]; then
> -		size=128M
> -	fi
> +	size=$(_small_fs_size_mb 25)M
>  
>  	# Create an fs on a small, initialized image. The pattern is written to
>  	# the image to detect stale data exposure.
> diff --git a/tests/generic/081 b/tests/generic/081
> index 22ac94de..0996f221 100755
> --- a/tests/generic/081
> +++ b/tests/generic/081
> @@ -62,13 +62,16 @@ snapname=snap_$seq
>  mnt=$TEST_DIR/mnt_$seq
>  mkdir -p $mnt
>  
> +size=$(_small_fs_size_mb 300)
> +lvsize=$((size * 85 / 100))	 # ~256M
> +
>  # make sure there's enough disk space for 256M lv, test for 300M here in case
>  # lvm uses some space for metadata
> -_scratch_mkfs_sized $((300 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mkfs_sized $((size * 1024 * 1024)) >>$seqres.full 2>&1
>  $LVM_PROG vgcreate -f $vgname $SCRATCH_DEV >>$seqres.full 2>&1
>  # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
>  # (like 2.02.95 in RHEL6) don't support --yes option
> -yes | $LVM_PROG lvcreate -L 256M -n $lvname $vgname >>$seqres.full 2>&1
> +yes | $LVM_PROG lvcreate -L ${lvsize}M -n $lvname $vgname >>$seqres.full 2>&1
>  # wait for lvcreation to fully complete
>  $UDEV_SETTLE_PROG >>$seqres.full 2>&1
>  
> diff --git a/tests/generic/108 b/tests/generic/108
> index efe66ba5..07703fc8 100755
> --- a/tests/generic/108
> +++ b/tests/generic/108
> @@ -44,9 +44,11 @@ vgname=vg_$seq
>  
>  physical=`blockdev --getpbsz $SCRATCH_DEV`
>  logical=`blockdev --getss $SCRATCH_DEV`
> +size=$(_small_fs_size_mb 300)
> +lvsize=$((size * 91 / 100))
>  
>  # _get_scsi_debug_dev returns a scsi debug device with 128M in size by default
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 300`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev ${physical:-512} ${logical:-512} 0 $size`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
>  echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
>  
> @@ -55,7 +57,7 @@ $LVM_PROG pvcreate -f $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
>  $LVM_PROG vgcreate -f $vgname $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
>  # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
>  # (like 2.02.95 in RHEL6) don't support --yes option
> -yes | $LVM_PROG lvcreate -i 2 -I 4m -L 275m -n $lvname $vgname \
> +yes | $LVM_PROG lvcreate -i 2 -I 4m -L ${lvsize}m -n $lvname $vgname \
>  	>>$seqres.full 2>&1
>  # wait for lv creation to fully complete
>  $UDEV_SETTLE_PROG >>$seqres.full 2>&1
> diff --git a/tests/generic/455 b/tests/generic/455
> index c13d872c..da803de0 100755
> --- a/tests/generic/455
> +++ b/tests/generic/455
> @@ -51,7 +51,8 @@ SANITY_DIR=$TEST_DIR/fsxtests
>  rm -rf $SANITY_DIR
>  mkdir $SANITY_DIR
>  
> -devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
> +size=$(_small_fs_size_mb 200)           # 200m phys/virt size
> +devsize=$((1024*1024*size / 512))
>  csize=$((1024*64 / 512))                # 64k cluster size
>  lowspace=$((1024*1024 / 512))           # 1m low space threshold
>  
> diff --git a/tests/generic/457 b/tests/generic/457
> index ca0f5e62..03aeb814 100755
> --- a/tests/generic/457
> +++ b/tests/generic/457
> @@ -55,7 +55,8 @@ SANITY_DIR=$TEST_DIR/fsxtests
>  rm -rf $SANITY_DIR
>  mkdir $SANITY_DIR
>  
> -devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
> +size=$(_small_fs_size_mb 200)           # 200m phys/virt size
> +devsize=$((1024*1024*size / 512))
>  csize=$((1024*64 / 512))                # 64k cluster size
>  lowspace=$((1024*1024 / 512))           # 1m low space threshold
>  
> diff --git a/tests/generic/482 b/tests/generic/482
> index 6d8396d9..c647d24c 100755
> --- a/tests/generic/482
> +++ b/tests/generic/482
> @@ -65,7 +65,8 @@ fi
>  fsstress_args=$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $nr_cpus \
>  		$FSSTRESS_AVOID)
>  
> -devsize=$((1024*1024*200 / 512))	# 200m phys/virt size
> +size=$(_small_fs_size_mb 200)           # 200m phys/virt size
> +devsize=$((1024*1024*size / 512))
>  csize=$((1024*64 / 512))		# 64k cluster size
>  lowspace=$((1024*1024 / 512))		# 1m low space threshold
>  
> diff --git a/tests/generic/704 b/tests/generic/704
> index c0142a60..6cc4bb4a 100755
> --- a/tests/generic/704
> +++ b/tests/generic/704
> @@ -30,8 +30,9 @@ _require_scsi_debug
>  _require_test
>  _require_block_device $TEST_DEV
>  
> +size=$(_small_fs_size_mb 256)
>  echo "Get a device with 4096 physical sector size and 512 logical sector size"
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 $size`
>  blockdev --getpbsz --getss $SCSI_DEBUG_DEV
>  
>  echo "mkfs and mount"
> diff --git a/tests/generic/730 b/tests/generic/730
> index 11308cda..988c47e1 100755
> --- a/tests/generic/730
> +++ b/tests/generic/730
> @@ -27,7 +27,8 @@ _require_test
>  _require_block_device $TEST_DEV
>  _require_scsi_debug
>  
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 256`
> +size=$(_small_fs_size_mb 256)
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
>  echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
>  
> diff --git a/tests/generic/731 b/tests/generic/731
> index e1400d06..b279e3f7 100755
> --- a/tests/generic/731
> +++ b/tests/generic/731
> @@ -27,7 +27,8 @@ _require_block_device $TEST_DEV
>  _supported_fs generic
>  _require_scsi_debug
>  
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 256`
> +size=$(_small_fs_size_mb 256)
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
>  echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
>  
> diff --git a/tests/shared/298 b/tests/shared/298
> index 807d4c87..52bfffb8 100755
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -20,7 +20,7 @@ if [ "$FSTYP" = "btrfs" ]; then
>  	fssize=3000
>  else
>  	_require_fs_space $TEST_DIR 307200
> -	fssize=300
> +	fssize=$(_small_fs_size_mb 300)           # 200m phys/virt size
>  fi
>  
>  [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
> diff --git a/tests/xfs/279 b/tests/xfs/279
> index 835d187f..9f366d1e 100755
> --- a/tests/xfs/279
> +++ b/tests/xfs/279
> @@ -26,6 +26,7 @@ _cleanup()
>  _supported_fs xfs
>  
>  _require_scsi_debug
> +size=$(_small_fs_size_mb 128)
>  
>  # Remove xfs signature so -f isn't needed to re-mkfs
>  _wipe_device()
> @@ -55,7 +56,7 @@ _check_mkfs()
>  (
>  echo "==================="
>  echo "4k physical 512b logical aligned"
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 $size`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
>  # sector size should default to 4k
>  _check_mkfs $SCSI_DEBUG_DEV
> @@ -68,7 +69,7 @@ _put_scsi_debug_dev
>  (
>  echo "==================="
>  echo "4k physical 512b logical unaligned"
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 128`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 $size`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
>  # should fail on misalignment
>  _check_mkfs $SCSI_DEBUG_DEV
> @@ -85,7 +86,7 @@ _put_scsi_debug_dev
>  (
>  echo "==================="
>  echo "hard 4k physical / 4k logical"
> -SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 128`
> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 $size`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
>  # block size smaller than sector size should fail 
>  _check_mkfs -b size=2048 $SCSI_DEBUG_DEV
> 
> base-commit: 386c7b6aa69ebe8017a4728a994f80d55c660de4
> -- 
> 2.43.0
> 
> 
