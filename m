Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95F833A9CB
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779102379; cv=none; b=OxwLotPXKhg0mM8lUKRG4tkUzzP7rHHfVY8PbEbc/pBEo+Z9BJHTmW9HTvx7ZI8y8/pN8bORk0ngk6c7St41a9NZk9C2ObTpH1rsv/f9tJ0lcyB50twwsQX7TwPbpPb2oXzhporIlZveUoYc4xtPuUM4/qzky1NwM/MFZMRYqu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779102379; c=relaxed/simple;
	bh=xFcldxokdsbj7TUpvhV14vcpBdCAH3Jd6hUXoi1gpfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSRpoJOHtNcrN5kuxDIvbILEjU252/kld18EVrq78umXIGubqFE2XjVlyIB2zt8iS2/gr+NUlJJJPAAJD319jY2LybC4e4zKzdxLgYJXVRjgnLzGq6ZUa6mei3UhGfbeGZKE0O6bggLjMFJDZNPgjlcRnC6sk4uE5p9v1F4IM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGelwsV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGelwsV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59613C2BCB7;
	Mon, 18 May 2026 11:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779102378;
	bh=xFcldxokdsbj7TUpvhV14vcpBdCAH3Jd6hUXoi1gpfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WGelwsV9JHXVH+sLlCC1o0Ea2FdNindE62I+w7446jnATrt7wnWMGPXntJGzpUoZf
	 YndOBFQuQdymyTR49QXpL+p6bg6K6yHylN81MATPSE7JdkbfDN5HhkEbqxEJLByVa0
	 EQbyrN5zDZwemkIGTaDBLtb8LR4mhRbChZq4qTOaW4lksFT44G4uUu8Kwkyc5EjXOi
	 bCVps50JCzSQg8qtMD5A0utdGmvHStZXf2GHwl42JYenfUBHoFkba6C8yOKzONdItW
	 hHSCGI/Aqv9d3a+YPb4m7BJ/ZBSjpPMJOtIVURdwQie5RZZzOBB3V3jaD6BUCsl8V5
	 RlGlssoe4e33A==
Date: Mon, 18 May 2026 13:06:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: add a XFS_INO_TO_FSB helper
Message-ID: <agryn78GC597GYdq@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-4-hch@lst.de>

On Fri, May 15, 2026 at 03:50:24PM +0200, Christoph Hellwig wrote:
> Add a shortcut for the common XFS_INO_TO_FSB(mp, ip->i_ino) pattern.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c   | 8 +++-----
>  fs/xfs/libxfs/xfs_btree.c  | 6 ++----
>  fs/xfs/libxfs/xfs_format.h | 2 ++
>  fs/xfs/scrub/cow_repair.c  | 3 +--
>  fs/xfs/scrub/newbt.c       | 6 ++----
>  fs/xfs/scrub/trace.c       | 2 +-
>  6 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7a4c8f1aa76c..a11a8aee5b79 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -681,8 +681,7 @@ xfs_bmap_extents_to_btree(
>  	args.minlen = args.maxlen = args.prod = 1;
>  	args.wasdel = wasdel;
>  	*logflagsp = 0;
> -	error = xfs_alloc_vextent_start_ag(&args,
> -				XFS_INO_TO_FSB(mp, ip->i_ino));
> +	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
>  	if (error)
>  		goto out_root_realloc;
>  
> @@ -828,8 +827,7 @@ xfs_bmap_local_to_extents(
>  	 */
>  	args.total = total;
>  	args.minlen = args.maxlen = args.prod = 1;
> -	error = xfs_alloc_vextent_start_ag(&args,
> -			XFS_INO_TO_FSB(args.mp, ip->i_ino));
> +	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
>  	if (error)
>  		goto done;
>  
> @@ -3590,7 +3588,7 @@ xfs_bmap_btalloc_best_length(
>  	xfs_extlen_t		blen = 0;
>  	int			error;
>  
> -	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
> +	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
>  	if (!xfs_bmap_adjacent(ap))
>  		ap->eof = false;
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 7012f3570c8d..71d65f2fa005 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -3243,8 +3243,7 @@ xfs_btree_new_iroot(
>  	if (level > 0)
>  		aptr = *xfs_btree_ptr_addr(cur, 1, block);
>  	else
> -		aptr.l = cpu_to_be64(XFS_INO_TO_FSB(cur->bc_mp,
> -				cur->bc_ino.ip->i_ino));
> +		aptr.l = cpu_to_be64(XFS_INODE_TO_FSB(cur->bc_ino.ip));
>  
>  	/* Allocate the new block. If we can't do it, we're toast. Give up. */
>  	error = xfs_btree_alloc_block(cur, &aptr, &nptr, stat);
> @@ -5609,8 +5608,7 @@ xfs_btree_alloc_metafile_block(
>  	ASSERT(xfs_is_metadir_inode(ip));
>  
>  	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
> -	error = xfs_alloc_vextent_start_ag(&args,
> -			XFS_INO_TO_FSB(cur->bc_mp, ip->i_ino));
> +	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
>  	if (error)
>  		return error;
>  	if (args.fsbno == NULLFSBLOCK) {
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f812c6782492..9886af0507e3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1289,6 +1289,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
>  	((int)(i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
>  #define	XFS_INO_TO_FSB(mp,i)		\
>  	XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
> +#define	XFS_INODE_TO_FSB(ip)		\
> +	XFS_INO_TO_FSB((ip)->i_mount, (ip)->i_ino)
>  #define	XFS_AGINO_TO_INO(mp,a,i)	\
>  	(((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
>  #define	XFS_AGINO_TO_AGBNO(mp,i)	((i) >> XFS_INO_OFFSET_BITS(mp))
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index bffc4666ce60..7b36b87f2c1a 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -426,8 +426,7 @@ xrep_cow_alloc(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_vextent_start_ag(&args,
> -			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino));
> +	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(sc->ip));
>  	if (error)
>  		return error;
>  	if (args.fsbno == NULLFSBLOCK)
> diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
> index 2e4981c1baf2..6ab0eff7d2ea 100644
> --- a/fs/xfs/scrub/newbt.c
> +++ b/fs/xfs/scrub/newbt.c
> @@ -123,8 +123,7 @@ xrep_newbt_init_inode(
>  	if (!ifp)
>  		return -ENOMEM;
>  
> -	xrep_newbt_init_ag(xnr, sc, oinfo,
> -			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
> +	xrep_newbt_init_ag(xnr, sc, oinfo, XFS_INODE_TO_FSB(sc->ip),
>  			XFS_AG_RESV_NONE);
>  	xnr->ifake.if_fork = ifp;
>  	xnr->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, whichfork);
> @@ -160,8 +159,7 @@ xrep_newbt_init_metadir_inode(
>  	 * as if they were regular file blocks.  This exposes us to a higher
>  	 * risk of the repair being cancelled due to ENOSPC.
>  	 */
> -	xrep_newbt_init_ag(xnr, sc, &oinfo,
> -			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
> +	xrep_newbt_init_ag(xnr, sc, &oinfo, XFS_INODE_TO_FSB(sc->ip),
>  			XFS_AG_RESV_NONE);
>  	xnr->ifake.if_fork = ifp;
>  	xnr->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, XFS_DATA_FORK);
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index 70d353287993..e5efc680651f 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -48,7 +48,7 @@ xchk_btree_cur_fsbno(
>  
>  	if (level == cur->bc_nlevels - 1 &&
>  	    cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
> -		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
> +		return XFS_INODE_TO_FSB(cur->bc_ino.ip);
>  
>  	return NULLFSBLOCK;
>  }
> -- 
> 2.53.0
> 
> 
