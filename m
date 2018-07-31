Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731920AbeGaN2s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 09:28:48 -0400
Date: Tue, 31 Jul 2018 07:48:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/15] xfs: automatic dfops buffer relogging
Message-ID: <20180731114848.GD40201@bfoster>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-8-bfoster@redhat.com>
 <20180730202037.GH30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730202037.GH30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 01:20:37PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 30, 2018 at 12:45:12PM -0400, Brian Foster wrote:
> > Buffers that are held across deferred operations are explicitly
> > joined to the dfops structure to ensure appropriate relogging.
> > While buffers are currently joined explicitly, we can detect the
> > conditions that require relogging at dfops finish time by inspecting
> > the transaction item list for held buffers.
> > 
> > Replace the xfs_defer_bjoin() infrastructure with such detection and
> > automatic relogging of held buffers. This eliminates the need for
> > the per-dfops buffer list, replaced by an on-stack variant in
> > xfs_defer_trans_roll().
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c  |  1 -
> >  fs/xfs/libxfs/xfs_defer.c | 55 ++++++++++++++++-----------------------
> >  fs/xfs/libxfs/xfs_defer.h |  1 -
> >  fs/xfs/xfs_dquot.c        |  1 -
> >  fs/xfs/xfs_trans.h        |  1 -
> >  5 files changed, 23 insertions(+), 36 deletions(-)
> > 
...
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 0306187b5f56..d0ee55048a7a 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
...
> > @@ -235,9 +240,21 @@ xfs_defer_trans_roll(
> >  	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
> >  		xfs_trans_log_inode(*tp, dop->dop_inodes[i], XFS_ILOG_CORE);
> >  
> > -	/* Hold the (previously bjoin'd) buffer locked across the roll. */
> > -	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++)
> > -		xfs_trans_dirty_buf(*tp, dop->dop_bufs[i]);
> > +	list_for_each_entry(lip, &(*tp)->t_items, li_trans) {
> > +		switch (lip->li_type) {
> > +		case XFS_LI_BUF:
> > +			bli = container_of(lip, struct xfs_buf_log_item,
> > +					   bli_item);
> > +			if (bli->bli_flags & XFS_BLI_HOLD) {
> > +				ASSERT(bpcount < XFS_DEFER_OPS_NR_BUFS);
> 
> This is a bit of a behavior change -- previously if we oveflowed the
> array we'd bail out with -EFSCORRUPTED rather than go corrupting
> whatever came after dop_bufs.  Granted, we were pretty terrible about
> checking the return values, but I think this ought to be:
> 
> if (bpcount >= XFS_DEFER_OPS_NR_BUFS) {
> 	ASSERT(0);
> 	return -EFSCORRUPTED;
> }
> 
> rather than corrupting the on-stack array if we happen to bhold too many
> buffers to the transaction.
> 

Yup, good point. I'll fix up the error checking in both of these
patches.

Brian

> --D
> 
> > +				xfs_trans_dirty_buf(*tp, bli->bli_buf);
> > +				bplist[bpcount++] = bli->bli_buf;
> > +			}
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> >  
> >  	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop, _RET_IP_);
> >  
> > @@ -255,9 +272,9 @@ xfs_defer_trans_roll(
> >  		xfs_trans_ijoin(*tp, dop->dop_inodes[i], 0);
> >  
> >  	/* Rejoin the buffers and dirty them so the log moves forward. */
> > -	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++) {
> > -		xfs_trans_bjoin(*tp, dop->dop_bufs[i]);
> > -		xfs_trans_bhold(*tp, dop->dop_bufs[i]);
> > +	for (i = 0; i < bpcount; i++) {
> > +		xfs_trans_bjoin(*tp, bplist[i]);
> > +		xfs_trans_bhold(*tp, bplist[i]);
> >  	}
> >  
> >  	return error;
> > @@ -295,30 +312,6 @@ xfs_defer_ijoin(
> >  	return -EFSCORRUPTED;
> >  }
> >  
> > -/*
> > - * Add this buffer to the deferred op.  Each joined buffer is relogged
> > - * each time we roll the transaction.
> > - */
> > -int
> > -xfs_defer_bjoin(
> > -	struct xfs_defer_ops		*dop,
> > -	struct xfs_buf			*bp)
> > -{
> > -	int				i;
> > -
> > -	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
> > -		if (dop->dop_bufs[i] == bp)
> > -			return 0;
> > -		else if (dop->dop_bufs[i] == NULL) {
> > -			dop->dop_bufs[i] = bp;
> > -			return 0;
> > -		}
> > -	}
> > -
> > -	ASSERT(0);
> > -	return -EFSCORRUPTED;
> > -}
> > -
> >  /*
> >   * Reset an already used dfops after finish.
> >   */
> > @@ -331,7 +324,6 @@ xfs_defer_reset(
> >  	ASSERT(!xfs_defer_has_unfinished_work(dop));
> >  
> >  	memset(dop->dop_inodes, 0, sizeof(dop->dop_inodes));
> > -	memset(dop->dop_bufs, 0, sizeof(dop->dop_bufs));
> >  
> >  	/*
> >  	 * Low mode state transfers across transaction rolls to mirror dfops
> > @@ -594,7 +586,6 @@ xfs_defer_move(
> >  	list_splice_init(&src->dop_pending, &dst->dop_pending);
> >  
> >  	memcpy(dst->dop_inodes, src->dop_inodes, sizeof(dst->dop_inodes));
> > -	memcpy(dst->dop_bufs, src->dop_bufs, sizeof(dst->dop_bufs));
> >  
> >  	/*
> >  	 * Low free space mode was historically controlled by a dfops field.
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index 8908a2716774..4a8bb838adf2 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -43,7 +43,6 @@ void xfs_defer_cancel(struct xfs_trans *);
> >  void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
> >  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
> >  int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
> > -int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
> >  void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
> >  
> >  /* Description of a deferred type. */
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index da5c55cec966..e1196854dbcd 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -362,7 +362,6 @@ xfs_dquot_disk_alloc(
> >  	 * manually or by committing the transaction.
> >  	 */
> >  	xfs_trans_bhold(tp, bp);
> > -	error = xfs_defer_bjoin(tp->t_dfops, bp);
> >  	if (error) {
> >  		xfs_trans_bhold_release(tp, bp);
> >  		xfs_trans_brelse(tp, bp);
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 7e493221160e..581456c79197 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -100,7 +100,6 @@ struct xfs_defer_ops {
> >  
> >  	/* relog these with each roll */
> >  	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
> > -	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
> >  };
> >  
> >  /*
> > -- 
> > 2.17.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
