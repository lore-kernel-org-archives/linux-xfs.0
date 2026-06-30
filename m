Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251051A9F97
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 00:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782780744; cv=none; b=TfoUWMkwdOd0FK2W0Dahc0NstCqnKqA9Umk9N3vWUOQo86syyfFOOIZU8wFWbK4Anci53Ci991uLLLN+bl3exIVx7xyTuxQwvednoYSSCwKuF1Bas6pEnES+Iwc9bJaH0PXo6Ga+3MNa6NiCWtcMeOQdeeSsfCEjlMFjqxAMAls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782780744; c=relaxed/simple;
	bh=WQ8cslHJ89s7QZAP0C5phKlsAV5RrZTXx1+3av3o+Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVy8Kcf6Xb09A5lNF+uxcWu3K3IiUpKC++4lZ0YiNEuagQnaxzeiJD7Nel822nJy8ccVKNc8D6MakWKVNW7vK0BOdVKj/8n282hMZ0SQVAIcBstSZY4ff2zupPHNTTI12rdas+HYui/tTV3CjCCxQ6ZS8XM9A1NzMXc7hlXU56k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CsiMThzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CsiMThzY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AC0E21F000E9;
	Tue, 30 Jun 2026 00:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782780742;
	bh=1QtG2KOCMTdbE7ZBui2FlO7hR/l38knNWyHPibYTpHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CsiMThzYK6OJ2ZLatqEwk2lEorlzAzdNWAtlYZDgYHnIQQthqcH/tG2hKkjjD86zr
	 63aSo/BB3CiXFdSfu+v/s+5ZRVI2t/4EdaxMkEZF0vXNllp7Y4RZo9Q2S/OoAw2s4P
	 07k1X0Qr1l6DTMJynCLjBrX48DO3crVZiDx2FTfLqDLJ350ybA1va9Y2EYKhmA+GaT
	 ONQLUDS5PnvZQt5b58lPpW65q/9KXek5ySOSlT8TFRMaiDguXoSbOYuSKOfWHfyXRo
	 VOtvmXWWBWCj60FUQb6NTYzG3STl0JRnQZ83FRO+3KjajGTgvM61+yU/G9qBT6okaD
	 OinLRSDHS5seg==
Date: Mon, 29 Jun 2026 17:52:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: split up xfs_buf_alloc_backing_mem
Message-ID: <20260630005222.GG6078@frogsfrogsfrogs>
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

Ok, a simple hoist; so far so good

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 61 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 21 deletions(-)
> 
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
> 
