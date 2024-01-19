Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441F31362
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 01:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705627585; cv=none; b=rZewNyabj3SgbrOnbnQW+oSe/sDO27MVtbmrB+HB3Ae4JBh1QlQUa9IbfCZg4c4pjbDLqTgZXzEuw108iFTnuVo6N5pq4s+CKFpGa7paRkJtYz5pcXcqSlsmHAzwY7QDlXyowvqB0ffqpncELDt0/1Io8R1P0gJXAYLSXRxd3Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705627585; c=relaxed/simple;
	bh=wAyrhKG2oaMmnU++pcXLEdMH2bRrKjQT6kQJ8UCZvdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTN8BshfxiBtzznY3d0JC7/7Q0/u+u4K5B5g4iJNRX0tTfnBgyaCKuteDmPZJuLzq2I8hAMDlE7H++6vxOWO1XiG0S3rzUsOgMsud+C/Yc9uzaAavGVovSmBBvPHW4kawabU0ePNoEa9sx6Bd5MiVr6NtxfKQRpfnMkhR1ZyLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGH2NWt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGH2NWt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F22EC433C7;
	Fri, 19 Jan 2024 01:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705627585;
	bh=wAyrhKG2oaMmnU++pcXLEdMH2bRrKjQT6kQJ8UCZvdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGH2NWt8L6uxpj0D8oKr5zPOH3gtSDOEIA4Qne6fJXcZ525zycFtcz64AvIWDjhEt
	 lPeEEDxjilGbr33ParLphihgqZkaIEj06haUiACNPyLR336/thwwFOnWjQmwAfZL8u
	 zXWa4omGDWTjwxrmdXCvCzHghdYmXxcfGKsj4pTkal50/srJhQ4UCGIprThNfc7FQE
	 52EZUEwZqsdAI9GiAfNcgrz793+AIkMqUBpjuXiBU/NyqZL31MLZ6Sf9JQ9Cpb2gw0
	 zmTgxrXf7DCp14lkwogkbQiEN2zx6CbP8j2EmrXgWbzsVdu652NvrFAaRS77BhNsGT
	 S0bu1X8lKPYdg==
Date: Thu, 18 Jan 2024 17:26:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: use folios in the buffer cache
Message-ID: <20240119012624.GQ674499@frogsfrogsfrogs>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118222216.4131379-3-david@fromorbit.com>

On Fri, Jan 19, 2024 at 09:19:40AM +1100, Dave Chinner wrote:
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
> ---
>  fs/xfs/xfs_buf.c      | 127 +++++++++++++++++++++---------------------
>  fs/xfs/xfs_buf.h      |  14 ++---
>  fs/xfs/xfs_buf_item.c |   2 +-
>  fs/xfs/xfs_linux.h    |   8 +++
>  4 files changed, 80 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 08f2fbc04db5..15907e92d0d3 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -60,25 +60,25 @@ xfs_buf_submit(
>  	return __xfs_buf_submit(bp, !(bp->b_flags & XBF_ASYNC));
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
> @@ -197,7 +197,7 @@ xfs_buf_get_maps(
>  }
>  
>  /*
> - *	Frees b_pages if it was allocated.
> + *	Frees b_maps if it was allocated.
>   */
>  static void
>  xfs_buf_free_maps(
> @@ -273,26 +273,26 @@ _xfs_buf_alloc(
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
> @@ -313,8 +313,8 @@ xfs_buf_free(
>  
>  	ASSERT(list_empty(&bp->b_lru));
>  
> -	if (bp->b_flags & _XBF_PAGES)
> -		xfs_buf_free_pages(bp);
> +	if (bp->b_flags & _XBF_FOLIOS)
> +		xfs_buf_free_folios(bp);
>  	else if (bp->b_flags & _XBF_KMEM)
>  		kfree(bp->b_addr);
>  
> @@ -345,15 +345,15 @@ xfs_buf_alloc_kmem(
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
> @@ -364,16 +364,16 @@ xfs_buf_alloc_pages(
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
> @@ -387,9 +387,9 @@ xfs_buf_alloc_pages(
>  	for (;;) {
>  		long	last = filled;
>  
> -		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
> -						bp->b_pages);
> -		if (filled == bp->b_page_count) {
> +		filled = alloc_pages_bulk_array(gfp_mask, bp->b_folio_count,
> +						(struct page **)bp->b_folios);

Ugh, pointer casting.  I suppose here is where we might want an
alloc_folio_bulk_array that might give us successively smaller
large-folios until b_page_count is satisfied?  (Maybe that's in the next
patch?)

I guess you'd also need a large-folio capable vm_map_ram.  Both of
these things sound reasonable, particularly if somebody wants to write
us a new buffer cache for ext2rs and support large block sizes.

Assuming that one of the goals here is (say) to be able to mount a 16k
blocksize filesystem and try to get 16k folios for the buffer cache?

--D

> +		if (filled == bp->b_folio_count) {
>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>  			break;
>  		}
> @@ -398,7 +398,7 @@ xfs_buf_alloc_pages(
>  			continue;
>  
>  		if (flags & XBF_READ_AHEAD) {
> -			xfs_buf_free_pages(bp);
> +			xfs_buf_free_folios(bp);
>  			return -ENOMEM;
>  		}
>  
> @@ -412,14 +412,14 @@ xfs_buf_alloc_pages(
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
> @@ -443,8 +443,8 @@ _xfs_buf_map_pages(
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
> @@ -571,7 +571,7 @@ xfs_buf_find_lock(
>  			return -ENOENT;
>  		}
>  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> -		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
> +		bp->b_flags &= _XBF_KMEM | _XBF_FOLIOS;
>  		bp->b_ops = NULL;
>  	}
>  	return 0;
> @@ -629,14 +629,15 @@ xfs_buf_find_insert(
>  		goto out_drop_pag;
>  
>  	/*
> -	 * For buffers that fit entirely within a single page, first attempt to
> -	 * allocate the memory from the heap to minimise memory usage. If we
> -	 * can't get heap memory for these small buffers, we fall back to using
> -	 * the page allocator.
> +	 * For buffers that fit entirely within a single page folio, first
> +	 * attempt to allocate the memory from the heap to minimise memory
> +	 * usage. If we can't get heap memory for these small buffers, we fall
> +	 * back to using the page allocator.
>  	 */
> +
>  	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
>  	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
> -		error = xfs_buf_alloc_pages(new_bp, flags);
> +		error = xfs_buf_alloc_folios(new_bp, flags);
>  		if (error)
>  			goto out_free_buf;
>  	}
> @@ -728,11 +729,11 @@ xfs_buf_get_map(
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
> @@ -963,14 +964,14 @@ xfs_buf_get_uncached(
>  	if (error)
>  		return error;
>  
> -	error = xfs_buf_alloc_pages(bp, flags);
> +	error = xfs_buf_alloc_folios(bp, flags);
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
> @@ -1465,7 +1466,7 @@ xfs_buf_ioapply_map(
>  	blk_opf_t	op)
>  {
>  	int		page_index;
> -	unsigned int	total_nr_pages = bp->b_page_count;
> +	unsigned int	total_nr_pages = bp->b_folio_count;
>  	int		nr_pages;
>  	struct bio	*bio;
>  	sector_t	sector =  bp->b_maps[map].bm_bn;
> @@ -1503,7 +1504,7 @@ xfs_buf_ioapply_map(
>  		if (nbytes > size)
>  			nbytes = size;
>  
> -		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
> +		rbytes = bio_add_folio(bio, bp->b_folios[page_index], nbytes,
>  				      offset);
>  		if (rbytes < nbytes)
>  			break;
> @@ -1716,13 +1717,13 @@ xfs_buf_offset(
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
> @@ -1735,18 +1736,18 @@ xfs_buf_zero(
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
> index b470de08a46c..1e7298ff3fa5 100644
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
> @@ -116,7 +116,7 @@ typedef struct xfs_buftarg {
>  	struct ratelimit_state	bt_ioerror_rl;
>  } xfs_buftarg_t;
>  
> -#define XB_PAGES	2
> +#define XB_FOLIOS	2
>  
>  struct xfs_buf_map {
>  	xfs_daddr_t		bm_bn;	/* block number for I/O */
> @@ -180,14 +180,14 @@ struct xfs_buf {
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
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index caccb7f76690..804389b8e802 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -279,4 +279,12 @@ kmem_to_page(void *addr)
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
