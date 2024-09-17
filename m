Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E1752F88
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726599357; cv=none; b=XvsdNR4Rr8IWb78mYU3skqErlMM0qDGnvFuh4H0ZxJ/sC/v0c9I1HBvoSux4n8IGCQR3bT01v5t1JPtejRPC8WlOysOvBo07zqKlvQjxEM9obuo1ybGm1Dwy/qCmdbsjTrt6TAhdchiMu1qbPTUCawv6zQ+mZ6p5ZL4AOUzUSok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726599357; c=relaxed/simple;
	bh=UjQ57yU2vUD/YTSvs/9uOxnuqz6Ap9ZQ5ncmabX0u/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DO1uO1aNudKTuSrk84u1zJUys8qq8FZsxYmtdVH4W7OAOxDrcH3RqcWBwz/emIQPoOp8rS3BLU50vBqCDfiTCiyqyWStiHzqoEFNBYCz3i44PJtZMOQQsCmo3iboR897WkKXL7aS+77yWr2a3YWkR5Th3EKPC2wxhlxoPRH9wkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LekCbmCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LekCbmCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE93CC4CEC5;
	Tue, 17 Sep 2024 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726599356;
	bh=UjQ57yU2vUD/YTSvs/9uOxnuqz6Ap9ZQ5ncmabX0u/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LekCbmCr1AnyU4iEKk7Laz+gFqN/nIYyNxATguC4jKKO+FAF4qijB/mxA6nHQJTkb
	 eC0jVnQt3JEP4Z3YpO4DPvKG0nopMjXx6gGI+ue9ROZ6aXPqTmFLYOXwilkh67wUCu
	 mBPJlGIxpNj2CUqpWruONJt2TFH5dNS8UKKLX1FfAvxJxE21S+p+NbZAplDlZGfe6X
	 IE5DquHoj9MJ3sZBt3KsTF8bmxDfitwD4AbXqmIXmWn2xrYa5IZOG2C2ljoRMS+cRT
	 BAUMHSrcpMl6W7FrddOQyHEaKdYFMfS12kOJpppQ/7ccxguAb0qfSEf+7YCKwCRoz/
	 Po759jpaql4SA==
Date: Tue, 17 Sep 2024 11:55:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: merge the perag freeing helpers
Message-ID: <20240917185556.GL182194@frogsfrogsfrogs>
References: <20240910042855.3480387-1-hch@lst.de>
 <20240910042855.3480387-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910042855.3480387-3-hch@lst.de>

On Tue, Sep 10, 2024 at 07:28:45AM +0300, Christoph Hellwig wrote:
> There is no good reason to have two different routines for freeing perag
> structures for the unmount and error cases.  Add two arguments to specify
> the range of AGs to free to xfs_free_perag, and use that to replace
> xfs_free_unused_perag_range.
> 
> The addition RCU grace period for the error case is harmless, and the
> extra check for the AG to actually exist is not required now that the
> callers pass the exact known allocated range.

And I guess the extra xfs_perag_rele is ok because xfs_initialize_perag
sets it to 1 and the _unused free function didn't care what the active
refcount was?

If the answer is yes then I've understood this enough to say
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 40 ++++++++++------------------------------
>  fs/xfs/libxfs/xfs_ag.h |  5 ++---
>  fs/xfs/xfs_fsops.c     |  2 +-
>  fs/xfs/xfs_mount.c     |  5 ++---
>  4 files changed, 15 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 5186735da5d45a..3f695100d7ab58 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -185,17 +185,20 @@ xfs_initialize_perag_data(
>  }
>  
>  /*
> - * Free up the per-ag resources associated with the mount structure.
> + * Free up the per-ag resources  within the specified AG range.
>   */
>  void
> -xfs_free_perag(
> -	struct xfs_mount	*mp)
> +xfs_free_perag_range(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		first_agno,
> +	xfs_agnumber_t		end_agno)
> +
>  {
> -	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xa_erase(&mp->m_perags, agno);
> +	for (agno = first_agno; agno < end_agno; agno++) {
> +		struct xfs_perag	*pag = xa_erase(&mp->m_perags, agno);
> +
>  		ASSERT(pag);
>  		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
>  		xfs_defer_drain_free(&pag->pag_intents_drain);
> @@ -270,29 +273,6 @@ xfs_agino_range(
>  	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
>  }
>  
> -/*
> - * Free perag within the specified AG range, it is only used to free unused
> - * perags under the error handling path.
> - */
> -void
> -xfs_free_unused_perag_range(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agstart,
> -	xfs_agnumber_t		agend)
> -{
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		index;
> -
> -	for (index = agstart; index < agend; index++) {
> -		pag = xa_erase(&mp->m_perags, index);
> -		if (!pag)
> -			break;
> -		xfs_buf_cache_destroy(&pag->pag_bcache);
> -		xfs_defer_drain_free(&pag->pag_intents_drain);
> -		kfree(pag);
> -	}
> -}
> -
>  int
>  xfs_initialize_perag(
>  	struct xfs_mount	*mp,
> @@ -369,7 +349,7 @@ xfs_initialize_perag(
>  out_free_pag:
>  	kfree(pag);
>  out_unwind_new_pags:
> -	xfs_free_unused_perag_range(mp, old_agcount, index);
> +	xfs_free_perag_range(mp, old_agcount, index);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 69fc31e7b84728..6e68d6a3161a0f 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -144,13 +144,12 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
>  __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
>  __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
>  
> -void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
> -			xfs_agnumber_t agend);
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
>  		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
>  		xfs_agnumber_t *maxagi);
> +void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
> +		xfs_agnumber_t end_agno);
>  int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
> -void xfs_free_perag(struct xfs_mount *mp);
>  
>  /* Passive AG references */
>  struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index de2bf0594cb474..b247d895c276d2 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -229,7 +229,7 @@ xfs_growfs_data_private(
>  	xfs_trans_cancel(tp);
>  out_free_unused_perag:
>  	if (nagcount > oagcount)
> -		xfs_free_unused_perag_range(mp, oagcount, nagcount);
> +		xfs_free_perag_range(mp, oagcount, nagcount);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 0f4f56a7f02d9a..6671ee3849c239 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1044,7 +1044,7 @@ xfs_mountfs(
>  		xfs_buftarg_drain(mp->m_logdev_targp);
>  	xfs_buftarg_drain(mp->m_ddev_targp);
>   out_free_perag:
> -	xfs_free_perag(mp);
> +	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
>   out_free_dir:
>  	xfs_da_unmount(mp);
>   out_remove_uuid:
> @@ -1125,8 +1125,7 @@ xfs_unmountfs(
>  	xfs_errortag_clearall(mp);
>  #endif
>  	shrinker_free(mp->m_inodegc_shrinker);
> -	xfs_free_perag(mp);
> -
> +	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
>  	xfs_errortag_del(mp);
>  	xfs_error_sysfs_del(mp);
>  	xchk_stats_unregister(mp->m_scrub_stats);
> -- 
> 2.45.2
> 
> 
