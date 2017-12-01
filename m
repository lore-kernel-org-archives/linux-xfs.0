Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdLARhE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 12:37:04 -0500
Date: Fri, 1 Dec 2017 12:36:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 1/2] xfs: add the ability to join a buffer to a
 defer_ops
Message-ID: <20171201173656.GC22403@bfoster.bfoster>
References: <20171130175805.GC31372@magnolia>
 <20171201133618.GA22403@bfoster.bfoster>
 <20171201163944.GP21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171201163944.GP21412@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: alex@zadarastorage.com, linux-xfs@vger.kernel.org, david@fromorbit.com, libor.klepac@bcom.cz

On Fri, Dec 01, 2017 at 08:39:44AM -0800, Darrick J. Wong wrote:
> On Fri, Dec 01, 2017 at 08:36:19AM -0500, Brian Foster wrote:
> > On Thu, Nov 30, 2017 at 09:58:05AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > In certain cases we need to be able to maintain a buffer lock across a
> > > defer_finish call.  Since there could be many (large) transactions
> > > committed as a result of a defer_finish, we have to hold the buffer
> > > across the roll, then immediately rejoin the buffer and mark it dirty in
> > > each transaction to keep the log moving forward.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > Seems about right to me. A couple things..
> > 
> > >  fs/xfs/libxfs/xfs_defer.c |   37 ++++++++++++++++++++++++++++++++++---
> > >  fs/xfs/libxfs/xfs_defer.h |    5 ++++-
> > >  2 files changed, 38 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > > index 072ebfe..b5b3414 100644
> > > --- a/fs/xfs/libxfs/xfs_defer.c
> > > +++ b/fs/xfs/libxfs/xfs_defer.c
> > > @@ -249,6 +249,10 @@ xfs_defer_trans_roll(
> > >  	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
> > >  		xfs_trans_log_inode(*tp, dop->dop_inodes[i], XFS_ILOG_CORE);
> > >  
> > > +	/* Hold the (previously bjoin'd) buffer locked across the roll. */
> > > +	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++)
> > > +		xfs_trans_bhold(*tp, dop->dop_bufs[i]);
> > > +
> > 
> > It seems more consistent to dirty the buffer in the tx here and
> > bjoin+bhold it in the loop below.
> 
> I thought the purpose of calling bhold was to prevent the transaction
> commit (in xfs_trans_roll) from unlocking the buffer?  Therefore you'd
> bhold it before the _roll and then bjoin/dirty the still-locked buffer
> afterwards to attach the buffer as a dirty buffer to the new
> transaction.
> 

Yeah, but that wouldn't necessarily change.. I guess what I overlooked
before is that xfs_defer_bjoin() doesn't actually hold the buffer in the
current tp, so we'd have to start off with call to do that in the
current transaction. All in all, what throws me off a bit is that I'd
expect the same semantics/behavior for buffers in this situation as we
have for inodes...

xfs_attr_set() joins the inode the transaction without transferring the
lock (which is analogous to _bjoin() + _bhold()). It does some real
work, defer_ijoin()'s the inode and finishes deferred ops.
xfs_defer_finish() ultimately returns with a transaction that holds the
inode with a clean log item descriptor.

The analogous behavior for buffers in my mind is for xfs_attr_set() to
bhold the buffer to the current transaction, defer_bjoin() it and
ultimately return from xfs_defer_finish() with the buffer held, but not
yet dirtied, in the current transaction. Hm?

Brian

> > >  	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop);
> > >  
> > >  	/* Roll the transaction. */
> > > @@ -264,6 +268,12 @@ xfs_defer_trans_roll(
> > >  	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
> > >  		xfs_trans_ijoin(*tp, dop->dop_inodes[i], 0);
> > >  
> > > +	/* Rejoin the buffers and dirty them so the log moves forward. */
> > > +	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++) {
> > > +		xfs_trans_bjoin(*tp, dop->dop_bufs[i]);
> > > +		xfs_trans_dirty_buf(*tp, dop->dop_bufs[i]);
> > > +	}
> > > +
> > >  	return error;
> > >  }
> > >  
> > > @@ -299,6 +309,29 @@ xfs_defer_ijoin(
> > >  }
> > >  
> > >  /*
> > > + * Add this buffer to the deferred op.  Each joined buffer is relogged
> > > + * each time we roll the transaction.
> > > + */
> > > +int
> > > +xfs_defer_bjoin(
> > > +	struct xfs_defer_ops		*dop,
> > > +	struct xfs_buf			*bp)
> > > +{
> > > +	int				i;
> > > +
> > > +	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
> > > +		if (dop->dop_bufs[i] == bp)
> > > +			return 0;
> > > +		else if (dop->dop_bufs[i] == NULL) {
> > > +			dop->dop_bufs[i] = bp;
> > > +			return 0;
> > > +		}
> > > +	}
> > > +
> > > +	return -EFSCORRUPTED;
> > 
> > I notice that this looks exactly like xfs_defer_join(), but is
> > -EFSCORRUPTED the right error here? It probably doesn't matter that much
> > given that if we hit this we've already lost, but I wonder if an error
> > that more reflects a programming error as opposed to inconsistent fs
> > might be more appropriate..? -EINVAL, -EBUSY?
> 
> Yeah, I'm not sure what error code applies to "programmer messed up" :)
> 
> Perhaps we should add an ASSERT(0) at the bottom of both functions.
> 
> --D
> 
> > Brian
> > 
> > > +}
> > > +
> > > +/*
> > >   * Finish all the pending work.  This involves logging intent items for
> > >   * any work items that wandered in since the last transaction roll (if
> > >   * one has even happened), rolling the transaction, and finishing the
> > > @@ -493,9 +526,7 @@ xfs_defer_init(
> > >  	struct xfs_defer_ops		*dop,
> > >  	xfs_fsblock_t			*fbp)
> > >  {
> > > -	dop->dop_committed = false;
> > > -	dop->dop_low = false;
> > > -	memset(&dop->dop_inodes, 0, sizeof(dop->dop_inodes));
> > > +	memset(dop, 0, sizeof(struct xfs_defer_ops));
> > >  	*fbp = NULLFSBLOCK;
> > >  	INIT_LIST_HEAD(&dop->dop_intake);
> > >  	INIT_LIST_HEAD(&dop->dop_pending);
> > > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > > index d4f046d..045beac 100644
> > > --- a/fs/xfs/libxfs/xfs_defer.h
> > > +++ b/fs/xfs/libxfs/xfs_defer.h
> > > @@ -59,6 +59,7 @@ enum xfs_defer_ops_type {
> > >  };
> > >  
> > >  #define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> > > +#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
> > >  
> > >  struct xfs_defer_ops {
> > >  	bool			dop_committed;	/* did any trans commit? */
> > > @@ -66,8 +67,9 @@ struct xfs_defer_ops {
> > >  	struct list_head	dop_intake;	/* unlogged pending work */
> > >  	struct list_head	dop_pending;	/* logged pending work */
> > >  
> > > -	/* relog these inodes with each roll */
> > > +	/* relog these with each roll */
> > >  	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
> > > +	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
> > >  };
> > >  
> > >  void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
> > > @@ -77,6 +79,7 @@ void xfs_defer_cancel(struct xfs_defer_ops *dop);
> > >  void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
> > >  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
> > >  int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
> > > +int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
> > >  
> > >  /* Description of a deferred type. */
> > >  struct xfs_defer_op_type {
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
