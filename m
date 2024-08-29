Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F12189BBE
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724966698; cv=none; b=QAQ/XP/iwysAlKuVjXA0CMF4qJEhhglHB6DOFyuUJifMuG7SFOuOGCx6XDajltRcoOxxdxNO0AHWvOq0Kt7XrkLMyEBb4mk8LWSdp+F3WCnnHexzuGCFWynGhJ64IqwwjVHyaPuieq1dc3BG0BLAtlko+mggd5OOVh+FTtUOd8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724966698; c=relaxed/simple;
	bh=h/mc6GourA7pFsIsV3rctQgSz/nyUxr65HrD0BUV7t0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LO4NUs33GHVYnkD2DV/FMF1kPyl599YcssmB3wcpO/bDOdlkgP6x/lom76r7Ye1m0p2V0OxstkF7XjS9ot8iy1jZTMo3I8Z9VWxU2FVeA8smU1/aBgkzL7p2Clwg8P5/XveZHkShGt9HMatc5MkQzLQudh7dKVY8g3ojAHBpP3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mm2g+HLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mm2g+HLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA98C4CEC1;
	Thu, 29 Aug 2024 21:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724966698;
	bh=h/mc6GourA7pFsIsV3rctQgSz/nyUxr65HrD0BUV7t0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mm2g+HLCq2mleoNEcHtLjuvjECVscmvczYcUq5m9sCkVD8cqHHo+1apkkAk6aE1Av
	 mzENyF3Kj2oomAnhAd2xJYfYf7gqfHzYYhqB/fcg9XTI2P9/HZRqHGUSHhkUZTBYFX
	 kUlVZNJrdfliepV618XC2yNvZ6Dsltq3M6rxWJos8cU4k1dTFehJinTPl4v+znuMa4
	 LCMKg1bNeg8vGmhkdYeJjLhOkstyyqtfbxkE+Sn/UqBMX7mRKzdMHLM6dyqDAHhwWg
	 Le1zgk+Q4DDuaM/EnjKTn1i2LXhOj1YDaQBxyNHDUTAzJEzyyiadc39R77Qo8uRtHN
	 2a75HSE2hkMsw==
Date: Thu, 29 Aug 2024 14:24:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: simplify tagged perag iteration
Message-ID: <20240829212457.GL6224@frogsfrogsfrogs>
References: <20240829040848.1977061-1-hch@lst.de>
 <20240829040848.1977061-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829040848.1977061-4-hch@lst.de>

On Thu, Aug 29, 2024 at 07:08:39AM +0300, Christoph Hellwig wrote:
> Pass the old perag structure to the tagged loop helpers so that they can
> grab the old agno before releasing the reference.  This removes the need
> to separately track the agno and the iterator macro, and thus also
> obsoletes the for_each_perag_tag syntactic sugar.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I like this change!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 71 +++++++++++++++++++++------------------------
>  fs/xfs/xfs_trace.h  |  4 +--
>  2 files changed, 35 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ac604640d36229..573743b1841fe7 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -293,63 +293,66 @@ xfs_perag_clear_inode_tag(
>  }
>  
>  /*
> - * Search from @first to find the next perag with the given tag set.
> + * Find the next AG after @pag, or the first AG if @pag is NULL.
>   */
>  static struct xfs_perag *
> -xfs_perag_get_tag(
> +xfs_perag_get_next_tag(
>  	struct xfs_mount	*mp,
> -	xfs_agnumber_t		first,
> +	struct xfs_perag	*pag,
>  	unsigned int		tag)
>  {
> -	struct xfs_perag	*pag;
> +	unsigned long		index = 0;
>  	int			found;
>  
> +	if (pag) {
> +		index = pag->pag_agno + 1;
> +		xfs_perag_rele(pag);
> +	}
> +
>  	rcu_read_lock();
>  	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> -					(void **)&pag, first, 1, tag);
> +					(void **)&pag, index, 1, tag);
>  	if (found <= 0) {
>  		rcu_read_unlock();
>  		return NULL;
>  	}
> -	trace_xfs_perag_get_tag(pag, _RET_IP_);
> +	trace_xfs_perag_get_next_tag(pag, _RET_IP_);
>  	atomic_inc(&pag->pag_ref);
>  	rcu_read_unlock();
>  	return pag;
>  }
>  
>  /*
> - * Search from @first to find the next perag with the given tag set.
> + * Find the next AG after @pag, or the first AG if @pag is NULL.
>   */
>  static struct xfs_perag *
> -xfs_perag_grab_tag(
> +xfs_perag_grab_next_tag(
>  	struct xfs_mount	*mp,
> -	xfs_agnumber_t		first,
> +	struct xfs_perag	*pag,
>  	int			tag)
>  {
> -	struct xfs_perag	*pag;
> +	unsigned long		index = 0;
>  	int			found;
>  
> +	if (pag) {
> +		index = pag->pag_agno + 1;
> +		xfs_perag_rele(pag);
> +	}
> +
>  	rcu_read_lock();
>  	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> -					(void **)&pag, first, 1, tag);
> +					(void **)&pag, index, 1, tag);
>  	if (found <= 0) {
>  		rcu_read_unlock();
>  		return NULL;
>  	}
> -	trace_xfs_perag_grab_tag(pag, _RET_IP_);
> +	trace_xfs_perag_grab_next_tag(pag, _RET_IP_);
>  	if (!atomic_inc_not_zero(&pag->pag_active_ref))
>  		pag = NULL;
>  	rcu_read_unlock();
>  	return pag;
>  }
>  
> -#define for_each_perag_tag(mp, agno, pag, tag) \
> -	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
> -		(pag) != NULL; \
> -		(agno) = (pag)->pag_agno + 1, \
> -		xfs_perag_rele(pag), \
> -		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
> -
>  /*
>   * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
>   * part of the structure. This is made more complex by the fact we store
> @@ -1077,15 +1080,11 @@ long
>  xfs_reclaim_inodes_count(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		ag = 0;
> +	struct xfs_perag	*pag = NULL;
>  	long			reclaimable = 0;
>  
> -	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> -		ag = pag->pag_agno + 1;
> +	while ((pag = xfs_perag_get_next_tag(mp, pag, XFS_ICI_RECLAIM_TAG)))
>  		reclaimable += pag->pag_ici_reclaimable;
> -		xfs_perag_put(pag);
> -	}
>  	return reclaimable;
>  }
>  
> @@ -1427,14 +1426,13 @@ void
>  xfs_blockgc_start(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag = NULL;
>  
>  	if (xfs_set_blockgc_enabled(mp))
>  		return;
>  
>  	trace_xfs_blockgc_start(mp, __return_address);
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
> +	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
>  		xfs_blockgc_queue(pag);
>  }
>  
> @@ -1550,21 +1548,19 @@ int
>  xfs_blockgc_flush_all(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag = NULL;
>  
>  	trace_xfs_blockgc_flush_all(mp, __return_address);
>  
>  	/*
> -	 * For each blockgc worker, move its queue time up to now.  If it
> -	 * wasn't queued, it will not be requeued.  Then flush whatever's
> -	 * left.
> +	 * For each blockgc worker, move its queue time up to now.  If it wasn't
> +	 * queued, it will not be requeued.  Then flush whatever is left.
>  	 */
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
> +	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
>  		mod_delayed_work(pag->pag_mount->m_blockgc_wq,
>  				&pag->pag_blockgc_work, 0);
>  
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
> +	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
>  		flush_delayed_work(&pag->pag_blockgc_work);
>  
>  	return xfs_inodegc_flush(mp);
> @@ -1810,12 +1806,11 @@ xfs_icwalk(
>  	enum xfs_icwalk_goal	goal,
>  	struct xfs_icwalk	*icw)
>  {
> -	struct xfs_perag	*pag;
> +	struct xfs_perag	*pag = NULL;
>  	int			error = 0;
>  	int			last_error = 0;
> -	xfs_agnumber_t		agno;
>  
> -	for_each_perag_tag(mp, agno, pag, goal) {
> +	while ((pag = xfs_perag_grab_next_tag(mp, pag, goal))) {
>  		error = xfs_icwalk_ag(pag, goal, icw);
>  		if (error) {
>  			last_error = error;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 180ce697305a92..002d012ebd83cb 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -210,11 +210,11 @@ DEFINE_EVENT(xfs_perag_class, name,	\
>  	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip), \
>  	TP_ARGS(pag, caller_ip))
>  DEFINE_PERAG_REF_EVENT(xfs_perag_get);
> -DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
> +DEFINE_PERAG_REF_EVENT(xfs_perag_get_next_tag);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_hold);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_put);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_grab);
> -DEFINE_PERAG_REF_EVENT(xfs_perag_grab_tag);
> +DEFINE_PERAG_REF_EVENT(xfs_perag_grab_next_tag);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
> -- 
> 2.43.0
> 
> 
