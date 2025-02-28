Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9FA125B2;
	Fri, 28 Feb 2025 02:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708717; cv=none; b=C4nhgBv1+DF4tM6KWLSj5HDFngHrpEVUa+cuXXQS1w2z226G9AOtKV7WK9jICYsAzOB5SFUZ1OPnNQiislGjz0BBT1cxEloxCdCYx7joIhfTPltFFnDjTbhLXMFgjfa0UONfrXjD6vtIsFdirbdSDZc2FtxubkFOjmc130XqyH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708717; c=relaxed/simple;
	bh=76AGr2z6n321IZ4sfC5rWg+TOLN3SmiH6uQ6lliBlOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPn0lOJPiNvlC45IxJ46nk6yDLQoNg4qlQi1au4EnYxIZrQ2P/h5aT43PpNsJk5LM7dKLzj+P6rfVjpBa+CbhPlYILZHPL8qjxNuQ9ofTOYpRK5TGlmUTnDgwX2oRAbcZ1p2y8XGbMtlLynN0/qz4CERKkNrnfJfg6azzPI9Yro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrNSNaEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrNSNaEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CF2C4CEDD;
	Fri, 28 Feb 2025 02:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740708717;
	bh=76AGr2z6n321IZ4sfC5rWg+TOLN3SmiH6uQ6lliBlOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lrNSNaEw6CPfOlWrUv/XqYPBSfwl7JrkmsFNlhPlWwasMmR+q/MCXBAnZsSCDqjUN
	 HmoTu9NDt8BrOTDpK81WVjU3KIqtFsaqcL6FrFXVAqZIapwDTtLuwcxsGoQIlve5gr
	 pTgwtgx4p0MYF75yagL5NTCyyljYJiGc7yROyJ32NjWOifDXMsBSXo3/WyfRe9eg2m
	 ecDfYpMY2P42hVkIbzI5J0b0ReWLcdbSQYsW64l4FGCuFr/+5CS0T/zx3smgGO7lv+
	 e7TvR8DayzajiyOLGWYO77Ab2aBrhowbhhRLbDtSog3edmEDQii+YPNp0GerXghEpS
	 MWFZI+du4cpLw==
Date: Thu, 27 Feb 2025 18:11:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
Message-ID: <20250228021156.GX6242@frogsfrogsfrogs>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228002059.16750-1-catherine.hoang@oracle.com>

On Thu, Feb 27, 2025 at 04:20:59PM -0800, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Er.... what git tree is this based upon?  generic/762 is a project quota
test.

--D

> ---
>  common/rc             |  51 ++++++++++++++
>  tests/generic/762     | 160 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/762.out |   2 +
>  3 files changed, 213 insertions(+)
>  create mode 100755 tests/generic/762
>  create mode 100644 tests/generic/762.out
> 
> diff --git a/common/rc b/common/rc
> index 6592c835..08a9d9b8 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2837,6 +2837,10 @@ _require_xfs_io_command()
>  			opts+=" -d"
>  			pwrite_opts+="-V 1 -b 4k"
>  		fi
> +		if [ "$param" == "-A" ]; then
> +			opts+=" -d"
> +			pwrite_opts+="-D -V 1 -b 4k"
> +		fi
>  		testio=`$XFS_IO_PROG -f $opts -c \
>  		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
>  		param_checked="$pwrite_opts $param"
> @@ -5175,6 +5179,53 @@ _require_scratch_btime()
>  	_scratch_unmount
>  }
>  
> +_get_atomic_write_unit_min()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep atomic_write_unit_min | grep -o '[0-9]\+'
> +}
> +
> +_get_atomic_write_unit_max()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep atomic_write_unit_max | grep -o '[0-9]\+'
> +}
> +
> +_get_atomic_write_segments_max()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep atomic_write_segments_max | grep -o '[0-9]\+'
> +}
> +
> +_require_scratch_write_atomic()
> +{
> +	_require_scratch
> +
> +	export STATX_WRITE_ATOMIC=0x10000
> +
> +	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> +
> +	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
> +		_notrun "write atomic not supported by this block device"
> +	fi
> +
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	touch $testfile
> +
> +	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> +	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> +
> +	_scratch_unmount
> +
> +	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
> +		_notrun "write atomic not supported by this filesystem"
> +	fi
> +}
> +
>  _require_inode_limits()
>  {
>  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> diff --git a/tests/generic/762 b/tests/generic/762
> new file mode 100755
> index 00000000..d0a80219
> --- /dev/null
> +++ b/tests/generic/762
> @@ -0,0 +1,160 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 762
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_require_scratch_write_atomic
> +_require_xfs_io_command pwrite -A
> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    case "$FSTYP" in
> +    "xfs")
> +        mkfs_opts="-b size=$bsize"
> +        ;;
> +    "ext4")
> +        mkfs_opts="-b $bsize"
> +        ;;
> +    *)
> +        ;;
> +    esac
> +
> +    # If block size is not supported, skip this test
> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> +    _try_scratch_mount >>$seqres.full 2>&1 || return
> +
> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> +
> +    # Check that atomic min/max = FS block size
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write min $file_min_write, should be fs block size $bsize"
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write max $file_max_write, should be fs block size $bsize"
> +    test $file_max_segments -eq 1 || \
> +        echo "atomic write max segments $file_max_segments, should be 1"
> +
> +    # Check that we can perform an atomic write of len = FS block size
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> +
> +    # Check that we can perform an atomic single-block cow write
> +    if [ "$FSTYP" == "xfs" ]; then
> +        testfile_cp=$SCRATCH_MNT/testfile_copy
> +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> +            cp --reflink $testfile $testfile_cp
> +        fi
> +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
> +            grep wrote | awk -F'[/ ]' '{print $2}')
> +        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
> +    fi
> +
> +    # Check that we can perform an atomic write on an unwritten block
> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> +
> +    # Check that we can perform an atomic write on a sparse hole
> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
> +
> +    # Check that we can perform an atomic write on a fully mapped block
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
> +
> +    # Reject atomic write if len is out of bounds
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize - 1)) should fail"
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize + 1)) should fail"
> +
> +    # Reject atomic write when iovecs > 1
> +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write only supports iovec count of 1"
> +
> +    # Reject atomic write when not using direct I/O
> +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write requires direct I/O"
> +
> +    # Reject atomic write when offset % bsize != 0
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write requires offset to be aligned to bsize"
> +
> +    _scratch_unmount
> +}
> +
> +test_atomic_write_bounds()
> +{
> +    local bsize=$1
> +
> +    case "$FSTYP" in
> +    "xfs")
> +        mkfs_opts="-b size=$bsize"
> +        ;;
> +    "ext4")
> +        mkfs_opts="-b $bsize"
> +        ;;
> +    *)
> +        ;;
> +    esac
> +
> +    # If block size is not supported, skip this test
> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> +    _try_scratch_mount >>$seqres.full 2>&1 || return
> +
> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write should fail when bsize is out of bounds"
> +
> +    _scratch_unmount
> +}
> +
> +sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> +sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> +
> +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> +
> +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> +    echo "bdev min write != sys min write"
> +fi
> +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> +    echo "bdev max write != sys max write"
> +fi
> +
> +# Test all supported block sizes between bdev min and max
> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> +        test_atomic_writes $bsize
> +done;
> +
> +# Check that atomic write fails if bsize < bdev min or bsize > bdev max
> +test_atomic_write_bounds $((bdev_min_write / 2))
> +test_atomic_write_bounds $((bdev_max_write * 2))
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/762.out b/tests/generic/762.out
> new file mode 100644
> index 00000000..fbaeb297
> --- /dev/null
> +++ b/tests/generic/762.out
> @@ -0,0 +1,2 @@
> +QA output created by 762
> +Silence is golden
> -- 
> 2.34.1
> 
> 
