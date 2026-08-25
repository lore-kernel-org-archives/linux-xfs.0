Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BAC15A85A
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 03:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787627830; cv=none; b=M04dJp14UBhltVWlLd8MhSlomq+W0Dfazlpk2n5WXpX+QDgBkEadg2U+HTrEedfcoOoJnVioAF1q7OblUNp+eQiwjbykLfqwA6UWDO2x2FytviY/yPwTksAsttmFWyu2zaf7GbBwol9GTtQ2/CT9g9x0g/tjTx3mRpBVBYI/2cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787627830; c=relaxed/simple;
	bh=I3ZffmzPwW4w5+v8u4kA2xwOd9dcE9MSUU6OMUMnnhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lca0hGyrKUk+qVWTiv3J1JpD2Z6ZtnynOFX09iReLXTChXlEqnTcvutDZMiQaSof+RFg7/T3NOM51+VTGcIWngfQi8r5LOfwiBEWETQck9mvxd6sxXA3rQ+Bp8InS3rP+4ORgZgeZs879CzPGgkAKC4LVJnV0YwosohyaLITPOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjE/PP3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjE/PP3T"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B6E551F000E9;
	Tue, 25 Aug 2026 03:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787627828;
	bh=U9KOhYK3p7CC4avvNUi/cwx9zIe5MtLs4fqwKLhd35A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MjE/PP3TZMSYszJz+gZayhEsXdWUHgLPjmc7BdHVLanEBzWx2l9Ydme3Zq1iHVqBw
	 e5/Oug30KJLL6KkvX0y85ioTV+2vBuX9WOWr2HjWLpzX25OrHJNvOWnl+baNx9U2wD
	 XJctNpCpm9ncOCUAJHnMmwlx2AKoQsADF37mZYcNdezUyb5ejRHhOX+CQDKPWIkauh
	 HP3K/UhQddRab9ZeZlDzRu9sWp1pbvc9VaBdUDSQ30lXi8Czh08RNzvlSAD96vhY2F
	 cOmQSQmzAGFgYGCS7c25YLiwdkTxXMRHb0SM/An3C5S+hAsvIOGQRtGz44ZKicW3bn
	 RkpejeFr7h79w==
Date: Mon, 24 Aug 2026 20:17:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: do not allow cache growth to overflow
Message-ID: <20260825031708.GG6110@frogsfrogsfrogs>
References: <20260824214056.400740-1-sandeen@redhat.com>
 <20260824214056.400740-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824214056.400740-2-sandeen@redhat.com>

On Mon, Aug 24, 2026 at 02:58:59PM -0500, user.mail wrote:
> Nothing stops cache_expand() from growing c_maxcount (via *2)
> repeatedly until it overflows.
> 
> Add a bounds check here and return failure if for any reason we try to
> grow too much.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: user.mail <sandeen@redhat.com>
> ---
>  libxfs/cache.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index d5d9ba56..f8be9b89 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -79,16 +79,23 @@ cache_init(
>  	return cache;
>  }
>  
> -static void
> +static int
>  cache_expand(
>  	struct cache *		cache)
>  {
> +	int			success = 1;
>  	pthread_mutex_lock(&cache->c_mutex);
> +	if (cache->c_maxcount <= UINT_MAX/2) {
>  #ifdef CACHE_DEBUG
> -	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
> +		fprintf(stderr, "doubling cache size to %u\n",
> +			2 * cache->c_maxcount);
>  #endif
> -	cache->c_maxcount *= 2;
> +		cache->c_maxcount *= 2;

I agree that it's useful not to overflow c_maxcount, but how did you end
up with that many cached buffers?  Or is this LLM-inspired bugfixes?

Either way I'm ok with this part, so...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

> +	} else
> +		success = 0;
>  	pthread_mutex_unlock(&cache->c_mutex);
> +
> +	return success;
>  }
>  
>  void
> @@ -468,7 +475,8 @@ next_object:
>  		 */
>  		if (priority > CACHE_MAX_PRIORITY) {
>  			priority = 0;
> -			cache_expand(cache);
> +			if (!cache_expand(cache))
> +				goto fail;
>  		}
>  	}
>  
> @@ -488,6 +496,10 @@ next_object:
>  
>  	*nodep = node;
>  	return 1;
> +
> +fail:
> +	*nodep = NULL;
> +	return -1;

...but a general comment about this patch and the next one: it seems
reasonable to make cache_node_get return a null nodep and -1 to indicate
error, but AFAICT the only caller is __cache_lookup (aka the buffer
cache), which doesn't check the return value at all, only the value of
*nodep.

I don't see a change in this series to change __cache_lookup.  Did that
get lost somewhere?

--D

>  }
>  
>  void
> -- 
> 2.55.0
> 
> 
