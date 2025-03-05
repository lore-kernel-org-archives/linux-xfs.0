Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426C423027C
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 18:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198810; cv=none; b=jDN4uH/6LuEiNLpkuYbvGmY89R9nzJlEFl6jL4oGvV4G61KiAqckVSiZs78P2wuuUiW2ar+fAKVrpKkqiGZxekv3hmBGtYu9QLx537d44HYHDWp6m5Tp0ns+l7wjOsPTDW+2EhC3qTwjMuEhfhvoI9dKFu2kpwEMImbTZVkrQLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198810; c=relaxed/simple;
	bh=npV/RxsCrxKtSH1DDLZWpZF0Y/q5efYQJzwU9BC25+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sclVi8WUXr32aEctSsmpAkVu54cfb3BzQa2vGeIsDg4ikNIMNVlN+R15QrbjMym91khDsLMINFFuI86Q709cEMqYLXHJUQ0hkHmzRmy02IdNMp9Aoe/541kP2VMkH3nG9H3vFYUQ7E1cIpR1kG72gC5jZ6/VcNCXP73/SqrbpRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cz3Mc5s0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cz3Mc5s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AB2C4CEE0;
	Wed,  5 Mar 2025 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741198810;
	bh=npV/RxsCrxKtSH1DDLZWpZF0Y/q5efYQJzwU9BC25+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cz3Mc5s03zmTyvzrm7yRooyw1M3mvDl2ECsQyDzhEPrcYHOz54fxe2IPKto7jcrDr
	 fb5iENnjGtlIlvAS35PneWxAD5EvMLdIj41vhn//az7EzJV16ukyCQqvrLvhUVNsL0
	 1qYIQTpMqrE2B1PqwfOM1AHoEEGrojQD3GxDEtfNpVu8prK/cjmNp1R2OB/uJAXoP4
	 pjr/K5Y8RMATn+nlA3YPwNBHvfTsderV0eaPRlbcd+mTfqbxnqbXcF76XZG6pJWKjC
	 ZPxoolTZTi3QlXoi0vAah1RF1yB2wW3gYFtvi30ZuLk/Urag1LZUu2h2QPF4oA+H5v
	 diN+O0ZjDLCwQ==
Date: Wed, 5 Mar 2025 10:20:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: convert buffer cache to use high order folios
Message-ID: <20250305182009.GJ2803749@frogsfrogsfrogs>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305140532.158563-8-hch@lst.de>

On Wed, Mar 05, 2025 at 07:05:24AM -0700, Christoph Hellwig wrote:
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

Looks good now!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 52 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 073246d4352f..f0666ef57bd2 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -203,9 +203,9 @@ xfs_buf_free_pages(
>  
>  	for (i = 0; i < bp->b_page_count; i++) {
>  		if (bp->b_pages[i])
> -			__free_page(bp->b_pages[i]);
> +			folio_put(page_folio(bp->b_pages[i]));
>  	}
> -	mm_account_reclaimed_pages(bp->b_page_count);
> +	mm_account_reclaimed_pages(howmany(BBTOB(bp->b_length), PAGE_SIZE));
>  
>  	if (bp->b_pages != bp->b_page_array)
>  		kfree(bp->b_pages);
> @@ -277,12 +277,17 @@ xfs_buf_alloc_kmem(
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
> @@ -295,6 +300,7 @@ xfs_buf_alloc_backing_mem(
>  {
>  	size_t		size = BBTOB(bp->b_length);
>  	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
> +	struct folio	*folio;
>  	long		filled = 0;
>  
>  	if (xfs_buftarg_is_mem(bp->b_target))
> @@ -316,7 +322,41 @@ xfs_buf_alloc_backing_mem(
>  	if (size < PAGE_SIZE && is_power_of_2(size))
>  		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
>  
> -	/* Make sure that we have a page list */
> +	/*
> +	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
> +	 * won't do any better.
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
> +	 * path for them instead of wasting memory here.
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
> @@ -1474,7 +1514,7 @@ xfs_buf_submit_bio(
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
