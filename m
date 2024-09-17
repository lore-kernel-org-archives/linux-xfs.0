Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14B352F88
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726599056; cv=none; b=Ag4tb9yGXdhKxrJNWhL7JNyxXPuCkOhfr2jaga4I7Bk7tFlpT/j3uwfwJV8GuAtsb2VR3MzpNDrPL4dyUucLK94toRRgCpjUrwTpHAnzYBNuXGRxL5S6KEHzsrS2szJeHcJaA4ZCD7j2YCHW5c7QUokZ6Y8M8PrrW0rec5X8D6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726599056; c=relaxed/simple;
	bh=+r8GOcTid/TsmmMr4dyfxZgNZEFihlsYj+opPpyOHKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6/+l4qkWSvwkUwHGCorhPDb+sKlVjPI16mVcj9r2QW/u+OcxtDWZyJoawoGgzWKvv3TVXkN6SHcXtDaeaiuOVaDCfu1W/FJchgvj5OmajD/3vl0dDV6avEBFriNL53XFB2ITs2mb5puww6faUn016Jt/cnp7BEXvSkexjZ//YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RpyMbVUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RpyMbVUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8832CC4CEC5;
	Tue, 17 Sep 2024 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726599055;
	bh=+r8GOcTid/TsmmMr4dyfxZgNZEFihlsYj+opPpyOHKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RpyMbVUyzkCVJ8lSuA7bdCscmvG0rkkyoflQ172QouXa2qXWLTkwTZsEhtO981PTR
	 7QquosiTcZInnn7rgrKTRQG4O5MQQLDynfurSwEEyWzsHnfLiVcpN+XOP5pSJsQCCd
	 v/SZS9fmzZLAoES8S/XpnZqWK5ia3dNd6m6tV1WWCqOMIm2x3+JRUHDudO7ZjjR+mN
	 bfkGYsN84X3Jj+s6yifl0HN8i6t/ELA18KQxq7zAu7RKHNM1JCD2YVg35Jy774kQAZ
	 mCjfNC5UxOUQetZIXhmkm/tc6YD4SGX8YARiCIwcJbwsHL8VTwf0sq9dsuB27oeJJf
	 yK3Zufgu2U5rA==
Date: Tue, 17 Sep 2024 11:50:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <20240917185054.GK182194@frogsfrogsfrogs>
References: <20240910042855.3480387-1-hch@lst.de>
 <20240910042855.3480387-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910042855.3480387-2-hch@lst.de>

On Tue, Sep 10, 2024 at 07:28:44AM +0300, Christoph Hellwig wrote:
> Currently only the new agcount is passed to xfs_initialize_perag, which
> requires lookups of existing AGs to skip them and complicates error
> handling.  Also pass the previous agcount so that the range that
> xfs_initialize_perag operates on is exactly defined.  That way the
> extra lookups can be avoided, and error handling can clean up the
> exact range from the old count to the last added perag structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ag.c   | 23 +++++------------------
>  fs/xfs/libxfs/xfs_ag.h   |  5 +++--
>  fs/xfs/xfs_fsops.c       | 18 ++++++++----------
>  fs/xfs/xfs_log_recover.c |  5 +++--
>  fs/xfs/xfs_mount.c       |  4 ++--
>  5 files changed, 21 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 5f0494702e0b55..5186735da5d45a 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -296,27 +296,19 @@ xfs_free_unused_perag_range(
>  int
>  xfs_initialize_perag(
>  	struct xfs_mount	*mp,
> +	xfs_agnumber_t		old_agcount,
>  	xfs_agnumber_t		agcount,

Might want to rename this new_agcount for clarity?

Otherwise looks pretty straightforward to me, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	xfs_rfsblock_t		dblocks,
>  	xfs_agnumber_t		*maxagi)
>  {
>  	struct xfs_perag	*pag;
>  	xfs_agnumber_t		index;
> -	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
>  	int			error;
>  
> -	/*
> -	 * Walk the current per-ag tree so we don't try to initialise AGs
> -	 * that already exist (growfs case). Allocate and insert all the
> -	 * AGs we don't find ready for initialisation.
> -	 */
> -	for (index = 0; index < agcount; index++) {
> -		pag = xfs_perag_get(mp, index);
> -		if (pag) {
> -			xfs_perag_put(pag);
> -			continue;
> -		}
> +	if (old_agcount >= agcount)
> +		return 0;
>  
> +	for (index = old_agcount; index < agcount; index++) {
>  		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!pag) {
>  			error = -ENOMEM;
> @@ -353,10 +345,6 @@ xfs_initialize_perag(
>  		/* Active ref owned by mount indicates AG is online. */
>  		atomic_set(&pag->pag_active_ref, 1);
>  
> -		/* first new pag is fully initialized */
> -		if (first_initialised == NULLAGNUMBER)
> -			first_initialised = index;
> -
>  		/*
>  		 * Pre-calculated geometry
>  		 */
> @@ -381,8 +369,7 @@ xfs_initialize_perag(
>  out_free_pag:
>  	kfree(pag);
>  out_unwind_new_pags:
> -	/* unwind any prior newly initialized pags */
> -	xfs_free_unused_perag_range(mp, first_initialised, agcount);
> +	xfs_free_unused_perag_range(mp, old_agcount, index);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index d9cccd093b60e0..69fc31e7b84728 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -146,8 +146,9 @@ __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
>  
>  void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
>  			xfs_agnumber_t agend);
> -int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
> -			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
> +int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
> +		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
> +		xfs_agnumber_t *maxagi);
>  int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
>  void xfs_free_perag(struct xfs_mount *mp);
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 3643cc843f6271..de2bf0594cb474 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -87,6 +87,7 @@ xfs_growfs_data_private(
>  	struct xfs_mount	*mp,		/* mount point for filesystem */
>  	struct xfs_growfs_data	*in)		/* growfs data input struct */
>  {
> +	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
>  	struct xfs_buf		*bp;
>  	int			error;
>  	xfs_agnumber_t		nagcount;
> @@ -94,7 +95,6 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		nb, nb_div, nb_mod;
>  	int64_t			delta;
>  	bool			lastag_extended = false;
> -	xfs_agnumber_t		oagcount;
>  	struct xfs_trans	*tp;
>  	struct aghdr_init_data	id = {};
>  	struct xfs_perag	*last_pag;
> @@ -138,16 +138,14 @@ xfs_growfs_data_private(
>  	if (delta == 0)
>  		return 0;
>  
> -	oagcount = mp->m_sb.sb_agcount;
> -	/* allocate the new per-ag structures */
> -	if (nagcount > oagcount) {
> -		error = xfs_initialize_perag(mp, nagcount, nb, &nagimax);
> -		if (error)
> -			return error;
> -	} else if (nagcount < oagcount) {
> -		/* TODO: shrinking the entire AGs hasn't yet completed */
> +	/* TODO: shrinking the entire AGs hasn't yet completed */
> +	if (nagcount < oagcount)
>  		return -EINVAL;
> -	}
> +
> +	/* allocate the new per-ag structures */
> +	error = xfs_initialize_perag(mp, oagcount, nagcount, nb, &nagimax);
> +	if (error)
> +		return error;
>  
>  	if (delta > 0)
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1a74fe22672e3e..2af02b32f419c2 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3346,6 +3346,7 @@ xlog_do_recover(
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_buf		*bp = mp->m_sb_bp;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> +	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
>  	int			error;
>  
>  	trace_xfs_log_recover(log, head_blk, tail_blk);
> @@ -3393,8 +3394,8 @@ xlog_do_recover(
>  	/* re-initialise in-core superblock and geometry structures */
>  	mp->m_features |= xfs_sb_version_to_features(sbp);
>  	xfs_reinit_percpu_counters(mp);
> -	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
> -			&mp->m_maxagi);
> +	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
> +			sbp->sb_dblocks, &mp->m_maxagi);
>  	if (error) {
>  		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
>  		return error;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 460f93a9ce00d1..0f4f56a7f02d9a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -806,8 +806,8 @@ xfs_mountfs(
>  	/*
>  	 * Allocate and initialize the per-ag data.
>  	 */
> -	error = xfs_initialize_perag(mp, sbp->sb_agcount, mp->m_sb.sb_dblocks,
> -			&mp->m_maxagi);
> +	error = xfs_initialize_perag(mp, 0, sbp->sb_agcount,
> +			mp->m_sb.sb_dblocks, &mp->m_maxagi);
>  	if (error) {
>  		xfs_warn(mp, "Failed per-ag init: %d", error);
>  		goto out_free_dir;
> -- 
> 2.45.2
> 
> 
