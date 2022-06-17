Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DA2C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 16:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbiFQQeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbiFQQep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 12:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 812A045AE3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 09:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655483683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ll69PF4v9COT4N56kCAQrmJvs/9lXz/xjsH5G9n8V/4=;
        b=LYsWMHkUTQNTrEQCb5oLBYhxYodAnz6oaAV5fXGamJZbCR5/m87t5TDCN1KrEVFzpYA5te
        t2qXGHcXxNJII7jUy795o6Z16ec3j4s3GCeyhVTsYbgu3VHpYvm5D+CRCW+Os8+Yy4749T
        8Ait1r7XiRNYQ4ugqGgnyk4OCo83fic=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-n3TRb5HfMmyJR_dj6Q1cCQ-1; Fri, 17 Jun 2022 12:34:42 -0400
X-MC-Unique: n3TRb5HfMmyJR_dj6Q1cCQ-1
Received: by mail-qv1-f70.google.com with SMTP id c4-20020a0cca04000000b0046e6864aca4so5290114qvk.18
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 09:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ll69PF4v9COT4N56kCAQrmJvs/9lXz/xjsH5G9n8V/4=;
        b=YysnbGpD0iTAgpVBDchX+N8IEXa7sYDud9yWHTDVK0I+cSavW9KLIeFoR8xFah1/FU
         0jzci8sCLDe4ljckws57CJuih0dKDye0jATXIUgJse2bXcP2Fxo9skpTPSkb2KK1V56t
         PWkGgS98FZmC63Z5zaJS1wxEx3m4b1NTuVlXHScClokuPKNbIY90BO7tQuvk+4A+VYmT
         L5MZ+BdNEJ1WKI0/slL5hbPuAkUFZFe04nW9x4Rp1mHadGqCTl2kXIFBFmtDoTA4ej8u
         iYTkeZcxElwXiXuRbFTy0k0yD6SQG5JeYzHTZoYIWvd+IadMWGfir4ANQKtFibyuiLO6
         YJKg==
X-Gm-Message-State: AJIora9wG+mpjuxPmBU6NkA4BgroXnZ9mjvpTvWYfhMFgDJ4rVn4Qmrv
        6fAokUrVvSTlPMCkOURIRXeVqV4SriZLg2mLERbXnCTIlz+vDkW3oyuPqlP14rhW0OCyqClKAVh
        JTbgCk3ymq2yTjRgl45/z
X-Received: by 2002:a05:620a:2996:b0:6a7:39ca:d8de with SMTP id r22-20020a05620a299600b006a739cad8demr7723881qkp.718.1655483681387;
        Fri, 17 Jun 2022 09:34:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sfSOEiXFOv/msb8fnHXBzVS8fh9jKR2xMPCkxSH7wE4Rg8pPBUZ7E3SgZowK6ynAnrFCRpJA==
X-Received: by 2002:a05:620a:2996:b0:6a7:39ca:d8de with SMTP id r22-20020a05620a299600b006a739cad8demr7723850qkp.718.1655483681002;
        Fri, 17 Jun 2022 09:34:41 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id e7-20020a05620a014700b006a66f3d3708sm4379012qkn.129.2022.06.17.09.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 09:34:40 -0700 (PDT)
Date:   Fri, 17 Jun 2022 12:34:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <YqytHuc/sJprFn0K@bfoster>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615220416.3681870-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 08:04:15AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently inodegc work can sit queued on the per-cpu queue until
> the workqueue is either flushed of the queue reaches a depth that
> triggers work queuing (and later throttling). This means that we
> could queue work that waits for a long time for some other event to
> trigger flushing.
> 
> Hence instead of just queueing work at a specific depth, use a
> delayed work that queues the work at a bound time. We can still
> schedule the work immediately at a given depth, but we no long need
> to worry about leaving a number of items on the list that won't get
> processed until external events prevail.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
>  fs/xfs/xfs_mount.h  |  2 +-
>  fs/xfs/xfs_super.c  |  2 +-
>  3 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 374b3bafaeb0..46b30ecf498c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
...
> @@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
>  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
>  
>  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
>  			no_items = false;
>  		}

This all seems reasonable to me, but is there much practical benefit to
shrinker infra/feedback just to expedite a delayed work item by one
jiffy? Maybe there's a use case to continue to trigger throttling..? If
so, it looks like decent enough overhead to cycle through every cpu in
both callbacks that it might be worth spelling out more clearly in the
top-level comment.

Brian

>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index ba5d42abf66e..d2eaebd85abf 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -61,7 +61,7 @@ struct xfs_error_cfg {
>   */
>  struct xfs_inodegc {
>  	struct llist_head	list;
> -	struct work_struct	work;
> +	struct delayed_work	work;
>  
>  	/* approximate count of inodes in the list */
>  	unsigned int		items;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 48a7239ed1b2..651ae75a7e23 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1075,7 +1075,7 @@ xfs_inodegc_init_percpu(
>  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
>  		init_llist_head(&gc->list);
>  		gc->items = 0;
> -		INIT_WORK(&gc->work, xfs_inodegc_worker);
> +		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
>  	}
>  	return 0;
>  }
> -- 
> 2.35.1
> 

