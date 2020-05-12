Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6B6C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 14:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 265BE20722
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 14:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZRfrxP/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgELOFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 10:05:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58867 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729583AbgELOFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 10:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589292349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ctMQIqRrhbfVyKoe5ezfAqdxb0bhMv/L5RN4LU7tyc=;
        b=JZRfrxP/P7Sm4Zf/uvU/FUlinABmJ8W5exTD/BBOMah2TCIn6DU4zPNCGlzsrNmiNMdZQ0
        MxAujvlnjd7D9Y9NoJtfZl/OZ67UMTDnhPCrtboxFPR/l2OpiHRuVZxET1ep7F890B+nm/
        6jcIHgyMbZbHa07IiJJmftOxhEBR0Cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-YzYEaXoQOtWGJxwl3GsRFg-1; Tue, 12 May 2020 10:05:47 -0400
X-MC-Unique: YzYEaXoQOtWGJxwl3GsRFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9D43107ACF8;
        Tue, 12 May 2020 14:05:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 836AE5C1BB;
        Tue, 12 May 2020 14:05:46 +0000 (UTC)
Date:   Tue, 12 May 2020 10:05:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] [RFC] xfs: use percpu counters for CIL context
 counters
Message-ID: <20200512140544.GD37029@bfoster>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200512092811.1846252-4-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 07:28:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the m_active_trans atomic bottleneck out of the way, the CIL
> xc_cil_lock is the next bottleneck that causes cacheline contention.
> This protects several things, the first of which is the CIL context
> reservation ticket and space usage counters.
> 
> We can lift them out of the xc_cil_lock by converting them to
> percpu counters. THis involves two things, the first of which is
> lifting calculations and samples that don't actually need protecting
> from races outside the xc_cil lock.
> 
> The second is converting the counters to percpu counters and lifting
> them outside the lock. This requires a couple of tricky things to
> minimise initial state races and to ensure we take into account
> split reservations. We do this by erring on the "take the
> reservation just in case" side, which largely lost in the noise of
> many frequent large transactions.
> 
> We use a trick with percpu_counter_add_batch() to ensure the global
> sum is updated immediately on first reservation, hence allowing us
> to use fast counter reads everywhere to determine if the CIL is
> empty or not, rather than using the list itself. This is important
> for later patches where the CIL is moved to percpu lists
> and hence cannot use list_empty() to detect an empty CIL. Hence we
> provide a low overhead, lockless mechanism for determining if the
> CIL is empty or not via this mechanisms. All other percpu counter
> updates use a large batch count so they aggregate on the local CPU
> and minimise global sum updates.
> 
> The xc_ctx_lock rwsem protects draining the percpu counters to the
> context's ticket, similar to the way it allows access to the CIL
> without using the xc_cil_lock. i.e. the CIL push has exclusive
> access to the CIL, the context and the percpu counters while holding
> the xc_ctx_lock. This ensures that we can sum and zero the counters
> atomically from the perspective of the transaction commit side of
> the push. i.e. they reset to zero atomically with the CIL context
> swap and hence we don't need to have the percpu counters attached to
> the CIL context.
> 
> Performance wise, this increases the transaction rate from
> ~620,000/s to around 750,000/second. Using a 32-way concurrent
> create instead of 16-way on a 32p/16GB virtual machine:
> 
> 		create time	rate		unlink time
> unpatched	  2m03s      472k/s+/-9k/s	 3m6s
> patched		  1m56s	     533k/s+/-28k/s	 2m34
> 
> Notably, the system time for the create went from 44m20s down to
> 38m37s, whilst going faster. There is more variance, but I think
> that is from the cacheline contention having inconsistent overhead.
> 
> XXX: probably should split into two patches
> 

Yes please. :)

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 99 ++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_log_priv.h |  2 +
>  2 files changed, 72 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b43f0e8f43f2e..746c841757ed1 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -393,7 +393,7 @@ xlog_cil_insert_items(
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
>  	int			diff_iovecs = 0;
> -	int			iclog_space;
> +	int			iclog_space, space_used;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
>  

fs/xfs//xfs_log_cil.c: In function ‘xlog_cil_insert_items’:
fs/xfs//xfs_log_cil.c:396:21: warning: unused variable ‘space_used’ [-Wunused-variable]

>  	ASSERT(tp);
> @@ -403,17 +403,16 @@ xlog_cil_insert_items(
>  	 * are done so it doesn't matter exactly how we update the CIL.
>  	 */
>  	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
> -
> -	spin_lock(&cil->xc_cil_lock);
> -
>  	/* account for space used by new iovec headers  */
> +
>  	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
>  	len += iovhdr_res;
>  	ctx->nvecs += diff_iovecs;
>  
> -	/* attach the transaction to the CIL if it has any busy extents */
> -	if (!list_empty(&tp->t_busy))
> -		list_splice_init(&tp->t_busy, &ctx->busy_extents);
> +	/*
> +	 * The ticket can't go away from us here, so we can do racy sampling
> +	 * and precalculate everything.
> +	 */
>  
>  	/*
>  	 * Now transfer enough transaction reservation to the context ticket
> @@ -421,27 +420,28 @@ xlog_cil_insert_items(
>  	 * reservation has to grow as well as the current reservation as we
>  	 * steal from tickets so we can correctly determine the space used
>  	 * during the transaction commit.
> +	 *
> +	 * We use percpu_counter_add_batch() here to force the addition into the
> +	 * global sum immediately. This will result in percpu_counter_read() now
> +	 * always returning a non-zero value, and hence we'll only ever have a
> +	 * very short race window on new contexts.
>  	 */
> -	if (ctx->ticket->t_curr_res == 0) {
> +	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
>  		ctx_res = ctx->ticket->t_unit_res;
> -		ctx->ticket->t_curr_res = ctx_res;
>  		tp->t_ticket->t_curr_res -= ctx_res;
> +		percpu_counter_add_batch(&cil->xc_curr_res, ctx_res, ctx_res - 1);
>  	}

Ok, so we open a race here at the cost of stealing more reservation than
necessary from the transaction. Seems harmless, but I would like to see
some quantification/analysis on what a 'very short race window' is in
this context. Particularly as it relates to percpu functionality. Does
the window scale with cpu count, for example? It might not matter either
way because we expect any given transaction to accommodate the ctx res,
but it would be good to understand the behavior here so we can think
about potential side effects, if any.

>  
>  	/* do we need space for more log record headers? */
> -	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> -	if (len > 0 && (ctx->space_used / iclog_space !=
> -				(ctx->space_used + len) / iclog_space)) {
> +	if (len > 0 && !ctx_res) {
> +		iclog_space = log->l_iclog_size - log->l_iclog_hsize;
>  		split_res = (len + iclog_space - 1) / iclog_space;
>  		/* need to take into account split region headers, too */
>  		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> -		ctx->ticket->t_unit_res += split_res;
> -		ctx->ticket->t_curr_res += split_res;
>  		tp->t_ticket->t_curr_res -= split_res;
>  		ASSERT(tp->t_ticket->t_curr_res >= len);
>  	}

Similarly here, assume additional split reservation for every context
rather than checking each commit. Seems reasonable in principle, but
just from a cursory glance this doesn't cover the case of the context
expanding beyond more than two iclogs. IOW, the current logic adds
split_res if the size increase from the current transaction expands the
ctx into another iclog than before the transaction. The new logic only
seems to add split_res for the first transaction into the ctx. Also note
that len seems to be a factor in the calculation of split_res, but it's
not immediately clear to me what impact filtering the split_res
calculation as such has in that regard.

(BTW the comment above this hunk needs an update if we do end up with
some special logic here.)

Other than those bits this seems fairly sane to me.

Brian

>  	tp->t_ticket->t_curr_res -= len;
> -	ctx->space_used += len;
>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
> @@ -458,6 +458,15 @@ xlog_cil_insert_items(
>  		xlog_print_trans(tp);
>  	}
>  
> +	percpu_counter_add_batch(&cil->xc_curr_res, split_res, 1000 * 1000);
> +	percpu_counter_add_batch(&cil->xc_space_used, len, 1000 * 1000);
> +
> +	spin_lock(&cil->xc_cil_lock);
> +
> +	/* attach the transaction to the CIL if it has any busy extents */
> +	if (!list_empty(&tp->t_busy))
> +		list_splice_init(&tp->t_busy, &ctx->busy_extents);
> +
>  	/*
>  	 * Now (re-)position everything modified at the tail of the CIL.
>  	 * We do this here so we only need to take the CIL lock once during
> @@ -741,6 +750,18 @@ xlog_cil_push_work(
>  		num_iovecs += lv->lv_niovecs;
>  	}
>  
> +	/*
> +	 * Drain per cpu counters back to context so they can be re-initialised
> +	 * to zero before we allow commits to the new context we are about to
> +	 * switch to.
> +	 */
> +	ctx->space_used = percpu_counter_sum(&cil->xc_space_used);
> +	ctx->ticket->t_curr_res = percpu_counter_sum(&cil->xc_curr_res);
> +	ctx->ticket->t_unit_res = ctx->ticket->t_curr_res;
> +	percpu_counter_set(&cil->xc_space_used, 0);
> +	percpu_counter_set(&cil->xc_curr_res, 0);
> +
> +
>  	/*
>  	 * initialise the new context and attach it to the CIL. Then attach
>  	 * the current context to the CIL committing lsit so it can be found
> @@ -900,6 +921,7 @@ xlog_cil_push_background(
>  	struct xlog	*log) __releases(cil->xc_ctx_lock)
>  {
>  	struct xfs_cil	*cil = log->l_cilp;
> +	s64		space_used = percpu_counter_read(&cil->xc_space_used);
>  
>  	/*
>  	 * The cil won't be empty because we are called while holding the
> @@ -911,7 +933,7 @@ xlog_cil_push_background(
>  	 * don't do a background push if we haven't used up all the
>  	 * space available yet.
>  	 */
> -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> +	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
>  		up_read(&cil->xc_ctx_lock);
>  		return;
>  	}
> @@ -934,9 +956,9 @@ xlog_cil_push_background(
>  	 * If we are well over the space limit, throttle the work that is being
>  	 * done until the push work on this context has begun.
>  	 */
> -	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> +	if (space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
>  		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
> -		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> +		ASSERT(space_used < log->l_logsize);
>  		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
>  		return;
>  	}
> @@ -1200,16 +1222,23 @@ xlog_cil_init(
>  {
>  	struct xfs_cil	*cil;
>  	struct xfs_cil_ctx *ctx;
> +	int		error = -ENOMEM;
>  
>  	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
>  	if (!cil)
> -		return -ENOMEM;
> +		return error;
>  
>  	ctx = kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
> -	if (!ctx) {
> -		kmem_free(cil);
> -		return -ENOMEM;
> -	}
> +	if (!ctx)
> +		goto out_free_cil;
> +
> +	error = percpu_counter_init(&cil->xc_space_used, 0, GFP_KERNEL);
> +	if (error)
> +		goto out_free_ctx;
> +
> +	error = percpu_counter_init(&cil->xc_curr_res, 0, GFP_KERNEL);
> +	if (error)
> +		goto out_free_space;
>  
>  	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
>  	INIT_LIST_HEAD(&cil->xc_cil);
> @@ -1230,19 +1259,31 @@ xlog_cil_init(
>  	cil->xc_log = log;
>  	log->l_cilp = cil;
>  	return 0;
> +
> +out_free_space:
> +	percpu_counter_destroy(&cil->xc_space_used);
> +out_free_ctx:
> +	kmem_free(ctx);
> +out_free_cil:
> +	kmem_free(cil);
> +	return error;
>  }
>  
>  void
>  xlog_cil_destroy(
>  	struct xlog	*log)
>  {
> -	if (log->l_cilp->xc_ctx) {
> -		if (log->l_cilp->xc_ctx->ticket)
> -			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
> -		kmem_free(log->l_cilp->xc_ctx);
> +	struct xfs_cil  *cil = log->l_cilp;
> +
> +	if (cil->xc_ctx) {
> +		if (cil->xc_ctx->ticket)
> +			xfs_log_ticket_put(cil->xc_ctx->ticket);
> +		kmem_free(cil->xc_ctx);
>  	}
> +	percpu_counter_destroy(&cil->xc_space_used);
> +	percpu_counter_destroy(&cil->xc_curr_res);
>  
> -	ASSERT(list_empty(&log->l_cilp->xc_cil));
> -	kmem_free(log->l_cilp);
> +	ASSERT(list_empty(&cil->xc_cil));
> +	kmem_free(cil);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ec22c7a3867f1..f5e79a7d44c8e 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -262,6 +262,8 @@ struct xfs_cil_ctx {
>   */
>  struct xfs_cil {
>  	struct xlog		*xc_log;
> +	struct percpu_counter	xc_space_used;
> +	struct percpu_counter	xc_curr_res;
>  	struct list_head	xc_cil;
>  	spinlock_t		xc_cil_lock;
>  
> -- 
> 2.26.1.301.g55bc3eb7cb9
> 

