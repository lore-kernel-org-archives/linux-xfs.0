Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D5AC4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB450613D1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhE0Smz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 14:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhE0Smz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78991613D1;
        Thu, 27 May 2021 18:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622140881;
        bh=NUsoHQxIgjVyw7i7Xppytl164SGr5tUOncS9JAPU74M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YsIrPLlQtEojMHEtZyrlP3Q/fLE0Ca9rMvRyOJjUbQLEeC7k2jZptQYi4Jbch4kGg
         99WMoGAAmTF7x9SU5I0nwdtmnlmIAGv4ipOKf4aDssbpeeOzR2poM1yNV+SmdC3M17
         IJVK+8s3geI4uICBFMGV+PaRwynm9Mgfc2kMMKosqSqbzpPevwN/mGLbWW4LCCgHnl
         qBCMjWDB3aLcYPECMdrCyAQA38j+3ujU+pZ2BLrReo+Hp06hHozpdSEIOsPo19nbX8
         HzzJgS35UlZWuMqDlK4iL4R1pwaO19HWQF1T+fYl2znUeBHaux7WIqBY3d9d3XhlPH
         TPTH0jQPMSYEA==
Date:   Thu, 27 May 2021 11:41:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/39] xfs: implement percpu cil space used calculation
Message-ID: <20210527184121.GM202144@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-31-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-31-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have the CIL percpu structures in place, implement the
> space used counter with a fast sum check similar to the
> percpu_counter infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 61 ++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 55 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index ba1c6979a4c7..72693fba929b 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -76,6 +76,24 @@ xlog_cil_ctx_alloc(void)
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
> +		cilpcp->space_used = 0;

How does this aggregate anything?  All I see here is zeroing a counter?
I see that we /can/ add the percpu space_used counter to the cil context
if we're over the space limits, but I don't actually see where...

> +	}
> +}
> +
>  static void
>  xlog_cil_ctx_switch(
>  	struct xfs_cil		*cil,
> @@ -433,6 +451,8 @@ xlog_cil_insert_items(
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
> +	int			space_used;
> +	struct xlog_cil_pcp	*cilpcp;
>  
>  	ASSERT(tp);
>  
> @@ -469,8 +489,9 @@ xlog_cil_insert_items(
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
> @@ -480,16 +501,34 @@ xlog_cil_insert_items(
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

...this update happens if we're not over the space limit?

--D

>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
>  	 * the log items. Shutdown is imminent...
>  	 */
> +	tp->t_ticket->t_curr_res -= ctx_res + len;
>  	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
>  		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
>  		xfs_warn(log->l_mp,
> @@ -846,6 +885,8 @@ xlog_cil_push_work(
>  	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
>  				&bdev_flush);
>  
> +	xlog_cil_pcp_aggregate(cil, ctx);
> +
>  	/*
>  	 * Pull all the log vectors off the items in the CIL, and remove the
>  	 * items from the CIL. We don't need the CIL lock here because it's only
> @@ -1043,6 +1084,7 @@ xlog_cil_push_background(
>  	struct xlog	*log) __releases(cil->xc_ctx_lock)
>  {
>  	struct xfs_cil	*cil = log->l_cilp;
> +	int		space_used = atomic_read(&cil->xc_ctx->space_used);
>  
>  	/*
>  	 * The cil won't be empty because we are called while holding the
> @@ -1055,7 +1097,7 @@ xlog_cil_push_background(
>  	 * Don't do a background push if we haven't used up all the
>  	 * space available yet.
>  	 */
> -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> +	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
>  		up_read(&cil->xc_ctx_lock);
>  		return;
>  	}
> @@ -1084,10 +1126,10 @@ xlog_cil_push_background(
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
> @@ -1391,9 +1433,14 @@ xlog_cil_pcp_dead(
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
> index aaa1e7f7fb66..7dc6275818de 100644
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
> -- 
> 2.31.1
> 
