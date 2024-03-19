Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D6536137
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710870150; cv=none; b=OTh7XNfOur76xlOFOXBjTx7FsPVhBifr+2gPNXLsrYABGSHhmdelguVBvolNp/zfLaQw2O/HsQFMETzSg8xIQLoO8HWB1lrrusBRxc2h2Tacr6ASiO9H7RfbLC2eskU4tPJx8cPxKdzayqoG5BQ6GZVO1JWJxvrV4IILb1f3wJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710870150; c=relaxed/simple;
	bh=Pj0krUuQad7MIzOSIFsJDvbJywcr+PmjrfbtnPVLSDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oc5KpXrzu3O6j1r/3gZLcbIeGvHEYil6oa6PXNiB6eFhEqqyi4D3mONPz8NY7yRLFZlx/5tuux95t6Ow031670u2JH0UAuL3wWOSD5UoFC5Ki6ir2hU2Y0ezDNJ5G4Y6D+xUhW35pKdb/qqbmWt3CrG0tpFOLOI3EFFhyrvVoBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=suHbI1o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="suHbI1o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01E3C433C7;
	Tue, 19 Mar 2024 17:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710870150;
	bh=Pj0krUuQad7MIzOSIFsJDvbJywcr+PmjrfbtnPVLSDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=suHbI1o5bJHdTznZOxxwUFpuRRhAcIkOUrhl08q59TpMwmfhWsfXo2UvDcJS8I53n
	 8VlccN4VbzFUUvqDgzoO9eOpvJh5qoJM56E3E7ABFNkTob7yrPXVjcy+vm4v9Skp77
	 YVltuB4acgdjkh4GMe/JMZin2D3iUvQzE0ew3CjpWpviPMEKLRzHPi3tKmJvd+e1UQ
	 q2UsP4nd8zpirf50N1UBEYHFScW5VWB2LVCgB5TBoM9IN1aXeRaFZTmZ+IvIKoxcXA
	 6/QOTAWdVkEmh4+/gk3yK2i2j+wrCgZRMJ2V4U+H4YjMhy51a+5lYxqjbNHgG/EE5i
	 CyLepMhzul1Gg==
Date: Tue, 19 Mar 2024 10:42:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: walk b_addr for buffer I/O
Message-ID: <20240319174229.GT1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-8-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-8-david@fromorbit.com>

On Tue, Mar 19, 2024 at 09:45:58AM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Instead of walking the folio array just walk the kernel virtual
> address in ->b_addr.  This prepares for using vmalloc for buffers
> and removing the b_folio array.
> 
> [dchinner: ported to folios-based buffers.]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 110 +++++++++++++----------------------------------
>  fs/xfs/xfs_buf.h |   2 -
>  2 files changed, 29 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a77e2d8c8107..303945554415 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -358,7 +358,6 @@ xfs_buf_alloc_kmem(
>  	}
>  	bp->b_folios = bp->b_folio_array;
>  	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
> -	bp->b_offset = offset_in_folio(bp->b_folios[0], bp->b_addr);
>  	bp->b_folio_count = 1;
>  	bp->b_flags |= _XBF_KMEM;
>  	return 0;
> @@ -1549,87 +1548,44 @@ xfs_buf_bio_end_io(
>  static void
>  xfs_buf_ioapply_map(
>  	struct xfs_buf	*bp,
> -	int		map,
> -	int		*buf_offset,
> -	int		*count,
> +	unsigned int	map,

I like making these never-negative quantities unsigned.

> +	unsigned int	*buf_offset,
>  	blk_opf_t	op)
>  {
> -	int		folio_index;
> -	unsigned int	total_nr_folios = bp->b_folio_count;
> -	int		nr_folios;
>  	struct bio	*bio;
> -	sector_t	sector =  bp->b_maps[map].bm_bn;
>  	int		size;
> -	int		offset;
>  
> -	/*
> -	 * If the start offset if larger than a single page, we need to be
> -	 * careful. We might have a high order folio, in which case the indexing
> -	 * is from the start of the buffer. However, if we have more than one
> -	 * folio single page folio in the buffer, we need to skip the folios in
> -	 * the buffer before the start offset.
> -	 */
> -	folio_index = 0;
> -	offset = *buf_offset;
> -	if (bp->b_folio_count > 1) {
> -		while (offset >= PAGE_SIZE) {
> -			folio_index++;
> -			offset -= PAGE_SIZE;
> -		}
> +	/* Limit the IO size to the length of the current vector. */
> +	size = min_t(unsigned int, BBTOB(bp->b_maps[map].bm_len),
> +			BBTOB(bp->b_length) - *buf_offset);
> +
> +	if (WARN_ON_ONCE(bp->b_folio_count > BIO_MAX_VECS)) {
> +		xfs_buf_ioerror(bp, -EIO);
> +		return;
>  	}
>  
> -	/*
> -	 * Limit the IO size to the length of the current vector, and update the
> -	 * remaining IO count for the next time around.
> -	 */
> -	size = min_t(int, BBTOB(bp->b_maps[map].bm_len), *count);
> -	*count -= size;
> -	*buf_offset += size;
> -
> -next_chunk:
>  	atomic_inc(&bp->b_io_remaining);
> -	nr_folios = bio_max_segs(total_nr_folios);
>  
> -	bio = bio_alloc(bp->b_target->bt_bdev, nr_folios, op, GFP_NOIO);
> -	bio->bi_iter.bi_sector = sector;
> +	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_folio_count, op, GFP_NOIO);
> +	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
>  	bio->bi_end_io = xfs_buf_bio_end_io;
>  	bio->bi_private = bp;
>  
> -	for (; size && nr_folios; nr_folios--, folio_index++) {
> -		struct folio	*folio = bp->b_folios[folio_index];
> -		int		nbytes = folio_size(folio) - offset;
> -
> -		if (nbytes > size)
> -			nbytes = size;
> -
> -		if (!bio_add_folio(bio, folio, nbytes,
> -				offset_in_folio(folio, offset)))
> -			break;
> -
> -		offset = 0;
> -		sector += BTOBB(nbytes);
> -		size -= nbytes;
> -		total_nr_folios--;
> -	}
> -
> -	if (likely(bio->bi_iter.bi_size)) {
> -		if (xfs_buf_is_vmapped(bp)) {
> -			flush_kernel_vmap_range(bp->b_addr,
> -						xfs_buf_vmap_len(bp));
> -		}
> -		submit_bio(bio);
> -		if (size)
> -			goto next_chunk;
> -	} else {
> -		/*
> -		 * This is guaranteed not to be the last io reference count
> -		 * because the caller (xfs_buf_submit) holds a count itself.
> -		 */
> -		atomic_dec(&bp->b_io_remaining);
> -		xfs_buf_ioerror(bp, -EIO);
> -		bio_put(bio);
> -	}
> -
> +	do {
> +		void		*data = bp->b_addr + *buf_offset;
> +		struct folio	*folio = kmem_to_folio(data);
> +		unsigned int	off = offset_in_folio(folio, data);
> +		unsigned int	len = min_t(unsigned int, size,
> +						folio_size(folio) - off);
> +
> +		bio_add_folio_nofail(bio, folio, len, off);
> +		size -= len;
> +		*buf_offset += len;
> +	} while (size);
> +
> +	if (xfs_buf_is_vmapped(bp))
> +		flush_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
> +	submit_bio(bio);
>  }
>  
>  STATIC void
> @@ -1638,8 +1594,7 @@ _xfs_buf_ioapply(
>  {
>  	struct blk_plug	plug;
>  	blk_opf_t	op;
> -	int		offset;
> -	int		size;
> +	unsigned int	offset = 0;
>  	int		i;
>  
>  	/*
> @@ -1701,16 +1656,9 @@ _xfs_buf_ioapply(
>  	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
>  	 * subsequent call.
>  	 */
> -	offset = bp->b_offset;

Huh.  So ... where does b_offset come into play here?

OH.  Since we're starting with b_addr and working our way /back/ to
folios, we don't need b_offset anymore since we can compute that from
(b_addr - folio_address()).  So then the @offset variable in
_xfs_buf_ioapply is really a cursor into how far into the xfs_buf we've
ioapply'd.

Would you mind adding a sentence to the commit message?

"Instead of walking the folio array just walk the kernel virtual address
in ->b_addr.  This prepares for using vmalloc for buffers and removing
the b_folio array.  Furthermore, b_offset goes away since we can compute
that from b_addr and the folio."

With that changed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -	size = BBTOB(bp->b_length);
>  	blk_start_plug(&plug);
> -	for (i = 0; i < bp->b_map_count; i++) {
> -		xfs_buf_ioapply_map(bp, i, &offset, &size, op);
> -		if (bp->b_error)
> -			break;
> -		if (size <= 0)
> -			break;	/* all done */
> -	}
> +	for (i = 0; i < bp->b_map_count; i++)
> +		xfs_buf_ioapply_map(bp, i, &offset, op);
>  	blk_finish_plug(&plug);
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index aef7015cf9f3..4d515407713b 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -198,8 +198,6 @@ struct xfs_buf {
>  	atomic_t		b_pin_count;	/* pin count */
>  	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
>  	unsigned int		b_folio_count;	/* size of folio array */
> -	unsigned int		b_offset;	/* page offset of b_addr,
> -						   only for _XBF_KMEM buffers */
>  	int			b_error;	/* error code on I/O */
>  
>  	/*
> -- 
> 2.43.0
> 
> 
