Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCBF222592
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589201; cv=none; b=pbAJMIfXR0CBQhoQOzk9IjAlX0SgizwynCHM9G6Nu/8iQBdObD/+gaFDCyN4xsLIPLJ2xlMvxyiIouskMiJyOJ1ETc1XxTP+zftWW4U+YctpDhkgZuwI6jTyci/xR3Qsr9J6g+z6Bu5tws0aWW6D5/5DmwOVQ5DyUm7nIKcl0dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589201; c=relaxed/simple;
	bh=trIEL+zgCm8CqDraZqRe8QcfXKurHnZJJq+wOufsgR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfjKz/BTIgYfJIXmD1ZsAj0jhkVgDRj/+1xf5/VIl4+1XscHEr239EAxX22q1KdohFkdeKaj/+GyHFWeD3aNxTI3Aakg7u8EU95assUE49CkQ0jp7yNfS912KzV0n7P7vHo8+FOq/oCJqbqPpi8rXxlNE4cFKlukvS4NC9FUE58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTb0dlc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTb0dlc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F7AC4CED6;
	Wed, 26 Feb 2025 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740589201;
	bh=trIEL+zgCm8CqDraZqRe8QcfXKurHnZJJq+wOufsgR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MTb0dlc6w4XIM9j79pOs6c0q9PioTgDpl54scViSkvf1rD3dyQuySyDMGO4O59sqK
	 jeobef+1B2qXNFvNsYn40LMJwi4n68EhDMmRTOd6aZWpUlhtfJSyyG2bTrzDwcdGLk
	 wUdThY8IyTfolZ0oEjt6Bqw+XLjXLRF7a4SZPWldgdjeFYN/1sLDv5kacwuWR8TiLY
	 OelzEMrJ1mFELtVw6u/zdJNeKzMEy3K6QhW9mAeyO1xMylvxOEw7t+qrTVPirS2tW6
	 DfMdrr4anodXeU9cJjmVIksp2Y2bmNQQpmLSf9mMtK1gw4D3g40Q8GfYZvyKTckanz
	 CHlLUNv16oAvg==
Date: Wed, 26 Feb 2025 09:00:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: add a fast path to xfs_buf_zero when b_addr
 is set
Message-ID: <20250226170001.GM6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-3-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:30AM -0800, Christoph Hellwig wrote:
> No need to walk the page list if bp->b_addr is valid.  That also means
> b_offset doesn't need to be taken into account in the unmapped loop as
> b_offset is only set for kmem backed buffers which are always mapped.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That's much clearer!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15bb790359f8..9e0c64511936 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1688,13 +1688,18 @@ xfs_buf_zero(
>  {
>  	size_t			bend;
>  
> +	if (bp->b_addr) {
> +		memset(bp->b_addr + boff, 0, bsize);
> +		return;
> +	}
> +
>  	bend = boff + bsize;
>  	while (boff < bend) {
>  		struct page	*page;
>  		int		page_index, page_offset, csize;
>  
> -		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
> -		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
> +		page_index = boff >> PAGE_SHIFT;
> +		page_offset = boff & ~PAGE_MASK;
>  		page = bp->b_pages[page_index];
>  		csize = min_t(size_t, PAGE_SIZE - page_offset,
>  				      BBTOB(bp->b_length) - boff);
> -- 
> 2.45.2
> 
> 
