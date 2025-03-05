Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CAA206F17
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 22:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741215248; cv=none; b=eIUw4xskTv2L1O4/Cm+pjT4K8Mw8KEkXc206yYC2OYYuLBPJ8S9bDtm8KiU8fNE/FlQVqXOLqwKUnLRX2e4g0Lh/xU1aqf9CIGYZ9Evm1JhKIOaI6UPlrXfWvAVn5rCSj6Cuz/B0Dy4fqGZn+u/Yet2jDzISAxznELFQ+obgOqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741215248; c=relaxed/simple;
	bh=5mpSWfQpjeuDdOCghSutOiQlWZf0w0Ux7X2hgH3k0TM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usN2xpOGlaSRQ+sUtyQryMoqEdR7pWanzi+eCAqn7gTN16taeSenT3VGTogcwogPL+G6K3JTmlG+8BNUMeedICaQ06a6KkCrYUOfLz6S3hqsfEDNpkY2Q2s9d76TrsmPNcWISeADZf0vhKv0ZVH+xippApKZu5YDlp0RTdRpB10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMxfLmtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMxfLmtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039B0C4CED1;
	Wed,  5 Mar 2025 22:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741215248;
	bh=5mpSWfQpjeuDdOCghSutOiQlWZf0w0Ux7X2hgH3k0TM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMxfLmtz/wXVXeIYYWG31MI8Tmi8rUNJRX1qA9y3ZnOpbk1eQ2ct+Xxgp0yyWm5fA
	 6mWk0G6GmCb73AZkK3ekrDDtO0datUdPQE5rYwVAVDchIIhdrmJ3A6k7E+nHGnWSNY
	 xMXD0OL66TxdcPzoFV3P+RqIbBf0LBMiK5Ws9/x/Q/ajGrzGmc+1yuzPq3JAj3CoQ9
	 iLzRAExWfIVTZfPyjobVeM3fdLVE2DGw9OZIcBGSRauitkzKzNT2IjkuvEpxD2P3qJ
	 ZLORQdAFrM6REXl7Xtybr8UxnIy839Ne/vctO9KH0xzRFl6lJXFXUBA+grqapOfgSG
	 3NdJhkIc4neEA==
Date: Wed, 5 Mar 2025 14:54:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for buffer
 backing memory
Message-ID: <20250305225407.GM2803749@frogsfrogsfrogs>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-11-hch@lst.de>
 <Z8jACLtp5X98ShBR@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jACLtp5X98ShBR@dread.disaster.area>

On Thu, Mar 06, 2025 at 08:20:08AM +1100, Dave Chinner wrote:
> On Wed, Mar 05, 2025 at 07:05:27AM -0700, Christoph Hellwig wrote:
> > The fallback buffer allocation path currently open codes a suboptimal
> > version of vmalloc to allocate pages that are then mapped into
> > vmalloc space.  Switch to using vmalloc instead, which uses all the
> > optimizations in the common vmalloc code, and removes the need to
> > track the backing pages in the xfs_buf structure.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> .....
> 
> > @@ -1500,29 +1373,43 @@ static void
> >  xfs_buf_submit_bio(
> >  	struct xfs_buf		*bp)
> >  {
> > -	unsigned int		size = BBTOB(bp->b_length);
> > -	unsigned int		map = 0, p;
> > +	unsigned int		map = 0;
> >  	struct blk_plug		plug;
> >  	struct bio		*bio;
> >  
> > -	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count,
> > -			xfs_buf_bio_op(bp), GFP_NOIO);
> > -	bio->bi_private = bp;
> > -	bio->bi_end_io = xfs_buf_bio_end_io;
> > +	if (is_vmalloc_addr(bp->b_addr)) {
> > +		unsigned int	size = BBTOB(bp->b_length);
> > +		unsigned int	alloc_size = roundup(size, PAGE_SIZE);
> > +		void		*data = bp->b_addr;
> >  
> > -	if (bp->b_page_count == 1) {
> > -		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
> > -				offset_in_page(bp->b_addr));
> > -	} else {
> > -		for (p = 0; p < bp->b_page_count; p++)
> > -			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
> > -		bio->bi_iter.bi_size = size; /* limit to the actual size used */
> > +		bio = bio_alloc(bp->b_target->bt_bdev, alloc_size >> PAGE_SHIFT,
> > +				xfs_buf_bio_op(bp), GFP_NOIO);
> > +
> > +		do {
> > +			unsigned int	len = min(size, PAGE_SIZE);
> >  
> > -		if (is_vmalloc_addr(bp->b_addr))
> > -			flush_kernel_vmap_range(bp->b_addr,
> > -					xfs_buf_vmap_len(bp));
> > +			ASSERT(offset_in_page(data) == 0);
> > +			__bio_add_page(bio, vmalloc_to_page(data), len, 0);
> > +			data += len;
> > +			size -= len;
> > +		} while (size);
> > +
> > +		flush_kernel_vmap_range(bp->b_addr, alloc_size);
> > +	} else {
> > +		/*
> > +		 * Single folio or slab allocation.  Must be contiguous and thus
> > +		 * only a single bvec is needed.
> > +		 */
> > +		bio = bio_alloc(bp->b_target->bt_bdev, 1, xfs_buf_bio_op(bp),
> > +				GFP_NOIO);
> > +		__bio_add_page(bio, virt_to_page(bp->b_addr),
> > +				BBTOB(bp->b_length),
> > +				offset_in_page(bp->b_addr));
> >  	}
> 
> How does offset_in_page() work with a high order folio? It can only
> return a value between 0 and (PAGE_SIZE - 1). i.e. shouldn't this
> be:
> 
> 		folio = kmem_to_folio(bp->b_addr);
> 
> 		bio_add_folio_nofail(bio, folio, BBTOB(bp->b_length),
> 				offset_in_folio(folio, bp->b_addr));

I think offset_in_folio() returns 0 in the !kmem && !vmalloc case
because we allocate the folio and set b_addr to folio_address(folio);
and we never call the kmem alloc code for sizes greater than PAGE_SIZE.

--D

> 
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
