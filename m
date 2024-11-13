Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE83812E4A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731457485; cv=none; b=FqWaQ3Ygu27Ns6B5bYX/azJohRJ71xH/FS+wE6eOUb1zln+cNl2eehX1K78eCr7otg5xiJKfhP+shSdB9Unsw51joPwfLHEnC4FZ28640OizPrOSPfivTv5pUj18zuaYT0lfvi0miopy+A0iBmHhwKCxLpwbe86jNvTa/3qjC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731457485; c=relaxed/simple;
	bh=ncS+tAQoVvzxS7MkBP1kIrcuAn2//Em4Bt6oLPEAQwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pA21wrI6oiH0X11bCDo6VLDBO6cM+j4dEdz7rkfMO6VG07LE4c7OrXm9wQoYFoL5S8Olku6Vk2ZjgHLc1CPJK+Vt9IbzR3vVkZJzsc8z09XC5BXpMf6O+tSWnlQ8yTf0ptyM70mBFT7NHCqjW0Qj2ww52txeMlhfM1SeBwC/2hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCtVHIca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCtVHIca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD50C4CECD;
	Wed, 13 Nov 2024 00:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731457485;
	bh=ncS+tAQoVvzxS7MkBP1kIrcuAn2//Em4Bt6oLPEAQwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QCtVHIcaAe/xYX51V8gvEmPcUO0Bguj1kMLAnDPCg50KdPGy4gb2qc14ZkHF2JOvf
	 fWmSC+taq6JG6VVbf976qzuOrkEYXzntgPVQm7q/I/kebfUtfJyDrzJ1wwX76wUMMD
	 gI0geqdCjvfNtnMgJ8ISIGXnvzqstShPHS0ieOHSrZ1dpUssGf5VU8dd1Ge6ryjAAh
	 7aSfw+wBVsdHHytEB2Wxo+K4lApQ94nv3vKM/t+emMU/qETDiAX8gNqpM4SEGglElP
	 tRUtJpkzzDmO2zKKXBCIl4jg6qdglUeMCwNe5H//LOxGL2wMSTQlv06OII2MXafMiu
	 ukjNg/e8P5Kdg==
Date: Tue, 12 Nov 2024 16:24:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 1/3] xfs: fix sparse inode limits on runt AG
Message-ID: <20241113002444.GK9438@frogsfrogsfrogs>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-2-david@fromorbit.com>
 <20241112231539.GG9438@frogsfrogsfrogs>
 <ZzPu0mxbqVjplwOj@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzPu0mxbqVjplwOj@dread.disaster.area>

On Wed, Nov 13, 2024 at 11:12:02AM +1100, Dave Chinner wrote:
> On Tue, Nov 12, 2024 at 03:15:39PM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 13, 2024 at 09:05:14AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The runt AG at the end of a filesystem is almost always smaller than
> > > the mp->m_sb.sb_agblocks. Unfortunately, when setting the max_agbno
> > > limit for the inode chunk allocation, we do not take this into
> > > account. This means we can allocate a sparse inode chunk that
> > > overlaps beyond the end of an AG. When we go to allocate an inode
> > > from that sparse chunk, the irec fails validation because the
> > > agbno of the start of the irec is beyond valid limits for the runt
> > > AG.
> > > 
> > > Prevent this from happening by taking into account the size of the
> > > runt AG when allocating inode chunks. Also convert the various
> > > checks for valid inode chunk agbnos to use xfs_ag_block_count()
> > > so that they will also catch such issues in the future.
> > > 
> > > Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
> > 
> > Cc: <stable@vger.kernel.org> # v4.2
> > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ialloc.c | 16 +++++++++-------
> > >  1 file changed, 9 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > > index 271855227514..6258527315f2 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > @@ -855,7 +855,8 @@ xfs_ialloc_ag_alloc(
> > >  		 * the end of the AG.
> > >  		 */
> > >  		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
> > > -		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
> > > +		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
> > > +							pag->pag_agno),
> > 
> > So if I'm reading this right, the inode cluster allocation checks now
> > enforce that we cannot search for free space beyond the actual end of
> > the AG, rounded down per inode alignment rules?
> > 
> > In that case, can this use the cached ag block count:
> > 
> > 		args.max_agbno = round_down(
> > 					pag_group(pag)->xg_block_count,
> > 					args.mp->m_sb.sb_inoalignmt);
> > 
> > rather than recomputing the block count every time?
> 
> Eventually, yes. I have another series that pushes the pag further
> into these AG size checks all over the code to try to avoid this
> entire class of bug in the future (i.e. blindly using mp->m_sb ag
> parameters without considering the last AG is a runt).
> 
> I am waiting for the group rework to land
> before I did any more work on that conversion. However, it is not
> yet in the for-next branch, so I'm assuming that it isn't due to be
> merged in the upcoming merge window because that's about to open
> and none of that code has seen any time in linux-next of fs-next...

...let's hope that slip doesn't happen. :(

> I want this fix to land sooner rather than later, so I used
> xfs_ag_block_count() to avoid conflicts with pending work as well
> as not require me to chase random dev branches to submit what is a
> relatively simple bug fix....

Aha, I wondered if that was why you were asking if cem was planning to
push things to for-next.  He said during office hours that he'd push the
metadir/rtgroups stuff Wednesday morning.

With the xfs_ag_block_count calls replaced if the generic groups rework
*does* land (or as it is now if it doesn't),

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
