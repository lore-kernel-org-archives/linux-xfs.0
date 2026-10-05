Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B463337A496
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236873; cv=none; b=frPmwY/sAVscdNP4ak8BBMvab8YCgQ8McvCSVOoMyyGWkHAyzfMNyNnWu/rXQiIWxxCXATFwA6S52jC/Uylsbw0k8HTdQl5xSbzpzPTxbHYFHtvhcl8GVPLZZkAiql6hH+0QirRohcvwRhu3f6e48hQ6pt1MwL9jgGf3k9LRGeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236873; c=relaxed/simple;
	bh=/nDo2FT7vOTRFTGrUpeU7PA/t0ECJp5kcnY2QOHdQg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvLoAXzPK0Ay6253PgpMomDVKT0FqllVOhmHn4NIFKUqcwJi+TFHBZupriFqH3McQtIsUZrgfGITToMFYCe5piULWzVmX3fijm3y6UDqOBWReAbRRwx10uRdXXPqRkBe7DA7yGSC2KoKhjrsRo5QnTPfyb0BkSsZquTlnRCEmaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPMUg7Mg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPMUg7Mg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 398B21F000FF;
	Mon,  5 Oct 2026 21:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236872;
	bh=lUr1NDU2gVO24KXh9uTCbgxzC7Uar8wNa2tipI2tUn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hPMUg7MgWUlK2twwPqMMvpeX4Uw+dfh0zaHNSiW+A3y0dpBy9oqL3QnjoXeWTTm6q
	 eH59/O9yGrUu0lhAz5cscFlHsvKytnZdA6fk1TejzmeWG/LMeheRFStVYPK91bt9G1
	 gTwYG43m5LLahWHGdb9lv+FtSrlZtohQ7qCyBuw1ZdtiBlELMVJH90dWPle5pDA4ua
	 F5hC5Q0iv63faak8tKW+J+f51vWpoDktJYEzYX3vEKjCkPb5kxWPIVJL2/JudIvkc6
	 0QLmho75gBjxg4oJ9Aq4ClmWnyNlYtUlMLBSlWNOStMAUoPJoAponAC15DKfZTGgqO
	 F7fIxnj7g1f4A==
Date: Mon, 5 Oct 2026 14:47:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] libxfs: remove libxfs_trans_alloc_rollable
Message-ID: <20261005214751.GN2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-9-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:18PM +0200, Christoph Hellwig wrote:
> There is no real value in this userland-only wrapper.  Remove it and
> open code the calls, and switch to clearly better fitting transaction
> reservations where applicable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think that's fine.  Log reservations don't mean much of anything right
now in userspace, but in general it's a better idea to use the correct
reservation for the operation that's about to happen.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/stubs/xfs_trans.h |  2 --
>  libxfs/trans.c           | 15 ---------------
>  mkfs/proto.c             |  8 +++++---
>  mkfs/xfs_mkfs.c          |  3 ++-
>  repair/phase5.c          |  3 ++-
>  repair/phase6.c          |  3 ++-
>  repair/rmap.c            |  5 +++--
>  7 files changed, 14 insertions(+), 25 deletions(-)
> 
> diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
> index 1117aad80c2f..9e8737f09d8e 100644
> --- a/libxfs/stubs/xfs_trans.h
> +++ b/libxfs/stubs/xfs_trans.h
> @@ -88,8 +88,6 @@ int	libxfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
>  int	libxfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
>  			struct xfs_inode *ip, unsigned int *dblocks,
>  			struct xfs_trans **tpp, int *nospace_error);
> -int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
> -				    struct xfs_trans **tpp);
>  struct xfs_trans *libxfs_trans_alloc_empty(struct xfs_mount *mp);
>  int	libxfs_trans_commit(struct xfs_trans *);
>  void	libxfs_trans_cancel(struct xfs_trans *);
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index aa303288a81c..f36c54b9c806 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -306,21 +306,6 @@ libxfs_trans_alloc_empty(
>  	return __libxfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
>  }
>  
> -/*
> - * Allocate a transaction that can be rolled.  Since userspace doesn't have
> - * a need for log reservations, we really only tr_itruncate to get the
> - * permanent log reservation flag to avoid blowing asserts.
> - */
> -int
> -libxfs_trans_alloc_rollable(
> -	struct xfs_mount	*mp,
> -	unsigned int		blocks,
> -	struct xfs_trans	**tpp)
> -{
> -	return libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
> -			0, 0, tpp);
> -}
> -
>  void
>  libxfs_trans_cancel(
>  	struct xfs_trans	*tp)
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index bdd0fadda517..f17ed3b88112 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -161,7 +161,8 @@ getres(
>  	uint		r;
>  
>  	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
> -		i = -libxfs_trans_alloc_rollable(mp, r, &tp);
> +		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, r, 0, 0,
> +			&tp);
>  		if (i == 0)
>  			return tp;
>  	}
> @@ -251,7 +252,7 @@ rsvfile(
>  	/*
>  	 * update the inode timestamp, mode, and prealloc flag bits
>  	 */
> -	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
> +	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
>  	if (error)
>  		fail(_("allocating transaction for a file"), error);
>  	libxfs_trans_ijoin(tp, ip, 0);
> @@ -1037,7 +1038,8 @@ create_sb_metadata_file(
>  	xfs_ino_t		ino;
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
> +	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
> +			MKFS_BLOCKRES_INODE, 0, 0, &tp);
>  	if (error)
>  		res_failed(error);
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index aa87951db0d0..eb863827d19c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -5706,7 +5706,8 @@ initialise_ag_freespace(
>  	struct xfs_trans	*tp;
>  	int			c;
>  
> -	c = -libxfs_trans_alloc_rollable(mp, worst_freelist, &tp);
> +	c = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, worst_freelist,
> +			0, 0, &tp);
>  	if (c)
>  		res_failed(c);
>  
> diff --git a/repair/phase5.c b/repair/phase5.c
> index e44c26885717..4c67d049702b 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -610,7 +610,8 @@ inject_lost_extent(
>  	xfs_agblock_t		agbno;
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> +	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 16, 0, 0,
> +			&tp);
>  	if (error)
>  		return error;
>  
> diff --git a/repair/phase6.c b/repair/phase6.c
> index f3951a3d0709..f6f985a92541 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -507,7 +507,8 @@ mk_rtino(
>  		libxfs_rtginode_metafile_type(type);
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
> +	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 10, 0, 0,
> +			&tp);
>  	if (error)
>  		res_failed(error);
>  
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 55c2b0928c52..9f824f848edc 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -714,7 +714,8 @@ rmap_commit_agbtree_mappings(
>  		struct xfs_owner_info	oinfo = {};
>  		struct xfs_perag	*pag;
>  
> -		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> +		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 16, 0,
> +				0, &tp);
>  		if (error)
>  			goto err_slab;
>  
> @@ -1952,7 +1953,7 @@ fix_freelist(
>  	args.agno = agno;
>  	args.alignment = 1;
>  	args.pag = libxfs_perag_get(mp, agno);
> -	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
> +	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
>  	if (error)
>  		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
>  				agno, error);
> -- 
> 2.53.0
> 
> 
