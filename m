Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B590521C9E9
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589356; cv=none; b=mGf8LwpQRjt4DTUuTnDx/b7G4sZx/sIZHrEIxK82icWxCohPV327gIGM0j7JdTB+o2xfBPJsVHTWYTYAJaw3OuuOy7BV0kAH8lzsToqGgLCKuRVDaNT6YG0ZHLYYVUXBG3yvSKgxvvg7s58mNKPXm+6wvpxs7ZKQyCLUzVH+9/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589356; c=relaxed/simple;
	bh=DWsN9sWo++3GrfzR6OZVqIV+Tdj9abvwLRVTZ7srfXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzKOOHF2e5tot6pZltcvL+XmQD2GO+zBs6efWFE5uPzwTpiCy4V3L5qfwMTzlfwcTe+Zg187Wcftysu4hDRwBbHrnq5LP/EczDEd6C19EVOZIsWxcIDhLNeH4FnmnXvIeiurONUYUgh1MSB4BJ6JRGiSY9y7DHbAsO1HH8iLblM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtX0rBEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtX0rBEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311AAC4CED6;
	Wed, 26 Feb 2025 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740589356;
	bh=DWsN9sWo++3GrfzR6OZVqIV+Tdj9abvwLRVTZ7srfXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XtX0rBEEwdz4F1jJdnpOdsX+XQtEv7Lq2c9D0qEhw7Rw1OXJQkfmY/gBDq0zUZxG2
	 0cvSU10bNvNhMJPv2xkkXo7ueZ6amC8uUDeXPfSkdo0BiOytp0oTEOs2qoyP2Zfwpr
	 ac7cbGq/eMQU9JosuUlEvtqSYsXYv91msXyjU4HLlR9+g+yWjAaNnv40NuSWp/js4H
	 b+Egrq8/GgqjhM2jDYLxcB6FqY2IiQKw7S1PSfcCPn1fagRJkdYmdFCbTvsyNyoMzc
	 1qKMZd5Dzm1ibNa3Rj01rNoZlsWFBwW8YwG8azSDc8q3JyZzVNMF9aspLkf/i1Wkce
	 l7q2F2Bl4ozgA==
Date: Wed, 26 Feb 2025 09:02:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: remove xfs_buf_is_vmapped
Message-ID: <20250226170235.GO6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-5-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:32AM -0800, Christoph Hellwig wrote:
> No need to look at the page count if we can simply call is_vmalloc_addr
> on bp->b_addr.  This prepares for eventualy removing the b_page_count
> field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that's more direct.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ee678e13d9bd..af1389ebdd69 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -60,20 +60,6 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
>  	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
>  }
>  
> -static inline int
> -xfs_buf_is_vmapped(
> -	struct xfs_buf	*bp)
> -{
> -	/*
> -	 * Return true if the buffer is vmapped.
> -	 *
> -	 * b_addr is null if the buffer is not mapped, but the code is clever
> -	 * enough to know it doesn't have to map a single page, so the check has
> -	 * to be both for b_addr and bp->b_page_count > 1.
> -	 */
> -	return bp->b_addr && bp->b_page_count > 1;
> -}
> -
>  static inline int
>  xfs_buf_vmap_len(
>  	struct xfs_buf	*bp)
> @@ -270,7 +256,7 @@ xfs_buf_free_pages(
>  
>  	ASSERT(bp->b_flags & _XBF_PAGES);
>  
> -	if (xfs_buf_is_vmapped(bp))
> +	if (is_vmalloc_addr(bp->b_addr))
>  		vm_unmap_ram(bp->b_addr, bp->b_page_count);
>  
>  	for (i = 0; i < bp->b_page_count; i++) {
> @@ -1361,7 +1347,7 @@ xfs_buf_ioend(
>  	trace_xfs_buf_iodone(bp, _RET_IP_);
>  
>  	if (bp->b_flags & XBF_READ) {
> -		if (!bp->b_error && xfs_buf_is_vmapped(bp))
> +		if (!bp->b_error && bp->b_addr && is_vmalloc_addr(bp->b_addr))
>  			invalidate_kernel_vmap_range(bp->b_addr,
>  					xfs_buf_vmap_len(bp));
>  		if (!bp->b_error && bp->b_ops)
> @@ -1533,7 +1519,7 @@ xfs_buf_submit_bio(
>  			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
>  		bio->bi_iter.bi_size = size; /* limit to the actual size used */
>  
> -		if (xfs_buf_is_vmapped(bp))
> +		if (bp->b_addr && is_vmalloc_addr(bp->b_addr))
>  			flush_kernel_vmap_range(bp->b_addr,
>  					xfs_buf_vmap_len(bp));
>  	}
> -- 
> 2.45.2
> 
> 
