Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FA62253A4
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740592957; cv=none; b=IfwpagDKh+hVTZEwQ20igxJx7eKw6/KpeQvs0II9zSj0v8yFxwDRr7w/ffatIpMyzWRFkv+jmeaIB0I2GYmumjNM5rWyLxN2JRYPj/hnw9O/Rbhi1vML/xo5NqEtgFGEL2A7Za2+zlDD7XJ6hb6rI89uraiA1lUPJwcv+gBjAZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740592957; c=relaxed/simple;
	bh=jQ6zq8iT5fLwonQQjqmt6UvLZGXBxmhaN1Szzfc4xYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6ijCPizddoIi100dNKSb78/+G3AqxJHvarmqIxUTUC1cIDqZ/GXPj1N8SfyYjh74Qt2X9tya1OPpzXsXu1geH8By+JuOTbaGdNbAbSqsHUkhso59buOR+DC0A+ceYmFmSPED2ZIeYH95JHYQtcjjnnR81HLND2blcTFVoSNBXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VT7h2187; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VT7h2187"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D131CC4CED6;
	Wed, 26 Feb 2025 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740592956;
	bh=jQ6zq8iT5fLwonQQjqmt6UvLZGXBxmhaN1Szzfc4xYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VT7h2187ZvsQa8Kn3V7lEy+cuVVBvy6qS0PANCVAvy+t5OBav09RRUV6SziCNAeGc
	 b14SPpMdnJog2lmjWbJfE7mRh9CGPsn00o379E3Ja7X/2aErTGluNFj3/2o5xkXwVU
	 zkFQG+RwXhe0gYvAq6MgAkLycLJiO2Nt/c4rkcK7poOTzU1Bv7Wg3bJEbh8vcAPdYq
	 k5pKyfchMXN9m/6lPWQ+orMWnx3utxbBbcDUzjMvv1+D0MvDiiLcbw9w4LVu6Q1eK6
	 m81tKvgrG2XUrKmYRfR+sBeoScglLuAhWtstAAsDJzqq8hubkrZuITLaI788wyYNI/
	 Jcgzek6RduqcA==
Date: Wed, 26 Feb 2025 10:02:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for buffer
 backing memory
Message-ID: <20250226180234.GT6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-11-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:38AM -0800, Christoph Hellwig wrote:
> The fallback buffer allocation path currently open codes a suboptimal
> version of vmalloc to allocate pages that are then mapped into
> vmalloc space.  Switch to using vmalloc instead, which uses all the
> optimizations in the common vmalloc code, and removes the need to
> track the backing pages in the xfs_buf structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c     | 209 ++++++++++---------------------------------
>  fs/xfs/xfs_buf.h     |   7 --
>  fs/xfs/xfs_buf_mem.c |  11 +--
>  3 files changed, 49 insertions(+), 178 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15087f24372f..fb127589c6b4 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c

<snip>

> @@ -412,98 +384,18 @@ xfs_buf_alloc_backing_mem(
>  		goto fallback;
>  	}
>  	bp->b_addr = folio_address(folio);
> -	bp->b_page_array[0] = &folio->page;
> -	bp->b_pages = bp->b_page_array;
> -	bp->b_page_count = 1;
> -	bp->b_flags |= _XBF_PAGES;
>  	return 0;
>  
>  fallback:
> -	/* Fall back to allocating an array of single page folios. */
> -	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
> -	if (bp->b_page_count <= XB_PAGES) {
> -		bp->b_pages = bp->b_page_array;
> -	} else {
> -		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
> -					gfp_mask);
> -		if (!bp->b_pages)
> -			return -ENOMEM;
> -	}
> -	bp->b_flags |= _XBF_PAGES;
> -
> -	/*
> -	 * Bulk filling of pages can take multiple calls. Not filling the entire
> -	 * array is not an allocation failure, so don't back off if we get at
> -	 * least one extra page.
> -	 */
>  	for (;;) {
> -		long	last = filled;
> -
> -		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
> -					  bp->b_pages);
> -		if (filled == bp->b_page_count) {
> -			XFS_STATS_INC(bp->b_mount, xb_page_found);
> +		bp->b_addr = __vmalloc(size, gfp_mask);
> +		if (bp->b_addr)
>  			break;
> -		}
> -
> -		if (filled != last)
> -			continue;
> -
> -		if (flags & XBF_READ_AHEAD) {
> -			xfs_buf_free_pages(bp);
> +		if (flags & XBF_READ_AHEAD)
>  			return -ENOMEM;
> -		}
> -
>  		XFS_STATS_INC(bp->b_mount, xb_page_retries);
>  		memalloc_retry_wait(gfp_mask);
>  	}
> -	return 0;
> -}
> -
> -/*
> - *	Map buffer into kernel address-space if necessary.
> - */
> -STATIC int
> -_xfs_buf_map_pages(
> -	struct xfs_buf		*bp,
> -	xfs_buf_flags_t		flags)
> -{
> -	ASSERT(bp->b_flags & _XBF_PAGES);
> -	if (bp->b_page_count == 1) {
> -		/* A single page buffer is always mappable */
> -		bp->b_addr = page_address(bp->b_pages[0]);
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

Heh, I should've got rid of this comment when I added the code pinning
dquot buffers to the dquot log item at transaction commit/quotacheck
dirty time.

> -		 */
> -		nofs_flag = memalloc_nofs_save();
> -		do {
> -			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> -						-1);
> -			if (bp->b_addr)
> -				break;
> -			vm_unmap_aliases();
> -		} while (retried++ <= 1);
> -		memalloc_nofs_restore(nofs_flag);
> -
> -		if (!bp->b_addr)
> -			return -ENOMEM;
> -	}
>  
>  	return 0;
>  }
> @@ -1409,7 +1281,8 @@ xfs_buf_ioend(
>  	if (bp->b_flags & XBF_READ) {
>  		if (!bp->b_error && is_vmalloc_addr(bp->b_addr))
>  			invalidate_kernel_vmap_range(bp->b_addr,
> -					xfs_buf_vmap_len(bp));
> +					DIV_ROUND_UP(BBTOB(bp->b_length),
> +							PAGE_SIZE));

The second argument to invalidate_kernel_vmap_range is the number of
bytes, right?  Isn't this BBTOB() without the DIV_ROUND_UP?  Or do you
actually want roundup(BBTOB(b_length), PAGE_SIZE) here?

>  		if (!bp->b_error && bp->b_ops)
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
> @@ -1561,29 +1434,43 @@ static void
>  xfs_buf_submit_bio(
>  	struct xfs_buf		*bp)
>  {
> -	unsigned int		size = BBTOB(bp->b_length);
> -	unsigned int		map = 0, p;
> +	unsigned int		map = 0;
>  	struct blk_plug		plug;
>  	struct bio		*bio;
>  
> -	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count,
> -			xfs_buf_bio_op(bp), GFP_NOIO);
> -	bio->bi_private = bp;
> -	bio->bi_end_io = xfs_buf_bio_end_io;
> +	if (is_vmalloc_addr(bp->b_addr)) {
> +		unsigned int	size = BBTOB(bp->b_length);
> +		unsigned int	alloc_size = DIV_ROUND_UP(size, PAGE_SIZE);
> +		void		*data = bp->b_addr;
>  
> -	if (bp->b_page_count == 1) {
> -		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
> -				offset_in_page(bp->b_addr));
> -	} else {
> -		for (p = 0; p < bp->b_page_count; p++)
> -			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
> -		bio->bi_iter.bi_size = size; /* limit to the actual size used */
> +		bio = bio_alloc(bp->b_target->bt_bdev, size >> PAGE_SHIFT,

Is the second argument (size >> PAGE_SHIFT) supposed to be the number of
pages that we're going to __bio_add_page to the bio?

In which case, shouldn't it be alloc_size ?

> +				xfs_buf_bio_op(bp), GFP_NOIO);
> +
> +		do {
> +			unsigned int	len = min(size, PAGE_SIZE);
> +
> +			ASSERT(offset_in_page(data) == 0);
> +			__bio_add_page(bio, vmalloc_to_page(data), len, 0);
> +			data += len;
> +			size -= len;
> +		} while (size);
>  
> -		if (is_vmalloc_addr(bp->b_addr))
> -			flush_kernel_vmap_range(bp->b_addr,
> -					xfs_buf_vmap_len(bp));
> +		flush_kernel_vmap_range(bp->b_addr, alloc_size);

...and this one is roundup(size, PAGE_SIZE) isn't it?

> +	} else {
> +		/*
> +		 * Single folio or slab allocation.  Must be contigous and thus

s/contigous/contiguous/

--D

> +		 * only a single bvec is needed.
> +		 */
> +		bio = bio_alloc(bp->b_target->bt_bdev, 1, xfs_buf_bio_op(bp),
> +				GFP_NOIO);
> +		__bio_add_page(bio, virt_to_page(bp->b_addr),
> +				BBTOB(bp->b_length),
> +				offset_in_page(bp->b_addr));
>  	}
>  
> +	bio->bi_private = bp;
> +	bio->bi_end_io = xfs_buf_bio_end_io;
> +
>  	/*
>  	 * If there is more than one map segment, split out a new bio for each
>  	 * map except of the last one.  The last map is handled by the
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 57faed82e93c..3089e5d5f042 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -37,7 +37,6 @@ struct xfs_buf;
>  #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
> -#define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
>  #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
>  
> @@ -63,7 +62,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
> -	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
>  	/* The following interface flags should never be set */ \
> @@ -125,8 +123,6 @@ struct xfs_buftarg {
>  	struct xfs_buf_cache	bt_cache[];
>  };
>  
> -#define XB_PAGES	2
> -
>  struct xfs_buf_map {
>  	xfs_daddr_t		bm_bn;	/* block number for I/O */
>  	int			bm_len;	/* size of I/O */
> @@ -188,13 +184,10 @@ struct xfs_buf {
>  	struct xfs_buf_log_item	*b_log_item;
>  	struct list_head	b_li_list;	/* Log items list head */
>  	struct xfs_trans	*b_transp;
> -	struct page		**b_pages;	/* array of page pointers */
> -	struct page		*b_page_array[XB_PAGES]; /* inline pages */
>  	struct xfs_buf_map	*b_maps;	/* compound buffer map */
>  	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
>  	int			b_map_count;
>  	atomic_t		b_pin_count;	/* pin count */
> -	unsigned int		b_page_count;	/* size of page array */
>  	int			b_error;	/* error code on I/O */
>  	void			(*b_iodone)(struct xfs_buf *bp);
>  
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index 07bebbfb16ee..e2f6c5524771 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -169,9 +169,6 @@ xmbuf_map_page(
>  	unlock_page(page);
>  
>  	bp->b_addr = page_address(page);
> -	bp->b_pages = bp->b_page_array;
> -	bp->b_pages[0] = page;
> -	bp->b_page_count = 1;
>  	return 0;
>  }
>  
> @@ -180,16 +177,10 @@ void
>  xmbuf_unmap_page(
>  	struct xfs_buf		*bp)
>  {
> -	struct page		*page = bp->b_pages[0];
> -
>  	ASSERT(xfs_buftarg_is_mem(bp->b_target));
>  
> -	put_page(page);
> -
> +	put_page(virt_to_page(bp->b_addr));
>  	bp->b_addr = NULL;
> -	bp->b_pages[0] = NULL;
> -	bp->b_pages = NULL;
> -	bp->b_page_count = 0;
>  }
>  
>  /* Is this a valid daddr within the buftarg? */
> -- 
> 2.45.2
> 
> 
