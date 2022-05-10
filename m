Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887A2C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiEJX7w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiEJX7g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D5243104
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7285FB81DF5
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A31DC385CC;
        Tue, 10 May 2022 23:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652227172;
        bh=tWN2qLhTZqSCRpCSjIZiYgopgBDq1SsC77x/kVWe++g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DhuY8YYpMT3qSM4fbvxMw5wLzZerG6L7CIO78qAvsvnCqZIT9EarcGXouE9KupH1a
         LsaKAogDy8ZKg5AsiN4SEaMSymVERevty/XLA4KLGdlLmTquwt9fCMNBBExMxS8cWz
         10uiQGhTvR3sGMg6QvdoYA4/OQGP0APtTiL4qMAzsNtPKyZeYzTGy1zl1djbdKKphV
         8H1Syn6qToMw7xVN+YxoqQrsRu0NUSS8BjfnIt1DP+PTr2iJeuUX+S4J9FptDxzJTg
         boasP3bnREa8nCjTgXcKGMGjwJ2VNvEB+m184ZoSgmn/Chi7rHAWhyrO5jGL/qcotg
         cVzdPkfPioiDw==
Date:   Tue, 10 May 2022 16:59:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/18] xfs: can't use kmem_zalloc() for attribute buffers
Message-ID: <20220510235931.GX27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220510222716.GW1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510222716.GW1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 08:27:16AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because when running fsmark workloads with 64kB xattrs, heap
> allocation of >64kB buffers for the attr item name/value buffer
> will fail and deadlock.
> 
> ....
>  XFS: fs_mark(8414) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8417) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8409) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8428) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8430) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8437) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8433) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8406) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8412) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8432) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
>  XFS: fs_mark(8424) possible memory allocation deadlock size 65768 in kmem_alloc (mode:0x2d40)
> ....
> 
> I'd use kvmalloc(), but if we are doing 15,000 64kB xattr creates a
> second, the attempt to use kmalloc() in kvmalloc() results in a huge
> amount of direct reclaim work that is guaranteed to fail occurs
> before it falls back to vmalloc:
> 
> - 48.19% xfs_attr_create_intent
>   - 46.89% xfs_attri_init
>      - kvmalloc_node
> 	- 46.04% __kmalloc_node
> 	   - kmalloc_large_node
> 	      - 45.99% __alloc_pages
> 		 - 39.39% __alloc_pages_slowpath.constprop.0
> 		    - 38.89% __alloc_pages_direct_compact
> 		       - 38.71% try_to_compact_pages
> 			  - compact_zone_order
> 			  - compact_zone
> 			     - 21.09% isolate_migratepages_block
> 				  10.31% PageHuge
> 				  5.82% set_pfnblock_flags_mask
> 				  0.86% get_pfnblock_flags_mask
> 			     - 4.48% __reset_isolation_suitable
> 				  4.44% __reset_isolation_pfn
> 			     - 3.56% __pageblock_pfn_to_page
> 				  1.33% pfn_to_online_page
> 			       2.83% get_pfnblock_flags_mask
> 			     - 0.87% migrate_pages
> 				  0.86% compaction_alloc
> 			       0.84% find_suitable_fallback
> 		 - 6.60% get_page_from_freelist
> 		      4.99% clear_page_erms
> 		    - 1.19% _raw_spin_lock_irqsave
> 		       - do_raw_spin_lock
> 			    __pv_queued_spin_lock_slowpath
> 	- 0.86% __vmalloc_node_range
> 	     0.65% __alloc_pages_bulk
> 
> So lift xlog_cil_kvmalloc(), rename it to xlog_kvmalloc() and use
> that instead because it has sane fail-fast behaviour for the
> embedded kmalloc attempt. It also provides __GFP_NOFAIL guarantees
> that kvmalloc() won't do, either....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr_item.c | 35 +++++++++++++++--------------------
>  fs/xfs/xfs_log_cil.c   | 35 +----------------------------------
>  fs/xfs/xfs_log_priv.h  | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 56f678c965b7..e8ac88d9fd14 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -44,7 +44,7 @@ xfs_attri_item_free(
>  	struct xfs_attri_log_item	*attrip)
>  {
>  	kmem_free(attrip->attri_item.li_lv_shadow);
> -	kmem_free(attrip);
> +	kvfree(attrip);
>  }
>  
>  /*
> @@ -119,11 +119,11 @@ xfs_attri_item_format(
>  			sizeof(struct xfs_attri_log_format));
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>  			attrip->attri_name,
> -			xlog_calc_iovec_len(attrip->attri_name_len));
> +			attrip->attri_name_len);

Are we fixing these because the xlog_{copy,finish}_iovec functions do
the rounding themselves now?

>  	if (attrip->attri_value_len > 0)
>  		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>  				attrip->attri_value,
> -				xlog_calc_iovec_len(attrip->attri_value_len));
> +				attrip->attri_value_len);
>  }
>  
>  /*
> @@ -163,26 +163,21 @@ xfs_attri_init(
>  
>  {
>  	struct xfs_attri_log_item	*attrip;
> -	uint32_t			name_vec_len = 0;
> -	uint32_t			value_vec_len = 0;
> -	uint32_t			buffer_size;
> -
> -	if (name_len)
> -		name_vec_len = xlog_calc_iovec_len(name_len);
> -	if (value_len)
> -		value_vec_len = xlog_calc_iovec_len(value_len);

...and we don't need to bloat up the internal structures anymore either,
right?

> -
> -	buffer_size = name_vec_len + value_vec_len;
> +	uint32_t			buffer_size = name_len + value_len;
>  
>  	if (buffer_size) {
> -		attrip = kmem_zalloc(sizeof(struct xfs_attri_log_item) +
> -				    buffer_size, KM_NOFS);
> -		if (attrip == NULL)
> -			return NULL;
> +		/*
> +		 * This could be over 64kB in length, so we have to use
> +		 * kvmalloc() for this. But kvmalloc() utterly sucks, so we
> +		 * use own version.
> +		 */
> +		attrip = xlog_kvmalloc(sizeof(struct xfs_attri_log_item) +
> +					buffer_size);
>  	} else {
> -		attrip = kmem_cache_zalloc(xfs_attri_cache,
> -					  GFP_NOFS | __GFP_NOFAIL);
> +		attrip = kmem_cache_alloc(xfs_attri_cache,
> +					GFP_NOFS | __GFP_NOFAIL);
>  	}
> +	memset(attrip, 0, sizeof(struct xfs_attri_log_item));

I wonder if this memset should be right after the xlog_kvmalloc and
leave the kmem_cache_zalloc alone?

Looks solid otherwise.

--D

>  
>  	attrip->attri_name_len = name_len;
>  	if (name_len)
> @@ -195,7 +190,7 @@ xfs_attri_init(
>  	if (value_len)
>  		attrip->attri_value = ((char *)attrip) +
>  				sizeof(struct xfs_attri_log_item) +
> -				name_vec_len;
> +				name_len;
>  	else
>  		attrip->attri_value = NULL;
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 42ace9b091d8..b4023693b89f 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -219,39 +219,6 @@ xlog_cil_iovec_space(
>  			sizeof(uint64_t));
>  }
>  
> -/*
> - * shadow buffers can be large, so we need to use kvmalloc() here to ensure
> - * success. Unfortunately, kvmalloc() only allows GFP_KERNEL contexts to fall
> - * back to vmalloc, so we can't actually do anything useful with gfp flags to
> - * control the kmalloc() behaviour within kvmalloc(). Hence kmalloc() will do
> - * direct reclaim and compaction in the slow path, both of which are
> - * horrendously expensive. We just want kmalloc to fail fast and fall back to
> - * vmalloc if it can't get somethign straight away from the free lists or buddy
> - * allocator. Hence we have to open code kvmalloc outselves here.
> - *
> - * Also, we are in memalloc_nofs_save task context here, so despite the use of
> - * GFP_KERNEL here, we are actually going to be doing GFP_NOFS allocations. This
> - * is actually the only way to make vmalloc() do GFP_NOFS allocations, so lets
> - * just all pretend this is a GFP_KERNEL context operation....
> - */
> -static inline void *
> -xlog_cil_kvmalloc(
> -	size_t		buf_size)
> -{
> -	gfp_t		flags = GFP_KERNEL;
> -	void		*p;
> -
> -	flags &= ~__GFP_DIRECT_RECLAIM;
> -	flags |= __GFP_NOWARN | __GFP_NORETRY;
> -	do {
> -		p = kmalloc(buf_size, flags);
> -		if (!p)
> -			p = vmalloc(buf_size);
> -	} while (!p);
> -
> -	return p;
> -}
> -
>  /*
>   * Allocate or pin log vector buffers for CIL insertion.
>   *
> @@ -368,7 +335,7 @@ xlog_cil_alloc_shadow_bufs(
>  			 * storage.
>  			 */
>  			kmem_free(lip->li_lv_shadow);
> -			lv = xlog_cil_kvmalloc(buf_size);
> +			lv = xlog_kvmalloc(buf_size);
>  
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 4aa95b68450a..46f989641eda 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -679,4 +679,38 @@ xlog_valid_lsn(
>   */
>  void xlog_cil_pcp_dead(struct xlog *log, unsigned int cpu);
>  
> +/*
> + * Log vector and shadow buffers can be large, so we need to use kvmalloc() here
> + * to ensure success. Unfortunately, kvmalloc() only allows GFP_KERNEL contexts
> + * to fall back to vmalloc, so we can't actually do anything useful with gfp
> + * flags to control the kmalloc() behaviour within kvmalloc(). Hence kmalloc()
> + * will do direct reclaim and compaction in the slow path, both of which are
> + * horrendously expensive. We just want kmalloc to fail fast and fall back to
> + * vmalloc if it can't get somethign straight away from the free lists or
> + * buddy allocator. Hence we have to open code kvmalloc outselves here.
> + *
> + * This assumes that the caller uses memalloc_nofs_save task context here, so
> + * despite the use of GFP_KERNEL here, we are going to be doing GFP_NOFS
> + * allocations. This is actually the only way to make vmalloc() do GFP_NOFS
> + * allocations, so lets just all pretend this is a GFP_KERNEL context
> + * operation....
> + */
> +static inline void *
> +xlog_kvmalloc(
> +	size_t		buf_size)
> +{
> +	gfp_t		flags = GFP_KERNEL;
> +	void		*p;
> +
> +	flags &= ~__GFP_DIRECT_RECLAIM;
> +	flags |= __GFP_NOWARN | __GFP_NORETRY;
> +	do {
> +		p = kmalloc(buf_size, flags);
> +		if (!p)
> +			p = vmalloc(buf_size);
> +	} while (!p);
> +
> +	return p;
> +}
> +
>  #endif	/* __XFS_LOG_PRIV_H__ */
> -- 
> Dave Chinner
> david@fromorbit.com
