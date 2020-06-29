Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0A8C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFA3206A1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466387;
	bh=LBfhDIhyAbegWKiFoWANZi3Pap2eilYpWYyw9E97Frw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=oSUu+gP6SlrY25+QmMdMaG32bcFJl3qc+EkxCH+6grTmFpJLAs19twjxtbmFRqHWU
	 0a2smroEIVAI4p7LIEu5mITgU9a9WvEzc8hpXDCVIiK+BtBAw/KULeKgBpzPMectkQ
	 iLaXkqldNyJUt/9kF2iBbfPIhE65cKiIsg9LzhDA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgF2Vc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgF2SlD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:03 -0400
Received: from kernel.org (unknown [87.71.40.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FEEC2311E;
        Mon, 29 Jun 2020 05:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593407337;
        bh=LBfhDIhyAbegWKiFoWANZi3Pap2eilYpWYyw9E97Frw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kn0EDPLt/kFtL3TZwbVsUV6b9Vc5HPIVlyu8B/7Z9XfljZNUO7/rCJq63g5bf9pSJ
         OuJViNwGVJTHvPk1NoY7dWJEDKZDnrb/oqmreD43xNTbok6DB/kaiaAxuKlUdglMKc
         LIKCiivFZH7gq+RcuYB4BDBIb7L2Rr8ceeaQPnaU=
Date:   Mon, 29 Jun 2020 08:08:51 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200629050851.GC1492837@kernel.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-7-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
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

I've read the series twice and I'm still missing the definition of
memalloc_noio_save().

And also it would be nice to have a paragraph about it in
Documentation/core-api/memory-allocation.rst

> +			b = alloc_buffer(c, GFP_KERNEL |
> __GFP_NOMEMALLOC | __GFP_NOWARN); +
> memalloc_noio_restore(noio_flag); dm_bufio_lock(c); if (b)
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
Sincerely yours,
Mike.
