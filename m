Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36604 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbeAZTUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 14:20:42 -0500
Date: Fri, 26 Jan 2018 11:20:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: CoW fork operations should only update quota
 reservations
Message-ID: <20180126192038.GC9068@magnolia>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
 <151693230033.7395.7231908899619118352.stgit@magnolia>
 <20180126190649.GB26910@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126190649.GB26910@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 26, 2018 at 02:06:49PM -0500, Brian Foster wrote:
> On Thu, Jan 25, 2018 at 06:05:00PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since the CoW fork only exists in memory, it is incorrect to update the
> > on-disk quota block counts when we modify the CoW fork.  Unlike the data
> > fork, even real extents in the CoW fork are only reservations (on-disk
> > they're owned by the refcountbt) so they must not be tracked in the on
> > disk quota info.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Looks sane.. just a couple comments from my braindump on the previous
> patch and a few comment suggestions that help me understand this better
> (feel free to tweak, rewrite, etc.).
> 
> >  fs/xfs/libxfs/xfs_bmap.c |   33 ++++++++++++++++++++++++++++++---
> >  fs/xfs/libxfs/xfs_bmap.h |    2 +-
> >  fs/xfs/xfs_reflink.c     |   12 ++++++------
> >  3 files changed, 37 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 6ad79ea..a59d5be 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3343,8 +3343,26 @@ xfs_bmap_btalloc_accounting(
> >  	struct xfs_bmalloca	*ap,
> >  	struct xfs_alloc_arg	*args)
> >  {
> > -	if (!(ap->flags & XFS_BMAPI_COWFORK))
> > -		ap->ip->i_d.di_nblocks += args->len;
> > +	if (ap->flags & XFS_BMAPI_COWFORK) {
> 
> /*
>  * COW fork blocks are in-core only and thus are treated as in-core
>  * quota reservation (like delalloc blocks) even when converted to real
>  * blocks. The quota reservation is not accounted to disk until blocks
>  * are remapped to the data fork. So if these blocks were previously
>  * delalloc, we already have quota reservation and there's nothing to do
>  * yet.
>  */

Ok.

> 
> > +		/* Filling a previously reserved extent; nothing to do here. */
> > +		if (ap->wasdel)
> > +			return;
> > +
> > +		/*
> > +		 * If we get here, we're filling a CoW hole with a real
> > +		 * (non-delalloc) CoW extent having reserved enough blocks
> > +		 * from both q_res_bcount and qt_blk_res to guarantee that we
> > +		 * won't run out of space.  The unused qt_blk_res is given
> > +		 * back to q_res_bcount when the transaction commits, so we
> > +		 * must decrease qt_blk_res without decreasing q_res_bcount.
> > +		 */
> 
> /*
>  * Otherwise, we've allocated blocks in a hole. The transaction has
>  * acquired in-core quota reservation for this extent. Rather than
>  * account these as real blocks, however, we reduce the transaction
>  * quota reservation based on the allocation. This essentially transfers
>  * the transaction quota reservation to that of a delalloc extent.
>  */

Ok.

> 
> > +		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
> > +				-(long)args->len);
> > +		return;
> > +	}
> > +
> > +	/* data/attr fork only */
> > +	ap->ip->i_d.di_nblocks += args->len;
> >  	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> >  	if (ap->wasdel)
> >  		ap->ip->i_delayed_blks -= args->len;
> > @@ -4761,13 +4779,15 @@ xfs_bmap_del_extent_cow(
> >  	struct xfs_inode	*ip,
> >  	struct xfs_iext_cursor	*icur,
> >  	struct xfs_bmbt_irec	*got,
> > -	struct xfs_bmbt_irec	*del)
> > +	struct xfs_bmbt_irec	*del,
> > +	bool			free_quotares)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> >  	struct xfs_bmbt_irec	new;
> >  	xfs_fileoff_t		del_endoff, got_endoff;
> >  	int			state = BMAP_COWFORK;
> > +	int			error;
> >  
> >  	XFS_STATS_INC(mp, xs_del_exlist);
> >  
> > @@ -4824,6 +4844,13 @@ xfs_bmap_del_extent_cow(
> >  		xfs_iext_insert(ip, icur, &new, state);
> >  		break;
> >  	}
> > +
> > +	/* Remove the quota reservation */
> > +	if (!free_quotares)
> > +		return;
> > +	error = xfs_trans_reserve_quota_nblks(NULL, ip,
> > +			-(long)del->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
> > +	ASSERT(error == 0);
> 
> Might as well pull this into the only free_quotares = true caller.

Done.  Thx for the review!

--D

> Brian
> 
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index e36d757..e99f28f 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -224,7 +224,7 @@ int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
> >  		struct xfs_bmbt_irec *del);
> >  void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
> >  		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
> > -		struct xfs_bmbt_irec *del);
> > +		struct xfs_bmbt_irec *del, bool free_quotares);
> >  uint	xfs_default_attroffset(struct xfs_inode *ip);
> >  int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
> >  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 82abff6..3644a08 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -599,10 +599,6 @@ xfs_reflink_cancel_cow_blocks(
> >  					del.br_startblock, del.br_blockcount,
> >  					NULL);
> >  
> > -			/* Update quota accounting */
> > -			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
> > -					-(long)del.br_blockcount);
> > -
> >  			/* Roll the transaction */
> >  			xfs_defer_ijoin(&dfops, ip);
> >  			error = xfs_defer_finish(tpp, &dfops);
> > @@ -612,7 +608,7 @@ xfs_reflink_cancel_cow_blocks(
> >  			}
> >  
> >  			/* Remove the mapping from the CoW fork. */
> > -			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> > +			xfs_bmap_del_extent_cow(ip, &icur, &got, &del, true);
> >  		} else {
> >  			/* Didn't do anything, push cursor back. */
> >  			xfs_iext_prev(ifp, &icur);
> > @@ -795,8 +791,12 @@ xfs_reflink_end_cow(
> >  		if (error)
> >  			goto out_defer;
> >  
> > +		/* Charge this new data fork mapping to the on-disk quota. */
> > +		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
> > +				(long)del.br_blockcount);
> > +
> >  		/* Remove the mapping from the CoW fork. */
> > -		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> > +		xfs_bmap_del_extent_cow(ip, &icur, &got, &del, false);
> >  
> >  		xfs_defer_ijoin(&dfops, ip);
> >  		error = xfs_defer_finish(&tp, &dfops);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
