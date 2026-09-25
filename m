Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E67D4F055B
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376996; cv=none; b=nA9JocJ2nfnx/cadfrWXjGrTvxDSAuOOXrehItzRLn3NMaoA6EvwERzZwOh2N82bSo4D6SY8O2Dpopq2dtNsiS3EaDTfwZD9OweUMUtu/vYqviKVQLV/NpUG43S4TNJ/qw5e4Lp4DfsVKBvwUygfkdms9gYUuPaynQj0cvha2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376996; c=relaxed/simple;
	bh=RCUYBz3nVw3lZnf7eZLMCDlQs6a2cepn1VTehwzzkLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Of0FP2YekH3ah+z3nSoSHlvo9ZaBpOQlUVU0VgY+NkvNIagwZ9/Q1H+uUdqyGanq/pC3QNEXbUN/O1ENtlkpb0YFrFcFfrenQMBHtm1673N7xWW2dEN4FAx13gMObmMWWTkZ1korT5ZRlicBpmyjCDgsEj8OK6+ChYdV5RbKF6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhQmq9jJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhQmq9jJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E81BD1F000FF;
	Fri, 25 Sep 2026 22:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790376995;
	bh=2QV49sJ7Ox/ILAwUuEOmfaneQfBfYd4NwRyEws5jlyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HhQmq9jJb2t3jLhIbErbxXfx2VSwhZZaU2DT3XvZ9z536lhyn7cijm4MlGUx46wBH
	 VkrfE7p6rX7DSKSLYDhSmiPWp0ZVDk0QIUy4H8Zo3Vj+a1GQ/jKbrNqKi7IJyauJ3A
	 GDJ1tUL8BQbY1v4f+CDBXLwvzf3fil1ds8iP1scIMeuj1+3gs+Os+Q8ie5NDtbWOnB
	 UZPV1kOTAOpZxasZ7hgeC1mskmAY5F/b8j+q29k3m6Sknux598y58n36KS3kgdoapy
	 AR91bAfxHOz6ZsDKkvU7ZX7r2qXP9HpuB2TgpXIqTW17NXTyBchs0i3vQVBJMIsNVK
	 H0dB2MwgE7aDQ==
Date: Fri, 25 Sep 2026 15:56:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH 1/3] libxfs: change cache_node_allocate function signature
Message-ID: <20260925225634.GB2705364@frogsfrogsfrogs>
References: <20260925194535.397036-1-sandeen@redhat.com>
 <20260925194535.397036-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925194535.397036-2-sandeen@redhat.com>

On Fri, Sep 25, 2026 at 02:41:43PM -0500, Eric Sandeen wrote:
> Modify cache_node_allocate() so that it returns a 0 / 1 status for
> cache miss / cache hit, with the cache node itself as a parameter. This
> will allow the next patches to properly differentiate underlying states
> and error conditions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I like this much better, thanks!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/cache.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index d5d9ba56..a6dabf92 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -284,11 +284,14 @@ cache_shake(
>  /*
>   * Allocate a new hash node (updating atomic counter in the process),
>   * unless doing so will push us over the maximum cache size.
> + * Return 1 with nodep set on success.
> + * Return 0 and NULL nodep otherwise (cache full, or alloc failure)
>   */
> -static struct cache_node *
> +static int
>  cache_node_allocate(
>  	struct cache *		cache,
> -	cache_key_t		key)
> +	cache_key_t		key,
> +	struct cache_node **	nodep)
>  {
>  	unsigned int		nodesfree;
>  	struct cache_node *	node;
> @@ -302,21 +305,25 @@ cache_node_allocate(
>  	}
>  	cache->c_misses++;
>  	pthread_mutex_unlock(&cache->c_mutex);
> -	if (!nodesfree)
> -		return NULL;
> +	if (!nodesfree) {
> +		*nodep = NULL;
> +		return 0;
> +	}
>  	node = cache->alloc(key);
>  	if (node == NULL) {	/* uh-oh */
>  		pthread_mutex_lock(&cache->c_mutex);
>  		cache->c_count--;
>  		pthread_mutex_unlock(&cache->c_mutex);
> -		return NULL;
> +		*nodep = NULL;
> +		return 0;
>  	}
>  	pthread_mutex_init(&node->cn_mutex, NULL);
>  	list_head_init(&node->cn_mru);
>  	node->cn_count = 1;
>  	node->cn_priority = 0;
>  	node->cn_old_priority = -1;
> -	return node;
> +	*nodep = node;
> +	return 1;
>  }
>  
>  int
> @@ -366,8 +373,8 @@ __cache_node_purge(
>   * hit, in which case this will all be over quickly and painlessly.
>   * Otherwise, we allocate a new node, taking care not to expand the
>   * cache beyond the requested maximum size (shrink it if it would).
> - * Returns one if hit in cache, otherwise zero.  A node is _always_
> - * returned, however.
> + * Returns zero if hit in cache, one if a new node was allocated.  A node
> + * is always returned.
>   */
>  int
>  cache_node_get(
> @@ -457,9 +464,10 @@ next_object:
>  		/*
>  		 * not found, allocate a new entry
>  		 */
> -		node = cache_node_allocate(cache, key);
> +		cache_node_allocate(cache, key, &node);
>  		if (node)
>  			break;
> +
>  		priority = cache_shake(cache, priority, false);
>  		/*
>  		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
> -- 
> 2.55.0
> 
> 
