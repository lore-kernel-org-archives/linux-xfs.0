Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8026C253F3C
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198693; cv=none; b=CvOicH3mAVrD3GoIPmhqCBLjeYWdy5Eb/XToQwjQlPuPSK7ZEj2x6FeAOkA6GyceWr0kCm32HD/OvHZDseBDcs2QjoI5IOoRMQz0XEhH4aZAnj6kZQk8+T3pofUqpXqnjmekgpLJHoer9qXsUZFrzUZEqVHOgijb+3CFTFUUVtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198693; c=relaxed/simple;
	bh=j4DkVotwNetPCP+DzN0qd4P29yzQTQ39YyowVnFdvdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jBivQIm51wJDYQ+DBDtxnmhvJS0BOd/iwmOFSY5+UQQUWzC/UMDLSC1IqcX7V3BTQdydDf/+UPFXPjPQphKU0pzjwiLldZs9Ur0dF0hBCmMVsCIis60CH9jYbr9d6xWjvrDCb+6OiWpHkIylNW+/K/of0/AMxe5XtWHI49dVN6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Slw8RSff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Slw8RSff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571CCC4CED1;
	Wed,  5 Mar 2025 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741198693;
	bh=j4DkVotwNetPCP+DzN0qd4P29yzQTQ39YyowVnFdvdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Slw8RSffpduwQ80ixd2+dPgOgQ1+12J+xnLCb6Y7FyXDelbb6XB62c2y/ygZfNXF5
	 1yQjBUSgy0hVqRfiMRjrWIF/fDe/FJMfVLDdTsDEZ6urO2MEFfl4IwB4oqpxZCKu1V
	 bmB2nsGP8Hg6BEH78U4Vyc7YaUuEdx7Kld9e6afSUaQ3gc/51Itp43Fa4w3wIRmnJg
	 ijFMnlG47r0e4586bKKqInbf+QvhhY60eJBRVOe1cF4SmJnpOq+m4NOfxaWlgZAVxn
	 qGY/vvBMDcSfcKSlopDpNudT8sGaQO1uQY+vFFx3oh5Pssv4O6BW2sfSKV4qUwItD7
	 qfC8ARpUG//bw==
Date: Wed, 5 Mar 2025 10:18:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove the kmalloc to page allocator fallback
Message-ID: <20250305181812.GI2803749@frogsfrogsfrogs>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305140532.158563-7-hch@lst.de>

On Wed, Mar 05, 2025 at 07:05:23AM -0700, Christoph Hellwig wrote:
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
>  fs/xfs/xfs_buf.c | 48 ++++++++++++++++++++++++------------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 18ec1c1fbca1..073246d4352f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -243,23 +243,23 @@ xfs_buf_free(
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
> +	if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)bp->b_addr, size))) {
>  		kfree(bp->b_addr);
>  		bp->b_addr = NULL;
>  		return -ENOMEM;
> @@ -300,18 +300,22 @@ xfs_buf_alloc_backing_mem(
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
> +	 * allocation for all power of two sizes, we matches most of the smaller

Same suggestion:

"...which matches most of the smaller than PAGE_SIZE buffers..."

as last time.

with the comment fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	 * than PAGE_SIZE buffers used by XFS.
> +	 */
> +	if (size < PAGE_SIZE && is_power_of_2(size))
> +		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
> +
>  	/* Make sure that we have a page list */
>  	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
>  	if (bp->b_page_count <= XB_PAGES) {
> @@ -324,10 +328,6 @@ xfs_buf_alloc_backing_mem(
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
