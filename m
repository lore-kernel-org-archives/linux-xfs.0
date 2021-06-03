Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AADFC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 16:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C456024A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 16:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhFCQqV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 12:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhFCQqV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 12:46:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8057A613F1;
        Thu,  3 Jun 2021 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622738676;
        bh=fiFsxykksRQdhZSvNTnk/neO0gQJgB2+QU5Hml4n10k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HNadiIIvDgBfKWt0xUX5vHfk4+fPtK+c+bbdxTa6K5XrgGOXSDKItYLem4pNzcYuk
         n93PUpTEJumW0ZKkQyvVJChiEvttmGxMuGBJC3tu9q0jwC3kvm20d9OmtJuD04PPjj
         6nqIDxigX9+e5860EL7VvRB2TIOyPx4KmDITws7tY43/QDw5OqV6/8WiKGrDY9anuz
         r+3xL60b6mW0+kQt1Wl7jCX7o4VUPLT5eZNfcETjeCi8K7YXP9kxr1yHUvCxDgFHAU
         Ld3ISIV1Hyy5VHAP98FPXJj54RpsiDRgDqOylbNPk4JNxSDHZ1PeIOXnU+7Rnhy795
         eldnJB7IeYRxg==
Date:   Thu, 3 Jun 2021 09:44:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/39] xfs: implement percpu cil space used calculation
Message-ID: <20210603164436.GX26380@locust>
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603052240.171998-31-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603052240.171998-31-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 03:22:31PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have the CIL percpu structures in place, implement the
> space used counter with a fast sum check similar to the
> percpu_counter infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/me gets it now, so:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c  | 67 ++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  3 +-
>  2 files changed, 62 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 791ed1058fb4..620824c6f7fa 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -76,6 +76,30 @@ xlog_cil_ctx_alloc(void)
>  	return ctx;
>  }
>  
> +/*
> + * Aggregate the CIL per cpu structures into global counts, lists, etc and
> + * clear the percpu state ready for the next context to use.
> + */
> +static void
> +xlog_cil_pcp_aggregate(
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
>  static void
>  xlog_cil_ctx_switch(
>  	struct xfs_cil		*cil,
> @@ -433,6 +457,8 @@ xlog_cil_insert_items(
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
> +	int			space_used;
> +	struct xlog_cil_pcp	*cilpcp;
>  
>  	ASSERT(tp);
>  
> @@ -469,8 +495,9 @@ xlog_cil_insert_items(
>  	 *
>  	 * This can steal more than we need, but that's OK.
>  	 */
> +	space_used = atomic_read(&ctx->space_used);
>  	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
> -	    ctx->space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> +	    space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
>  		int	split_res = log->l_iclog_hsize +
>  					sizeof(struct xlog_op_header);
>  		if (ctx_res)
> @@ -480,16 +507,34 @@ xlog_cil_insert_items(
>  		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
>  	}
>  
> +	/*
> +	 * Update the CIL percpu pointer. This updates the global counter when
> +	 * over the percpu batch size or when the CIL is over the space limit.
> +	 * This means low lock overhead for normal updates, and when over the
> +	 * limit the space used is immediately accounted. This makes enforcing
> +	 * the hard limit much more accurate. The per cpu fold threshold is
> +	 * based on how close we are to the hard limit.
> +	 */
> +	cilpcp = get_cpu_ptr(cil->xc_pcp);
> +	cilpcp->space_used += len;
> +	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
> +	    cilpcp->space_used >
> +			((XLOG_CIL_BLOCKING_SPACE_LIMIT(log) - space_used) /
> +					num_online_cpus())) {
> +		atomic_add(cilpcp->space_used, &ctx->space_used);
> +		cilpcp->space_used = 0;
> +	}
> +	put_cpu_ptr(cilpcp);
> +
>  	spin_lock(&cil->xc_cil_lock);
> -	tp->t_ticket->t_curr_res -= ctx_res + len;
>  	ctx->ticket->t_unit_res += ctx_res;
>  	ctx->ticket->t_curr_res += ctx_res;
> -	ctx->space_used += len;
>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
>  	 * the log items. Shutdown is imminent...
>  	 */
> +	tp->t_ticket->t_curr_res -= ctx_res + len;
>  	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
>  		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
>  		xfs_warn(log->l_mp,
> @@ -846,6 +891,8 @@ xlog_cil_push_work(
>  	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
>  				&bdev_flush);
>  
> +	xlog_cil_pcp_aggregate(cil, ctx);
> +
>  	/*
>  	 * Pull all the log vectors off the items in the CIL, and remove the
>  	 * items from the CIL. We don't need the CIL lock here because it's only
> @@ -1042,6 +1089,7 @@ xlog_cil_push_background(
>  	struct xlog	*log) __releases(cil->xc_ctx_lock)
>  {
>  	struct xfs_cil	*cil = log->l_cilp;
> +	int		space_used = atomic_read(&cil->xc_ctx->space_used);
>  
>  	/*
>  	 * The cil won't be empty because we are called while holding the
> @@ -1054,7 +1102,7 @@ xlog_cil_push_background(
>  	 * Don't do a background push if we haven't used up all the
>  	 * space available yet.
>  	 */
> -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> +	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
>  		up_read(&cil->xc_ctx_lock);
>  		return;
>  	}
> @@ -1083,10 +1131,10 @@ xlog_cil_push_background(
>  	 * The ctx->xc_push_lock provides the serialisation necessary for safely
>  	 * using the lockless waitqueue_active() check in this context.
>  	 */
> -	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log) ||
> +	if (space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log) ||
>  	    waitqueue_active(&cil->xc_push_wait)) {
>  		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
> -		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> +		ASSERT(space_used < log->l_logsize);
>  		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
>  		return;
>  	}
> @@ -1390,9 +1438,14 @@ xlog_cil_pcp_dead(
>  
>  	spin_lock(&xlog_cil_pcp_lock);
>  	list_for_each_entry_safe(cil, n, &xlog_cil_pcp_list, xc_pcp_list) {
> +		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +
>  		spin_unlock(&xlog_cil_pcp_lock);
>  		down_write(&cil->xc_ctx_lock);
> -		/* move stuff on dead CPU to context */
> +
> +		atomic_add(cilpcp->space_used, &cil->xc_ctx->space_used);
> +		cilpcp->space_used = 0;
> +
>  		up_write(&cil->xc_ctx_lock);
>  		spin_lock(&xlog_cil_pcp_lock);
>  	}
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index d76deffa4690..373b7dbde4af 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -218,7 +218,7 @@ struct xfs_cil_ctx {
>  	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
>  	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
> -	int			space_used;	/* aggregate size of regions */
> +	atomic_t		space_used;	/* aggregate size of regions */
>  	struct list_head	busy_extents;	/* busy extents in chkpt */
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
>  	struct list_head	iclog_entry;
> @@ -231,6 +231,7 @@ struct xfs_cil_ctx {
>   * Per-cpu CIL tracking items
>   */
>  struct xlog_cil_pcp {
> +	uint32_t		space_used;
>  	struct list_head	busy_extents;
>  	struct list_head	log_items;
>  };
> -- 
> 2.31.1
> 
