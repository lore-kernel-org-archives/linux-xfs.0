Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DEA80034
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 19:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724701229; cv=none; b=jww9egZv2hU+RsHiSd7Ugd30JIesYZ7i3iHJJE7FOROhFwi0srvIvjUu1bpbKM++GU16gedb1ETR7i6qmYCL6MshxaAkqTI5sm9Ln/dNBPPWj9kZz91NcrN9wRg00ff99hi2lHBiHbSj4bKAx7Qtn9SuStrB2ZAaGfXmagIIrGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724701229; c=relaxed/simple;
	bh=zrbNUB7xBQ6H1dGpOJMH2jLL/HeLsIyfbnjBfPxRGSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpu9NoWCo1b5vc00WgGg/o/c7itlLiMAsjcfQciHcR3gg80ZfnhH1oHB5jJh4kxbRzj8cL5uRf6IgJS+WK+uFVx7pLGdcUOmHYSFThyx1DUDSWhGyDo7bcPgnI/DwqgjgYeGnawf9DFAAlbtAiwO60M5ZDWMhAym0HEEJouk2sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+T8RQjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+T8RQjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3FEC8B7A3;
	Mon, 26 Aug 2024 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724701228;
	bh=zrbNUB7xBQ6H1dGpOJMH2jLL/HeLsIyfbnjBfPxRGSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+T8RQjDiy2UiY9L9E1v0kzMJhYAfQ5hYx/X/eb2eVpdKyU4OO9wEG+kWIQ68o5he
	 vJP6Acd48Khm7OSMyhBX4SEUA7+uQaJTlvJtilGosBAbovOz3xoS+1lyucDsscQr81
	 GHEMxE3k/xoN48M7RW9KQJHdZe51E9n0kG7DQ7hx9J5+aLZsjvZH3CFRGGawfroEOY
	 Os/G/V+ZsSoV2YWzsq2IFNC5W5t1mv7+MuSHHr/Fuva+kt7Os6OYkWSsY3XP3sq+Sq
	 COGApCgezpqanKhzCwILKwT92JLjoBujCfcXhofni1ZR2tnIkit9eOhXE8RfK8ymgl
	 sGk7PRULzylYQ==
Date: Mon, 26 Aug 2024 12:40:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
Message-ID: <20240826194028.GE865349@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
 <ZswLBVOUvwhJZInN@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZswLBVOUvwhJZInN@dread.disaster.area>

On Mon, Aug 26, 2024 at 02:56:37PM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:26:38PM -0700, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Make the allocator rtgroup aware by either picking a specific group if
> > there is a hint, or loop over all groups otherwise.  A simple rotor is
> > provided to pick the placement for initial allocations.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c     |   13 +++++-
> >  fs/xfs/libxfs/xfs_rtbitmap.c |    6 ++-
> >  fs/xfs/xfs_mount.h           |    1 
> >  fs/xfs/xfs_rtalloc.c         |   98 ++++++++++++++++++++++++++++++++++++++----
> >  4 files changed, 105 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 126a0d253654a..88c62e1158ac7 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3151,8 +3151,17 @@ xfs_bmap_adjacent_valid(
> >  	struct xfs_mount	*mp = ap->ip->i_mount;
> >  
> >  	if (XFS_IS_REALTIME_INODE(ap->ip) &&
> > -	    (ap->datatype & XFS_ALLOC_USERDATA))
> > -		return x < mp->m_sb.sb_rblocks;
> > +	    (ap->datatype & XFS_ALLOC_USERDATA)) {
> > +		if (x >= mp->m_sb.sb_rblocks)
> > +			return false;
> > +		if (!xfs_has_rtgroups(mp))
> > +			return true;
> > +
> > +		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
> > +			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
> > +			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;
> 
> WHy do we need the xfs_has_rtgroups() check here? The new rtg logic will
> return true for an old school rt device here, right?

The incore sb_rgextents is zero on !rtg filesystems, so we need the
xfs_has_rtgroups.

> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 3fedc552b51b0..2b57ff2687bf6 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -1661,8 +1661,9 @@ xfs_rtalloc_align_minmax(
> >  }
> >  
> >  static int
> > -xfs_rtallocate(
> > +xfs_rtallocate_rtg(
> >  	struct xfs_trans	*tp,
> > +	xfs_rgnumber_t		rgno,
> >  	xfs_rtblock_t		bno_hint,
> >  	xfs_rtxlen_t		minlen,
> >  	xfs_rtxlen_t		maxlen,
> > @@ -1682,16 +1683,33 @@ xfs_rtallocate(
> >  	xfs_rtxlen_t		len = 0;
> >  	int			error = 0;
> >  
> > -	args.rtg = xfs_rtgroup_grab(args.mp, 0);
> > +	args.rtg = xfs_rtgroup_grab(args.mp, rgno);
> >  	if (!args.rtg)
> >  		return -ENOSPC;
> >  
> >  	/*
> > -	 * Lock out modifications to both the RT bitmap and summary inodes.
> > +	 * We need to lock out modifications to both the RT bitmap and summary
> > +	 * inodes for finding free space in xfs_rtallocate_extent_{near,size}
> > +	 * and join the bitmap and summary inodes for the actual allocation
> > +	 * down in xfs_rtallocate_range.
> > +	 *
> > +	 * For RTG-enabled file system we don't want to join the inodes to the
> > +	 * transaction until we are committed to allocate to allocate from this
> > +	 * RTG so that only one inode of each type is locked at a time.
> > +	 *
> > +	 * But for pre-RTG file systems we need to already to join the bitmap
> > +	 * inode to the transaction for xfs_rtpick_extent, which bumps the
> > +	 * sequence number in it, so we'll have to join the inode to the
> > +	 * transaction early here.
> > +	 *
> > +	 * This is all a bit messy, but at least the mess is contained in
> > +	 * this function.
> >  	 */
> >  	if (!*rtlocked) {
> >  		xfs_rtgroup_lock(args.rtg, XFS_RTGLOCK_BITMAP);
> > -		xfs_rtgroup_trans_join(tp, args.rtg, XFS_RTGLOCK_BITMAP);
> > +		if (!xfs_has_rtgroups(args.mp))
> > +			xfs_rtgroup_trans_join(tp, args.rtg,
> > +					XFS_RTGLOCK_BITMAP);
> >  		*rtlocked = true;
> >  	}
> >  
> > @@ -1701,7 +1719,7 @@ xfs_rtallocate(
> >  	 */
> >  	if (bno_hint)
> >  		start = xfs_rtb_to_rtx(args.mp, bno_hint);
> > -	else if (initial_user_data)
> > +	else if (!xfs_has_rtgroups(args.mp) && initial_user_data)
> >  		start = xfs_rtpick_extent(args.rtg, tp, maxlen);
> 
> Check initial_user_data first - we don't care if there are rtgroups
> enabled if initial_user_data is not true, and we only ever allocate
> initial data on an inode once...

<nod>

> > @@ -1741,6 +1767,53 @@ xfs_rtallocate(
> >  	return error;
> >  }
> >  
> > +static int
> > +xfs_rtallocate_rtgs(
> > +	struct xfs_trans	*tp,
> > +	xfs_fsblock_t		bno_hint,
> > +	xfs_rtxlen_t		minlen,
> > +	xfs_rtxlen_t		maxlen,
> > +	xfs_rtxlen_t		prod,
> > +	bool			wasdel,
> > +	bool			initial_user_data,
> > +	xfs_rtblock_t		*bno,
> > +	xfs_extlen_t		*blen)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	xfs_rgnumber_t		start_rgno, rgno;
> > +	int			error;
> > +
> > +	/*
> > +	 * For now this just blindly iterates over the RTGs for an initial
> > +	 * allocation.  We could try to keep an in-memory rtg_longest member
> > +	 * to avoid the locking when just looking for big enough free space,
> > +	 * but for now this keep things simple.
> > +	 */
> > +	if (bno_hint != NULLFSBLOCK)
> > +		start_rgno = xfs_rtb_to_rgno(mp, bno_hint);
> > +	else
> > +		start_rgno = (atomic_inc_return(&mp->m_rtgrotor) - 1) %
> > +				mp->m_sb.sb_rgcount;
> > +
> > +	rgno = start_rgno;
> > +	do {
> > +		bool		rtlocked = false;
> > +
> > +		error = xfs_rtallocate_rtg(tp, rgno, bno_hint, minlen, maxlen,
> > +				prod, wasdel, initial_user_data, &rtlocked,
> > +				bno, blen);
> > +		if (error != -ENOSPC)
> > +			return error;
> > +		ASSERT(!rtlocked);
> > +
> > +		if (++rgno == mp->m_sb.sb_rgcount)
> > +			rgno = 0;
> > +		bno_hint = NULLFSBLOCK;
> > +	} while (rgno != start_rgno);
> > +
> > +	return -ENOSPC;
> > +}
> > +
> >  static int
> >  xfs_rtallocate_align(
> >  	struct xfs_bmalloca	*ap,
> > @@ -1835,9 +1908,16 @@ xfs_bmap_rtalloc(
> >  	if (xfs_bmap_adjacent(ap))
> >  		bno_hint = ap->blkno;
> >  
> > -	error = xfs_rtallocate(ap->tp, bno_hint, raminlen, ralen, prod,
> > -			ap->wasdel, initial_user_data, &rtlocked,
> > -			&ap->blkno, &ap->length);
> > +	if (xfs_has_rtgroups(ap->ip->i_mount)) {
> > +		error = xfs_rtallocate_rtgs(ap->tp, bno_hint, raminlen, ralen,
> > +				prod, ap->wasdel, initial_user_data,
> > +				&ap->blkno, &ap->length);
> > +	} else {
> > +		error = xfs_rtallocate_rtg(ap->tp, 0, bno_hint, raminlen, ralen,
> > +				prod, ap->wasdel, initial_user_data,
> > +				&rtlocked, &ap->blkno, &ap->length);
> > +	}
> 
> The xfs_has_rtgroups() check is unnecessary.  The iterator in
> xfs_rtallocate_rtgs() will do the right thing for the
> !xfs_has_rtgroups() case - it'll set start_rgno = 0 and break out
> after a single call to xfs_rtallocate_rtg() with rgno = 0.
> 
> Another thing that probably should be done here is push all the
> constant value calculations a couple of functions down the stack to
> where they are used. Then we only need to pass two parameters down
> through the rg iterator here, not 11...

..and pass the ap itself too, to remove three of the parameters?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
