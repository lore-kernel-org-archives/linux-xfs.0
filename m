Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35420 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752258AbeA3Cty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 21:49:54 -0500
Date: Mon, 29 Jan 2018 15:00:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/7] xfs: treat CoW fork operations as delalloc for quota
 accounting
Message-ID: <20180129230004.GJ9068@magnolia>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
 <151701543454.3070.15432025661660161748.stgit@magnolia>
 <20180129122637.GA38852@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180129122637.GA38852@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org

On Mon, Jan 29, 2018 at 07:26:38AM -0500, Brian Foster wrote:
> On Fri, Jan 26, 2018 at 05:10:34PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since the CoW fork only exists in memory, it is incorrect to update the
> > on-disk quota block counts when we modify the CoW fork.  Unlike the data
> > fork, even real extents in the CoW fork are only delalloc-style
> > reservations (on-disk they're owned by the refcountbt) so they must not
> > be tracked in the on disk quota info.  Ensure the i_delayed_blks
> > accounting reflects this too.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Patch doesn't apply.. I'm guessing because xfs_bmap_btalloc_accounting()
> doesn't exist. Is this series incomplete, or perhaps not consistent with
> for-next..?

Yeah, sorry, I think I forgot to send the middle patch when I sent this
series....

...no, wait, "xfs: refactor accounting updates out of xfs_bmap_btalloc"
was already reviewed, so these last few patches were supposed to apply
atop that, and that went on top of for-next.

--D

> 
> Brian
> 
> >  fs/xfs/libxfs/xfs_bmap.c |   32 ++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_reflink.c     |   15 +++++++++++----
> >  2 files changed, 41 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 4582f55..cad21fd 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3343,8 +3343,35 @@ xfs_bmap_btalloc_accounting(
> >  	struct xfs_bmalloca	*ap,
> >  	struct xfs_alloc_arg	*args)
> >  {
> > -	if (!(ap->flags & XFS_BMAPI_COWFORK))
> > -		ap->ip->i_d.di_nblocks += args->len;
> > +	if (ap->flags & XFS_BMAPI_COWFORK) {
> > +		/*
> > +		 * COW fork blocks are in-core only and thus are treated as
> > +		 * in-core quota reservation (like delalloc blocks) even when
> > +		 * converted to real blocks. The quota reservation is not
> > +		 * accounted to disk until blocks are remapped to the data
> > +		 * fork. So if these blocks were previously delalloc, we
> > +		 * already have quota reservation and there's nothing to do
> > +		 * yet.
> > +		 */
> > +		if (ap->wasdel)
> > +			return;
> > +
> > +		/*
> > +		 * Otherwise, we've allocated blocks in a hole. The transaction
> > +		 * has acquired in-core quota reservation for this extent.
> > +		 * Rather than account these as real blocks, however, we reduce
> > +		 * the transaction quota reservation based on the allocation.
> > +		 * This essentially transfers the transaction quota reservation
> > +		 * to that of a delalloc extent.
> > +		 */
> > +		ap->ip->i_delayed_blks += args->len;
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
> > @@ -4820,6 +4847,7 @@ xfs_bmap_del_extent_cow(
> >  		xfs_iext_insert(ip, icur, &new, state);
> >  		break;
> >  	}
> > +	ip->i_delayed_blks -= del->br_blockcount;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 85a119e..c4f0aff 100644
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
> > @@ -613,6 +609,13 @@ xfs_reflink_cancel_cow_blocks(
> >  
> >  			/* Remove the mapping from the CoW fork. */
> >  			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> > +
> > +			/* Remove the quota reservation */
> > +			error = xfs_trans_reserve_quota_nblks(NULL, ip,
> > +					-(long)del.br_blockcount, 0,
> > +					XFS_QMOPT_RES_REGBLKS);
> > +			if (error)
> > +				break;
> >  		} else {
> >  			/* Didn't do anything, push cursor back. */
> >  			xfs_iext_prev(ifp, &icur);
> > @@ -795,6 +798,10 @@ xfs_reflink_end_cow(
> >  		if (error)
> >  			goto out_defer;
> >  
> > +		/* Charge this new data fork mapping to the on-disk quota. */
> > +		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
> > +				(long)del.br_blockcount);
> > +
> >  		/* Remove the mapping from the CoW fork. */
> >  		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
