Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9890C1898EA
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 23:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045410; cv=none; b=rBuM+zhb+6ezfQtJicLfGM4m+LIYqygE7JoKbfjNqcSNAnad2FaMoy1df+6oNmhpbuOuM/DOjKZF6DeuGIGaNwSvArd68jbS4J21JCKFJw7oAM3USx3oyBW0oE99dIcHdYCe2sNDnaCDPnKqB4UDNnj1LxUxMREPz8BflPkWI2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045410; c=relaxed/simple;
	bh=cfUhLjTe+OoHCX80zmSBbqvQ3YiK6EFE/iLqpJUHLxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKLGQCrKWBpxf3CgDXTnzGp7PtOvmCtTWNLP6L6olRSlCSeafBkS8gy94yVnE3yS6bwTI1517OoqHR3hZGUo48rudbzyWyvV6TCiChNKvH2sx+3rjQ2aFqNW0F2H/+/zYzFHKdybiU/KC6QGSakezAelVF9Gj14Ri+iN0vxd5c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2tMimd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2tMimd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F01EC4CECE;
	Thu, 12 Dec 2024 23:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734045410;
	bh=cfUhLjTe+OoHCX80zmSBbqvQ3YiK6EFE/iLqpJUHLxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U2tMimd/yHa+2aaND7ZADbaUHy6jcLE12iDWTPMrLKqg08rK84dy8pSWiwTbpersV
	 HNR7n3ynJcQ2Vzoczw7pOYu2MuhUHjgoKpo3GNJrf+QzTwUV1oiYnO49XqScyAvfp+
	 qy9s8k3Ogsh8Ay7thbfCIiKtkbI7a+h92+oZYZXkOAu4/zJmWh6iWu7AN3e1QDD7LY
	 CZsCvsgpjOGfPP+TuRZ56AfMgkVH/aFdVbiy+T/MLSXOhhAx5wSF0xzxOX3KEIiysw
	 19u/I0+bd2PYBDhIwGjJE2XXhlj3fRsF3L+SfGLP8rrp/rqqw7Ttozvbc+AaGJMn/z
	 k6ZpwfT08IM0g==
Date: Thu, 12 Dec 2024 15:16:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs: add a test for atomic writes
Message-ID: <20241212231649.GI6678@frogsfrogsfrogs>
References: <20241212230123.36325-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212230123.36325-1-catherine.hoang@oracle.com>

On Thu, Dec 12, 2024 at 03:01:23PM -0800, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/rc         | 14 ++++++++++++++
>  tests/xfs/611     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/611.out | 17 +++++++++++++++++
>  3 files changed, 79 insertions(+)
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
> index 00000000..d193de86
> --- /dev/null
> +++ b/tests/xfs/611
> @@ -0,0 +1,48 @@
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
> +
> +test_atomic_writes()
> +{
> +    bsize=$1

local bsize=$1

(don't pollute the global namespace)

> +
> +    echo ""
> +    echo "Block size: $bsize"
> +
> +    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
> +    _scratch_mount

You probably want:
_xfs_force_bdev data $SCRATCH_MNT

to force the data/rt status of $testfile to match whichever block device
supports untorn writes.

> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    # Check that atomic min/max = FS block size
> +    $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile \
> +        | grep atomic
> +
> +    # Check that we can perform an atomic write of len = FS block size
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | grep wrote
> +
> +    # Reject atomic write if len is out of bounds
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile

Can you also check that untorn writes to an unwritten block and a sparse
hole also work?

> +    _scratch_unmount
> +}
> +
> +test_atomic_writes 4096
> +test_atomic_writes 16384

Shouldn't this be testing every fsblock size between the untorn write
unit min and max of the underlying block device?

--D

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/611.out b/tests/xfs/611.out
> new file mode 100644
> index 00000000..ea28b971
> --- /dev/null
> +++ b/tests/xfs/611.out
> @@ -0,0 +1,17 @@
> +QA output created by 611
> +
> +Block size: 4096
> +stat.atomic_write_unit_min = 4096
> +stat.atomic_write_unit_max = 4096
> +stat.atomic_write_segments_max = 1
> +wrote 4096/4096 bytes at offset 0
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +
> +Block size: 16384
> +stat.atomic_write_unit_min = 16384
> +stat.atomic_write_unit_max = 16384
> +stat.atomic_write_segments_max = 1
> +wrote 16384/16384 bytes at offset 0
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> -- 
> 2.34.1
> 
> 
