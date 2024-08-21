Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A913B28D
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724256276; cv=none; b=YZw4EZGeI0UMSMArcMRRxj9hwO4IthC/PU57e3rN+Lu5fpIlElcqmGfzJNJlF/ZxTuGP4wpBposvLVYQg2Fgnh25RvRdE5s6Bk9+7Jwrt9Sabg2Gkg0OrViQKinfy62TCAr52frmkN61wZNC6fqyx0gvdSZAmUrDtGue6UORNyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724256276; c=relaxed/simple;
	bh=S1TmoLpGmAvx1783mtPjFOCXwVV1glg6q/q3CX5xUqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ercpUCPn7/VVLs6/5IG6LORj4jHCx9wKCgajqFFiw6IPzjDxnyFEzwuYW5kL6kw+hamgsQDOCTe3kkh1u8TIhQMrpYFvQamotRtxv8eCFO2Ce/wsrcd3Ki530UjTf2KkDaBKdMwBBbmOumnsiokzvjYLmJTu4vPbdUb33ip6Z0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYqAhUru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYqAhUru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E9EC4AF13;
	Wed, 21 Aug 2024 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724256275;
	bh=S1TmoLpGmAvx1783mtPjFOCXwVV1glg6q/q3CX5xUqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aYqAhUruxKy7Pks6uG3f9Rc4HSbfmu7KFy/Wer64j1WO5pGDDKWWni2DEprAcUV9+
	 0wswvYpcSqbwwbzoef+hbDK54Qm8farVV+2Sr9bTVmuBG0KgTY7Qse8wqPRDhnDxIV
	 Dpbm/C/sAB4X4Th81Ht4EjFDa6B0DljM7bg1l7eokiGRznijYC0D3mhEuBSXpUBXlQ
	 rk2vo8naKXNaH+VpZRFJqozr5V8N+0G7Wg0ncT1RxKcVqzDp2Aw4gqtQUCjCAhAAQ3
	 ytPe4NWpLh4MHQAgjs3t5IXjpMLSLtqqCbKr6oIHdEWcjgsI4N4FceCyxtjTYemtl0
	 L4Lz9HU1PIBdw==
Date: Wed, 21 Aug 2024 09:04:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: call xfs_bmap_exact_minlen_extent_alloc from
 xfs_bmap_btalloc
Message-ID: <20240821160434.GZ865349@frogsfrogsfrogs>
References: <20240820170517.528181-1-hch@lst.de>
 <20240820170517.528181-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170517.528181-6-hch@lst.de>

On Tue, Aug 20, 2024 at 07:04:56PM +0200, Christoph Hellwig wrote:
> xfs_bmap_exact_minlen_extent_alloc duplicates the args setup in
> xfs_bmap_btalloc.  Switch to call it from xfs_bmap_btalloc after
> doing the basic setup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

AFAICT this looks good, though it might be useful to get an ack from
Chandan since he wrote the minlen allocator and might know about any
weird subtleties.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 61 +++++++++-------------------------------
>  1 file changed, 13 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1db9d084a44c47..b5eeaea164ee46 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3471,28 +3471,17 @@ xfs_bmap_process_allocated_extent(
>  #ifdef DEBUG
>  static int
>  xfs_bmap_exact_minlen_extent_alloc(
> -	struct xfs_bmalloca	*ap)
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args)
>  {
> -	struct xfs_mount	*mp = ap->ip->i_mount;
> -	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
> -	xfs_fileoff_t		orig_offset;
> -	xfs_extlen_t		orig_length;
> -	int			error;
> -
> -	ASSERT(ap->length);
> -
>  	if (ap->minlen != 1) {
> -		ap->blkno = NULLFSBLOCK;
> -		ap->length = 0;
> +		args->fsbno = NULLFSBLOCK;
>  		return 0;
>  	}
>  
> -	orig_offset = ap->offset;
> -	orig_length = ap->length;
> -
> -	args.alloc_minlen_only = 1;
> -
> -	xfs_bmap_compute_alignments(ap, &args);
> +	args->alloc_minlen_only = 1;
> +	args->minlen = args->maxlen = ap->minlen;
> +	args->total = ap->total;
>  
>  	/*
>  	 * Unlike the longest extent available in an AG, we don't track
> @@ -3502,33 +3491,9 @@ xfs_bmap_exact_minlen_extent_alloc(
>  	 * we need not be concerned about a drop in performance in
>  	 * "debug only" code paths.
>  	 */
> -	ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
> +	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
>  
> -	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> -	args.minlen = args.maxlen = ap->minlen;
> -	args.total = ap->total;
> -
> -	args.alignment = 1;
> -	args.minalignslop = 0;
> -
> -	args.minleft = ap->minleft;
> -	args.wasdel = ap->wasdel;
> -	args.resv = XFS_AG_RESV_NONE;
> -	args.datatype = ap->datatype;
> -
> -	error = xfs_alloc_vextent_first_ag(&args, ap->blkno);
> -	if (error)
> -		return error;
> -
> -	if (args.fsbno != NULLFSBLOCK) {
> -		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
> -			orig_length);
> -	} else {
> -		ap->blkno = NULLFSBLOCK;
> -		ap->length = 0;
> -	}
> -
> -	return 0;
> +	return xfs_alloc_vextent_first_ag(args, ap->blkno);
>  }
>  #else
>  
> @@ -3792,8 +3757,11 @@ xfs_bmap_btalloc(
>  	/* Trim the allocation back to the maximum an AG can fit. */
>  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
>  
> -	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> -	    xfs_inode_is_filestream(ap->ip))
> +	if (unlikely(XFS_TEST_ERROR(false, mp,
> +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +		error = xfs_bmap_exact_minlen_extent_alloc(ap, &args);
> +	else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> +			xfs_inode_is_filestream(ap->ip))
>  		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
>  	else
>  		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
> @@ -4208,9 +4176,6 @@ xfs_bmapi_allocate(
>  	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
>  	    XFS_IS_REALTIME_INODE(bma->ip))
>  		error = xfs_bmap_rtalloc(bma);
> -	else if (unlikely(XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> -		error = xfs_bmap_exact_minlen_extent_alloc(bma);
>  	else
>  		error = xfs_bmap_btalloc(bma);
>  	if (error)
> -- 
> 2.43.0
> 
> 
