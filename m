Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244BED52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598162; cv=none; b=AqoZAa/ALDz84tR4gyjg/b5tfczixrjSJjjuhKhuacSzciSDCQp7MNko45T3OKYn2vcsSbwTGGMdWcnffU7uNvxiHlzMvKO8RHJ9f68AHC+p1bn9LAdtHzpP97R+XhzwSS5idsNWqS3Bsy76f5DO9AlqmSKZu+BCw1EhoddwW+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598162; c=relaxed/simple;
	bh=J1K1SPUndkP4ktSlij6YRSt3fiRgMQuHxyPG6HZJCYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APyzuPawZ4BJnzp0CigRnIxOyqZ/55P1Fns8sHWeXWRi8ktG+U8k1wlCmH1iTm9sIpPfTFk/V8dg7hOn7P0yTk48Y5KRsLzFEj7NIy+AMlJRq7Is5W/kOBvj2drctEttaaQpzmiHi/wxuDCvPS+nGI6obnhvCoeVGuTP0tJdFec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcoXN+hM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcoXN+hM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C56C072AA;
	Wed,  1 May 2024 21:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598161;
	bh=J1K1SPUndkP4ktSlij6YRSt3fiRgMQuHxyPG6HZJCYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pcoXN+hMlpBvP2nL+wV9W4CL2bE16TJsFWo1epFw6sE5Olvy5PrISczjzKwWQdudk
	 xHhiYGCb7VSvSsStQmvrI9L/Iou33VKGwFeF5IhGcIERBWPpvaGpr2Y5hluy+Lj3zS
	 Gfm3GIKxS3NqFTFXfFH6Lrz+0VJxtGA7BCDasjl2gANJnDEhZXiJSibxJ7q4/FdNya
	 blYgfF7TkdfzxoCSwUYHfM+AqynBUkhq+oM0KFpuVWCtRQrGsG3MRAg1u3whznw73M
	 8LNPhymLHLqkTTHUffiOjM+F/YP6O8PkCon0KEwc5Ikph+1rTkUtYsRqK/nfG7M4vn
	 6OX2kUKP+f1Kg==
Date: Wed, 1 May 2024 14:16:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/16] xfs: move the "does it fit" check into
 xfs_dir2_block_to_sf
Message-ID: <20240501211601.GT360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-6-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:15PM +0200, Christoph Hellwig wrote:
> All callers of xfs_dir2_block_to_sf first check if the block format
> directory would actually fit into the short format.  Move this code
> into xfs_dir2_block_to_sf and rename the function to
> xfs_dir2_try_block_to_sf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_block.c | 24 ++----------------------
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  5 +----
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 25 +++++++++++++++++--------
>  fs/xfs/libxfs/xfs_exchmaps.c   |  8 +-------
>  4 files changed, 21 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 20d4e86e14ab08..378d3aefdd9ced 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -795,8 +795,6 @@ xfs_dir2_block_removename(
>  	int			error;		/* error return value */
>  	int			needlog;	/* need to log block header */
>  	int			needscan;	/* need to fixup bestfree */
> -	xfs_dir2_sf_hdr_t	sfh;		/* shortform header */
> -	int			size;		/* shortform size */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  
>  	trace_xfs_dir2_block_removename(args);
> @@ -845,17 +843,8 @@ xfs_dir2_block_removename(
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, bp);
>  	xfs_dir3_data_check(dp, bp);
> -	/*
> -	 * See if the size as a shortform is good enough.
> -	 */
> -	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
> -	if (size > xfs_inode_data_fork_size(dp))
> -		return 0;
>  
> -	/*
> -	 * If it works, do the conversion.
> -	 */
> -	return xfs_dir2_block_to_sf(args, bp, size, &sfh);
> +	return xfs_dir2_try_block_to_sf(args, bp);
>  }
>  
>  /*
> @@ -944,7 +933,6 @@ xfs_dir2_leaf_to_block(
>  	xfs_mount_t		*mp;		/* file system mount point */
>  	int			needlog;	/* need to log data header */
>  	int			needscan;	/* need to scan for bestfree */
> -	xfs_dir2_sf_hdr_t	sfh;		/* shortform header */
>  	int			size;		/* bytes used */
>  	__be16			*tagp;		/* end of entry (tag) */
>  	int			to;		/* block/leaf to index */
> @@ -1058,15 +1046,7 @@ xfs_dir2_leaf_to_block(
>  	error = xfs_da_shrink_inode(args, args->geo->leafblk, lbp);
>  	if (error)
>  		return error;
> -
> -	/*
> -	 * Now see if the resulting block can be shrunken to shortform.
> -	 */
> -	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
> -	if (size > xfs_inode_data_fork_size(dp))
> -		return 0;
> -
> -	return xfs_dir2_block_to_sf(args, dbp, size, &sfh);
> +	return xfs_dir2_try_block_to_sf(args, dbp);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 3befb32509fa44..1e4401f9ec936e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -167,10 +167,7 @@ uint8_t xfs_dir2_sf_get_ftype(struct xfs_mount *mp,
>  		struct xfs_dir2_sf_entry *sfep);
>  struct xfs_dir2_sf_entry *xfs_dir2_sf_nextentry(struct xfs_mount *mp,
>  		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep);
> -extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
> -		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
> -extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
> -		int size, xfs_dir2_sf_hdr_t *sfhp);
> +int xfs_dir2_try_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp);
>  extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
>  extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
>  extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 1cd5228e1ce6af..fad3fd28175368 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -163,7 +163,7 @@ xfs_dir2_sf_put_ftype(
>   * space currently present in the inode.  If it won't fit, the output
>   * size is too big (but not accurate).
>   */
> -int						/* size for sf form */
> +static int					/* size for sf form */
>  xfs_dir2_block_sfsize(
>  	xfs_inode_t		*dp,		/* incore inode pointer */
>  	xfs_dir2_data_hdr_t	*hdr,		/* block directory data */
> @@ -250,15 +250,12 @@ xfs_dir2_block_sfsize(
>  }
>  
>  /*
> - * Convert a block format directory to shortform.
> - * Caller has already checked that it will fit, and built us a header.
> + * Try to convert a block format directory to shortform.
>   */
>  int						/* error */
> -xfs_dir2_block_to_sf(
> +xfs_dir2_try_block_to_sf(
>  	struct xfs_da_args	*args,		/* operation arguments */
> -	struct xfs_buf		*bp,
> -	int			size,		/* shortform directory size */
> -	struct xfs_dir2_sf_hdr	*sfhp)		/* shortform directory hdr */
> +	struct xfs_buf		*bp)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -267,8 +264,20 @@ xfs_dir2_block_to_sf(
>  	struct xfs_dir2_sf_entry *sfep;		/* shortform entry */
>  	struct xfs_dir2_sf_hdr	*sfp;		/* shortform directory header */
>  	unsigned int		offset = args->geo->data_entry_offset;
> +	struct xfs_dir2_sf_hdr	sfh;
> +	int			size;
>  	unsigned int		end;
>  
> +	/*
> +	 * See if it would fit into the shortform format.  If not we are done.
> +	 */
> +	size = xfs_dir2_block_sfsize(dp, bp->b_addr, &sfh);
> +	if (size > xfs_inode_data_fork_size(dp))
> +		return 0;
> +
> +	/*
> +	 * It would fit into the shortform formt, do the conversion now.
> +	 */
>  	trace_xfs_dir2_block_to_sf(args);
>  
>  	/*
> @@ -277,7 +286,7 @@ xfs_dir2_block_to_sf(
>  	 * the block and copy the formatted data into the inode literal area.
>  	 */
>  	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
> -	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
> +	memcpy(sfp, &sfh, xfs_dir2_sf_hdr_size(sfh.i8count));
>  
>  	/*
>  	 * Loop over the active and unused entries.  Stop when we reach the
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 2021396651de27..bca6b6b0985464 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -463,9 +463,7 @@ xfs_exchmaps_dir_to_sf(
>  		.trans		= tp,
>  		.owner		= xmi->xmi_ip2->i_ino,
>  	};
> -	struct xfs_dir2_sf_hdr	sfh;
>  	struct xfs_buf		*bp;
> -	int			size;
>  	int			error = 0;
>  
>  	if (xfs_dir2_format(&args, &error) != XFS_DIR2_FMT_BLOCK)
> @@ -475,11 +473,7 @@ xfs_exchmaps_dir_to_sf(
>  	if (error)
>  		return error;
>  
> -	size = xfs_dir2_block_sfsize(xmi->xmi_ip2, bp->b_addr, &sfh);
> -	if (size > xfs_inode_data_fork_size(xmi->xmi_ip2))
> -		return 0;
> -
> -	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
> +	return xfs_dir2_try_block_to_sf(&args, bp);
>  }
>  
>  /* Convert inode2's remote symlink target back to shortform, if possible. */
> -- 
> 2.39.2
> 
> 
