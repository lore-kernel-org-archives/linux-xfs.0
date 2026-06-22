Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7440D567
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782130630; cv=none; b=DRTaN2diFv4oD1jperjAawJQZQ0/PBS7AI78eJBaq7KBH3wN4WALBLgQazUjItoImaiC6nIV8lZ8F7k2AJvatsVk/d4jmjTAktSb1/w5zBmiPAc1/4V98nPZNW/XKpFjJPmV7UfFxsA9P4FRODYZj4VfYeRp5e3Hx2ouyYd7uT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782130630; c=relaxed/simple;
	bh=WJ4+wJQlAkfVzuQ+9cpSBRbJEypugF++ekKtPcbRGko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHH9pZgSE+NyZqzOvIADsC64b3mgVndS6kwzBjNYMsKM7alI4/rSPnSsxdGq4SeNuhDNfDqrgpVoTmZw/bGDnDRZAZB28N3zDRrJ4joO1iTUXKhq8JV7SD6vKDVuf1iTlUSA1vrcUpg3xzmp6xnc2n3YOkdOeOqPeosMXLfHJg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUgBsiI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUgBsiI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F9F1F000E9;
	Mon, 22 Jun 2026 12:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782130628;
	bh=AG5jUS7us8aonCd78GS/QTz4owq0Z6AZCJl5SF+d62U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oUgBsiI7N7l2YVFCBgwhrK/XsBN5dRCtnpUs1/PPaEpuHh85mPQexaR09i3KQDLFy
	 3rT6M7PLQGmeUJzGA75Z2j8VL6qim02B3JAV7H4EB/0vT928GCON7bTPCBpPvyJL3E
	 3l5Rq2iMoWjk/usuN8LuWfsSwb3EMzK2sms750uRfpPIVLocKX9mmScM/CqYks0OMN
	 Emi988juGzT9Oy66hxxr/aauSsHHJAL769TTxbcN5MBrkRvzxTChff8z2hE8NdKlJi
	 iG8EF+EcrJQdKRqQo1/bfF8eTG8ed3qSU//MEbehNTbx6KPKsz03FPo3pm1erev2/B
	 BDLssLUmEvRxg==
Date: Mon, 22 Jun 2026 14:17:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: split up xfs_buf_alloc_backing_mem
Message-ID: <ajknuzEqH6gNYA5b@nidhogg.toxiclabs.cc>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617055814.3842058-2-hch@lst.de>

On Wed, Jun 17, 2026 at 07:58:02AM +0200, Christoph Hellwig wrote:
> Split out helpers for folio and vmalloc allocations to prepare for a bug
> fix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 61 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 21 deletions(-)
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 0cea458f1353..d3d44e3ff001 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -120,6 +120,22 @@ xfs_buf_free(
>  	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
>  }
>  
> +static int
> +xfs_buf_alloc_folio(
> +	struct xfs_buf		*bp,
> +	size_t			size,
> +	gfp_t			gfp_mask)
> +{
> +	struct folio		*folio;
> +
> +	folio = folio_alloc(gfp_mask, get_order(size));
> +	if (!folio)
> +		return -ENOMEM;
> +	bp->b_addr = folio_address(folio);
> +	trace_xfs_buf_backing_folio(bp, _RET_IP_);
> +	return 0;
> +}
> +
>  static int
>  xfs_buf_alloc_kmem(
>  	struct xfs_buf		*bp,
> @@ -148,6 +164,27 @@ xfs_buf_alloc_kmem(
>  	return 0;
>  }
>  
> +static int
> +xfs_buf_alloc_vmalloc(
> +	struct xfs_buf		*bp,
> +	size_t			size,
> +	gfp_t			gfp_mask,
> +	xfs_buf_flags_t		flags)
> +{
> +	for (;;) {
> +		bp->b_addr = __vmalloc(size, gfp_mask);
> +		if (bp->b_addr)
> +			break;
> +		if (flags & XBF_READ_AHEAD)
> +			return -ENOMEM;
> +		XFS_STATS_INC(bp->b_mount, xb_page_retries);
> +		memalloc_retry_wait(gfp_mask);
> +	}
> +
> +	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
> +	return 0;
> +}
> +
>  /*
>   * Allocate backing memory for a buffer.
>   *
> @@ -175,7 +212,6 @@ xfs_buf_alloc_backing_mem(
>  {
>  	size_t		size = BBTOB(bp->b_length);
>  	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
> -	struct folio	*folio;
>  
>  	if (xfs_buftarg_is_mem(bp->b_target))
>  		return xmbuf_map_backing_mem(bp);
> @@ -216,33 +252,16 @@ xfs_buf_alloc_backing_mem(
>  	 */
>  	if (size > PAGE_SIZE) {
>  		if (!is_power_of_2(size))
> -			goto fallback;
> +			return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
>  		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
>  		gfp_mask |= __GFP_NORETRY;
>  	}
> -	folio = folio_alloc(gfp_mask, get_order(size));
> -	if (!folio) {
> +	if (xfs_buf_alloc_folio(bp, size, gfp_mask) < 0) {
>  		if (size <= PAGE_SIZE)
>  			return -ENOMEM;
>  		trace_xfs_buf_backing_fallback(bp, _RET_IP_);
> -		goto fallback;
> -	}
> -	bp->b_addr = folio_address(folio);
> -	trace_xfs_buf_backing_folio(bp, _RET_IP_);
> -	return 0;
> -
> -fallback:
> -	for (;;) {
> -		bp->b_addr = __vmalloc(size, gfp_mask);
> -		if (bp->b_addr)
> -			break;
> -		if (flags & XBF_READ_AHEAD)
> -			return -ENOMEM;
> -		XFS_STATS_INC(bp->b_mount, xb_page_retries);
> -		memalloc_retry_wait(gfp_mask);
> +		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
>  	}
> -
> -	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 
