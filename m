Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6B021E0AA
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589728; cv=none; b=RtVQ5I1sRND0ztz7paysNXHT1F1KxoOJl1RzYOngHQCABvg/vJ7n2agnuRvai2YcJTKrJ+UELd0HVApB++Iiu5ux08EMBDKw2Wujlfx3KsaGauuKojHrqN3ksbcLwqwOHQTSA3omlIqEWH+Fe1RA2t4gjLI0jsc4E/JkliSKQlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589728; c=relaxed/simple;
	bh=iz5C/djZGXG+7wD/Zw5VuBzSCc7oJBtLDZRCdPBgbGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4NfKS1PCzJfK6yhT5i7W94+0iNX60s6oPlYFWKroHGLZyJsBLbnZyo7ulxJwdK3sdRhgys72ouw+P+yy9PGpCgWhI4L4wQIt6hFOOMHM9+Duze3IVGreyIyU/6U63TlDX7QEEzZkv2Rp6F+bPU93BSJVK9XKAQnucsCF+4IIRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5UHGG/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5UHGG/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B040C4CEE4;
	Wed, 26 Feb 2025 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740589728;
	bh=iz5C/djZGXG+7wD/Zw5VuBzSCc7oJBtLDZRCdPBgbGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f5UHGG/LPBywWJb/m/uVDiCowidUh7rPDaLmFaNSym9O8JhSQZnwZJIyzZdeKIbVH
	 +7phzv2O7eIk6dq9sUrPyb62yOoReLryhnFkO81Gy1OQhno40ATmBICU/XgyH2J1ry
	 Bo/cRAATS/MCJIJWYN9BaKcp0ADDuljVrD3i/PZCn/Ogf2IA5BZlrRKVC41/sx4SdL
	 SeQUExrt5ofPiIjBsiHPiM4bc5J2QQdmmDG8wSzcT9SLiUke4daJ3GlBkvfdhUwBj2
	 W0tAOQvJH6WYMTED/DlF8At2nZIQK4OGT23pN5x0PyQ7uhkTCUdHEVxPi5JBDgNoOw
	 wbF3IdVKK3ASw==
Date: Wed, 26 Feb 2025 09:08:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: refactor backing memory allocations for
 buffers
Message-ID: <20250226170847.GP6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-6-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:33AM -0800, Christoph Hellwig wrote:
> Lift handling of shmem and slab backed buffers into xfs_buf_alloc_pages
> and rename the result to xfs_buf_alloc_backing_mem.  This shares more
> code and ensures uncached buffers can also use slab, which slightly
> reduces the memory usage of growfs on 512 byte sector size file systems,
> but more importantly means the allocation invariants are the same for
> cached and uncached buffers.  Document these new invariants with a big
> fat comment mostly stolen from a patch by Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That's a nice refactoring.  I'd wondered about get_buf_uncached not
going for slab memory when I was writing the xmbuf code, but didn't want
to overcomplicate that patchset and then forgot about it :/

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 55 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 36 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index af1389ebdd69..e8783ee23623 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -329,19 +329,49 @@ xfs_buf_alloc_kmem(
>  	return 0;
>  }
>  
> +/*
> + * Allocate backing memory for a buffer.
> + *
> + * For tmpfs-backed buffers used by in-memory btrees this directly maps the
> + * tmpfs page cache folios.
> + *
> + * For real file system buffers there are two different kinds backing memory:
> + *
> + * The first type backs the buffer by a kmalloc allocation.  This is done for
> + * less than PAGE_SIZE allocations to avoid wasting memory.
> + *
> + * The second type of buffer is the multi-page buffer. These are always made
> + * up of single pages so that they can be fed to vmap_ram() to return a
> + * contiguous memory region we can access the data through, or mark it as
> + * XBF_UNMAPPED and access the data directly through individual page_address()
> + * calls.
> + */
>  static int
> -xfs_buf_alloc_pages(
> +xfs_buf_alloc_backing_mem(
>  	struct xfs_buf	*bp,
>  	xfs_buf_flags_t	flags)
>  {
> +	size_t		size = BBTOB(bp->b_length);
>  	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
>  	long		filled = 0;
>  
> +	if (xfs_buftarg_is_mem(bp->b_target))
> +		return xmbuf_map_page(bp);
> +
> +	/*
> +	 * For buffers that fit entirely within a single page, first attempt to
> +	 * allocate the memory from the heap to minimise memory usage.  If we
> +	 * can't get heap memory for these small buffers, we fall back to using
> +	 * the page allocator.
> +	 */
> +	if (size < PAGE_SIZE && xfs_buf_alloc_kmem(new_bp, flags) == 0)
> +		return 0;
> +
>  	if (flags & XBF_READ_AHEAD)
>  		gfp_mask |= __GFP_NORETRY;
>  
>  	/* Make sure that we have a page list */
> -	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
> +	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
>  	if (bp->b_page_count <= XB_PAGES) {
>  		bp->b_pages = bp->b_page_array;
>  	} else {
> @@ -622,18 +652,7 @@ xfs_buf_find_insert(
>  	if (error)
>  		goto out_drop_pag;
>  
> -	if (xfs_buftarg_is_mem(new_bp->b_target)) {
> -		error = xmbuf_map_page(new_bp);
> -	} else if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
> -		   xfs_buf_alloc_kmem(new_bp, flags) < 0) {
> -		/*
> -		 * For buffers that fit entirely within a single page, first
> -		 * attempt to allocate the memory from the heap to minimise
> -		 * memory usage. If we can't get heap memory for these small
> -		 * buffers, we fall back to using the page allocator.
> -		 */
> -		error = xfs_buf_alloc_pages(new_bp, flags);
> -	}
> +	error = xfs_buf_alloc_backing_mem(new_bp, flags);
>  	if (error)
>  		goto out_free_buf;
>  
> @@ -995,14 +1014,12 @@ xfs_buf_get_uncached(
>  	if (error)
>  		return error;
>  
> -	if (xfs_buftarg_is_mem(bp->b_target))
> -		error = xmbuf_map_page(bp);
> -	else
> -		error = xfs_buf_alloc_pages(bp, flags);
> +	error = xfs_buf_alloc_backing_mem(bp, flags);
>  	if (error)
>  		goto fail_free_buf;
>  
> -	error = _xfs_buf_map_pages(bp, 0);
> +	if (!bp->b_addr)
> +		error = _xfs_buf_map_pages(bp, 0);
>  	if (unlikely(error)) {
>  		xfs_warn(target->bt_mount,
>  			"%s: failed to map pages", __func__);
> -- 
> 2.45.2
> 
> 
