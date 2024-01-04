Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565B336B
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 00:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UztC+bEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C78FC433C8;
	Thu,  4 Jan 2024 00:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704327536;
	bh=T5mvxqVxG0/Fh+i329OnR6A1dG2fuRhpvMkzMGMxwZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UztC+bEo2HFk5a6wyw5IuTma2KX1B8fCBjF/J5vAnzARfrNN9gTWGvDXxxTBgDp+g
	 s9og//g863OwX+3RXuPz4AT/TMK75OyJV13u0yZXoSGG+c2M2nAMJUfnbPmQQJDurA
	 JDJVYvCzdlrVoX3y160EPuOXrKYwOMIOonDaPIFoVgch95OidB/lWLaXgAp25EFpCw
	 SzIlmW8TJzOv/ihe7ghQK4cEOqFPSDKNrUnBfn/A0fusiza2PsSkqE4caNwi20blp5
	 q3XV9X+4FGQm/QPV97co0GKoMt8U4UGUr/n0jUZHvq/LNhgliBvOgQhsqCq3CkDnm2
	 mZfAefA917RyA==
Date: Wed, 3 Jan 2024 16:18:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 13/15] xfs: don't unconditionally allocate a new page in
 xfile_get_page
Message-ID: <20240104001856.GG361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-14-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:24AM +0000, Christoph Hellwig wrote:
> Pass a flags argument to xfile_get_page, and only allocate a new page
> if the XFILE_ALLOC flag is passed.  This allows to also use
> xfile_get_page for pure readers that do not want to allocate a new
> page or dirty the existing one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks correct to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/xfarray.c |  2 +-
>  fs/xfs/scrub/xfile.c   | 14 ++++++++++----
>  fs/xfs/scrub/xfile.h   |  4 +++-
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index 4f396462186793..8543067d46366d 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -572,7 +572,7 @@ xfarray_sort_get_page(
>  {
>  	struct page		*page;
>  
> -	page = xfile_get_page(si->array->xfile, pos, len);
> +	page = xfile_get_page(si->array->xfile, pos, len, XFILE_ALLOC);
>  	if (IS_ERR(page))
>  		return PTR_ERR(page);
>  	si->page = page;
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 715c4d10b67c14..3ed7fb82a4497b 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -274,7 +274,8 @@ struct page *
>  xfile_get_page(
>  	struct xfile		*xf,
>  	loff_t			pos,
> -	unsigned int		len)
> +	unsigned int		len,
> +	unsigned int		flags)
>  {
>  	struct inode		*inode = file_inode(xf->file);
>  	struct folio		*folio = NULL;
> @@ -293,15 +294,19 @@ xfile_get_page(
>  	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
>  	 * actually allocates a folio instead of erroring out.
>  	 */
> -	if (pos + len > i_size_read(inode))
> +	if ((flags & XFILE_ALLOC) && pos + len > i_size_read(inode))
>  		i_size_write(inode, pos + len);
>  
>  	pflags = memalloc_nofs_save();
> -	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE);
> +	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> +			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
>  	memalloc_nofs_restore(pflags);
>  	if (error)
>  		return ERR_PTR(error);
>  
> +	if (!folio)
> +		return NULL;
> +
>  	page = folio_file_page(folio, pos >> PAGE_SHIFT);
>  	if (PageHWPoison(page)) {
>  		folio_put(folio);
> @@ -312,7 +317,8 @@ xfile_get_page(
>  	 * Mark the page dirty so that it won't be reclaimed once we drop the
>  	 * (potentially last) reference in xfile_put_page.
>  	 */
> -	set_page_dirty(page);
> +	if (flags & XFILE_ALLOC)
> +		set_page_dirty(page);
>  	return page;
>  }
>  
> diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
> index 993368b37b4b7c..f0403ea869e4d0 100644
> --- a/fs/xfs/scrub/xfile.h
> +++ b/fs/xfs/scrub/xfile.h
> @@ -19,7 +19,9 @@ int xfile_obj_store(struct xfile *xf, const void *buf, size_t count,
>  
>  loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
>  
> -struct page *xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len);
> +#define XFILE_ALLOC		(1 << 0) /* allocate page if not present */
> +struct page *xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
> +		unsigned int flags);
>  void xfile_put_page(struct xfile *xf, struct page *page);
>  
>  #endif /* __XFS_SCRUB_XFILE_H__ */
> -- 
> 2.39.2
> 
> 
