Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D707EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCD064F60
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCKAV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhCKAU7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 19:20:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A60A64F60;
        Thu, 11 Mar 2021 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615422059;
        bh=ZdaRc9GucKpbJuQ+fbperXfRE8rhwLQWTkkJX7ium/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=upJwzKLsxCKiVDj7y/cyH8+I+eEzML9W7MINrsdiYQ+ClOPv807BeVvfcreB7Q6c9
         KN3/Xc41cT90prwBWv35HKw1RM9SjpsxKp02kqnseGJazDNvTIssbNycPMWYWT+qbt
         WXt1wLcxA6Sqv2U4QHu4d85UlwlxH6XgQpQA8UCys6zeO5+qYkPGQgWmITyLhGhKRT
         vBU4lKSNOhKVSLWNjewhavTsDL3ombOum6g3/nyNJBkA6O87qAaqHEwLBby7Bw/rxq
         U/Ei2nuvTqSFqMuWWMaDDvpD6xt/cqH3fjzKLHpAl9zRGXUIKbQ/31iHInZVTjRt/p
         5Bby+gN2JcV+A==
Date:   Wed, 10 Mar 2021 16:20:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/45] xfs: implement percpu cil space used calculation
Message-ID: <20210311002054.GJ3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-37-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-37-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:34PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have the CIL percpu structures in place, implement the
> space used counter with a fast sum check similar to the
> percpu_counter infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 42 ++++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 1bcf0d423d30..5519d112c1fd 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -433,6 +433,8 @@ xlog_cil_insert_items(
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
> +	int			space_used;
> +	struct xlog_cil_pcp	*cilpcp;
>  
>  	ASSERT(tp);
>  
> @@ -469,8 +471,9 @@ xlog_cil_insert_items(
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
> @@ -480,16 +483,34 @@ xlog_cil_insert_items(
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

What happens if the log is very small and there are hundreds of CPUs?
Can we end up on this slow path on a regular basis even if the amount of
space used is not that large?

Granted I can't think of a good way out of that, since I suspect that if
you do that you're already going to be hurting in 5 other places anyway.
That said ... I /do/ keep getting bugs from people with tiny logs on big
iron.  Some day I'll (ha!) stomp out all the bugs that are "NO do not
let your deployment system growfs 10000x, this is not ext4"...

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

Is moving this really necessary?

--D

>  	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
>  		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
>  		xfs_warn(log->l_mp,
> @@ -769,12 +790,20 @@ xlog_cil_push_work(
>  	struct bio		bio;
>  	DECLARE_COMPLETION_ONSTACK(bdev_flush);
>  	bool			commit_iclog_sync = false;
> +	int			cpu;
> +	struct xlog_cil_pcp	*cilpcp;
>  
>  	new_ctx = xlog_cil_ctx_alloc();
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
>  
>  	down_write(&cil->xc_ctx_lock);
>  
> +	/* Reset the CIL pcp counters */
> +	for_each_online_cpu(cpu) {
> +		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +		cilpcp->space_used = 0;
> +	}
> +
>  	spin_lock(&cil->xc_push_lock);
>  	push_seq = cil->xc_push_seq;
>  	ASSERT(push_seq <= ctx->sequence);
> @@ -1042,6 +1071,7 @@ xlog_cil_push_background(
>  	struct xlog	*log) __releases(cil->xc_ctx_lock)
>  {
>  	struct xfs_cil	*cil = log->l_cilp;
> +	int		space_used = atomic_read(&cil->xc_ctx->space_used);
>  
>  	/*
>  	 * The cil won't be empty because we are called while holding the
> @@ -1054,7 +1084,7 @@ xlog_cil_push_background(
>  	 * Don't do a background push if we haven't used up all the
>  	 * space available yet.
>  	 */
> -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> +	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
>  		up_read(&cil->xc_ctx_lock);
>  		return;
>  	}
> @@ -1083,10 +1113,10 @@ xlog_cil_push_background(
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
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2562f29c8986..4eb373357f26 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -222,7 +222,7 @@ struct xfs_cil_ctx {
>  	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
>  	int			nvecs;		/* number of regions */
> -	int			space_used;	/* aggregate size of regions */
> +	atomic_t		space_used;	/* aggregate size of regions */
>  	struct list_head	busy_extents;	/* busy extents in chkpt */
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
>  	struct list_head	iclog_entry;
> -- 
> 2.28.0
> 
