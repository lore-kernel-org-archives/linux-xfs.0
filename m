Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8BD17BB3C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714492292; cv=none; b=UJ1575qRhpsmumak+eXXE5trOyKhz1+W/34mPhxqFhTpWc761wF/8ywIgtBXxlO+b/sskl0essLruaVCjpB1oFljFH4fR6CFS7oM0gDolKTv7cKnQt1zzxqMdKL+4oEUny1NO/Y85CSPn3nMSuaPkihMy+lwuxUOUkMEDId6AU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714492292; c=relaxed/simple;
	bh=Z6laDREcxIgAtnI3siALyvpyls0o6PI0oujSTgYj998=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPZUV3vDJEh6FxcTSPJ+UY2a3O6dGvwuounnYxY59NM7mjAQTYtFysNs8VW9JSyBl1XXl2nnksmk5Jmrt4qVyfaSQku9YfE19O/OwBMBXw8m9bywZxUdoGq1cr2nwHDBtByePTLtOgkqE3XexJEaY/O8i9iwFW1EV0UJfEfEWr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdUgWrVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdUgWrVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1061BC4AF1B;
	Tue, 30 Apr 2024 15:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714492292;
	bh=Z6laDREcxIgAtnI3siALyvpyls0o6PI0oujSTgYj998=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KdUgWrViI3j0Sj664R3qWZ4fAIuHD2Dz6dpUzrO3aPfdVOIpvSrfJpakmYVfBWpra
	 ArPGqujbEqmmLDzFkBKYhqrPz00E2msEWonlnDEDhz/NVzSYaoy7A/189AzaGCWzYn
	 Wzv6x3vnKOd4ygMDGbIdxsnk0ylCzQHMvkzwWuwwf3pV+VQ8JLLoPhPaneuIy7eSwZ
	 pbs/e/KPlITp1g0iJE9GGhzjcghIxVOoQayUIDzmzJOYmJsi7JiNTLUNJK87Ua8DCp
	 mCiKPHW37/y9VgPAq300nMod9ulcHK+V+gBeRdQkpNb50P6wLP1+RsEg4fvzP4d8tX
	 7ocP5Cy/rYaWA==
Date: Tue, 30 Apr 2024 08:51:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: allow non-empty forks in
 xfs_bmap_local_to_extents_empty
Message-ID: <20240430155131.GO360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-2-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:11PM +0200, Christoph Hellwig wrote:
> Currently xfs_bmap_local_to_extents_empty expects the caller to set the
> for size to 0, which implies freeing if_data.  That is highly suboptimal
> because the callers need the data in the local fork so that they can
> copy it to the newly allocated extent.
> 
> Change xfs_bmap_local_to_extents_empty to return the old fork data and
> clear if_bytes to zero instead and let the callers free the memory for

But I don't see any changes in the callsites to do that freeing, is this
a memory leak?

--D

> the local fork, which allows them to access the data directly while
> formatting the extent format data.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 13 +++++++------
>  fs/xfs/libxfs/xfs_bmap.h |  2 +-
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6053f5e5c71eec..eb826fae8fd878 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -754,31 +754,32 @@ xfs_bmap_extents_to_btree(
>  
>  /*
>   * Convert a local file to an extents file.
> - * This code is out of bounds for data forks of regular files,
> - * since the file data needs to get logged so things will stay consistent.
> - * (The bmap-level manipulations are ok, though).
> + *
> + * Returns the content of the old data fork, which needs to be freed by the
> + * caller.
>   */
> -void
> +void *
>  xfs_bmap_local_to_extents_empty(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork)
>  {
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> +	void			*old_data = ifp->if_data;
>  
>  	ASSERT(whichfork != XFS_COW_FORK);
>  	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> -	ASSERT(ifp->if_bytes == 0);
>  	ASSERT(ifp->if_nextents == 0);
>  
>  	xfs_bmap_forkoff_reset(ip, whichfork);
>  	ifp->if_data = NULL;
> +	ifp->if_bytes = 0;
>  	ifp->if_height = 0;
>  	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	return old_data;
>  }
>  
> -
>  int					/* error */
>  xfs_bmap_local_to_extents(
>  	xfs_trans_t	*tp,		/* transaction pointer */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index e98849eb9bbae3..6e0b6081bf3aa5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -178,7 +178,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
>  int	xfs_bmap_add_attrfork(struct xfs_trans *tp, struct xfs_inode *ip,
>  		int size, int rsvd);
> -void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
> +void	*xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
>  		struct xfs_inode *ip, int whichfork);
>  int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extlen_t total, int *logflagsp, int whichfork,
> -- 
> 2.39.2
> 
> 
