Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037B3BFAEE
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538840; cv=none; b=Fgp7joVGLuwnTlarH9xfEno3w0iTDoHRulM5KwizFRNqxuk7Oy0uuhgspmSVWU/RnKul5r9sBoNqnQaxYj3NnEnE8topkN4xcoTkVHx45HIygb5p+x59vZ+LSAqFpA2AFK6E++TGgW3RC9dUWc2N0A6lEex2VxAy55RmHY5RmBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538840; c=relaxed/simple;
	bh=Xu1VT3YsCNJVx6z6P3iRyzayUySes/JzUatXBog7hWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H71lp+92701TdQcP9udIkwxp8c9VdCNPDw5TObeY5mk+3elPCRFNrj6UsoVdRRm61arsljGOZj6Tbawmghka6uVQVFMqI5mF7GzzVVrGsiPVF5j18g+IX/T8Ni/nzSfqCWfWM/W6+dXgBBqKdA72yOdDIIqoyMR9Hqz6cQbplVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrCAUsWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrCAUsWs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 95C111F00A3E;
	Fri,  4 Sep 2026 16:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538838;
	bh=ecifVLYUcxMPQJQ4IKf9uxph+pOeIaweCPbg48hQz5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jrCAUsWshULB7MJizI8pWngDP+rQP6RVWKavtyLmx+66r7OstcvPBUv3YgCRbu1c4
	 Wb1ZQPde74VsCo4mb20Il+wxuZlifKMiGpX8BaxPbJ/VOJFi7Kecz8c2QbXsza56dA
	 WJBd2r9y70BQutZ/J34zVKQqjal1BU/pOCyFyYa8axRpA3b/YcmgKwo95I7Nmqv2bn
	 MjBK+svBcC3jW8eiaDq3196qZzVJs8Hs0J1flgWijiQX68RP7LSzk4A+N2rxx1poWX
	 th9kF2EoUqkMu1KdbUJf16Xd+4n5a46PwAfuuhom9/5B4+YxhTg7lPyoCoUBWSmxyI
	 QhmAmLzYbJzPA==
Date: Fri, 4 Sep 2026 09:20:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: distinguish true ENOMEM from "not found"
 in cache_node_get
Message-ID: <20260904162038.GD1933798@frogsfrogsfrogs>
References: <20260903203638.1094907-1-sandeen@redhat.com>
 <20260903203638.1094907-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903203638.1094907-2-sandeen@redhat.com>

On Thu, Sep 03, 2026 at 01:42:43PM -0500, Eric Sandeen wrote:
> When cache_node_get() needs a new node it calls cache_node_allocate(),
> which returns NULL for two very different reasons:
> 
>  - the cache is already full (c_count has reached c_maxcount), or
>  - an underlying allocation actually failed with ENOMEM.
> 
> These require different responses. A full cache should be shaken to free
> slots and, failing that, expanded. An actual ENOMEM should be returned
> to the caller to deal with.
> 
> To achieve this, make cache_node_allocate() say which case occurred via
> a new *enomem parameter, set true only for a real allocation failure.
> Cache shaking still happens before returning ENOMEM, as this may actually
> free memory and allow new allocations to succeed.
> 
> Also fix the stale return-value comment, which had the hit/new-node
> cases backwards.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  libxfs/cache.c | 39 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index d5d9ba56..21e4c0c0 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -284,15 +284,26 @@ cache_shake(
>  /*
>   * Allocate a new hash node (updating atomic counter in the process),
>   * unless doing so will push us over the maximum cache size.
> + *
> + * Returns NULL on failure.  A NULL return can mean two different things:
> + * either the cache is already full (c_count has reached c_maxcount), or
> + * the underlying allocation genuinely failed with ENOMEM.  These call for
> + * very different responses from the caller, so report which one happened
> + * via *enomem: it is set true only for a real allocation failure, and
> + * left false when we cannot allocate another node in the current cache
> + * size.
>   */
>  static struct cache_node *
>  cache_node_allocate(
>  	struct cache *		cache,
> -	cache_key_t		key)
> +	cache_key_t		key,
> +	bool			*enomem)

Hrmm.  Having ENOMEM as an outparam is a little weird, but I suppose we
can't do the ERR_PTR stuff that the kernel does.

OTOH I guess you could set errno here and redefine the return value as:

"This function returns a pointer to a cache object in the case of a hit.
For a miss, it returns NULL with errno set to 0.  For any other runtime
error, it returns NULL with errno set to a nonzero value."

Hrm?

>  {
>  	unsigned int		nodesfree;
>  	struct cache_node *	node;
>  
> +	*enomem = false;
> +
>  	pthread_mutex_lock(&cache->c_mutex);
>  	nodesfree = (cache->c_count < cache->c_maxcount);
>  	if (nodesfree) {
> @@ -309,6 +320,7 @@ cache_node_allocate(
>  		pthread_mutex_lock(&cache->c_mutex);
>  		cache->c_count--;
>  		pthread_mutex_unlock(&cache->c_mutex);
> +		*enomem = true;
>  		return NULL;
>  	}
>  	pthread_mutex_init(&node->cn_mutex, NULL);
> @@ -366,8 +378,9 @@ __cache_node_purge(
>   * hit, in which case this will all be over quickly and painlessly.
>   * Otherwise, we allocate a new node, taking care not to expand the
>   * cache beyond the requested maximum size (shrink it if it would).
> - * Returns one if hit in cache, otherwise zero.  A node is _always_
> - * returned, however.
> + * Returns zero if hit in cache, one if a new node was allocated.  If
> + * allocation fails with a genuine ENOMEM we return -1 with a NULL
> + * *nodep; in every other case a node is returned.
>   */
>  int
>  cache_node_get(
> @@ -384,6 +397,8 @@ cache_node_get(
>  	unsigned int		hashidx;
>  	int			priority = 0;
>  	int			purged = 0;
> +	int			ret;
> +	bool			enomem = false;
>  
>  	hashidx = cache->hash(key, cache->c_hashsize, cache->c_hashshift);
>  	hash = cache->c_hash + hashidx;
> @@ -457,7 +472,7 @@ next_object:
>  		/*
>  		 * not found, allocate a new entry
>  		 */
> -		node = cache_node_allocate(cache, key);
> +		node = cache_node_allocate(cache, key, &enomem);
>  		if (node)
>  			break;

I guess the awkward part here is that you then need extra stupid
variables and logic:

		switch (errno) {
		case ENOMEM:
			enomem = true;
			break;
		case 0:
			break;
		default:
			/* what the heck?? */
			break;
		}

I think I'd almost rather we change cache_node_allocate to return int
and the cache node as an outparam since we do that elsewhere, but
<shrug> I'll defer to Andrey.

--D

>  		priority = cache_shake(cache, priority, false);
> @@ -467,6 +482,18 @@ next_object:
>  		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
>  		 */
>  		if (priority > CACHE_MAX_PRIORITY) {
> +			/*
> +			 * We've shaken every priority level and still can't
> +			 * allocate.  If the last attempt failed with a real
> +			 * ENOMEM rather than simply a full cache, then neither
> +			 * shaking nor growing the cache can help - give up and
> +			 * let the caller handle the failure.
> +			 */
> +			if (enomem) {
> +				node = NULL;
> +				ret = -1;
> +				goto out;
> +			}
>  			priority = 0;
>  			cache_expand(cache);
>  		}
> @@ -479,7 +506,9 @@ next_object:
>  	hash->ch_count++;
>  	list_add(&node->cn_hash, &hash->ch_list);
>  	pthread_mutex_unlock(&hash->ch_mutex);
> +	ret = 1;
>  
> +out:
>  	if (purged) {
>  		pthread_mutex_lock(&cache->c_mutex);
>  		cache->c_count -= purged;
> @@ -487,7 +516,7 @@ next_object:
>  	}
>  
>  	*nodep = node;
> -	return 1;
> +	return ret;
>  }
>  
>  void
> -- 
> 2.55.0
> 
> 
