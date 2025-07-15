Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393631DF258
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592692; cv=none; b=HareLHOwd/rJgAoJIN2Idx3GX1JbGQA4XE0DBNQRFhWy5vNUvPbKCiGc5Rbsf7Ha6E3KjRlLXfGoyxhn7gFTuYtgkXyuuT6lLkcEnsqWQ/zlvofLYEJd7p7brVN8C/BW2MW8uQ43ofDiDGf+tBPXDFw9lIdjaXpqxwzZjOBTw1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592692; c=relaxed/simple;
	bh=SRCTYH01HVmFBp+9Vu1myXJYVOXXOArtThJ/xIJCwc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8Vdk+F3k5eOHjbcPNivY4fuaa0eH4QDyP94ASEkA44Jajs3myhKGQDWpwa77TbWtPjPvIf1p+kiu95uwr0uPifsy695v6egSPEJYue67/b05GS/oqd+SycqWLXZdShz1zAq5b35GDsRtNu23ixXdLSkGdFEdLMB6LPAw8+ZLbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOB0hYEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOB0hYEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A833DC4CEE3;
	Tue, 15 Jul 2025 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752592691;
	bh=SRCTYH01HVmFBp+9Vu1myXJYVOXXOArtThJ/xIJCwc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uOB0hYEL9khl2I4yLH4rFBQzW13KIjppN05lllmFGPr9AxwCy+v5KfhLP5ORRVqfd
	 q7v/YNKFBbeRo6eX16yTFMXcZOwb0gwWOYShjz8qqGUZwEGjqSP/ScfA8mxWnskVS5
	 TvXWRHZCv1WWuODIuqpSIccR2MeaXbeDdrHGOjBV8GQ7MosLqJdSgQFeeXyJ4UKYXP
	 iNq/GQtc0+pI0RVwO9Lj0kD3L+Br5E+AhjShAAMUWWxCwx/VmwC1Fa5J16uB65dvzW
	 o90NewtAfB/J5gTPLhXEkaZTqiGzUpTTOd1W8HkuAdoLA72ApiT4nuW6px3rQUHnbZ
	 vDc+8SuQASOlw==
Date: Tue, 15 Jul 2025 08:18:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: return the allocated transaction from
 xrep_trans_alloc_hook_dummy
Message-ID: <20250715151811.GZ2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715122544.1943403-8-hch@lst.de>

On Tue, Jul 15, 2025 at 02:25:40PM +0200, Christoph Hellwig wrote:
> xrep_trans_alloc_hook_dummy can't return errors, so return the allocated
> transaction directly instead of an output double pointer argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/repair.c        | 8 +++-----
>  fs/xfs/scrub/repair.h        | 4 ++--
>  fs/xfs/scrub/rmap_repair.c   | 5 +----
>  fs/xfs/scrub/rtrmap_repair.c | 5 +----
>  4 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index f7f80ff32afc..79251c595e18 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -1273,16 +1273,14 @@ xrep_setup_xfbtree(
>   * function MUST NOT be called from regular repair code because the current
>   * process' transaction is saved via the cookie.
>   */
> -int
> +struct xfs_trans *
>  xrep_trans_alloc_hook_dummy(
>  	struct xfs_mount	*mp,
> -	void			**cookiep,
> -	struct xfs_trans	**tpp)
> +	void			**cookiep)
>  {
>  	*cookiep = current->journal_info;
>  	current->journal_info = NULL;

You could get rid of all this journal_info manipulation because xfs no
longer uses that to track the current transaction.

--D

> -	*tpp = xfs_trans_alloc_empty(mp);
> -	return 0;
> +	return xfs_trans_alloc_empty(mp);
>  }
>  
>  /* Cancel a dummy transaction used by a live update hook function. */
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index af0a3a9e5ed9..0a808e903cf5 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -180,8 +180,8 @@ int xrep_quotacheck(struct xfs_scrub *sc);
>  int xrep_reinit_pagf(struct xfs_scrub *sc);
>  int xrep_reinit_pagi(struct xfs_scrub *sc);
>  
> -int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
> -		struct xfs_trans **tpp);
> +struct xfs_trans *xrep_trans_alloc_hook_dummy(struct xfs_mount *mp,
> +		void **cookiep);
>  void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
>  
>  bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
> diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
> index bf1e632b449a..6024872a17e5 100644
> --- a/fs/xfs/scrub/rmap_repair.c
> +++ b/fs/xfs/scrub/rmap_repair.c
> @@ -1621,9 +1621,7 @@ xrep_rmapbt_live_update(
>  
>  	trace_xrep_rmap_live_update(pag_group(rr->sc->sa.pag), action, p);
>  
> -	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
> -	if (error)
> -		goto out_abort;
> +	tp = xrep_trans_alloc_hook_dummy(mp, &txcookie);
>  
>  	mutex_lock(&rr->lock);
>  	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, &rr->rmap_btree);
> @@ -1644,7 +1642,6 @@ xrep_rmapbt_live_update(
>  out_cancel:
>  	xfbtree_trans_cancel(&rr->rmap_btree, tp);
>  	xrep_trans_cancel_hook_dummy(&txcookie, tp);
> -out_abort:
>  	mutex_unlock(&rr->lock);
>  	xchk_iscan_abort(&rr->iscan);
>  out_unlock:
> diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
> index 4a56726d9952..5b8155c87873 100644
> --- a/fs/xfs/scrub/rtrmap_repair.c
> +++ b/fs/xfs/scrub/rtrmap_repair.c
> @@ -855,9 +855,7 @@ xrep_rtrmapbt_live_update(
>  
>  	trace_xrep_rmap_live_update(rtg_group(rr->sc->sr.rtg), action, p);
>  
> -	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
> -	if (error)
> -		goto out_abort;
> +	tp = xrep_trans_alloc_hook_dummy(mp, &txcookie);
>  
>  	mutex_lock(&rr->lock);
>  	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, &rr->rtrmap_btree);
> @@ -878,7 +876,6 @@ xrep_rtrmapbt_live_update(
>  out_cancel:
>  	xfbtree_trans_cancel(&rr->rtrmap_btree, tp);
>  	xrep_trans_cancel_hook_dummy(&txcookie, tp);
> -out_abort:
>  	xchk_iscan_abort(&rr->iscan);
>  	mutex_unlock(&rr->lock);
>  out_unlock:
> -- 
> 2.47.2
> 
> 
