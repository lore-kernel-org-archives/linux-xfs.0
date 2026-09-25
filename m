Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECDC4FECDF
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790377129; cv=none; b=IyClsWt+x1jzsdgQeklHE1PJ2nYOzOFyCXbJOULweoBdUxyUaJJGR5JNpcMBz6wRqAcyvpspDF43SnYlr1Hx4nIuEnXpI5PxJoiQcVK0LLB6J5HH9xQZ0F5fT/qMCYfrrLDJTJEgDKh0BXRX9gSCI2sYnV78GCc5yeqXPdwbFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790377129; c=relaxed/simple;
	bh=/gcMpvxrTFto7c43dWuU+DM53+savWaJXxEyfY1Wb9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzzmvMxnRWXWXfCo9A/M4/b0v4HxxqEkP7psnbaW7+dYnw8vRwUvggblLC1HQD2/UiYcVqpkvUn2j3szt7mvaQUvYX/FuMckxBix5Z1ZAwDBwctRIW2nnZ8WEEu3HmOfFAyiGQm0fRYJBjUHfyCMJqW+ggU3I6akdz7qqRJEXDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JACV8kUc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JACV8kUc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BE8F21F000FF;
	Fri, 25 Sep 2026 22:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790377127;
	bh=+/rjos2nec+4k7mKVkmWw8arUnO7zfKxkA61EEBZwsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JACV8kUcSNq4SUIxs9UoeSKAIEGX2jXkEGilGXJ96t1HQoQPUwdkS2ehYVCtF2ALa
	 4HCN6it/50qf7fsZ54A2goAksh9lNilIBgJzsiq9gX7ZcJEWAY4bvIt1wf8EAJx8uN
	 MP+SAPKRZrYb7+Bau4Z2m0qbuNFkbTh+9L7tc0H4hIhZcR+ZmDcr0HOumwdSfTGdk0
	 hX24kXI/HVOg9QsHrLLySa/N3BY3M2UTyP6rj3Kowzb+zykYiNsKurWQWZb/x/1OgD
	 P4vtGqA1iQIbJ9wW0L6xMIignwLuf8YEm7W0+ln2N+ntrIKuztf03NbWi89sd3rLb2
	 AFfbEq2nb8WOg==
Date: Fri, 25 Sep 2026 15:58:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH 2/3] libxfs: Return -ENOMEM on actual cache node
 allocation failures
Message-ID: <20260925225847.GC2705364@frogsfrogsfrogs>
References: <20260925194535.397036-1-sandeen@redhat.com>
 <20260925194535.397036-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925194535.397036-3-sandeen@redhat.com>

On Fri, Sep 25, 2026 at 02:41:44PM -0500, Eric Sandeen wrote:
> Today, if we get an underlying ENOMEM from an actual cache node
> allocation attempt, it's indistinguishable from "current cache size
> is filled" and we'll keep doubling cache size to no avail until the
> size itself overflows.
> 
> This patch differentiates "no node returned" between the "cache full;
> grow it" case and the "underlying allocation actually got ENOMEM" case
> so that the caller can do the right thing, and return true ENOMEM
> up the stack for callers to handle.
> 
> Finally, actually check this returned error at the cache_node_get
> callsite (in __cache_lookup).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  libxfs/cache.c | 22 ++++++++++++++++------
>  libxfs/rdwr.c  |  9 ++++-----
>  2 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index a6dabf92..60bfcdc5 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -285,7 +285,8 @@ cache_shake(
>   * Allocate a new hash node (updating atomic counter in the process),
>   * unless doing so will push us over the maximum cache size.
>   * Return 1 with nodep set on success.
> - * Return 0 and NULL nodep otherwise (cache full, or alloc failure)
> + * Return 0 and NULL nodep if the cache is full (caller should shake/expand).
> + * Return -ENOMEM and NULL nodep if the underlying allocation failed.
>   */
>  static int
>  cache_node_allocate(
> @@ -315,7 +316,7 @@ cache_node_allocate(
>  		cache->c_count--;
>  		pthread_mutex_unlock(&cache->c_mutex);
>  		*nodep = NULL;
> -		return 0;
> +		return -ENOMEM;
>  	}
>  	pthread_mutex_init(&node->cn_mutex, NULL);
>  	list_head_init(&node->cn_mru);
> @@ -373,8 +374,8 @@ __cache_node_purge(
>   * hit, in which case this will all be over quickly and painlessly.
>   * Otherwise, we allocate a new node, taking care not to expand the
>   * cache beyond the requested maximum size (shrink it if it would).
> - * Returns zero if hit in cache, one if a new node was allocated.  A node
> - * is always returned.
> + * Returns zero if hit in cache, one if a new node was allocated.  Returns
> + * -ENOMEM if allocation fails after cache shaking is exhausted.
>   */
>  int
>  cache_node_get(
> @@ -391,6 +392,7 @@ cache_node_get(
>  	unsigned int		hashidx;
>  	int			priority = 0;
>  	int			purged = 0;
> +	int			error = 0;
>  
>  	hashidx = cache->hash(key, cache->c_hashsize, cache->c_hashshift);
>  	hash = cache->c_hash + hashidx;
> @@ -464,8 +466,8 @@ next_object:
>  		/*
>  		 * not found, allocate a new entry
>  		 */
> -		cache_node_allocate(cache, key, &node);
> -		if (node)
> +		error = cache_node_allocate(cache, key, &node);
> +		if (error > 0)

I think you could keep the node nullness check, though in the end it
doesn't make much difference.  It's not like you can return
Result<struct cache_node> or anything. :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  			break;
>  
>  		priority = cache_shake(cache, priority, false);
> @@ -475,6 +477,14 @@ next_object:
>  		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
>  		 */
>  		if (priority > CACHE_MAX_PRIORITY) {
> +			/*
> +			 * We've shaken every priority level.  If the last
> +			 * attempt failed with a real ENOMEM rather than a
> +			 * full cache, neither shaking nor growing can help;
> +			 * return the error to the caller.
> +			 */
> +			if (error < 0)
> +				return error;
>  			priority = 0;
>  			cache_expand(cache);
>  		}
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 90f2d566..d8ba832e 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -411,17 +411,16 @@ __cache_lookup(
>  	struct cache_node	*cn = NULL;
>  	struct cache		*bcache = key->buftarg->bcache;
>  	struct xfs_buf		*bp;
> +	int			ret;
>  
>  	*bpp = NULL;
>  
> -	cache_node_get(bcache, key, &cn);
> -	if (!cn)
> -		return -ENOMEM;
> +	ret = cache_node_get(bcache, key, &cn);
> +	if (ret < 0)
> +		return ret;
>  	bp = container_of(cn, struct xfs_buf, b_node);
>  
>  	if (use_xfs_buf_lock) {
> -		int		ret;
> -
>  		ret = pthread_mutex_trylock(&bp->b_lock);
>  		if (ret) {
>  			ASSERT(ret == EAGAIN);
> -- 
> 2.55.0
> 
> 
