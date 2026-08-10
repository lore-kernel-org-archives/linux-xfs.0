Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7763236BCDE
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386104; cv=none; b=a9Rz3TovN9THlaaeDMko4XSvJxFXqCeyC6rgO5uqIJN/vkHWTbG8n7BzGd46QrcaEtITpOtNnqAGu1RhPCU+rlDiDU/BwbA8kmWlY/84EKXZUMFusfq1IxDN2rJe7c0iVpiNYG94qMX41g0GWhZifINL/tVFg2uHxnudWz+ysjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386104; c=relaxed/simple;
	bh=ral42JLbZOkngpP1Ql7MrLvCLOwvA75j3J+6wjTOlUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rR/9K3rycDLRznU8cIrdAexOqmVzjvrTQmW3gl1KjaNcl4+qKXQvbknsdrOsm7cFTpqzfS98FMTll6sy9hJaZvEFo6yOhCwHD1JdpQlt7yyG9CGE8BE7KZjBLIdJ0R1xejF0kIJZs0tXjBAxejMxBer3CBQciLhAdQN2qrsgOo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AH92HKD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AH92HKD5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 166431F000E9;
	Mon, 10 Aug 2026 18:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786386103;
	bh=7M4hcEVHMMA+CTz4y+siqzp6n0815RUgr0a+/x5Szcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AH92HKD5WSZ3Ijyl+by6W+0sJkI47YWrSs7hjcfclViYyILD2Ovs0b+sD4bkS2Wwl
	 GXSaITVsZOImRbUZp9cz3krl6+04zxIp9AXU1H0wxSTWq4oQCT9WU4ymeZZI2Bf/4I
	 Oou4zzFWdBkSA6wXfYLxzdYfF4w/Z19VgY7VNiUUpw01aGst8CuaJK4JxjhxxTCoSO
	 HUNp/fgQ1Mu30Qguh5QuuVp0qZELtP2agAE1apufR9EcvTreL0nTI2MOUOIIoMk2Mp
	 jy2SG+2GK6votoPK7Qxn3VYm9J2116RSBFjxt3s7naI7m+iKHsSvxB5RK7RTfshrr8
	 xQpuA+UrQ0iNw==
Date: Mon, 10 Aug 2026 11:21:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fix racy open zone caching
Message-ID: <20260810182142.GW3556460@frogsfrogsfrogs>
References: <20260810153759.466417-1-hch@lst.de>
 <20260810153759.466417-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810153759.466417-3-hch@lst.de>

On Mon, Aug 10, 2026 at 08:37:43AM -0700, Christoph Hellwig wrote:
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
> ---
>  fs/xfs/xfs_zone_alloc.c | 56 +++++++++++++++++++++++++++++++----------
>  1 file changed, 43 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 7d13fa7ab30a..dee21f65f7b7 100644
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
> +	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
> +		oz = NULL;

Do we still need to test oz for null-ness here?  AFAICT we've already
handled those cases here.

> +out_unlock:
> +	rcu_read_unlock();
>  	return oz;
>  }
>  
> @@ -819,17 +837,30 @@ xfs_get_cached_zone(
>   * lookup.  Because the open_zone is clearly marked as full when all data
>   * in the underlying RTG was written, the caching is always safe.
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
> +	 * instead of the inode we just selected.  This can happen when multiple
> +	 * threads race to perform zone selection for an inode.  io_uring worker
> +	 * threads seem to be good at triggering this.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	old_oz = VFS_I(ip)->i_private;
> +	if (old_oz && old_oz->oz_allocated < rtg_blocks(old_oz->oz_rtg))
> +		swap(oz, old_oz);
>  	atomic_inc(&oz->oz_ref);

Hmm, I'm confused about oz_ref handling here.

If old_oz still has space, we swap oz and old_oz, after which oz alias
i_private and old_oz is the zone that the caller passed in.  The above
line then increments oz->oz_ref and puts the zone that the caller passed
in.

Doesn't that cause oz->oz_ref to be too high?  We already had a ref
via i_private, and now we have another one.

--D

> -	old_oz = xchg(&VFS_I(ip)->i_private, oz);
> +	VFS_I(ip)->i_private = oz;
> +	spin_unlock(&ip->i_flags_lock);
> +
>  	if (old_oz)
>  		xfs_open_zone_put(old_oz);
> +	return oz;
>  }
>  
>  static void
> @@ -873,14 +904,13 @@ xfs_zone_alloc_and_submit(
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
