Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024AB21ADB7
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779103337; cv=none; b=RlOqZB6BwKcWDtWd3m/yjEVhESKcZ2rL3Q2DpRGRNPRQPKsu2Lb53GgKH2W4Bsu0xRqls8kzHMxkZXWRefAAE2Ml+ggD0MpA56+RJgFl0HskqwXpJA5c/XUNyDiM1DfbZcMQjvopl9Gda0QQwjqmUWM4Q6yXiVrQe9oMmSiwfVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779103337; c=relaxed/simple;
	bh=mfDvZUxxt08iBL66H5n5KJrjz38JROvviqbJ3WVRpU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTdmankYPhx1GYjRqqY1U1qQbD5CXTSjbk4epngLgtv/x3rTy/q4x1Gec9QhmMOGf/Q6Ct3M8TCNOODwxPonrqo5TPIaR14LuYC38POWwN5OmDyICjUSms9vOllwPhooTqvRIh848kxAhJVzR28px2X6Yw1HuBaAS7uoikO4j6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfBKSCBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfBKSCBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE33C2BCC7;
	Mon, 18 May 2026 11:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779103335;
	bh=mfDvZUxxt08iBL66H5n5KJrjz38JROvviqbJ3WVRpU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AfBKSCBfpIiDVwtxv+UfiHwJF6GhNzBeViVB/2thqqOdvEBIu8kXQpxtbR7nZBdOJ
	 sQLiXFvWx944ra4u9Q3ikrLS0YparkKlDPRNrc25TPIp22qvVTeR+m2K92UkA5NT/c
	 qdLm66zgDIi6XVdIV0KKUkfg9Slx4wKbsk5m9c0nnirYaqBMkciGBHQTCpU/X4V33+
	 G3pmeFb5H+6aLS5+k/odDxVO9Qz/ncdfgF4U5li6tL+goDYhD4B7P7rX5esu9YB335
	 kcBbLgd+AZSTutrefhrm7zm1UA30ZW3jz5otzDT2MmL1eeuZ5zGCM5JyWWRisdID9s
	 il9D+RcmzUbqQ==
Date: Mon, 18 May 2026 13:22:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: add a xchk_ip_set_corrupt helper
Message-ID: <agr2U5k2Tci0UK9i@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-7-hch@lst.de>

On Fri, May 15, 2026 at 03:50:27PM +0200, Christoph Hellwig wrote:
> Add a smaller wrapper to set a inode corrupted by the xfs_inode
> pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/bmap.c      |  8 ++++----
>  fs/xfs/scrub/common.c    | 10 +++++-----
>  fs/xfs/scrub/common.h    |  2 ++
>  fs/xfs/scrub/dir.c       |  2 +-
>  fs/xfs/scrub/dirtree.c   |  4 ++--
>  fs/xfs/scrub/metapath.c  |  6 +++---
>  fs/xfs/scrub/nlinks.c    | 12 ++++++------
>  fs/xfs/scrub/parent.c    |  6 +++---
>  fs/xfs/scrub/rtbitmap.c  | 12 ++++++------
>  fs/xfs/scrub/rtsummary.c | 12 ++++++------
>  10 files changed, 38 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 67861102cdb9..6dc1f6eea45e 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -1040,7 +1040,7 @@ xchk_bmap(
>  	case XFS_COW_FORK:
>  		/* No CoW forks filesystem doesn't support out of place writes */
>  		if (!xfs_has_reflink(mp) && !xfs_has_zoned(mp)) {
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  			return 0;
>  		}
>  		break;
> @@ -1052,7 +1052,7 @@ xchk_bmap(
>  		 * attr here.
>  		 */
>  		if (!xfs_has_attr(mp))
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  		break;
>  	default:
>  		ASSERT(whichfork == XFS_DATA_FORK);
> @@ -1137,7 +1137,7 @@ xchk_bmap_data(
>  	int			error;
>  
>  	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTD_ZAPPED)) {
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  		return 0;
>  	}
>  
> @@ -1165,7 +1165,7 @@ xchk_bmap_attr(
>  	 * returning immediately.
>  	 */
>  	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTA_ZAPPED)) {
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  		return 0;
>  	}
>  
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 20e63069088b..5041f0c91603 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -1099,7 +1099,7 @@ xchk_install_live_inode(
>  	struct xfs_inode	*ip)
>  {
>  	if (!igrab(VFS_I(ip))) {
> -		xchk_ino_set_corrupt(sc, ip->i_ino);
> +		xchk_ip_set_corrupt(sc, ip);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -1428,13 +1428,13 @@ xchk_metadata_inode_forks(
>  
>  	/* Metadata inodes don't live on the rt device. */
>  	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME) {
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  		return 0;
>  	}
>  
>  	/* They should never participate in reflink. */
>  	if (xfs_is_reflink_inode(sc->ip)) {
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  		return 0;
>  	}
>  
> @@ -1451,7 +1451,7 @@ xchk_metadata_inode_forks(
>  				&error))
>  			return error;
>  		if (shared)
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  	}
>  
>  	/*
> @@ -1460,7 +1460,7 @@ xchk_metadata_inode_forks(
>  	 */
>  	if (xfs_inode_hasattr(sc->ip)) {
>  		if (!xfs_has_metadir(sc->mp)) {
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  			return 0;
>  		}
>  
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index f2ecc68538f0..ae998501f8aa 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -30,6 +30,8 @@ void xchk_set_corrupt(struct xfs_scrub *sc);
>  void xchk_block_set_corrupt(struct xfs_scrub *sc,
>  		struct xfs_buf *bp);
>  void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
> +#define xchk_ip_set_corrupt(_sc, _ip) \
> +	xchk_ino_set_corrupt((_sc), (_ip)->i_ino)
>  void xchk_fblock_set_corrupt(struct xfs_scrub *sc, int whichfork,
>  		xfs_fileoff_t offset);
>  #ifdef CONFIG_XFS_QUOTA
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index e09724cd3725..c810c154d72e 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -1075,7 +1075,7 @@ xchk_directory(
>  
>  	/* Plausible size? */
>  	if (sc->ip->i_disk_size < xfs_dir2_sf_hdr_size(0)) {
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  		return 0;
>  	}
>  
> diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
> index 143114718d75..124b2379d5c4 100644
> --- a/fs/xfs/scrub/dirtree.c
> +++ b/fs/xfs/scrub/dirtree.c
> @@ -979,10 +979,10 @@ xchk_dirtree(
>  	xchk_dirtree_evaluate(dl, &oc);
>  	if (xchk_dirtree_parentless(dl)) {
>  		if (oc.good || oc.bad || oc.suspect)
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  	} else {
>  		if (oc.bad || oc.good + oc.suspect != 1)
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  		if (oc.suspect)
>  			xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  	}
> diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
> index 050b86eb12d3..680a8ba1cdf1 100644
> --- a/fs/xfs/scrub/metapath.c
> +++ b/fs/xfs/scrub/metapath.c
> @@ -314,7 +314,7 @@ xchk_metapath(
>  
>  	/* Parent required to do anything else. */
>  	if (mpath->dp == NULL) {
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  		return 0;
>  	}
>  
> @@ -329,7 +329,7 @@ xchk_metapath(
>  	trace_xchk_metapath_lookup(sc, mpath->path, mpath->dp, ino);
>  	if (error == -ENOENT) {
>  		/* No directory entry at all */
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  		error = 0;
>  		goto out_ilock;
>  	}
> @@ -337,7 +337,7 @@ xchk_metapath(
>  		goto out_ilock;
>  	if (ino != sc->ip->i_ino) {
>  		/* Pointing to wrong inode */
> -		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_set_corrupt(sc, sc->ip);
>  	}
>  
>  out_ilock:
> diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
> index 1e0effdb65a6..2a214802c77c 100644
> --- a/fs/xfs/scrub/nlinks.c
> +++ b/fs/xfs/scrub/nlinks.c
> @@ -718,7 +718,7 @@ xchk_nlinks_compare_inode(
>  	 * count, but it will let them decrease it.
>  	 */
>  	if (total_links > XFS_NLINK_PINNED) {
> -		xchk_ino_set_corrupt(sc, ip->i_ino);
> +		xchk_ip_set_corrupt(sc, ip);
>  		goto out_corrupt;
>  	} else if (total_links > XFS_MAXLINK) {
>  		xchk_ino_set_warning(sc, ip->i_ino);
> @@ -726,7 +726,7 @@ xchk_nlinks_compare_inode(
>  
>  	/* Link counts should match. */
>  	if (total_links != actual_nlink) {
> -		xchk_ino_set_corrupt(sc, ip->i_ino);
> +		xchk_ip_set_corrupt(sc, ip);
>  		goto out_corrupt;
>  	}
>  
> @@ -747,7 +747,7 @@ xchk_nlinks_compare_inode(
>  		 * back references.
>  		 */
>  		if (obs.backrefs != 0) {
> -			xchk_ino_set_corrupt(sc, ip->i_ino);
> +			xchk_ip_set_corrupt(sc, ip);
>  			goto out_corrupt;
>  		}
>  
> @@ -756,7 +756,7 @@ xchk_nlinks_compare_inode(
>  		 * children.
>  		 */
>  		if (obs.children != 0) {
> -			xchk_ino_set_corrupt(sc, ip->i_ino);
> +			xchk_ip_set_corrupt(sc, ip);
>  			goto out_corrupt;
>  		}
>  	}
> @@ -769,7 +769,7 @@ xchk_nlinks_compare_inode(
>  		 * the root directory.
>  		 */
>  		if (obs.parents != 1) {
> -			xchk_ino_set_corrupt(sc, ip->i_ino);
> +			xchk_ip_set_corrupt(sc, ip);
>  			goto out_corrupt;
>  		}
>  	} else if (actual_nlink > 0) {
> @@ -778,7 +778,7 @@ xchk_nlinks_compare_inode(
>  		 * least one parent.
>  		 */
>  		if (obs.parents == 0) {
> -			xchk_ino_set_corrupt(sc, ip->i_ino);
> +			xchk_ip_set_corrupt(sc, ip);
>  			goto out_corrupt;
>  		}
>  	}
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 931604fa1294..eb9ca3d75fef 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -729,10 +729,10 @@ xchk_parent_count_pptrs(
>  			pp->pptrs_found++;
>  
>  		if (VFS_I(sc->ip)->i_nlink == 0 && pp->pptrs_found > 0)
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  		else if (VFS_I(sc->ip)->i_nlink > 0 &&
>  			 pp->pptrs_found == 0)
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  	} else {
>  		/*
>  		 * Starting with metadir, we allow checking of parent pointers
> @@ -743,7 +743,7 @@ xchk_parent_count_pptrs(
>  			pp->pptrs_found++;
>  
>  		if (VFS_I(sc->ip)->i_nlink != pp->pptrs_found)
> -			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_set_corrupt(sc, sc->ip);
>  	}
>  
>  	return 0;
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index b3a4972d423e..10d4c11372d9 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -200,13 +200,13 @@ xchk_rtbitmap(
>  
>  	/* Is sb_rextents correct? */
>  	if (mp->m_sb.sb_rextents != rtb->rextents) {
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  
>  	/* Is sb_rextslog correct? */
>  	if (mp->m_sb.sb_rextslog != rtb->rextslog) {
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  
> @@ -215,17 +215,17 @@ xchk_rtbitmap(
>  	 * case can we exceed 4bn bitmap blocks since the super field is a u32.
>  	 */
>  	if (rtb->rbmblocks > U32_MAX) {
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  	if (mp->m_sb.sb_rbmblocks != rtb->rbmblocks) {
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  
>  	/* The bitmap file length must be aligned to an fsblock. */
>  	if (rbmip->i_disk_size & mp->m_blockmask) {
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  
> @@ -235,7 +235,7 @@ xchk_rtbitmap(
>  	 * file can be larger than sb_rbmblocks.
>  	 */
>  	if (rbmip->i_disk_size < XFS_FSB_TO_B(mp, rtb->rbmblocks)) {
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  
> diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
> index efce39d7a1ef..18074c1ff166 100644
> --- a/fs/xfs/scrub/rtsummary.c
> +++ b/fs/xfs/scrub/rtsummary.c
> @@ -314,25 +314,25 @@ xchk_rtsummary(
>  
>  	/* Is sb_rextents correct? */
>  	if (mp->m_sb.sb_rextents != rts->rextents) {
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  
>  	/* Is m_rsumlevels correct? */
>  	if (mp->m_rsumlevels != rts->rsumlevels) {
> -		xchk_ino_set_corrupt(sc, rsumip->i_ino);
> +		xchk_ip_set_corrupt(sc, rsumip);
>  		return 0;
>  	}
>  
>  	/* Is m_rsumsize correct? */
>  	if (mp->m_rsumblocks != rts->rsumblocks) {
> -		xchk_ino_set_corrupt(sc, rsumip->i_ino);
> +		xchk_ip_set_corrupt(sc, rsumip);
>  		return 0;
>  	}
>  
>  	/* The summary file length must be aligned to an fsblock. */
>  	if (rsumip->i_disk_size & mp->m_blockmask) {
> -		xchk_ino_set_corrupt(sc, rsumip->i_ino);
> +		xchk_ip_set_corrupt(sc, rsumip);
>  		return 0;
>  	}
>  
> @@ -342,7 +342,7 @@ xchk_rtsummary(
>  	 * the file can be larger than rsumsize.
>  	 */
>  	if (rsumip->i_disk_size < XFS_FSB_TO_B(mp, rts->rsumblocks)) {
> -		xchk_ino_set_corrupt(sc, rsumip->i_ino);
> +		xchk_ip_set_corrupt(sc, rsumip);
>  		return 0;
>  	}
>  
> @@ -358,7 +358,7 @@ xchk_rtsummary(
>  		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
>  		 * error since we're checking the summary file.
>  		 */
> -		xchk_ino_set_corrupt(sc, rbmip->i_ino);
> +		xchk_ip_set_corrupt(sc, rbmip);
>  		return 0;
>  	}
>  	if (error)
> -- 
> 2.53.0
> 
> 
