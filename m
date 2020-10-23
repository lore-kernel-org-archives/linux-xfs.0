Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2170BC388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 14:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF3F2168B
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 14:49:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="MvGnx9vk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S376038AbgJWOtx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 10:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896924AbgJWOtw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 10:49:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672F0C0613D2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 07:49:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h7so2195530wre.4
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 07:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=xePUgVqudoa7FnGpfppkhLWoCoDAn7O+IxyLYMvs6Sc=;
        b=MvGnx9vkHwpizYCI9ky1WftlKGJyu8gfslaoAiKEIdj22q0PhnMpWAUsJSBX3MFBXx
         q5Kgm1gIGuREOXqi72Ng1uZ1jttei9ar/c7saDblVfEOptFy7Byma67mTyG2MP3lGf7Q
         aRqtc82yNyZlus4h+wpJdbS3QLBLSNleBXB9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=xePUgVqudoa7FnGpfppkhLWoCoDAn7O+IxyLYMvs6Sc=;
        b=qJV+TeBaHHTN8LEEYHtE0paGK/8rjbfeFPsr5xcbzpjHwRTfWFPogd0VDhwcbakwHU
         ytp7ayxlNwC0EZ9bwiw3f9Mqn3R0NUZaOGfpfBKjohIaXWjPyxsYL/561uE+hvjxp0+4
         CtsRhXvyYScaFYsDS3X5OuPhNV8kv9hC63+69zYc16Oe8vqiXdAI7pnabZUEeF6SAM1z
         fDYUtxDOHu6IMCZ7IUy1MnhGFgZKd/5VdcYXZpDrJItVaDDYTe0VxmGKaRQr6sRVNrpg
         jJzpB07G7fryG7qgqV4xLHkWnyniCgSETsqMBTvSQLRj/mqrMuoR7zZjwMbD4LsTNtWd
         VsGQ==
X-Gm-Message-State: AOAM5333kiWUdFXBWARRKyRW19B4jP8gkWlmMuvyVvuaa6Syby8JmPbi
        QdE5GoNz1U4m/mOOjl9eJjuq8g==
X-Google-Smtp-Source: ABdhPJyQZR2dXG0RjIsq+LQh8IIHllK8eRs8oeqmDRQIBDJg1umlU3uJqlUglPGV6YHm5CpOm9JoMg==
X-Received: by 2002:adf:ef06:: with SMTP id e6mr2966269wro.397.1603464591080;
        Fri, 23 Oct 2020 07:49:51 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id e25sm4069542wra.71.2020.10.23.07.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 07:49:50 -0700 (PDT)
Date:   Fri, 23 Oct 2020 16:49:48 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20201023144948.GE401619@phenom.ffwll.local>
Mail-Followup-To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-7-willy@infradead.org>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 12:31:22PM +0100, Matthew Wilcox (Oracle) wrote:
> Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> guarantees we will not sleep to reclaim memory.  Use it to simplify
> dm-bufio's allocations.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/md/dm-bufio.c    | 30 ++++++++----------------------
>  include/linux/sched.h    |  1 +
>  include/linux/sched/mm.h | 12 ++++++++----
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 6d1565021d74..140ada9a2c8f 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -412,23 +412,6 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
>  
>  	*data_mode = DATA_MODE_VMALLOC;
>  
> -	/*
> -	 * __vmalloc allocates the data pages and auxiliary structures with
> -	 * gfp_flags that were specified, but pagetables are always allocated
> -	 * with GFP_KERNEL, no matter what was specified as gfp_mask.
> -	 *
> -	 * Consequently, we must set per-process flag PF_MEMALLOC_NOIO so that
> -	 * all allocations done by this process (including pagetables) are done
> -	 * as if GFP_NOIO was specified.
> -	 */
> -	if (gfp_mask & __GFP_NORETRY) {
> -		unsigned noio_flag = memalloc_noio_save();
> -		void *ptr = __vmalloc(c->block_size, gfp_mask);
> -
> -		memalloc_noio_restore(noio_flag);
> -		return ptr;
> -	}
> -
>  	return __vmalloc(c->block_size, gfp_mask);
>  }
>  
> @@ -866,9 +849,6 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 * dm-bufio is resistant to allocation failures (it just keeps
>  	 * one buffer reserved in cases all the allocations fail).
>  	 * So set flags to not try too hard:
> -	 *	GFP_NOWAIT: don't wait; if we need to sleep we'll release our
> -	 *		    mutex and wait ourselves.
> -	 *	__GFP_NORETRY: don't retry and rather return failure
>  	 *	__GFP_NOMEMALLOC: don't use emergency reserves
>  	 *	__GFP_NOWARN: don't print a warning in case of failure
>  	 *
> @@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 */
>  	while (1) {
>  		if (dm_bufio_cache_size_latch != 1) {
> -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			unsigned nowait_flag = memalloc_nowait_save();
> +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			memalloc_nowait_restore(nowait_flag);
>  			if (b)
>  				return b;
>  		}
> @@ -886,8 +868,12 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  			return NULL;
>  
>  		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
> +			unsigned noio_flag;
> +
>  			dm_bufio_unlock(c);
> -			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			noio_flag = memalloc_noio_save();
> +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			memalloc_noio_restore(noio_flag);
>  			dm_bufio_lock(c);
>  			if (b)
>  				return b;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 90336850e940..b1c2cddd366c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -803,6 +803,7 @@ struct task_struct {
>  #endif
>  	unsigned			memalloc_noio:1;
>  	unsigned			memalloc_nofs:1;
> +	unsigned			memalloc_nowait:1;

I think you also need to update gfpflags_allow_blocking() to take your new
flag into account, or some debug checks all over the place might misfire.

Plus I have a patch which rolls this out to a few more places in all the
allocators.
-Daniel

>  	unsigned			memalloc_nocma:1;
>  
>  	unsigned long			atomic_flags; /* Flags requiring atomic access. */
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 6f7b59a848a6..6484569f50df 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -179,12 +179,16 @@ static inline bool in_vfork(struct task_struct *tsk)
>  static inline gfp_t current_gfp_context(gfp_t flags)
>  {
>  	if (unlikely(current->memalloc_noio || current->memalloc_nofs ||
> -		     current->memalloc_nocma)) {
> +		     current->memalloc_nocma) || current->memalloc_nowait) {
>  		/*
> -		 * NOIO implies both NOIO and NOFS and it is a weaker context
> -		 * so always make sure it makes precedence
> +		 * Clearing DIRECT_RECLAIM means we won't get to the point
> +		 * of testing IO or FS, so we don't need to bother clearing
> +		 * them.  noio implies neither IO nor FS and it is a weaker
> +		 * context so always make sure it takes precedence.
>  		 */
> -		if (current->memalloc_noio)
> +		if (current->memalloc_nowait)
> +			flags &= ~__GFP_DIRECT_RECLAIM;
> +		else if (current->memalloc_noio)
>  			flags &= ~(__GFP_IO | __GFP_FS);
>  		else if (current->memalloc_nofs)
>  			flags &= ~__GFP_FS;
> -- 
> 2.27.0
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
