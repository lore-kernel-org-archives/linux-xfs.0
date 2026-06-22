Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5229F3A380E
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782131485; cv=none; b=BCox3bdzBzgBxDYp64d0JJsNOdbxhhN0vhOYvAxp2hLVQTlqrbqhk5sj+xtKU3KVmfSBp3cpJlcnuM9VblaBdnVSbmQIngHgSbvb99jGJzwdujaEeQ4tA0ls71xSQzxV6pXAhqeLIRt9stA8b7C6fuJWrpuwAU+xUO0pPbMEvYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782131485; c=relaxed/simple;
	bh=J3Gq1itPZZJPWJwLNDe3wSKis2F9/57M25JWCxlxduw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NC3E1+abJBq2YqP5+HQivT1xWSPt8teKW/GwPXzPL7XetRmB+MMO1YKuygzDzgg3bvnBkwZ1sitZPOkk/FDLNT0MDTyxV5rKbcbaAjA9Qk9yfozZvR+k9XV2wgd3wBMoPuEk33OYpvUYPax+uCMKA1tyBDqqEIGbTHG82S5xlw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1iJtXuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1iJtXuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1AE1F000E9;
	Mon, 22 Jun 2026 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782131483;
	bh=aOCI3oo2Y5zQEGGoi5aPBxm7XPaOZdRvwcUy70vc1Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W1iJtXuCCDVAGYBvKRLx5+48zeNfWzeV/JhFp6s+UHkWv4o4LZ1jkRduXHzbRiVD2
	 u7xM/whF6b9Mm7mlJSuHlgCa9p8YbB0rQ6V+3TRTT34uRxXmLp4kGqnKFainiUsocf
	 shNQzQD7EVmZ6zd5JmEs1xO8UeR0Anj/PyrZUI0OSFWa4vBMb4lEMbZ9lLZ1RvKRuf
	 Sy6pM0uHFp0EoJSqmZi9iCO918uFc6VFLdgv0DSVvjQ30R1brDlcaj0sxhHi0QfS5B
	 3+nvt3DB2smKuCh+YyrSQsEtpiNiZqVt2HHGFDUHFS4kxMaswV4GPVeG37r0WEsKvD
	 ST/ZmJb3ax5jQ==
Date: Mon, 22 Jun 2026 14:31:16 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: fix incorrect use of gfp flags in
 xfs_buf_alloc_backing_mem
Message-ID: <ajko9ab_ILwGMtmR@nidhogg.toxiclabs.cc>
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

Ok, this addresses my concern on the previous patch. Ignore that.

This one looks good to.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
>  }
>  
>  static int
> -- 
> 2.53.0
> 
> 
