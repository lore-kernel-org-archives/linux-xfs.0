Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348EA1E4BE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 00:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734568908; cv=none; b=ToDgSI/019S59KZWHm6U6yz5L/UQzJbo36WyjKJ/oM7YKCpSu5YcH2sgKIKQTai/BzC4XFMxwvtiHxviIoQnbxViujI5dRHbMcGLz8rEsKbQIpqqcgSDytIFYJD1nPrqV7lUPqCQdYhQUL1BJnJbAcoimcH8W2SyxUKk74galRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734568908; c=relaxed/simple;
	bh=U+sM5eStgYyN0AlYBKyP9AJTQwD1wAwVE1uFNJ+Wn+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJ8EH2cqdm++PZJzJIrUiqs8DsqkgcvW8TMJwzez4LZPjQnZ+oqVJpYQ0eRZ5wmNlr9rrqOW/RFc4BEdqXMJ2OCtxVwxkS0q8sd5dzCqc9nCiyZJ/GQUeFtBp1CR5Q3XOPfpJsx5JqeaSLQr1PkPJEO6Vk8KGVDcYB1vfrzm/+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFoTK9+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFoTK9+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDFEC4CED4;
	Thu, 19 Dec 2024 00:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734568907;
	bh=U+sM5eStgYyN0AlYBKyP9AJTQwD1wAwVE1uFNJ+Wn+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dFoTK9+X8POj0O2Q36oW7MupS+61A1MVmuZPVfrMOgUW7peQ6OzQ3RzRt0lb7of21
	 wtyX32oboL0UV4fmd5iXNc+H7l0LD5V5vIx7MpmJjHeCb5G+YevkPGvv2ZyWpnLlMx
	 2Ek+TIHLjyMJeAidrR0cdfm5Ioh3WMiPdIbQJ38Pa0TdoA5Mncatawxi8WcfVRsjBv
	 orahv17T0g8FzKTJNdY6Htta2OKi+Ttft43BDpN1u4LAmIsFB6lP9HzoBujwZbrTwT
	 UixkrNDJ3ZRvYUAhbEq24ZDhs8gGAYfJjbl+c+0ja/JCsb/P6R9miz3grguJpG6Fd7
	 z+eV7eZ+GKdFA==
Date: Wed, 18 Dec 2024 16:41:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for atomic writes
Message-ID: <20241219004147.GE6174@frogsfrogsfrogs>
References: <20241217020828.28976-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217020828.28976-1-catherine.hoang@oracle.com>

On Mon, Dec 16, 2024 at 06:08:28PM -0800, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/rc         | 14 ++++++++
>  tests/xfs/611     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/611.out |  2 ++
>  3 files changed, 97 insertions(+)
>  create mode 100755 tests/xfs/611
>  create mode 100644 tests/xfs/611.out
> 
> diff --git a/common/rc b/common/rc
> index 2ee46e51..b9da749e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5148,6 +5148,20 @@ _require_scratch_btime()
>  	_scratch_unmount
>  }
>  
> +_require_scratch_write_atomic()
> +{
> +	_require_scratch
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount
> +
> +	export STATX_WRITE_ATOMIC=0x10000
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT \
> +		| grep atomic >>$seqres.full 2>&1 || \
> +		_notrun "write atomic not supported by this filesystem"
> +
> +	_scratch_unmount
> +}
> +
>  _require_inode_limits()
>  {
>  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> diff --git a/tests/xfs/611 b/tests/xfs/611
> new file mode 100755
> index 00000000..a26ec143
> --- /dev/null
> +++ b/tests/xfs/611
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 611
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_write_atomic

You can omit the _require_scratch since _require_scratch_write_atomic
does it for you.

> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
> +    _scratch_mount
> +    _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    file_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_min | cut -d ' ' -f 3)
> +    file_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_max | cut -d ' ' -f 3)
> +    file_max_segments=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_segments_max | cut -d ' ' -f 3)
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
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"

Hmm, ok, so that's an extending write, good...

> +    # Check that we can perform an atomic write on an unwritten block
> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D $bsize $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> +
> +    # Check that we can perform an atomic write on a sparse hole
> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"

...and those check unwritten and non-mapped ranges.

Now that the the file range has been filled with a written block, should
there be a second atomic pwrite here to check that it works for a fully
mapped block?

If reflink is supported, could you also cp --reflink $testfile to make
sure that atomic single-block cow writes work?

Other than that, everything looks good.

--D

> +    # Reject atomic write if len is out of bounds
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize - 1)) should fail"
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize + 1)) should fail"
> +
> +    _scratch_unmount
> +}
> +
> +bdev_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
> +    grep atomic_write_unit_min | cut -d ' ' -f 3)
> +bdev_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
> +    grep atomic_write_unit_max | cut -d ' ' -f 3)
> +
> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> +    _scratch_mkfs_xfs_supported -b size=$bsize >> $seqres.full 2>&1 && \
> +        test_atomic_writes $bsize
> +done;
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/611.out b/tests/xfs/611.out
> new file mode 100644
> index 00000000..b8a44164
> --- /dev/null
> +++ b/tests/xfs/611.out
> @@ -0,0 +1,2 @@
> +QA output created by 611
> +Silence is golden
> -- 
> 2.34.1
> 
> 
