Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDED2F2F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041354; cv=none; b=ptanrhTtdAZkWC8WczssW9ooqmhK6+d8J/nIVQ0Z6UlF6BD0MDHBXYA9Vq0hrPrE5NkH5Lm+vJVJSLxHpEJUS9m0TUh+gc9h0WB/NEOPsTnP+qCa2cmXurhRZGTNAXZv9oW9HB6Fup5e1NasxS0w/Wl4n544RmxiTlsNnUq84BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041354; c=relaxed/simple;
	bh=zA5C5RAFS9O/wR8CQqn6teVSPxgixl7I5hwGRVGt034=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eg88yrxhJ/t0Osj6ble6oDvguQS+m+u+U5vMeTpRdaUPTgNdyTvCXkaq9we/rogOupShelzKTUkMT/exkHXNx8XXTk1vVNn5ERJCZWbN1BcMpsVvhQA3KlnqLMjq8tJsOZ2XwT9wspMzV8Sl8L2PmLFUfMeBf6SLRvsoeQc+xrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUuu83HE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUuu83HE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66DAC4CECE;
	Thu, 12 Dec 2024 22:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734041353;
	bh=zA5C5RAFS9O/wR8CQqn6teVSPxgixl7I5hwGRVGt034=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUuu83HEJDhvDy1v23332vjSdHTj7BN85WlkRXwAetBzra/dtlz8ljBgB4BuHp8tN
	 TQT2BEKwqKlg5dXV4aCET5RhF/m3xW+VKrle1jSMPTd/Jlar+e6Wov9osXlmq8hdqK
	 roOLZcBvVMHGZMz/ie8LNTuPrR+ypndnTK+r5+uyoQvtP5gq95fClt66BtAW05YleO
	 Rtg919N0XKo8C8CMZNobolt0OZk8poVzQ1oFufun/zkqiW2KiNTYg6A1ZjDaQ8U/3C
	 fkhFii2vDCCU9OATamEBNe9lslM/PsXwUlamfaTaEhvJLzKdkjgEUZwyY3ygZPlUS8
	 Fis9alN6fXEXw==
Date: Thu, 12 Dec 2024 14:09:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/43] xfs: export zoned geometry via XFS_FSOP_GEOM
Message-ID: <20241212220913.GD6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-19-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:43AM +0100, Christoph Hellwig wrote:
> Export the zoned geometry information so that userspace can query it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 5 ++++-
>  fs/xfs/libxfs/xfs_sb.c | 6 ++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2c3171262b44..5e66fb2b2cc7 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -189,7 +189,9 @@ struct xfs_fsop_geom {
>  	uint32_t	checked;	/* o: checked fs & rt metadata	*/
>  	__u32		rgextents;	/* rt extents in a realtime group */
>  	__u32		rgcount;	/* number of realtime groups	*/
> -	__u64		reserved[16];	/* reserved space		*/
> +	__u64		rtstart;	/* start of internal rt section */
> +	__u64		rtreserved;	/* RT (zoned) reserved blocks	*/
> +	__u64		reserved[14];	/* reserved space		*/
>  };
>  
>  #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
> @@ -247,6 +249,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
>  #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
>  #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
> +#define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 20b8318d4a59..6fc21c0a332b 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1541,6 +1541,8 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
>  	if (xfs_has_metadir(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
> +	if (xfs_has_zoned(mp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
> @@ -1561,6 +1563,10 @@ xfs_fs_geometry(
>  		geo->rgcount = sbp->sb_rgcount;
>  		geo->rgextents = sbp->sb_rgextents;
>  	}
> +	if (xfs_has_zoned(mp)) {
> +		geo->rtstart = XFS_FSB_TO_BB(mp, sbp->sb_rtstart);

Not sure why this is reported in units of 512b, everything else set by
xfs_fs_geometry is in units of fsblocks.

--D

> +		geo->rtreserved = sbp->sb_rtreserved;
> +	}
>  }
>  
>  /* Read a secondary superblock. */
> -- 
> 2.45.2
> 
> 
