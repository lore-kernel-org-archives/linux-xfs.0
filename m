Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733143DEFF7
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 09:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779096086; cv=none; b=IlOyIBH2q0iyZYj4nLEavcA7hftphgstj7lsS1SBh0tpXOIgHqjGl4qSFY1550/+PJgmbfxCtuBX8ynxtoJKz0grUq00UmCBWKcKGTvAYQyxxuf+PcY8nnzWG/BpHglTNbARJry6rDjH3zp3SFDHWvj0yy0opwo1SFT2mwPAOb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779096086; c=relaxed/simple;
	bh=G/9jcYFknYvC2odGzBqIEFCcTdd2ftAvg0hM3lcPUA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLzWJRE1HpRM2EHDGrBITZXLCcPXED2Lw8j+Lu3WvAk5c5RJ4AAhzMy8FJYEu7VIi0nBzpuWRWm+3HHPtkLXPitYb+iazxEAmtVtvlgv4MdTfkbk2rjJ0dyn5D5lgpaEkMGF0VnYioZiJtf+Ddxr+IRxITpZVR7muy3RGONGnxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYuqgAiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYuqgAiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5798AC2BCB7;
	Mon, 18 May 2026 09:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779096086;
	bh=G/9jcYFknYvC2odGzBqIEFCcTdd2ftAvg0hM3lcPUA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYuqgAiT4vLtlnr8W/L/XGqxKE31BVH8V+hN/Jb+RsIF+p+STp2czR/l9OIk6YViR
	 2b8knSQmwnxRbW/QOlHmTLVM84tXqzmEDeIASAFmERbao//yJvVUkAxHW/Ilc4uBWt
	 gkVALCixTUxHPIuzf7vfvUoTENM6seRzzLK1826QqGepDKFgZH3AznXc4yj1/lgRZt
	 aA+UAO9Yxujjfdw/LjMXWJkwxsrA7tmDSWD8OaGTQ0IlUEyINS98pSq80aDSlvQub2
	 VazhigjfqdaKr+qXEn3K2aXxVpz0tCz/OuaI7XE5ILBDr+T/+lV5xT8jYO/NAmM+kl
	 NuhchTyqXcHLw==
Date: Mon, 18 May 2026 11:21:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: add a XFS_INODE_TO_AGNO helper
Message-ID: <agrZ6jUzrJxRIevO@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-2-hch@lst.de>

On Fri, May 15, 2026 at 03:50:22PM +0200, Christoph Hellwig wrote:
> Add a shortcut for the common XFS_INO_TO_AGNO(mp, ip->i_ino) pattern.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_dir2.c       |  4 ++--
>  fs/xfs/libxfs/xfs_format.h     |  2 ++
>  fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
>  fs/xfs/libxfs/xfs_inode_util.c |  2 +-
>  fs/xfs/scrub/agheader_repair.c |  8 +++-----
>  fs/xfs/scrub/dir_repair.c      |  2 +-
>  fs/xfs/scrub/inode_repair.c    |  3 +--
>  fs/xfs/scrub/nlinks_repair.c   |  2 +-
>  fs/xfs/scrub/parent_repair.c   |  2 +-
>  fs/xfs/scrub/trace.h           |  8 ++++----
>  fs/xfs/xfs_icache.c            | 14 ++++++--------
>  fs/xfs/xfs_inode.c             |  9 ++++-----
>  fs/xfs/xfs_trace.h             |  9 ++++-----
>  13 files changed, 31 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 495620cc001f..9f96528ea407 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -919,7 +919,7 @@ xfs_dir_add_child(
>  	if (VFS_I(ip)->i_nlink == 0) {
>  		struct xfs_perag	*pag;
>  
> -		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  		error = xfs_iunlink_remove(tp, pag, ip);
>  		xfs_perag_put(pag);
>  		if (error)
> @@ -1246,7 +1246,7 @@ xfs_dir_rename_children(
>  
>  		ASSERT(VFS_I(du_wip->ip)->i_nlink == 0);
>  
> -		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, du_wip->ip->i_ino));
> +		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(du_wip->ip));
>  		error = xfs_iunlink_remove(tp, pag, du_wip->ip);
>  		xfs_perag_put(pag);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 779dac59b1f3..36a00c174f1e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1276,6 +1276,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
>  	XFS_INO_AGNO_BITS(mp) + XFS_INO_AGINO_BITS(mp)
>  #define	XFS_INO_TO_AGNO(mp,i)		\
>  	((xfs_agnumber_t)((i) >> XFS_INO_AGINO_BITS(mp)))
> +#define	XFS_INODE_TO_AGNO(ip)		\
> +	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
>  #define	XFS_INO_TO_AGINO(mp,i)		\
>  	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
>  #define	XFS_INO_TO_AGBNO(mp,i)		\
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index dcef06ec0a02..77201a1eb3c4 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1870,7 +1870,7 @@ xfs_dialloc_pick_ag(
>  	if (S_ISDIR(mode))
>  		return (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
>  
> -	start_agno = XFS_INO_TO_AGNO(mp, dp->i_ino);
> +	start_agno = XFS_INODE_TO_AGNO(dp);
>  	if (start_agno >= mp->m_maxagi)
>  		start_agno = 0;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> index 551fa51befb6..b478d16c0e20 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.c
> +++ b/fs/xfs/libxfs/xfs_inode_util.c
> @@ -529,7 +529,7 @@ xfs_iunlink(
>  	ASSERT(VFS_I(ip)->i_mode != 0);
>  	trace_xfs_iunlink(ip);
>  
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  
>  	/* Get the agi buffer first.  It ensures lock ordering on the list. */
>  	error = xfs_read_agi(pag, tp, 0, &agibp);
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index ae9ed5f280d0..c8d54ce6e363 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1116,9 +1116,7 @@ xrep_iunlink_igrab(
>  	struct xfs_perag	*pag,
>  	struct xfs_inode	*ip)
>  {
> -	struct xfs_mount	*mp = pag_mount(pag);
> -
> -	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
> +	if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
>  		return false;
>  
>  	if (!xfs_inode_on_unlinked_list(ip))
> @@ -1142,7 +1140,7 @@ xrep_iunlink_visit(
>  	unsigned int		bucket;
>  	int			error;
>  
> -	ASSERT(XFS_INO_TO_AGNO(mp, ip->i_ino) == pag_agno(ragi->sc->sa.pag));
> +	ASSERT(XFS_INODE_TO_AGNO(ip) == pag_agno(ragi->sc->sa.pag));
>  	ASSERT(xfs_inode_on_unlinked_list(ip));
>  
>  	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> @@ -1213,7 +1211,7 @@ xrep_iunlink_mark_incore(
>  			 * us to see this inode, so another lookup from the
>  			 * same index will not find it again.
>  			 */
> -			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
> +			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
>  				continue;
>  			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
>  			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 23b80c54aa60..373172e52287 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -1576,7 +1576,7 @@ xrep_dir_set_nlink(
>  	 * count.  If the directory has no parent, it will be moved to the
>  	 * orphanage.
>  	 */
> -	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, dp->i_ino));
> +	pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(dp));
>  	if (!pag) {
>  		ASSERT(0);
>  		return -EFSCORRUPTED;
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 9738b9ce3f2d..8a2bf263ca3b 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -2011,8 +2011,7 @@ xrep_inode_unlinked(
>  		struct xfs_perag	*pag;
>  		int			error;
>  
> -		pag = xfs_perag_get(sc->mp,
> -				XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
> +		pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(sc->ip));
>  		error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
>  		xfs_perag_put(pag);
>  		if (error)
> diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
> index 9049215c6eae..3767dba9f515 100644
> --- a/fs/xfs/scrub/nlinks_repair.c
> +++ b/fs/xfs/scrub/nlinks_repair.c
> @@ -75,7 +75,7 @@ xrep_nlinks_iunlink_remove(
>  	struct xfs_perag	*pag;
>  	int			error;
>  
> -	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
> +	pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(sc->ip));
>  	error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
>  	xfs_perag_put(pag);
>  	return error;
> diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
> index 2ce0cefad362..a5dc7dc65f98 100644
> --- a/fs/xfs/scrub/parent_repair.c
> +++ b/fs/xfs/scrub/parent_repair.c
> @@ -1451,7 +1451,7 @@ xrep_parent_set_nondir_nlink(
>  		 * The file is on the unlinked list but we found parents.
>  		 * Remove the file from the unlinked list.
>  		 */
> -		pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, ip->i_ino));
> +		pag = xfs_perag_get(sc->mp, XFS_INODE_TO_AGNO(ip));
>  		if (!pag) {
>  			ASSERT(0);
>  			return -EFSCORRUPTED;
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 286c5f5e0544..6c684e9433db 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -3473,7 +3473,7 @@ TRACE_EVENT(xrep_iunlink_reload_next,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(ip);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  		__entry->old_prev_agino = ip->i_prev_unlinked;
>  		__entry->prev_agino = prev_agino;
> @@ -3503,7 +3503,7 @@ TRACE_EVENT(xrep_iunlink_reload_ondisk,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(ip);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  		__entry->nlink = VFS_I(ip)->i_nlink;
>  		__entry->next_agino = ip->i_next_unlinked;
> @@ -3590,7 +3590,7 @@ TRACE_EVENT(xrep_iunlink_relink_next,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(ip);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  		__entry->next_agino = ip->i_next_unlinked;
>  		__entry->new_next_agino = next_agino;
> @@ -3616,7 +3616,7 @@ TRACE_EVENT(xrep_iunlink_relink_prev,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(ip);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  		__entry->prev_agino = ip->i_prev_unlinked;
>  		__entry->new_prev_agino = prev_agino;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2040a9292ee6..73f06bb13075 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -427,8 +427,7 @@ xfs_iget_check_free_state(
>  			xfs_warn(ip->i_mount,
>  "Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
>  				ip->i_ino, VFS_I(ip)->i_mode);
> -			xfs_agno_mark_sick(ip->i_mount,
> -					XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> +			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
>  					XFS_SICK_AG_INOBT);
>  			return -EFSCORRUPTED;
>  		}
> @@ -437,8 +436,7 @@ xfs_iget_check_free_state(
>  			xfs_warn(ip->i_mount,
>  "Corruption detected! Free inode 0x%llx has blocks allocated!",
>  				ip->i_ino);
> -			xfs_agno_mark_sick(ip->i_mount,
> -					XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> +			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
>  					XFS_SICK_AG_INOBT);
>  			return -EFSCORRUPTED;
>  		}
> @@ -1287,7 +1285,7 @@ xfs_blockgc_set_iflag(
>  	ip->i_flags |= iflag;
>  	spin_unlock(&ip->i_flags_lock);
>  
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  	spin_lock(&pag->pag_ici_lock);
>  
>  	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> @@ -1324,7 +1322,7 @@ xfs_blockgc_clear_iflag(
>  	if (!clear_tag)
>  		return;
>  
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  	spin_lock(&pag->pag_ici_lock);
>  
>  	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> @@ -1802,7 +1800,7 @@ xfs_icwalk_ag(
>  			 * us to see this inode, so another lookup from the
>  			 * same index will not find it again.
>  			 */
> -			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
> +			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
>  				continue;
>  			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
>  			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> @@ -1916,7 +1914,7 @@ xfs_inodegc_set_reclaimable(
>  		ASSERT(0);
>  	}
>  
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  	spin_lock(&pag->pag_ici_lock);
>  	spin_lock(&ip->i_flags_lock);
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index beaa26ec62da..8a25cefaa17f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1363,7 +1363,7 @@ xfs_inactive_health(
>  	if (sick & XFS_SICK_INO_FORGET)
>  		return;
>  
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  	if (!pag) {
>  		/* There had better still be a perag structure! */
>  		ASSERT(0);
> @@ -1802,7 +1802,7 @@ xfs_ifree(
>  	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
>  	ASSERT(ip->i_nblocks == 0);
>  
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  
>  	error = xfs_inode_uninit(tp, pag, ip, &xic);
>  	if (error)
> @@ -2311,8 +2311,7 @@ xfs_rename(
>  			struct xfs_perag	*pag;
>  			struct xfs_buf		*bp;
>  
> -			pag = xfs_perag_get(mp,
> -					XFS_INO_TO_AGNO(mp, inodes[i]->i_ino));
> +			pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(inodes[i]));
>  			error = xfs_read_agi(pag, tp, 0, &bp);
>  			xfs_perag_put(pag);
>  			if (error)
> @@ -2859,7 +2858,7 @@ xfs_inode_reload_unlinked_bucket(
>  	struct xfs_buf		*agibp;
>  	struct xfs_agi		*agi;
>  	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	xfs_agnumber_t		agno = XFS_INODE_TO_AGNO(ip);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		prev_agino, next_agino;
>  	unsigned int		bucket;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 1c098cfc5c00..cd8b85dac7a8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4529,7 +4529,7 @@ TRACE_EVENT(xfs_iunlink_reload_next,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(ip);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  		__entry->prev_agino = ip->i_prev_unlinked;
>  		__entry->next_agino = ip->i_next_unlinked;
> @@ -4552,7 +4552,7 @@ TRACE_EVENT(xfs_inode_reload_unlinked_bucket,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(ip);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  	),
>  	TP_printk("dev %d:%d agno 0x%x agino 0x%x bucket %u",
> @@ -4572,7 +4572,7 @@ DECLARE_EVENT_CLASS(xfs_ag_inode_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(ip);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  	),
>  	TP_printk("dev %d:%d agno 0x%x agino 0x%x",
> @@ -4769,8 +4769,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
>  	TP_fast_assign(
>  		__entry->dev = cur->bc_mp->m_super->s_dev;
>  		__assign_str(name);
> -		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
> -					cur->bc_ino.ip->i_ino);
> +		__entry->agno = XFS_INODE_TO_AGNO(cur->bc_ino.ip);
>  		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
>  					cur->bc_ino.ip->i_ino);
>  		__entry->levels = cur->bc_ino.ifake->if_levels;
> -- 
> 2.53.0
> 
> 
