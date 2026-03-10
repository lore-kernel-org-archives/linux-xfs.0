Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF912BD11;
	Tue, 10 Mar 2026 00:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773103762; cv=none; b=LnvA1So+iCwLPFMU5ZAsADx1diBA1zdf4l5Y+hASKj9/hbiGEuA0RV1xmXre5pzHznjEKZ67I1/gZOiR5j3Ht3vhODy92dchWb7WjdWDNkV9EucOviKQPA0uT2YU9/M5UZcPPQKnQ/tW0THEcWGbXdS49qI/fZ5I/nBxlv/yBZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773103762; c=relaxed/simple;
	bh=lKqhCSJKZhdrvwjb4xNjYx38RXJz/jSpPgPv4ORSk7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIqwLi4K4/xzaSYG9gV8pmpqZnQip6Ff0gxCkJDsSD1zWa2XnLdA/ecQ+LWJmPp/9Xpy1a3qM0WuQv/FHPqc7uPSsPGddtv/+oUHkfD9JZi7jfkk7llWrtYP7l6JRgxu6Z8sxZ8d7s/7fiGzHuFq5oQnar8tdszh4bZ89gnG80k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmaAN+jM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmaAN+jM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA26AC4CEF7;
	Tue, 10 Mar 2026 00:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773103761;
	bh=lKqhCSJKZhdrvwjb4xNjYx38RXJz/jSpPgPv4ORSk7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mmaAN+jMq0rvEauF80/acXKQ/iAaAxF0160S2i+MvLYETEOJpd/kFtHUPhjqxZhPw
	 IK7G/40KXOkNL1sNkU/eVej+wKENlysw9Diem3lJ/pAbRKMlW+awA09S0VTrfvCoZm
	 b1EzEfGHXJ+IGDljWW/yPGNR/WTAkObHRqjstTkLCMHjYhys400nuDxwywlnOK+Xe0
	 7ldJVN9/5queUv0MvMJtRA8a32UeTkvfgQHNvGw+zKeY/SHL0Wu+vpNXxl+NCo0Yy1
	 CnMo6LAn1LQKslel3ql27bEggplYSSf7LJHUoKHw+WR2rvw4vssq6kzhRKT2OgmFX/
	 ZNUv0Eqbh/20g==
Date: Mon, 9 Mar 2026 17:49:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 06/25] fsverity: hoist pagecache_read from f2fs/ext4
 to fsverity
Message-ID: <20260310004921.GX6033@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-7-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-7-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:21PM +0100, Andrey Albershteyn wrote:
> This is the same function to read from pageache. XFS will also need
> this, so move this to core fsverity.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

This looks like a neat code reduction. :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/ext4/verity.c         | 32 +++-----------------------------
>  fs/f2fs/verity.c         | 30 +-----------------------------
>  fs/verity/pagecache.c    | 33 +++++++++++++++++++++++++++++++++
>  include/linux/fsverity.h |  2 ++
>  4 files changed, 39 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
> index 347945ac23a4..ac5c133f5529 100644
> --- a/fs/ext4/verity.c
> +++ b/fs/ext4/verity.c
> @@ -34,32 +34,6 @@ static inline loff_t ext4_verity_metadata_pos(const struct inode *inode)
>  	return round_up(inode->i_size, 65536);
>  }
>  
> -/*
> - * Read some verity metadata from the inode.  __vfs_read() can't be used because
> - * we need to read beyond i_size.
> - */
> -static int pagecache_read(struct inode *inode, void *buf, size_t count,
> -			  loff_t pos)
> -{
> -	while (count) {
> -		struct folio *folio;
> -		size_t n;
> -
> -		folio = read_mapping_folio(inode->i_mapping, pos >> PAGE_SHIFT,
> -					 NULL);
> -		if (IS_ERR(folio))
> -			return PTR_ERR(folio);
> -
> -		n = memcpy_from_file_folio(buf, folio, pos, count);
> -		folio_put(folio);
> -
> -		buf += n;
> -		pos += n;
> -		count -= n;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * Write some verity metadata to the inode for FS_IOC_ENABLE_VERITY.
>   * kernel_write() can't be used because the file descriptor is readonly.
> @@ -311,8 +285,8 @@ static int ext4_get_verity_descriptor_location(struct inode *inode,
>  		goto bad;
>  	desc_size_pos -= sizeof(desc_size_disk);
>  
> -	err = pagecache_read(inode, &desc_size_disk, sizeof(desc_size_disk),
> -			     desc_size_pos);
> +	err = fsverity_pagecache_read(inode, &desc_size_disk,
> +				      sizeof(desc_size_disk), desc_size_pos);
>  	if (err)
>  		return err;
>  	desc_size = le32_to_cpu(desc_size_disk);
> @@ -352,7 +326,7 @@ static int ext4_get_verity_descriptor(struct inode *inode, void *buf,
>  	if (buf_size) {
>  		if (desc_size > buf_size)
>  			return -ERANGE;
> -		err = pagecache_read(inode, buf, desc_size, desc_pos);
> +		err = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
>  		if (err)
>  			return err;
>  	}
> diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> index b3b3e71604ac..5ea0a9b40443 100644
> --- a/fs/f2fs/verity.c
> +++ b/fs/f2fs/verity.c
> @@ -36,34 +36,6 @@ static inline loff_t f2fs_verity_metadata_pos(const struct inode *inode)
>  	return round_up(inode->i_size, 65536);
>  }
>  
> -/*
> - * Read some verity metadata from the inode.  __vfs_read() can't be used because
> - * we need to read beyond i_size.
> - */
> -static int pagecache_read(struct inode *inode, void *buf, size_t count,
> -			  loff_t pos)
> -{
> -	while (count) {
> -		size_t n = min_t(size_t, count,
> -				 PAGE_SIZE - offset_in_page(pos));
> -		struct page *page;
> -
> -		page = read_mapping_page(inode->i_mapping, pos >> PAGE_SHIFT,
> -					 NULL);
> -		if (IS_ERR(page))
> -			return PTR_ERR(page);
> -
> -		memcpy_from_page(buf, page, offset_in_page(pos), n);
> -
> -		put_page(page);
> -
> -		buf += n;
> -		pos += n;
> -		count -= n;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * Write some verity metadata to the inode for FS_IOC_ENABLE_VERITY.
>   * kernel_write() can't be used because the file descriptor is readonly.
> @@ -248,7 +220,7 @@ static int f2fs_get_verity_descriptor(struct inode *inode, void *buf,
>  	if (buf_size) {
>  		if (size > buf_size)
>  			return -ERANGE;
> -		res = pagecache_read(inode, buf, size, pos);
> +		res = fsverity_pagecache_read(inode, buf, size, pos);
>  		if (res)
>  			return res;
>  	}
> diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
> index 1d94bf73f38c..ec65f60e657f 100644
> --- a/fs/verity/pagecache.c
> +++ b/fs/verity/pagecache.c
> @@ -78,3 +78,36 @@ void fsverity_folio_zero_hash(struct folio *folio, size_t poff, size_t plen,
>  				vi->tree_params.digest_size);
>  }
>  EXPORT_SYMBOL_GPL(fsverity_folio_zero_hash);
> +
> +/**
> + * fsverity_pagecache_read() - read page and copy data to buffer
> + * @inode:	copy from this inode's address space
> + * @buf:	buffer to copy to
> + * @count:	number of bytes to copy
> + * @pos:	position of the folio to copy from
> + *
> + * Read some verity metadata from the inode.  __vfs_read() can't be used because
> + * we need to read beyond i_size.
> + */
> +int fsverity_pagecache_read(struct inode *inode, void *buf, size_t count,
> +			  loff_t pos)
> +{
> +	while (count) {
> +		struct folio *folio;
> +		size_t n;
> +
> +		folio = read_mapping_folio(inode->i_mapping, pos >> PAGE_SHIFT,
> +					 NULL);
> +		if (IS_ERR(folio))
> +			return PTR_ERR(folio);
> +
> +		n = memcpy_from_file_folio(buf, folio, pos, count);
> +		folio_put(folio);
> +
> +		buf += n;
> +		pos += n;
> +		count -= n;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fsverity_pagecache_read);
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 1ca8de129323..53dc161e18c0 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -327,5 +327,7 @@ void generic_readahead_merkle_tree(struct inode *inode, pgoff_t index,
>  				   unsigned long nr_pages);
>  void fsverity_folio_zero_hash(struct folio *folio, size_t poff, size_t plen,
>  			      struct fsverity_info *vi);
> +int fsverity_pagecache_read(struct inode *inode, void *buf, size_t count,
> +			    loff_t pos);
>  
>  #endif	/* _LINUX_FSVERITY_H */
> -- 
> 2.51.2
> 
> 
