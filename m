Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01AC14277
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868540; cv=none; b=bABquPtoxVlM1o+A9SrSpij9Vs2Dwj0m9cwYMy7+QlgR9JnxwfV6zOjwmwVnApNFiCDfBZBZocgwTzCBMm621UU3YW0d0u33z39j4iyqHzIA1siRrBKtY6j4zhlpB+ipudz9lIcGH5pV5nnvsiWnJ1x74jF9kjaQizAZJIrzd8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868540; c=relaxed/simple;
	bh=aXevx4z4I6gAgUiO6fmmpTXkAflOm9xNf+d5yICbrao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STxvlJFOmUQo7otgz3AxGNBfoJiyJTQiliX0mH2MV0KgxTlD0W1yEuhvYo7xL/3g3oJrJ0PqSVNEk9Tl4n5t3fbI6oAr19z+kY0tz3tN7AxilzCKKd+hvGuRIeKdKYAIFkydHcfSOPYhCIbQIpXzagSMhCuxLKnc9jyK6Cz239U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIunJjXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIunJjXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC57C433C7;
	Tue, 19 Mar 2024 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710868540;
	bh=aXevx4z4I6gAgUiO6fmmpTXkAflOm9xNf+d5yICbrao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIunJjXwVHtfm99AtgOJafvsJZlep6J4a/drOAEAqa60A1zzvU0w46gBXhsi5+Ysu
	 B8yUFS5s8+rfMS7MVKumo025urRYbOfCTnM0e71MGcZAgiPqX+z1u3EoM3YPwdfWSX
	 XyeBj/WtSLmjZA3J75JZX+wmJZLGtvOYspRdx3p447O+ZI3G6zUtZmS61qowKBgtF+
	 VqLsWgT/EK+kYRKqChNU+yTyJMq9CUBhu4aCT9ZOvJXl6fUxcW/E6GOmf/4sl+o7Za
	 6jttAXo7HbSYOuY0zWBLzny5SSJgPSgNAKZooGreM3+dmZ1utd+KrW/2TDtsYo1bzc
	 +Jx/kl+0B1Mqg==
Date: Tue, 19 Mar 2024 10:15:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: use folios in the buffer cache
Message-ID: <20240319171539.GO1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-3-david@fromorbit.com>

On Tue, Mar 19, 2024 at 09:45:53AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert the use of struct pages to struct folio everywhere. This
> is just direct API conversion, no actual logic of code changes
> should result.
> 
> Note: this conversion currently assumes only single page folios are
> allocated, and because some of the MM interfaces we use take
> pointers to arrays of struct pages, the address of single page
> folios and struct pages are the same. e.g alloc_pages_bulk_array(),
> vm_map_ram(), etc.
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks pretty straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c      | 132 +++++++++++++++++++++---------------------
>  fs/xfs/xfs_buf.h      |  14 ++---
>  fs/xfs/xfs_buf_item.c |   2 +-
>  fs/xfs/xfs_buf_mem.c  |  30 +++++-----
>  fs/xfs/xfs_buf_mem.h  |   8 +--
>  fs/xfs/xfs_linux.h    |   8 +++
>  6 files changed, 101 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1a18c381127e..832226385154 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -66,25 +66,25 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
>  	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
>  }
>  
> +/*
> + * Return true if the buffer is vmapped.
> + *
> + * b_addr is null if the buffer is not mapped, but the code is clever enough to
> + * know it doesn't have to map a single folio, so the check has to be both for
> + * b_addr and bp->b_folio_count > 1.
> + */
>  static inline int
>  xfs_buf_is_vmapped(
>  	struct xfs_buf	*bp)
>  {
> -	/*
> -	 * Return true if the buffer is vmapped.
> -	 *
> -	 * b_addr is null if the buffer is not mapped, but the code is clever
> -	 * enough to know it doesn't have to map a single page, so the check has
> -	 * to be both for b_addr and bp->b_page_count > 1.
> -	 */
> -	return bp->b_addr && bp->b_page_count > 1;
> +	return bp->b_addr && bp->b_folio_count > 1;
>  }
>  
>  static inline int
>  xfs_buf_vmap_len(
>  	struct xfs_buf	*bp)
>  {
> -	return (bp->b_page_count * PAGE_SIZE);
> +	return (bp->b_folio_count * PAGE_SIZE);
>  }
>  
>  /*
> @@ -203,7 +203,7 @@ xfs_buf_get_maps(
>  }
>  
>  /*
> - *	Frees b_pages if it was allocated.
> + *	Frees b_maps if it was allocated.
>   */
>  static void
>  xfs_buf_free_maps(
> @@ -279,26 +279,26 @@ _xfs_buf_alloc(
>  }
>  
>  static void
> -xfs_buf_free_pages(
> +xfs_buf_free_folios(
>  	struct xfs_buf	*bp)
>  {
>  	uint		i;
>  
> -	ASSERT(bp->b_flags & _XBF_PAGES);
> +	ASSERT(bp->b_flags & _XBF_FOLIOS);
>  
>  	if (xfs_buf_is_vmapped(bp))
> -		vm_unmap_ram(bp->b_addr, bp->b_page_count);
> +		vm_unmap_ram(bp->b_addr, bp->b_folio_count);
>  
> -	for (i = 0; i < bp->b_page_count; i++) {
> -		if (bp->b_pages[i])
> -			__free_page(bp->b_pages[i]);
> +	for (i = 0; i < bp->b_folio_count; i++) {
> +		if (bp->b_folios[i])
> +			__folio_put(bp->b_folios[i]);
>  	}
> -	mm_account_reclaimed_pages(bp->b_page_count);
> +	mm_account_reclaimed_pages(bp->b_folio_count);
>  
> -	if (bp->b_pages != bp->b_page_array)
> -		kfree(bp->b_pages);
> -	bp->b_pages = NULL;
> -	bp->b_flags &= ~_XBF_PAGES;
> +	if (bp->b_folios != bp->b_folio_array)
> +		kfree(bp->b_folios);
> +	bp->b_folios = NULL;
> +	bp->b_flags &= ~_XBF_FOLIOS;
>  }
>  
>  static void
> @@ -320,9 +320,9 @@ xfs_buf_free(
>  	ASSERT(list_empty(&bp->b_lru));
>  
>  	if (xfs_buftarg_is_mem(bp->b_target))
> -		xmbuf_unmap_page(bp);
> -	else if (bp->b_flags & _XBF_PAGES)
> -		xfs_buf_free_pages(bp);
> +		xmbuf_unmap_folio(bp);
> +	else if (bp->b_flags & _XBF_FOLIOS)
> +		xfs_buf_free_folios(bp);
>  	else if (bp->b_flags & _XBF_KMEM)
>  		kfree(bp->b_addr);
>  
> @@ -353,15 +353,15 @@ xfs_buf_alloc_kmem(
>  		return -ENOMEM;
>  	}
>  	bp->b_offset = offset_in_page(bp->b_addr);
> -	bp->b_pages = bp->b_page_array;
> -	bp->b_pages[0] = kmem_to_page(bp->b_addr);
> -	bp->b_page_count = 1;
> +	bp->b_folios = bp->b_folio_array;
> +	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
> +	bp->b_folio_count = 1;
>  	bp->b_flags |= _XBF_KMEM;
>  	return 0;
>  }
>  
>  static int
> -xfs_buf_alloc_pages(
> +xfs_buf_alloc_folios(
>  	struct xfs_buf	*bp,
>  	xfs_buf_flags_t	flags)
>  {
> @@ -372,16 +372,16 @@ xfs_buf_alloc_pages(
>  		gfp_mask |= __GFP_NORETRY;
>  
>  	/* Make sure that we have a page list */
> -	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
> -	if (bp->b_page_count <= XB_PAGES) {
> -		bp->b_pages = bp->b_page_array;
> +	bp->b_folio_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
> +	if (bp->b_folio_count <= XB_FOLIOS) {
> +		bp->b_folios = bp->b_folio_array;
>  	} else {
> -		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
> +		bp->b_folios = kzalloc(sizeof(struct folio *) * bp->b_folio_count,
>  					gfp_mask);
> -		if (!bp->b_pages)
> +		if (!bp->b_folios)
>  			return -ENOMEM;
>  	}
> -	bp->b_flags |= _XBF_PAGES;
> +	bp->b_flags |= _XBF_FOLIOS;
>  
>  	/* Assure zeroed buffer for non-read cases. */
>  	if (!(flags & XBF_READ))
> @@ -395,9 +395,9 @@ xfs_buf_alloc_pages(
>  	for (;;) {
>  		long	last = filled;
>  
> -		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
> -						bp->b_pages);
> -		if (filled == bp->b_page_count) {
> +		filled = alloc_pages_bulk_array(gfp_mask, bp->b_folio_count,
> +						(struct page **)bp->b_folios);
> +		if (filled == bp->b_folio_count) {
>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>  			break;
>  		}
> @@ -406,7 +406,7 @@ xfs_buf_alloc_pages(
>  			continue;
>  
>  		if (flags & XBF_READ_AHEAD) {
> -			xfs_buf_free_pages(bp);
> +			xfs_buf_free_folios(bp);
>  			return -ENOMEM;
>  		}
>  
> @@ -420,14 +420,14 @@ xfs_buf_alloc_pages(
>   *	Map buffer into kernel address-space if necessary.
>   */
>  STATIC int
> -_xfs_buf_map_pages(
> +_xfs_buf_map_folios(
>  	struct xfs_buf		*bp,
>  	xfs_buf_flags_t		flags)
>  {
> -	ASSERT(bp->b_flags & _XBF_PAGES);
> -	if (bp->b_page_count == 1) {
> +	ASSERT(bp->b_flags & _XBF_FOLIOS);
> +	if (bp->b_folio_count == 1) {
>  		/* A single page buffer is always mappable */
> -		bp->b_addr = page_address(bp->b_pages[0]);
> +		bp->b_addr = folio_address(bp->b_folios[0]);
>  	} else if (flags & XBF_UNMAPPED) {
>  		bp->b_addr = NULL;
>  	} else {
> @@ -451,8 +451,8 @@ _xfs_buf_map_pages(
>  		 */
>  		nofs_flag = memalloc_nofs_save();
>  		do {
> -			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> -						-1);
> +			bp->b_addr = vm_map_ram((struct page **)bp->b_folios,
> +					bp->b_folio_count, -1);
>  			if (bp->b_addr)
>  				break;
>  			vm_unmap_aliases();
> @@ -579,7 +579,7 @@ xfs_buf_find_lock(
>  			return -ENOENT;
>  		}
>  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> -		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
> +		bp->b_flags &= _XBF_KMEM | _XBF_FOLIOS;
>  		bp->b_ops = NULL;
>  	}
>  	return 0;
> @@ -638,16 +638,16 @@ xfs_buf_find_insert(
>  		goto out_drop_pag;
>  
>  	if (xfs_buftarg_is_mem(new_bp->b_target)) {
> -		error = xmbuf_map_page(new_bp);
> +		error = xmbuf_map_folio(new_bp);
>  	} else if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
>  		   xfs_buf_alloc_kmem(new_bp, flags) < 0) {
>  		/*
> -		 * For buffers that fit entirely within a single page, first
> -		 * attempt to allocate the memory from the heap to minimise
> -		 * memory usage. If we can't get heap memory for these small
> -		 * buffers, we fall back to using the page allocator.
> +		 * For buffers that fit entirely within a single page folio,
> +		 * first attempt to allocate the memory from the heap to
> +		 * minimise memory usage. If we can't get heap memory for these
> +		 * small buffers, we fall back to using the page allocator.
>  		 */
> -		error = xfs_buf_alloc_pages(new_bp, flags);
> +		error = xfs_buf_alloc_folios(new_bp, flags);
>  	}
>  	if (error)
>  		goto out_free_buf;
> @@ -764,11 +764,11 @@ xfs_buf_get_map(
>  
>  	/* We do not hold a perag reference anymore. */
>  	if (!bp->b_addr) {
> -		error = _xfs_buf_map_pages(bp, flags);
> +		error = _xfs_buf_map_folios(bp, flags);
>  		if (unlikely(error)) {
>  			xfs_warn_ratelimited(btp->bt_mount,
> -				"%s: failed to map %u pages", __func__,
> -				bp->b_page_count);
> +				"%s: failed to map %u folios", __func__,
> +				bp->b_folio_count);
>  			xfs_buf_relse(bp);
>  			return error;
>  		}
> @@ -1008,16 +1008,16 @@ xfs_buf_get_uncached(
>  		return error;
>  
>  	if (xfs_buftarg_is_mem(bp->b_target))
> -		error = xmbuf_map_page(bp);
> +		error = xmbuf_map_folio(bp);
>  	else
> -		error = xfs_buf_alloc_pages(bp, flags);
> +		error = xfs_buf_alloc_folios(bp, flags);
>  	if (error)
>  		goto fail_free_buf;
>  
> -	error = _xfs_buf_map_pages(bp, 0);
> +	error = _xfs_buf_map_folios(bp, 0);
>  	if (unlikely(error)) {
>  		xfs_warn(target->bt_mount,
> -			"%s: failed to map pages", __func__);
> +			"%s: failed to map folios", __func__);
>  		goto fail_free_buf;
>  	}
>  
> @@ -1526,7 +1526,7 @@ xfs_buf_ioapply_map(
>  	blk_opf_t	op)
>  {
>  	int		page_index;
> -	unsigned int	total_nr_pages = bp->b_page_count;
> +	unsigned int	total_nr_pages = bp->b_folio_count;
>  	int		nr_pages;
>  	struct bio	*bio;
>  	sector_t	sector =  bp->b_maps[map].bm_bn;
> @@ -1564,7 +1564,7 @@ xfs_buf_ioapply_map(
>  		if (nbytes > size)
>  			nbytes = size;
>  
> -		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
> +		rbytes = bio_add_folio(bio, bp->b_folios[page_index], nbytes,
>  				      offset);
>  		if (rbytes < nbytes)
>  			break;
> @@ -1783,13 +1783,13 @@ xfs_buf_offset(
>  	struct xfs_buf		*bp,
>  	size_t			offset)
>  {
> -	struct page		*page;
> +	struct folio		*folio;
>  
>  	if (bp->b_addr)
>  		return bp->b_addr + offset;
>  
> -	page = bp->b_pages[offset >> PAGE_SHIFT];
> -	return page_address(page) + (offset & (PAGE_SIZE-1));
> +	folio = bp->b_folios[offset >> PAGE_SHIFT];
> +	return folio_address(folio) + (offset & (PAGE_SIZE-1));
>  }
>  
>  void
> @@ -1802,18 +1802,18 @@ xfs_buf_zero(
>  
>  	bend = boff + bsize;
>  	while (boff < bend) {
> -		struct page	*page;
> +		struct folio	*folio;
>  		int		page_index, page_offset, csize;
>  
>  		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
>  		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
> -		page = bp->b_pages[page_index];
> +		folio = bp->b_folios[page_index];
>  		csize = min_t(size_t, PAGE_SIZE - page_offset,
>  				      BBTOB(bp->b_length) - boff);
>  
>  		ASSERT((csize + page_offset) <= PAGE_SIZE);
>  
> -		memset(page_address(page) + page_offset, 0, csize);
> +		memset(folio_address(folio) + page_offset, 0, csize);
>  
>  		boff += csize;
>  	}
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index b1580644501f..f059ae3d2755 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -29,7 +29,7 @@ struct xfs_buf;
>  #define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
>  #define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
>  #define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
> -#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
> +#define XBF_DONE	 (1u << 5) /* all folios in the buffer uptodate */
>  #define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
>  #define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
>  
> @@ -39,7 +39,7 @@ struct xfs_buf;
>  #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
> -#define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
> +#define _XBF_FOLIOS	 (1u << 20)/* backed by refcounted folios */
>  #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
>  
> @@ -68,7 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ _XBF_INODES,		"INODES" }, \
>  	{ _XBF_DQUOTS,		"DQUOTS" }, \
>  	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
> -	{ _XBF_PAGES,		"PAGES" }, \
> +	{ _XBF_FOLIOS,		"FOLIOS" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
>  	/* The following interface flags should never be set */ \
> @@ -128,7 +128,7 @@ struct xfs_buftarg {
>  	struct xfs_buf_cache	bt_cache[];
>  };
>  
> -#define XB_PAGES	2
> +#define XB_FOLIOS	2
>  
>  struct xfs_buf_map {
>  	xfs_daddr_t		bm_bn;	/* block number for I/O */
> @@ -192,14 +192,14 @@ struct xfs_buf {
>  	struct xfs_buf_log_item	*b_log_item;
>  	struct list_head	b_li_list;	/* Log items list head */
>  	struct xfs_trans	*b_transp;
> -	struct page		**b_pages;	/* array of page pointers */
> -	struct page		*b_page_array[XB_PAGES]; /* inline pages */
> +	struct folio		**b_folios;	/* array of folio pointers */
> +	struct folio		*b_folio_array[XB_FOLIOS]; /* inline folios */
>  	struct xfs_buf_map	*b_maps;	/* compound buffer map */
>  	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
>  	int			b_map_count;
>  	atomic_t		b_pin_count;	/* pin count */
>  	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
> -	unsigned int		b_page_count;	/* size of page array */
> +	unsigned int		b_folio_count;	/* size of folio array */
>  	unsigned int		b_offset;	/* page offset of b_addr,
>  						   only for _XBF_KMEM buffers */
>  	int			b_error;	/* error code on I/O */
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 83a81cb52d8e..d1407cee48d9 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -69,7 +69,7 @@ xfs_buf_item_straddle(
>  {
>  	void			*first, *last;
>  
> -	if (bp->b_page_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
> +	if (bp->b_folio_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
>  		return false;
>  
>  	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index 8ad38c64708e..26734c64c10e 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -74,7 +74,7 @@ xmbuf_alloc(
>  
>  	/*
>  	 * We don't want to bother with kmapping data during repair, so don't
> -	 * allow highmem pages to back this mapping.
> +	 * allow highmem folios to back this mapping.
>  	 */
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);
>  
> @@ -127,9 +127,9 @@ xmbuf_free(
>  	kfree(btp);
>  }
>  
> -/* Directly map a shmem page into the buffer cache. */
> +/* Directly map a shmem folio into the buffer cache. */
>  int
> -xmbuf_map_page(
> +xmbuf_map_folio(
>  	struct xfs_buf		*bp)
>  {
>  	struct inode		*inode = file_inode(bp->b_target->bt_file);
> @@ -169,27 +169,27 @@ xmbuf_map_page(
>  	unlock_page(page);
>  
>  	bp->b_addr = page_address(page);
> -	bp->b_pages = bp->b_page_array;
> -	bp->b_pages[0] = page;
> -	bp->b_page_count = 1;
> +	bp->b_folios = bp->b_folio_array;
> +	bp->b_folios[0] = folio;
> +	bp->b_folio_count = 1;
>  	return 0;
>  }
>  
> -/* Unmap a shmem page that was mapped into the buffer cache. */
> +/* Unmap a shmem folio that was mapped into the buffer cache. */
>  void
> -xmbuf_unmap_page(
> +xmbuf_unmap_folio(
>  	struct xfs_buf		*bp)
>  {
> -	struct page		*page = bp->b_pages[0];
> +	struct folio		*folio = bp->b_folios[0];
>  
>  	ASSERT(xfs_buftarg_is_mem(bp->b_target));
>  
> -	put_page(page);
> +	folio_put(folio);
>  
>  	bp->b_addr = NULL;
> -	bp->b_pages[0] = NULL;
> -	bp->b_pages = NULL;
> -	bp->b_page_count = 0;
> +	bp->b_folios[0] = NULL;
> +	bp->b_folios = NULL;
> +	bp->b_folio_count = 0;
>  }
>  
>  /* Is this a valid daddr within the buftarg? */
> @@ -205,7 +205,7 @@ xmbuf_verify_daddr(
>  	return daddr < (inode->i_sb->s_maxbytes >> BBSHIFT);
>  }
>  
> -/* Discard the page backing this buffer. */
> +/* Discard the folio backing this buffer. */
>  static void
>  xmbuf_stale(
>  	struct xfs_buf		*bp)
> @@ -220,7 +220,7 @@ xmbuf_stale(
>  }
>  
>  /*
> - * Finalize a buffer -- discard the backing page if it's stale, or run the
> + * Finalize a buffer -- discard the backing folio if it's stale, or run the
>   * write verifier to detect problems.
>   */
>  int
> diff --git a/fs/xfs/xfs_buf_mem.h b/fs/xfs/xfs_buf_mem.h
> index eed4a7b63232..8f4c959ff829 100644
> --- a/fs/xfs/xfs_buf_mem.h
> +++ b/fs/xfs/xfs_buf_mem.h
> @@ -19,15 +19,15 @@ int xmbuf_alloc(struct xfs_mount *mp, const char *descr,
>  		struct xfs_buftarg **btpp);
>  void xmbuf_free(struct xfs_buftarg *btp);
>  
> -int xmbuf_map_page(struct xfs_buf *bp);
> -void xmbuf_unmap_page(struct xfs_buf *bp);
> +int xmbuf_map_folio(struct xfs_buf *bp);
> +void xmbuf_unmap_folio(struct xfs_buf *bp);
>  bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
>  void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
>  int xmbuf_finalize(struct xfs_buf *bp);
>  #else
>  # define xfs_buftarg_is_mem(...)	(false)
> -# define xmbuf_map_page(...)		(-ENOMEM)
> -# define xmbuf_unmap_page(...)		((void)0)
> +# define xmbuf_map_folio(...)		(-ENOMEM)
> +# define xmbuf_unmap_folio(...)		((void)0)
>  # define xmbuf_verify_daddr(...)	(false)
>  #endif /* CONFIG_XFS_MEMORY_BUFS */
>  
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 8f07c9f6157f..9a74ba664efb 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -280,4 +280,12 @@ kmem_to_page(void *addr)
>  	return virt_to_page(addr);
>  }
>  
> +static inline struct folio *
> +kmem_to_folio(void *addr)
> +{
> +	if (is_vmalloc_addr(addr))
> +		return page_folio(vmalloc_to_page(addr));
> +	return virt_to_folio(addr);
> +}
> +
>  #endif /* __XFS_LINUX__ */
> -- 
> 2.43.0
> 
> 
