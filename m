Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D3C2475CB
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563265; cv=none; b=cj2cDLikWzhnZJxZfS4AVEm17zgTYOi8bc7Xm2tnldLy/AvH6YG6HfM3R0By8Pd3uzI1OPNc4xeRUN2JC80/c/1dwmQdK9RqtMlQ0/yEzrU/7aa09eoZKkH/zt8ErDzi3pd/k2yAqzmrUEBvr/tHkg5Fy0TyfnvZC1YLprFUqTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563265; c=relaxed/simple;
	bh=F+9i1x1NJ37xdFYjzu21WK/zTUd7RmozzM9YUPR5yrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lN0gbtEYdY99rcOT7bVM/Nmal5JPn3S0dnyjwSfMk3RgP3G36DsivmvOJUHC80gFIJJDSPpVCKrTbc0QabHwtQ8wKgMK6pW9C5Aw4eLyA+EWSTIsjWzYK5Miz8C94/S1xGOGjihVgVH3jdUu7E+c/I3PFz99nYiWAEIBRODCyKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gf2cwyrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gf2cwyrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B610C4CEF8;
	Wed, 15 Oct 2025 21:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563265;
	bh=F+9i1x1NJ37xdFYjzu21WK/zTUd7RmozzM9YUPR5yrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gf2cwyrxw4AgZFCYA2vKKf6BfdOsmLVgyMRFjwwch34dLPZZjXucNx52L3pLrcNUd
	 aXt+YPQ+tkAkCspmkjxtIM00XstdDYw3zHDSlmI96c2dpfjTfZYj8pm1KMLmwm74rZ
	 uRjAEXY3xukgTX3E99AP9MZp5S3g5w30eIlN4675Kjb2VhIRZ6uWFwrwLH/je9HjbJ
	 LRs3nBZPTOQTCkXHZdXItk4HtRwad27Llzt1Q2Jacw/Odzuj9hzEdKE70vKWBgecAr
	 Tmu6NfDvfz1wm/EEipHX3ZxveGxgfP33jZLfoRZWWi5IKaDkmjXIORlzhIMbid030a
	 xWFFribrbx3vA==
Date: Wed, 15 Oct 2025 14:21:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/17] xfs: move xfs_dquot_tree calls into
 xfs_qm_dqget_cache_{lookup,insert}
Message-ID: <20251015212105.GL2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-17-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:17AM +0900, Christoph Hellwig wrote:
> These are the low-level functions that needs them, so localize the
> (trivial) calculation of the radix tree root there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much cleaner, thanks for doing this.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 98593b380e94..29f578d66230 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -801,10 +801,11 @@ xfs_dq_get_next_id(
>  static struct xfs_dquot *
>  xfs_qm_dqget_cache_lookup(
>  	struct xfs_mount	*mp,
> -	struct xfs_quotainfo	*qi,
> -	struct radix_tree_root	*tree,
> -	xfs_dqid_t		id)
> +	xfs_dqid_t		id,
> +	xfs_dqtype_t		type)
>  {
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
>  	struct xfs_dquot	*dqp;
>  
>  restart:
> @@ -843,11 +844,12 @@ xfs_qm_dqget_cache_lookup(
>  static int
>  xfs_qm_dqget_cache_insert(
>  	struct xfs_mount	*mp,
> -	struct xfs_quotainfo	*qi,
> -	struct radix_tree_root	*tree,
>  	xfs_dqid_t		id,
> +	xfs_dqtype_t		type,
>  	struct xfs_dquot	*dqp)
>  {
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
>  	unsigned int		nofs_flags;
>  	int			error;
>  
> @@ -906,8 +908,6 @@ xfs_qm_dqget(
>  	bool			can_alloc,
>  	struct xfs_dquot	**O_dqpp)
>  {
> -	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> -	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
>  	struct xfs_dquot	*dqp;
>  	int			error;
>  
> @@ -916,7 +916,7 @@ xfs_qm_dqget(
>  		return error;
>  
>  restart:
> -	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
> +	dqp = xfs_qm_dqget_cache_lookup(mp, id, type);
>  	if (dqp)
>  		goto found;
>  
> @@ -924,7 +924,7 @@ xfs_qm_dqget(
>  	if (error)
>  		return error;
>  
> -	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
> +	error = xfs_qm_dqget_cache_insert(mp, id, type, dqp);
>  	if (error) {
>  		/*
>  		 * Duplicate found. Just throw away the new dquot and start
> @@ -994,8 +994,6 @@ xfs_qm_dqget_inode(
>  	struct xfs_dquot	**dqpp)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> -	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
>  	struct xfs_dquot	*dqp;
>  	xfs_dqid_t		id;
>  	int			error;
> @@ -1014,7 +1012,7 @@ xfs_qm_dqget_inode(
>  	id = xfs_qm_id_for_quotatype(ip, type);
>  
>  restart:
> -	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
> +	dqp = xfs_qm_dqget_cache_lookup(mp, id, type);
>  	if (dqp)
>  		goto found;
>  
> @@ -1050,7 +1048,7 @@ xfs_qm_dqget_inode(
>  		return -ESRCH;
>  	}
>  
> -	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
> +	error = xfs_qm_dqget_cache_insert(mp, id, type, dqp);
>  	if (error) {
>  		/*
>  		 * Duplicate found. Just throw away the new dquot and start
> -- 
> 2.47.3
> 
> 
