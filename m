Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD1478F4F
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753287582; cv=none; b=evrCXud2lbtCV+RZ/lom+2X7bXlbEKbOY+pR6LUi4aoSouzJan3PVtz7xGoq/BcZ4PKP1jB2iW8qF/UBWyZeTSInW1jfvulHUMpA8xb5C9BIH3lf1bQx3zJ/G4MQY5MIH34k5t3vMt8gXCRfI0kP++lkkB/YprhEDyStcPt0S8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753287582; c=relaxed/simple;
	bh=LA9bzu0iwqj+xGHrDIOpVUJricZ+xdeNpEYT/VSD42g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYo5W6qEzbuLbAzJhvCpq3E7WAoCGS1JPBRnC43qZ9QbPvlAeBYP8soOdaKmX09N1sU8QntClvNauyW11yEpybwBSf5y6brPhR7H5BeaByLhru/BtXZyp7eJu3YHTozwyPOjPQtOgWFiAuTbGgTwK1ASn3glK5/ifFTBukA0H70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGjsCCBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGjsCCBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D103C4CEE7;
	Wed, 23 Jul 2025 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753287581;
	bh=LA9bzu0iwqj+xGHrDIOpVUJricZ+xdeNpEYT/VSD42g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nGjsCCBJH2nqnhnhh3NgZLYKKhNNPrbEu+IZ7PWnJ++Xa/btEtarOUCieskfhkwF1
	 g4zwx+we6TOlaH8rphz/Y70EhQf/coDGazOJEw4heQxjL7WOPXwwFiAy5HRsDo5306
	 Z0uuc8hR0Jg/oltUpEhHQre7VWu07HpnpBY4nnFLDi2vivv9pTJoZKVE6a97Ta/mz6
	 8AImQEWZYgi/+6YlSyjn1Lxzj7mxxIE4guzSZ73abMl7b45cXLJSR56sR3JUEEtT3E
	 wPKNdkG+4wJ7b/wk6Ap2DVZIVSgD+tls6l7t38mtcZxX3XeujiPBehTvQ0Ud2DofJt
	 I38XULL3YMo9w==
Date: Wed, 23 Jul 2025 09:19:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: split xfs_zone_record_blocks
Message-ID: <20250723161940.GW2672049@frogsfrogsfrogs>
References: <20250723053544.3069555-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723053544.3069555-1-hch@lst.de>

On Wed, Jul 23, 2025 at 07:35:44AM +0200, Christoph Hellwig wrote:
> xfs_zone_record_blocks not only records successfully written blocks that
> now back file data, but is also used for blocks speculatively written by
> garbage collection that were never linked to an inode and instantly
> become invalid.
> 
> Split the latter functionality out to be easier to understand.  This also
> make it clear that we don't need to attach the rmap inode to a
> transaction for the skipped blocks case as we never dirty any peristent
> data structure.
> 
> Also make the argument order to xfs_zone_record_blocks a bit more
> natural.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trace.h      |  1 +
>  fs/xfs/xfs_zone_alloc.c | 42 ++++++++++++++++++++++++++++-------------
>  2 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 10d4fd671dcf..178b204dee3b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -455,6 +455,7 @@ DEFINE_EVENT(xfs_zone_alloc_class, name,			\
>  		 xfs_extlen_t len),				\
>  	TP_ARGS(oz, rgbno, len))
>  DEFINE_ZONE_ALLOC_EVENT(xfs_zone_record_blocks);
> +DEFINE_ZONE_ALLOC_EVENT(xfs_zone_skip_blocks);
>  DEFINE_ZONE_ALLOC_EVENT(xfs_zone_alloc_blocks);
>  
>  TRACE_EVENT(xfs_zone_gc_select_victim,
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 33f7eee521a8..f8bd6d741755 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -166,10 +166,9 @@ xfs_open_zone_mark_full(
>  static void
>  xfs_zone_record_blocks(
>  	struct xfs_trans	*tp,
> -	xfs_fsblock_t		fsbno,
> -	xfs_filblks_t		len,
>  	struct xfs_open_zone	*oz,
> -	bool			used)
> +	xfs_fsblock_t		fsbno,
> +	xfs_filblks_t		len)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_rtgroup	*rtg = oz->oz_rtg;
> @@ -179,18 +178,37 @@ xfs_zone_record_blocks(
>  
>  	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
>  	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
> -	if (used) {
> -		rmapip->i_used_blocks += len;
> -		ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
> -	} else {
> -		xfs_add_frextents(mp, len);
> -	}
> +	rmapip->i_used_blocks += len;
> +	ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
>  	oz->oz_written += len;
>  	if (oz->oz_written == rtg_blocks(rtg))
>  		xfs_open_zone_mark_full(oz);
>  	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
>  }
>  
> +/*
> + * Called for blocks that have been written to disk, but not actually linked to
> + * an inode, which can happen when garbage collection races with user data
> + * writes to a file.
> + */
> +static void
> +xfs_zone_skip_blocks(
> +	struct xfs_open_zone	*oz,
> +	xfs_filblks_t		len)
> +{
> +	struct xfs_rtgroup	*rtg = oz->oz_rtg;
> +
> +	trace_xfs_zone_skip_blocks(oz, 0, len);
> +
> +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +	oz->oz_written += len;
> +	if (oz->oz_written == rtg_blocks(rtg))
> +		xfs_open_zone_mark_full(oz);
> +	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> +
> +	xfs_add_frextents(rtg_mount(rtg), len);
> +}
> +
>  static int
>  xfs_zoned_map_extent(
>  	struct xfs_trans	*tp,
> @@ -250,8 +268,7 @@ xfs_zoned_map_extent(
>  		}
>  	}
>  
> -	xfs_zone_record_blocks(tp, new->br_startblock, new->br_blockcount, oz,
> -			true);
> +	xfs_zone_record_blocks(tp, oz, new->br_startblock, new->br_blockcount);
>  
>  	/* Map the new blocks into the data fork. */
>  	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, new);
> @@ -259,8 +276,7 @@ xfs_zoned_map_extent(
>  
>  skip:
>  	trace_xfs_reflink_cow_remap_skip(ip, new);
> -	xfs_zone_record_blocks(tp, new->br_startblock, new->br_blockcount, oz,
> -			false);
> +	xfs_zone_skip_blocks(oz, new->br_blockcount);
>  	return 0;
>  }
>  
> -- 
> 2.47.2
> 
> 
