Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21971 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932398AbdHYV5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 17:57:15 -0400
Date: Fri, 25 Aug 2017 14:57:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: Properly retry failed dquot items in case of
 error during buffer writeback
Message-ID: <20170825215701.GT4796@magnolia>
References: <20170825120752.22553-1-cmaiolino@redhat.com>
 <20170825170400.GS4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825170400.GS4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 10:04:01AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 25, 2017 at 02:07:52PM +0200, Carlos Maiolino wrote:
> > Hi,
> > 
> > Once the fix for inode item writeback errors is already queued
> > (d3a304b62), I believe it's time to fix the same problem in dquot code.
> > 
> > Although there were no reports of users hitting this bug in dquot code
> > (at least none I've seen), the bug is there and I was already planning
> > to fix it when the correct approach to fix the inodes part was decided.
> > 
> > So, this is an RFC patch to fix the same problem in dquot code,
> > regarding failed buffers being unable to be resubmitted once they are
> > flush locked.
> > 
> > The semantics are quite similar to inode items path, although during
> > xfs_qm_dqflush_done(), I'm not sure if the changes I made are correct.
> > 
> > Comments much appreciated :)
> > 
> > 
> > BTW, This patch should be applied only over branch xfs-4.14-merge, it requires
> > my previous patches, which are not in the master branch yet.
> 
> Looks ok, but is there an xfstests case to cover this?

Then I tried compiling it, which broke, and then I went digging more than
I would've for an RFC:

> --D
> 
> > 
> > Cheers.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_dquot.c      | 11 ++++++++---
> >  fs/xfs/xfs_dquot_item.c | 37 +++++++++++++++++++++++++++++++++++--
> >  2 files changed, 43 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index fd2ef8c2c9a7..8198c20212a2 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -987,14 +987,19 @@ xfs_qm_dqflush_done(
> >  	 * holding the lock before removing the dquot from the AIL.
> >  	 */
> >  	if ((lip->li_flags & XFS_LI_IN_AIL) &&
> > -	    lip->li_lsn == qip->qli_flush_lsn) {
> > +	   (lip->li_lsn == qip->qli_flush_lsn) ||
> > +	    lip->li_flags & XFS_LI_FAILED) {

...come to think of it, shouldn't there be a couple extra pairs of parentheses
in this somewhere?...

> >  
> >  		/* xfs_trans_ail_delete() drops the AIL lock. */
> >  		spin_lock(&ailp->xa_lock);
> > -		if (lip->li_lsn == qip->qli_flush_lsn)
> > +		if (lip->li_lsn == qip->qli_flush_lsn) {
> >  			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> > -		else
> > +		} else if (lip->li_flags & XFS_LI_FAILED) {
> > +			xfs_clear_li_failed(lip);
> >  			spin_unlock(&ailp->xa_lock);
> > +		} else {
> > +			spin_unlock(&ailp->xa_lock);
> > +		}
> >  	}
> >  
> >  	/*
> > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > index 2c7a1629e064..35fd6d71bc42 100644
> > --- a/fs/xfs/xfs_dquot_item.c
> > +++ b/fs/xfs/xfs_dquot_item.c
> > @@ -137,6 +137,23 @@ xfs_qm_dqunpin_wait(
> >  	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
> >  }
> >  
> > +/*
> > + * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> > + * have been failed during writeback
> > + *
> > + * this informs the AIL that the dquot is already flush locked on the next push,
> > + * and acquires a hold on the buffer to ensure that it isn't reclaimed before
> > + * dirty data makes it to disk.
> > + */
> > +STATIC void
> > +xfs_dquot_item_error(
> > +	struct xfs_log_item	*lip,
> > +	struct xfs_buf		*bp)
> > +{
> > +	ASSERT(XFS_DQ_IS_LOCKED(DQUOT_ITEM(lip)->qli_item));

...and isn't this qli_dquot, not qli_item?

(Does this compile at all?)

--D

> > +	xfs_set_li_failed(lip, bp);
> > +}
> > +
> >  STATIC uint
> >  xfs_qm_dquot_logitem_push(
> >  	struct xfs_log_item	*lip,
> > @@ -144,13 +161,28 @@ xfs_qm_dquot_logitem_push(
> >  					      __acquires(&lip->li_ailp->xa_lock)
> >  {
> >  	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
> > -	struct xfs_buf		*bp = NULL;
> > +	struct xfs_buf		*bp = lip->li_buf;
> >  	uint			rval = XFS_ITEM_SUCCESS;
> >  	int			error;
> >  
> >  	if (atomic_read(&dqp->q_pincount) > 0)
> >  		return XFS_ITEM_PINNED;
> >  
> > +	/*
> > +	 * The buffer containing this item failed to be written back
> > +	 * previously. Resubmit the buffer for IO
> > +	 */
> > +	if (lip->li_flags & XFS_LI_FAILED) {
> > +		if (!xfs_buf_trylock(bp))
> > +			return XFS_ITEM_LOCKED;
> > +
> > +		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
> > +			rval = XFS_ITEM_FLUSHING;
> > +
> > +		xfs_buf_unlock(bp);
> > +		return rval;
> > +	}
> > +
> >  	if (!xfs_dqlock_nowait(dqp))
> >  		return XFS_ITEM_LOCKED;
> >  
> > @@ -242,7 +274,8 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
> >  	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
> >  	.iop_committed	= xfs_qm_dquot_logitem_committed,
> >  	.iop_push	= xfs_qm_dquot_logitem_push,
> > -	.iop_committing = xfs_qm_dquot_logitem_committing
> > +	.iop_committing = xfs_qm_dquot_logitem_committing,
> > +	.iop_error	= xfs_dquot_item_error
> >  };
> >  
> >  /*
> > -- 
> > 2.13.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
