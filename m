Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDFE4BFE7B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281601; cv=none; b=W0jb7qVKuNSCwEaOKGn6WpZO81AIBlAGrYhWEJ1KSy2pG3fRrmOfI6u4WgOOcvgOa9nv86zlXNceAxCo/1LAAOnNTWgtKPzRU/GQMLxQcr+TiNshyDKwAaqLLsAF5+RAGIkG7SB5L3DSsrOHU4OVuas/tB1A1Fw6JkUsQto3hXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281601; c=relaxed/simple;
	bh=qo6rnjy/ehVVqQ37NahL4X8gedo3wgKnHpaJ0tnUQbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ev7ygLSn41vcJyHalpgH4QiXDUP70rirCtx9zBK6xal0uU4d1zGj+JBZJiekBXYs4ZmRvllGws1+COAIQExDImfz67cXwvCaBQFkSmO2rUXOGqxPLd4J0byY1vBAZmDLDzYsa2/jFFVLuCUQTS4rc5jHPUlV3sr3iJqikxXkaok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPf+2U/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPf+2U/k"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 71BC21F000FF;
	Thu, 24 Sep 2026 20:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281597;
	bh=BqwJ8kThHB9xyJafMZ0NHduhp7QNtb4iOmYAllscM+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JPf+2U/km9bDL/iaeMA7Ro9WvZtz6zBhOmH5x0osTDzAeaY0gxh5wfKYmZIRcrmlB
	 Dbb1L32YRK2rK7K+7t7YYeroKV8mscq+B6Y4vpdHHFbP2VWRWFwSIDYhn7MP5R2N9+
	 XNd2W/mCjvxIAoMcLWNSJDbu/hiOtP8jyfY3zAMfnwGZcTY7Kd9aWNF6Nbbpq+k1I5
	 0DdKJKhTaHhUMzTd1RrqTw2UWxxsrz/VqNunWG2pHeXhoSEBJ7X2RqJpCnLzf3nQLt
	 AbDutab6h/XdOIeVkyRMYA0LU9/bOv6d82UJmhGeMJKdAMst5csH5VpQQ6qX2R65Pi
	 d6AmCN1dtbOXg==
Date: Thu, 24 Sep 2026 13:26:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: split xfs_end_ioend_write
Message-ID: <20260924202637.GW2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-8-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:08AM +0200, Christoph Hellwig wrote:
> Split out a separate helper for the zoned I/O completions as the code
> flow is pretty different already and will become even more so soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioend.c | 63 ++++++++++++++++++++++++++++------------------
>  1 file changed, 39 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index 258c6130bee8..f0e01ac34de8 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -147,11 +147,40 @@ xfs_ioend_submit_read(
>  }
>  
>  static void
> -xfs_ioend_put_open_zones(
> +xfs_end_ioend_write_zoned(
>  	struct iomap_ioend	*ioend)
>  {
> -	struct iomap_ioend *tmp;
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_open_zone	*oz = ioend->io_private;
> +	struct iomap_ioend	*tmp;
> +	int			error = -EIO;
> +
> +	ASSERT(!(ioend->io_flags & IOMAP_IOEND_SHARED));
> +
> +	if (xfs_is_shutdown(ip->i_mount))
> +		goto done;
>  
> +	/*
> +	 * Zoned writes update the in-core open zone accounting before I/O
> +	 * submission.  A failed write leaves that state inconsistent, so shut
> +	 * down the filesystem instead of letting later writers wait forever for
> +	 * open zone space to become available.
> +	 */
> +	error = blk_status_to_errno(ioend->io_bio.bi_status);
> +	if (unlikely(error)) {
> +		xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
> +		goto done;
> +	}
> +
> +	error = xfs_zoned_end_io(ip, ioend->io_offset, ioend->io_size,
> +			ioend->io_sector, oz, NULLFSBLOCK);
> +	if (error)
> +		goto done;
> +
> +	if (!(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
> +	    xfs_ioend_is_append(ioend))
> +		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
> +done:
>  	/*
>  	 * Put the open zone for all ioends merged into this one (if any).
>  	 */
> @@ -162,8 +191,9 @@ xfs_ioend_put_open_zones(
>  	 * The main ioend might not have an open zone if the submission failed
>  	 * before xfs_zone_alloc_and_submit got called.
>  	 */
> -	if (ioend->io_private)
> -		xfs_open_zone_put(ioend->io_private);
> +	if (oz)
> +		xfs_open_zone_put(oz);
> +	iomap_finish_ioends(ioend, error);
>  }
>  
>  static void
> @@ -172,7 +202,6 @@ xfs_end_ioend_write(
>  {
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	bool			is_zoned = xfs_is_zoned_inode(ip);
>  	xfs_off_t		offset = ioend->io_offset;
>  	size_t			size = ioend->io_size;
>  	int			error;
> @@ -194,19 +223,7 @@ xfs_end_ioend_write(
>  	 */
>  	error = blk_status_to_errno(ioend->io_bio.bi_status);
>  	if (unlikely(error)) {
> -		/*
> -		 * Zoned writes update the in-core open zone accounting before
> -		 * I/O submission.  A failed write leaves that state
> -		 * inconsistent, so shut down the filesystem instead of letting
> -		 * later writers wait forever for open zone space to become
> -		 * available.
> -		 */
> -		if (is_zoned) {
> -			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> -			goto done;
> -		}
>  		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
> -			ASSERT(!is_zoned);
>  			xfs_reflink_cancel_cow_range(ip, offset, size, true);
>  			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
>  					offset + size, NULL);
> @@ -217,10 +234,7 @@ xfs_end_ioend_write(
>  	/*
>  	 * Success: commit the COW or unwritten blocks if needed.
>  	 */
> -	if (is_zoned)
> -		error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
> -				ioend->io_private, NULLFSBLOCK);
> -	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
> +	if (ioend->io_flags & IOMAP_IOEND_SHARED)
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> @@ -230,8 +244,6 @@ xfs_end_ioend_write(
>  	    xfs_ioend_is_append(ioend))
>  		error = xfs_setfilesize(ip, offset, size);
>  done:
> -	if (is_zoned)
> -		xfs_ioend_put_open_zones(ioend);
>  	iomap_finish_ioends(ioend, error);
>  }
>  
> @@ -276,7 +288,10 @@ xfs_end_io(
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
>  		iomap_ioend_try_merge(ioend, &tmp);
> -		xfs_end_ioend_write(ioend);
> +		if (xfs_is_zoned_inode(ip))
> +			xfs_end_ioend_write_zoned(ioend);
> +		else
> +			xfs_end_ioend_write(ioend);
>  		cond_resched();
>  	}
>  	memalloc_nofs_restore(nofs_flag);
> -- 
> 2.53.0
> 
> 
