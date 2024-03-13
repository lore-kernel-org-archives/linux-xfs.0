Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C247773;
	Wed, 13 Mar 2024 20:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710360516; cv=none; b=EiU77nLxyK/eb3sbbx7R7GEbFAAXJtcW/CZ0kAJkLOM8rZAW1ejDuc2RIwOPaQGpdcIPg4SyA1Y4o0BcjkO0alk555buQVZpftH6nkfRGLBVlHyQVqgX1DKKTaJuh/KK1dM4gHaRyNiWchCIwpVRWbIx9w06tlrCrLUiAt7FFoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710360516; c=relaxed/simple;
	bh=xL1hMQOGd/TKt9/7TXApd7Gg4MrmHinp2oldxa79bP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+rcZXHEUlo97UX2vbdM9yZYTvf74Xczygo+nxDPT2GZGdphAfpq1hwiFdbw3B0qeMEgBnheCCLwLh77uw1KismkDGc7kulC72GNw0CEJBtHStNnRQlDg4rt3ztayLMWR82p/dLHmxNneVPUkx3xbEs/LFTJBLzm3L8QmFf4gEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2/85bii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2/85bii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F943C433F1;
	Wed, 13 Mar 2024 20:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710360515;
	bh=xL1hMQOGd/TKt9/7TXApd7Gg4MrmHinp2oldxa79bP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2/85biiBGq7ZohRHg9xO6q6rtDxW1+IZ+AfeR87wpn+JIr1f+IHBMq4QHeaBvcUM
	 2f2ff/J99hLaweuAcvoFuq9pykK1EOC8VoxQr3bL3GR3b+sVSLqUC2D4Qy9PkrqBlF
	 h0on7m5R9XvjxqNdmWkstZG0aLXJYkN5rnW2x3d85njtIXPfKOtZFfMtn9hk0MWEkN
	 Okf7Qob3RkK5YfGDyP/Z9m4ubNaRdVhGR8+1f2oAWWcOxoolz5HtuYki9diFyymzzP
	 TgQARtV1Fh5AijernEyA/hiT/pFo9/VmF+Tl4nCWkFBLVXZWHSNqQmDSVxvFS9L/u8
	 zDIp5jNh3kkHA==
Date: Wed, 13 Mar 2024 13:08:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, zlang@redhat.com,
	fstests@vger.kernel.org, mcgrof@kernel.org, gost.dev@samsung.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/558: scale blk IO size based on the filesystem
 blksz
Message-ID: <20240313200834.GP1927156@frogsfrogsfrogs>
References: <20240122111751.449762-1-kernel@pankajraghav.com>
 <20240122111751.449762-2-kernel@pankajraghav.com>
 <CGME20240122165342eucas1p2ad68d6c116aeae8673ac04d84ab54356@eucas1p2.samsung.com>
 <20240122165336.GA6226@frogsfrogsfrogs>
 <cb8a9359-6678-4692-a76c-545f8bb44b00@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb8a9359-6678-4692-a76c-545f8bb44b00@samsung.com>

On Mon, Jan 22, 2024 at 06:23:16PM +0100, Pankaj Raghav wrote:
> On 22/01/2024 17:53, Darrick J. Wong wrote:
> > On Mon, Jan 22, 2024 at 12:17:50PM +0100, Pankaj Raghav (Samsung) wrote:
> >> From: Pankaj Raghav <p.raghav@samsung.com>
> >>
> >> This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
> >> system(see LBS efforts[1]). Scale the `blksz` based on the filesystem
> > > Fails how, specifically?
> 
> I basically get this in 558.out.bad when I set filesystem block size to be 64k:
> QA output created by 558
> Expected to hear about writeback iomap invalidations?
> Silence is golden
> 
> But I do see that iomap invalidations are happening for 16k and 32k, which makes it pass
> the test for those block sizes.
> 
> My suspicion was that we don't see any invalidations because of the blksz fixed
> at 64k in the test, which will contain one FSB in the case of 64k block size.
> 
> Let me know if I am missing something.

Nope, that sounds good and fixes the problems I saw.  So:
Tested-by: Darrick J. Wong <djwong@kernel.org>

And if you add to the commit message that this test specifically fixes
the "Expected to hear about writeback iomap invalidations?" message for
64k filesystems, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> > 
> > --D
> > 
> >> block size instead of fixing it as 64k so that we do get some iomap
> >> invalidations while doing concurrent writes.
> >>
> >> Cap the blksz to be at least 64k to retain the same behaviour as before
> >> for smaller filesystem blocksizes.
> >>
> >> [1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
> >>
> >> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> >> ---
> >>  tests/xfs/558 | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tests/xfs/558 b/tests/xfs/558
> >> index 9e9b3be8..270f458c 100755
> >> --- a/tests/xfs/558
> >> +++ b/tests/xfs/558
> >> @@ -127,7 +127,12 @@ _scratch_mount >> $seqres.full
> >>  $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
> >>  _require_pagecache_access $SCRATCH_MNT
> >>  
> >> -blksz=65536
> >> +min_blksz=65536
> >> +file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
> >> +blksz=$(( 8 * $file_blksz ))
> >> +
> >> +blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
> >> +
> >>  _require_congruent_file_oplen $SCRATCH_MNT $blksz
> >>  
> >>  # Make sure we have sufficient extent size to create speculative CoW
> >> -- 
> >> 2.43.0
> >>
> 
