Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49623 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdH3XDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 19:03:10 -0400
Date: Wed, 30 Aug 2017 16:03:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs: use xfs_iext_*_extent helpers in
 xfs_bmap_shift_extents
Message-ID: <20170830230305.GB3775@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
 <20170829174835.2218-6-hch@lst.de>
 <20170830000541.GF4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830000541.GF4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 05:05:41PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 29, 2017 at 07:48:32PM +0200, Christoph Hellwig wrote:
> > This abstracts the function away from details of the low-level extent
> > list implementation.
> > 
> > Note that it seems like the previous implementation of rmap for
> > the merge case was completely broken, but it no seems appear to
> > trigger that.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Series looks ok enough to test,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Tests ok, but I've since noticed the following:

<scroll down>

> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 180 +++++++++++++++++++++++------------------------
> >  1 file changed, 88 insertions(+), 92 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 6af3cc1fc630..02725becedfa 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5881,32 +5881,26 @@ xfs_bmse_merge(
> >  	int				whichfork,
> >  	xfs_fileoff_t			shift,		/* shift fsb */
> >  	int				current_ext,	/* idx of gotp */
> > -	struct xfs_bmbt_rec_host	*gotp,		/* extent to shift */
> > -	struct xfs_bmbt_rec_host	*leftp,		/* preceding extent */
> > +	struct xfs_bmbt_irec		*got,		/* extent to shift */
> > +	struct xfs_bmbt_irec		*left,		/* preceding extent */
> >  	struct xfs_btree_cur		*cur,
> > -	int				*logflags)	/* output */
> > +	int				*logflags,	/* output */
> > +	struct xfs_defer_ops		*dfops)
> >  {
> > -	struct xfs_bmbt_irec		got;
> > -	struct xfs_bmbt_irec		left;
> > +	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	struct xfs_bmbt_irec		new;
> >  	xfs_filblks_t			blockcount;
> >  	int				error, i;
> >  	struct xfs_mount		*mp = ip->i_mount;
> >  
> > -	xfs_bmbt_get_all(gotp, &got);
> > -	xfs_bmbt_get_all(leftp, &left);
> > -	blockcount = left.br_blockcount + got.br_blockcount;
> > +	blockcount = left->br_blockcount + got->br_blockcount;
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -	ASSERT(xfs_bmse_can_merge(&left, &got, shift));
> > +	ASSERT(xfs_bmse_can_merge(left, got, shift));
> >  
> > -	/*
> > -	 * Merge the in-core extents. Note that the host record pointers and
> > -	 * current_ext index are invalid once the extent has been removed via
> > -	 * xfs_iext_remove().
> > -	 */
> > -	xfs_bmbt_set_blockcount(leftp, blockcount);
> > -	xfs_iext_remove(ip, current_ext, 1, 0);
> > +	new = *left;
> > +	new.br_blockcount = blockcount;
> >  
> >  	/*
> >  	 * Update the on-disk extent count, the btree if necessary and log the
> > @@ -5917,12 +5911,12 @@ xfs_bmse_merge(
> >  	*logflags |= XFS_ILOG_CORE;
> >  	if (!cur) {
> >  		*logflags |= XFS_ILOG_DEXT;
> > -		return 0;
> > +		goto done;
> >  	}
> >  
> >  	/* lookup and remove the extent to merge */
> > -	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
> > -				   got.br_blockcount, &i);
> > +	error = xfs_bmbt_lookup_eq(cur, got->br_startoff, got->br_startblock,
> > +				   got->br_blockcount, &i);
> >  	if (error)
> >  		return error;
> >  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> > @@ -5933,16 +5927,29 @@ xfs_bmse_merge(
> >  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> >  
> >  	/* lookup and update size of the previous extent */
> > -	error = xfs_bmbt_lookup_eq(cur, left.br_startoff, left.br_startblock,
> > -				   left.br_blockcount, &i);
> > +	error = xfs_bmbt_lookup_eq(cur, left->br_startoff, left->br_startblock,
> > +				   left->br_blockcount, &i);
> >  	if (error)
> >  		return error;
> >  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> >  
> > -	left.br_blockcount = blockcount;
> > +	error = xfs_bmbt_update(cur, new.br_startoff, new.br_startblock,
> > +			        new.br_blockcount, new.br_state);
> > +	if (error)
> > +		return error;
> >  
> > -	return xfs_bmbt_update(cur, left.br_startoff, left.br_startblock,
> > -			       left.br_blockcount, left.br_state);
> > +done:
> > +	xfs_iext_update_extent(ifp, current_ext - 1, &new);
> > +	xfs_iext_remove(ip, current_ext, 1, 0);
> > +
> > +	/* update reverse mapping */
> > +	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
> > +	if (error)
> > +		return error;
> > +	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, left);
> > +	if (error)
> > +		return error;
> > +	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);

So one subtlety of the xfs_rmap_{,un}map_extent methods is that because
they take as input an inode fork mapping (as opposed to an rmap record),
these functions are free to merge rmap records under the hood.  That's
why the old code worked fine, even if the way the call sites were
structured was (quite obviously) misleading.

You can replace that whole hunk of code with:

	/* update reverse mapping */
	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
	if (error)
		return error;
	memcpy(&new, got, sizeof(new));
	new.br_startoff = left->br_startoff + left->br_blockcount;
	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);

And it works fine, at least for all the fcollapse tests including the
new xfs/706.  Plus we save one deferred op.

--D

> >  }
> >  
> >  /*
> > @@ -5954,7 +5961,7 @@ xfs_bmse_shift_one(
> >  	int				whichfork,
> >  	xfs_fileoff_t			offset_shift_fsb,
> >  	int				*current_ext,
> > -	struct xfs_bmbt_rec_host	*gotp,
> > +	struct xfs_bmbt_irec		*got,
> >  	struct xfs_btree_cur		*cur,
> >  	int				*logflags,
> >  	enum shift_direction		direction,
> > @@ -5963,9 +5970,7 @@ xfs_bmse_shift_one(
> >  	struct xfs_ifork		*ifp;
> >  	struct xfs_mount		*mp;
> >  	xfs_fileoff_t			startoff;
> > -	struct xfs_bmbt_rec_host	*adj_irecp;
> > -	struct xfs_bmbt_irec		got;
> > -	struct xfs_bmbt_irec		adj_irec;
> > +	struct xfs_bmbt_irec		adj_irec, new;
> >  	int				error;
> >  	int				i;
> >  	int				total_extents;
> > @@ -5974,13 +5979,11 @@ xfs_bmse_shift_one(
> >  	ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	total_extents = xfs_iext_count(ifp);
> >  
> > -	xfs_bmbt_get_all(gotp, &got);
> > -
> >  	/* delalloc extents should be prevented by caller */
> > -	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
> > +	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got->br_startblock));
> >  
> >  	if (direction == SHIFT_LEFT) {
> > -		startoff = got.br_startoff - offset_shift_fsb;
> > +		startoff = got->br_startoff - offset_shift_fsb;
> >  
> >  		/*
> >  		 * Check for merge if we've got an extent to the left,
> > @@ -5988,46 +5991,39 @@ xfs_bmse_shift_one(
> >  		 * of the file for the shift.
> >  		 */
> >  		if (!*current_ext) {
> > -			if (got.br_startoff < offset_shift_fsb)
> > +			if (got->br_startoff < offset_shift_fsb)
> >  				return -EINVAL;
> >  			goto update_current_ext;
> >  		}
> > +
> >  		/*
> > -		 * grab the left extent and check for a large
> > -		 * enough hole.
> > +		 * grab the left extent and check for a large enough hole.
> >  		 */
> > -		adj_irecp = xfs_iext_get_ext(ifp, *current_ext - 1);
> > -		xfs_bmbt_get_all(adj_irecp, &adj_irec);
> > -
> > -		if (startoff <
> > -		    adj_irec.br_startoff + adj_irec.br_blockcount)
> > +		xfs_iext_get_extent(ifp, *current_ext - 1, &adj_irec);
> > +		if (startoff < adj_irec.br_startoff + adj_irec.br_blockcount)
> >  			return -EINVAL;
> >  
> >  		/* check whether to merge the extent or shift it down */
> > -		if (xfs_bmse_can_merge(&adj_irec, &got,
> > -				       offset_shift_fsb)) {
> > -			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> > -					       *current_ext, gotp, adj_irecp,
> > -					       cur, logflags);
> > -			if (error)
> > -				return error;
> > -			adj_irec = got;
> > -			goto update_rmap;
> > +		if (xfs_bmse_can_merge(&adj_irec, got, offset_shift_fsb)) {
> > +			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> > +					      *current_ext, got, &adj_irec,
> > +					      cur, logflags, dfops);
> >  		}
> >  	} else {
> > -		startoff = got.br_startoff + offset_shift_fsb;
> > +		startoff = got->br_startoff + offset_shift_fsb;
> >  		/* nothing to move if this is the last extent */
> >  		if (*current_ext >= (total_extents - 1))
> >  			goto update_current_ext;
> > +
> >  		/*
> >  		 * If this is not the last extent in the file, make sure there
> >  		 * is enough room between current extent and next extent for
> >  		 * accommodating the shift.
> >  		 */
> > -		adj_irecp = xfs_iext_get_ext(ifp, *current_ext + 1);
> > -		xfs_bmbt_get_all(adj_irecp, &adj_irec);
> > -		if (startoff + got.br_blockcount > adj_irec.br_startoff)
> > +		xfs_iext_get_extent(ifp, *current_ext + 1, &adj_irec);
> > +		if (startoff + got->br_blockcount > adj_irec.br_startoff)
> >  			return -EINVAL;
> > +
> >  		/*
> >  		 * Unlike a left shift (which involves a hole punch),
> >  		 * a right shift does not modify extent neighbors
> > @@ -6035,45 +6031,48 @@ xfs_bmse_shift_one(
> >  		 * in this scenario. Check anyways and warn if we
> >  		 * encounter two extents that could be one.
> >  		 */
> > -		if (xfs_bmse_can_merge(&got, &adj_irec, offset_shift_fsb))
> > +		if (xfs_bmse_can_merge(got, &adj_irec, offset_shift_fsb))
> >  			WARN_ON_ONCE(1);
> >  	}
> > +
> >  	/*
> >  	 * Increment the extent index for the next iteration, update the start
> >  	 * offset of the in-core extent and update the btree if applicable.
> >  	 */
> >  update_current_ext:
> > -	if (direction == SHIFT_LEFT)
> > -		(*current_ext)++;
> > -	else
> > -		(*current_ext)--;
> > -	xfs_bmbt_set_startoff(gotp, startoff);
> >  	*logflags |= XFS_ILOG_CORE;
> > -	adj_irec = got;
> > -	if (!cur) {
> > +
> > +	new = *got;
> > +	new.br_startoff = startoff;
> > +
> > +	if (cur) {
> > +		error = xfs_bmbt_lookup_eq(cur, got->br_startoff,
> > +				got->br_startblock, got->br_blockcount, &i);
> > +		if (error)
> > +			return error;
> > +		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> > +
> > +		error = xfs_bmbt_update(cur, new.br_startoff,
> > +				new.br_startblock, new.br_blockcount,
> > +				new.br_state);
> > +		if (error)
> > +			return error;
> > +	} else {
> >  		*logflags |= XFS_ILOG_DEXT;
> > -		goto update_rmap;
> >  	}
> >  
> > -	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
> > -				   got.br_blockcount, &i);
> > -	if (error)
> > -		return error;
> > -	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> > +	xfs_iext_update_extent(ifp, *current_ext, &new);
> >  
> > -	got.br_startoff = startoff;
> > -	error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
> > -			got.br_blockcount, got.br_state);
> > -	if (error)
> > -		return error;
> > +	if (direction == SHIFT_LEFT)
> > +		(*current_ext)++;
> > +	else
> > +		(*current_ext)--;
> >  
> > -update_rmap:
> >  	/* update reverse mapping */
> > -	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, &adj_irec);
> > +	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
> >  	if (error)
> >  		return error;
> > -	adj_irec.br_startoff = startoff;
> > -	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &adj_irec);
> > +	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);
> >  }
> >  
> >  /*
> > @@ -6100,7 +6099,6 @@ xfs_bmap_shift_extents(
> >  	int			num_exts)
> >  {
> >  	struct xfs_btree_cur		*cur = NULL;
> > -	struct xfs_bmbt_rec_host	*gotp;
> >  	struct xfs_bmbt_irec            got;
> >  	struct xfs_mount		*mp = ip->i_mount;
> >  	struct xfs_ifork		*ifp;
> > @@ -6161,25 +6159,23 @@ xfs_bmap_shift_extents(
> >  		ASSERT(direction == SHIFT_RIGHT);
> >  
> >  		current_ext = total_extents - 1;
> > -		gotp = xfs_iext_get_ext(ifp, current_ext);
> > -		xfs_bmbt_get_all(gotp, &got);
> > -		*next_fsb = got.br_startoff;
> > -		if (stop_fsb > *next_fsb) {
> > +		xfs_iext_get_extent(ifp, current_ext, &got);
> > +		if (stop_fsb > got.br_startoff) {
> >  			*done = 1;
> >  			goto del_cursor;
> >  		}
> > +		*next_fsb = got.br_startoff;
> >  	} else {
> >  		/*
> >  		 * Look up the extent index for the fsb where we start shifting. We can
> >  		 * henceforth iterate with current_ext as extent list changes are locked
> >  		 * out via ilock.
> >  		 *
> > -		 * gotp can be null in 2 cases: 1) if there are no extents or 2)
> > -		 * *next_fsb lies in a hole beyond which there are no extents. Either
> > -		 * way, we are done.
> > +		 * If next_fsb lies in a hole beyond which there are no extents we are
> > +		 * done.
> >  		 */
> > -		gotp = xfs_iext_bno_to_ext(ifp, *next_fsb, &current_ext);
> > -		if (!gotp) {
> > +		if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &current_ext,
> > +				&got)) {
> >  			*done = 1;
> >  			goto del_cursor;
> >  		}
> > @@ -6187,7 +6183,9 @@ xfs_bmap_shift_extents(
> >  
> >  	/* Lookup the extent index at which we have to stop */
> >  	if (direction == SHIFT_RIGHT) {
> > -		xfs_iext_bno_to_ext(ifp, stop_fsb, &stop_extent);
> > +		struct xfs_bmbt_irec s;
> > +
> > +		xfs_iext_lookup_extent(ip, ifp, stop_fsb, &stop_extent, &s);
> >  		/* Make stop_extent exclusive of shift range */
> >  		stop_extent--;
> >  		if (current_ext <= stop_extent) {
> > @@ -6204,7 +6202,7 @@ xfs_bmap_shift_extents(
> >  
> >  	while (nexts++ < num_exts) {
> >  		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
> > -					   &current_ext, gotp, cur, &logflags,
> > +					   &current_ext, &got, cur, &logflags,
> >  					   direction, dfops);
> >  		if (error)
> >  			goto del_cursor;
> > @@ -6222,13 +6220,11 @@ xfs_bmap_shift_extents(
> >  			*next_fsb = NULLFSBLOCK;
> >  			break;
> >  		}
> > -		gotp = xfs_iext_get_ext(ifp, current_ext);
> > +		xfs_iext_get_extent(ifp, current_ext, &got);
> >  	}
> >  
> > -	if (!*done) {
> > -		xfs_bmbt_get_all(gotp, &got);
> > +	if (!*done)
> >  		*next_fsb = got.br_startoff;
> > -	}
> >  
> >  del_cursor:
> >  	if (cur)
> > -- 
> > 2.11.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
