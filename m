Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CCCB47F7E
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2015 06:27:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1578304039
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2015 04:27:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OMLqM4ftJDiEDoqs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Jun 2015 04:27:08 -0700 (PDT)
Date: Tue, 16 Jun 2015 07:27:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/20] xfs: sanitise error handling in
	xfs_alloc_fix_freelist
Message-ID: <20150616112706.GB24853@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-4-git-send-email-david@fromorbit.com>
	<20150615145814.GC36091@bfoster.bfoster>
	<20150615215119.GC10224@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150615215119.GC10224@dastard>
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

On Tue, Jun 16, 2015 at 07:51:19AM +1000, Dave Chinner wrote:
> On Mon, Jun 15, 2015 at 10:58:14AM -0400, Brian Foster wrote:
> > On Wed, Jun 03, 2015 at 04:04:40PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The error handling is currently an inconsistent mess as every error
> > > condition handles return values and releasing buffers individually.
> > > Clean this up by using gotos and a sane error label stack.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c | 103 +++++++++++++++++++++-------------------------
> > >  1 file changed, 47 insertions(+), 56 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index 2471cb5..352db46 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -1909,80 +1909,65 @@ xfs_alloc_space_available(
> > >   */
> > >  STATIC int			/* error */
> > >  xfs_alloc_fix_freelist(
> > > -	xfs_alloc_arg_t	*args,	/* allocation argument structure */
> > > -	int		flags)	/* XFS_ALLOC_FLAG_... */
> > > +	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> > > +	int			flags)	/* XFS_ALLOC_FLAG_... */
> > >  {
> > > -	xfs_buf_t	*agbp;	/* agf buffer pointer */
> > > -	xfs_buf_t	*agflbp;/* agfl buffer pointer */
> > > -	xfs_agblock_t	bno;	/* freelist block */
> > > -	int		error;	/* error result code */
> > > -	xfs_mount_t	*mp;	/* file system mount point structure */
> > > -	xfs_extlen_t	need;	/* total blocks needed in freelist */
> > > -	xfs_perag_t	*pag;	/* per-ag information structure */
> > > -	xfs_alloc_arg_t	targs;	/* local allocation arguments */
> > > -	xfs_trans_t	*tp;	/* transaction pointer */
> > > -
> > > -	mp = args->mp;
> > > +	struct xfs_mount	*mp = args->mp;
> > > +	struct xfs_perag	*pag = args->pag;
> > > +	struct xfs_trans	*tp = args->tp;
> > > +	struct xfs_buf		*agbp = NULL;
> > > +	struct xfs_buf		*agflbp = NULL;
> > > +	struct xfs_alloc_arg	targs;	/* local allocation arguments */
> > > +	xfs_agblock_t		bno;	/* freelist block */
> > > +	xfs_extlen_t		need;	/* total blocks needed in freelist */
> > > +	int			error;
> > >  
> > > -	pag = args->pag;
> > > -	tp = args->tp;
> > >  	if (!pag->pagf_init) {
> > > -		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
> > > -				&agbp)))
> > > -			return error;
> > > +		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> > > +		if (error)
> > > +			goto out_no_agbp;
> > >  		if (!pag->pagf_init) {
> > >  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
> > >  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> > > -			args->agbp = NULL;
> > > -			return 0;
> > > +			goto out_agbp_relse;
> > >  		}
> > > -	} else
> > > -		agbp = NULL;
> > > +	}
> > >  
> > >  	/*
> > > -	 * If this is a metadata preferred pag and we are user data
> > > -	 * then try somewhere else if we are not being asked to
> > > -	 * try harder at this point
> > > +	 * If this is a metadata preferred pag and we are user data then try
> > > +	 * somewhere else if we are not being asked to try harder at this
> > > +	 * point
> > >  	 */
> > >  	if (pag->pagf_metadata && args->userdata &&
> > >  	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
> > >  		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> > > -		args->agbp = NULL;
> > > -		return 0;
> > > +		goto out_agbp_relse;
> > >  	}
> > >  
> > >  	need = XFS_MIN_FREELIST_PAG(pag, mp);
> > > -	if (!xfs_alloc_space_available(args, need, flags)) {
> > > -		if (agbp)
> > > -			xfs_trans_brelse(tp, agbp);
> > > -		args->agbp = NULL;
> > > -		return 0;
> > > -	}
> > > +	if (!xfs_alloc_space_available(args, need, flags))
> > > +		goto out_agbp_relse;
> > >  
> > >  	/*
> > >  	 * Get the a.g. freespace buffer.
> > >  	 * Can fail if we're not blocking on locks, and it's held.
> > >  	 */
> > > -	if (agbp == NULL) {
> > > -		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
> > > -				&agbp)))
> > > -			return error;
> > > -		if (agbp == NULL) {
> > > +	if (!agbp) {
> > > +		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> > > +		if (error)
> > > +			goto out_no_agbp;
> > > +		if (!agbp) {
> > >  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
> > >  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> > > -			args->agbp = NULL;
> > > -			return 0;
> > > +			goto out_no_agbp;
> > >  		}
> > >  	}
> > >  
> > >  
> > >  	/* If there isn't enough total space or single-extent, reject it. */
> > >  	need = XFS_MIN_FREELIST_PAG(pag, mp);
> > > -	if (!xfs_alloc_space_available(args, need, flags)) {
> > > -		xfs_trans_brelse(tp, agbp);
> > > -		args->agbp = NULL;
> > > -		return 0;
> > > -	}
> > > +	if (!xfs_alloc_space_available(args, need, flags))
> > > +		goto out_agbp_relse;
> > >  
> > >  	/*
> > >  	 * Make the freelist shorter if it's too long.
> > > @@ -1997,10 +1982,10 @@ xfs_alloc_fix_freelist(
> > >  
> > >  		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
> > >  		if (error)
> > > -			return error;
> > > +			goto out_agbp_relse;
> > 
> > So at this point it looks like the buffer could be logged (i.e., dirty
> > in the transaction). Perhaps this is the reason for the lack of agbp
> > releases from this point forward in the current error handling. That
> > said, we do the agflbp release unconditionally at the end of the
> > function even when it might be logged. xfs_trans_brelse() appears to
> > handle this case as it just skips removing the item from the tp.
> > 
> > This is a bit confusing and at the very least seems like an unexpected
> > use of xfs_trans_brelse(). Is this intentional?
> 
> Yes, very much so. If the agf is clean, then releasing it
> immediately on error in the function that grabbed the buffer is the
> right thing to do. This can happen if the first call to
> xfs_alloc_get_freelist() fails (which only occurs if we fail to read
> the AGFL buffer).
> 

Ok.

> And, as you noticed, if it is dirty it will remain held by the
> transaction until it is cancelled, as happens everywhere else in the
> code. So this is effectively making the current code consistent with
> the usual error handling patterns...
> 

Effectively, yeah. My point was more that it doesn't seem to be the
prevalent pattern. Case in point, this code prior to these changes, attr
code doesn't seem to use brelse() after potential modification
(xfs_attr_leaf_[add|remove]name()), inode allocation, etc. Anyways, it
seems valid and is probably the more simple method for handling errors
in this situation:

Reviewed-by: Brian Foster <bfoster@redhat.com>

... though I think a comment around it couldn't hurt.

> FWIW, in looking at this, I noticed that the freelist modificaiton
> loops are kind of inefficient - extending it re-reads the agfl
> buffer for every call, and then we re-read the agfl buffer again
> before making the free list longer if needed. I think this can be
> cleaned up further and better optimised. IOWs, it can only fail on
> the first read of the AGFL buffer, because if it succeeds then it
> will be found in the transaction item list on subsequent reads...
> 
> Cheers,
> 
> Dave.
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
