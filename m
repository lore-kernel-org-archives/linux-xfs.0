Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A3B22577E;
	Tue,  8 Apr 2025 18:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744136160; cv=none; b=Ce7mLlNmrytYXGokmZNadx+abMXL1uSe4eg47GQwEb8ZSY38ULVXRE3Pigz91JcAOQ4FLEGFCuncuTkXxTPCjOcbm2w4K2eEYlOE305WtU9vOJA1b2J9KDHX4tBvsolWZiSm9FZ0m5oiZM8J52vRBDrJBkDCTLzaa2/QQ8Zhz6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744136160; c=relaxed/simple;
	bh=XiYWEi+CNGCwe5Nx/McyHZRDZFii1nktHnXquQTuPtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7rsSjnvoXhq/Axm3xwrRlxaZCO3Wmy1LpShWBX+pEFrpmYYjdLayQhBDKSmvB6/sRQXaknHfxmD8+JjDUMAFaKIclUoCRsr5wHpO9YW0JTAHFSRA6z9fKptXFwDveFG2rTspSCtNNitxCyBUirrAi6rnVRfDR1St5HESXGYMhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJXOIcWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJXOIcWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF85CC4CEE5;
	Tue,  8 Apr 2025 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744136159;
	bh=XiYWEi+CNGCwe5Nx/McyHZRDZFii1nktHnXquQTuPtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LJXOIcWBk/pVBFALpn3eRbcHms4hDEqY9TFl3cpMf4D+vJrcPG1z5+966bovWzntK
	 PToB8J4ur3gGrrSJKLYH+YWxc3RPyWk/+RT2NUmPvjs/WKQ8515W5cZzOENm/Umc9w
	 m+AY26D0qZjd/LD+HzFO2alN+VjjJW43gB6U2YzcSUU1L2xrdzyS5lCcZkdx0yUydX
	 lfw5cuBtAodnTvmd3ae67LzKp2yHNV0nru54C1tpD2txBp95O8REcLb0SkNke5POd/
	 0EylQSQG7yNgbKMfaPTL5K3NmhzMCTaAr3ibKAFSEHTMGEmZY/t19ytbYvpRVkWXjE
	 AS2J66iWIeU4g==
Date: Tue, 8 Apr 2025 11:15:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v4] generic: add a test for atomic writes
Message-ID: <20250408181559.GG6274@frogsfrogsfrogs>
References: <20250408075933.32541-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408075933.32541-1-catherine.hoang@oracle.com>

On Tue, Apr 08, 2025 at 12:59:33AM -0700, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  common/rc             |  51 +++++++++++++
>  tests/generic/765     | 172 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/765.out |   2 +
>  3 files changed, 225 insertions(+)
>  create mode 100755 tests/generic/765
>  create mode 100644 tests/generic/765.out
> 
> diff --git a/common/rc b/common/rc
> index 16d627e1..25e6a1f7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2996,6 +2996,10 @@ _require_xfs_io_command()
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
> @@ -5443,6 +5447,53 @@ _require_scratch_btime()
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
> diff --git a/tests/generic/765 b/tests/generic/765
> new file mode 100755
> index 00000000..f54f2e2e
> --- /dev/null
> +++ b/tests/generic/765
> @@ -0,0 +1,172 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 765
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_require_scratch_write_atomic
> +_require_xfs_io_command pwrite -A
> +
> +check_supported_bsize()
> +{
> +    local bsize=$1
> +
> +    case "$FSTYP" in
> +    "xfs")
> +        min_bsize=1024
> +        knob="/sys/kernel/mm/transparent_hugepage/shmem_enabled"
> +        test -w "$knob" && max_bsize=65536 || max_bsize=4096

What if the bsae page size is 64k and THP are not enabled?  This
detection will not result in max_bsize=65536.

Regrettably I think the only way to find out for sure is to format in a
loop:

	for ((i = 65536; i >= 1024; i /= 2)); do
		mkfs.xfs -b size=$i... || continue
		if mount...; then
			max_bsize=$i
			umount
			break;
		fi
	done

> +        mkfs_opts="-b size=$bsize"
> +        ;;
> +    "ext4")
> +        min_bsize=1024
> +        max_bsize=4096
> +        mkfs_opts="-b $bsize"
> +        ;;
> +    *)
> +        _notrun "$FSTYP does not support atomic writes"
> +        ;;
> +    esac
> +
> +    if [ "$bsize" -lt "$min_bsize" ] || [ "$bsize" -gt "$max_bsize" ]; then
> +        return 1
> +    fi
> +
> +    return 0
> +}
> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    if ! check_supported_bsize $bsize; then
> +        return
> +    fi
> +
> +    _scratch_mkfs $mkfs_opts >> $seqres.full
> +    _scratch_mount
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

_cp_reflink from common/rc

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
> +    if ! check_supported_bsize $bsize; then
> +        return
> +    fi
> +
> +    _scratch_mkfs $mkfs_opts >> $seqres.full
> +    _scratch_mount
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

Aren't these the block device min/max untorn write units?

> +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)

And aren't these the filesystem min/max untorn write units?  Shouldn't
the names be switched?

bdev_awu_min=$(cat /sys/block...)
file_awu_min=$(_get_atomic_write_unit_min...)

--D

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
> diff --git a/tests/generic/765.out b/tests/generic/765.out
> new file mode 100644
> index 00000000..39c254ae
> --- /dev/null
> +++ b/tests/generic/765.out
> @@ -0,0 +1,2 @@
> +QA output created by 765
> +Silence is golden
> -- 
> 2.34.1
> 
> 
