Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752002AbdFLMo1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:44:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 21C3DC04B935
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2017 12:44:27 +0000 (UTC)
Date: Mon, 12 Jun 2017 14:44:23 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2 V3] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170612124423.zdcc6oy6fdevypc4@eorzea.usersys.redhat.com>
References: <20170608140014.25132-1-cmaiolino@redhat.com>
 <20170608140014.25132-3-cmaiolino@redhat.com>
 <20170608164509.GI5244@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608164509.GI5244@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hey.

> > +/*
> > + * Requeue a failed buffer for writeback
> > + *
> > + * Return true if the buffer has been re-queued properly, false otherwise
> > + */
> > +bool
> > +xfs_buf_resubmit_failed_buffers(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_log_item	*lip,
> > +	struct list_head	*buffer_list)
> > +{
> > +	struct xfs_log_item	*next;
> > +	struct xfs_buf		*bp;
> > +	bool			ret;
> > +
> > +	bp = lip->li_buf;
> > +
> > +	/* Clear XFS_LI_FAILED flag from all items before resubmit
> > +	 *
> > +	 * XFS_LI_FAILED set/clear is protected by xa_lock, caller  this
> > +	 * function already have it acquired
> > +	 */
> > +	for (; lip; lip = next) {
> > +		next = lip->li_bio_list;
> > +		lip->li_flags &= ~XFS_LI_FAILED;
> > +		xfs_buf_rele(bp);
> 
> We need to check that the log item has LI_FAILED set before we release
> the buffer because it's possible for the buffer to have a mix of failed
> and recently flushed (not failed) items. We should set ->li_buf = NULL
> wherever we clear LI_FAILED as well.
> 
> A couple small inline helpers to fail/unfail log items correctly (i.e.,
> xfs_log_item_[fail|clear]() or some such) might help to make sure we get
> the reference counting right. We could also assert that the correct lock
> is held from those helpers.
> 

Agreed, will queue it for V4

> > +	}
> > +
> > +	/* Add this buffer back to the delayed write list */
> > +	xfs_buf_lock(bp);
> > +	if (!xfs_buf_delwri_queue(bp, buffer_list))
> > +		ret = false;
> > +	else
> > +		ret = true;
> > +
> > +	xfs_buf_unlock(bp);
> > +	return ret;
> > +}
> > diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> > index f7eba99..32aceae 100644
> > --- a/fs/xfs/xfs_buf_item.h
> > +++ b/fs/xfs/xfs_buf_item.h
> > @@ -70,6 +70,8 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
> >  			      xfs_log_item_t *);
> >  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
> >  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
> > +bool	xfs_buf_resubmit_failed_buffers(struct xfs_inode *, struct xfs_log_item *,
> > +					struct list_head *);
> >  
> >  extern kmem_zone_t	*xfs_buf_item_zone;
> >  
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 08cb7d1..2f5a49e 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -27,6 +27,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_trans_priv.h"
> > +#include "xfs_buf_item.h"
> >  #include "xfs_log.h"
> >  
> >  
> > @@ -475,6 +476,26 @@ xfs_inode_item_unpin(
> >  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> >  }
> >  
> > +STATIC void
> > +xfs_inode_item_error(
> > +	struct xfs_log_item	*lip,
> > +	struct xfs_buf		*bp,
> > +	unsigned int		bflags)
> > +{
> > +
> > +	/*
> > +	 * The buffer writeback containing this inode has been failed
> > +	 * mark it as failed and unlock the flush lock, so it can be retried
> > +	 * again.
> > +	 * Use xa_lock to avoid races with other log item state changes.
> > +	 */
> > +	spin_lock(&lip->li_ailp->xa_lock);
> 
> I'd push the ->xa_lock up into caller and cycle it once over the list
> rather than once per item. This is more consistent with the locking
> pattern for successful I/Os.
> 

I considered it too, and decided to use spin_lock/unlock on each interaction to
avoid having it locked for a long time, but I don't think there is any harm in
using a single lock/unlock.

> > +	xfs_buf_hold(bp);
> > +	lip->li_flags |= XFS_LI_FAILED;
> > +	lip->li_buf = bp;
> 
> Also, while I think this is technically Ok based on the current
> implementation, I think we should also test that LI_FAILED is not
> already set and only hold the buf in that case (i.e., the previously
> mentioned helper). This helps prevent a landmine if the
> implementation/locking/etc. changes down the road.
> 
> I think it would be fine to assert that LI_FAILED is not set already if
> we wanted to, though, as long as there's a brief comment as well.
> 
> > +	spin_unlock(&lip->li_ailp->xa_lock);
> > +}
> > +
> >  STATIC uint
> >  xfs_inode_item_push(
> >  	struct xfs_log_item	*lip,
> > @@ -504,6 +525,18 @@ xfs_inode_item_push(
> >  	}
> >  
> >  	/*
> > +	 * The buffer containing this item failed to be written back
> > +	 * previously. Resubmit the buffer for IO.
> > +	 */
> > +	if (lip->li_flags & XFS_LI_FAILED) {
> > +		if (!xfs_buf_resubmit_failed_buffers(ip, lip,
> > +						     buffer_list))
> > +			rval = XFS_ITEM_FLUSHING;
> > +
> > +		goto out_unlock;
> > +	}
> 
> I think this needs to go at least before the ilock. We don't need the
> latter lock because the inode is already flushed. Somebody else could be
> holding ilock and blocked on the flush lock. If that occurs, we'll never
> make progress.

It should be after the ilock IIRC, having it before the ilock will deadlock it
any unmount when there are still inodes to be destroyed.
> 
> I also think we should lock/unlock the buffer here rather than down in
> the helper. Hmm, maybe even queue it as well so it's clear what's going
> on. For example, something like:
> 
> 	if (lip->li_flags & XFS_LI_FAILED) {
> 		xfs_buf_lock(bp);
> 		xfs_buf_clear_failed_items(bp);
> 		if (!xfs_buf_delwri_queue(bp, buffer_list))
> 			rval = XFS_ITEM_FLUSHING;
> 		xfs_buf_unlock(bp);
> 		goto out_unlock;
> 	}
> 

Well, we could do that, but we would need to duplicate this code between inode
and dquot item, while keeping the helper as-is, we can re-use it in both inode
and dquot.

> ... but that is mostly just aesthetic.
> 
> > +
> > +	/*
> >  	 * Stale inode items should force out the iclog.
> >  	 */
> >  	if (ip->i_flags & XFS_ISTALE) {
> > @@ -622,7 +655,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
> >  	.iop_unlock	= xfs_inode_item_unlock,
> >  	.iop_committed	= xfs_inode_item_committed,
> >  	.iop_push	= xfs_inode_item_push,
> > -	.iop_committing = xfs_inode_item_committing
> > +	.iop_committing = xfs_inode_item_committing,
> > +	.iop_error	= xfs_inode_item_error
> >  };
> >  
> >  
> > @@ -710,7 +744,8 @@ xfs_iflush_done(
> >  		 * the AIL lock.
> >  		 */
> >  		iip = INODE_ITEM(blip);
> > -		if (iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn)
> > +		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> > +		    lip->li_flags & XFS_LI_FAILED)
> >  			need_ail++;
> >  
> >  		blip = next;
> > @@ -718,7 +753,8 @@ xfs_iflush_done(
> >  
> >  	/* make sure we capture the state of the initial inode. */
> >  	iip = INODE_ITEM(lip);
> > -	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn)
> > +	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
> > +	    lip->li_flags & XFS_LI_FAILED)
> >  		need_ail++;
> >  
> >  	/*
> > @@ -739,6 +775,8 @@ xfs_iflush_done(
> >  			if (INODE_ITEM(blip)->ili_logged &&
> >  			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
> >  				mlip_changed |= xfs_ail_delete_one(ailp, blip);
> > +			else if (blip->li_flags & XFS_LI_FAILED)
> > +				blip->li_flags &= ~XFS_LI_FAILED;
> 
> This needs to do the full "unfail" sequence as well (another place to
> call the helper).
> 
> >  		}
> >  
> >  		if (mlip_changed) {
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 3486517..86c3464 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -49,6 +49,7 @@ typedef struct xfs_log_item {
> >  	struct xfs_ail			*li_ailp;	/* ptr to AIL */
> >  	uint				li_type;	/* item type */
> >  	uint				li_flags;	/* misc flags */
> > +	struct xfs_buf			*li_buf;	/* real buffer pointer */
> >  	struct xfs_log_item		*li_bio_list;	/* buffer item list */
> >  	void				(*li_cb)(struct xfs_buf *,
> >  						 struct xfs_log_item *);
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 9056c0f..36e08dd 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -687,13 +687,13 @@ xfs_trans_ail_update_bulk(
> >  bool
> >  xfs_ail_delete_one(
> >  	struct xfs_ail		*ailp,
> > -	struct xfs_log_item 	*lip)
> > +	struct xfs_log_item	*lip)
> >  {
> >  	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
> >  
> >  	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
> >  	xfs_ail_delete(ailp, lip);
> > -	lip->li_flags &= ~XFS_LI_IN_AIL;
> > +	lip->li_flags &= ~(XFS_LI_IN_AIL | XFS_LI_FAILED);
> 
> ... and the same thing here.
> 

I agree with the helpers, and I'll queue them up for V4, I'll just wait for some
more reviews on this version before sending V4.

Thanks for the review Brian.

Cheers

-- 
Carlos
