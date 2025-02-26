Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7386B2248BA
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740591215; cv=none; b=Q61bG0x0fJesXO1EF2dwhsH7Zejaup7G+aKyYeFiDTuAfqfKyo1OsdNOOwbvBYa7hKVfSaoObJWqmqAGvfkF3fVF0OMETBaQnPMMqLCJ8fTJliAACAh6dVT96b99NW9RK/qsxeD9NrQvjO3OXsCoMcAVNxtRCHye1YMjDrxo5Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740591215; c=relaxed/simple;
	bh=9CpYPT5d9Ff9y6Osys4fCcYFB0FPJbD1v2v5Mxw80VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMQbWjh+OcsBgCMiYsOCA60zm7IhPw7nVWzSLvHyTYrB/uAl92X7LsInB4iWzaS6UHMFTdOD94EuAwPrlb+Y/s/aIFCZKkDqP8hZEVUnnl8ncertB3ZIBHfQwTRlTlstDhtF9Ny+GuVGOokvXS9TyQCJPj/Eeu8V47dRhfwoXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjO88dWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjO88dWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE474C4CED6;
	Wed, 26 Feb 2025 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740591213;
	bh=9CpYPT5d9Ff9y6Osys4fCcYFB0FPJbD1v2v5Mxw80VQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rjO88dWyaNCRpHJPHsz1T+sQXQuTwNqX5WK06qlSjuRjsfqQqp/dRrzux6yWA06qW
	 4yHztZNA0fBRilS/q+OFh6GQhgdnTSnMphBedebHYVDtfUHZ9vJT0w60xPR3vQgXd2
	 EEGvI1qNT9nQB6kCpXlmXHnmxhMiHk9wqnB7IkFDnWoSt6teM0VIlf0XfSLU7KShRk
	 EKavJtdWg884Z10YXPtOKou1gXLi75C6jyrcnd7sIgusINm9fnCTTI+YnXwlz44dGs
	 AUEh6kwNbWaSCWKpvE+5UKKigHE4VbBch/wtonpHnHmbNhTLohnl4cgQPdBWrwGT3+
	 nqIH1g+5XDNDQ==
Date: Wed, 26 Feb 2025 09:33:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: convert buffer cache to use high order folios
Message-ID: <20250226173333.GR6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-8-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:35AM -0800, Christoph Hellwig wrote:
> Now that we have the buffer cache using the folio API, we can extend
> the use of folios to allocate high order folios for multi-page
> buffers rather than an array of single pages that are then vmapped
> into a contiguous range.
> 
> This creates a new type of single folio buffers that can have arbitrary
> order in addition to the existing multi-folio buffers made up of many
> single page folios that get vmapped.  The single folio is for now
> stashed into the existing b_pages array, but that will go away entirely
> later in the series and remove the temporary page vs folio typing issues
> that only work because the two structures currently can be used largely
> interchangeable.
> 
> The code that allocates buffers will optimistically attempt a high
> order folio allocation as a fast path if the buffer size is a power
> of two and thus fits into a folio. If this high order allocation
> fails, then we fall back to the existing multi-folio allocation
> code. This now forms the slow allocation path, and hopefully will be
> largely unused in normal conditions except for buffers with size
> that are not a power of two like larger remote xattrs.
> 
> This should improve performance of large buffer operations (e.g.
> large directory block sizes) as we should now mostly avoid the
> expense of vmapping large buffers (and the vmap lock contention that
> can occur) as well as avoid the runtime pressure that frequently
> accessing kernel vmapped pages put on the TLBs.
> 
> Based on a patch from Dave Chinner <dchinner@redhat.com>, but mutilated
> beyond recognition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 58 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 52 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f327bf5b04c0..3c582eaa656d 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -261,9 +261,10 @@ xfs_buf_free_pages(
>  
>  	for (i = 0; i < bp->b_page_count; i++) {
>  		if (bp->b_pages[i])
> -			__free_page(bp->b_pages[i]);
> +			folio_put(page_folio(bp->b_pages[i]));
>  	}
> -	mm_account_reclaimed_pages(bp->b_page_count);
> +	mm_account_reclaimed_pages(
> +			DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE));

Why do we round the number of bytes in the buffer up to base page size?

Don't we want howmany(BBTOB(bp->b_length), PAGE_SIZE) here?

Oh wait, howmany *is* DIV_ROUND_UP.  Never mind...

>  	if (bp->b_pages != bp->b_page_array)
>  		kfree(bp->b_pages);
> @@ -336,12 +337,17 @@ xfs_buf_alloc_kmem(
>   * For tmpfs-backed buffers used by in-memory btrees this directly maps the
>   * tmpfs page cache folios.
>   *
> - * For real file system buffers there are two different kinds backing memory:
> + * For real file system buffers there are three different kinds backing memory:
>   *
>   * The first type backs the buffer by a kmalloc allocation.  This is done for
>   * less than PAGE_SIZE allocations to avoid wasting memory.
>   *
> - * The second type of buffer is the multi-page buffer. These are always made
> + * The second type is a single folio buffer - this may be a high order folio or
> + * just a single page sized folio, but either way they get treated the same way
> + * by the rest of the code - the buffer memory spans a single contiguous memory
> + * region that we don't have to map and unmap to access the data directly.
> + *
> + * The third type of buffer is the multi-page buffer. These are always made
>   * up of single pages so that they can be fed to vmap_ram() to return a
>   * contiguous memory region we can access the data through, or mark it as
>   * XBF_UNMAPPED and access the data directly through individual page_address()
> @@ -354,6 +360,7 @@ xfs_buf_alloc_backing_mem(
>  {
>  	size_t		size = BBTOB(bp->b_length);
>  	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
> +	struct folio	*folio;
>  	long		filled = 0;
>  
>  	if (xfs_buftarg_is_mem(bp->b_target))
> @@ -375,7 +382,46 @@ xfs_buf_alloc_backing_mem(
>  	if (size < PAGE_SIZE && is_power_of_2(size))
>  		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
>  
> -	/* Make sure that we have a page list */
> +	/* Assure zeroed buffer for non-read cases. */
> +	if (!(flags & XBF_READ))
> +		gfp_mask |= __GFP_ZERO;

Didn't this get added ten lines up in "xfs: remove the kmalloc to page
allocator fallback"?

> +
> +	/*
> +	 * Don't bother with the retry loop for single PAGE allocations, there
> +	 * is litte changes this can be better than the VM version.

Er... I don't understand the second half of this sentence; is this what
you're trying to communicate?:

"Don't bother with the retry loop for single-page allocations; vmalloc
won't do any better."

> +	 */
> +	if (size <= PAGE_SIZE)
> +		gfp_mask |= __GFP_NOFAIL;
> +
> +	/*
> +	 * Optimistically attempt a single high order folio allocation for
> +	 * larger than PAGE_SIZE buffers.
> +	 *
> +	 * Allocating a high order folio makes the assumption that buffers are a
> +	 * power-of-2 size, matching the power-of-2 folios sizes available.
> +	 *
> +	 * The exception here are user xattr data buffers, which can be arbitrarily
> +	 * sized up to 64kB plus structure metadata, skip straight to the vmalloc
> +	 * path for them instead of wasting memory.
> +	 * here.

Nit: "...path for them instead of wasting memory here."

--D

> +	 */
> +	if (size > PAGE_SIZE && !is_power_of_2(size))
> +		goto fallback;
> +	folio = folio_alloc(gfp_mask, get_order(size));
> +	if (!folio) {
> +		if (size <= PAGE_SIZE)
> +			return -ENOMEM;
> +		goto fallback;
> +	}
> +	bp->b_addr = folio_address(folio);
> +	bp->b_page_array[0] = &folio->page;
> +	bp->b_pages = bp->b_page_array;
> +	bp->b_page_count = 1;
> +	bp->b_flags |= _XBF_PAGES;
> +	return 0;
> +
> +fallback:
> +	/* Fall back to allocating an array of single page folios. */
>  	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
>  	if (bp->b_page_count <= XB_PAGES) {
>  		bp->b_pages = bp->b_page_array;
> @@ -1529,7 +1575,7 @@ xfs_buf_submit_bio(
>  	bio->bi_private = bp;
>  	bio->bi_end_io = xfs_buf_bio_end_io;
>  
> -	if (bp->b_flags & _XBF_KMEM) {
> +	if (bp->b_page_count == 1) {
>  		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
>  				offset_in_page(bp->b_addr));
>  	} else {
> -- 
> 2.45.2
> 
> 
