Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBA818A92F
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724966783; cv=none; b=h+omESb7IAYeobdZSdmDyxjy+00tFF8o8sK6KZaHxJLMc2xgiGWF8OTrcwfYEWmoO50uEPSCqohLzbjWYUQeyGy502kjWjc0SjpRuDzXxN5hEOULmDMGgBchb476rsFHBaZbqaxV9xeI22gRGQgXDugtut/VnOl5uKnR5YeyYM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724966783; c=relaxed/simple;
	bh=volfn9EM5DxqXNSNd3lvqPjahiGIEbU+njdU6+WGS7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVZItG9ERdvLrheA2qLJHklR/LWMt7cF8V39KHzLW0MGaPFnNF3Hvwlg675JCE99pIHv2z4Q76cAsAJnXf+YQWee/52XbRJFx85DbnV3Zs1ROrxpBJNneG8eFF798iQR9TZMmfw/ABirXvitJjPJohIDqknwUMF6kx/cN461Ob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnJZBceR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnJZBceR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75069C4CEC1;
	Thu, 29 Aug 2024 21:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724966782;
	bh=volfn9EM5DxqXNSNd3lvqPjahiGIEbU+njdU6+WGS7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NnJZBceR16AKsuWBuoeHrgt9RMq+iDeFGx+m/6DYI5mgI7d127Fk5hwBkv2bLNLHv
	 OivFjUz4VoWJ7EGZ/SSmXG8xR3HoMN4DDLqhNLALfJ8JobyXy7/hEnNix2cZyq8PQd
	 wl/V8ky+Ort/YiQb/duODu/V09ox4NwQcZYppR1skN6gftM/GenBESt7jhq+ggjVuV
	 FPFeUCQKkTMXq7jMkVGfp9tucmEyzF2fAqZTdF/WsLQn7azRv10PvI5sgg1V72/6i9
	 BR7lBo+KI1Hc2hVfw2gyqJZiwo86Mi+wNELPjbVb7vLCNSORFGitILUHanICKubIqK
	 1NX6E/025r59w==
Date: Thu, 29 Aug 2024 14:26:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: move the tagged perag lookup helpers to
 xfs_icache.c
Message-ID: <20240829212621.GM6224@frogsfrogsfrogs>
References: <20240829040848.1977061-1-hch@lst.de>
 <20240829040848.1977061-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829040848.1977061-3-hch@lst.de>

On Thu, Aug 29, 2024 at 07:08:38AM +0300, Christoph Hellwig wrote:
> The tagged perag helpers are only used in xfs_icache.c in the kernel code
> and not at all in xfsprogs.  Move them to xfs_icache.c in preparation for
> switching to an xarray, for which I have no plan to implement the tagged
> lookup functions for userspace.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Not thrilled about this, but I won't hold up the rest of the
conversion...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c | 51 -------------------------------------
>  fs/xfs/libxfs/xfs_ag.h | 11 --------
>  fs/xfs/xfs_icache.c    | 58 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 58 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 4b5a39a83f7aed..87f00f0180846f 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -56,31 +56,6 @@ xfs_perag_get(
>  	return pag;
>  }
>  
> -/*
> - * search from @first to find the next perag with the given tag set.
> - */
> -struct xfs_perag *
> -xfs_perag_get_tag(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		first,
> -	unsigned int		tag)
> -{
> -	struct xfs_perag	*pag;
> -	int			found;
> -
> -	rcu_read_lock();
> -	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> -					(void **)&pag, first, 1, tag);
> -	if (found <= 0) {
> -		rcu_read_unlock();
> -		return NULL;
> -	}
> -	trace_xfs_perag_get_tag(pag, _RET_IP_);
> -	atomic_inc(&pag->pag_ref);
> -	rcu_read_unlock();
> -	return pag;
> -}
> -
>  /* Get a passive reference to the given perag. */
>  struct xfs_perag *
>  xfs_perag_hold(
> @@ -127,32 +102,6 @@ xfs_perag_grab(
>  	return pag;
>  }
>  
> -/*
> - * search from @first to find the next perag with the given tag set.
> - */
> -struct xfs_perag *
> -xfs_perag_grab_tag(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		first,
> -	int			tag)
> -{
> -	struct xfs_perag	*pag;
> -	int			found;
> -
> -	rcu_read_lock();
> -	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> -					(void **)&pag, first, 1, tag);
> -	if (found <= 0) {
> -		rcu_read_unlock();
> -		return NULL;
> -	}
> -	trace_xfs_perag_grab_tag(pag, _RET_IP_);
> -	if (!atomic_inc_not_zero(&pag->pag_active_ref))
> -		pag = NULL;
> -	rcu_read_unlock();
> -	return pag;
> -}
> -
>  void
>  xfs_perag_rele(
>  	struct xfs_perag	*pag)
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index d62c266c0b44d5..d9cccd093b60e0 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -153,15 +153,11 @@ void xfs_free_perag(struct xfs_mount *mp);
>  
>  /* Passive AG references */
>  struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
> -struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
> -		unsigned int tag);
>  struct xfs_perag *xfs_perag_hold(struct xfs_perag *pag);
>  void xfs_perag_put(struct xfs_perag *pag);
>  
>  /* Active AG references */
>  struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
> -struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
> -				   int tag);
>  void xfs_perag_rele(struct xfs_perag *pag);
>  
>  /*
> @@ -263,13 +259,6 @@ xfs_perag_next(
>  	(agno) = 0; \
>  	for_each_perag_from((mp), (agno), (pag))
>  
> -#define for_each_perag_tag(mp, agno, pag, tag) \
> -	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
> -		(pag) != NULL; \
> -		(agno) = (pag)->pag_agno + 1, \
> -		xfs_perag_rele(pag), \
> -		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
> -
>  static inline struct xfs_perag *
>  xfs_perag_next_wrap(
>  	struct xfs_perag	*pag,
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index cf629302d48e74..ac604640d36229 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -292,6 +292,64 @@ xfs_perag_clear_inode_tag(
>  	trace_xfs_perag_clear_inode_tag(pag, _RET_IP_);
>  }
>  
> +/*
> + * Search from @first to find the next perag with the given tag set.
> + */
> +static struct xfs_perag *
> +xfs_perag_get_tag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		first,
> +	unsigned int		tag)
> +{
> +	struct xfs_perag	*pag;
> +	int			found;
> +
> +	rcu_read_lock();
> +	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +					(void **)&pag, first, 1, tag);
> +	if (found <= 0) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +	trace_xfs_perag_get_tag(pag, _RET_IP_);
> +	atomic_inc(&pag->pag_ref);
> +	rcu_read_unlock();
> +	return pag;
> +}
> +
> +/*
> + * Search from @first to find the next perag with the given tag set.
> + */
> +static struct xfs_perag *
> +xfs_perag_grab_tag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		first,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag;
> +	int			found;
> +
> +	rcu_read_lock();
> +	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +					(void **)&pag, first, 1, tag);
> +	if (found <= 0) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +	trace_xfs_perag_grab_tag(pag, _RET_IP_);
> +	if (!atomic_inc_not_zero(&pag->pag_active_ref))
> +		pag = NULL;
> +	rcu_read_unlock();
> +	return pag;
> +}
> +
> +#define for_each_perag_tag(mp, agno, pag, tag) \
> +	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
> +		(pag) != NULL; \
> +		(agno) = (pag)->pag_agno + 1, \
> +		xfs_perag_rele(pag), \
> +		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
> +
>  /*
>   * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
>   * part of the structure. This is made more complex by the fact we store
> -- 
> 2.43.0
> 
> 
