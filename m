Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751954AbdFLNpq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 09:45:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31F04C0587CF
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2017 13:45:46 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A83FF842AE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2017 13:45:45 +0000 (UTC)
Date: Mon, 12 Jun 2017 09:45:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2 V3] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170612134542.GB10244@bfoster.bfoster>
References: <20170608140014.25132-1-cmaiolino@redhat.com>
 <20170608140014.25132-3-cmaiolino@redhat.com>
 <20170608164509.GI5244@bfoster.bfoster>
 <20170612124423.zdcc6oy6fdevypc4@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170612124423.zdcc6oy6fdevypc4@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2017 at 02:44:23PM +0200, Carlos Maiolino wrote:
> Hey.
> 
> > > +/*
> > > + * Requeue a failed buffer for writeback
> > > + *
> > > + * Return true if the buffer has been re-queued properly, false otherwise
> > > + */
> > > +bool
> > > +xfs_buf_resubmit_failed_buffers(
> > > +	struct xfs_inode	*ip,
> > > +	struct xfs_log_item	*lip,
> > > +	struct list_head	*buffer_list)
> > > +{
> > > +	struct xfs_log_item	*next;
> > > +	struct xfs_buf		*bp;
> > > +	bool			ret;
> > > +
> > > +	bp = lip->li_buf;
> > > +
> > > +	/* Clear XFS_LI_FAILED flag from all items before resubmit
> > > +	 *
> > > +	 * XFS_LI_FAILED set/clear is protected by xa_lock, caller  this
> > > +	 * function already have it acquired
> > > +	 */
> > > +	for (; lip; lip = next) {
> > > +		next = lip->li_bio_list;
> > > +		lip->li_flags &= ~XFS_LI_FAILED;
> > > +		xfs_buf_rele(bp);
> > 
> > We need to check that the log item has LI_FAILED set before we release
> > the buffer because it's possible for the buffer to have a mix of failed
> > and recently flushed (not failed) items. We should set ->li_buf = NULL
> > wherever we clear LI_FAILED as well.
> > 
> > A couple small inline helpers to fail/unfail log items correctly (i.e.,
> > xfs_log_item_[fail|clear]() or some such) might help to make sure we get
> > the reference counting right. We could also assert that the correct lock
> > is held from those helpers.
> > 
> 
> Agreed, will queue it for V4
> 
> > > +	}
> > > +
> > > +	/* Add this buffer back to the delayed write list */
> > > +	xfs_buf_lock(bp);
> > > +	if (!xfs_buf_delwri_queue(bp, buffer_list))
> > > +		ret = false;
> > > +	else
> > > +		ret = true;
> > > +
> > > +	xfs_buf_unlock(bp);
> > > +	return ret;
> > > +}
> > > diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> > > index f7eba99..32aceae 100644
> > > --- a/fs/xfs/xfs_buf_item.h
> > > +++ b/fs/xfs/xfs_buf_item.h
> > > @@ -70,6 +70,8 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
> > >  			      xfs_log_item_t *);
> > >  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
> > >  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
> > > +bool	xfs_buf_resubmit_failed_buffers(struct xfs_inode *, struct xfs_log_item *,
> > > +					struct list_head *);
> > >  
> > >  extern kmem_zone_t	*xfs_buf_item_zone;
> > >  
> > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > index 08cb7d1..2f5a49e 100644
> > > --- a/fs/xfs/xfs_inode_item.c
> > > +++ b/fs/xfs/xfs_inode_item.c
> > > @@ -27,6 +27,7 @@
> > >  #include "xfs_error.h"
> > >  #include "xfs_trace.h"
> > >  #include "xfs_trans_priv.h"
> > > +#include "xfs_buf_item.h"
> > >  #include "xfs_log.h"
> > >  
> > >  
> > > @@ -475,6 +476,26 @@ xfs_inode_item_unpin(
> > >  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> > >  }
> > >  
> > > +STATIC void
> > > +xfs_inode_item_error(
> > > +	struct xfs_log_item	*lip,
> > > +	struct xfs_buf		*bp,
> > > +	unsigned int		bflags)
> > > +{
> > > +
> > > +	/*
> > > +	 * The buffer writeback containing this inode has been failed
> > > +	 * mark it as failed and unlock the flush lock, so it can be retried
> > > +	 * again.
> > > +	 * Use xa_lock to avoid races with other log item state changes.
> > > +	 */
> > > +	spin_lock(&lip->li_ailp->xa_lock);
> > 
> > I'd push the ->xa_lock up into caller and cycle it once over the list
> > rather than once per item. This is more consistent with the locking
> > pattern for successful I/Os.
> > 
> 
> I considered it too, and decided to use spin_lock/unlock on each interaction to
> avoid having it locked for a long time, but I don't think there is any harm in
> using a single lock/unlock.
> 

I don't think we're too concerned about performance at this low a level
when when I/Os are failing (or yet, at least), but I'm guessing that
pulling up the lock is still lighter weight than what a successful I/O
completion does.

That aside, I think we also want the entire sequence of marking
LI_FAILED to be atomic with respect to the AIL (e.g., so the next AIL
push sees the state of the items before the errors are processed or
after, not somewhere in between).

> > > +	xfs_buf_hold(bp);
> > > +	lip->li_flags |= XFS_LI_FAILED;
> > > +	lip->li_buf = bp;
> > 
> > Also, while I think this is technically Ok based on the current
> > implementation, I think we should also test that LI_FAILED is not
> > already set and only hold the buf in that case (i.e., the previously
> > mentioned helper). This helps prevent a landmine if the
> > implementation/locking/etc. changes down the road.
> > 
> > I think it would be fine to assert that LI_FAILED is not set already if
> > we wanted to, though, as long as there's a brief comment as well.
> > 
> > > +	spin_unlock(&lip->li_ailp->xa_lock);
> > > +}
> > > +
> > >  STATIC uint
> > >  xfs_inode_item_push(
> > >  	struct xfs_log_item	*lip,
> > > @@ -504,6 +525,18 @@ xfs_inode_item_push(
> > >  	}
> > >  
> > >  	/*
> > > +	 * The buffer containing this item failed to be written back
> > > +	 * previously. Resubmit the buffer for IO.
> > > +	 */
> > > +	if (lip->li_flags & XFS_LI_FAILED) {
> > > +		if (!xfs_buf_resubmit_failed_buffers(ip, lip,
> > > +						     buffer_list))
> > > +			rval = XFS_ITEM_FLUSHING;
> > > +
> > > +		goto out_unlock;
> > > +	}
> > 
> > I think this needs to go at least before the ilock. We don't need the
> > latter lock because the inode is already flushed. Somebody else could be
> > holding ilock and blocked on the flush lock. If that occurs, we'll never
> > make progress.
> 
> It should be after the ilock IIRC, having it before the ilock will deadlock it
> any unmount when there are still inodes to be destroyed.

Hmm.. so if we get into the failed state on an inode and a reclaim
attempt occurs on the inode, xfs_reclaim_inode() can grab the ilock and
then block on the flush lock. With this code as it is, we'll now never
resubmit the failed buffer (unless via some other inode, by chance)
because we can't get the inode lock. IOW, we're stuck in a livelock that
resembles the original problem.

AFAICT, we don't need the inode lock in this case at all. The only
reason for it here that I'm aware of is to follow the ilock -> flush
lock ordering rules and we know the inode is already flush locked in the
failed case. Can you elaborate on the unmount deadlock issue if we move
this before the ilock? Shouldn't the I/O error handling detect the
unmounting state the next go around and flag it as a permanent error?
I'm wondering if there is some other bug lurking there that we need to
work around...

(Note that I think it's important we resolve this above all else,
because getting this correct is probably what dictates whether this is a
viable approach or that we need to start looking at something like
Dave's flush lock rework idea.)

> > 
> > I also think we should lock/unlock the buffer here rather than down in
> > the helper. Hmm, maybe even queue it as well so it's clear what's going
> > on. For example, something like:
> > 
> > 	if (lip->li_flags & XFS_LI_FAILED) {
> > 		xfs_buf_lock(bp);
> > 		xfs_buf_clear_failed_items(bp);
> > 		if (!xfs_buf_delwri_queue(bp, buffer_list))
> > 			rval = XFS_ITEM_FLUSHING;
> > 		xfs_buf_unlock(bp);
> > 		goto out_unlock;
> > 	}
> > 
> 
> Well, we could do that, but we would need to duplicate this code between inode
> and dquot item, while keeping the helper as-is, we can re-use it in both inode
> and dquot.
> 

That doesn't seem so bad to me. It's basically just a lock and delwri
queue of a buffer. That said, we could also create a couple separate
helpers here: one that requeues a buffer and another that clears failed
items on a buffer. Hmm, I'm actually wondering if we can refactor
xfs_inode_item_push() a bit to just reuse some of the existing code
here. Perhaps it's best to get the locking down correctly before looking
into this...

BTW, I just realized that the xfs_buf_lock() above probably needs to be
a trylock (where we return XFS_ITEM_LOCKED on failure). The buffer lock
via xfs_iflush() is a trylock as well, and we actually drop and
reacquire ->xa_lock across that and the delwri queue of the buffer (but
I'm not totally sure that part is necessary here).

> > ... but that is mostly just aesthetic.
> > 
> > > +
> > > +	/*
> > >  	 * Stale inode items should force out the iclog.
> > >  	 */
> > >  	if (ip->i_flags & XFS_ISTALE) {
> > > @@ -622,7 +655,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
> > >  	.iop_unlock	= xfs_inode_item_unlock,
> > >  	.iop_committed	= xfs_inode_item_committed,
> > >  	.iop_push	= xfs_inode_item_push,
> > > -	.iop_committing = xfs_inode_item_committing
> > > +	.iop_committing = xfs_inode_item_committing,
> > > +	.iop_error	= xfs_inode_item_error
> > >  };
> > >  
> > >  
> > > @@ -710,7 +744,8 @@ xfs_iflush_done(
> > >  		 * the AIL lock.
> > >  		 */
> > >  		iip = INODE_ITEM(blip);
> > > -		if (iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn)
> > > +		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> > > +		    lip->li_flags & XFS_LI_FAILED)
> > >  			need_ail++;
> > >  
> > >  		blip = next;
> > > @@ -718,7 +753,8 @@ xfs_iflush_done(
> > >  
> > >  	/* make sure we capture the state of the initial inode. */
> > >  	iip = INODE_ITEM(lip);
> > > -	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn)
> > > +	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
> > > +	    lip->li_flags & XFS_LI_FAILED)
> > >  		need_ail++;
> > >  
> > >  	/*
> > > @@ -739,6 +775,8 @@ xfs_iflush_done(
> > >  			if (INODE_ITEM(blip)->ili_logged &&
> > >  			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
> > >  				mlip_changed |= xfs_ail_delete_one(ailp, blip);
> > > +			else if (blip->li_flags & XFS_LI_FAILED)
> > > +				blip->li_flags &= ~XFS_LI_FAILED;
> > 
> > This needs to do the full "unfail" sequence as well (another place to
> > call the helper).
> > 
> > >  		}
> > >  
> > >  		if (mlip_changed) {
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index 3486517..86c3464 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -49,6 +49,7 @@ typedef struct xfs_log_item {
> > >  	struct xfs_ail			*li_ailp;	/* ptr to AIL */
> > >  	uint				li_type;	/* item type */
> > >  	uint				li_flags;	/* misc flags */
> > > +	struct xfs_buf			*li_buf;	/* real buffer pointer */
> > >  	struct xfs_log_item		*li_bio_list;	/* buffer item list */
> > >  	void				(*li_cb)(struct xfs_buf *,
> > >  						 struct xfs_log_item *);
> > > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > > index 9056c0f..36e08dd 100644
> > > --- a/fs/xfs/xfs_trans_ail.c
> > > +++ b/fs/xfs/xfs_trans_ail.c
> > > @@ -687,13 +687,13 @@ xfs_trans_ail_update_bulk(
> > >  bool
> > >  xfs_ail_delete_one(
> > >  	struct xfs_ail		*ailp,
> > > -	struct xfs_log_item 	*lip)
> > > +	struct xfs_log_item	*lip)
> > >  {
> > >  	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
> > >  
> > >  	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
> > >  	xfs_ail_delete(ailp, lip);
> > > -	lip->li_flags &= ~XFS_LI_IN_AIL;
> > > +	lip->li_flags &= ~(XFS_LI_IN_AIL | XFS_LI_FAILED);
> > 
> > ... and the same thing here.
> > 
> 
> I agree with the helpers, and I'll queue them up for V4, I'll just wait for some
> more reviews on this version before sending V4.
> 

Sounds good.

Brian

> Thanks for the review Brian.
> 
> Cheers
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
