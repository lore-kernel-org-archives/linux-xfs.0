Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbeEGMQz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 08:16:55 -0400
Date: Mon, 7 May 2018 08:16:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/10] xfs: log item flags are racy
Message-ID: <20180507121652.GB38916@bfoster.bfoster>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502080157.11386-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 02, 2018 at 06:01:48PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The log item flags contain a field that is protected by the AIL
> lock - the XFS_LI_IN_AIL flag. We use non-atomic RMW operations to
> set and clear these flags, but most of the updates and checks are
> not done with the AIL lock held and so are susceptible to update
> races.
> 
> Fix this by changing the log item flags to use atomic bitops rather
> than be reliant on the AIL lock for update serialisation.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_item.c     |  4 ++--
>  fs/xfs/xfs_buf_item.c      |  4 +++-
>  fs/xfs/xfs_dquot.c         |  7 +++----
>  fs/xfs/xfs_dquot_item.c    |  2 +-
>  fs/xfs/xfs_extfree_item.c  |  4 ++--
>  fs/xfs/xfs_icache.c        |  3 ++-
>  fs/xfs/xfs_icreate_item.c  |  2 +-
>  fs/xfs/xfs_inode.c         |  4 ++--
>  fs/xfs/xfs_inode_item.c    |  8 ++++----
>  fs/xfs/xfs_log.c           |  2 +-
>  fs/xfs/xfs_qm.c            |  2 +-
>  fs/xfs/xfs_refcount_item.c |  4 ++--
>  fs/xfs/xfs_rmap_item.c     |  4 ++--
>  fs/xfs/xfs_trace.h         |  6 +++---
>  fs/xfs/xfs_trans.c         |  4 ++--
>  fs/xfs/xfs_trans.h         | 19 ++++++++++++-------
>  fs/xfs/xfs_trans_ail.c     |  9 ++++-----
>  fs/xfs/xfs_trans_buf.c     |  2 +-
>  fs/xfs/xfs_trans_priv.h    | 10 ++++------
>  19 files changed, 52 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 2203465e63ea..618bb71535c8 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -160,7 +160,7 @@ STATIC void
>  xfs_bui_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_bui_release(BUI_ITEM(lip));
>  }
>  
> @@ -305,7 +305,7 @@ xfs_bud_item_unlock(
>  {
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
>  
> -	if (lip->li_flags & XFS_LI_ABORTED) {
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
>  		xfs_bui_release(budp->bud_buip);
>  		kmem_zone_free(xfs_bud_zone, budp);
>  	}
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 76b21f780af8..53c07a7a14fb 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -545,13 +545,15 @@ xfs_buf_item_unlock(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	bool			aborted = !!(lip->li_flags & XFS_LI_ABORTED);
> +	bool			aborted;
>  	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
>  	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
>  #endif
>  
> +	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
> +
>  	/* Clear the buffer's association with this transaction. */
>  	bp->b_transp = NULL;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a7daef9e16bf..d0b65679baae 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -913,9 +913,9 @@ xfs_qm_dqflush_done(
>  	 * since it's cheaper, and then we recheck while
>  	 * holding the lock before removing the dquot from the AIL.
>  	 */
> -	if ((lip->li_flags & XFS_LI_IN_AIL) &&
> +	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
>  	    ((lip->li_lsn == qip->qli_flush_lsn) ||
> -	     (lip->li_flags & XFS_LI_FAILED))) {
> +	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
>  
>  		/* xfs_trans_ail_delete() drops the AIL lock. */
>  		spin_lock(&ailp->ail_lock);
> @@ -926,8 +926,7 @@ xfs_qm_dqflush_done(
>  			 * Clear the failed state since we are about to drop the
>  			 * flush lock
>  			 */
> -			if (lip->li_flags & XFS_LI_FAILED)
> -				xfs_clear_li_failed(lip);
> +			xfs_clear_li_failed(lip);
>  			spin_unlock(&ailp->ail_lock);
>  		}
>  	}
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 4b331e354da7..57df98122156 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -173,7 +173,7 @@ xfs_qm_dquot_logitem_push(
>  	 * The buffer containing this item failed to be written back
>  	 * previously. Resubmit the buffer for IO
>  	 */
> -	if (lip->li_flags & XFS_LI_FAILED) {
> +	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
>  		if (!xfs_buf_trylock(bp))
>  			return XFS_ITEM_LOCKED;
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index b5b1e567b9f4..70b7d48af6d6 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -168,7 +168,7 @@ STATIC void
>  xfs_efi_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_efi_release(EFI_ITEM(lip));
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
> index 8cb2ad1cc2ec..fb37ada55710 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -107,7 +107,8 @@ xfs_inode_free_callback(
>  		xfs_idestroy_fork(ip, XFS_COW_FORK);
>  
>  	if (ip->i_itemp) {
> -		ASSERT(!(ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL));
> +		ASSERT(!test_bit(XFS_LI_IN_AIL,
> +				 &ip->i_itemp->ili_item.li_flags));
>  		xfs_inode_item_destroy(ip);
>  		ip->i_itemp = NULL;
>  	}
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 865ad1373e5e..a99a0f8aa528 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -91,7 +91,7 @@ xfs_icreate_item_unlock(
>  {
>  	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
>  
> -	if (icp->ic_item.li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		kmem_zone_free(xfs_icreate_zone, icp);
>  	return;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index bdd92c18a4f3..2cb294e608a0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -498,7 +498,7 @@ xfs_lock_inodes(
>  		if (!try_lock) {
>  			for (j = (i - 1); j >= 0 && !try_lock; j--) {
>  				lp = (xfs_log_item_t *)ips[j]->i_itemp;
> -				if (lp && (lp->li_flags & XFS_LI_IN_AIL))
> +				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
>  					try_lock++;
>  			}
>  		}
> @@ -598,7 +598,7 @@ xfs_lock_two_inodes(
>  	 * and try again.
>  	 */
>  	lp = (xfs_log_item_t *)ip0->i_itemp;
> -	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
> +	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
>  		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
>  			xfs_iunlock(ip0, ip0_mode);
>  			if ((++attempts % 5) == 0)
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 34b91b789702..3e5b8574818e 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -518,7 +518,7 @@ xfs_inode_item_push(
>  	 * The buffer containing this item failed to be written back
>  	 * previously. Resubmit the buffer for IO.
>  	 */
> -	if (lip->li_flags & XFS_LI_FAILED) {
> +	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
>  		if (!xfs_buf_trylock(bp))
>  			return XFS_ITEM_LOCKED;
>  
> @@ -729,14 +729,14 @@ xfs_iflush_done(
>  		 */
>  		iip = INODE_ITEM(blip);
>  		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> -		    (blip->li_flags & XFS_LI_FAILED))
> +		    test_bit(XFS_LI_FAILED, &blip->li_flags))
>  			need_ail++;
>  	}
>  
>  	/* make sure we capture the state of the initial inode. */
>  	iip = INODE_ITEM(lip);
>  	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
> -	    lip->li_flags & XFS_LI_FAILED)
> +	    test_bit(XFS_LI_FAILED, &lip->li_flags))
>  		need_ail++;
>  
>  	/*
> @@ -803,7 +803,7 @@ xfs_iflush_abort(
>  	xfs_inode_log_item_t	*iip = ip->i_itemp;
>  
>  	if (iip) {
> -		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
> +		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
>  			xfs_trans_ail_remove(&iip->ili_item,
>  					     stale ? SHUTDOWN_LOG_IO_ERROR :
>  						     SHUTDOWN_CORRUPT_INCORE);
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2fcd9ed5d075..e427864434c1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2132,7 +2132,7 @@ xlog_print_trans(
>  
>  		xfs_warn(mp, "log item: ");
>  		xfs_warn(mp, "  type	= 0x%x", lip->li_type);
> -		xfs_warn(mp, "  flags	= 0x%x", lip->li_flags);
> +		xfs_warn(mp, "  flags	= 0x%lx", lip->li_flags);
>  		if (!lv)
>  			continue;
>  		xfs_warn(mp, "  niovecs	= %d", lv->lv_niovecs);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index aff4924f637f..f93bf427d2da 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -173,7 +173,7 @@ xfs_qm_dqpurge(
>  
>  	ASSERT(atomic_read(&dqp->q_pincount) == 0);
>  	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
> -	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
> +		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
>  
>  	xfs_dqfunlock(dqp);
>  	xfs_dqunlock(dqp);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 15c9393dd7a7..e5866b714d5f 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -159,7 +159,7 @@ STATIC void
>  xfs_cui_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_cui_release(CUI_ITEM(lip));
>  }
>  
> @@ -310,7 +310,7 @@ xfs_cud_item_unlock(
>  {
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
>  
> -	if (lip->li_flags & XFS_LI_ABORTED) {
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
>  		xfs_cui_release(cudp->cud_cuip);
>  		kmem_zone_free(xfs_cud_zone, cudp);
>  	}
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 06a07846c9b3..e5b5b3e7ef82 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -158,7 +158,7 @@ STATIC void
>  xfs_rui_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
>  		xfs_rui_release(RUI_ITEM(lip));
>  }
>  
> @@ -331,7 +331,7 @@ xfs_rud_item_unlock(
>  {
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  
> -	if (lip->li_flags & XFS_LI_ABORTED) {
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
>  		xfs_rui_release(rudp->rud_ruip);
>  		kmem_zone_free(xfs_rud_zone, rudp);
>  	}
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8955254b900e..7f4d961fae12 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -442,7 +442,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__field(int, bli_refcount)
>  		__field(unsigned, bli_flags)
>  		__field(void *, li_desc)
> -		__field(unsigned, li_flags)
> +		__field(unsigned long, li_flags)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = bip->bli_buf->b_target->bt_dev;
> @@ -1018,7 +1018,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
>  		__field(dev_t, dev)
>  		__field(void *, lip)
>  		__field(uint, type)
> -		__field(uint, flags)
> +		__field(unsigned long, flags)
>  		__field(xfs_lsn_t, lsn)
>  	),
>  	TP_fast_assign(
> @@ -1070,7 +1070,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
>  		__field(dev_t, dev)
>  		__field(void *, lip)
>  		__field(uint, type)
> -		__field(uint, flags)
> +		__field(unsigned long, flags)
>  		__field(xfs_lsn_t, old_lsn)
>  		__field(xfs_lsn_t, new_lsn)
>  	),
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index d6d8f9d129a7..c6a2a3cb9df5 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -790,7 +790,7 @@ xfs_trans_free_items(
>  		if (commit_lsn != NULLCOMMITLSN)
>  			lip->li_ops->iop_committing(lip, commit_lsn);
>  		if (abort)
> -			lip->li_flags |= XFS_LI_ABORTED;
> +			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  		lip->li_ops->iop_unlock(lip);
>  
>  		xfs_trans_free_item_desc(lidp);
> @@ -861,7 +861,7 @@ xfs_trans_committed_bulk(
>  		xfs_lsn_t		item_lsn;
>  
>  		if (aborted)
> -			lip->li_flags |= XFS_LI_ABORTED;
> +			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  		item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
>  
>  		/* item_lsn of -1 means the item needs no further processing */
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 9d542dfe0052..51145ddf7e5b 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -48,7 +48,7 @@ typedef struct xfs_log_item {
>  	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
>  	struct xfs_ail			*li_ailp;	/* ptr to AIL */
>  	uint				li_type;	/* item type */
> -	uint				li_flags;	/* misc flags */
> +	unsigned long			li_flags;	/* misc flags */
>  	struct xfs_buf			*li_buf;	/* real buffer pointer */
>  	struct list_head		li_bio_list;	/* buffer item list */
>  	void				(*li_cb)(struct xfs_buf *,
> @@ -64,14 +64,19 @@ typedef struct xfs_log_item {
>  	xfs_lsn_t			li_seq;		/* CIL commit seq */
>  } xfs_log_item_t;
>  
> -#define	XFS_LI_IN_AIL	0x1
> -#define	XFS_LI_ABORTED	0x2
> -#define	XFS_LI_FAILED	0x4
> +/*
> + * li_flags use the (set/test/clear)_bit atomic interfaces because updates can
> + * race with each other and we don't want to have to use the AIL lock to
> + * serialise all updates.
> + */
> +#define	XFS_LI_IN_AIL	0
> +#define	XFS_LI_ABORTED	1
> +#define	XFS_LI_FAILED	2
>  
>  #define XFS_LI_FLAGS \
> -	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
> -	{ XFS_LI_ABORTED,	"ABORTED" }, \
> -	{ XFS_LI_FAILED,	"FAILED" }
> +	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
> +	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
> +	{ (1 << XFS_LI_FAILED),		"FAILED" }
>  
>  struct xfs_item_ops {
>  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index d4a2445215e6..50611d2bcbc2 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -46,7 +46,7 @@ xfs_ail_check(
>  	/*
>  	 * Check the next and previous entries are valid.
>  	 */
> -	ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
> +	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
>  	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
>  	if (&prev_lip->li_ail != &ailp->ail_head)
>  		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
> @@ -684,7 +684,7 @@ xfs_trans_ail_update_bulk(
>  
>  	for (i = 0; i < nr_items; i++) {
>  		struct xfs_log_item *lip = log_items[i];
> -		if (lip->li_flags & XFS_LI_IN_AIL) {
> +		if (test_and_set_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  			/* check if we really need to move the item */
>  			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
>  				continue;
> @@ -694,7 +694,6 @@ xfs_trans_ail_update_bulk(
>  			if (mlip == lip)
>  				mlip_changed = 1;
>  		} else {
> -			lip->li_flags |= XFS_LI_IN_AIL;
>  			trace_xfs_ail_insert(lip, 0, lsn);
>  		}
>  		lip->li_lsn = lsn;
> @@ -725,7 +724,7 @@ xfs_ail_delete_one(
>  	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
>  	xfs_ail_delete(ailp, lip);
>  	xfs_clear_li_failed(lip);
> -	lip->li_flags &= ~XFS_LI_IN_AIL;
> +	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
>  	lip->li_lsn = 0;
>  
>  	return mlip == lip;
> @@ -761,7 +760,7 @@ xfs_trans_ail_delete(
>  	struct xfs_mount	*mp = ailp->ail_mount;
>  	bool			mlip_changed;
>  
> -	if (!(lip->li_flags & XFS_LI_IN_AIL)) {
> +	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index b26c5973da90..88557dfea21f 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -442,7 +442,7 @@ xfs_trans_brelse(
>  		ASSERT(bp->b_pincount == 0);
>  ***/
>  		ASSERT(atomic_read(&bip->bli_refcount) == 0);
> -		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
> +		ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
>  		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
>  		xfs_buf_item_relse(bp);
>  	}
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index be24b0c8a332..43f773297b9d 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -119,7 +119,7 @@ xfs_trans_ail_remove(
>  
>  	spin_lock(&ailp->ail_lock);
>  	/* xfs_trans_ail_delete() drops the AIL lock */
> -	if (lip->li_flags & XFS_LI_IN_AIL)
> +	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags))
>  		xfs_trans_ail_delete(ailp, lip, shutdown_type);
>  	else
>  		spin_unlock(&ailp->ail_lock);
> @@ -171,11 +171,10 @@ xfs_clear_li_failed(
>  {
>  	struct xfs_buf	*bp = lip->li_buf;
>  
> -	ASSERT(lip->li_flags & XFS_LI_IN_AIL);
> +	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
>  	lockdep_assert_held(&lip->li_ailp->ail_lock);
>  
> -	if (lip->li_flags & XFS_LI_FAILED) {
> -		lip->li_flags &= ~XFS_LI_FAILED;
> +	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags)) {
>  		lip->li_buf = NULL;
>  		xfs_buf_rele(bp);
>  	}
> @@ -188,9 +187,8 @@ xfs_set_li_failed(
>  {
>  	lockdep_assert_held(&lip->li_ailp->ail_lock);
>  
> -	if (!(lip->li_flags & XFS_LI_FAILED)) {
> +	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags)) {
>  		xfs_buf_hold(bp);
> -		lip->li_flags |= XFS_LI_FAILED;
>  		lip->li_buf = bp;
>  	}
>  }
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
