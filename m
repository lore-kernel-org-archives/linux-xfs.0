Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A33C280A20
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782784177; cv=none; b=mh62nJ2FhsgEWLzWtiGI87GCHA0KY3KOHz97uLAqT0XD0fC8wxWr1RDBzCotYbgVuCiiBeNx0EvmtFAG/wVbSfHQ6iW4cSKo8hGmAgrJsqFvmzV0YzbiH8qC96AiConMjBZQ6FMeqhh3YgIm3Lk5wWh8BXUmwbRyCzDmI2/WK+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782784177; c=relaxed/simple;
	bh=iUjzjdmAYRf9VtkSrR9ofF7J6OZipVIKYCoG2sLFjhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jA3SiiOiVC5ongQSRW+2YlL9tfmyuuJAUGzs+Vr5COa6MXuOTYI5ygzmOCxZQWJLGFZKA98YSbPuO9AxsQDzSce1sDwCbUxpTeIDFgdIbRJIrHLI7yzgdBtfVevHAPB6gDOUoOJRFN548oJXnZ0D9z8jbu9+q/LuwGa1oVSt87c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBatHr+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBatHr+q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E05941F000E9;
	Tue, 30 Jun 2026 01:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782784176;
	bh=ffNbxmCgnQ+4EdXjIlr7STRN7X7l8kLOWHhdCKHdWNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fBatHr+q28nJ1wxAnzM4YOlMvFk7+YY5+QrNn6HWLqmxnX3Y8kJYxxureNHgj6fcW
	 Rc636M4rWyoipxzacZKDcGJ4AoPXhzOId0cv1I5Hat7557/qZSKRKlXpHdJmGnF/ge
	 CBvdRcxdXyFQUegVCjRVZ8NNwnobTefa4QtK8DHhBXDTwCp0YB9D8cRAmz8WtndrbQ
	 UFZo5+OBMVw3nVtRXMW2EgInVmAi4cS8AQHCAtX91yg4KyPU6ZIJv76QlYk/L9EBwf
	 aRd/pEPtLEsrf9t1cC3iYgpvoUUObusbZDw7UF9Qwop6cu9QKBR/NeciAk51hma6TN
	 2keoM8TAJrqhA==
Date: Mon, 29 Jun 2026 18:49:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: fix incorrect use of gfp flags in
 xfs_buf_alloc_backing_mem
Message-ID: <20260630014935.GI6078@frogsfrogsfrogs>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617055814.3842058-4-hch@lst.de>

On Wed, Jun 17, 2026 at 07:58:04AM +0200, Christoph Hellwig wrote:
> xfs_buf_alloc_backing_mem currently has two issues with how the GFP_
> flags are set:
> 
>   - when aiming for a large folio allocation, the gfp mask is adjusted
>     to try less hard, but these flags then persist for the vmalloc
>     allocation, which is bogus.
>   - the __GFP_NOFAIL for small allocations is also applied when readahead
>     force __GFP_NORETRY which doesn't make any sense.
> 
> Fix this by only applying __GFP_NOFAIL when __GFP_NORETRY is not set,
> and by reordering the code so that the large folio gfp adjustments
> are performed locally just for that allocation.
> 
> Fixes: 94c78cfa3bd1 ("xfs: convert buffer cache to use high order folios")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 49 +++++++++++++++++++++++-------------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index dce398337ad0..eea2a8757fe1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -223,22 +223,6 @@ xfs_buf_alloc_backing_mem(
>  	if (flags & XBF_READ_AHEAD)
>  		gfp_mask |= __GFP_NORETRY;
>  
> -	/*
> -	 * For buffers smaller than PAGE_SIZE use a kmalloc allocation if that
> -	 * is properly aligned.  The slab allocator now guarantees an aligned
> -	 * allocation for all power of two sizes, which matches most of the
> -	 * smaller than PAGE_SIZE buffers used by XFS.
> -	 */
> -	if (size < PAGE_SIZE && is_power_of_2(size))
> -		return xfs_buf_alloc_kmem(bp, size, gfp_mask | __GFP_NOFAIL);
> -
> -	/*
> -	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
> -	 * won't do any better.
> -	 */
> -	if (size <= PAGE_SIZE)
> -		gfp_mask |= __GFP_NOFAIL;
> -
>  	/*
>  	 * Optimistically attempt a single high order folio allocation for
>  	 * larger than PAGE_SIZE buffers.
> @@ -251,18 +235,31 @@ xfs_buf_alloc_backing_mem(
>  	 * path for them instead of wasting memory here.
>  	 */
>  	if (size > PAGE_SIZE) {
> -		if (!is_power_of_2(size))
> -			return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
> -		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
> -		gfp_mask |= __GFP_NORETRY;
> -	}
> -	if (xfs_buf_alloc_folio(bp, size, gfp_mask) < 0) {
> -		if (size <= PAGE_SIZE)
> -			return -ENOMEM;
> -		trace_xfs_buf_backing_fallback(bp, _RET_IP_);
> +		if (is_power_of_2(size)) {
> +			gfp_t folio_gfp = gfp_mask;
> +
> +			folio_gfp &= ~__GFP_DIRECT_RECLAIM;
> +			folio_gfp |= __GFP_NORETRY;
> +			if (xfs_buf_alloc_folio(bp, size, folio_gfp) == 0)
> +				return 0;
> +			trace_xfs_buf_backing_fallback(bp, _RET_IP_);
> +		}
>  		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
>  	}
> -	return 0;
> +
> +	/*
> +	 * The slab allocator now guarantees aligned allocations for all power
> +	 * of two sizes.  This covers most smaller XFS buffers, so just use
> +	 * kmalloc in this case.
> +	 *
> +	 * Don't bother with the vmalloc fallback for allocations of page size
> +	 * or less: vmalloc won't do any better.
> +	 */
> +	if (!(gfp_mask & __GFP_NORETRY))
> +		gfp_mask |= __GFP_NOFAIL;
> +	if (size < PAGE_SIZE && is_power_of_2(size))
> +		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
> +	return xfs_buf_alloc_folio(bp, size, gfp_mask);

Hrmm, ok.  So first we special-case buffers > PAGE_SIZE -- if they're a
power of two, we try (not very hard) to allocate a single large folio.
If that fails or it's not a power-of-two, then we just do vmalloc, which
allows direct reclaim and retries.

For smaller than PAGE_SIZE buffers that are powers of two, I guess we
use the slab allocator, otherwise a full folio.  That part strikes me as
a little strange (efficiency, I guess?), but that's what the code did
before so I guess it's ok.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  }
>  
>  static int
> -- 
> 2.53.0
> 
> 
