Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B44C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB6D20707
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593087768;
	bh=POCzLC3lxb0jonPUfHvMfrWw0tlVXhBmDHam6JwEXTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HjIzS97/68FGNAfRRSo8+heECZQORGbPAeKugccMkYC/vvPOyNYKTo9+ZzcK82QXM
	 qAyLV+NjW3jcRiitVxDwqD7ht6Icr+tBAY8VwgQsTVZi93Eij2IWshKTHrFqk/c/5m
	 jxrf9X0dF0glM/3nBugTaHIDkQjoe/rg6oKoxTeE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404343AbgFYMWr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:22:47 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:34469 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404508AbgFYMWq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:22:46 -0400
Received: by mail-ej1-f67.google.com with SMTP id y10so5754969eje.1;
        Thu, 25 Jun 2020 05:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TYH8Ej/PPMwtZMk1atQ1DDjN+0+NMiukCpyuH/l8Kqo=;
        b=dENPPl9IhHE4wMM7UeGskjqJBjKvzQainSbAwzh/a54uC3Bz2VMBftgb3xHT/TTj9q
         emwHqcJYqWtMHzyRv0KCVIAzkC8O10GfjYDlrG5/bxWuhZxLigQKK5kbdoVGB3NUTlSl
         PtP8EsWg1ScgiaDhJRAfCwSTt247rJiuE7SFepGcrDUpngMcVeAn/hWlPhiAcYYZkFvk
         07boazjnrCEPCVdH0V8Ig+ojXraMT36lqzKzzk+Ei9qr9AyzqUqkKWWCkTVIOuPtrC4c
         HZjYkrg4kcVJl72cKrO6h4z13SacR8wMvZeONWc/whieQhO4sxNz21jywyTmNU/x1Rxf
         mWKA==
X-Gm-Message-State: AOAM5310NkOZ36vNYPwMVs+eJwHJQu2Vbu264FYhbeG+pRFNHxoVecr0
        Ch8hVE2ZVvl8ar6GD/HJpnM=
X-Google-Smtp-Source: ABdhPJxee0+FCUz90KDfNPrGix/+3ufKfv7M9wy1KKSns79yzVg+Jz95sa5CdEjBwCDMijHTFZfU3g==
X-Received: by 2002:a17:906:7e04:: with SMTP id e4mr20722062ejr.502.1593087762175;
        Thu, 25 Jun 2020 05:22:42 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id l18sm17858417eds.46.2020.06.25.05.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 05:22:41 -0700 (PDT)
Date:   Thu, 25 Jun 2020 14:22:39 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
Message-ID: <20200625122239.GJ1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-2-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 25-06-20 12:31:17, Matthew Wilcox wrote:
> We're short on PF_* flags, so make memalloc_noio its own bit where we
> have plenty of space.

I do not mind moving that outside of the PF_* space. Unless I
misremember all flags in this space were intented to be set only on the
current which rules out any RMW races and therefore they can be
lockless. I am not sure this holds for the bitfield you are adding this
to. At least in_memstall seem to be set on external task as well. But
this would require double checking. Maybe that is not really intended or
just a bug.

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/block/loop.c           |  3 ++-
>  drivers/md/dm-zoned-metadata.c |  5 ++---
>  include/linux/sched.h          |  2 +-
>  include/linux/sched/mm.h       | 30 +++++++++++++++++++++++-------
>  kernel/sys.c                   |  8 +++-----
>  5 files changed, 31 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 475e1a738560..c8742e25e58a 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -52,6 +52,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/sched.h>
> +#include <linux/sched/mm.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
>  #include <linux/stat.h>
> @@ -929,7 +930,7 @@ static void loop_unprepare_queue(struct loop_device *lo)
>  
>  static int loop_kthread_worker_fn(void *worker_ptr)
>  {
> -	current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
> +	set_current_io_flusher();
>  	return kthread_worker_fn(worker_ptr);
>  }
>  
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 130b5a6d9f12..1c5ae674ba20 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1599,9 +1599,8 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  
>  	/*
>  	 * Get zone information from disk. Since blkdev_report_zones() uses
> -	 * GFP_KERNEL by default for memory allocations, set the per-task
> -	 * PF_MEMALLOC_NOIO flag so that all allocations are done as if
> -	 * GFP_NOIO was specified.
> +	 * GFP_KERNEL by default for memory allocations, use
> +	 * memalloc_noio_save() to prevent recursion into the driver.
>  	 */
>  	noio_flag = memalloc_noio_save();
>  	ret = blkdev_report_zones(dev->bdev, dmz_start_sect(zmd, zone), 1,
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b62e6aaf28f0..cf18a3d2bc4c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -801,6 +801,7 @@ struct task_struct {
>  	/* Stalled due to lack of memory */
>  	unsigned			in_memstall:1;
>  #endif
> +	unsigned			memalloc_noio:1;
>  
>  	unsigned long			atomic_flags; /* Flags requiring atomic access. */
>  
> @@ -1505,7 +1506,6 @@ extern struct pid *cad_pid;
>  #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
>  #define PF_KSWAPD		0x00020000	/* I am kswapd */
>  #define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
> -#define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
>  #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
>  						 * I am cleaning dirty pages from some other bdi. */
>  #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 480a4d1b7dd8..1a7e1ab1be85 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -175,19 +175,18 @@ static inline bool in_vfork(struct task_struct *tsk)
>  
>  /*
>   * Applies per-task gfp context to the given allocation flags.
> - * PF_MEMALLOC_NOIO implies GFP_NOIO
>   * PF_MEMALLOC_NOFS implies GFP_NOFS
>   * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
>   */
>  static inline gfp_t current_gfp_context(gfp_t flags)
>  {
> -	if (unlikely(current->flags &
> -		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
> +	if (unlikely(current->flags & (PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA) ||
> +		     current->memalloc_noio)) {
>  		/*
>  		 * NOIO implies both NOIO and NOFS and it is a weaker context
>  		 * so always make sure it makes precedence
>  		 */
> -		if (current->flags & PF_MEMALLOC_NOIO)
> +		if (current->memalloc_noio)
>  			flags &= ~(__GFP_IO | __GFP_FS);
>  		else if (current->flags & PF_MEMALLOC_NOFS)
>  			flags &= ~__GFP_FS;
> @@ -224,8 +223,8 @@ static inline void fs_reclaim_release(gfp_t gfp_mask) { }
>   */
>  static inline unsigned int memalloc_noio_save(void)
>  {
> -	unsigned int flags = current->flags & PF_MEMALLOC_NOIO;
> -	current->flags |= PF_MEMALLOC_NOIO;
> +	unsigned int flags = current->memalloc_noio;
> +	current->memalloc_noio = 1;
>  	return flags;
>  }
>  
> @@ -239,7 +238,7 @@ static inline unsigned int memalloc_noio_save(void)
>   */
>  static inline void memalloc_noio_restore(unsigned int flags)
>  {
> -	current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
> +	current->memalloc_noio = flags ? 1 : 0;
>  }
>  
>  /**
> @@ -309,6 +308,23 @@ static inline void memalloc_nocma_restore(unsigned int flags)
>  }
>  #endif
>  
> +static inline void set_current_io_flusher(void)
> +{
> +	current->flags |= PF_LOCAL_THROTTLE;
> +	current->memalloc_noio = 1;
> +}
> +
> +static inline void clear_current_io_flusher(void)
> +{
> +	current->flags &= ~PF_LOCAL_THROTTLE;
> +	current->memalloc_noio = 0;
> +}
> +
> +static inline bool get_current_io_flusher(void)
> +{
> +	return current->flags & PF_LOCAL_THROTTLE;
> +}
> +
>  #ifdef CONFIG_MEMCG
>  /**
>   * memalloc_use_memcg - Starts the remote memcg charging scope.
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 00a96746e28a..78c90d1e92f4 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2275,8 +2275,6 @@ int __weak arch_prctl_spec_ctrl_set(struct task_struct *t, unsigned long which,
>  	return -EINVAL;
>  }
>  
> -#define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
> -
>  SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		unsigned long, arg4, unsigned long, arg5)
>  {
> @@ -2512,9 +2510,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			return -EINVAL;
>  
>  		if (arg2 == 1)
> -			current->flags |= PR_IO_FLUSHER;
> +			set_current_io_flusher();
>  		else if (!arg2)
> -			current->flags &= ~PR_IO_FLUSHER;
> +			clear_current_io_flusher();
>  		else
>  			return -EINVAL;
>  		break;
> @@ -2525,7 +2523,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  
> -		error = (current->flags & PR_IO_FLUSHER) == PR_IO_FLUSHER;
> +		error = get_current_io_flusher();
>  		break;
>  	default:
>  		error = -EINVAL;
> -- 
> 2.27.0
> 

-- 
Michal Hocko
SUSE Labs
