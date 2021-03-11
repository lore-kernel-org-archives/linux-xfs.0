Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCADC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7303464E77
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCKBPL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 20:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCKBPH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 20:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D763564E77;
        Thu, 11 Mar 2021 01:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615425307;
        bh=jAa/pi5t3DFRYAGhnd36XTy1+ZkK4exkr8vail6wR/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VEwSTrBN0VKy5oUi6i7mlGz3rrIbJJATyskoPLObXi9HOhEiIGBeceV1n9aji6KB1
         73BhwXiLT7zwVnTTxiM3Wz/O5Ubm0eRvIrAptF+CETTqbZOOT/dtvjcyfITLxWoF/Q
         7AJYF7U9rvCrACNj10ZzK8u3G8PrGCb/ZQWuRbJVlEFoES5sLl+RSx1R/bt0kc/2jl
         l4cYCxAQqc/hf9N2dpbz/L7O2kGpAK5MrLa48edODKEk2yqnrQjbCylvw7SF8ejFl1
         D4SNWTdIh8pjavNDS2bL7rg/x++kd39SjEwpXnCQNjNwpx4HyzxkVov5bFVQ3Fwop6
         uwWAxUY0PU0gg==
Date:   Wed, 10 Mar 2021 17:15:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/45] xfs: convert CIL to unordered per cpu lists
Message-ID: <20210311011505.GN3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-41-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-41-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:38PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So that we can remove the cil_lock which is a global serialisation
> point. We've already got ordering sorted, so all we need to do is
> treat the CIL list like the busy extent list and reconstruct it
> before the push starts.
> 
> This is what we're trying to avoid:
> 
>  -   75.35%     1.83%  [kernel]            [k] xfs_log_commit_cil
>     - 46.35% xfs_log_commit_cil
>        - 41.54% _raw_spin_lock
>           - 67.30% do_raw_spin_lock
>                66.96% __pv_queued_spin_lock_slowpath
> 
> Which happens on a 32p system when running a 32-way 'rm -rf'
> workload. After this patch:
> 
> -   20.90%     3.23%  [kernel]               [k] xfs_log_commit_cil
>    - 17.67% xfs_log_commit_cil
>       - 6.51% xfs_log_ticket_ungrant
>            1.40% xfs_log_space_wake
>         2.32% memcpy_erms
>       - 2.18% xfs_buf_item_committing
>          - 2.12% xfs_buf_item_release
>             - 1.03% xfs_buf_unlock
>                  0.96% up
>               0.72% xfs_buf_rele
>         1.33% xfs_inode_item_format
>         1.19% down_read
>         0.91% up_read
>         0.76% xfs_buf_item_format
>       - 0.68% kmem_alloc_large
>          - 0.67% kmem_alloc
>               0.64% __kmalloc
>         0.50% xfs_buf_item_size
> 
> It kinda looks like the workload is running out of log space all
> the time. But all the spinlock contention is gone and the
> transaction commit rate has gone from 800k/s to 1.3M/s so the amount
> of real work being done has gone up a *lot*.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 61 ++++++++++++++++++++-----------------------
>  fs/xfs/xfs_log_priv.h |  2 --
>  2 files changed, 29 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 7420389f4cee..3d43a5088154 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -448,10 +448,9 @@ xlog_cil_insert_items(
>  	/*
>  	 * We need to take the CIL checkpoint unit reservation on the first
>  	 * commit into the CIL. Test the XLOG_CIL_EMPTY bit first so we don't
> -	 * unnecessarily do an atomic op in the fast path here. We don't need to
> -	 * hold the xc_cil_lock here to clear the XLOG_CIL_EMPTY bit as we are
> -	 * under the xc_ctx_lock here and that needs to be held exclusively to
> -	 * reset the XLOG_CIL_EMPTY bit.
> +	 * unnecessarily do an atomic op in the fast path here. We can clear the
> +	 * XLOG_CIL_EMPTY bit as we are under the xc_ctx_lock here and that
> +	 * needs to be held exclusively to reset the XLOG_CIL_EMPTY bit.
>  	 */
>  	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) &&
>  	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
> @@ -505,24 +504,6 @@ xlog_cil_insert_items(
>  	/* attach the transaction to the CIL if it has any busy extents */
>  	if (!list_empty(&tp->t_busy))
>  		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
> -	put_cpu_ptr(cilpcp);
> -
> -	/*
> -	 * If we've overrun the reservation, dump the tx details before we move
> -	 * the log items. Shutdown is imminent...
> -	 */
> -	tp->t_ticket->t_curr_res -= ctx_res + len;
> -	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
> -		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
> -		xfs_warn(log->l_mp,
> -			 "  log items: %d bytes (iov hdrs: %d bytes)",
> -			 len, iovhdr_res);
> -		xfs_warn(log->l_mp, "  split region headers: %d bytes",
> -			 split_res);
> -		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
> -		xlog_print_trans(tp);
> -	}
> -
>  	/*
>  	 * Now update the order of everything modified in the transaction
>  	 * and insert items into the CIL if they aren't already there.
> @@ -530,7 +511,6 @@ xlog_cil_insert_items(
>  	 * the transaction commit.
>  	 */
>  	order = atomic_inc_return(&ctx->order_id);
> -	spin_lock(&cil->xc_cil_lock);
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  
>  		/* Skip items which aren't dirty in this transaction. */
> @@ -540,10 +520,26 @@ xlog_cil_insert_items(
>  		lip->li_order_id = order;
>  		if (!list_empty(&lip->li_cil))
>  			continue;
> -		list_add(&lip->li_cil, &cil->xc_cil);
> +		list_add(&lip->li_cil, &cilpcp->log_items);

Ok, so if I understand this correctly -- every time a transaction
commits, it marks every dirty log item with a monotonically increasing
counter.  If the log item isn't already on another CPU's CIL list, it
gets added to the current CPU's CIL list...

> +	}
> +	put_cpu_ptr(cilpcp);
> +
> +	/*
> +	 * If we've overrun the reservation, dump the tx details before we move
> +	 * the log items. Shutdown is imminent...
> +	 */
> +	tp->t_ticket->t_curr_res -= ctx_res + len;
> +	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
> +		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
> +		xfs_warn(log->l_mp,
> +			 "  log items: %d bytes (iov hdrs: %d bytes)",
> +			 len, iovhdr_res);
> +		xfs_warn(log->l_mp, "  split region headers: %d bytes",
> +			 split_res);
> +		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
> +		xlog_print_trans(tp);
>  	}
>  
> -	spin_unlock(&cil->xc_cil_lock);
>  
>  	if (tp->t_ticket->t_curr_res < 0)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> @@ -806,6 +802,7 @@ xlog_cil_push_work(
>  	bool			commit_iclog_sync = false;
>  	int			cpu;
>  	struct xlog_cil_pcp	*cilpcp;
> +	LIST_HEAD		(log_items);
>  
>  	new_ctx = xlog_cil_ctx_alloc();
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -822,6 +819,9 @@ xlog_cil_push_work(
>  			list_splice_init(&cilpcp->busy_extents,
>  					&ctx->busy_extents);
>  		}
> +		if (!list_empty(&cilpcp->log_items)) {
> +			list_splice_init(&cilpcp->log_items, &log_items);

...and then at CIL push time, we splice each per-CPU list into a big
list, sort the dirty log items by counter number, and process them.

The first thought I had was that it's a darn shame that _insert_items
can't steal a log item from another CPU's CIL list, because you could
then mergesort the per-CPU CIL lists into @log_items.  Unfortunately, I
don't think there's a safe way to steal items from a per-CPU list
without involving locks.

The second thought I had was that we have the xfs_pwork mechanism for
launching a bunch of worker threads.  A pwork workqueue is (probably)
too costly when the item list is short or there aren't that many CPUs,
but once list_sort starts getting painful, would it be faster to launch
a bunch of threads in push_work to sort each per-CPU list and then merge
sort them into the final list?

FWIW at least mechanically, the last two patches look reasonable to me.

--D

> +		}
>  	}
>  
>  	spin_lock(&cil->xc_push_lock);
> @@ -907,12 +907,12 @@ xlog_cil_push_work(
>  	 * needed on the transaction commit side which is currently locked out
>  	 * by the flush lock.
>  	 */
> -	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
> +	list_sort(NULL, &log_items, xlog_cil_order_cmp);
>  	lv = NULL;
> -	while (!list_empty(&cil->xc_cil)) {
> +	while (!list_empty(&log_items)) {
>  		struct xfs_log_item	*item;
>  
> -		item = list_first_entry(&cil->xc_cil,
> +		item = list_first_entry(&log_items,
>  					struct xfs_log_item, li_cil);
>  		list_del_init(&item->li_cil);
>  		item->li_order_id = 0;
> @@ -1099,7 +1099,6 @@ xlog_cil_push_background(
>  	 * The cil won't be empty because we are called while holding the
>  	 * context lock so whatever we added to the CIL will still be there.
>  	 */
> -	ASSERT(!list_empty(&cil->xc_cil));
>  	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
>  
>  	/*
> @@ -1491,6 +1490,7 @@ xlog_cil_pcp_alloc(
>  	for_each_possible_cpu(cpu) {
>  		cilpcp = per_cpu_ptr(pcptr, cpu);
>  		INIT_LIST_HEAD(&cilpcp->busy_extents);
> +		INIT_LIST_HEAD(&cilpcp->log_items);
>  	}
>  
>  	if (xlog_cil_pcp_hpadd(cil) < 0) {
> @@ -1531,9 +1531,7 @@ xlog_cil_init(
>  		return -ENOMEM;
>  	}
>  
> -	INIT_LIST_HEAD(&cil->xc_cil);
>  	INIT_LIST_HEAD(&cil->xc_committing);
> -	spin_lock_init(&cil->xc_cil_lock);
>  	spin_lock_init(&cil->xc_push_lock);
>  	init_waitqueue_head(&cil->xc_push_wait);
>  	init_rwsem(&cil->xc_ctx_lock);
> @@ -1559,7 +1557,6 @@ xlog_cil_destroy(
>  		kmem_free(cil->xc_ctx);
>  	}
>  
> -	ASSERT(list_empty(&cil->xc_cil));
>  	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
>  	xlog_cil_pcp_free(cil, cil->xc_pcp);
>  	kmem_free(cil);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 92d9e1a03a07..12a1a36eef7e 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -262,8 +262,6 @@ struct xfs_cil {
>  	struct xlog		*xc_log;
>  	unsigned long		xc_flags;
>  	atomic_t		xc_iclog_hdrs;
> -	struct list_head	xc_cil;
> -	spinlock_t		xc_cil_lock;
>  
>  	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
>  	struct xfs_cil_ctx	*xc_ctx;
> -- 
> 2.28.0
> 
