Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD7350AC02
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790377151; cv=none; b=SsKwHfTxnVkEnCsxjJwG2NicuDi3JI79sMVCG4VCSba5SFrvWgz91jyD8GgC1v7Ilp0a+RGYu3jQPCYgikKtlJtPlgI8ZMS3IvVOOhHe6ALpes/snbN9evKwqSMziaRfH3kGP9JIyLqk7+UamAJ4creAzqAh9L23z3dBE4x5XC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790377151; c=relaxed/simple;
	bh=vIRKYL7gsohGkIXPCOjQ16Ns3yxKI9K1qQUEb6jBY2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUoTO2eUXU/iWv1AULdM2s1PhADk5P8Ge0IE+9Pol27dSmKO5SMUQE9mb9Fq5ctEs38QPjgQyb7PimtpZdXjYD/XmQZ9d8pgUquwc+v5Pat8ZlAMqcVkUru4eRkR8EDMeY65NWt6I3vDBZqYi6T/rrn/nMDDyDA9LuVyeSVFbYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqeHAuZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqeHAuZ3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 602321F000FF;
	Fri, 25 Sep 2026 22:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790377148;
	bh=McejLxnosAT8N3F/zlaFdTvJYnec9RR1W+Qcob63zU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fqeHAuZ3S/Ou2JcyXfvP6LlpERrRm0TfQXuZxnt7Clv4S4frWh+9xD6OUHQAKtzcl
	 IuB+Tv9xtHT3qwi9mozBwUmFhD4+YkD6hJRaieaDncG8tOaxkDO6y4DScIt593xCLL
	 wqIZb4o7d3q10ItfdZlpgyIGHQQ1MGeUgwukmG4q10YvpztOLfhlWjbCuLeVhTSTlY
	 /sied7jZrxWDkf7qHgvcyBugQfUcky4v8cB7+cmLfIlCOhhyOMRDbsSXo3XJOXo/Oh
	 g5bDhO3NsUXx6uPF31xBircEYbqHRh5+Sf37o2Z5Ye4rfc1DzvXkRKAQgzWnIWoiFE
	 xsEXZ0vpe71Yw==
Date: Fri, 25 Sep 2026 15:59:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH 3/3] libxfs: do not allow cache growth to overflow
Message-ID: <20260925225907.GD2705364@frogsfrogsfrogs>
References: <20260925194535.397036-1-sandeen@redhat.com>
 <20260925194535.397036-4-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925194535.397036-4-sandeen@redhat.com>

On Fri, Sep 25, 2026 at 02:41:45PM -0500, Eric Sandeen wrote:
> Nothing stops cache_expand() from growing c_maxcount (via *2)
> repeatedly until it overflows.
> 
> Add a bounds check here and return failure if for any reason we try to
> grow too much.
> 
> With the prior fixes, we should never get this far, but it's worth
> defending against anyway.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/cache.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index 60bfcdc5..03b62bc7 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -79,16 +79,24 @@ cache_init(
>  	return cache;
>  }
>  
> -static void
> +/* Double the cache size limit; return false if it would overflow. */
> +static bool
>  cache_expand(
>  	struct cache *		cache)
>  {
> +	bool			expanded = false;
> +
>  	pthread_mutex_lock(&cache->c_mutex);
> +	if (cache->c_maxcount <= UINT_MAX / 2) {
>  #ifdef CACHE_DEBUG
> -	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
> +		fprintf(stderr, "doubling cache size to %u\n",
> +				2 * cache->c_maxcount);
>  #endif
> -	cache->c_maxcount *= 2;
> +		cache->c_maxcount *= 2;
> +		expanded = true;
> +	}
>  	pthread_mutex_unlock(&cache->c_mutex);
> +	return expanded;
>  }
>  
>  void
> @@ -375,7 +383,8 @@ __cache_node_purge(
>   * Otherwise, we allocate a new node, taking care not to expand the
>   * cache beyond the requested maximum size (shrink it if it would).
>   * Returns zero if hit in cache, one if a new node was allocated.  Returns
> - * -ENOMEM if allocation fails after cache shaking is exhausted.
> + * -ENOMEM if allocation fails after cache shaking is exhausted, or if the
> + * cache cannot be expanded further without overflowing.
>   */
>  int
>  cache_node_get(
> @@ -485,8 +494,9 @@ next_object:
>  			 */
>  			if (error < 0)
>  				return error;
> +			if (!cache_expand(cache))
> +				return -ENOMEM;
>  			priority = 0;
> -			cache_expand(cache);
>  		}
>  	}
>  
> -- 
> 2.55.0
> 
> 
