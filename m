Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399535DA78
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 22:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983104; cv=none; b=U5UzMhQ9phjJetkFZlnfWJH4aHyFGwWyaU+QZw9OfiQzNZR+W5qRdR+2WBP0ZiAO5EitG4SIMrJ5g2/akvm+mNeDWm4gKyrE+4BIYj/jcAwwjG0hNPgxP1LI79qazW5mk+uhYKnavBCxwVnCeazWsHv31izHdDjxLIWvUfv4KR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983104; c=relaxed/simple;
	bh=Eb0EhnPRO+VfJ25//S0RcpAy7rrYcn/49SsNA9SBRHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3taKhgyL5kU2QcWyVMPpJ2gE8vw5cNtqkpEAvwAXkmE+c3/tdmL9RKRNiuPCCYuwQ8iy//4qZBz1B/7U16ilYagM0LfvGvKOCYZHUi3LyDGqyvLckrfC1yD3j/TrvERYMZ0FNNXrTuGTw/qdh0LXXbtors5wekgXCfDGadZ+JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/kUgDoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/kUgDoS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 08CB11F000E9;
	Mon, 13 Jul 2026 22:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783983103;
	bh=caBQuDRfhY7br+NGl4tJXSuY+AQvHiyxWp+GCLnQGe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X/kUgDoShYBFoo0f4Iv7WhIFFrj5+K5KpR3Gy+9rBA5kd2G2cBTBmrdVgd8XJ1DQR
	 +EfSpQROy1oRRyvl7+sS46cKTn6luebvmNsBYQA+GFslDCJbE3u0A9818W+AZEqq8f
	 TxxJi93obpEmKlOYvNDEFr5qYsV0kAH8h4jM2xtMvBnBT3vUpAeZLd5txDFd6D6jX+
	 2K+NGa3jeGQvKEnw1x3G5CVrtpDxx6PxvOtAYzcyDzf1ibFvO6IRrcSOQB8TdpQYAE
	 da+saGy8Gjxvb87GpY5Spzv7EfCVQg3CF2wyki3CWlVoleBwvkMW1Mg5mTUBhFfmtZ
	 BFB6xJSwzEQOA==
Date: Mon, 13 Jul 2026 15:51:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 1/4] xfs: add xfs_metadir_create_file helper
Message-ID: <20260713225142.GI7195@frogsfrogsfrogs>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
 <20260713124250.3978-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713124250.3978-2-johannes.thumshirn@wdc.com>

On Mon, Jul 13, 2026 at 02:42:47PM +0200, Johannes Thumshirn wrote:
> Factor the metadata inode create/commit/cleanup lifecycle out of
> xfs_metadir_mkdir into a reusable helper that takes an optional callback
> to initialize the new inode, and convert xfs_metadir_mkdir to it.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/xfs/libxfs/xfs_metadir.c | 58 +++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_metadir.h |  6 ++++
>  2 files changed, 43 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
> index 74c4596ee4cf..0d6a153bc9e9 100644
> --- a/fs/xfs/libxfs/xfs_metadir.c
> +++ b/fs/xfs/libxfs/xfs_metadir.c
> @@ -438,48 +438,64 @@ xfs_metadir_cancel(
>  	xfs_metadir_teardown(upd, error);
>  }
>  
> -/* Create a metadata for the last component of the path. */
>  int
> -xfs_metadir_mkdir(
> -	struct xfs_inode		*dp,
> -	const char			*path,
> +xfs_metadir_create_file(
> +	struct xfs_metadir_update	*upd,
> +	umode_t				mode,
> +	xfs_metadir_createfn		create,
> +	void				*priv,
>  	struct xfs_inode		**ipp)
>  {
> -	struct xfs_metadir_update	upd = {
> -		.dp			= dp,
> -		.path			= path,
> -		.metafile_type		= XFS_METAFILE_DIR,
> -	};
>  	int				error;
>  
> -	if (xfs_is_shutdown(dp->i_mount))
> +	if (xfs_is_shutdown(upd->dp->i_mount))
>  		return -EIO;
>  
> -	/* Allocate a transaction to create the last directory. */
> -	error = xfs_metadir_start_create(&upd);
> +	error = xfs_metadir_start_create(upd);
>  	if (error)
>  		return error;
>  
> -	/* Create the subdirectory and take our reference. */
> -	error = xfs_metadir_create(&upd, S_IFDIR);
> +	error = xfs_metadir_create(upd, mode);
>  	if (error)
>  		goto out_cancel;
>  
> -	error = xfs_metadir_commit(&upd);
> +	if (create) {
> +		error = create(upd, priv);
> +		if (error)
> +			goto out_cancel;
> +	}
> +
> +	error = xfs_metadir_commit(upd);
>  	if (error)
>  		goto out_irele;
>  
> -	xfs_finish_inode_setup(upd.ip);
> -	*ipp = upd.ip;
> +	xfs_finish_inode_setup(upd->ip);
> +	*ipp = upd->ip;
>  	return 0;
>  
>  out_cancel:
> -	xfs_metadir_cancel(&upd, error);
> +	xfs_metadir_cancel(upd, error);
>  out_irele:
>  	/* Have to finish setting up the inode to ensure it's deleted. */
> -	if (upd.ip) {
> -		xfs_finish_inode_setup(upd.ip);
> -		xfs_irele(upd.ip);
> +	if (upd->ip) {
> +		xfs_finish_inode_setup(upd->ip);
> +		xfs_irele(upd->ip);
>  	}
>  	return error;
>  }
> +
> +/* Create a metadata for the last component of the path. */
> +int
> +xfs_metadir_mkdir(
> +	struct xfs_inode		*dp,
> +	const char			*path,
> +	struct xfs_inode		**ipp)
> +{
> +	struct xfs_metadir_update	upd = {
> +		.dp			= dp,
> +		.path			= path,
> +		.metafile_type		= XFS_METAFILE_DIR,
> +	};
> +
> +	return xfs_metadir_create_file(&upd, S_IFDIR, NULL, NULL, ipp);
> +}
> diff --git a/fs/xfs/libxfs/xfs_metadir.h b/fs/xfs/libxfs/xfs_metadir.h
> index bfecac7d3d14..a795a2d0e3fe 100644
> --- a/fs/xfs/libxfs/xfs_metadir.h
> +++ b/fs/xfs/libxfs/xfs_metadir.h
> @@ -35,6 +35,12 @@ int xfs_metadir_load(struct xfs_trans *tp, struct xfs_inode *dp,
>  int xfs_metadir_start_create(struct xfs_metadir_update *upd);
>  int xfs_metadir_create(struct xfs_metadir_update *upd, umode_t mode);
>  
> +typedef int (*xfs_metadir_createfn)(struct xfs_metadir_update *upd, void *priv);
> +
> +int xfs_metadir_create_file(struct xfs_metadir_update *upd, umode_t mode,
> +		xfs_metadir_createfn create, void *priv,

I'd have called these both "_create_fn" and "create_fn" for consistency
but otherwise this looks fine to me.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		struct xfs_inode **ipp);
> +
>  int xfs_metadir_start_link(struct xfs_metadir_update *upd);
>  int xfs_metadir_link(struct xfs_metadir_update *upd);
>  
> -- 
> 2.54.0
> 
> 
