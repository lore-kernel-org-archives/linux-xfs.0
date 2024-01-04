Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50187366
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 00:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfZEe2HS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A7CC433C9;
	Thu,  4 Jan 2024 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704327665;
	bh=6L1/GxZRr5i5NZtIy00q/HS8HPj+3JD6Nq2ciV6p14M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XfZEe2HSmiBbJ9/88Rr5bstB0Bx4g4YcOhDLic56LFMBL/nX9YbyInKzEl/iB4rU6
	 ptuuryMwms8m1vcCKecYhMaWe/f90s30EZLta0iasHn+MC2k80jrV6M2ArNakF4Yqn
	 I21EAzybs60GkS0U5+5Hz9R6S+OOX+exvkGUynITRzSNgZzOWAGcB6ZzPl+j9jolAs
	 boL8JAzdEi2o0HR4Dhzia51f9lI8D7hZWZoUhOy853l9TxKPIZdvD1GXd+MNDLcdkf
	 TXZxQJgm1M8/SyIG7I229NSZJjOPJHXETuIFjWg7aL9F6J3I9U93qNvx6jY02ke5sD
	 GiSh2H+DGCjiA==
Date: Wed, 3 Jan 2024 16:21:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 15/15] xfs: use xfile_get_page and xfile_put_page in
 xfile_obj_load
Message-ID: <20240104002105.GI361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-16-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:26AM +0000, Christoph Hellwig wrote:
> Switch xfile_obj_load to use xfile_get_page and xfile_put_page to access
> the shmem page cache.  The former uses shmem_get_folio(..., SGP_READ),
> which returns a NULL folio for a hole instead of allocating one to
> optimize the case where the caller is reading from a whole and doesn't
> want to a zeroed folio to the page cache.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/xfile.c | 51 +++++++++++---------------------------------
>  1 file changed, 12 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 987b03df241b02..3f9e416376d2f7 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -34,13 +34,6 @@
>   * xfiles assume that the caller will handle all required concurrency
>   * management; standard vfs locks (freezer and inode) are not taken.  Reads
>   * and writes are satisfied directly from the page cache.
> - *
> - * NOTE: The current shmemfs implementation has a quirk that in-kernel reads
> - * of a hole cause a page to be mapped into the file.  If you are going to
> - * create a sparse xfile, please be careful about reading from uninitialized
> - * parts of the file.  These pages are !Uptodate and will eventually be
> - * reclaimed if not written, but in the short term this boosts memory
> - * consumption.

Awright, this goes away finally!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>   */
>  
>  /*
> @@ -117,58 +110,38 @@ xfile_obj_load(
>  	size_t			count,
>  	loff_t			pos)
>  {
> -	struct inode		*inode = file_inode(xf->file);
> -	struct address_space	*mapping = inode->i_mapping;
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
>  	trace_xfile_obj_load(xf, pos, count);
>  
> -	pflags = memalloc_nofs_save();
>  	while (count > 0) {
> +		struct page	*page;
>  		unsigned int	len;
>  
>  		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
> -
> -		/*
> -		 * In-kernel reads of a shmem file cause it to allocate a page
> -		 * if the mapping shows a hole.  Therefore, if we hit ENOMEM
> -		 * we can continue by zeroing the caller's buffer.
> -		 */
> -		page = shmem_read_mapping_page_gfp(mapping, pos >> PAGE_SHIFT,
> -				__GFP_NOWARN);
> -		if (IS_ERR(page)) {
> -			error = PTR_ERR(page);
> -			if (error != -ENOMEM) {
> -				error = -ENOMEM;
> -				break;
> -			}
> -
> +		page = xfile_get_page(xf, pos, len, 0);
> +		if (IS_ERR(page))
> +			return -ENOMEM;
> +		if (!page) {
> +			/*
> +			 * No data stored at this offset, just zero the output
> +			 * buffer.
> +			 */
>  			memset(buf, 0, len);
>  			goto advance;
>  		}
> -
> -		/*
> -		 * xfile pages must never be mapped into userspace, so
> -		 * we skip the dcache flush.
> -		 */
>  		memcpy(buf, page_address(page) + offset_in_page(pos), len);
> -		put_page(page);
> -
> +		xfile_put_page(xf, page);
>  advance:
>  		count -= len;
>  		pos += len;
>  		buf += len;
>  	}
> -	memalloc_nofs_restore(pflags);
>  
> -	return error;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.39.2
> 
> 
