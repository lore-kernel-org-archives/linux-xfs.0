Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B7DC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 15:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC1120691
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 15:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQQjM2vp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgFKPLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 11:11:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40021 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728327AbgFKPLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jun 2020 11:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591888289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dCrUsFjr5nTo7YMbuo6naT5rMcveBqItH9g4ZRhLhDU=;
        b=UQQjM2vpHVgkYABnd33viNk0eQPueJLlOSa7qDFcVtj6VYU9Ytx2+weIlEC1FyWSsrMpLY
        TKBRVG2UCl4HiIjzzRKyD5279kubu0v4vgSe8HXnrc3E2FWQwkaXRaDto2D1xsmOV67V4e
        MylAwJP7vLondq7Bp8q+qsoTiHUwVJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-hZKXzjXEOfSX68ojmbc1Yw-1; Thu, 11 Jun 2020 11:11:26 -0400
X-MC-Unique: hZKXzjXEOfSX68ojmbc1Yw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83D3580572E;
        Thu, 11 Jun 2020 15:11:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B54610013D7;
        Thu, 11 Jun 2020 15:11:24 +0000 (UTC)
Date:   Thu, 11 Jun 2020 11:11:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Yu Kuai <yukuai3@huawei.com>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com
Subject: Re: [PATCH] xfs: fix use-after-free on CIL context on shutdown
Message-ID: <20200611151122.GA57603@bfoster>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
 <20200611022848.GQ2040@dread.disaster.area>
 <20200611024503.GR2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611024503.GR2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 12:45:03PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_wait() on the CIL context can reference a freed context if the
> waiter doesn't get scheduled before the CIL context is freed. This
> can happen when a task is on the hard throttle and the CIL push
> aborts due to a shutdown. This was detected by generic/019:
> 
> thread 1			thread 2
> 
> __xfs_trans_commit
>  xfs_log_commit_cil
>   <CIL size over hard throttle limit>
>   xlog_wait
>    schedule
> 				xlog_cil_push_work
> 				wake_up_all
> 				<shutdown aborts commit>
> 				xlog_cil_committed
> 				kmem_free
> 
>    remove_wait_queue
>     spin_lock_irqsave --> UAF
> 
> Fix it by moving the wait queue to the CIL rather than keeping it in
> in the CIL context that gets freed on push completion. Because the
> wait queue is now independent of the CIL context and we might have
> multiple contexts in flight at once, only wake the waiters on the
> push throttle when the context we are pushing is over the hard
> throttle size threshold.
> 
> Fixes: 0e7ab7efe7745 ("xfs: Throttle commits on delayed background CIL push")
> Reported-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_cil.c  | 10 +++++-----
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b43f0e8f43f2e..9ed90368ab311 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -671,7 +671,8 @@ xlog_cil_push_work(
>  	/*
>  	 * Wake up any background push waiters now this context is being pushed.
>  	 */
> -	wake_up_all(&ctx->push_wait);
> +	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> +		wake_up_all(&cil->xc_push_wait);
>  
>  	/*
>  	 * Check if we've anything to push. If there is nothing, then we don't
> @@ -743,13 +744,12 @@ xlog_cil_push_work(
>  
>  	/*
>  	 * initialise the new context and attach it to the CIL. Then attach
> -	 * the current context to the CIL committing lsit so it can be found
> +	 * the current context to the CIL committing list so it can be found
>  	 * during log forces to extract the commit lsn of the sequence that
>  	 * needs to be forced.
>  	 */
>  	INIT_LIST_HEAD(&new_ctx->committing);
>  	INIT_LIST_HEAD(&new_ctx->busy_extents);
> -	init_waitqueue_head(&new_ctx->push_wait);
>  	new_ctx->sequence = ctx->sequence + 1;
>  	new_ctx->cil = cil;
>  	cil->xc_ctx = new_ctx;
> @@ -937,7 +937,7 @@ xlog_cil_push_background(
>  	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
>  		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
>  		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> -		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> +		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
>  		return;
>  	}
>  
> @@ -1216,12 +1216,12 @@ xlog_cil_init(
>  	INIT_LIST_HEAD(&cil->xc_committing);
>  	spin_lock_init(&cil->xc_cil_lock);
>  	spin_lock_init(&cil->xc_push_lock);
> +	init_waitqueue_head(&cil->xc_push_wait);
>  	init_rwsem(&cil->xc_ctx_lock);
>  	init_waitqueue_head(&cil->xc_commit_wait);
>  
>  	INIT_LIST_HEAD(&ctx->committing);
>  	INIT_LIST_HEAD(&ctx->busy_extents);
> -	init_waitqueue_head(&ctx->push_wait);
>  	ctx->sequence = 1;
>  	ctx->cil = cil;
>  	cil->xc_ctx = ctx;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ec22c7a3867f1..75a62870b63af 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -240,7 +240,6 @@ struct xfs_cil_ctx {
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
>  	struct list_head	iclog_entry;
>  	struct list_head	committing;	/* ctx committing list */
> -	wait_queue_head_t	push_wait;	/* background push throttle */
>  	struct work_struct	discard_endio_work;
>  };
>  
> @@ -274,6 +273,7 @@ struct xfs_cil {
>  	wait_queue_head_t	xc_commit_wait;
>  	xfs_lsn_t		xc_current_sequence;
>  	struct work_struct	xc_push_work;
> +	wait_queue_head_t	xc_push_wait;	/* background push throttle */
>  } ____cacheline_aligned_in_smp;
>  
>  /*
> 

