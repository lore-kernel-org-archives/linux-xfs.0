Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6F0200A5
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 00:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGGMmxyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0851EC433C8;
	Thu,  4 Jan 2024 00:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704326664;
	bh=nzTd/eHPThDk7kMu+BEjnfqbKdVEGlEHsJQ3k+kmID4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SGGMmxyWXoXuu1VDa1x4eDvhh7hQp0Ns2C50aT/NNUo4NQjjXaS1vsOow5adYfj2V
	 y8fYrjHEoQwlOgGFAQLPIwsv/bM9bKjrqYJ5lgP8ShqLln+cyQbFzLrp4PBKVXSxi8
	 qFMBHm8SbW7BFoHH1jtLgKVJ68/VrpcIHM7GNv5hcOWz9tFO+q1hbuYzkI+hqzC7Up
	 KSrZETpeHPd4mcBs79Jawej+3AiCYFTzJftyNXjWZW9HwZZVtnsZX7ZWJV/woOW0/F
	 L5IaSvBjGobg9X2XMsXGlvhR2misp1FGqNFaw2MusRdV5ehgkXxLStZ943sEUeIZDZ
	 bC5tW8NGJ60cQ==
Date: Wed, 3 Jan 2024 16:04:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/15] xfs: remove xfarray_sortinfo.page_kaddr
Message-ID: <20240104000423.GD361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-11-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:21AM +0000, Christoph Hellwig wrote:
> Now that xfile pages don't need kmapping, there is no need to cache
> the kernel virtual address for them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/xfarray.c | 22 ++++------------------
>  fs/xfs/scrub/xfarray.h |  1 -
>  2 files changed, 4 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index 3a44700037924b..c29a240d4e25f4 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -570,18 +570,7 @@ xfarray_sort_get_page(
>  	loff_t			pos,
>  	uint64_t		len)
>  {
> -	int			error;
> -
> -	error = xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * xfile pages must never be mapped into userspace, so we skip the
> -	 * dcache flush when mapping the page.
> -	 */
> -	si->page_kaddr = page_address(si->xfpage.page);
> -	return 0;
> +	return xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
>  }
>  
>  /* Release a page we grabbed for sorting records. */
> @@ -589,11 +578,8 @@ static inline int
>  xfarray_sort_put_page(
>  	struct xfarray_sortinfo	*si)
>  {
> -	if (!si->page_kaddr)
> +	if (!xfile_page_cached(&si->xfpage))
>  		return 0;
> -
> -	si->page_kaddr = NULL;
> -
>  	return xfile_put_page(si->array->xfile, &si->xfpage);
>  }
>  
> @@ -636,7 +622,7 @@ xfarray_pagesort(
>  		return error;
>  
>  	xfarray_sort_bump_heapsorts(si);
> -	startp = si->page_kaddr + offset_in_page(lo_pos);
> +	startp = page_address(si->xfpage.page) + offset_in_page(lo_pos);
>  	sort(startp, hi - lo + 1, si->array->obj_size, si->cmp_fn, NULL);
>  
>  	xfarray_sort_bump_stores(si);
> @@ -883,7 +869,7 @@ xfarray_sort_load_cached(
>  			return error;
>  	}
>  
> -	memcpy(ptr, si->page_kaddr + offset_in_page(idx_pos),
> +	memcpy(ptr, page_address(si->xfpage.page) + offset_in_page(idx_pos),
>  			si->array->obj_size);
>  	return 0;
>  }
> diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
> index 62b9c506fdd1b7..6f2862054e194d 100644
> --- a/fs/xfs/scrub/xfarray.h
> +++ b/fs/xfs/scrub/xfarray.h
> @@ -107,7 +107,6 @@ struct xfarray_sortinfo {
>  
>  	/* Cache a page here for faster access. */
>  	struct xfile_page	xfpage;
> -	void			*page_kaddr;
>  
>  #ifdef DEBUG
>  	/* Performance statistics. */
> -- 
> 2.39.2
> 
> 
