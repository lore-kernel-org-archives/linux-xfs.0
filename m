Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61528134CB
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710869494; cv=none; b=mOHGpTOLZJSLN1v2AjuRQtaKEmRGvxBOhuGQK9yNFpMcs8ro2cBduZWwbs4vIdhgukMe/G+GZvKlxjQ8xKQj4Iw6ncPzdsrqb6rPoKJd1+0iz1rQ3jTeLBZXmQxyuZM7mipq+5+uec/E89gZV1CEEiSyBUWuIoDO90t/7eos+9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710869494; c=relaxed/simple;
	bh=bJ1ObkW1mXLKH7E2AlilQ+m+AdPrbvG5BYBcp2Q0X78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jc4/xVLTwTg+5BbHGt8ivbNaHyf2ja9D+bhHVO8RqQ1cCbZkxUoGWIUcvfWstBKj8DE1kntgJWNX/EcHev+RXREj+vFadOPaDsrwUJi1Wd21YIU70FuIcQsKe9Uhq3yL/tT1f3r1LTU36equUJ4wvlDf9qhcU9lEvI97B2hlxnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Atp+X8Hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Atp+X8Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334C1C433F1;
	Tue, 19 Mar 2024 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710869494;
	bh=bJ1ObkW1mXLKH7E2AlilQ+m+AdPrbvG5BYBcp2Q0X78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Atp+X8Hq9fRV9p0GtpwxRpuQZgC6tgmJJkbsTfvCcwzxz33wL/ahgFnesmo8CekFJ
	 CYnydiqTTFpiUki/dQBeQkZSFL/CSRN4UUW6x5TdrlGSiIP8M9a1AJCzFe+o5o2xCB
	 YK3NgLKzzeyXslojGYgVIwqKQLObxJIO+hPDOhrT3cmuT8Tiock7sD6CjC1Qp8w/MQ
	 evCqPiIpAYeoEyIQXq5c8WweI/znHbqND+UDFjUW3X61JvYbIewG6ME7nlZMBTTS4J
	 NM9yyeWKiH6wnHj2acurJevKyVi4IgnL9Ia/L2Ko2XY8VB5+3W1eF+BfgXxzQy2v+M
	 VzR3WzwS8ilog==
Date: Tue, 19 Mar 2024 10:31:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: buffer items don't straddle pages anymore
Message-ID: <20240319173133.GR1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-6-david@fromorbit.com>

On Tue, Mar 19, 2024 at 09:45:56AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Unmapped buffers don't exist anymore, so the page straddling
> detection and slow path code can go away now.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Oh good, I was reading throguh this code just yesterday for other
reasons and now I'll just stop. :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 124 ------------------------------------------
>  1 file changed, 124 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 7b66d3fe4ecd..cbc06605d31c 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -56,31 +56,6 @@ xfs_buf_log_format_size(
>  			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
>  }
>  
> -/*
> - * We only have to worry about discontiguous buffer range straddling on unmapped
> - * buffers. Everything else will have a contiguous data region we can copy from.
> - */
> -static inline bool
> -xfs_buf_item_straddle(
> -	struct xfs_buf		*bp,
> -	uint			offset,
> -	int			first_bit,
> -	int			nbits)
> -{
> -	void			*first, *last;
> -
> -	if (bp->b_folio_count == 1)
> -		return false;
> -
> -	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
> -	last = xfs_buf_offset(bp,
> -			offset + ((first_bit + nbits) << XFS_BLF_SHIFT));
> -
> -	if (last - first != nbits * XFS_BLF_CHUNK)
> -		return true;
> -	return false;
> -}
> -
>  /*
>   * Return the number of log iovecs and space needed to log the given buf log
>   * item segment.
> @@ -97,11 +72,8 @@ xfs_buf_item_size_segment(
>  	int				*nvecs,
>  	int				*nbytes)
>  {
> -	struct xfs_buf			*bp = bip->bli_buf;
>  	int				first_bit;
>  	int				nbits;
> -	int				next_bit;
> -	int				last_bit;
>  
>  	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
>  	if (first_bit == -1)
> @@ -114,15 +86,6 @@ xfs_buf_item_size_segment(
>  		nbits = xfs_contig_bits(blfp->blf_data_map,
>  					blfp->blf_map_size, first_bit);
>  		ASSERT(nbits > 0);
> -
> -		/*
> -		 * Straddling a page is rare because we don't log contiguous
> -		 * chunks of unmapped buffers anywhere.
> -		 */
> -		if (nbits > 1 &&
> -		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
> -			goto slow_scan;
> -
>  		(*nvecs)++;
>  		*nbytes += nbits * XFS_BLF_CHUNK;
>  
> @@ -137,43 +100,6 @@ xfs_buf_item_size_segment(
>  	} while (first_bit != -1);
>  
>  	return;
> -
> -slow_scan:
> -	ASSERT(bp->b_addr == NULL);
> -	last_bit = first_bit;
> -	nbits = 1;
> -	while (last_bit != -1) {
> -
> -		*nbytes += XFS_BLF_CHUNK;
> -
> -		/*
> -		 * This takes the bit number to start looking from and
> -		 * returns the next set bit from there.  It returns -1
> -		 * if there are no more bits set or the start bit is
> -		 * beyond the end of the bitmap.
> -		 */
> -		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> -					last_bit + 1);
> -		/*
> -		 * If we run out of bits, leave the loop,
> -		 * else if we find a new set of bits bump the number of vecs,
> -		 * else keep scanning the current set of bits.
> -		 */
> -		if (next_bit == -1) {
> -			if (first_bit != last_bit)
> -				(*nvecs)++;
> -			break;
> -		} else if (next_bit != last_bit + 1 ||
> -		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
> -			last_bit = next_bit;
> -			first_bit = next_bit;
> -			(*nvecs)++;
> -			nbits = 1;
> -		} else {
> -			last_bit++;
> -			nbits++;
> -		}
> -	}
>  }
>  
>  /*
> @@ -286,8 +212,6 @@ xfs_buf_item_format_segment(
>  	struct xfs_buf		*bp = bip->bli_buf;
>  	uint			base_size;
>  	int			first_bit;
> -	int			last_bit;
> -	int			next_bit;
>  	uint			nbits;
>  
>  	/* copy the flags across from the base format item */
> @@ -332,15 +256,6 @@ xfs_buf_item_format_segment(
>  		nbits = xfs_contig_bits(blfp->blf_data_map,
>  					blfp->blf_map_size, first_bit);
>  		ASSERT(nbits > 0);
> -
> -		/*
> -		 * Straddling a page is rare because we don't log contiguous
> -		 * chunks of unmapped buffers anywhere.
> -		 */
> -		if (nbits > 1 &&
> -		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
> -			goto slow_scan;
> -
>  		xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
>  					first_bit, nbits);
>  		blfp->blf_size++;
> @@ -356,45 +271,6 @@ xfs_buf_item_format_segment(
>  	} while (first_bit != -1);
>  
>  	return;
> -
> -slow_scan:
> -	ASSERT(bp->b_addr == NULL);
> -	last_bit = first_bit;
> -	nbits = 1;
> -	for (;;) {
> -		/*
> -		 * This takes the bit number to start looking from and
> -		 * returns the next set bit from there.  It returns -1
> -		 * if there are no more bits set or the start bit is
> -		 * beyond the end of the bitmap.
> -		 */
> -		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
> -					(uint)last_bit + 1);
> -		/*
> -		 * If we run out of bits fill in the last iovec and get out of
> -		 * the loop.  Else if we start a new set of bits then fill in
> -		 * the iovec for the series we were looking at and start
> -		 * counting the bits in the new one.  Else we're still in the
> -		 * same set of bits so just keep counting and scanning.
> -		 */
> -		if (next_bit == -1) {
> -			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> -						first_bit, nbits);
> -			blfp->blf_size++;
> -			break;
> -		} else if (next_bit != last_bit + 1 ||
> -		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
> -			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> -						first_bit, nbits);
> -			blfp->blf_size++;
> -			first_bit = next_bit;
> -			last_bit = next_bit;
> -			nbits = 1;
> -		} else {
> -			last_bit++;
> -			nbits++;
> -		}
> -	}
>  }
>  
>  /*
> -- 
> 2.43.0
> 
> 
