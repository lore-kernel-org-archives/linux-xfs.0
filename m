Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9928C1E
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 18:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718994229; cv=none; b=AHgx93jXLJa40aPJJEXlDJTqibg/gP5NciaCNNzZd5egQ7hAUUeq8cA8AKh8u1efu/maZYFTLrZsiUuhuacXZo+7VF0lzVoA8bsLyHMSmkogoRxPz+LItXRVWpP9X9F1zPF0CoOeQSvl1qiuqjm0CRCown7QvqnQkYq88gsZLRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718994229; c=relaxed/simple;
	bh=wWjqJo5B+7BO5TC8lZmNfcuq2jfEOV3d5CQvEkCswik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SkMoiic8vFLgiHvnq+WH9p9pjPO+TLcgGsIjH1qaF6QvM3ZFSpcTEha/XrmXysImlUMHTVHb4P0+Zbp4/FmWMAmKuwSSHNIxGIGAStLDYyN+VEhQNNC7mRhDyqJXNWXXvXJsdxQlG0x3weqbh3FG9QCjVxObRmZWlc4pVBHSPRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpuKpl98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpuKpl98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2FFC2BBFC;
	Fri, 21 Jun 2024 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718994228;
	bh=wWjqJo5B+7BO5TC8lZmNfcuq2jfEOV3d5CQvEkCswik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dpuKpl98YgxdvT3bOCnv+Ph2v6zUUbrSwD+WsENjMNe9xZxnkWmc7niZo4lpx4M86
	 18dtLtCz81UbAtm/UpQNH/Gi8OM2RRwiKzk66V7JWgTV8bNpxhaxxGk0q4SR1J2Qkh
	 H0+T2AvwttRSSf2hk6HmWHzbcCqcYzSfosNwJoReUizCahPMpk9qdJw5p42DpKqjJ9
	 MBCgbYxyIjbgf4MMrmwiT4aAIaQmlLDfhpH6GYNZ9MDohIo25YOxrBiW3HRKil0WRR
	 c2ADY7INWJD/iJLLAxg1QKB06+9wGG7Wbd9YDwX8WxdJnNt1/ZvVBLmZ/FaOaVHbGu
	 BgY5qI5zE/AIA==
Date: Fri, 21 Jun 2024 11:23:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Konst Mayer <cdlscpmv@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] xfs: enable FITRIM on the realtime device
Message-ID: <20240621182348.GJ3058325@frogsfrogsfrogs>
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
 <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs>
 <ZnUI8Jd1m5j0RUN5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnUI8Jd1m5j0RUN5@infradead.org>

On Thu, Jun 20, 2024 at 10:00:32PM -0700, Christoph Hellwig wrote:
> > +	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev))
> > +		goto rt_discard;
> > +
> 
> I think this would looks much better if we split the ddev trimming
> into a separate helper, just like this patch does for the RT device:
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 3ad5b0505848b0..4eb71edf732c48 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -595,6 +595,48 @@ xfs_trim_rtdev_extents(
>  # define xfs_trim_rtdev_extents(m,s,e,n,b)	(-EOPNOTSUPP)
>  #endif /* CONFIG_XFS_RT */
>  
> +static int
> +xfs_trim_dddev_extents(
> +	struct xfs_mount	*mp,
> +	xfs_daddr_t		start,
> +	xfs_daddr_t		end,
> +	xfs_extlen_t		minlen,
> +	uint64_t		*blocks_trimmed)
> +{
> +	xfs_agnumber_t		start_agno, end_agno;
> +	xfs_agblock_t		start_agbno, end_agbno;
> +	xfs_daddr_t		ddev_end;
> +	struct xfs_perag	*pag;
> +	int			last_error = 0, error;
> +
> +	ddev_end = min_t(xfs_daddr_t, end,
> +			 XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);
> +
> +	start_agno = xfs_daddr_to_agno(mp, start);
> +	start_agbno = xfs_daddr_to_agbno(mp, start);
> +	end_agno = xfs_daddr_to_agno(mp, ddev_end);
> +	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
> +
> +	for_each_perag_range(mp, start_agno, end_agno, pag) {
> +		xfs_agblock_t	agend = pag->block_count;
> +
> +		if (start_agno == end_agno)
> +			agend = end_agbno;
> +		error = xfs_trim_extents(pag, start_agbno, agend, minlen,
> +				blocks_trimmed);
> +		if (error)
> +			last_error = error;
> +
> +		if (xfs_trim_should_stop()) {
> +			xfs_perag_rele(pag);
> +			break;
> +		}
> +		start_agbno = 0;
> +	}
> +
> +	return last_error;
> +}
> +
>  /*
>   * trim a range of the filesystem.
>   *
> @@ -612,15 +654,12 @@ xfs_ioc_trim(
>  	struct xfs_mount		*mp,
>  	struct fstrim_range __user	*urange)
>  {
> -	struct xfs_perag	*pag;
>  	unsigned int		granularity =
>  		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
>  	struct block_device	*rt_bdev = NULL;
>  	struct fstrim_range	range;
> -	xfs_daddr_t		start, end, ddev_end;
> +	xfs_daddr_t		start, end;
>  	xfs_extlen_t		minlen;
> -	xfs_agnumber_t		start_agno, end_agno;
> -	xfs_agblock_t		start_agbno, end_agbno;
>  	xfs_rfsblock_t		max_blocks;
>  	uint64_t		blocks_trimmed = 0;
>  	int			error, last_error = 0;
> @@ -666,35 +705,13 @@ xfs_ioc_trim(
>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
>  
> -	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev))
> -		goto rt_discard;
> -
> -	ddev_end = min_t(xfs_daddr_t, end,
> -			 XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);
> -
> -	start_agno = xfs_daddr_to_agno(mp, start);
> -	start_agbno = xfs_daddr_to_agbno(mp, start);
> -	end_agno = xfs_daddr_to_agno(mp, ddev_end);
> -	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
> -
> -	for_each_perag_range(mp, start_agno, end_agno, pag) {
> -		xfs_agblock_t	agend = pag->block_count;
> -
> -		if (start_agno == end_agno)
> -			agend = end_agbno;
> -		error = xfs_trim_extents(pag, start_agbno, agend, minlen,
> +	if (bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev)) {
> +		error = xfs_trim_dddev_extents(mp, start, end, minlen,
>  				&blocks_trimmed);

I quite like this cleanup, though I think I'll name the helper
xfs_trim_datadev_extents instead.

>  		if (error)
>  			last_error = error;
> -
> -		if (xfs_trim_should_stop()) {
> -			xfs_perag_rele(pag);
> -			break;
> -		}
> -		start_agbno = 0;
>  	}
>  
> -rt_discard:
>  	if (rt_bdev && bdev_max_discard_sectors(rt_bdev)) {

This needs to check !xfs_trim_should_stop() as well, so that a ^C during
the data device discard isn't followed by a rtbitmap query.

Will send a V2.

--D

>  		error = xfs_trim_rtdev_extents(mp, start, end, minlen,
>  				&blocks_trimmed);
> 
