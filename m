Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2433C872B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784911795; cv=none; b=F3P8KD0SYvJcwaGDRSqau9TkPC5f2Cvwe3h/0gyugY7rTofOaBuCVLBL9MSvTlPqF2IllLkP4Skt060Bi5z0gKy7JkumV7qK85yeAUsZ1n+xtmZN14G3VuiidzzCjNIVyn49JvizXGU6OWEH+lBHpqu/044ZIEQYpd+7dwOnxC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784911795; c=relaxed/simple;
	bh=lYrZJL3OY0ohL+z4DwzBlzwlQLgdgH6/ev6uThnu4aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0N8ARg29/Q1CPEbKqTl2BsPmjJvp7tez1eTzTt+6RA3JG2AYfRyXh5GtSHsBGx2iy6xq9gZtx4ajj/piOHTU7dzmu1WaIUYt3mw92X/wz0/A4+RUBYZ0P/gj+wSaqOOulRCcXrBZe7P2Qzka4W6KvmowMgO1BJQwmquIfDQ1P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQi2yN/J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQi2yN/J"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AADD61F000E9;
	Fri, 24 Jul 2026 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784911793;
	bh=jwgMbaj+lqGQ1ApmV7Yj456wdIVnb+j2aCJTdSTktt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PQi2yN/JWq698pyAv0UR47uOUlsm5/uKaAeKM6ssfD2vP/CZgaw/Hz7iCmxhKgG6j
	 yOTMxznZKoIoNng2HXl8RzAGVhqu9TWBTM2fENq1q/HJWSE3CkRznp9hXW3EVoDpJp
	 60DtE6uzFpA6aAVIE+H3tAB/ZJArvw9qgU6H8KYDiuw3gxGHGuD3/acUVOOsyaU/vW
	 w9lCqhraForQwRi5uDjtU3KMTqmBrp0Z+rbNautdX/a7m+ySfiGPUV2FduwHDAmTjx
	 BgDH5jQMsh9XFKmKoaYEQwB5FIp1k7yW3Kigy5rb5MaxXK9kWZTtQhfhssx4clJdZ7
	 xc8cOKdksjwFA==
Date: Fri, 24 Jul 2026 09:49:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: hide b_flags manipulation from code outside
 of xfs_buf.c
Message-ID: <20260724164953.GT2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-7-hch@lst.de>

On Wed, Jul 15, 2026 at 04:50:59PM +0200, Christoph Hellwig wrote:
> Add helpers for the remaining buffer flags manipulation not done in the
> core buffer cache code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward wrappers, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_btree_staging.c |  7 +++----
>  fs/xfs/libxfs/xfs_ialloc.c        |  2 +-
>  fs/xfs/xfs_buf.c                  | 16 ++++++++++++++++
>  fs/xfs/xfs_buf.h                  |  4 +++-
>  fs/xfs/xfs_fsops.c                |  2 +-
>  fs/xfs/xfs_inode.c                |  4 ++--
>  fs/xfs/xfs_trans_buf.c            |  7 +++----
>  7 files changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index c3c7ea54895a..7314dab4bcfb 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -248,11 +248,10 @@ xfs_btree_bload_drop_buf(
>  		return 0;
>  
>  	/*
> -	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
> -	 * xfs_buf_read will not pointlessly reread the contents from the disk.
> +	 * Mark this buffer uptodate so that a subsequent xfs_buf_read will
> +	 * not pointlessly reread the contents from the disk.
>  	 */
> -	bp->b_flags |= XBF_DONE;
> -
> +	xfs_buf_set_uptodate(bp);
>  	xfs_buf_delwri_queue_here(bp, buffers_list);
>  	xfs_buf_relse(bp);
>  	*bpp = NULL;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index ffcdd1f691fd..58dac4d505ba 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -413,7 +413,7 @@ xfs_ialloc_inode_init(
>  				xfs_trans_ordered_buf(tp, fbuf);
>  			}
>  		} else {
> -			fbuf->b_flags |= XBF_DONE;
> +			xfs_buf_set_uptodate(fbuf);
>  			xfs_buf_delwri_queue(fbuf, buffer_list);
>  			xfs_buf_relse(fbuf);
>  		}
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d0146d4fb3d3..33e904d838f4 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -55,6 +55,13 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
>  	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
>  }
>  
> +void
> +xfs_buf_set_uptodate(
> +	struct xfs_buf	*bp)
> +{
> +	bp->b_flags |= XBF_DONE;
> +}
> +
>  /*
>   * When we mark a buffer stale, we remove the buffer from the LRU and clear the
>   * b_lru_ref count so that the buffer is freed immediately when the buffer
> @@ -85,6 +92,15 @@ xfs_buf_stale(
>  	spin_unlock(&bp->b_lockref.lock);
>  }
>  
> +void
> +xfs_buf_clear_stale(
> +	struct xfs_buf	*bp)
> +{
> +	ASSERT(bp->b_flags & XBF_STALE);
> +
> +	bp->b_flags &= ~XBF_STALE;
> +}
> +
>  static void
>  xfs_buf_free_callback(
>  	struct callback_head	*cb)
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index e440f97cf3e1..a4729253b56f 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -301,7 +301,9 @@ static inline void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize)
>  	memset(bp->b_addr + boff, 0, bsize);
>  }
>  
> -extern void xfs_buf_stale(struct xfs_buf *bp);
> +void xfs_buf_set_uptodate(struct xfs_buf *bp);
> +void xfs_buf_stale(struct xfs_buf *bp);
> +void xfs_buf_clear_stale(struct xfs_buf *bp);
>  
>  /* Delayed Write Buffer Routines */
>  extern void xfs_buf_delwri_cancel(struct list_head *);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 67624a804a7f..21114bb6d4ff 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -501,7 +501,7 @@ xfs_do_force_shutdown(
>  		return;
>  	}
>  	if (mp->m_sb_bp)
> -		mp->m_sb_bp->b_flags |= XBF_DONE;
> +		xfs_buf_set_uptodate(mp->m_sb_bp);
>  
>  	if (flags & SHUTDOWN_FORCE_UMOUNT)
>  		xfs_alert(mp, "User initiated shutdown received.");
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 15279d22a894..030a7c8f2c12 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1753,7 +1753,7 @@ xfs_ifree_cluster(
>  		 * attachment may occur in xfs_inode_item_precommit() after we
>  		 * have marked this buffer stale.  If this buffer was not in
>  		 * memory before xfs_ifree_cluster() started, it will not be
> -		 * marked XBF_DONE and this will cause problems later in
> +		 * marked uptodate and this will cause problems later in
>  		 * xfs_inode_item_precommit() when we trip over a (stale, !done)
>  		 * buffer to attached to the transaction.
>  		 *
> @@ -1766,7 +1766,7 @@ xfs_ifree_cluster(
>  		 * fail. We can acheive this by adding a write verifier to the
>  		 * buffer.
>  		 */
> -		bp->b_flags |= XBF_DONE;
> +		xfs_buf_set_uptodate(bp);
>  		bp->b_ops = &xfs_inode_buf_ops;
>  
>  		/*
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 7e17b93fe9ad..1e025848811a 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -140,7 +140,7 @@ xfs_trans_get_buf_map(
>  		ASSERT(xfs_buf_islocked(bp));
>  		if (xfs_is_shutdown(tp->t_mountp)) {
>  			xfs_buf_stale(bp);
> -			bp->b_flags |= XBF_DONE;
> +			xfs_buf_set_uptodate(bp);
>  		}
>  
>  		ASSERT(bp->b_transp == tp);
> @@ -482,7 +482,7 @@ xfs_trans_dirty_buf(
>  	 * item from the AIL and free it when the buffer is flushed
>  	 * to disk.
>  	 */
> -	bp->b_flags |= XBF_DONE;
> +	xfs_buf_set_uptodate(bp);
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
> @@ -494,8 +494,7 @@ xfs_trans_dirty_buf(
>  	 */
>  	if (bip->bli_flags & XFS_BLI_STALE) {
>  		bip->bli_flags &= ~XFS_BLI_STALE;
> -		ASSERT(bp->b_flags & XBF_STALE);
> -		bp->b_flags &= ~XBF_STALE;
> +		xfs_buf_clear_stale(bp);
>  		bip->__bli_format.blf_flags &= ~XFS_BLF_CANCEL;
>  	}
>  	bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
> -- 
> 2.53.0
> 
> 
