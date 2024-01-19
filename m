Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADADEC7
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 01:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705627861; cv=none; b=BDFaimrhfj7j3XLP3xhRSLp0ZRtDGRwEM7Upokmh2GGJZRN8pu40RK0C1pvJQxnS+gl6KPyqnwdrLjXkBr9TNLp18so2crXqi2qNH/gDlOG7VjBnPn0g2WxfA20V9i840p/dfA28bOp3O+nU6jlRTQPv0FnLyzTopXTXROvRdSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705627861; c=relaxed/simple;
	bh=sj8LwBuxpDXj+ppO1Uutgop62svsZ8u/RQRfzC/WmKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPRs+wcK78WqRrtarbcM2pw0w9kunWz2E2QAM/vE4BhuDFN8KHhHskyzaoXkdsdUFMuIN2lQKpGaUyoHIrwPWJF6fbKdrAzhKZMrUWxuTRGsTwGnntrd0rwWl8ZNPQ8KXcBmI9M9C4JSQpANL/a4ZPcljxJcaHIczI8XkHwa274=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKUaiou+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKUaiou+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F57C433F1;
	Fri, 19 Jan 2024 01:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705627860;
	bh=sj8LwBuxpDXj+ppO1Uutgop62svsZ8u/RQRfzC/WmKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SKUaiou+JC9Z7hoEwuwBPt3MxvsMqyjLtanjl7b4207fuWIDAMAqGY6HNpJxf3e65
	 4Eph/WbTGlOgRJnM//JOz39b5aAJ7ntzDxRJCyRML8w67p7epcsMQ99C8754qB5TD1
	 7Rj6ngjpNUSrMJDoukcozVNy1KlNhicZAqwDaFoL+9WPEVKkIyaDGa/RvRpEVop4Hw
	 xo3LjE9q6hO/hAOWMMj9BOgTx5KuyjzHuM84He1vOFltvXxYpq4JKLoprh08JCMIks
	 ZvIZk8UhyzzVFvzFCva5H5RN/npWoO1C9Lit2z1+vhIuyNZnjy9xCSWbz94j+EKnEl
	 DtyE/8ebvuCCQ==
Date: Thu, 18 Jan 2024 17:31:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: convert buffer cache to use high order folios
Message-ID: <20240119013100.GR674499@frogsfrogsfrogs>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118222216.4131379-4-david@fromorbit.com>

On Fri, Jan 19, 2024 at 09:19:41AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have the buffer cache using the folio API, we can extend
> the use of folios to allocate high order folios for multi-page
> buffers rather than an array of single pages that are then vmapped
> into a contiguous range.
> 
> This creates two types of buffers: single folio buffers that can
> have arbitrary order, and multi-folio buffers made up of many single
> page folios that get vmapped. The latter is essentially the existing
> code, so there are no logic changes to handle this case.
> 
> There are a few places where we iterate the folios on a buffer.
> These need to be converted to handle the high order folio case.
> Luckily, this only occurs when bp->b_folio_count == 1, and the code
> for handling this case is just a simple application of the folio API
> to the operations that need to be performed.
> 
> The code that allocates buffers will optimistically attempt a high
> order folio allocation as a fast path. If this high order allocation
> fails, then we fall back to the existing multi-folio allocation
> code. This now forms the slow allocation path, and hopefully will be
> largely unused in normal conditions.
> 
> This should improve performance of large buffer operations (e.g.
> large directory block sizes) as we should now mostly avoid the
> expense of vmapping large buffers (and the vmap lock contention that
> can occur) as well as avoid the runtime pressure that frequently
> accessing kernel vmapped pages put on the TLBs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 150 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 119 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15907e92d0d3..df363f17ea1a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -74,6 +74,10 @@ xfs_buf_is_vmapped(
>  	return bp->b_addr && bp->b_folio_count > 1;
>  }
>  
> +/*
> + * See comment above xfs_buf_alloc_folios() about the constraints placed on
> + * allocating vmapped buffers.
> + */
>  static inline int
>  xfs_buf_vmap_len(
>  	struct xfs_buf	*bp)
> @@ -344,14 +348,72 @@ xfs_buf_alloc_kmem(
>  		bp->b_addr = NULL;
>  		return -ENOMEM;
>  	}
> -	bp->b_offset = offset_in_page(bp->b_addr);
>  	bp->b_folios = bp->b_folio_array;
>  	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
> +	bp->b_offset = offset_in_folio(bp->b_folios[0], bp->b_addr);
>  	bp->b_folio_count = 1;
>  	bp->b_flags |= _XBF_KMEM;
>  	return 0;
>  }
>  
> +/*
> + * Allocating a high order folio makes the assumption that buffers are a
> + * power-of-2 size so that ilog2() returns the exact order needed to fit
> + * the contents of the buffer. Buffer lengths are mostly a power of two,
> + * so this is not an unreasonable approach to take by default.
> + *
> + * The exception here are user xattr data buffers, which can be arbitrarily
> + * sized up to 64kB plus structure metadata. In that case, round up the order.
> + */
> +static bool
> +xfs_buf_alloc_folio(
> +	struct xfs_buf	*bp,
> +	gfp_t		gfp_mask)
> +{
> +	int		length = BBTOB(bp->b_length);
> +	int		order;
> +
> +	order = ilog2(length);
> +	if ((1 << order) < length)
> +		order = ilog2(length - 1) + 1;
> +
> +	if (order <= PAGE_SHIFT)
> +		order = 0;
> +	else
> +		order -= PAGE_SHIFT;
> +
> +	bp->b_folio_array[0] = folio_alloc(gfp_mask, order);
> +	if (!bp->b_folio_array[0])
> +		return false;
> +
> +	bp->b_folios = bp->b_folio_array;
> +	bp->b_folio_count = 1;
> +	bp->b_flags |= _XBF_FOLIOS;
> +	return true;

Hmm.  So I guess with this patchset, either we get one multi-page large
folio for the whole buffer, or we fall back to the array of basepage
sized folios?

/me wonders if the extra flexibility from alloc_folio_bulk_array and a
folioized vm_map_ram would eliminate all this special casing?

Uhoh, lights flickering again and ice crashing off the roof.  I better
go before the lights go out again. :(

--D

> +}
> +
> +/*
> + * When we allocate folios for a buffer, we end up with one of two types of
> + * buffer.
> + *
> + * The first type is a single folio buffer - this may be a high order
> + * folio or just a single page sized folio, but either way they get treated the
> + * same way by the rest of the code - the buffer memory spans a single
> + * contiguous memory region that we don't have to map and unmap to access the
> + * data directly.
> + *
> + * The second type of buffer is the multi-folio buffer. These are *always* made
> + * up of single page folios so that they can be fed to vmap_ram() to return a
> + * contiguous memory region we can access the data through, or mark it as
> + * XBF_UNMAPPED and access the data directly through individual folio_address()
> + * calls.
> + *
> + * We don't use high order folios for this second type of buffer (yet) because
> + * having variable size folios makes offset-to-folio indexing and iteration of
> + * the data range more complex than if they are fixed size. This case should now
> + * be the slow path, though, so unless we regularly fail to allocate high order
> + * folios, there should be little need to optimise this path.
> + */
>  static int
>  xfs_buf_alloc_folios(
>  	struct xfs_buf	*bp,
> @@ -363,7 +425,15 @@ xfs_buf_alloc_folios(
>  	if (flags & XBF_READ_AHEAD)
>  		gfp_mask |= __GFP_NORETRY;
>  
> -	/* Make sure that we have a page list */
> +	/* Assure zeroed buffer for non-read cases. */
> +	if (!(flags & XBF_READ))
> +		gfp_mask |= __GFP_ZERO;
> +
> +	/* Optimistically attempt a single high order folio allocation. */
> +	if (xfs_buf_alloc_folio(bp, gfp_mask))
> +		return 0;
> +
> +	/* Fall back to allocating an array of single page folios. */
>  	bp->b_folio_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
>  	if (bp->b_folio_count <= XB_FOLIOS) {
>  		bp->b_folios = bp->b_folio_array;
> @@ -375,9 +445,6 @@ xfs_buf_alloc_folios(
>  	}
>  	bp->b_flags |= _XBF_FOLIOS;
>  
> -	/* Assure zeroed buffer for non-read cases. */
> -	if (!(flags & XBF_READ))
> -		gfp_mask |= __GFP_ZERO;
>  
>  	/*
>  	 * Bulk filling of pages can take multiple calls. Not filling the entire
> @@ -418,7 +485,7 @@ _xfs_buf_map_folios(
>  {
>  	ASSERT(bp->b_flags & _XBF_FOLIOS);
>  	if (bp->b_folio_count == 1) {
> -		/* A single page buffer is always mappable */
> +		/* A single folio buffer is always mappable */
>  		bp->b_addr = folio_address(bp->b_folios[0]);
>  	} else if (flags & XBF_UNMAPPED) {
>  		bp->b_addr = NULL;
> @@ -1465,20 +1532,28 @@ xfs_buf_ioapply_map(
>  	int		*count,
>  	blk_opf_t	op)
>  {
> -	int		page_index;
> -	unsigned int	total_nr_pages = bp->b_folio_count;
> -	int		nr_pages;
> +	int		folio_index;
> +	unsigned int	total_nr_folios = bp->b_folio_count;
> +	int		nr_folios;
>  	struct bio	*bio;
>  	sector_t	sector =  bp->b_maps[map].bm_bn;
>  	int		size;
>  	int		offset;
>  
> -	/* skip the pages in the buffer before the start offset */
> -	page_index = 0;
> +	/*
> +	 * If the start offset if larger than a single page, we need to be
> +	 * careful. We might have a high order folio, in which case the indexing
> +	 * is from the start of the buffer. However, if we have more than one
> +	 * folio single page folio in the buffer, we need to skip the folios in
> +	 * the buffer before the start offset.
> +	 */
> +	folio_index = 0;
>  	offset = *buf_offset;
> -	while (offset >= PAGE_SIZE) {
> -		page_index++;
> -		offset -= PAGE_SIZE;
> +	if (bp->b_folio_count > 1) {
> +		while (offset >= PAGE_SIZE) {
> +			folio_index++;
> +			offset -= PAGE_SIZE;
> +		}
>  	}
>  
>  	/*
> @@ -1491,28 +1566,28 @@ xfs_buf_ioapply_map(
>  
>  next_chunk:
>  	atomic_inc(&bp->b_io_remaining);
> -	nr_pages = bio_max_segs(total_nr_pages);
> +	nr_folios = bio_max_segs(total_nr_folios);
>  
> -	bio = bio_alloc(bp->b_target->bt_bdev, nr_pages, op, GFP_NOIO);
> +	bio = bio_alloc(bp->b_target->bt_bdev, nr_folios, op, GFP_NOIO);
>  	bio->bi_iter.bi_sector = sector;
>  	bio->bi_end_io = xfs_buf_bio_end_io;
>  	bio->bi_private = bp;
>  
> -	for (; size && nr_pages; nr_pages--, page_index++) {
> -		int	rbytes, nbytes = PAGE_SIZE - offset;
> +	for (; size && nr_folios; nr_folios--, folio_index++) {
> +		struct folio	*folio = bp->b_folios[folio_index];
> +		int		nbytes = folio_size(folio) - offset;
>  
>  		if (nbytes > size)
>  			nbytes = size;
>  
> -		rbytes = bio_add_folio(bio, bp->b_folios[page_index], nbytes,
> -				      offset);
> -		if (rbytes < nbytes)
> +		if (!bio_add_folio(bio, folio, nbytes,
> +				offset_in_folio(folio, offset)))
>  			break;
>  
>  		offset = 0;
>  		sector += BTOBB(nbytes);
>  		size -= nbytes;
> -		total_nr_pages--;
> +		total_nr_folios--;
>  	}
>  
>  	if (likely(bio->bi_iter.bi_size)) {
> @@ -1722,6 +1797,13 @@ xfs_buf_offset(
>  	if (bp->b_addr)
>  		return bp->b_addr + offset;
>  
> +	/* Single folio buffers may use large folios. */
> +	if (bp->b_folio_count == 1) {
> +		folio = bp->b_folios[0];
> +		return folio_address(folio) + offset_in_folio(folio, offset);
> +	}
> +
> +	/* Multi-folio buffers always use PAGE_SIZE folios */
>  	folio = bp->b_folios[offset >> PAGE_SHIFT];
>  	return folio_address(folio) + (offset & (PAGE_SIZE-1));
>  }
> @@ -1737,18 +1819,24 @@ xfs_buf_zero(
>  	bend = boff + bsize;
>  	while (boff < bend) {
>  		struct folio	*folio;
> -		int		page_index, page_offset, csize;
> +		int		folio_index, folio_offset, csize;
>  
> -		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
> -		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
> -		folio = bp->b_folios[page_index];
> -		csize = min_t(size_t, PAGE_SIZE - page_offset,
> +		/* Single folio buffers may use large folios. */
> +		if (bp->b_folio_count == 1) {
> +			folio = bp->b_folios[0];
> +			folio_offset = offset_in_folio(folio,
> +						bp->b_offset + boff);
> +		} else {
> +			folio_index = (boff + bp->b_offset) >> PAGE_SHIFT;
> +			folio_offset = (boff + bp->b_offset) & ~PAGE_MASK;
> +			folio = bp->b_folios[folio_index];
> +		}
> +
> +		csize = min_t(size_t, folio_size(folio) - folio_offset,
>  				      BBTOB(bp->b_length) - boff);
> +		ASSERT((csize + folio_offset) <= folio_size(folio));
>  
> -		ASSERT((csize + page_offset) <= PAGE_SIZE);
> -
> -		memset(folio_address(folio) + page_offset, 0, csize);
> -
> +		memset(folio_address(folio) + folio_offset, 0, csize);
>  		boff += csize;
>  	}
>  }
> -- 
> 2.43.0
> 
> 
