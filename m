Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C74133998;
	Wed, 31 Jan 2024 18:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706725740; cv=none; b=hsRF1XadijUx1yQT7vM3DO+/6CLiqpl6uaN4qXcAk34OEnfA0bgNSBTh2QPg0ctxWKJUIM59e7mtKr/rgSuc0dHa3QOegdSXXyCkL2WU/Ha7bEBSSquwSIk6vIXTb2orL88S2vrcpWE41yNDiMrF/c73N227MxdvHmnvvxdjGnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706725740; c=relaxed/simple;
	bh=S8Y3/RbLzU/uJ/TIQnn4Jhqnr9PlUTawUzkHdz+tXuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCtlM3sOvQh6XlPMlXJrYH6IoenL4bbNolSp9gyjQ0o7qJLB3TD4xBbw8Vy/hpPmJl0tG9wmptgbdxVbszIGdzXVoq2hB4uGBdrySzNVI1r630sKtpJH+SqznZU9mzfWriq9vdm9LLx4oIPPPagy9Ih4rEGb+anuIgDDdFdBYZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4R9k7vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4R9k7vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A145C43390;
	Wed, 31 Jan 2024 18:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706725739;
	bh=S8Y3/RbLzU/uJ/TIQnn4Jhqnr9PlUTawUzkHdz+tXuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l4R9k7vf8zTWuA4pi2vmBFj6mEYD63WaCnSiPGz9DkD+tBQM9zoByjMFsLDymHliJ
	 /mFcpqCZDFor7t9Cps4QvKHlvlJ93bqGnVNySjAMKefejhkq1fVmUxW9A1BGrx0oaC
	 VUMFhkBPqATH3XWYfZ7MO0b1bc3vEemkpWCyU6+301recKLc7d55ylV4EWIDcwf9Th
	 1q4+XpxRe+lRCeUbn9KL6ScRr5CPhJXpLoNY+dKkCOaUSSWa4W92CJE2UlWw0o6nQX
	 g7aqcQtr85hWgmAf5Yymf4esojzIqxxb4Ug77yOW5aHd/idSF4x9Hs69L7Iyny8uO5
	 cewZbJ7zfC5fQ==
Date: Wed, 31 Jan 2024 10:28:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, fstests@vger.kernel.org,
	zlang@redhat.com, Dave Chinner <david@fromorbit.com>,
	mcgrof@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
Message-ID: <20240131182858.GG6188@frogsfrogsfrogs>
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
 <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
 <20240130195602.GJ1371843@frogsfrogsfrogs>
 <6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>
 <20240131034851.GF6188@frogsfrogsfrogs>
 <yhuvl7u466fc6zznulfirtg35m7fteutzhar2dhunrxleterym@3qxydiupxnsx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yhuvl7u466fc6zznulfirtg35m7fteutzhar2dhunrxleterym@3qxydiupxnsx>

On Wed, Jan 31, 2024 at 03:05:48PM +0100, Pankaj Raghav (Samsung) wrote:
> > > 
> > > Thanks for the reply. So we can have a small `if` conditional block for xfs
> > > to have fs size = 500M in generic test cases.
> > 
> > I'd suggest creating a helper where you pass in the fs size you want and
> > it rounds that up to the minimum value.  That would then get passed to
> > _scratch_mkfs_sized or _scsi_debug_get_dev.
> > 
> > (testing this as we speak...)
> 
> I would be more than happy if you send a patch for
> this but I also know you are pretty busy, so let me know if you want me
> to send a patch for this issue.
> 
> You had something like this in mind?

Close, but something more like below.  It's not exhaustive; it merely
makes the xfs 64k bs tests pass:

From: Darrick J. Wong <djwong@kernel.org>
Subject: [PATCH] misc: fix test that fail formatting with 64k blocksize

There's a bunch of tests that fail the formatting step when the test run
is configured to use XFS with a 64k blocksize.  This happens because XFS
doesn't really support that combination due to minimum log size
constraints.  Fix the test to format larger devices in that case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   29 +++++++++++++++++++++++++++++
 tests/generic/042 |    9 +--------
 tests/generic/081 |    7 +++++--
 tests/generic/108 |    6 ++++--
 tests/generic/704 |    3 ++-
 tests/generic/730 |    3 ++-
 tests/generic/731 |    3 ++-
 tests/xfs/279     |    7 ++++---
 8 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/common/rc b/common/rc
index 29bb90ca4d..953aad85ae 100644
--- a/common/rc
+++ b/common/rc
@@ -940,6 +940,35 @@ _check_minimal_fs_size()
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
+		# xfs no longer supports filesystems smaller than 512m
+		fs_min_size=512
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
index 5116183f79..63a46d6b2b 100755
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
index 22ac94de53..0996f221d3 100755
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
index efe66ba57f..07703fc8f1 100755
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
diff --git a/tests/generic/704 b/tests/generic/704
index c0142a6051..6cc4bb4af0 100755
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
index 11308cdaa1..988c47e18e 100755
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
index e1400d062c..b279e3f7b4 100755
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
 
diff --git a/tests/xfs/279 b/tests/xfs/279
index 835d187f51..9f366d1e75 100755
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
