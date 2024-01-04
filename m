Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F08A4400
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 00:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZE07rd22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAF5C433C8;
	Thu,  4 Jan 2024 00:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704327624;
	bh=pEgOItruu30RUfKNsh5vfgUOuP+fmt6+FLYwopw18u8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZE07rd22woPVAj7VMF+LZQe9KAFFr2As/kdHka8LkIMBISspIPtvmgacvu5DuE46L
	 9Qn5LtJlCwvGacm5+tJefpxUiB7NvLXI2NqtuPC0QZIz6C3FJFtJyt9aI25B6+Cxnx
	 c8Mimw56MrN2iFJpNC496KRUyy5zpgXMNKtSFiWKDoI03mycIfUvbIFPiZoZi/MYZL
	 VbG9D6TEIcoupg32gpumP2NYRflDP8jcF1UTmgwmBYfgifY7s2ICLMobQTmJ/hi3qR
	 gazmYLGuqXrD3/9CB52Rma6Hpvlt3ZYKctduUeB56YvUQNmrXy21FkmecM4l0Gx0Vt
	 Dzw18JiolGxsA==
Date: Wed, 3 Jan 2024 16:20:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/15] xfs: use xfile_get_page and xfile_put_page in
 xfile_obj_store
Message-ID: <20240104002024.GH361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-15-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:25AM +0000, Christoph Hellwig wrote:
> Rewrite xfile_obj_store to use xfile_get_page and xfile_put_page to
> access the data in the shmem page cache instead of abusing the
> shmem write_begin and write_end aops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much simpler, though I wonder if willy is going to have something to say
about xfile.c continuing to pass pages around instead of folios.  I
/think/ that's ok since we actually need the physical base page for
doing IO, right?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/xfile.c | 66 ++++++++------------------------------------
>  1 file changed, 11 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 3ed7fb82a4497b..987b03df241b02 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -182,74 +182,30 @@ xfile_obj_store(
>  	size_t			count,
>  	loff_t			pos)
>  {
> -	struct inode		*inode = file_inode(xf->file);
> -	struct address_space	*mapping = inode->i_mapping;
> -	const struct address_space_operations *aops = mapping->a_ops;
> -	struct page		*page = NULL;
> -	unsigned int		pflags;
> -	int			error = 0;
> -
>  	if (count > MAX_RW_COUNT)
>  		return -ENOMEM;
> -	if (inode->i_sb->s_maxbytes - pos < count)
> +	if (file_inode(xf->file)->i_sb->s_maxbytes - pos < count)
>  		return -ENOMEM;
>  
>  	trace_xfile_obj_store(xf, pos, count);
>  
> -	pflags = memalloc_nofs_save();
>  	while (count > 0) {
> -		void		*fsdata = NULL;
> -		void		*p, *kaddr;
> +		struct page	*page;
>  		unsigned int	len;
> -		int		ret;
>  
>  		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
> +		page = xfile_get_page(xf, pos, len, XFILE_ALLOC);
> +		if (IS_ERR(page))
> +			return -ENOMEM;
> +		memcpy(page_address(page) + offset_in_page(pos), buf, len);
> +		xfile_put_page(xf, page);
>  
> -		/*
> -		 * We call write_begin directly here to avoid all the freezer
> -		 * protection lock-taking that happens in the normal path.
> -		 * shmem doesn't support fs freeze, but lockdep doesn't know
> -		 * that and will trip over that.
> -		 */
> -		error = aops->write_begin(NULL, mapping, pos, len, &page,
> -				&fsdata);
> -		if (error) {
> -			error = -ENOMEM;
> -			break;
> -		}
> -
> -		/*
> -		 * xfile pages must never be mapped into userspace, so we skip
> -		 * the dcache flush.  If the page is not uptodate, zero it
> -		 * before writing data.
> -		 */
> -		kaddr = page_address(page);
> -		if (!PageUptodate(page)) {
> -			memset(kaddr, 0, PAGE_SIZE);
> -			SetPageUptodate(page);
> -		}
> -		p = kaddr + offset_in_page(pos);
> -		memcpy(p, buf, len);
> -
> -		ret = aops->write_end(NULL, mapping, pos, len, len, page,
> -				fsdata);
> -		if (ret < 0) {
> -			error = -ENOMEM;
> -			break;
> -		}
> -
> -		if (ret != len) {
> -			error = -ENOMEM;
> -			break;
> -		}
> -
> -		count -= ret;
> -		pos += ret;
> -		buf += ret;
> +		count -= len;
> +		pos += len;
> +		buf += len;
>  	}
> -	memalloc_nofs_restore(pflags);
>  
> -	return error;
> +	return 0;
>  }
>  
>  /* Find the next written area in the xfile data for a given offset. */
> -- 
> 2.39.2
> 
> 
