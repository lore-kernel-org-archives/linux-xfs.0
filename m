Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7308A225798
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740590552; cv=none; b=heJ7ZgtmvaAB1OGGW0EmrYhC2g9QelJsk23JRImyL7GUzmVM4ItSIjnRbiFP8glwG2b6pZQ5+cXs3VW9+yh7Q570/s2hf5vsDkJierOZ4wbE6BAJ4rzyjTFtG9/dx8RBpOeVWbTpjoZnN7GcDk75ewCKYcK2lYlLfzxN7qSqvkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740590552; c=relaxed/simple;
	bh=fcMoZggS3ud73TR5WBjbhmbf2JsYiD7ArWO8NlxtZwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Og6HwyaW+WNEqoTFE/8UueXCe1CqVzBaQtn/e3c0uxnMMGXFgxAg3/VmIZNgZm6sJOXXoDeB04GI09HEgoiQNS6mQ+DoUU1HAEiOSqBuLcKSi602z3KX9qrtE9La7mIXiiXZicSw3HS78TEtu8kE2SBcwybWYr6oZ0JqTbDqk1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHhqkHyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHhqkHyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF520C4CEE8;
	Wed, 26 Feb 2025 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740590551;
	bh=fcMoZggS3ud73TR5WBjbhmbf2JsYiD7ArWO8NlxtZwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHhqkHyimOCAbd7UAyluxNZ0WR9CWMWATxJUMMBfF2i7OOcJG8tVuulImqNv9BcQr
	 Nq1uWCtjlGDf+9XbIHKQucTrK+zcH6oZanMcvuaI0fCMjpYbitPudzgUhK8yC8z13R
	 uKCLDjtBAtBtlIu8JZjaAhYoZUX4sPtSYmXk8h0gWUntUsJG8PnwE97tCMCju2Y8k2
	 /xGeUhd2qGWBcW6uF2F1T7PgVLWjokqE+xndrf5QpoW1gcZ8iKvO/vJfNQE/G4fYlw
	 0PgvAhDD2JZEIwikEFmErm8+t2LVrV3s4P1BZCgMHlDsxMnn8yUakNYR8bAH3A/W64
	 DEBNhIbrJboDQ==
Date: Wed, 26 Feb 2025 09:22:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove the kmalloc to page allocator fallback
Message-ID: <20250226172231.GQ6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-7-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:34AM -0800, Christoph Hellwig wrote:
> Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
> for kmalloc(power-of-two)", kmalloc and friends guarantee that power of
> two sized allocations are naturally aligned.  Limit our use of kmalloc
> for buffers to these power of two sizes and remove the fallback to
> the page allocator for this case, but keep a check in addition to
> trusting the slab allocator to get the alignment right.
> 
> Also refactor the kmalloc path to reuse various calculations for the
> size and gfp flags.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 49 ++++++++++++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e8783ee23623..f327bf5b04c0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -301,23 +301,24 @@ xfs_buf_free(
>  
>  static int
>  xfs_buf_alloc_kmem(
> -	struct xfs_buf	*bp,
> -	xfs_buf_flags_t	flags)
> +	struct xfs_buf		*bp,
> +	size_t			size,
> +	gfp_t			gfp_mask)
>  {
> -	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL;
> -	size_t		size = BBTOB(bp->b_length);
> -
> -	/* Assure zeroed buffer for non-read cases. */
> -	if (!(flags & XBF_READ))
> -		gfp_mask |= __GFP_ZERO;
> +	ASSERT(is_power_of_2(size));
> +	ASSERT(size < PAGE_SIZE);
>  
> -	bp->b_addr = kmalloc(size, gfp_mask);
> +	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
>  	if (!bp->b_addr)
>  		return -ENOMEM;
>  
> -	if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
> -	    ((unsigned long)bp->b_addr & PAGE_MASK)) {
> -		/* b_addr spans two pages - use alloc_page instead */
> +	/*
> +	 * Slab guarantees that we get back naturally aligned allocations for
> +	 * power of two sizes.  Keep this check as the canary in the coal mine
> +	 * if anything changes in slab.
> +	 */
> +	if (!IS_ALIGNED((unsigned long)bp->b_addr, size)) {
> +		ASSERT(IS_ALIGNED((unsigned long)bp->b_addr, size));

Depending on the level of paranoia about "outside" subsystems, should
this be a regular xfs_err so we can catch these kinds of things on
production kernels?

>  		kfree(bp->b_addr);
>  		bp->b_addr = NULL;
>  		return -ENOMEM;
> @@ -358,18 +359,22 @@ xfs_buf_alloc_backing_mem(
>  	if (xfs_buftarg_is_mem(bp->b_target))
>  		return xmbuf_map_page(bp);
>  
> -	/*
> -	 * For buffers that fit entirely within a single page, first attempt to
> -	 * allocate the memory from the heap to minimise memory usage.  If we
> -	 * can't get heap memory for these small buffers, we fall back to using
> -	 * the page allocator.
> -	 */
> -	if (size < PAGE_SIZE && xfs_buf_alloc_kmem(new_bp, flags) == 0)
> -		return 0;
> +	/* Assure zeroed buffer for non-read cases. */
> +	if (!(flags & XBF_READ))
> +		gfp_mask |= __GFP_ZERO;
>  
>  	if (flags & XBF_READ_AHEAD)
>  		gfp_mask |= __GFP_NORETRY;
>  
> +	/*
> +	 * For buffers smaller than PAGE_SIZE use a kmalloc allocation if that
> +	 * is properly aligned.  The slab allocator now guarantees an aligned
> +	 * allocation for all power of two sizes, we matches must of the smaller

"...which matches most of the smaller than PAGE_SIZE buffers..."

--D

> +	 * than PAGE_SIZE buffers used by XFS.
> +	 */
> +	if (size < PAGE_SIZE && is_power_of_2(size))
> +		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
> +
>  	/* Make sure that we have a page list */
>  	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
>  	if (bp->b_page_count <= XB_PAGES) {
> @@ -382,10 +387,6 @@ xfs_buf_alloc_backing_mem(
>  	}
>  	bp->b_flags |= _XBF_PAGES;
>  
> -	/* Assure zeroed buffer for non-read cases. */
> -	if (!(flags & XBF_READ))
> -		gfp_mask |= __GFP_ZERO;
> -
>  	/*
>  	 * Bulk filling of pages can take multiple calls. Not filling the entire
>  	 * array is not an allocation failure, so don't back off if we get at
> -- 
> 2.45.2
> 
> 
