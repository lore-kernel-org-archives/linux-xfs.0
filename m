Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99610249E5
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752680001; cv=none; b=fJN1FaJJ4kpj3jLKCTzS5cQxzMrnYeAEvrx4Rz9O8kNofevfPuF24qm1Z7WJ1Tn7IdapGXWlQqyOw58/R1//6aQ2ft6Ef5IZ1fsqaq/ES7+m4+tCTurgOOcA8hmn/Etoli1N8HDY11u9py+tPEjhr4M7gBWIvT4l3WrrQae69TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752680001; c=relaxed/simple;
	bh=IuzwP18gKoPY8LeCMeO9YT6cqlx1fHW5keAxYM1OaKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6RcWENnjqGRjJ4kgVsAwxKiqugU1U20UdbFhBpVffPU7NCn9iMseV05T+AIUEDKUTwL6bMHeEdkfMWBjloPVV67jpvKqG5ArFhi4JzlqXky+YCi6NgjXeiN1CpuIpKrukKod1wll/fewjCCcS3GBIFoiXdkX5j/Vr5KzlYc7oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkUHBBS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkUHBBS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2568AC4CEE7;
	Wed, 16 Jul 2025 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752680001;
	bh=IuzwP18gKoPY8LeCMeO9YT6cqlx1fHW5keAxYM1OaKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkUHBBS8Km4RKcMEmeEeTQdoEnlRe3p0r53IOyjZz+uOsI7IwBuD3BEJ7JaR/hJpV
	 +/Ba+uUR/8jsz7JxeX3J04nrSC0PNCS9hJbfxF4LruOJyy2zG63dbgLRGoEnSbL9DN
	 wqpFL3OG7esVn0i0teIyHe9VHZZ1GDtedS9BzFj2TjTBzbwPimvA8joMRucaXG8Eet
	 FdaEn/Qu2qMr4By6t5aBmOsKoY9Zlzn1C0etLfUmxre1mgda/9zZrtTVaulspcwlxr
	 meIYcsiamEpHYB5lQ0duxSCfI2uSewRQeleLhu+u8CyOLv17GM6IQJ2HUuFQPWziWA
	 MPxPKI9sCpVSg==
Date: Wed, 16 Jul 2025 08:33:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: remove xrep_trans_{alloc,cancel}_hook_dummy
Message-ID: <20250716153320.GF2672049@frogsfrogsfrogs>
References: <20250716124352.2146673-1-hch@lst.de>
 <20250716124352.2146673-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716124352.2146673-8-hch@lst.de>

On Wed, Jul 16, 2025 at 02:43:17PM +0200, Christoph Hellwig wrote:
> XFS stopped using current->journal_info in commit f2e812c1522d ("xfs:
> don't use current->journal_info"), so there is no point in saving and
> restoring it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Excellent <tents fingers>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/repair.c        | 28 ----------------------------
>  fs/xfs/scrub/repair.h        |  4 ----
>  fs/xfs/scrub/rmap_repair.c   | 10 +++-------
>  fs/xfs/scrub/rtrmap_repair.c | 10 +++-------
>  4 files changed, 6 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index f7f80ff32afc..d00c18954a26 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -1268,34 +1268,6 @@ xrep_setup_xfbtree(
>  	return xmbuf_alloc(sc->mp, descr, &sc->xmbtp);
>  }
>  
> -/*
> - * Create a dummy transaction for use in a live update hook function.  This
> - * function MUST NOT be called from regular repair code because the current
> - * process' transaction is saved via the cookie.
> - */
> -int
> -xrep_trans_alloc_hook_dummy(
> -	struct xfs_mount	*mp,
> -	void			**cookiep,
> -	struct xfs_trans	**tpp)
> -{
> -	*cookiep = current->journal_info;
> -	current->journal_info = NULL;
> -	*tpp = xfs_trans_alloc_empty(mp);
> -	return 0;
> -}
> -
> -/* Cancel a dummy transaction used by a live update hook function. */
> -void
> -xrep_trans_cancel_hook_dummy(
> -	void			**cookiep,
> -	struct xfs_trans	*tp)
> -{
> -	xfs_trans_cancel(tp);
> -	current->journal_info = *cookiep;
> -	*cookiep = NULL;
> -}
> -
>  /*
>   * See if this buffer can pass the given ->verify_struct() function.
>   *
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index af0a3a9e5ed9..9c04295742c8 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -180,10 +180,6 @@ int xrep_quotacheck(struct xfs_scrub *sc);
>  int xrep_reinit_pagf(struct xfs_scrub *sc);
>  int xrep_reinit_pagi(struct xfs_scrub *sc);
>  
> -int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
> -		struct xfs_trans **tpp);
> -void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
> -
>  bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
>  void xrep_inode_set_nblocks(struct xfs_scrub *sc, int64_t new_blocks);
>  int xrep_reset_metafile_resv(struct xfs_scrub *sc);
> diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
> index bf1e632b449a..17d4a38d735c 100644
> --- a/fs/xfs/scrub/rmap_repair.c
> +++ b/fs/xfs/scrub/rmap_repair.c
> @@ -1610,7 +1610,6 @@ xrep_rmapbt_live_update(
>  	struct xfs_mount		*mp;
>  	struct xfs_btree_cur		*mcur;
>  	struct xfs_trans		*tp;
> -	void				*txcookie;
>  	int				error;
>  
>  	rr = container_of(nb, struct xrep_rmap, rhook.rmap_hook.nb);
> @@ -1621,9 +1620,7 @@ xrep_rmapbt_live_update(
>  
>  	trace_xrep_rmap_live_update(pag_group(rr->sc->sa.pag), action, p);
>  
> -	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
> -	if (error)
> -		goto out_abort;
> +	tp = xfs_trans_alloc_empty(mp);
>  
>  	mutex_lock(&rr->lock);
>  	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, &rr->rmap_btree);
> @@ -1637,14 +1634,13 @@ xrep_rmapbt_live_update(
>  	if (error)
>  		goto out_cancel;
>  
> -	xrep_trans_cancel_hook_dummy(&txcookie, tp);
> +	xfs_trans_cancel(tp);
>  	mutex_unlock(&rr->lock);
>  	return NOTIFY_DONE;
>  
>  out_cancel:
>  	xfbtree_trans_cancel(&rr->rmap_btree, tp);
> -	xrep_trans_cancel_hook_dummy(&txcookie, tp);
> -out_abort:
> +	xfs_trans_cancel(tp);
>  	mutex_unlock(&rr->lock);
>  	xchk_iscan_abort(&rr->iscan);
>  out_unlock:
> diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
> index 4a56726d9952..7561941a337a 100644
> --- a/fs/xfs/scrub/rtrmap_repair.c
> +++ b/fs/xfs/scrub/rtrmap_repair.c
> @@ -844,7 +844,6 @@ xrep_rtrmapbt_live_update(
>  	struct xfs_mount		*mp;
>  	struct xfs_btree_cur		*mcur;
>  	struct xfs_trans		*tp;
> -	void				*txcookie;
>  	int				error;
>  
>  	rr = container_of(nb, struct xrep_rtrmap, rhook.rmap_hook.nb);
> @@ -855,9 +854,7 @@ xrep_rtrmapbt_live_update(
>  
>  	trace_xrep_rmap_live_update(rtg_group(rr->sc->sr.rtg), action, p);
>  
> -	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
> -	if (error)
> -		goto out_abort;
> +	tp = xfs_trans_alloc_empty(mp);
>  
>  	mutex_lock(&rr->lock);
>  	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, &rr->rtrmap_btree);
> @@ -871,14 +868,13 @@ xrep_rtrmapbt_live_update(
>  	if (error)
>  		goto out_cancel;
>  
> -	xrep_trans_cancel_hook_dummy(&txcookie, tp);
> +	xfs_trans_cancel(tp);
>  	mutex_unlock(&rr->lock);
>  	return NOTIFY_DONE;
>  
>  out_cancel:
>  	xfbtree_trans_cancel(&rr->rtrmap_btree, tp);
> -	xrep_trans_cancel_hook_dummy(&txcookie, tp);
> -out_abort:
> +	xfs_trans_cancel(tp);
>  	xchk_iscan_abort(&rr->iscan);
>  	mutex_unlock(&rr->lock);
>  out_unlock:
> -- 
> 2.47.2
> 
> 
