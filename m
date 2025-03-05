Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB1E16426
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 18:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741199691; cv=none; b=IFrD32Cz711Ni9eCyyE6LKHqdBnJ3A1TaJslqM163sTLXstJLP0rNuEbjTQo6s2k3OqR1dncNqjm5fPNdt69WmeuWVbq6XYvp7EhBzmTEkw6DcJOUF+sRRnNOX94lzDJNHdSCpr5clFnZyz+CZBztlYYM32SyDOhQ09Z0OPWTmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741199691; c=relaxed/simple;
	bh=hxEdb+dm6RM4V0ZOvo1/yQe0hktMo2dpdcUE3jxWbKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ILflsPsKsV23cANNLPYa7QDqtgo5t4gPSOpsciQcP+ATx4Q/0rTNNkQjE/jxAmjHJHGyDtGiE8U9s6upx4AjEclvTa4bpa/zp/rtUkn0qQiHwORTQDvwHIZxMAT1vHa3w4cv8S32NayV5X0lpjq3s5C2g+TZ/nFqFMh1fGPwnXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1hGMecE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1hGMecE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB8C4CEE0;
	Wed,  5 Mar 2025 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741199691;
	bh=hxEdb+dm6RM4V0ZOvo1/yQe0hktMo2dpdcUE3jxWbKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o1hGMecECN1kE6pfkeZYZsF5NHolGZwh7rbw2ErAJqiNgHdIgCLVjVyT0RwlzsWAo
	 gFSh1K9fdqSNT7XiEy/Q0iLs9VFbSjCySAfZguttEUO0Unllm9RHy85chxeId6G3hK
	 nhp2y4lzgF+2keUTO/XG69chatO/kxo0jFOzDQGMAievym5kUsT5cqMrsmklFsIG8N
	 71Y3hpmX/Dqr2sUiAuxQLXV7AI3DKI2ld0Vrxi9fiBGYb/uzUAyyLpXtfPE7Pebpht
	 fXNyoQwXcV3lBnHyUYdEv9Ak13nNIyKaGJ/SZ//lg+VOW2mP56Ubfcyou4trJyHzu/
	 764OfIFuUfRxw==
Date: Wed, 5 Mar 2025 10:34:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: cleanup mapping tmpfs folios into the buffer
 cache
Message-ID: <20250305183451.GL2803749@frogsfrogsfrogs>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305140532.158563-12-hch@lst.de>

On Wed, Mar 05, 2025 at 07:05:28AM -0700, Christoph Hellwig wrote:
> Directly assign b_addr based on the tmpfs folios without a detour
> through pages, reuse the folio_put path used for non-tmpfs buffers
> and replace all references to pages in comments with folios.
> 
> Partially based on a patch from Dave Chinner <dchinner@redhat.com>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c     |  6 ++----
>  fs/xfs/xfs_buf_mem.c | 34 ++++++++++------------------------
>  fs/xfs/xfs_buf_mem.h |  6 ++----
>  3 files changed, 14 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f28ca5cb5bd8..c7f4cafda705 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -206,9 +206,7 @@ xfs_buf_free(
>  	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
>  		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
>  
> -	if (xfs_buftarg_is_mem(bp->b_target))
> -		xmbuf_unmap_page(bp);
> -	else if (is_vmalloc_addr(bp->b_addr))
> +	if (is_vmalloc_addr(bp->b_addr))
>  		vfree(bp->b_addr);
>  	else if (bp->b_flags & _XBF_KMEM)
>  		kfree(bp->b_addr);
> @@ -275,7 +273,7 @@ xfs_buf_alloc_backing_mem(
>  	struct folio	*folio;
>  
>  	if (xfs_buftarg_is_mem(bp->b_target))
> -		return xmbuf_map_page(bp);
> +		return xmbuf_map_backing_mem(bp);
>  
>  	/* Assure zeroed buffer for non-read cases. */
>  	if (!(flags & XBF_READ))
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index b207754d2ee0..b4ffd80b7cb6 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -74,7 +74,7 @@ xmbuf_alloc(
>  
>  	/*
>  	 * We don't want to bother with kmapping data during repair, so don't
> -	 * allow highmem pages to back this mapping.
> +	 * allow highmem folios to back this mapping.
>  	 */
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);
>  
> @@ -127,14 +127,13 @@ xmbuf_free(
>  	kfree(btp);
>  }
>  
> -/* Directly map a shmem page into the buffer cache. */
> +/* Directly map a shmem folio into the buffer cache. */
>  int
> -xmbuf_map_page(
> +xmbuf_map_backing_mem(
>  	struct xfs_buf		*bp)
>  {
>  	struct inode		*inode = file_inode(bp->b_target->bt_file);
>  	struct folio		*folio = NULL;
> -	struct page		*page;
>  	loff_t                  pos = BBTOB(xfs_buf_daddr(bp));
>  	int			error;
>  
> @@ -159,30 +158,17 @@ xmbuf_map_page(
>  		return -EIO;
>  	}
>  
> -	page = folio_file_page(folio, pos >> PAGE_SHIFT);
> -
>  	/*
> -	 * Mark the page dirty so that it won't be reclaimed once we drop the
> -	 * (potentially last) reference in xmbuf_unmap_page.
> +	 * Mark the folio dirty so that it won't be reclaimed once we drop the
> +	 * (potentially last) reference in xfs_buf_free.
>  	 */
> -	set_page_dirty(page);
> -	unlock_page(page);
> +	folio_set_dirty(folio);
> +	folio_unlock(folio);
>  
> -	bp->b_addr = page_address(page);
> +	bp->b_addr = folio_address(folio);

If tmpfs gives us a large folio, don't we need to add offset_in_folio to
b_addr?  Or does this just work and xfs/801 (aka force the use of
hugepages on tmpfs) passes with no complaints?

--D

>  	return 0;
>  }
>  
> -/* Unmap a shmem page that was mapped into the buffer cache. */
> -void
> -xmbuf_unmap_page(
> -	struct xfs_buf		*bp)
> -{
> -	ASSERT(xfs_buftarg_is_mem(bp->b_target));
> -
> -	put_page(virt_to_page(bp->b_addr));
> -	bp->b_addr = NULL;
> -}
> -
>  /* Is this a valid daddr within the buftarg? */
>  bool
>  xmbuf_verify_daddr(
> @@ -196,7 +182,7 @@ xmbuf_verify_daddr(
>  	return daddr < (inode->i_sb->s_maxbytes >> BBSHIFT);
>  }
>  
> -/* Discard the page backing this buffer. */
> +/* Discard the folio backing this buffer. */
>  static void
>  xmbuf_stale(
>  	struct xfs_buf		*bp)
> @@ -211,7 +197,7 @@ xmbuf_stale(
>  }
>  
>  /*
> - * Finalize a buffer -- discard the backing page if it's stale, or run the
> + * Finalize a buffer -- discard the backing folio if it's stale, or run the
>   * write verifier to detect problems.
>   */
>  int
> diff --git a/fs/xfs/xfs_buf_mem.h b/fs/xfs/xfs_buf_mem.h
> index eed4a7b63232..67d525cc1513 100644
> --- a/fs/xfs/xfs_buf_mem.h
> +++ b/fs/xfs/xfs_buf_mem.h
> @@ -19,16 +19,14 @@ int xmbuf_alloc(struct xfs_mount *mp, const char *descr,
>  		struct xfs_buftarg **btpp);
>  void xmbuf_free(struct xfs_buftarg *btp);
>  
> -int xmbuf_map_page(struct xfs_buf *bp);
> -void xmbuf_unmap_page(struct xfs_buf *bp);
>  bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
>  void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
>  int xmbuf_finalize(struct xfs_buf *bp);
>  #else
>  # define xfs_buftarg_is_mem(...)	(false)
> -# define xmbuf_map_page(...)		(-ENOMEM)
> -# define xmbuf_unmap_page(...)		((void)0)
>  # define xmbuf_verify_daddr(...)	(false)
>  #endif /* CONFIG_XFS_MEMORY_BUFS */
>  
> +int xmbuf_map_backing_mem(struct xfs_buf *bp);
> +
>  #endif /* __XFS_BUF_MEM_H__ */
> -- 
> 2.45.2
> 
> 
