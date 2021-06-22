Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA28C2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C446135A
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhFVMmr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 08:42:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231610AbhFVMlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 08:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624365540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IM6QVTZupRnXc/vceV0VbinzPSL6+IdZClii7ORqxk4=;
        b=T8pp3lY12CG/s4psPG+LYDbIulPA4cJXkd9bg0YayIuqyTlxG6pSWpX1mxdDIWYUUFALLD
        SL0PN74e3Q+ecAlSjpdYPbzaqtO7OAzp0irThfr+VUv6SQhLMotc0l2GC1u4x0GU32zWw7
        yevTmokU8f9ac/pHUwEOEuh8RsoJpPU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-gfKnVIUOP36FVToJFOYHcw-1; Tue, 22 Jun 2021 08:38:59 -0400
X-MC-Unique: gfKnVIUOP36FVToJFOYHcw-1
Received: by mail-qt1-f199.google.com with SMTP id 62-20020aed30440000b029024cabef375cso2085504qte.17
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 05:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IM6QVTZupRnXc/vceV0VbinzPSL6+IdZClii7ORqxk4=;
        b=tqecmMWy4cUqQh6PYxMTBr20jCkZpqAqt3d7ryRRVav0QJ0JhZ0qSxiT+qOOTc8aS1
         Z2/kGl9NksQwGzQMR4oj581G8PnaD+YY8MtUIR/dzB73fUoIdFQYkseSP72rVDHntv2M
         dUfzLLSIYfoJsVzO3d7h526cdzZZ9budEU/Kwy7jhNWcQGnoQtnWipqSUF51mk4WimyC
         nxe01mSsnlJsYsIztfax5Emq6JRlzPbYFamXvOFF0aVjGNA/EbUGF1YPxC9fvc46kfEs
         4lEZXausUCJGHG6a1QLmQAn9bgU5rDcDbmOzz2jt0YdT5XR3XwU7HfquTmZQmbFif50Y
         AB8g==
X-Gm-Message-State: AOAM532QTIvtdJoBFS8Ix+G6KmEfa7aMyJ67TOvBMmrYeL1dHHfPfcwp
        zQErdeg3mSEjNYXOb1QZOW7JgGd8OnBtBIJ21uF/nbYSa/w8LMdC22M4Pb+y48yU/b8zE/4figj
        9U6wh5QXC23JL2GjWpeIv
X-Received: by 2002:ac8:670f:: with SMTP id e15mr3237327qtp.291.1624365538502;
        Tue, 22 Jun 2021 05:38:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl015yw4W4nHKcunyZv4xgk71X0E7+xVH9kqEa2GXQSzsgRAV1w1un7YtUCAVObTKVrNBnVg==
X-Received: by 2002:ac8:670f:: with SMTP id e15mr3237316qtp.291.1624365538294;
        Tue, 22 Jun 2021 05:38:58 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id z13sm1602610qtn.4.2021.06.22.05.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 05:38:57 -0700 (PDT)
Date:   Tue, 22 Jun 2021 08:38:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: don't nest icloglock inside ic_callback_lock
Message-ID: <YNHZ4Bsr27u53TxG@bfoster>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622040604.1290539-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:06:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's completely unnecessary because callbacks are added to iclogs
> without holding the icloglock, hence no amount of ordering between
> the icloglock and ic_callback_lock will order the removal of
> callbacks from the iclog.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e93cac6b5378..bb4390942275 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2773,11 +2773,8 @@ static void
>  xlog_state_do_iclog_callbacks(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
> -		__releases(&log->l_icloglock)
> -		__acquires(&log->l_icloglock)
>  {
>  	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> -	spin_unlock(&log->l_icloglock);
>  	spin_lock(&iclog->ic_callback_lock);
>  	while (!list_empty(&iclog->ic_callbacks)) {
>  		LIST_HEAD(tmp);
> @@ -2789,12 +2786,6 @@ xlog_state_do_iclog_callbacks(
>  		spin_lock(&iclog->ic_callback_lock);
>  	}
>  
> -	/*
> -	 * Pick up the icloglock while still holding the callback lock so we
> -	 * serialise against anyone trying to add more callbacks to this iclog
> -	 * now we've finished processing.
> -	 */

This makes sense wrt to the current locking, but I'd like to better
understand what's being removed. When would we add callbacks to an iclog
that's made it to this stage (i.e., already completed I/O)? Is this some
historical case or attempt at defensive logic?

Brian

> -	spin_lock(&log->l_icloglock);
>  	spin_unlock(&iclog->ic_callback_lock);
>  	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
>  }
> @@ -2836,13 +2827,12 @@ xlog_state_do_callback(
>  				iclog = iclog->ic_next;
>  				continue;
>  			}
> +			spin_unlock(&log->l_icloglock);
>  
> -			/*
> -			 * Running callbacks will drop the icloglock which means
> -			 * we'll have to run at least one more complete loop.
> -			 */
> -			cycled_icloglock = true;
>  			xlog_state_do_iclog_callbacks(log, iclog);
> +			cycled_icloglock = true;
> +
> +			spin_lock(&log->l_icloglock);
>  			if (XLOG_FORCED_SHUTDOWN(log))
>  				wake_up_all(&iclog->ic_force_wait);
>  			else
> -- 
> 2.31.1
> 

