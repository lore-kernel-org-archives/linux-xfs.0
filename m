Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939EB22F1E
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710870500; cv=none; b=cv0M34SFlb2xu7M4jAM4TL27oIMudP21zf7ZL6Kjhcf0jQ1ElZ1/BgKYksh/sSLZmb8z5cPTtfENBMmVxgwShFE7+LDrsGHKy3sPwiTqubKow6Wpat8dRfMwqDpNxn8g7mLjXuRqXs56y8AXcT3NaWWNpxFut0O8+0XKu27jUog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710870500; c=relaxed/simple;
	bh=XzsTwXgOKCC7HCcIuo8KBN3+JCDoOREFmWcLMxFZw9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIAiHCqOVnBo009zFEocxnByAw+4Gau/IDhqRZOI+pTHVLKZu1yB0e20CLqUPGQ3IDTQQlRrxbIH1wbLXY8CkMHuiIz8cZPnMvFSfCFx9Kw/fHTeWOFZ7Xe218QOzn1BW6GButF7gJkTP0A221cWXbk12cBI4obE0gfrXQgNv8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dk/3Tdzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dk/3Tdzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2678DC433F1;
	Tue, 19 Mar 2024 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710870500;
	bh=XzsTwXgOKCC7HCcIuo8KBN3+JCDoOREFmWcLMxFZw9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dk/3Tdzvsucg5oQKXcv9VBPldQaqPLA6WZqjMZ/YI0dgOpaan+5oWUgrs7UXn+bQx
	 KcSsMHeZypQFENDFIAY45yUCuzdPpWcHaxkMe0Y+fU8pOWQLFlyV9fnzTlozSIWt7H
	 KX6kGCKIovf7Pis5dtRwHkaNMMdc1kScVcdwZhy4S8rRCpzSOKJHpGpAfzsSr/5eOc
	 eZlnkwrZcIKKihXq9kzBRQ1jaqECHNqS8kzvw7MBkIMpyXpj778toTMltMTg3FZphh
	 VxTjBnX7UIB6ymL6R4FXpUVOiVyBTUEYv0Gn29JQOcNJV6oTlpoA/pq0CXuWwI62Wg
	 qngTuPiqxyFVQ==
Date: Tue, 19 Mar 2024 10:48:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: use vmalloc for multi-folio buffers
Message-ID: <20240319174819.GU1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-9-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-9-david@fromorbit.com>

On Tue, Mar 19, 2024 at 09:45:59AM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Instead of allocating the folios manually using the bulk page
> allocator and then using vm_map_page just use vmalloc to allocate
> the entire buffer - vmalloc will use the bulk allocator internally
> if it fits.
> 
> With this the b_folios array can go away as well as nothing uses it.
> 
> [dchinner: port to folio based buffers.]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c     | 164 ++++++++++++-------------------------------
>  fs/xfs/xfs_buf.h     |   2 -
>  fs/xfs/xfs_buf_mem.c |   9 +--
>  3 files changed, 45 insertions(+), 130 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 303945554415..6d6bad80722e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -282,29 +282,6 @@ _xfs_buf_alloc(
>  	return 0;
>  }
>  
> -static void
> -xfs_buf_free_folios(
> -	struct xfs_buf	*bp)
> -{
> -	uint		i;
> -
> -	ASSERT(bp->b_flags & _XBF_FOLIOS);
> -
> -	if (xfs_buf_is_vmapped(bp))
> -		vm_unmap_ram(bp->b_addr, bp->b_folio_count);
> -
> -	for (i = 0; i < bp->b_folio_count; i++) {
> -		if (bp->b_folios[i])
> -			__folio_put(bp->b_folios[i]);
> -	}
> -	mm_account_reclaimed_pages(bp->b_folio_count);
> -
> -	if (bp->b_folios != bp->b_folio_array)
> -		kfree(bp->b_folios);
> -	bp->b_folios = NULL;
> -	bp->b_flags &= ~_XBF_FOLIOS;
> -}
> -
>  static void
>  xfs_buf_free_callback(
>  	struct callback_head	*cb)
> @@ -323,13 +300,22 @@ xfs_buf_free(
>  
>  	ASSERT(list_empty(&bp->b_lru));
>  
> -	if (xfs_buftarg_is_mem(bp->b_target))
> +	if (xfs_buftarg_is_mem(bp->b_target)) {
>  		xmbuf_unmap_folio(bp);
> -	else if (bp->b_flags & _XBF_FOLIOS)
> -		xfs_buf_free_folios(bp);
> -	else if (bp->b_flags & _XBF_KMEM)
> -		kfree(bp->b_addr);
> +		goto free;
> +	}
>  
> +	if (!(bp->b_flags & _XBF_KMEM))
> +		mm_account_reclaimed_pages(bp->b_folio_count);

Echoing hch's statement about the argument being passed to
mm_account_reclaimed_pages needing to be fed units of base pages, not
folios.

> +
> +	if (bp->b_flags & _XBF_FOLIOS)
> +		__folio_put(kmem_to_folio(bp->b_addr));

Is it necessary to use folio_put instead of the __ version like hch said
earlier?

> +	else
> +		kvfree(bp->b_addr);
> +
> +	bp->b_flags &= _XBF_KMEM | _XBF_FOLIOS;

Shouldn't this be:

	bp->b_flags &= ~(_XBF_KMEM | _XBF_FOLIOS); ?

> +
> +free:
>  	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
>  }
>  
> @@ -356,8 +342,6 @@ xfs_buf_alloc_kmem(
>  		bp->b_addr = NULL;
>  		return -ENOMEM;
>  	}
> -	bp->b_folios = bp->b_folio_array;
> -	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
>  	bp->b_folio_count = 1;
>  	bp->b_flags |= _XBF_KMEM;
>  	return 0;
> @@ -377,14 +361,15 @@ xfs_buf_alloc_folio(
>  	struct xfs_buf	*bp,
>  	gfp_t		gfp_mask)
>  {
> +	struct folio	*folio;
>  	int		length = BBTOB(bp->b_length);
>  	int		order = get_order(length);
>  
> -	bp->b_folio_array[0] = folio_alloc(gfp_mask, order);
> -	if (!bp->b_folio_array[0])
> +	folio = folio_alloc(gfp_mask, order);
> +	if (!folio)
>  		return false;
>  
> -	bp->b_folios = bp->b_folio_array;
> +	bp->b_addr = folio_address(folio);
>  	bp->b_folio_count = 1;
>  	bp->b_flags |= _XBF_FOLIOS;
>  	return true;
> @@ -400,15 +385,11 @@ xfs_buf_alloc_folio(
>   * contiguous memory region that we don't have to map and unmap to access the
>   * data directly.
>   *
> - * The second type of buffer is the multi-folio buffer. These are *always* made
> - * up of single page folios so that they can be fed to vmap_ram() to return a
> - * contiguous memory region we can access the data through.
> - *
> - * We don't use high order folios for this second type of buffer (yet) because
> - * having variable size folios makes offset-to-folio indexing and iteration of
> - * the data range more complex than if they are fixed size. This case should now
> - * be the slow path, though, so unless we regularly fail to allocate high order
> - * folios, there should be little need to optimise this path.
> + * The second type of buffer is the vmalloc()d buffer. This provides the buffer
> + * with the required contiguous memory region but backed by discontiguous
> + * physical pages. vmalloc() typically doesn't fail, but it can and so we may
> + * need to wrap the allocation in a loop to prevent low memory failures and
> + * shutdowns.

Where's the loop now?  Is that buried under __vmalloc somewhere?

--D

>   */
>  static int
>  xfs_buf_alloc_folios(
> @@ -416,7 +397,7 @@ xfs_buf_alloc_folios(
>  	xfs_buf_flags_t	flags)
>  {
>  	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
> -	long		filled = 0;
> +	unsigned	nofs_flag;
>  
>  	if (flags & XBF_READ_AHEAD)
>  		gfp_mask |= __GFP_NORETRY;
> @@ -425,89 +406,32 @@ xfs_buf_alloc_folios(
>  	if (!(flags & XBF_READ))
>  		gfp_mask |= __GFP_ZERO;
>  
> -	/* Optimistically attempt a single high order folio allocation. */
> -	if (xfs_buf_alloc_folio(bp, gfp_mask))
> -		return 0;
> -
>  	/* Fall back to allocating an array of single page folios. */
>  	bp->b_folio_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
> -	if (bp->b_folio_count <= XB_FOLIOS) {
> -		bp->b_folios = bp->b_folio_array;
> -	} else {
> -		bp->b_folios = kzalloc(sizeof(struct folio *) * bp->b_folio_count,
> -					gfp_mask);
> -		if (!bp->b_folios)
> -			return -ENOMEM;
> -	}
> -	bp->b_flags |= _XBF_FOLIOS;
>  
> +	/* Optimistically attempt a single high order folio allocation. */
> +	if (xfs_buf_alloc_folio(bp, gfp_mask))
> +		return 0;
> +
> +	/* We are done if an order-0 allocation has already failed. */
> +	if (bp->b_folio_count == 1)
> +		return -ENOMEM;
>  
>  	/*
> -	 * Bulk filling of pages can take multiple calls. Not filling the entire
> -	 * array is not an allocation failure, so don't back off if we get at
> -	 * least one extra page.
> +	 * XXX(dgc): I think dquot reclaim is the only place we can get
> +	 * to this function from memory reclaim context now. If we fix
> +	 * that like we've fixed inode reclaim to avoid writeback from
> +	 * reclaim, this nofs wrapping can go away.
>  	 */
> -	for (;;) {
> -		long	last = filled;
> -
> -		filled = alloc_pages_bulk_array(gfp_mask, bp->b_folio_count,
> -						(struct page **)bp->b_folios);
> -		if (filled == bp->b_folio_count) {
> -			XFS_STATS_INC(bp->b_mount, xb_page_found);
> -			break;
> -		}
> -
> -		if (filled != last)
> -			continue;
> -
> -		if (flags & XBF_READ_AHEAD) {
> -			xfs_buf_free_folios(bp);
> -			return -ENOMEM;
> -		}
> -
> -		XFS_STATS_INC(bp->b_mount, xb_page_retries);
> -		memalloc_retry_wait(gfp_mask);
> -	}
> -
> -	if (bp->b_folio_count == 1) {
> -		/* A single folio buffer is always mappable */
> -		bp->b_addr = folio_address(bp->b_folios[0]);
> -	} else {
> -		int retried = 0;
> -		unsigned nofs_flag;
> -
> -		/*
> -		 * vm_map_ram() will allocate auxiliary structures (e.g.
> -		 * pagetables) with GFP_KERNEL, yet we often under a scoped nofs
> -		 * context here. Mixing GFP_KERNEL with GFP_NOFS allocations
> -		 * from the same call site that can be run from both above and
> -		 * below memory reclaim causes lockdep false positives. Hence we
> -		 * always need to force this allocation to nofs context because
> -		 * we can't pass __GFP_NOLOCKDEP down to auxillary structures to
> -		 * prevent false positive lockdep reports.
> -		 *
> -		 * XXX(dgc): I think dquot reclaim is the only place we can get
> -		 * to this function from memory reclaim context now. If we fix
> -		 * that like we've fixed inode reclaim to avoid writeback from
> -		 * reclaim, this nofs wrapping can go away.
> -		 */
> -		nofs_flag = memalloc_nofs_save();
> -		do {
> -			bp->b_addr = vm_map_ram((struct page **)bp->b_folios,
> -					bp->b_folio_count, -1);
> -			if (bp->b_addr)
> -				break;
> -			vm_unmap_aliases();
> -		} while (retried++ <= 1);
> -		memalloc_nofs_restore(nofs_flag);
> -
> -		if (!bp->b_addr) {
> -			xfs_warn_ratelimited(bp->b_mount,
> -				"%s: failed to map %u folios", __func__,
> -				bp->b_folio_count);
> -			xfs_buf_free_folios(bp);
> -			return -ENOMEM;
> -		}
> +	nofs_flag = memalloc_nofs_save();
> +	bp->b_addr = __vmalloc(BBTOB(bp->b_length), gfp_mask);
> +	memalloc_nofs_restore(nofs_flag);
> +
> +	if (!bp->b_addr) {
> +		xfs_warn_ratelimited(bp->b_mount,
> +			"%s: failed to allocate %u folios", __func__,
> +			bp->b_folio_count);
> +		return -ENOMEM;
>  	}
>  
>  	return 0;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 4d515407713b..68c24947ca1a 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -190,8 +190,6 @@ struct xfs_buf {
>  	struct xfs_buf_log_item	*b_log_item;
>  	struct list_head	b_li_list;	/* Log items list head */
>  	struct xfs_trans	*b_transp;
> -	struct folio		**b_folios;	/* array of folio pointers */
> -	struct folio		*b_folio_array[XB_FOLIOS]; /* inline folios */
>  	struct xfs_buf_map	*b_maps;	/* compound buffer map */
>  	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
>  	int			b_map_count;
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index 26734c64c10e..336e7c8effb7 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -169,8 +169,6 @@ xmbuf_map_folio(
>  	unlock_page(page);
>  
>  	bp->b_addr = page_address(page);
> -	bp->b_folios = bp->b_folio_array;
> -	bp->b_folios[0] = folio;
>  	bp->b_folio_count = 1;
>  	return 0;
>  }
> @@ -180,15 +178,10 @@ void
>  xmbuf_unmap_folio(
>  	struct xfs_buf		*bp)
>  {
> -	struct folio		*folio = bp->b_folios[0];
> -
>  	ASSERT(xfs_buftarg_is_mem(bp->b_target));
>  
> -	folio_put(folio);
> -
> +	folio_put(kmem_to_folio(bp->b_addr));
>  	bp->b_addr = NULL;
> -	bp->b_folios[0] = NULL;
> -	bp->b_folios = NULL;
>  	bp->b_folio_count = 0;
>  }
>  
> -- 
> 2.43.0
> 
> 
