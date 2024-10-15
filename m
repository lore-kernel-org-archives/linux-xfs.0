Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4401C07FF
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997796; cv=none; b=Pr6oS1F6hfSHr0anIy65niLalgGKZO7Pr5yQK6Uca+Eqn3hTumOrcOKoO5S2geX3YXV00SxBipx2yNBLKduR/la6W1e4HCtxktMQW6w2hD+vGU/VFKcMMbioAbB4prXLZx8DPYaNhrtu9/fFWeiT91pQDx3KqTt5BVDrORkS6FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997796; c=relaxed/simple;
	bh=81+7FOq4Lu0bxygfuqOlhkFKVZloYdbNBX1TwjQdl8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLobYe2VMGCzGtlCSUisLBjqyl1CCnjqhxVFytxwjp/UvnGfeMzjfPZJePK4sbjDGMbkg2N4aUiCMUJmTLYyEMXYr3qTWFbBredq4FcCy89ycXtt4AyRWzMI/8ic0E7pTy0po2iINNgjZe9v6hnsTjyt8i9jSIWxq4vJJf6i/sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bbvi51bh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbvi51bh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728997793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UHUZxmGmBjJPdKXrJ0dwueH9EgjdUJFoWEqIyMAxTo4=;
	b=bbvi51bh2C1U9/oLqFQXvOpTlBK6wpwUZIwKc+sXoKDY1+xdm+UTLdeRl1HDCZK71jiyTt
	5FeL78eTE40OqmwYRAA4PnISroyRzjCPME34t8YpY0+xkeIEf/NLmXBuMw4vgSnJEV+u7h
	whhVLZRtkaNq13xemvbs/udwreSUkY8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-TCiDL55BOniJ7uxVbTXwqw-1; Tue,
 15 Oct 2024 09:09:47 -0400
X-MC-Unique: TCiDL55BOniJ7uxVbTXwqw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5190E1955F3C;
	Tue, 15 Oct 2024 13:09:46 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.74])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F65C19560A3;
	Tue, 15 Oct 2024 13:09:45 +0000 (UTC)
Date: Tue, 15 Oct 2024 09:11:06 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <Zw5p6k_R99zbj26a@bfoster>
References: <20241014060516.245606-1-hch@lst.de>
 <20241014060516.245606-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014060516.245606-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Oct 14, 2024 at 08:04:50AM +0200, Christoph Hellwig wrote:
> Currently only the new agcount is passed to xfs_initialize_perag, which
> requires lookups of existing AGs to skip them and complicates error
> handling.  Also pass the previous agcount so that the range that
> xfs_initialize_perag operates on is exactly defined.  That way the
> extra lookups can be avoided, and error handling can clean up the
> exact range from the old count to the last added perag structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c   | 28 ++++++----------------------
>  fs/xfs/libxfs/xfs_ag.h   |  5 +++--
>  fs/xfs/xfs_fsops.c       | 18 ++++++++----------
>  fs/xfs/xfs_log_recover.c |  5 +++--
>  fs/xfs/xfs_mount.c       |  4 ++--
>  5 files changed, 22 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 5f0494702e0b55..464f682eab4690 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -296,27 +296,16 @@ xfs_free_unused_perag_range(
>  int
>  xfs_initialize_perag(
>  	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agcount,
> +	xfs_agnumber_t		old_agcount,
> +	xfs_agnumber_t		new_agcount,

What happened to using first/end or whatever terminology here like is
done in one of the later patches? I really find old/new unnecessarily
confusing in this context.

Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> -
> +	for (index = old_agcount; index < new_agcount; index++) {
>  		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!pag) {
>  			error = -ENOMEM;
> @@ -353,21 +342,17 @@ xfs_initialize_perag(
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
> -		pag->block_count = __xfs_ag_block_count(mp, index, agcount,
> +		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
>  				dblocks);
>  		pag->min_block = XFS_AGFL_BLOCK(mp);
>  		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
>  				&pag->agino_max);
>  	}
>  
> -	index = xfs_set_inode_alloc(mp, agcount);
> +	index = xfs_set_inode_alloc(mp, new_agcount);
>  
>  	if (maxagi)
>  		*maxagi = index;
> @@ -381,8 +366,7 @@ xfs_initialize_perag(
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
> index d6a3ff24c327c3..60d46338f51792 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3346,6 +3346,7 @@ xlog_do_recover(
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_buf		*bp = mp->m_sb_bp;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> +	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
>  	int			error;
>  
>  	trace_xfs_log_recover(log, head_blk, tail_blk);
> @@ -3393,8 +3394,8 @@ xlog_do_recover(
>  	/* re-initialise in-core superblock and geometry structures */
>  	mp->m_features |= xfs_sb_version_to_features(sbp);
>  	xfs_reinit_percpu_counters(mp);
> -	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
> -			&mp->m_maxagi);
> +	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
> +			sbp->sb_dblocks, &mp->m_maxagi);
>  	if (error) {
>  		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
>  		return error;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1fdd79c5bfa04e..6fa7239a4a01b6 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -810,8 +810,8 @@ xfs_mountfs(
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

