Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DAEC77B7F
	for <linux-xfs@archiver.kernel.org>; Fri, 12 May 2023 18:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbjELS0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 May 2023 14:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbjELS0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2023 14:26:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360FB3582
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2023 11:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0B2F657E4
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2023 18:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FF4C433D2;
        Fri, 12 May 2023 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683915896;
        bh=v6pwApmAVDa7vPP8e2TczA5g8XU4jLV+2gEsEknjRiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D/RORfNN9g7sxLqs0/ZwGF9dm/ttdtJC8xhHVNhyYWg+xpg7qzJl2VYci1N89PCzR
         fewadjgq1BKJ7eOIPGICinVcAaxNYmge77Q/ABAkxIn0mx3llaD+A2PbZM9L6e7Y3H
         kp+1ePgDZ/XSw0gtR9VBHk73ohyyJSFsKOPXqDXqqxg/8maib0ATnH4WzxhhaOdSq5
         shO+FdSdZQ0jqI4dkPmc0R3bei4hcR/w96ohwRFyOYT8CGnIbnBLr37jduqPx2t6Ik
         LK2B5KAn6DZwfBltqZ6ysUv0FavhBL+qG9PbGglc60SSC9Q84KhRu8Pp4s7NWTNvGc
         fo45hcRHiiOyw==
Date:   Fri, 12 May 2023 11:24:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Message-ID: <20230512182455.GJ858799@frogsfrogsfrogs>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424225102.23402-1-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sorry for the slow response, I thought Dave would've responded by now.

On Mon, Apr 24, 2023 at 03:51:02PM -0700, Wengang Wang wrote:
> To avoid possible deadlock when allocating AGFL blocks, change the behaviour.
> The orignal hehaviour for freeing extents in an EFI is that the extents in
> the EFI were processed one by one in the same transaction. When the second
> and subsequent extents are being processed, we have produced busy extents for
> previous extents. If the second and subsequent extents are from the same AG
> as the busy extents are, we have the risk of deadlock when allocating AGFL
> blocks. A typical calltrace for the deadlock is like this:

It's been a few weeks, so let me try to remember what this is all about.
You have one EFI containing multiple extents to free:

{agno: 3, agbno: X, ... }
{agno: 3, agbno: Y, ... }

AG 3 is nearly full, so we free the first extent (3/X), which adds it to
the bnobt, records the newly freed extent in the extentbusylist, and
attaches the record to the transaction's busy extent list.

Then we move on to the second record in the EFI item.  We want to free
(3/Y), but whoops the AGFL isn't big enough to handle maximal expansion
of the bnobt/cntbt btrees.

So we try to fix the AG 3 AGFL to be long enough.  We can find the space
in the bnobt, but the only space available is the (3/X) that we put
there during the last step.  That space is still(!) busy and still
attached to the transaction, so the CIL cannot clear it.  The AGFL fixer
sees that the space is busy, so it waits for it... and now we're dead in
the water.

The key to this deadlock is a thread waiting on its own uncommitted busy
extent, right?

> 
> 	#0	context_switch() kernel/sched/core.c:3881
> 	#1	__schedule() kernel/sched/core.c:5111
> 	#2	schedule() kernel/sched/core.c:5186
> 	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> 	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> 	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> 	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> 	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> 	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> 	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> 	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> 	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> 	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> 	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> 	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> 	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
> 	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> 	#17	mount_bdev() fs/super.c:1417
> 	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
> 	#19	legacy_get_tree() fs/fs_context.c:647
> 	#20	vfs_get_tree() fs/super.c:1547
> 	#21	do_new_mount() fs/namespace.c:2843
> 	#22	do_mount() fs/namespace.c:3163
> 	#23	ksys_mount() fs/namespace.c:3372
> 	#24	__do_sys_mount() fs/namespace.c:3386
> 	#25	__se_sys_mount() fs/namespace.c:3383
> 	#26	__x64_sys_mount() fs/namespace.c:3383
> 	#27	do_syscall_64() arch/x86/entry/common.c:296
> 	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
> 
> The deadlock could happen at both IO time and log recover time.
> 
> To avoid above deadlock, this patch changes the extent free procedure.
> 1) it always let the first extent from the EFI go (no change).
> 2) increase the (new) AG counter when it let a extent go.
> 3) for the 2nd+ extents, if the owning AGs ready have pending extents
>    don't let the extent go with current transaction. Instead, move the
>    extent in question and subsequent extents to a new EFI and try the new
>    EFI again with new transaction (by rolling current transaction).
> 4) for the EFD to orginal EFI, fill it with all the extents from the original
>    EFI.
> 5) though the new EFI is placed after original EFD, it's safe as they are in
>    same in-memory transaction.
> 6) The new AG counter for pending extent freeings is decremented after the
>    log items in in-memory transaction is committed to CIL.

So the solution you're proposing is a per-AG counter of however many
threads have started an EFI free.  If the second (or subsequent) EFI
free encounters an AG with a nonzero counter, it'll return EAGAIN to
cycle the transaction.  The cycling is critical to getting the busy
extent to the CIL so the log can process it and make it unbusy.  If the
AG wasn't contended (pag_nr_pending_extents was 0), it proceeds with the
freeing, having bumped the per-AG counter.  Right?

Therefore, the above deadlock sequence now becomes:

1. Free (3/X), placing (3/X) on the transaction's busy list.

2. Start trying to free (3/Y), notice that AG 3 has elevated
pag_nr_pending_extents, return EAGAIN

3. Roll transaction, which moves (3/X) to the CIL and gets us a fresh
transaction

4. Try to free (3/Y) again

At step 4, if pag_nr_pending_extents is still elevated, does that
mean we return EAGAIN and keep rolling the transaction until it's not
elevated?  Shouldn't we be able to proceed at step 4, even if we end up
waiting on the log to clear (3/X) from the busy list?

What happens if the log actually clears (3/X) from the busy list after
step 3 but then some other thread starts processing an EFI for (3/Z)?
Does that cause this thread to roll repeatedly waiting for another
thread's EFI to clear?

IOWs, I'm not sure we can always make forward progress with this scheme,
and I'd prefer to avoid introducing more global state.

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c    |   1 +
>  fs/xfs/libxfs/xfs_ag.h    |   5 ++
>  fs/xfs/xfs_extfree_item.c | 111 +++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_log_cil.c      |  24 ++++++++-
>  4 files changed, 138 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 86696a1c6891..61ef61e05668 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -378,6 +378,7 @@ xfs_initialize_perag(
>  		pag->pagb_tree = RB_ROOT;
>  #endif /* __KERNEL__ */
>  
> +		atomic_set(&pag->pag_nr_pending_extents, 0);
>  		error = xfs_buf_hash_init(pag);
>  		if (error)
>  			goto out_remove_pag;
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 5e18536dfdce..5950bc36a32c 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -82,6 +82,11 @@ struct xfs_perag {
>  	uint16_t	pag_sick;
>  	spinlock_t	pag_state_lock;
>  
> +	/*
> +	 * Number of concurrent extent freeings (not committed to CIL yet)
> +	 * on this AG.
> +	 */
> +	atomic_t	pag_nr_pending_extents;
>  	spinlock_t	pagb_lock;	/* lock for pagb_tree */
>  	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
>  	unsigned int	pagb_gen;	/* generation count for pagb_tree */
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 011b50469301..1dbf36d9c1c9 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -336,6 +336,75 @@ xfs_trans_get_efd(
>  	return efdp;
>  }
>  
> +/*
> + * Fill the EFD with all extents from the EFI and set the counter.
> + * Note: the EFD should comtain at least one extents already.
> + */
> +static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
> +{
> +	struct xfs_efi_log_item	*efip = efdp->efd_efip;
> +	uint			i;
> +
> +	i = efdp->efd_next_extent;
> +	ASSERT(i > 0);
> +	for (; i < efip->efi_format.efi_nextents; i++) {
> +		efdp->efd_format.efd_extents[i] =
> +			efip->efi_format.efi_extents[i];

Why is it necessary to fill the EFD mapping structures?  Nobody /ever/
looks at those; the only part that matters to log recovery is matching
efd.efd_efi_id to efi.efi_id.

But, I guess it looks funny to requeue an EFI and have the EFD for the
old EFI missing a bunch of fields.

> +	}
> +	efdp->efd_next_extent = i;
> +}
> +
> +/*
> + * Check if xefi is the first in the efip.
> + * Returns true if so, ad false otherwise
> + */
> +static bool xfs_is_first_extent_in_efi(struct xfs_efi_log_item *efip,
> +				  struct xfs_extent_free_item *xefi)
> +{
> +	return efip->efi_format.efi_extents[0].ext_start ==
> +					xefi->xefi_startblock;
> +}
> +
> +/*
> + * Check if the xefi needs to be in a new transaction.
> + * efip is the containing EFI of xefi.
> + * Return true if so, false otherwise.
> + */
> +static bool xfs_extent_free_need_new_trans(struct xfs_mount *mp,
> +				    struct xfs_efi_log_item *efip,
> +				    struct xfs_extent_free_item *xefi)
> +{
> +	bool			ret = true;
> +	int			nr_pre;
> +	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag;
> +
> +	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
> +	pag = xfs_perag_get(mp, agno);
> +	/* The first extent in EFI is always OK to go */
> +	if (xfs_is_first_extent_in_efi(efip, xefi)) {
> +		atomic_inc(&pag->pag_nr_pending_extents);
> +		ret = false;
> +		goto out_put;
> +	}
> +
> +	/*
> +	 * Now the extent is the 2nd or subsequent in the efip. We need
> +	 * new transaction if the AG already has busy extents pending.
> +	 */
> +	nr_pre = atomic_inc_return(&pag->pag_nr_pending_extents) - 1;
> +	/* No prevoius pending extent freeing to this AG */
> +	if (nr_pre == 0) {
> +		ret = false;
> +		goto out_put;
> +	}
> +
> +	atomic_dec(&pag->pag_nr_pending_extents);
> +out_put:
> +	xfs_perag_put(pag);
> +	return ret;
> +}
> +
>  /*
>   * Free an extent and log it to the EFD. Note that the transaction is marked
>   * dirty regardless of whether the extent free succeeds or fails to support the
> @@ -356,6 +425,28 @@ xfs_trans_free_extent(
>  	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
>  							xefi->xefi_startblock);
>  	int				error;
> +	struct xfs_efi_log_item		*efip = efdp->efd_efip;
> +
> +	if (xfs_extent_free_need_new_trans(mp, efip, xefi)) {
> +		/*
> +		 * This should be the 2nd+ extent, we don't have to mark the
> +		 * transaction and efd dirty, those are already done with the
> +		 * first extent.
> +		 */
> +		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
> +		ASSERT(tp->t_flags & XFS_TRANS_HAS_INTENT_DONE);
> +		ASSERT(test_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags));
> +
> +		xfs_fill_efd_with_efi(efdp);
> +
> +		/*
> +		 * A preious extent in same AG is processed with the current
> +		 * transaction. To avoid possible AGFL allocation deadlock,
> +		 * we roll the transaction and then restart with this extent
> +		 * with new transaction.
> +		 */
> +		return -EAGAIN;
> +	}
>  
>  	oinfo.oi_owner = xefi->xefi_owner;
>  	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
> @@ -369,6 +460,13 @@ xfs_trans_free_extent(
>  	error = __xfs_free_extent(tp, xefi->xefi_startblock,
>  			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
>  			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> +	if (error) {
> +		struct xfs_perag	*pag;
> +
> +		pag = xfs_perag_get(mp, agno);
> +		atomic_dec(&pag->pag_nr_pending_extents);
> +		xfs_perag_put(pag);
> +	}
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:
> @@ -476,7 +574,8 @@ xfs_extent_free_finish_item(

This function comes with an unused **state variable:

STATIC int
xfs_extent_free_finish_item(
	struct xfs_trans		*tp,
	struct xfs_log_item		*done,
	struct list_head		*item,
	struct xfs_btree_cur		**state)

What if, after each xfs_trans_free_extent call, we stuff *state with
xefi_startblock's AG?

Then, upon entry to xfs_extent_free_finish_item, we compare *state with
the xefi item and return EAGAIN if we're processing an EFI from the same
AG as the previous call to xfs_extent_free_finish_item?  Something like
this (totally untested):

STATIC int
xfs_extent_free_finish_item(
	struct xfs_trans		*tp,
	struct xfs_log_item		*done,
	struct list_head		*item,
	struct xfs_btree_cur		**state)
{
	struct xfs_extent_free_item	*xefi;
	int				error;

	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);

	if (*state) {
		struct xfs_perag	*oldpag = *(struct xfs_perag **)state;

		/*
		 * If we're freeing two extents from the same AG, we
		 * must roll the transaction between the two extents to
		 * avoid a livelock resulting from AGFL fixing waiting
		 * on the extent that we just freed to become unbusy.
		 */
		if (oldpag == xefi->xefi_pag) {
			xfs_fill_efd_with_efi(EFD_ITEM(done));
			xfs_perag_put(oldpag);
			return -EAGAIN;
		}
		xfs_perag_put(oldpag);
	}

	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
	if (!error)
		*state = (void *)xfs_perag_hold(xefi->xefi_pag);

	xfs_extent_free_put_group(xefi);
	kmem_cache_free(xfs_extfree_item_cache, xefi);
	return error;
}

Obviously, you now need a ->finish_cleanup function to drop the perag
reference that may be stashed in @state.  This (I think) avoids the
livelock by ensuring that xfs_trans_free_extent always starts with a
transaction that does not contain any busy extents from the same AG that
it's acting on, right?

A simpler version of the above would make it so that we always roll
between EFI records and don't have to manage perag references:

#define XFS_EFI_STATE_ROLL		((struct xfs_btree_cur *)1)
STATIC int
xfs_extent_free_finish_item(
	struct xfs_trans		*tp,
	struct xfs_log_item		*done,
	struct list_head		*item,
	struct xfs_btree_cur		**state)
{
	struct xfs_extent_free_item	*xefi;
	int				error;

	/*
	 * If we're freeing two extents, roll the transaction between
	 * the two extents to avoid a livelock resulting from AGFL
	 * fixing waiting on the extent that we just freed to become
	 * unbusy.  It's not necessary to roll if the previous and
	 * current EFI record point to different AGs, but this
	 * simplifies the state tracking.
	 */
	if (*state == XFS_EFI_STATE_ROLL) {
		xfs_fill_efd_with_efi(EFD_ITEM(done));
		*state = NULL;
		return -EAGAIN;
	}

	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);

	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
	if (!error)
		*state = XFS_EFI_STATE_ROLL;

	xfs_extent_free_put_group(xefi);
	kmem_cache_free(xfs_extfree_item_cache, xefi);
	return error;
}

(Did you and Dave already talk about this?)

--D

>  	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
>  
>  	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> -	kmem_cache_free(xfs_extfree_item_cache, xefi);
> +	if (error != -EAGAIN)
> +		kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
>  }
>  
> @@ -632,7 +731,15 @@ xfs_efi_item_recover(
>  		fake.xefi_startblock = extp->ext_start;
>  		fake.xefi_blockcount = extp->ext_len;
>  
> -		error = xfs_trans_free_extent(tp, efdp, &fake);
> +		if (error == 0)
> +			error = xfs_trans_free_extent(tp, efdp, &fake);
> +
> +		if (error == -EAGAIN) {
> +			ASSERT(i > 0);
> +			xfs_free_extent_later(tp, fake.xefi_startblock,
> +			fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
> +			continue;
> +		}
>  		if (error == -EFSCORRUPTED)
>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  					extp, sizeof(*extp));
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index eccbfb99e894..97eda4487db0 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -16,6 +16,7 @@
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_trace.h"
> +#include "xfs_ag.h"
>  
>  struct workqueue_struct *xfs_discard_wq;
>  
> @@ -643,8 +644,29 @@ xlog_cil_insert_items(
>  		cilpcp->space_used += len;
>  	}
>  	/* attach the transaction to the CIL if it has any busy extents */
> -	if (!list_empty(&tp->t_busy))
> +	if (!list_empty(&tp->t_busy)) {
> +		struct xfs_perag	*last_pag = NULL;
> +		xfs_agnumber_t		last_agno = -1;
> +		struct xfs_extent_busy	*ebp;
> +
> +		/*
> +		 * Pending extent freeings are committed to CIL, now it's
> +		 * to let other extent freeing on same AG go.
> +		 */
> +		list_for_each_entry(ebp, &tp->t_busy, list) {
> +			if (ebp->agno != last_agno) {
> +				last_agno = ebp->agno;
> +				if (last_pag)
> +					xfs_perag_put(last_pag);
> +				last_pag = xfs_perag_get(tp->t_mountp, last_agno);
> +			}
> +			atomic_dec(&last_pag->pag_nr_pending_extents);
> +		}
> +		if (last_pag)
> +			xfs_perag_put(last_pag);
> +
>  		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
> +	}
>  
>  	/*
>  	 * Now update the order of everything modified in the transaction
> -- 
> 2.21.0 (Apple Git-122.2)
> 
