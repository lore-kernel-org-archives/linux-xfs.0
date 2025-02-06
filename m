Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64339194094
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 21:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875823; cv=none; b=FNlfSWgASDLjQkh/guLMA0hBWV2h/KoyL3JqECdbN9jAISJLwE0fwhf6tIkxamZh0L/xz3QhlSr6kRKpQaRNtP6njfqijF9MrcgCRS1YmB4k6l51IvVeWpRFuB2djBVqpvcGuxdYHto9t4FYDOmgGcN1VQ1lA95b/PCTpUqSKMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875823; c=relaxed/simple;
	bh=2M5X+oOIKga9AvyrLT/3o2ZsW1TvlX2rugquNFBJ800=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xt+tig136cBLYTuNlASWCTgTZnKUlX6fbqP6b2fJHyL9lijAh7AbW1rmErPbESDV6wevjMA9TnHWwcg/Iq//SH0HxWOL/q569RIa0gBr3SyaAcs9ddJDf3wzg+yrrKi9tgF9Wj3t3QMUF8ElevDvfUPMl/n0S8A2bREFwy3+pg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfP7mobg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfP7mobg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD41C4CEDD;
	Thu,  6 Feb 2025 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738875823;
	bh=2M5X+oOIKga9AvyrLT/3o2ZsW1TvlX2rugquNFBJ800=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YfP7mobgQg11MZ3LE5fUBIzH3lBxMf8N1hA0hprmqxRTvDYO9So4W4wDCirhGUiPs
	 vOTDFPU0No83wb1B2npc6Lkr+OlqoGaFiAYUdGPIF1r+jGVoQVwyxtis29RcIUZlqR
	 EMhKMks1IRFGJF+T/xqBW6q5r5B4gJgZHK8j1q3T3/TfRU/jVrvlNS0P37IlnQRr8h
	 hD4x5v2oHaRQkNUg9ES6cJWU1vgtVpJsDjyegNYVM97oV/ep+RRcDY3q2U5TuFIDZ5
	 L59xXZE1N/k/h8OW010IhmxHEjudJYBKQAtOWJ63b1xheckCf0+o4ccToeJnBeulKL
	 l5C1zDpDz8fdA==
Date: Thu, 6 Feb 2025 13:03:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/43] xfs: export zoned geometry via XFS_FSOP_GEOM
Message-ID: <20250206210342.GQ21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-17-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:32AM +0100, Christoph Hellwig wrote:
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
> index 088c192810f5..71cf5eba94a7 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1569,6 +1569,8 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
>  	if (xfs_has_metadir(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
> +	if (xfs_has_zoned(mp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
> @@ -1589,6 +1591,10 @@ xfs_fs_geometry(
>  		geo->rgcount = sbp->sb_rgcount;
>  		geo->rgextents = sbp->sb_rgextents;
>  	}
> +	if (xfs_has_zoned(mp)) {
> +		geo->rtstart = sbp->sb_rtstart;

Wait, this is a little startling -- sb_rtstart is declared as an
xfs_fsblock_t in struct xfs_sb?

Oh.  That should have been declared as an xfs_rfsblock_t back in the
ondisk format patch.  Can you go make that change, and then both can be

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

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
