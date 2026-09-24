Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34C536A01A
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790276505; cv=none; b=NEHBC1EsWN2BYjkrTw6/ENykXoi9P9/tmx1ARr3WhWm+IdgzKEVd7DU9tzLmWBMF75EMtqyQr28v+iI+NAaqdQUFUaymGM5Cw5fEk4v7uAwkA3UFSUmgIzpm+XWr142awLc0V8RraIXeB9QJ2nBH/IEQjsqJ3t+ER9Fwcd110hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790276505; c=relaxed/simple;
	bh=7hSMZ9XmrZrq6MbHdPSoLSrgQ6P4/wciDJGjjwcOcLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHhePXTHz1Izy2nuo9r5a38NVR6VFOApWBZ7h7QMTMNbAelirc0iYrGgIUo0pXEYsN7OUAF/lWNzH1/8XagZUxvzGkvysGRQtQOiACQDqM4HyL+chwKyhb/mwTTHG92mT4lBclHGGogCHkVqREjG0ImuvUNYOY/fgWi9Xt/WzZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g86l7R5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g86l7R5D"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E3071F00898;
	Thu, 24 Sep 2026 19:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790276499;
	bh=1YxWt0tb1Rr+w69f9Bh6BSChanGoTSYWyLc5K2Hvdi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g86l7R5DNA9nui49+Mk6ePjA96zdCEV6iM2MgDKsEPApxykTkA1GdPbjNGb2Bh1dm
	 1surKyqb+GmO6hKg5FJavgZjDGdqt5NyvQHwHUJBxL7x1zAUMi80TiiKeNYscCbP31
	 1GH2NSoCtFmOwMZFQg/sbS9CXlVA6EIWjzhO1Icwf320YZAW8QEJHvLaoSIrDA5KiG
	 3viZK812XkJws2Tde5LiyjJFrDitty/lAHpTpTdW+528wzNULk1ZkgTzfQ9cqWabsM
	 aGue/DM6JsvyrI6GUXOkSuFDw+3NznWEZZIA5Y9UNF8SV0kpTNwAakL5hKD8x5Anma
	 trBwnmLicH2zA==
Date: Thu, 24 Sep 2026 12:01:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: centralize setting of buf_ops/buf_type/magic
 for rtblocks
Message-ID: <20260924190138.GO2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-2-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:02AM +0200, Christoph Hellwig wrote:
> Add two tables for the buf_ops and buf_type, and derive the magic from
> the buf_ops to make have a single source of truth for the different RT
> block variants.  This cleans up the existing code and makes adding another
> type of block/file easier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems like a reasonable hoist here.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 40 +++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_rtbitmap.h | 15 ++------------
>  2 files changed, 25 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index e62786e90f7b..3f7877220e05 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -125,6 +125,26 @@ const struct xfs_buf_ops xfs_rtsummary_buf_ops = {
>  	.verify_struct	= xfs_rtbuf_verify,
>  };
>  
> +static const struct xfs_buf_ops *xfs_rtblock_buf_ops[XFS_RTGI_MAX] = {
> +	[XFS_RTGI_SUMMARY]	= &xfs_rtsummary_buf_ops,
> +	[XFS_RTGI_BITMAP]	= &xfs_rtbitmap_buf_ops,
> +};
> +
> +const struct xfs_buf_ops *
> +xfs_rtblock_ops(
> +	struct xfs_mount	*mp,
> +	enum xfs_rtg_inodes	type)
> +{
> +	if (!xfs_has_rtgroups(mp))
> +		return &xfs_rtbuf_ops;
> +	return xfs_rtblock_buf_ops[type];
> +}
> +
> +static enum xfs_blft xfs_rtblock_buf_types[XFS_RTGI_MAX] = {
> +	[XFS_RTGI_SUMMARY]	= XFS_BLFT_RTSUMMARY_BUF,
> +	[XFS_RTGI_BITMAP]	= XFS_BLFT_RTBITMAP_BUF,
> +};
> +
>  /* Release cached rt bitmap and summary buffers. */
>  void
>  xfs_rtbuf_cache_relse(
> @@ -158,7 +178,6 @@ xfs_rtbuf_get(
>  	xfs_fileoff_t		*coffp;	/* cached block number */
>  	struct xfs_buf		*bp;	/* block buffer, result */
>  	struct xfs_bmbt_irec	map;
> -	enum xfs_blft		buf_type;
>  	int			nmap = 1;
>  	int			error;
>  
> @@ -166,12 +185,10 @@ xfs_rtbuf_get(
>  	case XFS_RTGI_SUMMARY:
>  		cbpp = &args->sumbp;
>  		coffp = &args->sumoff;
> -		buf_type = XFS_BLFT_RTSUMMARY_BUF;
>  		break;
>  	case XFS_RTGI_BITMAP:
>  		cbpp = &args->rbmbp;
>  		coffp = &args->rbmoff;
> -		buf_type = XFS_BLFT_RTBITMAP_BUF;
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -222,7 +239,7 @@ xfs_rtbuf_get(
>  		}
>  	}
>  
> -	xfs_trans_buf_set_type(args->tp, bp, buf_type);
> +	xfs_trans_buf_set_type(args->tp, bp, xfs_rtblock_buf_types[type]);
>  	*cbpp = bp;
>  	*coffp = block;
>  	return 0;
> @@ -1375,16 +1392,8 @@ xfs_rtfile_initialize_block(
>  	struct xfs_buf		*bp;
>  	void			*bufdata;
>  	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
> -	enum xfs_blft		buf_type;
>  	int			error;
>  
> -	if (type == XFS_RTGI_BITMAP)
> -		buf_type = XFS_BLFT_RTBITMAP_BUF;
> -	else if (type == XFS_RTGI_SUMMARY)
> -		buf_type = XFS_BLFT_RTSUMMARY_BUF;
> -	else
> -		return -EINVAL;
> -
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
> @@ -1399,16 +1408,13 @@ xfs_rtfile_initialize_block(
>  	}
>  	bufdata = bp->b_addr;
>  
> -	xfs_trans_buf_set_type(tp, bp, buf_type);
> +	xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
>  	bp->b_ops = xfs_rtblock_ops(mp, type);
>  
>  	if (xfs_has_rtgroups(mp)) {
>  		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
>  
> -		if (type == XFS_RTGI_BITMAP)
> -			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
> -		else
> -			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
> +		hdr->rt_magic = bp->b_ops->magic[1];
>  		hdr->rt_owner = cpu_to_be64(I_INO(ip));
>  		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
>  		hdr->rt_lsn = 0;
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
> index 22e5d9cd95f4..375cc48e1a53 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.h
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.h
> @@ -354,19 +354,6 @@ xfs_suminfo_add(
>  	return info->old;
>  }
>  
> -static inline const struct xfs_buf_ops *
> -xfs_rtblock_ops(
> -	struct xfs_mount	*mp,
> -	enum xfs_rtg_inodes	type)
> -{
> -	if (xfs_has_rtgroups(mp)) {
> -		if (type == XFS_RTGI_SUMMARY)
> -			return &xfs_rtsummary_buf_ops;
> -		return &xfs_rtbitmap_buf_ops;
> -	}
> -	return &xfs_rtbuf_ops;
> -}
> -
>  /*
>   * Functions for walking free space rtextents in the realtime bitmap.
>   */
> @@ -419,6 +406,8 @@ xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
>  xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
>  		unsigned int *rsumlevels);
>  
> +const struct xfs_buf_ops *xfs_rtblock_ops(struct xfs_mount *mp,
> +		enum xfs_rtg_inodes type);
>  int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
>  		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
>  		xfs_fileoff_t end_fsb, void *data);
> -- 
> 2.53.0
> 
> 
