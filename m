Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D4FB7F3F
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 10:04:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D54A8F8033
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 08:04:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qV06eSObmJmuHtt1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 08:04:30 -0700 (PDT)
Date: Tue, 9 Sep 2014 11:04:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: refactor xfs_bmap_shift_extents() into multiple
	functions
Message-ID: <20140909150426.GC35182@bfoster.bfoster>
References: <1410092760-3451-1-git-send-email-bfoster@redhat.com>
	<1410092760-3451-3-git-send-email-bfoster@redhat.com>
	<20140909050800.GD20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140909050800.GD20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 03:08:00PM +1000, Dave Chinner wrote:
> On Sun, Sep 07, 2014 at 08:25:58AM -0400, Brian Foster wrote:
> > The extent shift mechanism in xfs_bmap_shift_extents() is complicated
> > and handles several different, non-deterministic scenarios. These
> > include extent shifts, extent merges and potential btree updates in
> > either of the former scenarios.
> > 
> > Refactor the code to be more linear and readable. The loop logic in
> > xfs_bmap_shift_extents() and some initial error checking is adjusted
> > slightly. The associated btree lookup and update/delete operations are
> > condensed into single blocks of code. This reduces the number of
> > btree-specific blocks and facilitates the separation of the merge
> > operation into a new xfs_bmap_shift_extents_merge() helper.  The merge
> > check is also separated into an inline.
> > 
> > This is a code refactor only. The behavior of extent shift and collapse
> > range is not modified.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 243 ++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 168 insertions(+), 75 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 4b3f1b9..449a016 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5404,6 +5404,120 @@ error0:
> >  }
> >  
> >  /*
> > + * Determine whether an extent shift can be accomplished by a merge with the
> > + * extent that precedes the target hole of the shift.
> > + */
> > +static inline bool
> > +xfs_bmap_shift_extents_can_merge(
> 
> No need for "inline" for static functions. The compiler will do that
> as an optimisation if appropriate.
> 

Ok.

> > +	struct xfs_bmbt_irec	*left,	/* preceding extent */
> > +	struct xfs_bmbt_irec	*got,	/* current extent to shift */
> > +	xfs_fileoff_t		shift)	/* shift fsb */
> > +{
> > +	xfs_fileoff_t		startoff;
> > +
> > +	startoff = got->br_startoff - shift;
> > +
> > +	/*
> > +	 * The extent, once shifted, must be adjacent in-file and on-disk with
> > +	 * the preceding extent.
> > +	 */
> > +	if ((left->br_startoff + left->br_blockcount != startoff) ||
> > +	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
> > +	    (left->br_state != got->br_state) ||
> > +	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> > +/*
> > + * An extent shift adjusts the file offset of an extent to fill a preceding hole
> > + * in the file. If an extent shift would result in the extent being fully
> > + * adjacent to the extent that currently precedes the hole, we can merge with
> > + * the preceding extent rather than do the shift.
> > + *
> > + * This function assumes the caller has verified a shift-by-merge is possible
> > + * with the provided extents via xfs_bmap_shift_extents_can_merge().
> > + */
> > +static int
> > +xfs_bmap_shift_extents_merge(
> > +	struct xfs_inode		*ip,
> > +	int				whichfork,
> > +	xfs_fileoff_t			shift,		/* shift fsb */
> > +	int				current_ext,	/* idx of gotp */
> > +	struct xfs_bmbt_rec_host	*gotp,		/* extent to shift */
> > +	struct xfs_bmbt_rec_host	*leftp,		/* preceding extent */
> > +	struct xfs_btree_cur		*cur,
> > +	int				*logflags)	/* output */
> > +{
> > +	struct xfs_ifork		*ifp;
> > +	struct xfs_bmbt_irec		got;
> > +	struct xfs_bmbt_irec		left;
> > +	xfs_filblks_t			blockcount;
> > +	int				error, i;
> > +
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	xfs_bmbt_get_all(gotp, &got);
> > +	xfs_bmbt_get_all(leftp, &left);
> > +	blockcount = left.br_blockcount + got.br_blockcount;
> > +
> > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > +	ASSERT(xfs_bmap_shift_extents_can_merge(&left, &got, shift));
> > +
> > +	/*
> > +	 * Merge the in-core extents. Note that the host record pointers and
> > +	 * current_ext index are invalid once the extent has been removed via
> > +	 * xfs_iext_remove().
> > +	 */
> > +	xfs_bmbt_set_blockcount(leftp, blockcount);
> > +	xfs_iext_remove(ip, current_ext, 1, 0);
> > +
> > +	/*
> > +	 * Update the on-disk extent count, the btree if necessary and log the
> > +	 * inode.
> > +	 */
> > +	XFS_IFORK_NEXT_SET(ip, whichfork,
> > +			   XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> > +	*logflags |= XFS_ILOG_CORE;
> > +	if (cur) {
> > +		/* lookup and remove the extent to merge */
> > +		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> > +				got.br_startblock, got.br_blockcount, &i);
> > +		if (error)
> > +			goto error;
> 
> Probably shouldn't give the jump label the same name as a variable
> in the function. "out_error" is commonly used here.
> 

Ok.

> > +		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> > +
> > +		error = xfs_btree_delete(cur, &i);
> > +		if (error)
> > +			goto error;
> > +		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> > +
> > +		/* lookup and update size of the previous extent */
> > +		error = xfs_bmbt_lookup_eq(cur, left.br_startoff,
> > +				left.br_startblock, left.br_blockcount, &i);
> > +		if (error)
> > +			goto error;
> > +		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> > +
> > +		left.br_blockcount = blockcount;
> > +
> > +		error = xfs_bmbt_update(cur, left.br_startoff,
> > +				left.br_startblock, left.br_blockcount,
> > +				left.br_state);
> > +		if (error)
> > +			goto error;
> > +	} else {
> > +		*logflags |= XFS_ILOG_DEXT;
> > +	}
> > +
> > +	return 0;
> > +
> > +error:
> > +	return error;
> 
> This code is much clearer, though I'd get rid of further
> indents by changing the logic around like so:
> 

Yeah, good idea.

> ....
> 	*logflags |= XFS_ILOG_CORE;
> 	if (!cur) {
> 		*logflags |= XFS_ILOG_DEXT;
> 		return 0;
> 	}
> 
> 	/* lookup and remove the extent to merge */
> 	error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> 				got.br_startblock, got.br_blockcount, &i);
> 	if (error)
> 		goto out_error;
> .....
> 
> 	error = xfs_bmbt_update(cur, left.br_startoff,
> 				left.br_startblock, left.br_blockcount,
> 				left.br_state);
> out_error:
> 	return error;
> }
> 
> > @@ -5493,30 +5617,42 @@ xfs_bmap_shift_extents(
> >  	 */
> >  	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> >  	while (nexts++ < num_exts && current_ext < total_extents) {
> > -
> > -		gotp = xfs_iext_get_ext(ifp, current_ext);
> > -		xfs_bmbt_get_all(gotp, &got);
> >  		startoff = got.br_startoff - offset_shift_fsb;
> >  
> > -		/*
> > -		 * Before shifting extent into hole, make sure that the hole is
> > -		 * large enough to accommodate the shift.
> > -		 */
> > +		/* grab the left extent and check for a potential merge */
> >  		if (current_ext > 0) {
> > -			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, current_ext - 1),
> > -					 &left);
> > -			if (startoff < left.br_startoff + left.br_blockcount)
> > +			leftp = xfs_iext_get_ext(ifp, current_ext - 1);
> > +			xfs_bmbt_get_all(leftp, &left);
> > +
> > +			/* make sure hole is large enough for shift */
> > +			if (startoff < left.br_startoff + left.br_blockcount) {
> >  				error = -EINVAL;
> > -		} else if (offset_shift_fsb > got.br_startoff) {
> > -			/*
> > -			 * When first extent is shifted, offset_shift_fsb should
> > -			 * be less than the stating offset of the first extent.
> > -			 */
> > -			error = -EINVAL;
> > +				goto del_cursor;
> > +			}
> > +
> > +			if (xfs_bmap_shift_extents_can_merge(&left, &got,
> > +							offset_shift_fsb)) {
> > +				error = xfs_bmap_shift_extents_merge(ip, whichfork,
> > +						offset_shift_fsb, current_ext, gotp,
> > +						leftp, cur, &logflags);
> > +				if (error)
> > +					goto del_cursor;
> > +
> > +				/*
> > +				 * The extent was merged so adjust the extent
> > +				 * index and move onto the next.
> > +				 */
> > +				current_ext--;
> > +				goto next;
> > +			}
> >  		}
> > -		if (error)
> > -			goto del_cursor;
> >  
> > +		/*
> > +		 * We didn't merge the extent so do the shift. Update the start
> > +		 * offset in the in-core extent and btree, if necessary.
> > +		 */
> > +		xfs_bmbt_set_startoff(gotp, startoff);
> > +		logflags |= XFS_ILOG_CORE;
> >  		if (cur) {
> >  			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> >  						   got.br_startblock,
> 
> This doesn't do a lot to improve the code. It increases the level of
> indent and, IMO, makes it harder to read. It's a classic case of
> function names getting so long there's no space left for the code...
> 
> So, how about s/xfs_bmap_shift_extents/xfs_bmse/ as a means of
> reducing the namespace verbosity? And, really, that whole loop body
> could be pushed into a separate function. i.e
> 
>         while (nexts++ < num_exts) {
> 		error = xfs_bmse_collapse_one(ip, ifp, cur, &current_ext, gotp,
> 					      offset_shift_fsb, &logflags);
> 		if (error)
> 			goto del_cursor;
> 
> 		/* check against total extent count, grab the next record */
> 		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> 		if (current_ext >= total_extents)
> 			break;
> 		gotp = xfs_iext_get_ext(ifp, current_ext);
> 		xfs_bmbt_get_all(gotp, &got);
> 	}
> 
> That reduces all the jumps/error cases simply to return statements,
> allowing them to be ordered clearly to minimise the indent of
> the code. It also means that way the value of current_ext changes is
> obvious, rather than having the decrement/increment because of the
> "next iteration" handling in the loop always incrementing the value.
> 
> Even the initial check outside the loop for:
> 
>         if (current_ext == 0 && got.br_startoff < offset_shift_fsb) {
> 		error = -EINVAL;
> 		goto del_cursor
> 	}
> 
> could be driven inside xfs_bmse_collapse_one() as the first check that
> is done, and that would further simplify xfs_bmap_shift_extents().
> i.e.
> 
> xfs_bmse_collapse_one()
> {
> 	if (*current_ext == 0) {
> 		if (got.br_startoff < offset_shift_fsb)
> 			return -EINVAL;
> 		goto shift_extent;
> 	}
> 
> 	/* get left, do merge checks */
> 	....
> 	if (!xfs_bmse_can_merge(&left, &got, offset_shift_fsb))
> 		goto shift_extent;
> 
> 	return xfs_bmse_merge(ip, whichfork, ...)
> 
> shift_extent:
> 	(*current_ext)++;
> 	xfs_bmbt_set_startoff(gotp, startoff);
> 	logflags |= XFS_ILOG_CORE;
> 	if (!cur)
> 		*logflags |= XFS_ILOG_DEXT;
> 		return 0;
> 	}
> 
> 	/* do btree shift */
> 	....
> 	return error;
> }
> 
> This way we end up with a set of well defined operations, along
> with clear logic on how they are iterated to make do the overall
> shift operation.
> 
> What do you think?
> 

That all sounds pretty good to me. I may incorporate the aforementioned
updates to the merge bits to this patch and create a new patch for the
subsequent refactor of the loop body. E.g., this patch becomes "...
refactor extent merge into new function." But I'll play with it and see
what falls out... thanks for the feedback.

Brian

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
