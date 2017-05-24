Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753351AbdEXRGp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 13:06:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5449B804EB
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2017 17:06:45 +0000 (UTC)
Date: Wed, 24 May 2017 13:06:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: use atomic operations to handle xfs_log_item
 flags
Message-ID: <20170524170641.GA13925@bfoster.bfoster>
References: <20170522153220.25072-1-cmaiolino@redhat.com>
 <20170522153220.25072-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170522153220.25072-2-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 05:32:18PM +0200, Carlos Maiolino wrote:
> In order to fix a bug during buffer retries, a new flag type will be
> added to xfs_log_item, and such operations need to be atomic.
> 
> Change all operations in xfs_log_item flags to atomic operations
> 
> To use atomic operations, xfs_log_item->li_flags also needed to be
> converted to unsigned long type.
> 
> There is a small whitespace cleanup in the patch too
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

As noted in the v1 discussion, I don't think this needs to be a
dependency of the bug fix patch. Provided we can alleviate Dave's
concerns over performance and not add any ->xa_lock acquisitions that
aren't triggered by I/O errors, can we fix the bug using ->xa_lock and
then port this on top? That way we have more of a backportable fix for
older kernels affected by this problem.

(Please see my comments on patches 2 and 3 wrt proposed changes to avoid
the custom callback and need for atomic flags..)

Brian

>  fs/xfs/xfs_bmap_item.c     |  4 ++--
>  fs/xfs/xfs_buf_item.c      |  4 ++--
>  fs/xfs/xfs_dquot.c         |  2 +-
>  fs/xfs/xfs_extfree_item.c  |  4 ++--
>  fs/xfs/xfs_icache.c        |  2 +-
>  fs/xfs/xfs_icreate_item.c  |  2 +-
>  fs/xfs/xfs_inode.c         |  4 ++--
>  fs/xfs/xfs_inode_item.c    |  2 +-
>  fs/xfs/xfs_qm.c            |  2 +-
>  fs/xfs/xfs_refcount_item.c |  4 ++--
>  fs/xfs/xfs_rmap_item.c     |  4 ++--
>  fs/xfs/xfs_trace.h         |  4 ++--
>  fs/xfs/xfs_trans.c         |  4 ++--
>  fs/xfs/xfs_trans.h         |  2 +-
>  fs/xfs/xfs_trans_ail.c     | 12 ++++++------
>  fs/xfs/xfs_trans_buf.c     |  2 +-
>  fs/xfs/xfs_trans_priv.h    |  2 +-
>  17 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index d419d23..9ebdca9 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -141,7 +141,7 @@ STATIC void
>  xfs_bui_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_bui_item_free(BUI_ITEM(lip));
>  }
>  
> @@ -304,7 +304,7 @@ xfs_bud_item_unlock(
>  {
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
>  
> -	if (lip->li_flags & XFS_LI_ABORTED) {
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
>  		xfs_bui_release(budp->bud_buip);
>  		kmem_zone_free(xfs_bud_zone, budp);
>  	}
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 0306168..6ac3816 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -587,7 +587,7 @@ xfs_buf_item_unlock(
>  	 * (cancelled) buffers at unpin time, but we'll never go through the
>  	 * pin/unpin cycle if we abort inside commit.
>  	 */
> -	aborted = (lip->li_flags & XFS_LI_ABORTED) ? true : false;
> +	aborted = (test_bit(XFS_LI_ABORTED, &lip->li_flags)) ? true : false;
>  	/*
>  	 * Before possibly freeing the buf item, copy the per-transaction state
>  	 * so we can reference it safely later after clearing it from the
> @@ -975,7 +975,7 @@ xfs_buf_item_relse(
>  	xfs_buf_log_item_t	*bip = bp->b_fspriv;
>  
>  	trace_xfs_buf_item_relse(bp, _RET_IP_);
> -	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
> +	ASSERT(!(test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)));
>  
>  	bp->b_fspriv = bip->bli_item.li_bio_list;
>  	if (bp->b_fspriv == NULL)
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 9d06cc3..e8f2cbc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1003,7 +1003,7 @@ xfs_qm_dqflush_done(
>  	 * since it's cheaper, and then we recheck while
>  	 * holding the lock before removing the dquot from the AIL.
>  	 */
> -	if ((lip->li_flags & XFS_LI_IN_AIL) &&
> +	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
>  	    lip->li_lsn == qip->qli_flush_lsn) {
>  
>  		/* xfs_trans_ail_delete() drops the AIL lock. */
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 44f8c54..32a519d 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -150,7 +150,7 @@ STATIC void
>  xfs_efi_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_efi_item_free(EFI_ITEM(lip));
>  }
>  
> @@ -402,7 +402,7 @@ xfs_efd_item_unlock(
>  {
>  	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
>  
> -	if (lip->li_flags & XFS_LI_ABORTED) {
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
>  		xfs_efi_release(efdp->efd_efip);
>  		xfs_efd_item_free(efdp);
>  	}
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f61c84f8..23d750f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -107,7 +107,7 @@ xfs_inode_free_callback(
>  		xfs_idestroy_fork(ip, XFS_COW_FORK);
>  
>  	if (ip->i_itemp) {
> -		ASSERT(!(ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL));
> +		ASSERT(!(test_bit(XFS_LI_IN_AIL, &ip->i_itemp->ili_item.li_flags)));
>  		xfs_inode_item_destroy(ip);
>  		ip->i_itemp = NULL;
>  	}
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 865ad13..e24cf83 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -91,7 +91,7 @@ xfs_icreate_item_unlock(
>  {
>  	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
>  
> -	if (icp->ic_item.li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &icp->ic_item.li_flags))
>  		kmem_zone_free(xfs_icreate_zone, icp);
>  	return;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ec9826c..208c8c7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -504,7 +504,7 @@ xfs_lock_inodes(
>  		if (!try_lock) {
>  			for (j = (i - 1); j >= 0 && !try_lock; j--) {
>  				lp = (xfs_log_item_t *)ips[j]->i_itemp;
> -				if (lp && (lp->li_flags & XFS_LI_IN_AIL))
> +				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
>  					try_lock++;
>  			}
>  		}
> @@ -601,7 +601,7 @@ xfs_lock_two_inodes(
>  	 * and try again.
>  	 */
>  	lp = (xfs_log_item_t *)ip0->i_itemp;
> -	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
> +	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
>  		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
>  			xfs_iunlock(ip0, lock_mode);
>  			if ((++attempts % 5) == 0)
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 08cb7d1..eeeadbb 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -783,7 +783,7 @@ xfs_iflush_abort(
>  	xfs_inode_log_item_t	*iip = ip->i_itemp;
>  
>  	if (iip) {
> -		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
> +		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
>  			xfs_trans_ail_remove(&iip->ili_item,
>  					     stale ? SHUTDOWN_LOG_IO_ERROR :
>  						     SHUTDOWN_CORRUPT_INCORE);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 5fe6e70..da58263 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -169,7 +169,7 @@ xfs_qm_dqpurge(
>  
>  	ASSERT(atomic_read(&dqp->q_pincount) == 0);
>  	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
> -	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
> +	       !(test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags)));
>  
>  	xfs_dqfunlock(dqp);
>  	xfs_dqunlock(dqp);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 96fe209..5ecfd04 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -139,7 +139,7 @@ STATIC void
>  xfs_cui_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_cui_item_free(CUI_ITEM(lip));
>  }
>  
> @@ -308,7 +308,7 @@ xfs_cud_item_unlock(
>  {
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
>  
> -	if (lip->li_flags & XFS_LI_ABORTED) {
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
>  		xfs_cui_release(cudp->cud_cuip);
>  		kmem_zone_free(xfs_cud_zone, cudp);
>  	}
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index f3b139c..ada5ec7 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -139,7 +139,7 @@ STATIC void
>  xfs_rui_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_rui_item_free(RUI_ITEM(lip));
>  }
>  
> @@ -330,7 +330,7 @@ xfs_rud_item_unlock(
>  {
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  
> -	if (lip->li_flags & XFS_LI_ABORTED) {
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
>  		xfs_rui_release(rudp->rud_ruip);
>  		kmem_zone_free(xfs_rud_zone, rudp);
>  	}
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 7c5a165..d09e539 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1031,7 +1031,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
>  		__field(dev_t, dev)
>  		__field(void *, lip)
>  		__field(uint, type)
> -		__field(uint, flags)
> +		__field(unsigned long, flags)
>  		__field(xfs_lsn_t, lsn)
>  	),
>  	TP_fast_assign(
> @@ -1083,7 +1083,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
>  		__field(dev_t, dev)
>  		__field(void *, lip)
>  		__field(uint, type)
> -		__field(uint, flags)
> +		__field(unsigned long, flags)
>  		__field(xfs_lsn_t, old_lsn)
>  		__field(xfs_lsn_t, new_lsn)
>  	),
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index be86e4e..6c8f492 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -764,7 +764,7 @@ xfs_trans_free_items(
>  		if (commit_lsn != NULLCOMMITLSN)
>  			lip->li_ops->iop_committing(lip, commit_lsn);
>  		if (abort)
> -			lip->li_flags |= XFS_LI_ABORTED;
> +			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  		lip->li_ops->iop_unlock(lip);
>  
>  		xfs_trans_free_item_desc(lidp);
> @@ -835,7 +835,7 @@ xfs_trans_committed_bulk(
>  		xfs_lsn_t		item_lsn;
>  
>  		if (aborted)
> -			lip->li_flags |= XFS_LI_ABORTED;
> +			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  		item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
>  
>  		/* item_lsn of -1 means the item needs no further processing */
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a07acbf..7ae04de 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -48,7 +48,7 @@ typedef struct xfs_log_item {
>  	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
>  	struct xfs_ail			*li_ailp;	/* ptr to AIL */
>  	uint				li_type;	/* item type */
> -	uint				li_flags;	/* misc flags */
> +	unsigned long			li_flags;	/* misc flags */
>  	struct xfs_log_item		*li_bio_list;	/* buffer item list */
>  	void				(*li_cb)(struct xfs_buf *,
>  						 struct xfs_log_item *);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 9056c0f..76e0de7 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -45,7 +45,7 @@ xfs_ail_check(
>  	/*
>  	 * Check the next and previous entries are valid.
>  	 */
> -	ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
> +	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
>  	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
>  	if (&prev_lip->li_ail != &ailp->xa_ail)
>  		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
> @@ -653,7 +653,7 @@ xfs_trans_ail_update_bulk(
>  
>  	for (i = 0; i < nr_items; i++) {
>  		struct xfs_log_item *lip = log_items[i];
> -		if (lip->li_flags & XFS_LI_IN_AIL) {
> +		if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  			/* check if we really need to move the item */
>  			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
>  				continue;
> @@ -663,7 +663,7 @@ xfs_trans_ail_update_bulk(
>  			if (mlip == lip)
>  				mlip_changed = 1;
>  		} else {
> -			lip->li_flags |= XFS_LI_IN_AIL;
> +			set_bit(XFS_LI_IN_AIL, &lip->li_flags);
>  			trace_xfs_ail_insert(lip, 0, lsn);
>  		}
>  		lip->li_lsn = lsn;
> @@ -687,13 +687,13 @@ xfs_trans_ail_update_bulk(
>  bool
>  xfs_ail_delete_one(
>  	struct xfs_ail		*ailp,
> -	struct xfs_log_item 	*lip)
> +	struct xfs_log_item	*lip)
>  {
>  	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
>  
>  	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
>  	xfs_ail_delete(ailp, lip);
> -	lip->li_flags &= ~XFS_LI_IN_AIL;
> +	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
>  	lip->li_lsn = 0;
>  
>  	return mlip == lip;
> @@ -729,7 +729,7 @@ xfs_trans_ail_delete(
>  	struct xfs_mount	*mp = ailp->xa_mount;
>  	bool			mlip_changed;
>  
> -	if (!(lip->li_flags & XFS_LI_IN_AIL)) {
> +	if (!(test_bit(XFS_LI_IN_AIL, &lip->li_flags))) {
>  		spin_unlock(&ailp->xa_lock);
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 8ee29ca..15814b5 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -433,7 +433,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
>  		ASSERT(bp->b_pincount == 0);
>  ***/
>  		ASSERT(atomic_read(&bip->bli_refcount) == 0);
> -		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
> +		ASSERT(!(test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)));
>  		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
>  		xfs_buf_item_relse(bp);
>  	}
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index d91706c..82ea000 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -119,7 +119,7 @@ xfs_trans_ail_remove(
>  
>  	spin_lock(&ailp->xa_lock);
>  	/* xfs_trans_ail_delete() drops the AIL lock */
> -	if (lip->li_flags & XFS_LI_IN_AIL)
> +	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags))
>  		xfs_trans_ail_delete(ailp, lip, shutdown_type);
>  	else
>  		spin_unlock(&ailp->xa_lock);
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
