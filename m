Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35383 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751094AbdFSPJT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jun 2017 11:09:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9755D37E72
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2017 15:09:18 +0000 (UTC)
Date: Mon, 19 Jun 2017 11:09:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170619150912.GE25516@bfoster.bfoster>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
 <20170619134940.GC25516@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170619134940.GC25516@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 19, 2017 at 09:49:42AM -0400, Brian Foster wrote:
> On Fri, Jun 16, 2017 at 12:54:45PM +0200, Carlos Maiolino wrote:
> > When a buffer has been failed during writeback, the inode items into it
> > are kept flush locked, and are never resubmitted due the flush lock, so,
> > if any buffer fails to be written, the items in AIL are never written to
> > disk and never unlocked.
> > 
> > This causes unmount operation to hang due these items flush locked in AIL,
> > but this also causes the items in AIL to never be written back, even when
> > the IO device comes back to normal.
> > 
> > I've been testing this patch with a DM-thin device, creating a
> > filesystem larger than the real device.
> > 
> > When writing enough data to fill the DM-thin device, XFS receives ENOSPC
> > errors from the device, and keep spinning on xfsaild (when 'retry
> > forever' configuration is set).
> > 
> > At this point, the filesystem can not be unmounted because of the flush locked
> > items in AIL, but worse, the items in AIL are never retried at all
> > (once xfs_inode_item_push() will skip the items that are flush locked),
> > even if the underlying DM-thin device is expanded to the proper size.
> > 
> > This patch fixes both cases, retrying any item that has been failed
> > previously, using the infra-structure provided by the previous patch.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
...
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 08cb7d1..2719ac6 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
...
> > @@ -475,6 +476,18 @@ xfs_inode_item_unpin(
> >  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> >  }
> >  
> > +/*
> > + * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> > + * have been failed during writeback
> > + */
> > +STATIC void
> > +xfs_inode_item_error(
> > +	struct xfs_log_item	*lip,
> > +	struct xfs_buf		*bp)
> > +{

Also if we're going to keep the ->iop_error() thing around, could we add
an 'ASSERT(xfs_isiflocked(INODE_ITEM(lip)->ili_inode))' here?

Brian

> > +	xfs_set_li_failed(lip, bp);
> > +}
> > +
> >  STATIC uint
> >  xfs_inode_item_push(
> >  	struct xfs_log_item	*lip,
> > @@ -491,6 +504,17 @@ xfs_inode_item_push(
> >  	if (xfs_ipincount(ip) > 0)
> >  		return XFS_ITEM_PINNED;
> >  
> > +	/*
> > +	 * The buffer containing this item failed to be written back
> > +	 * previously. Resubmit the buffer for IO.
> > +	 */
> > +	if (lip->li_flags & XFS_LI_FAILED) {
> > +		if (!xfs_buf_resubmit_failed_buffers(lip, buffer_list))
> > +			rval = XFS_ITEM_FLUSHING;
> > +
> > +		return rval;
> > +	}
> > +
> >  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
> >  		return XFS_ITEM_LOCKED;
> >  
> > @@ -622,7 +646,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
> >  	.iop_unlock	= xfs_inode_item_unlock,
> >  	.iop_committed	= xfs_inode_item_committed,
> >  	.iop_push	= xfs_inode_item_push,
> > -	.iop_committing = xfs_inode_item_committing
> > +	.iop_committing = xfs_inode_item_committing,
> > +	.iop_error	= xfs_inode_item_error
> >  };
> >  
> >  
> > @@ -710,7 +735,8 @@ xfs_iflush_done(
> >  		 * the AIL lock.
> >  		 */
> >  		iip = INODE_ITEM(blip);
> > -		if (iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn)
> > +		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> > +		    lip->li_flags & XFS_LI_FAILED)
> >  			need_ail++;
> >  
> >  		blip = next;
> > @@ -718,7 +744,8 @@ xfs_iflush_done(
> >  
> >  	/* make sure we capture the state of the initial inode. */
> >  	iip = INODE_ITEM(lip);
> > -	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn)
> > +	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
> > +	    lip->li_flags & XFS_LI_FAILED)
> >  		need_ail++;
> >  
> >  	/*
> > @@ -739,6 +766,9 @@ xfs_iflush_done(
> >  			if (INODE_ITEM(blip)->ili_logged &&
> >  			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
> >  				mlip_changed |= xfs_ail_delete_one(ailp, blip);
> > +			else {
> > +				xfs_clear_li_failed(blip);
> > +			}
> >  		}
> >  
> >  		if (mlip_changed) {
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 50df5367..2d7cf91 100644
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
> > @@ -72,6 +73,31 @@ typedef struct xfs_log_item {
> >  	{ XFS_LI_ABORTED,	"ABORTED" }, \
> >  	{ XFS_LI_FAILED,	"FAILED" }
> >  
> > +static inline void
> > +xfs_clear_li_failed(
> > +	struct xfs_log_item	*lip)
> > +{
> > +	struct xfs_buf	*bp = lip->li_buf;
> > +
> 
> I think we should assert that ->xa_lock is held in both of these
> helpers. Note that we have to use lockdep_assert_held() for spinlocks.
> 
> It also couldn't hurt to assert that XFS_LI_IN_AIL is set as well (we'd
> just have to reorder the _clear_li_failed() call in xfs_ail_delete_one()
> below).
> 
> > +	if (lip->li_flags & XFS_LI_FAILED) {
> > +		lip->li_flags &= ~XFS_LI_FAILED;
> > +		lip->li_buf = NULL;
> > +		xfs_buf_rele(bp);
> > +	}
> > +}
> > +
> > +static inline void
> > +xfs_set_li_failed(
> > +	struct xfs_log_item	*lip,
> > +	struct xfs_buf		*bp)
> > +{
> > +	if (lip->li_flags & ~XFS_LI_FAILED) {
> 
> I think you want !(lip->li_flags & XFS_LI_FAILED). ;)
> 
> Brian
> 
> > +		xfs_buf_hold(bp);
> > +		lip->li_flags |= XFS_LI_FAILED;
> > +		lip->li_buf = bp;
> > +	}
> > +}
> > +
> >  struct xfs_item_ops {
> >  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> >  	void (*iop_format)(xfs_log_item_t *, struct xfs_log_vec *);
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 9056c0f..c41d640 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -687,15 +687,15 @@ xfs_trans_ail_update_bulk(
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
> >  	lip->li_flags &= ~XFS_LI_IN_AIL;
> > +	xfs_clear_li_failed(lip);
> >  	lip->li_lsn = 0;
> > -
> >  	return mlip == lip;
> >  }
> >  
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
