Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F2E27D770
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388234; cv=none; b=Aw3ZGtRh5pZ4xLHdeRD29od1b9pgn04h7ZWUo/vncG0W+Z3xtZ7EQVn/aKuT18OH3SvJihz9egha6hooS6yfgCCFSh18zL3aiQZTzRFhBsCI0XgHXx+foR9m74hPZj/xXJgRs32wezCZabhcSmtn8CgNRJZsI1F9HBZzGh954kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388234; c=relaxed/simple;
	bh=ek9wpg9xKqtOD1R8Q6LPxS+c0wNweqw4mr6C9K11mIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQ5vMd0ylDqW3fIuGFCryRsGKvEleQkdzGwIAGqE2RbeHd7z94B6FQkMgbrgpTGcASlmCZFBQcVEe96PU9hE38WnHVktQeYAVu+AT7LFCuuehoiQp0ifPRk9ZpkrpgqrXPKaC9H92F2F2IFQ2CkMxLNrPP1qsi7VfbA2b3x6kzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKwtfdvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKwtfdvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A082C4CEEB;
	Tue,  1 Jul 2025 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751388234;
	bh=ek9wpg9xKqtOD1R8Q6LPxS+c0wNweqw4mr6C9K11mIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eKwtfdvwfEEu9Vhu5bYR4TluVcwFD+F0CpfH+GXn567oSvUd3UMq5CCwx8/RJqUwX
	 rdVYjq7DKuv4Ts3m41COQ2bneKS5oHVfVnInRPKLEQ3zRoUL2NlARCLhtK5ZQ069ch
	 1GfANWsdse3+IvxWHO/ZX5eEcgX3gmfEY8encauKj9xaz4qEFEO9NN2GnN7lhSYuHW
	 +6MOxKdKIpWe1Ieds2+80pI4NZa1D0cG/96IAYQ0FDwafRAfNk3s/2rEEGMVucM/PU
	 JHgsBllDaXwQegzmp+xnXBPj4s1tgmCNJejjcRlXMyhy2xfEYAsWlweM4SYclUKAU3
	 94Hm62k4cnXhg==
Date: Tue, 1 Jul 2025 09:43:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: add a xfs_group_type_buftarg helper
Message-ID: <20250701164353.GG10009@frogsfrogsfrogs>
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701104125.1681798-4-hch@lst.de>

On Tue, Jul 01, 2025 at 12:40:37PM +0200, Christoph Hellwig wrote:
> Generalize the xfs_group_type helper in the discard code to return a buftarg
> and move it to xfs_mount.h, and use the result in xfs_dax_notify_dev_failure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c        | 29 +++++++----------------------
>  fs/xfs/xfs_mount.h          | 17 +++++++++++++++++
>  fs/xfs/xfs_notify_failure.c |  3 +--
>  3 files changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 94d0873bcd62..603d51365645 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -103,24 +103,6 @@ xfs_discard_endio(
>  	bio_put(bio);
>  }
>  
> -static inline struct block_device *
> -xfs_group_bdev(
> -	const struct xfs_group	*xg)
> -{
> -	struct xfs_mount	*mp = xg->xg_mount;
> -
> -	switch (xg->xg_type) {
> -	case XG_TYPE_AG:
> -		return mp->m_ddev_targp->bt_bdev;
> -	case XG_TYPE_RTG:
> -		return mp->m_rtdev_targp->bt_bdev;
> -	default:
> -		ASSERT(0);
> -		break;
> -	}
> -	return NULL;
> -}
> -
>  /*
>   * Walk the discard list and issue discards on all the busy extents in the
>   * list. We plug and chain the bios so that we only need a single completion
> @@ -138,11 +120,14 @@ xfs_discard_extents(
>  
>  	blk_start_plug(&plug);
>  	list_for_each_entry(busyp, &extents->extent_list, list) {
> -		trace_xfs_discard_extent(busyp->group, busyp->bno,
> -				busyp->length);
> +		struct xfs_group	*xg = busyp->group;
> +		struct xfs_buftarg	*btp =
> +			xfs_group_type_buftarg(xg->xg_mount, xg->xg_type);
> +
> +		trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
>  
> -		error = __blkdev_issue_discard(xfs_group_bdev(busyp->group),
> -				xfs_gbno_to_daddr(busyp->group, busyp->bno),
> +		error = __blkdev_issue_discard(btp->bt_bdev,
> +				xfs_gbno_to_daddr(xg, busyp->bno),
>  				XFS_FSB_TO_BB(mp, busyp->length),
>  				GFP_KERNEL, &bio);
>  		if (error && error != -EOPNOTSUPP) {
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index d85084f9f317..97de44c32272 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -802,4 +802,21 @@ static inline void xfs_mod_sb_delalloc(struct xfs_mount *mp, int64_t delta)
>  int xfs_set_max_atomic_write_opt(struct xfs_mount *mp,
>  		unsigned long long new_max_bytes);
>  
> +static inline struct xfs_buftarg *
> +xfs_group_type_buftarg(
> +	struct xfs_mount	*mp,
> +	enum xfs_group_type	type)
> +{
> +	switch (type) {
> +	case XG_TYPE_AG:
> +		return mp->m_ddev_targp;
> +	case XG_TYPE_RTG:
> +		return mp->m_rtdev_targp;
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +	return NULL;
> +}
> +
>  #endif	/* __XFS_MOUNT_H__ */
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index 3545dc1d953c..42e9c72b85c0 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -253,8 +253,7 @@ xfs_dax_notify_dev_failure(
>  		return -EOPNOTSUPP;
>  	}
>  
> -	error = xfs_dax_translate_range(type == XG_TYPE_RTG ?
> -			mp->m_rtdev_targp : mp->m_ddev_targp,
> +	error = xfs_dax_translate_range(xfs_group_type_buftarg(mp, type),
>  			offset, len, &daddr, &bblen);
>  	if (error)
>  		return error;
> -- 
> 2.47.2
> 
> 
