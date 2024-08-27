Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97154846F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 02:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724724970; cv=none; b=Py0xYC1z8H80Kzo414rGCSJFmvXLh95G32WGh6Xo2an+04xd7lI48xIG2qHATUfGj2NgnLOq0JJSvZi4Y1q4iMDZk1scCZIc8ylM3ga5czKLKBlbOw59TLo4Hk0MJF+VIQyXo8QHbQPHfvD2+tmMLU6YEj+aLptfUlz5vRnhMhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724724970; c=relaxed/simple;
	bh=XadlZXQteSeZGPDBrqQUxUccn5RK1lQGAsuUKpLLuM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/ZRiyQh6S4kPlpFYayIMhI/57W+qoS5bUiRo/Chyfinj6Sjt3g2uwDT6wka4aBYcgcyuMlNbilAcV1RGGqetefiXCnBKJ0U5Kb1YcyvtoZ2OpB9COFwr2gRhdg26AfucblHBKWqyyvtw96zVWX9uW9sakBPY+7WRZkKqYsEyjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGKWZfDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGKWZfDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEF9C4E68F;
	Tue, 27 Aug 2024 02:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724724970;
	bh=XadlZXQteSeZGPDBrqQUxUccn5RK1lQGAsuUKpLLuM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LGKWZfDhFzv73VRPlD4HrLj+1bts3LSPfkZnjl3tG0rUU+ZxxEATtS1IQWMgf0Hxy
	 7FSX+i/yVC4FUUzfzOpq2B8y7b8ksn+rkp2T3bkxwkOOOvQSiAADtB6LwKPQ1WPmS8
	 AdrQ64reILE8yWuIhlHpl3IU6hePEgnU7+/ofqpSyPeedE549fnIqYFjI4eh8ZkrzU
	 qdmu5qxfTMPsJ00cRD4ljyGXmw8dx6de5uX8Wp+qUwfjW+oxu85TTqOtGOPxuCkL+B
	 jAQTCoDF+nFm42q/XhDtr+XF+GXElgF2DUFyHHbVyCxgaScPUXdL59pax6jm0VleJZ
	 NCCCPiV8b2Enw==
Date: Mon, 26 Aug 2024 19:16:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
Message-ID: <20240827021609.GG6082@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
 <ZswLBVOUvwhJZInN@dread.disaster.area>
 <20240826194028.GE865349@frogsfrogsfrogs>
 <Zs0yT0T8fnzQgDI3@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs0yT0T8fnzQgDI3@dread.disaster.area>

On Tue, Aug 27, 2024 at 11:56:31AM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2024 at 12:40:28PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 26, 2024 at 02:56:37PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 22, 2024 at 05:26:38PM -0700, Darrick J. Wong wrote:
> > > > From: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Make the allocator rtgroup aware by either picking a specific group if
> > > > there is a hint, or loop over all groups otherwise.  A simple rotor is
> > > > provided to pick the placement for initial allocations.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_bmap.c     |   13 +++++-
> > > >  fs/xfs/libxfs/xfs_rtbitmap.c |    6 ++-
> > > >  fs/xfs/xfs_mount.h           |    1 
> > > >  fs/xfs/xfs_rtalloc.c         |   98 ++++++++++++++++++++++++++++++++++++++----
> > > >  4 files changed, 105 insertions(+), 13 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index 126a0d253654a..88c62e1158ac7 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -3151,8 +3151,17 @@ xfs_bmap_adjacent_valid(
> > > >  	struct xfs_mount	*mp = ap->ip->i_mount;
> > > >  
> > > >  	if (XFS_IS_REALTIME_INODE(ap->ip) &&
> > > > -	    (ap->datatype & XFS_ALLOC_USERDATA))
> > > > -		return x < mp->m_sb.sb_rblocks;
> > > > +	    (ap->datatype & XFS_ALLOC_USERDATA)) {
> > > > +		if (x >= mp->m_sb.sb_rblocks)
> > > > +			return false;
> > > > +		if (!xfs_has_rtgroups(mp))
> > > > +			return true;
> > > > +
> > > > +		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
> > > > +			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
> > > > +			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;
> > > 
> > > WHy do we need the xfs_has_rtgroups() check here? The new rtg logic will
> > > return true for an old school rt device here, right?
> > 
> > The incore sb_rgextents is zero on !rtg filesystems, so we need the
> > xfs_has_rtgroups.
> 
> Hmmm. Could we initialise it in memory only for !rtg filesystems,
> and make sure we never write it back via a check in the
> xfs_sb_to_disk() formatter function?

Only if the incore sb_rgextents becomes u64, which will then cause the
incore and ondisk superblock structures not to match anymore.  There's
probably not much reason to keep them the same anymore.  That said, up
until recently the metadir patchset actually broke the two apart, but
then hch and I put things back to reduce our own confusion.

> That would remove one of the problematic in-memory differences
> between old skool rtdev setups and the new rtg-based setups...
> 
> > > > @@ -1835,9 +1908,16 @@ xfs_bmap_rtalloc(
> > > >  	if (xfs_bmap_adjacent(ap))
> > > >  		bno_hint = ap->blkno;
> > > >  
> > > > -	error = xfs_rtallocate(ap->tp, bno_hint, raminlen, ralen, prod,
> > > > -			ap->wasdel, initial_user_data, &rtlocked,
> > > > -			&ap->blkno, &ap->length);
> > > > +	if (xfs_has_rtgroups(ap->ip->i_mount)) {
> > > > +		error = xfs_rtallocate_rtgs(ap->tp, bno_hint, raminlen, ralen,
> > > > +				prod, ap->wasdel, initial_user_data,
> > > > +				&ap->blkno, &ap->length);
> > > > +	} else {
> > > > +		error = xfs_rtallocate_rtg(ap->tp, 0, bno_hint, raminlen, ralen,
> > > > +				prod, ap->wasdel, initial_user_data,
> > > > +				&rtlocked, &ap->blkno, &ap->length);
> > > > +	}
> > > 
> > > The xfs_has_rtgroups() check is unnecessary.  The iterator in
> > > xfs_rtallocate_rtgs() will do the right thing for the
> > > !xfs_has_rtgroups() case - it'll set start_rgno = 0 and break out
> > > after a single call to xfs_rtallocate_rtg() with rgno = 0.
> > > 
> > > Another thing that probably should be done here is push all the
> > > constant value calculations a couple of functions down the stack to
> > > where they are used. Then we only need to pass two parameters down
> > > through the rg iterator here, not 11...
> > 
> > ..and pass the ap itself too, to remove three of the parameters?
> 
> Yeah, I was thinking that the iterator only needs the bno_hint
> to determine which group to start iterating. Everything else is
> derived from information in the ap structure and so doesn't need to
> be calculated above the iterator.
> 
> Though we could just lift the xfs_rtalloc_args() up to this level
> and stuff all the parameters into that structure and pass it down
> instead (like we do with xfs_alloc_args for the btree allocator).
> Then we only need to pass args through xfs_rtallocate(),
> xfs_rtallocate_extent_near/size() and all the other helper
> functions, too.
> 
> That's a much bigger sort of cleanup, though, but I think it would
> be worth doing a some point because it would bring the rtalloc code
> closer to how the btalloc code is structured. And, perhaps, allow us
> to potentially share group selection and iteration code between
> the bt and rt allocators in future...

Well we're already tearing the rt allocator to pieces and rebuilding it,
so why not...

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
