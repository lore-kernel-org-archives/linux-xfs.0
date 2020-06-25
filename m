Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238DBC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC0F20709
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593088308;
	bh=uZyquXWX2uZbi7C4PfxooqqslUf/H9KACJBSxEKBJzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OT2RB5Fb9YPH2b6flcAGgFBXuv3nQQzf3pBxWAXQTycDAtiPi7qgisu8jEPe97pJP
	 tioSUrGcAMJPO3tRMvL32CRnAOdP7IivY+PuTOwR6wpvKQR1qdvm8sxaFD0wiPw6Za
	 iObZYurdrqqLfVPXvkTUctfOc2JPXZphc0bl7aIk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404508AbgFYMbr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:31:47 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:45098 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404343AbgFYMbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:31:47 -0400
Received: by mail-ej1-f66.google.com with SMTP id a1so5724405ejg.12;
        Thu, 25 Jun 2020 05:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LfL/J6kcjTPEsDskt6aLX8PefsDeHP4anavcHPUMTKA=;
        b=K8tP2qbXQI2hBSalRv4SKfazP6iRV3H2GezAc8E8Uh9rrhiWuQ8Uqg34LY7Fb6evnI
         l0B30MTdDB8NfVH+KqkGnEjAhchh7qqCHacKA4oePCjNf6TrHlbE0h6RdihWtzcD6spO
         IE8vZBokrOoqo6uM3O/nZUnpG3CboXOzspyfNggmh3UZuWqH9stnfsm8dKW0rUYkyuq6
         laFq5z4Bb37H2lDLFaKcdL6RTThXEoBdGPecY/sJJA1qLPPP8FRrX51vy/UNLpxHukgN
         TzJQMEzsGodiU98ggnmLqKKHWgzO/aMakaLVJ7b+s9Sl9MnE0UqIB2SnSEaU/RL4mTx4
         J3XA==
X-Gm-Message-State: AOAM530w5IK5YXKYgtRq/pvNRb0vyX7+bEIhjkMbTaP28RkyOk1Dd0gq
        MTQHz5NVGHmYaldpcgU8ebY=
X-Google-Smtp-Source: ABdhPJyiXDwgXlrcNxDquN/m7X009TUFeb5rEVdNCJL2oLKPwCGm2N5mD6JL7UM8/mFBSoWnOD0BJw==
X-Received: by 2002:a17:906:3d41:: with SMTP id q1mr30164872ejf.12.1593088305149;
        Thu, 25 Jun 2020 05:31:45 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id u13sm11449983ejx.3.2020.06.25.05.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 05:31:44 -0700 (PDT)
Date:   Thu, 25 Jun 2020 14:31:43 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/6] mm: Add become_kswapd and restore_kswapd
Message-ID: <20200625123143.GK1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-3-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 25-06-20 12:31:18, Matthew Wilcox wrote:
> Since XFS needs to pretend to be kswapd in some of its worker threads,
> create methods to save & restore kswapd state.  Don't bother restoring
> kswapd state in kswapd -- the only time we reach this code is when we're
> exiting and the task_struct is about to be destroyed anyway.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Certainly better than an opencoded PF_$FOO manipulation
Acked-by: Michal Hocko <mhocko@suse.com>

I would just ask for a clarification because this is rellying to have a
good MM knowledge to follow

> +/*
> + * Tell the memory management that we're a "memory allocator",

I would go with.
Tell the memory management that the caller is working on behalf of the
background memory reclaim (aka kswapd) and help it to make a forward
progress. That means that it will get an access to memory reserves
should there be a need to allocate memory in order to make a forward
progress. Note that the caller has to be extremely careful when doing
that.

Or something like that.

> + * and that if we need more memory we should get access to it
> + * regardless (see "__alloc_pages()"). "kswapd" should
> + * never get caught in the normal page freeing logic.
> + *
> + * (Kswapd normally doesn't need memory anyway, but sometimes
> + * you need a small amount of memory in order to be able to
> + * page out something else, and this flag essentially protects
> + * us from recursively trying to free more memory as we're
> + * trying to free the first piece of memory in the first place).
> + */
> +#define KSWAPD_PF_FLAGS		(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD)
> +
> +static inline unsigned long become_kswapd(void)
> +{
> +	unsigned long flags = current->flags & KSWAPD_PF_FLAGS;
> +	current->flags |= KSWAPD_PF_FLAGS;
> +	return flags;
> +}
> +
> +static inline void restore_kswapd(unsigned long flags)
> +{
> +	current->flags &= ~(flags ^ KSWAPD_PF_FLAGS);
> +}
> +
>  static inline void set_current_io_flusher(void)
>  {
>  	current->flags |= PF_LOCAL_THROTTLE;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b6d84326bdf2..27ae76699899 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3870,19 +3870,7 @@ static int kswapd(void *p)
>  	if (!cpumask_empty(cpumask))
>  		set_cpus_allowed_ptr(tsk, cpumask);
>  
> -	/*
> -	 * Tell the memory management that we're a "memory allocator",
> -	 * and that if we need more memory we should get access to it
> -	 * regardless (see "__alloc_pages()"). "kswapd" should
> -	 * never get caught in the normal page freeing logic.
> -	 *
> -	 * (Kswapd normally doesn't need memory anyway, but sometimes
> -	 * you need a small amount of memory in order to be able to
> -	 * page out something else, and this flag essentially protects
> -	 * us from recursively trying to free more memory as we're
> -	 * trying to free the first piece of memory in the first place).
> -	 */
> -	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> +	become_kswapd();
>  	set_freezable();
>  
>  	WRITE_ONCE(pgdat->kswapd_order, 0);
> @@ -3932,8 +3920,6 @@ static int kswapd(void *p)
>  			goto kswapd_try_sleep;
>  	}
>  
> -	tsk->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD);
> -
>  	return 0;
>  }
>  
> -- 
> 2.27.0
> 

-- 
Michal Hocko
SUSE Labs
