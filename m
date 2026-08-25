Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC515A85A
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 03:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787627892; cv=none; b=XBsrvFIq3aKzVflbT+iFv4ZwvPImWlzkJ5AUDpLZdvcaqi9mF+GTYDm9NcacX8QzXVhvutTUiMk56UckVeSzbjG6WImE8B4GhLslwGIvi5v0qFkKLCiN26yipMgYVYwvMeljl9r3FHmJbKMoHVFzjC2JDViNE/0kh5idKU9avSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787627892; c=relaxed/simple;
	bh=84zoqX2LVanwor1+LbnVwdGfPN8Eq9nrxSL8YcznemU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJe/h1kx7yiNzuTZyp/j+rRCoy6ZvMg1lgq2ayjPyjZYPrXYINYzh3o/e4TzD9Ig1QcoIQO82nNh32MgoU6Qjq9YlirDwDSLp5y4QFDI5xPaTOdnBzMsNgFVDX7pNkqqdRUyA53rPX6dhhbAh48noiGpWhXAqiZlGdYLLGg0nhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8k9sb3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8k9sb3V"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B3DAD1F00A3A;
	Tue, 25 Aug 2026 03:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787627890;
	bh=cc2PHGl5bPF0AOzGww9obqbYmUZsTeIUHtBDJV/W5gY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j8k9sb3VaGuJ6XXw1+tF8FefElDy7h7Oi303MOo0PU36UeW90IRr38QWc7FTVKsyF
	 3X2Nx45WaHrpo6wO7Xsb1LT2eZQ6qj1kmoHMvByEyNvYAenreKLDcM43zpNFmD+cJT
	 Ez/rklv2B7jEsZBWW0g2TlNcNKPZu3tV6klG+SAmcJPIexka39pQxWYsH3j3UL0Ysq
	 XWOIMv+i/gk86KEi1rB/efWbjEY42/XUnYQgpyUHD53kiyiuIQvXS40XWTYzUd3Gom
	 aJM32lMNaozYWEAAtseLDRTGilHXCXhMQB0POvbp/Uy2gino5nsm1+/ECwKpAGdNBT
	 yUxhVi/PXNb6g==
Date: Mon, 24 Aug 2026 20:18:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: distinguish true ENOMEM from "not found"
 in cache_node_get
Message-ID: <20260825031810.GQ6072@frogsfrogsfrogs>
References: <20260824214056.400740-1-sandeen@redhat.com>
 <20260824214056.400740-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824214056.400740-3-sandeen@redhat.com>

On Mon, Aug 24, 2026 at 02:59:00PM -0500, user.mail wrote:
> In the cache_node_get() callchain, we may fail in cache_node_allocate
> for two distinct reasons:
>  - The cache may be at its current size limit, and must be expanded
>  - An underlying allocation may have actually failed with ENOMEM
> 
> Today, we do not distinguish these 2 failure modes and will try to
> expand the cache size even in the face of an ENOMEM, which won't help.
> We can distinguish these two failures, because:
> 
> If cache_node_allocate fails because all slots are full, c_count is
> untouched, and it is >= c_maxcount (all slots full.)
> 
> If cache_node_allocate fails due to an underlying ENOMEM, c_count is
> decremented before return and c_count will remain < c_maxcount.
> 
> So, if the cache has been fully shaken, cache_node_allocate stil
> fails, and c_count < c_maxcount, this is a true ENOMEM situation, and
> we should give up and tell the caller.
> 
> This adds yet another return value to cache_node_get (-1) for ENOMEM
> failures, and corrects the comment about the existing 0-vs-1 returns
> - though nobody looks at that return value today.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: user.mail <sandeen@redhat.com>

Dunno who "user.mail" is but I feel like I know them from somewhere ;)

> ---
>  libxfs/cache.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index f8be9b89..63224e58 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -373,8 +373,8 @@ __cache_node_purge(
>   * hit, in which case this will all be over quickly and painlessly.
>   * Otherwise, we allocate a new node, taking care not to expand the
>   * cache beyond the requested maximum size (shrink it if it would).
> - * Returns one if hit in cache, otherwise zero.  A node is _always_
> - * returned, however.
> + * Returns zero if hit in cache, otherwise return 1 for new node;
> + * allocation failures return -1 and a null nodep.
>   */
>  int
>  cache_node_get(
> @@ -474,6 +474,18 @@ next_object:
>  		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
>  		 */
>  		if (priority > CACHE_MAX_PRIORITY) {
> +			/*
> +			 * Shaking failed to make room. If the cache is not
> +			 * full, expanding the limit won't help - this is a
> +			 * genuine ENOMEM. Tell the caller.
> +			 */
> +			pthread_mutex_lock(&cache->c_mutex);
> +			if (cache->c_count < cache->c_maxcount) {
> +				pthread_mutex_unlock(&cache->c_mutex);
> +				*nodep = NULL;
> +				return -1;
> +			}
> +			pthread_mutex_unlock(&cache->c_mutex);

Also seems fine to me, but nobody checks for these -1 returns.  Also,
maybe we should be "return -ENOMEM" here or something?

--D

>  			priority = 0;
>  			if (!cache_expand(cache))
>  				goto fail;
> -- 
> 2.55.0
> 
> 
