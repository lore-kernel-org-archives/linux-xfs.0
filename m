Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E9AC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiF1ULu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiF1ULe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B69D44750
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D73AB81855
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9146C3411D;
        Tue, 28 Jun 2022 20:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656446488;
        bh=GKDUhHZM2zsFGjDO+4MMKWB7GDDsFyROqC8fNmo7CjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=afACCoMWMLCjFFSLhqsBQpIdIE200Oqx05Ugcb0Bglr1C8twboqnzlO3pIwFHwWkF
         owd/TXwUqcloTVkbkBrCdkginexYwBu5hNua3hDSN5Sz1wmkgCszhsA1OBW0O0OlzE
         wc5K2kHlwpGgzPFVjx/7mvOMxRBhNTVKfT08p7bDP2VLT99NKeMVEvmHKEugiFJ3cE
         6KEHcQuIY+PZcgj65J2csc2Jr23Or/YrniNC9gFMAf08t8/fwmJjEPZc+OkT6Lzg2u
         pFy68kE/O0XjfOArzlQn+iaeytPBn6mSMiAYVPvsfNsaYsUk5PZnywAupQt0noR9K8
         y2tL+Mlt3LQbA==
Date:   Tue, 28 Jun 2022 13:01:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: implement percpu cil space used calculation
Message-ID: <YrteGNbRaCqLOY6g@magnolia>
References: <20220615075330.3651541-1-david@fromorbit.com>
 <20220615075330.3651541-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615075330.3651541-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 15, 2022 at 05:53:21PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have the CIL percpu structures in place, implement the
> space used counter as a per-cpu counter.
> 
> We have to be really careful now about ensuring that the checks and
> updates run without arbitrary delays, which means they need to run
> with pre-emption disabled. We do this by careful placement of
> the get_cpu_ptr/put_cpu_ptr calls to access the per-cpu structures
> for that CPU.
> 
> We need to be able to reliably detect that the CIL has reached
> the hard limit threshold so we can take extra reservations for the
> iclog headers when the space used overruns the original reservation.
> hence we factor out xlog_cil_over_hard_limit() from
> xlog_cil_push_background().
> 
> The global CIL space used is an atomic variable that is backed by
> per-cpu aggregation to minimise the number of atomic updates we do
> to the global state in the fast path. While we are under the soft
> limit, we aggregate only when the per-cpu aggregation is over the
> proportion of the soft limit assigned to that CPU. This means that
> all CPUs can use all but one byte of their aggregation threshold
> and we will not go over the soft limit.
> 
> Hence once we detect that we've gone over both a per-cpu aggregation
> threshold and the soft limit, we know that we have only
> exceeded the soft limit by one per-cpu aggregation threshold. Even
> if all CPUs hit this at the same time, we can't be over the hard
> limit, so we can run an aggregation back into the atomic counter
> at this point and still be under the hard limit.
> 
> At this point, we will be over the soft limit and hence we'll
> aggregate into the global atomic used space directly rather than the
> per-cpu counters, hence providing accurate detection of hard limit
> excursion for accounting and reservation purposes.
> 
> Hence we get the best of both worlds - lockless, scalable per-cpu
> fast path plus accurate, atomic detection of hard limit excursion.
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 176 +++++++++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_log_priv.h |   4 +-
>  2 files changed, 149 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index c6d6322aabaa..2d16add7a8d4 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -108,6 +108,64 @@ xlog_cil_ctx_alloc(void)
>  	return ctx;
>  }
>  
> +/*
> + * Aggregate the CIL per cpu structures into global counts, lists, etc and
> + * clear the percpu state ready for the next context to use. This is called
> + * from the push code with the context lock held exclusively, hence nothing else
> + * will be accessing or modifying the per-cpu counters.
> + */
> +static void
> +xlog_cil_push_pcp_aggregate(
> +	struct xfs_cil		*cil,
> +	struct xfs_cil_ctx	*ctx)
> +{
> +	struct xlog_cil_pcp	*cilpcp;
> +	int			cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +
> +		/*
> +		 * We're in the middle of switching cil contexts.  Reset the
> +		 * counter we use to detect when the current context is nearing
> +		 * full.
> +		 */
> +		cilpcp->space_used = 0;
> +	}
> +}
> +
> +/*
> + * Aggregate the CIL per-cpu space used counters into the global atomic value.
> + * This is called when the per-cpu counter aggregation will first pass the soft
> + * limit threshold so we can switch to atomic counter aggregation for accurate
> + * detection of hard limit traversal.
> + */
> +static void
> +xlog_cil_insert_pcp_aggregate(
> +	struct xfs_cil		*cil,
> +	struct xfs_cil_ctx	*ctx)
> +{
> +	struct xlog_cil_pcp	*cilpcp;
> +	int			cpu;
> +	int			count = 0;
> +
> +	/* Trigger atomic updates then aggregate only for the first caller */
> +	if (!test_and_clear_bit(XLOG_CIL_PCP_SPACE, &cil->xc_flags))

Hmm, this patch has changed a bit since the last time I looked at it.

Last time, IIRC, each CIL context gets a certain amount of space, and
then you split that space evenly among the running CPUs; after we hit
certain thresholds (the overall cil context has used more than the
background push threshold; or this cpu's cil context has used more space
than blocking push threshold divided by cpu count) we make everyone use
the slow accounting.  Now I guess you've changed it a bit...

> +		return;
> +
> +	for_each_online_cpu(cpu) {
> +		int	old, prev;
> +
> +		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +		do {
> +			old = cilpcp->space_used;
> +			prev = cmpxchg(&cilpcp->space_used, old, 0);
> +		} while (old != prev);
> +		count += old;
> +	}
> +	atomic_add(count, &ctx->space_used);
> +}
> +
>  static void
>  xlog_cil_ctx_switch(
>  	struct xfs_cil		*cil,
> @@ -115,6 +173,7 @@ xlog_cil_ctx_switch(
>  {
>  	xlog_cil_set_iclog_hdr_count(cil);
>  	set_bit(XLOG_CIL_EMPTY, &cil->xc_flags);
> +	set_bit(XLOG_CIL_PCP_SPACE, &cil->xc_flags);
>  	ctx->sequence = ++cil->xc_current_sequence;
>  	ctx->cil = cil;
>  	cil->xc_ctx = ctx;
> @@ -447,6 +506,23 @@ xlog_cil_insert_format_items(
>  	}
>  }
>  
> +/*
> + * The use of lockless waitqueue_active() requires that the caller has
> + * serialised itself against the wakeup call in xlog_cil_push_work(). That
> + * can be done by either holding the push lock or the context lock.
> + */
> +static inline bool
> +xlog_cil_over_hard_limit(
> +	struct xlog	*log,
> +	int32_t		space_used)
> +{
> +	if (waitqueue_active(&log->l_cilp->xc_push_wait))
> +		return true;
> +	if (space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> +		return true;
> +	return false;
> +}
> +
>  /*
>   * Insert the log items into the CIL and calculate the difference in space
>   * consumed by the item. Add the space to the checkpoint ticket and calculate
> @@ -465,6 +541,8 @@ xlog_cil_insert_items(
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
> +	int			space_used;
> +	struct xlog_cil_pcp	*cilpcp;
>  
>  	ASSERT(tp);
>  
> @@ -474,6 +552,21 @@ xlog_cil_insert_items(
>  	 */
>  	xlog_cil_insert_format_items(log, tp, &len);
>  
> +	/*
> +	 * Subtract the space released by intent cancelation from the space we
> +	 * consumed so that we remove it from the CIL space and add it back to
> +	 * the current transaction reservation context.
> +	 */
> +	len -= released_space;
> +
> +	/*
> +	 * Grab the per-cpu pointer for the CIL before we start any accounting.
> +	 * That ensures that we are running with pre-emption disabled and so we
> +	 * can't be scheduled away between split sample/update operations that
> +	 * are done without outside locking to serialise them.
> +	 */
> +	cilpcp = get_cpu_ptr(cil->xc_pcp);
> +
>  	/*
>  	 * We need to take the CIL checkpoint unit reservation on the first
>  	 * commit into the CIL. Test the XLOG_CIL_EMPTY bit first so we don't
> @@ -500,10 +593,14 @@ xlog_cil_insert_items(
>  	 * push won't run out of reservation space.
>  	 *
>  	 * This can steal more than we need, but that's OK.
> +	 *
> +	 * The cil->xc_ctx_lock provides the serialisation necessary for safely
> +	 * calling xlog_cil_over_hard_limit() in this context.
>  	 */
> +	space_used = atomic_read(&ctx->space_used) + cilpcp->space_used + len;
>  	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
> -	    ctx->space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> -		int	split_res = log->l_iclog_hsize +
> +	    xlog_cil_over_hard_limit(log, space_used)) {
> +		split_res = log->l_iclog_hsize +
>  					sizeof(struct xlog_op_header);
>  		if (ctx_res)
>  			ctx_res += split_res * (tp->t_ticket->t_iclog_hdrs - 1);
> @@ -512,29 +609,31 @@ xlog_cil_insert_items(
>  		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
>  	}
>  
> -	spin_lock(&cil->xc_cil_lock);
> -	tp->t_ticket->t_curr_res -= ctx_res + len;
> -	ctx->ticket->t_unit_res += ctx_res;
> -	ctx->ticket->t_curr_res += ctx_res;
> -	ctx->space_used += len;
> -
> -	tp->t_ticket->t_curr_res += released_space;
> -	ctx->space_used -= released_space;
> -
>  	/*
> -	 * If we've overrun the reservation, dump the tx details before we move
> -	 * the log items. Shutdown is imminent...
> +	 * Accurately account when over the soft limit, otherwise fold the
> +	 * percpu count into the global count if over the per-cpu threshold.
>  	 */
> -	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
> -		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
> -		xfs_warn(log->l_mp,
> -			 "  log items: %d bytes (iov hdrs: %d bytes)",
> -			 len, iovhdr_res);
> -		xfs_warn(log->l_mp, "  split region headers: %d bytes",
> -			 split_res);
> -		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
> -		xlog_print_trans(tp);
> +	if (!test_bit(XLOG_CIL_PCP_SPACE, &cil->xc_flags)) {
> +		atomic_add(len, &ctx->space_used);
> +	} else if (cilpcp->space_used + len >
> +			(XLOG_CIL_SPACE_LIMIT(log) / num_online_cpus())) {
> +		space_used = atomic_add_return(cilpcp->space_used + len,
> +						&ctx->space_used);
> +		cilpcp->space_used = 0;
> +
> +		/*
> +		 * If we just transitioned over the soft limit, we need to
> +		 * transition to the global atomic counter.
> +		 */
> +		if (space_used >= XLOG_CIL_SPACE_LIMIT(log))
> +			xlog_cil_insert_pcp_aggregate(cil, ctx);
> +	} else {
> +		cilpcp->space_used += len;
>  	}

...so I guess if the PCP_SPACE bit is cleared, everybody gets to do the
slow accounting, and if this cpu's cil context has used more than its
share of the blocking push threshold, then we transition everyone to the
slow paths until the next context.  Right?

If I've grokked all that, then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +	put_cpu_ptr(cilpcp);
> +
> +	spin_lock(&cil->xc_cil_lock);
> +	ctx->ticket->t_curr_res += ctx_res;
>  
>  	/*
>  	 * Now (re-)position everything modified at the tail of the CIL.
> @@ -542,7 +641,6 @@ xlog_cil_insert_items(
>  	 * the transaction commit.
>  	 */
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
> -
>  		/* Skip items which aren't dirty in this transaction. */
>  		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
>  			continue;
> @@ -561,8 +659,22 @@ xlog_cil_insert_items(
>  		list_splice_init(&tp->t_busy, &ctx->busy_extents);
>  	spin_unlock(&cil->xc_cil_lock);
>  
> -	if (tp->t_ticket->t_curr_res < 0)
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
>  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> +	}
>  }
>  
>  static void
> @@ -1076,6 +1188,8 @@ xlog_cil_push_work(
>  	if (waitqueue_active(&cil->xc_push_wait))
>  		wake_up_all(&cil->xc_push_wait);
>  
> +	xlog_cil_push_pcp_aggregate(cil, ctx);
> +
>  	/*
>  	 * Check if we've anything to push. If there is nothing, then we don't
>  	 * move on to a new sequence number and so we have to be able to push
> @@ -1259,6 +1373,7 @@ xlog_cil_push_background(
>  	struct xlog	*log) __releases(cil->xc_ctx_lock)
>  {
>  	struct xfs_cil	*cil = log->l_cilp;
> +	int		space_used = atomic_read(&cil->xc_ctx->space_used);
>  
>  	/*
>  	 * The cil won't be empty because we are called while holding the
> @@ -1271,7 +1386,7 @@ xlog_cil_push_background(
>  	 * Don't do a background push if we haven't used up all the
>  	 * space available yet.
>  	 */
> -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> +	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
>  		up_read(&cil->xc_ctx_lock);
>  		return;
>  	}
> @@ -1298,12 +1413,11 @@ xlog_cil_push_background(
>  	 * dipping back down under the hard limit.
>  	 *
>  	 * The ctx->xc_push_lock provides the serialisation necessary for safely
> -	 * using the lockless waitqueue_active() check in this context.
> +	 * calling xlog_cil_over_hard_limit() in this context.
>  	 */
> -	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log) ||
> -	    waitqueue_active(&cil->xc_push_wait)) {
> +	if (xlog_cil_over_hard_limit(log, space_used)) {
>  		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
> -		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> +		ASSERT(space_used < log->l_logsize);
>  		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
>  		return;
>  	}
> @@ -1631,9 +1745,11 @@ xlog_cil_pcp_dead(
>  	unsigned int		cpu)
>  {
>  	struct xfs_cil		*cil = log->l_cilp;
> +	struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
>  
>  	down_write(&cil->xc_ctx_lock);
> -	/* move stuff on dead CPU to context */
> +	atomic_add(cilpcp->space_used, &cil->xc_ctx->space_used);
> +	cilpcp->space_used = 0;
>  	up_write(&cil->xc_ctx_lock);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 70483c78953e..f4c13704ef8c 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -222,7 +222,7 @@ struct xfs_cil_ctx {
>  	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
>  	struct xlog_in_core	*commit_iclog;
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
> -	int			space_used;	/* aggregate size of regions */
> +	atomic_t		space_used;	/* aggregate size of regions */
>  	struct list_head	busy_extents;	/* busy extents in chkpt */
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
>  	struct list_head	iclog_entry;
> @@ -235,6 +235,7 @@ struct xfs_cil_ctx {
>   * Per-cpu CIL tracking items
>   */
>  struct xlog_cil_pcp {
> +	int32_t			space_used;
>  	struct list_head	busy_extents;
>  	struct list_head	log_items;
>  };
> @@ -283,6 +284,7 @@ struct xfs_cil {
>  
>  /* xc_flags bit values */
>  #define	XLOG_CIL_EMPTY		1
> +#define XLOG_CIL_PCP_SPACE	2
>  
>  /*
>   * The amount of log space we allow the CIL to aggregate is difficult to size.
> -- 
> 2.35.1
> 
