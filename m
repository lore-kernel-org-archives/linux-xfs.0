Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CED2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 13:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07CDB20672
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593092108;
	bh=B+NvDd+iBL3uwIFdsmtKVl+bVtcSaC9CvrV/j5Ezo3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NUXcKZu687PHAfaipBg6daCc+kIK50RRjY7D9wqM8sTkZyUftYP7zMbDRarbGHOm+
	 wsOzeD/9qHuK4wuctcRY7GUlGXYvp/6LLQazHvYNJvbe6B7kL3H9O2yy8sw+DXo6Wu
	 ssAl4ovwCF0Pi5j3hJQNJ/fZQG4iO367TMCgvT6w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405040AbgFYNfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 09:35:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33952 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404926AbgFYNfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 09:35:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id f7so2876576wrw.1;
        Thu, 25 Jun 2020 06:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IgYZrPxHW1Yk3TwSNNUUSYdD36C5CbbVMe0vITplDXw=;
        b=l9q7AAgALfEqsZH2LniIPsbgf/nk72MJtcRxv57X9inKyshrK2aHeVgKtvAK/OamCJ
         HeK02zV25X/7jL9Fkletwj8wbGoplY+b0MljuijeGAoVVtYrwbMp9KyCB1Q9zrNcLPFU
         7Rfl+564+EctTHdF47lGajmoNhpZl9CZBHL/V9tK9YpwMFEIIUkzyEYUzVX2HQBQIcgF
         Y1QAIzO8XNXKXkTUiHeMBleNxjFFLHBsbrrv4faLdQOeQz2vfeEwQoAqViDLCGLT8Elo
         0jhxtyoJPvyVBRwOx8XfYy9yuJaI78IwjDqOOhjpXwzJ4bFfnGMsDMbyiMW1VzcVexvh
         Hzpw==
X-Gm-Message-State: AOAM532TOT3nFTVq72rTMGzQF5unkpWxwc6syyfZ55TCy8r9doVL0l7N
        +x6YFWc1okbt4Usj7rjZZsKXhvsf
X-Google-Smtp-Source: ABdhPJwaddI6ttW180z9XolsU5F/8EUo6u4oLwe5Z7g00mWKYqqFcDJ9Z0yPcz+5CvQGbwEE1bpQkg==
X-Received: by 2002:a05:6000:18c:: with SMTP id p12mr39132209wrx.66.1593092105200;
        Thu, 25 Jun 2020 06:35:05 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id c143sm14010709wmd.1.2020.06.25.06.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 06:35:04 -0700 (PDT)
Date:   Thu, 25 Jun 2020 15:35:03 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/6] mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
Message-ID: <20200625133503.GO1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-5-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 25-06-20 12:31:20, Matthew Wilcox wrote:
> We're short on PF_* flags, so make memalloc_nofs its own bit where we
> have plenty of space.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

forgot to add
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  fs/iomap/buffered-io.c   |  2 +-
>  include/linux/sched.h    |  2 +-
>  include/linux/sched/mm.h | 13 ++++++-------
>  3 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index bcfc288dba3f..87d66c13bf5c 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1502,7 +1502,7 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
>  	 * Given that we do not allow direct reclaim to call us, we should
>  	 * never be called in a recursive filesystem reclaim context.
>  	 */
> -	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
> +	if (WARN_ON_ONCE(current->memalloc_nofs))
>  		goto redirty;
>  
>  	/*
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index cf18a3d2bc4c..eaf36ae1fde2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -802,6 +802,7 @@ struct task_struct {
>  	unsigned			in_memstall:1;
>  #endif
>  	unsigned			memalloc_noio:1;
> +	unsigned			memalloc_nofs:1;
>  
>  	unsigned long			atomic_flags; /* Flags requiring atomic access. */
>  
> @@ -1505,7 +1506,6 @@ extern struct pid *cad_pid;
>  #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
>  #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
>  #define PF_KSWAPD		0x00020000	/* I am kswapd */
> -#define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
>  #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
>  						 * I am cleaning dirty pages from some other bdi. */
>  #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index b0089eadc367..08bc9d0606a8 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -175,20 +175,19 @@ static inline bool in_vfork(struct task_struct *tsk)
>  
>  /*
>   * Applies per-task gfp context to the given allocation flags.
> - * PF_MEMALLOC_NOFS implies GFP_NOFS
>   * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
>   */
>  static inline gfp_t current_gfp_context(gfp_t flags)
>  {
> -	if (unlikely(current->flags & (PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA) ||
> -		     current->memalloc_noio)) {
> +	if (unlikely((current->flags & PF_MEMALLOC_NOCMA) ||
> +		     current->memalloc_noio || current->memalloc_nofs)) {
>  		/*
>  		 * NOIO implies both NOIO and NOFS and it is a weaker context
>  		 * so always make sure it makes precedence
>  		 */
>  		if (current->memalloc_noio)
>  			flags &= ~(__GFP_IO | __GFP_FS);
> -		else if (current->flags & PF_MEMALLOC_NOFS)
> +		else if (current->memalloc_nofs)
>  			flags &= ~__GFP_FS;
>  #ifdef CONFIG_CMA
>  		if (current->flags & PF_MEMALLOC_NOCMA)
> @@ -254,8 +253,8 @@ static inline void memalloc_noio_restore(unsigned int flags)
>   */
>  static inline unsigned int memalloc_nofs_save(void)
>  {
> -	unsigned int flags = current->flags & PF_MEMALLOC_NOFS;
> -	current->flags |= PF_MEMALLOC_NOFS;
> +	unsigned int flags = current->memalloc_nofs;
> +	current->memalloc_nofs = 1;
>  	return flags;
>  }
>  
> @@ -269,7 +268,7 @@ static inline unsigned int memalloc_nofs_save(void)
>   */
>  static inline void memalloc_nofs_restore(unsigned int flags)
>  {
> -	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
> +	current->memalloc_nofs = flags ? 1 : 0;
>  }
>  
>  static inline unsigned int memalloc_noreclaim_save(void)
> -- 
> 2.27.0

-- 
Michal Hocko
SUSE Labs
