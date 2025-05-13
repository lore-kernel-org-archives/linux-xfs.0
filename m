Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289951DB12E
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 08:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126186; cv=none; b=FnvjWyEjYts/PrhDvyT6kV4u/NJeT5N7e9sK9Ih/pr7PaFysdKj093rTGi6QyHFakucOOusi3iTtMBPuDDfA/XwLk/u+elmb9UFBH3D7ycv+MlTuU+o2o6Q7ugog/gzOoOCvVMUGkCYxXOXHQDsy9H+GVISPlx9WiCmgx/V4V5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126186; c=relaxed/simple;
	bh=qOwWeDp1DOgR6a0SVDqpTbL0qiKzEwifqQRspzTkGEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSTvcMetB4wx2C5WWJlobDxWEHlhO6jEp1UUfk3NR8lPFLGxKI5Xrw+oNF0MrxnKvtOX0ibpyxNSQLGn21IKpjWUmGpDGOmXFkw3FHh5BrToiZaezg4X0WgrU/USXpWH7cpnjr+vi7kMCdvY/wPcMbR/xdNiliZBvXcg0h9TeHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCfMCYNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCfMCYNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB1CC4CEE4;
	Tue, 13 May 2025 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747126185;
	bh=qOwWeDp1DOgR6a0SVDqpTbL0qiKzEwifqQRspzTkGEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kCfMCYNddBly08qx81UCW8U8XjJ05DOATZKo7ORINsKcvQmQMq163YXBHh0BJbtVN
	 ykrS5HGQXp7XfP8fz4F/nufuA69N6j0QO9lE8iO9LoV4KGp/ho84sGnUtz2oYZ4k32
	 Y+ybIs2p+cErCI3zhBgXe1LJK5lCf15M7uLQJkd8FvGIyjDzUJLUIED03dbOl084Or
	 vPwSbWq71mCSPAgx5jfFySGVAqzUhd47ZJi1xgF2+suZTHmx7S5socU/Fn6dMShq8V
	 xxmsvVPNgRSazGSpoFarOErLlnG0m28OZqBcBdBJQdYRjamZR7ny9UYzyaYbFcc1/c
	 eK/LDDb2ZGc4Q==
Date: Tue, 13 May 2025 10:49:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <lkaqkzbb7spc5n4v2eomlmp23ia52wcrcktv4sjscupdgrw7lt@txlcuvqwv4uh>
References: <lwf6FP6bvClFnnDLscr2Wzt31ZMf-v2JtA-UvFrZWuq8doDoxgvYr6yRjjkRSUbKQ9AH1SQH_9Zar2yIALzAUA==@protonmail.internalid>
 <20250510155301.GC2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250510155301.GC2701446@frogsfrogsfrogs>

On Sat, May 10, 2025 at 08:53:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> syscall and parent pointers were merged in the same cycle.  None of
> these have encountered any serious errors in the year that they've been
> in the kernel (or the many many years they've been under development) so
> let's drop the shouty warnings.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

No objections either.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_message.h |    3 ---
>  fs/xfs/scrub/scrub.c |    2 --
>  fs/xfs/xfs_message.c |   12 ------------
>  fs/xfs/xfs_super.c   |    7 -------
>  4 files changed, 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index a92a4d09c8e9fa..bce9942f394a6f 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -92,12 +92,9 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
> 
>  enum xfs_experimental_feat {
>  	XFS_EXPERIMENTAL_PNFS,
> -	XFS_EXPERIMENTAL_SCRUB,
>  	XFS_EXPERIMENTAL_SHRINK,
>  	XFS_EXPERIMENTAL_LARP,
>  	XFS_EXPERIMENTAL_LBS,
> -	XFS_EXPERIMENTAL_EXCHRANGE,
> -	XFS_EXPERIMENTAL_PPTR,
>  	XFS_EXPERIMENTAL_METADIR,
>  	XFS_EXPERIMENTAL_ZONED,
> 
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 9908850bf76f9e..76e24032e99a53 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -680,8 +680,6 @@ xfs_scrub_metadata(
>  	if (error)
>  		goto out;
> 
> -	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SCRUB);
> -
>  	sc = kzalloc(sizeof(struct xfs_scrub), XCHK_GFP_FLAGS);
>  	if (!sc) {
>  		error = -ENOMEM;
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 15d410d16bb27c..54fc5ada519c43 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -145,10 +145,6 @@ xfs_warn_experimental(
>  			.opstate	= XFS_OPSTATE_WARNED_PNFS,
>  			.name		= "pNFS",
>  		},
> -		[XFS_EXPERIMENTAL_SCRUB] = {
> -			.opstate	= XFS_OPSTATE_WARNED_SCRUB,
> -			.name		= "online scrub",
> -		},
>  		[XFS_EXPERIMENTAL_SHRINK] = {
>  			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
>  			.name		= "online shrink",
> @@ -161,14 +157,6 @@ xfs_warn_experimental(
>  			.opstate	= XFS_OPSTATE_WARNED_LBS,
>  			.name		= "large block size",
>  		},
> -		[XFS_EXPERIMENTAL_EXCHRANGE] = {
> -			.opstate	= XFS_OPSTATE_WARNED_EXCHRANGE,
> -			.name		= "exchange range",
> -		},
> -		[XFS_EXPERIMENTAL_PPTR] = {
> -			.opstate	= XFS_OPSTATE_WARNED_PPTR,
> -			.name		= "parent pointer",
> -		},
>  		[XFS_EXPERIMENTAL_METADIR] = {
>  			.opstate	= XFS_OPSTATE_WARNED_METADIR,
>  			.name		= "metadata directory tree",
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 696874e72eacf1..b4e830fe101b2f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1953,13 +1953,6 @@ xfs_fs_fill_super(
>  		}
>  	}
> 
> -
> -	if (xfs_has_exchange_range(mp))
> -		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_EXCHRANGE);
> -
> -	if (xfs_has_parent(mp))
> -		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PPTR);
> -
>  	/*
>  	 * If no quota mount options were provided, maybe we'll try to pick
>  	 * up the quota accounting and enforcement flags from the ondisk sb.
> 
