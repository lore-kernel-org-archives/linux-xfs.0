Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39EA1AA1D9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629570; cv=none; b=Re3ZZAFyU4nZTJNqvXLJghyjY9K0/LtTXGllJp2EHsjjJ5xdiLrnabQXPJjXmw+lqEZAPPuZYLLpNwhNfq5xP6UAH8K8jlZu8PzRIvFGGqfKx0pyFO6tpcH37S18wp7e1ndqD3SRxa/wCguqFWp9nS196P1tLWQYxOEclAuXjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629570; c=relaxed/simple;
	bh=vfXfYKFq84+BWcuT/KVqY6s0q602kabkpX0hSA/giGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdNAaXWhJapEdKz0/aYmif71cmMn9RZ/d1QDLuKMrIHcyagRTPxo9Bq6mNvG4HC02tqF6p1YOGPvHDVKYpsKVz29hN3y0psOo8oVUuc+wN3U+nQWdRuqbORRe9aYDOFN1uLzdEu3W/95PZp9BEXVYd3fJP0DTcdG4LPRr5tMaHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmUd/hoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmUd/hoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE53C4CED0;
	Thu, 19 Dec 2024 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629570;
	bh=vfXfYKFq84+BWcuT/KVqY6s0q602kabkpX0hSA/giGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KmUd/hoX9hXWvHhqmmMsmJhwaAPCiaEW7dbjvXINDijDlFrXHQYWve2qtR117n8ny
	 71MsfykIJfh5zEx8D8YUAdFnCc4X7JITWymP/TEzm47NC0Sd4vpn/ZSKU45hqVD1e9
	 i8kSz1+NlEflHywex6JuY031GyQJa8TxCKQBnCaShUT97gh4tBb+7NXPfQ0rCYJbzL
	 TchcWOILaVY1A4k8h3MFbOV9Bl3Nv23Xh+ZQQ9hNuNI81oFv0zXcyl0XN6iYDK7mKe
	 aCYpF4edtn86hMM+7M4E0564u7TvoHLRn3TvCyb9NbFUKZsJhKK4k6mpAsIuw7g+Kb
	 agGr6i3SDDRVA==
Date: Thu, 19 Dec 2024 09:32:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for atomic writes
Message-ID: <20241219173248.GK6174@frogsfrogsfrogs>
References: <20241217020828.28976-1-catherine.hoang@oracle.com>
 <51981220-c246-421b-90b3-0b467a91c5cc@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51981220-c246-421b-90b3-0b467a91c5cc@oracle.com>

On Thu, Dec 19, 2024 at 10:48:28AM +0000, John Garry wrote:
> On 17/12/2024 02:08, Catherine Hoang wrote:
> > Add a test to validate the new atomic writes feature.
> 
> Generally this look ok, just a couple of comments/questions, below.
> 
> Thanks,
> John
> 
> > 
> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > ---
> >   common/rc         | 14 ++++++++
> >   tests/xfs/611     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
> >   tests/xfs/611.out |  2 ++
> >   3 files changed, 97 insertions(+)
> >   create mode 100755 tests/xfs/611
> >   create mode 100644 tests/xfs/611.out
> > 
> > diff --git a/common/rc b/common/rc
> > index 2ee46e51..b9da749e 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -5148,6 +5148,20 @@ _require_scratch_btime()
> >   	_scratch_unmount
> >   }
> > +_require_scratch_write_atomic()
> > +{
> > +	_require_scratch
> > +	_scratch_mkfs > /dev/null 2>&1
> > +	_scratch_mount
> > +
> > +	export STATX_WRITE_ATOMIC=0x10000
> > +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT \
> > +		| grep atomic >>$seqres.full 2>&1 || \
> > +		_notrun "write atomic not supported by this filesystem"
> > +
> > +	_scratch_unmount
> > +}
> > +
> >   _require_inode_limits()
> >   {
> >   	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> > diff --git a/tests/xfs/611 b/tests/xfs/611
> > new file mode 100755
> > index 00000000..a26ec143
> > --- /dev/null
> > +++ b/tests/xfs/611
> > @@ -0,0 +1,81 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 611
> > +#
> > +# Validate atomic write support
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_scratch_write_atomic
> > +
> > +test_atomic_writes()
> > +{
> > +    local bsize=$1
> > +
> > +    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
> 
> bsize (bdev max) can be upto 0.5M - are we really possibly testing FS
> blocksize == 0.5M?

No, but I suppose the for loop at the bottom should stop at 64k.

> Apart from that, it would be nice if we fixed FS blocksize at 4K or 64K, and
> fed bdev min/max and ensured that we can only support atomic writes for bdev
> min <= fs blocksize <= bdev max. But maybe what you are doing is ok.
> 
> > +    _scratch_mount
> > +    _xfs_force_bdev data $SCRATCH_MNT
> > +
> > +    testfile=$SCRATCH_MNT/testfile
> > +    touch $testfile
> > +
> > +    file_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> > +        grep atomic_write_unit_min | cut -d ' ' -f 3)
> > +    file_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> > +        grep atomic_write_unit_max | cut -d ' ' -f 3)
> > +    file_max_segments=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> > +        grep atomic_write_segments_max | cut -d ' ' -f 3)
> > +
> > +    # Check that atomic min/max = FS block size
> 
> Hopefully we can have max > FS block size soon, but I am not sure how ....
> so it's hard to consider now how the test could be expanded to cover that.

Yeah, this test will need revision whenever we manage to finishing
running this marathon and get the next phase merged.  Until then,
let's at least test the existing functionality. :/

--D

> > +    test $file_min_write -eq $bsize || \
> > +        echo "atomic write min $file_min_write, should be fs block size $bsize"
> > +    test $file_min_write -eq $bsize || \
> > +        echo "atomic write max $file_max_write, should be fs block size $bsize"
> > +    test $file_max_segments -eq 1 || \
> > +        echo "atomic write max segments $file_max_segments, should be 1"
> > +
> > +    # Check that we can perform an atomic write of len = FS block size
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> > +
> > +    # Check that we can perform an atomic write on an unwritten block
> > +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D $bsize $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> > +
> > +    # Check that we can perform an atomic write on a sparse hole
> > +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
> > +
> > +    # Reject atomic write if len is out of bounds
> > +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> > +        echo "atomic write len=$((bsize - 1)) should fail"
> > +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> > +        echo "atomic write len=$((bsize + 1)) should fail"
> > +
> > +    _scratch_unmount
> > +}
> > +
> > +bdev_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
> > +    grep atomic_write_unit_min | cut -d ' ' -f 3)
> > +bdev_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV | \
> > +    grep atomic_write_unit_max | cut -d ' ' -f 3)
> > +
> > +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> > +    _scratch_mkfs_xfs_supported -b size=$bsize >> $seqres.full 2>&1 && \
> > +        test_atomic_writes $bsize
> > +done;
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/611.out b/tests/xfs/611.out
> > new file mode 100644
> > index 00000000..b8a44164
> > --- /dev/null
> > +++ b/tests/xfs/611.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 611
> > +Silence is golden
> 
> 
