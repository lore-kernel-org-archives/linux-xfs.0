Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC82A431A4C
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786468324; cv=none; b=vDgnlgoXjjVt8Lc2PL6/yzyJQkpIhS6ii7gb5NUhdzkqbCSLcjw3QG8oL04zcoxxzBhZAhgCsp/8eeR6KmXW0839FDdo8tTuzjmk78Uu5iWbSuv8rQq132WAyUUyyT/JJoktou1v/V6c+nghP06BR46M/dA4qC1psXjfwHrWilE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786468324; c=relaxed/simple;
	bh=gIa+Fwfy/8hrqoqS7lpun7KZ7TcaR2+074XUR6lc1Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTXwamHRseA7YmqvULHKMs66SXRHR1nHMfNZgxuNDVybvbSa94/El8wEs74A1hMhfVjNUkDYJHLxYS5NkfwsAWqexS4VU5bpqQeLRceo9khN7EUxRYgplvEZ3lWj8D/sWY0dIZStnRnZC4/OTgBhxLQ/OAdnw7DmLNQLTDjfHYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JChFVQhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JChFVQhD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4B60E1F00A3D;
	Tue, 11 Aug 2026 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786468322;
	bh=fDfgmwQcGb+hdGf9Pe3cSEBZ9iO0+FeN2oAkK5mA/cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JChFVQhDM5pD1cRw/mqp+/JsnsFuNnh6qPxYyT4oHrpCZo8TgmLJSxcDsWkEc7a9B
	 ov2GI6OZfB81IpoAjMLUV1zadbrbKgShCrdi4e/ycgnD3FI9hjFoW40ngQuWJrM4OG
	 +0wOWKQuSuvhVv1n6AHjKe1CwbNY4S0LGeDIlVHBCz5MorSui/gjCfzCuE6sLA3xXD
	 ueHInW/IcfxMgJRymHLZGczpp7EMzYC9stS4KRITakg3xtnYEsMjynkIdGGi+WzqyZ
	 TrqlQ8TZu6+7LS+UaC+RNEYzu3BRF3Ch34RL+s97dpL50qv2Y6lDaDi96yWI/Lwae1
	 RootNMfGaxYxA==
Date: Tue, 11 Aug 2026 10:12:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fix racy open zone caching
Message-ID: <20260811171201.GD3556460@frogsfrogsfrogs>
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811164912.124416-3-hch@lst.de>

On Tue, Aug 11, 2026 at 10:48:38AM -0600, Christoph Hellwig wrote:
> When testing on very fast storage devices, I've observed writers using
> io_uring creating many open zones with just a few kiB written to it,
> which then don't get used.  I tracked this down to multiple io_uring
> helper threads finding a full zone in i_private, and then going on to
> select a one, with the final one winning the race and leaving it in
> i_private.
> 
> Fix this by dropping full zones from i_private as soon we find them,
> checking cached for a cached zoned when a single writes needs a new zone,
> and by keeping an existing cached zone in xfs_set_cached_zone when it
> still has space available, dropping the newly found/allocated one
> instead.  This uses i_flags_lock as a low-level spinlock for short
> hold times to avoid interactions with the ilock, which is used for
> completions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much clearer now, thanks!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 53 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 7d13fa7ab30a..bdbb60cc5d5b 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -793,17 +793,35 @@ xfs_get_cached_zone(
>  
>  	rcu_read_lock();
>  	oz = VFS_I(ip)->i_private;
> -	if (oz) {
> -		/*
> -		 * GC only steals open zones at mount time, so no GC zones
> -		 * should end up in the cache.
> -		 */
> -		ASSERT(!oz->oz_is_gc);
> -		if (!atomic_inc_not_zero(&oz->oz_ref))
> +	if (!oz)
> +		goto out_unlock;
> +
> +	/*
> +	 * GC only steals open zones at mount time, so no GC zones should end up
> +	 * in the cache.
> +	 */
> +	ASSERT(!oz->oz_is_gc);
> +
> +	/*
> +	 * Drop the old cached open zone if it is full.
> +	 */
> +	if (oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
> +		spin_lock(&ip->i_flags_lock);
> +		oz = VFS_I(ip)->i_private;
> +		if (oz && oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
> +			VFS_I(ip)->i_private = NULL;
> +			spin_unlock(&ip->i_flags_lock);
> +			xfs_open_zone_put(oz);
>  			oz = NULL;
> +			goto out_unlock;
> +		}
> +		spin_unlock(&ip->i_flags_lock);
>  	}
> -	rcu_read_unlock();
>  
> +	if (!atomic_inc_not_zero(&oz->oz_ref))
> +		oz = NULL;
> +out_unlock:
> +	rcu_read_unlock();
>  	return oz;
>  }
>  
> @@ -818,18 +836,41 @@ xfs_get_cached_zone(
>   * that were every written to, but significantly simplifies the cached zone
>   * lookup.  Because the open_zone is clearly marked as full when all data
>   * in the underlying RTG was written, the caching is always safe.
> + *
> + * Called with a reference on @oz held.  And returns two references on the
> + * returned zone: one for the caller and one for pinning the zone in
> + * inode->i_private.
>   */
> -static void
> +static struct xfs_open_zone *
>  xfs_set_cached_zone(
>  	struct xfs_inode	*ip,
>  	struct xfs_open_zone	*oz)
>  {
>  	struct xfs_open_zone	*old_oz;
>  
> +	/*
> +	 * If the open zone cached in the inode still has free space, use that
> +	 * instead of the new open zone just selected.  This can happen when
> +	 * multiple threads race to perform zone selection for an inode.
> +	 * io_uring worker threads seem to be good way to trigger this.
> +	 *
> +	 * We need to grab an extra reference to this open zone as the caller
> +	 * owns a reference in addition to the i_private pointer.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	old_oz = VFS_I(ip)->i_private;
> +	if (old_oz && old_oz->oz_allocated < rtg_blocks(old_oz->oz_rtg) &&
> +	    atomic_inc_not_zero(&old_oz->oz_ref)) {
> +		spin_unlock(&ip->i_flags_lock);
> +		xfs_open_zone_put(oz);
> +		return old_oz;
> +	}
> +	VFS_I(ip)->i_private = oz;
>  	atomic_inc(&oz->oz_ref);
> -	old_oz = xchg(&VFS_I(ip)->i_private, oz);
> +	spin_unlock(&ip->i_flags_lock);
>  	if (old_oz)
>  		xfs_open_zone_put(old_oz);
> +	return oz;
>  }
>  
>  static void
> @@ -873,14 +914,13 @@ xfs_zone_alloc_and_submit(
>  	 * the inode is still associated with a zone and use that if so.
>  	 */
>  	if (!*oz)
> +select_zone:
>  		*oz = xfs_get_cached_zone(ip);
> -
>  	if (!*oz) {
> -select_zone:
>  		*oz = xfs_select_zone(mp, write_hint, pack_tight);
>  		if (!*oz)
>  			goto out_error;
> -		xfs_set_cached_zone(ip, *oz);
> +		*oz = xfs_set_cached_zone(ip, *oz);
>  	}
>  
>  	alloc_len = xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size),
> -- 
> 2.53.0
> 
> 
