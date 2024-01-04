Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547D5200A0
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 00:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0jkiZM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD570C433C7;
	Thu,  4 Jan 2024 00:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704326604;
	bh=WzDfCBMRLMc5eJLpfHMIDX7xkk+4zEKFGfN2Osboi18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0jkiZM5vbz57dX7mkg7u5bcCS7YhJnGh6VNOaDjvMAY+kZ44gcTsknVm+uIPYczD
	 M9mYlcHjMhXx/0gql1suwuHNymkyZWugQegyFqyg39XZl1iKHH8b+ohFn5EJvZ4rrS
	 Bg4qtBkjoH3fTLZc0fFdFfDtHjMkWpdooYKLMrKBtiA+wD/0ayIWj5HMtucqcsTdyg
	 TP5eWFhV2F7YwTjzjss5QREMXFlD3im1Tp96w7huKSx9F2qFll4l93VoWwgHMrbJ4u
	 VBffaHpYrhtXYvoRQXh3Bd6pgIZiowXWJ/7VRqvulfHwHTbtdu/vwHOTKFZKgLgc7j
	 RuGkBLGOKn4FQ==
Date: Wed, 3 Jan 2024 16:03:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/15] xfs: don't allow highmem pages in xfile mappings
Message-ID: <20240104000324.GC361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-10-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:20AM +0000, Christoph Hellwig wrote:
> XFS is generally used on 64-bit, non-highmem platforms and xfile
> mappings are accessed all the time.  Reduce our pain by not allowing
> any highmem mappings in the xfile page cache and remove all the kmap
> calls for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/xfarray.c |  3 +--
>  fs/xfs/scrub/xfile.c   | 21 +++++++++------------
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index f0f532c10a5acc..3a44700037924b 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -580,7 +580,7 @@ xfarray_sort_get_page(
>  	 * xfile pages must never be mapped into userspace, so we skip the
>  	 * dcache flush when mapping the page.
>  	 */
> -	si->page_kaddr = kmap_local_page(si->xfpage.page);
> +	si->page_kaddr = page_address(si->xfpage.page);
>  	return 0;
>  }
>  
> @@ -592,7 +592,6 @@ xfarray_sort_put_page(
>  	if (!si->page_kaddr)
>  		return 0;
>  
> -	kunmap_local(si->page_kaddr);
>  	si->page_kaddr = NULL;
>  
>  	return xfile_put_page(si->array->xfile, &si->xfpage);
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index e872f4f0263f59..afbd205289e9b0 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -77,6 +77,12 @@ xfile_create(
>  	inode = file_inode(xf->file);
>  	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
>  
> +	/*
> +	 * We don't want to bother with kmapping data during repair, so don't
> +	 * allow highmem pages to back this mapping.
> +	 */
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);

Gonna be fun to see what happens on 32-bit. ;)

But I do like getting rid of all the kmap overhead.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  	trace_xfile_create(xf);
>  
>  	*xfilep = xf;
> @@ -126,7 +132,6 @@ xfile_obj_load(
>  
>  	pflags = memalloc_nofs_save();
>  	while (count > 0) {
> -		void		*p, *kaddr;
>  		unsigned int	len;
>  
>  		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
> @@ -153,10 +158,7 @@ xfile_obj_load(
>  		 * xfile pages must never be mapped into userspace, so
>  		 * we skip the dcache flush.
>  		 */
> -		kaddr = kmap_local_page(page);
> -		p = kaddr + offset_in_page(pos);
> -		memcpy(buf, p, len);
> -		kunmap_local(kaddr);
> +		memcpy(buf, page_address(page) + offset_in_page(pos), len);
>  		put_page(page);
>  
>  advance:
> @@ -221,14 +223,13 @@ xfile_obj_store(
>  		 * the dcache flush.  If the page is not uptodate, zero it
>  		 * before writing data.
>  		 */
> -		kaddr = kmap_local_page(page);
> +		kaddr = page_address(page);
>  		if (!PageUptodate(page)) {
>  			memset(kaddr, 0, PAGE_SIZE);
>  			SetPageUptodate(page);
>  		}
>  		p = kaddr + offset_in_page(pos);
>  		memcpy(p, buf, len);
> -		kunmap_local(kaddr);
>  
>  		ret = aops->write_end(NULL, mapping, pos, len, len, page,
>  				fsdata);
> @@ -314,11 +315,7 @@ xfile_get_page(
>  	 * to the caller and make sure the backing store will hold on to them.
>  	 */
>  	if (!PageUptodate(page)) {
> -		void	*kaddr;
> -
> -		kaddr = kmap_local_page(page);
> -		memset(kaddr, 0, PAGE_SIZE);
> -		kunmap_local(kaddr);
> +		memset(page_address(page), 0, PAGE_SIZE);
>  		SetPageUptodate(page);
>  	}
>  
> -- 
> 2.39.2
> 
> 
