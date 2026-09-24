Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35662222A9
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790210285; cv=none; b=rXdaAgPp13ykwdYeZyOdvuMXjhOxzW8S5T6Ip8lwyh3mcm75ODR93Chb8rvGLWqNHtykCqJGPdV/Hp7BCZwwFZPRGWAYG6bTdPWD7Mbg+kGyAWWfIJVL5mSxphXQT+knMDxrTDlVJ+BVmYtIwytW2K5QWiwOjj1ike64j1jNNgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790210285; c=relaxed/simple;
	bh=SwvKBaumk/20FVGQSLp4k/kP0l8RGSfJe2CHlSAPRs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3UGko4oOBV+e8Ggf2p+yH+xvep5pnkpDTxDJIdl6aWUCXLRcxePWaoBLIJd5DhFXH9cnkGW3AGhvYdukSSv4oX/Yyk61mRgnHU+ws2nPgZxG0v4fXlcIR8vfLP+BqXdtKSR94142FbwTfz5+Z3H+LFEUHwOSt+7N08vbsA6FLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFlfZ4ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFlfZ4ve"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 479D41F000FF;
	Thu, 24 Sep 2026 00:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790210283;
	bh=CbZR7IgOIHOJb68pJ70eXd9tjlmLGalZvp/ifNT8zqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gFlfZ4vernP1lNNN/LAIuI9G/gkyNClfl+Zsd3skxanecNBldqJyy2Ab3NEgs1cB+
	 3bFySC/WTpnqqMB76UyNirLaFSG5cTn5v7N1AgdmjLTOCggtEC1+DTtYrJwRJXwXNw
	 EPHZ3cqYciw+vwkMZLSmkHGgRv06MnEF3Vg7rF5/d6WEKu04vaqV/7h+jgJ2o4NQ0B
	 /Enl9uhohsLRBu+gcg3xKJRHagXU/ca4b6zmSXFX8KEx5HTc9G/PN8scVfsYBu0t1T
	 Tntu1Q4YLl185vR+MtW5FEIeGgESsNM3uV8xM3jX2cBeLeHXmzginVmMMzSUGzWVKu
	 ED16pAi8tMzTA==
Date: Wed, 23 Sep 2026 17:38:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v4 3/4] xfs: calculate AGFL max to support multiple-alloc
 transactions
Message-ID: <20260924003802.GG2705364@frogsfrogsfrogs>
References: <20260923161524.416059-1-bfoster@redhat.com>
 <20260923161524.416059-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923161524.416059-4-bfoster@redhat.com>

On Wed, Sep 23, 2026 at 12:15:23PM -0400, Brian Foster wrote:
> Rework xfs_alloc_min_freelist() to return an (optional) max value
> along with the historical min freelist value. The max value
> includes an extra level in the btree based calculation to account
> for btree splits in the first allocation of a multi-alloc sequence.
> 
> This value reflects the worst case AGFL requirement that can be
> expected across multiple allocations within a single AG and single
> transaction. For example, consider the case of allocating an inode
> chunk and then an inobt block on inode record insertion.
> 
> While here, rename the need variable in xfs_alloc_fix_freelist() for
> clarity with upcoming changes.
> 
> Note that no callers calculate the max AGFL value as of yet. No
> functional changes in this patch.
> 
> Assisted-by: LLM
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>

Looks fine to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c  | 35 ++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_alloc.h  |  4 ++--
>  fs/xfs/libxfs/xfs_bmap.c   |  5 +++--
>  fs/xfs/libxfs/xfs_ialloc.c |  4 +++-
>  4 files changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b2525c58051b..af63926cc9ee 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2445,7 +2445,7 @@ xfs_alloc_longest_free_extent(
>   * multi-allocation transactions.
>   */
>  static unsigned int
> -__xfs_alloc_min_freelist(
> +__xfs_alloc_freelist(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
>  	unsigned int		extra_levels)
> @@ -2492,12 +2492,21 @@ __xfs_alloc_min_freelist(
>  	return min_free;
>  }
>  
> -unsigned int
> -xfs_alloc_min_freelist(
> +/*
> + * Compute the minimum and maximum length of the AGFL in the given AG. The max
> + * value in this context refers to the max requirement the AG might see in a
> + * multi-alloc transaction. If @pag is NULL, return the largest possible values.
> + */
> +void
> +xfs_alloc_freelist(
>  	struct xfs_mount	*mp,
> -	struct xfs_perag	*pag)
> +	struct xfs_perag	*pag,
> +	unsigned int		*min_free,
> +	unsigned int		*max_free)
>  {
> -	return __xfs_alloc_min_freelist(mp, pag, 0);
> +	*min_free = __xfs_alloc_freelist(mp, pag, 0);
> +	if (max_free)
> +		*max_free = __xfs_alloc_freelist(mp, pag, 1);
>  }
>  
>  /*
> @@ -2849,7 +2858,7 @@ xfs_alloc_fix_freelist(
>  	struct xfs_buf		*agflbp = NULL;
>  	struct xfs_alloc_arg	targs;	/* local allocation arguments */
>  	xfs_agblock_t		bno;	/* freelist block */
> -	xfs_extlen_t		need;	/* total blocks needed in freelist */
> +	xfs_extlen_t		min_free;/* total blocks needed in freelist */
>  	int			error = 0;
>  
>  	/* deferred ops (AGFL block frees) require permanent transactions */
> @@ -2877,8 +2886,8 @@ xfs_alloc_fix_freelist(
>  		goto out_agbp_relse;
>  	}
>  
> -	need = xfs_alloc_min_freelist(mp, pag);
> -	if (!xfs_alloc_space_available(args, need, alloc_flags |
> +	xfs_alloc_freelist(mp, pag, &min_free, NULL);
> +	if (!xfs_alloc_space_available(args, min_free, alloc_flags |
>  			XFS_ALLOC_FLAG_CHECK))
>  		goto out_agbp_relse;
>  
> @@ -2901,8 +2910,8 @@ xfs_alloc_fix_freelist(
>  		xfs_agfl_reset(tp, agbp, pag);
>  
>  	/* If there isn't enough total space or single-extent, reject it. */
> -	need = xfs_alloc_min_freelist(mp, pag);
> -	if (!xfs_alloc_space_available(args, need, alloc_flags))
> +	xfs_alloc_freelist(mp, pag, &min_free, NULL);
> +	if (!xfs_alloc_space_available(args, min_free, alloc_flags))
>  		goto out_agbp_relse;
>  
>  	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
> @@ -2944,7 +2953,7 @@ xfs_alloc_fix_freelist(
>  	else
>  		targs.oinfo = XFS_RMAP_OINFO_AG;
>  	while (!(alloc_flags & XFS_ALLOC_FLAG_NOSHRINK) &&
> -			pag->pagf_flcount > need) {
> +			pag->pagf_flcount > min_free) {
>  		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
>  		if (error)
>  			goto out_agbp_relse;
> @@ -2978,9 +2987,9 @@ xfs_alloc_fix_freelist(
>  		goto out_agbp_relse;
>  
>  	/* Make the freelist longer if it's too short. */
> -	while (pag->pagf_flcount < need) {
> +	while (pag->pagf_flcount < min_free) {
>  		targs.agbno = 0;
> -		targs.maxlen = need - pag->pagf_flcount;
> +		targs.maxlen = min_free - pag->pagf_flcount;
>  		targs.resv = XFS_AG_RESV_AGFL;
>  
>  		/* Allocate as many blocks as possible at once. */
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 50ef79a1ed41..44a10f4a22a2 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -71,8 +71,8 @@ unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
>  
>  xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
>  		xfs_extlen_t need, xfs_extlen_t reserved);
> -unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
> -		struct xfs_perag *pag);
> +void xfs_alloc_freelist(struct xfs_mount *mp, struct xfs_perag *pag,
> +		unsigned int *min_free, unsigned int *max_free);
>  int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
>  		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
>  int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ae91f63455c5..d6be6734bd90 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3149,6 +3149,7 @@ xfs_bmap_longest_free_extent(
>  	xfs_extlen_t		*blen)
>  {
>  	xfs_extlen_t		longest;
> +	unsigned int		min_free;
>  	int			error = 0;
>  
>  	if (!xfs_perag_initialised_agf(pag)) {
> @@ -3158,8 +3159,8 @@ xfs_bmap_longest_free_extent(
>  			return error;
>  	}
>  
> -	longest = xfs_alloc_longest_free_extent(pag,
> -				xfs_alloc_min_freelist(pag_mount(pag), pag),
> +	xfs_alloc_freelist(pag_mount(pag), pag, &min_free, NULL);
> +	longest = xfs_alloc_longest_free_extent(pag, min_free,
>  				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
>  	if (*blen < longest)
>  		*blen = longest;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index e31611cabd4d..e705f681ed44 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -3074,6 +3074,7 @@ xfs_ialloc_calc_rootino(
>  {
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
>  	xfs_agblock_t		first_bno;
> +	unsigned int		min_free;
>  
>  	/*
>  	 * Pre-calculate the geometry of AG 0.  We know what it looks like
> @@ -3092,7 +3093,8 @@ xfs_ialloc_calc_rootino(
>  	first_bno += 1;
>  
>  	/* ...the initial AGFL... */
> -	first_bno += xfs_alloc_min_freelist(mp, NULL);
> +	xfs_alloc_freelist(mp, NULL, &min_free, NULL);
> +	first_bno += min_free;
>  
>  	/* ...the free inode btree root... */
>  	if (xfs_has_finobt(mp))
> -- 
> 2.55.0
> 
> 
