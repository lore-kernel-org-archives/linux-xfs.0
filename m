Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83553546C5
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 22:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983292; cv=none; b=DAnZJC+mD9Gy/UJXfHlIqQZRAjOEVEb4B6F1+S+YZ7Xj8//qH25B1II/ThkWzlruSlW+5Xy16IF/6BG9gNCR52aWIXATgtsN0aDH3BKf0xHo8+w4chruUMFu6vUPQWZ/ZrmilzOaFfAbTB3alzZ8uZDFJbz5vOfPmfuRywfMFQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983292; c=relaxed/simple;
	bh=+Dn+/XdNH+HVMEX9DuPFmjXFQX4qo91Umo4ju2mULlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dm8E7niZgbbG+4HLKTehYgMTN+PYiPXiNkEbu0amVUWoV0cEYBp6j7WCKbGMAcZ0sMOMdHM37eGOso+xbx/7WY5vfDHnToJKi+Js3mbXhW9t8PW+DJTBto81NL6OlhttxnKi3bHsz9Zf5WIaMGIZQNaVlDw2iWk2l49jA/VgWYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbCpsQwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbCpsQwl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4A1271F000E9;
	Mon, 13 Jul 2026 22:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783983291;
	bh=TmEmZ2JWlEtBfyPp3tc6fAcalulnWHoWk03EIwL5jZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QbCpsQwlqapFtlWWEE5UpKF+tT0OHhTTGE6WzQm+XyNaTek02s40izD9iZ8MHbweW
	 W0NKbyzgAl5qTRNdJGwoc5FteeqP2Yigdu4ihI+B44ERuPzNZe63FSdszky9QbmsLk
	 GGSPx7KTjn7NnJDfS02A3Pa1cthJoi+hAElJBG8oeQIHJiTOGQES1P46vIhUNRJMSD
	 oCBfOTq3Z6Fyzj341ht34pnCFMFWKJogfAkPa2804oC5pGJVunYw6wGYxbXGzCxuyf
	 Dxa/CLzX07Dcmr8JfPu7Iq36FCUvi4OVZXMkWuYryCYlFvvFUgXQj9wS5uZoij4nmp
	 ihV3czY0zEHOQ==
Date: Mon, 13 Jul 2026 15:54:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 3/4] xfs: create rtgroup metadir inodes using
 xfs_metadir_create_file
Message-ID: <20260713225450.GK7195@frogsfrogsfrogs>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
 <20260713124250.3978-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713124250.3978-4-johannes.thumshirn@wdc.com>

On Mon, Jul 13, 2026 at 02:42:49PM +0200, Johannes Thumshirn wrote:
> Now that we have xfs_metadir_create_file() use it in
> xfs_rtginode_create().
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/xfs/libxfs/xfs_rtgroup.c | 58 +++++++++++++++++--------------------
>  1 file changed, 26 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index c85d50953218..fe7222bbe449 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -517,6 +517,25 @@ xfs_rtginode_irele(
>  	*ipp = NULL;
>  }
>  
> +struct xfs_rtginode_create {
> +	struct xfs_rtgroup		*rtg;
> +	enum xfs_rtg_inodes		type;
> +	bool				init;
> +};
> +
> +static int
> +xfs_rtginode_init(
> +	struct xfs_metadir_update	*upd,
> +	void				*priv)
> +{
> +	struct xfs_rtginode_create	*rc = priv;
> +	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[rc->type];
> +
> +	xfs_rtginode_lockdep_setup(upd->ip, rtg_rgno(rc->rtg), rc->type);
> +	upd->ip->i_projid = rtg_rgno(rc->rtg);
> +	return ops->create(rc->rtg, upd->ip, upd->tp, rc->init);

Though I guess we already have ->create for rtgroup inodes.  I can't
think of a good (re)naming scheme for both ... but the parameters are at
least different so I guess this is fine.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +}
> +
>  /* Add a metadata inode for a realtime rmap btree. */
>  int
>  xfs_rtginode_create(
> @@ -526,6 +545,11 @@ xfs_rtginode_create(
>  {
>  	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[type];
>  	struct xfs_mount		*mp = rtg_mount(rtg);
> +	struct xfs_rtginode_create	rc = {
> +		.rtg			= rtg,
> +		.type			= type,
> +		.init			= init,
> +	};
>  	struct xfs_metadir_update	upd = {
>  		.dp			= mp->m_rtdirip,
>  		.metafile_type		= ops->metafile_type,
> @@ -544,38 +568,8 @@ xfs_rtginode_create(
>  	if (!upd.path)
>  		return -ENOMEM;
>  
> -	error = xfs_metadir_start_create(&upd);
> -	if (error)
> -		goto out_path;
> -
> -	error = xfs_metadir_create(&upd, S_IFREG);
> -	if (error)
> -		goto out_cancel;
> -
> -	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
> -
> -	upd.ip->i_projid = rtg_rgno(rtg);
> -	error = ops->create(rtg, upd.ip, upd.tp, init);
> -	if (error)
> -		goto out_cancel;
> -
> -	error = xfs_metadir_commit(&upd);
> -	if (error)
> -		goto out_path;
> -
> -	kfree(upd.path);
> -	xfs_finish_inode_setup(upd.ip);
> -	rtg->rtg_inodes[type] = upd.ip;
> -	return 0;
> -
> -out_cancel:
> -	xfs_metadir_cancel(&upd, error);
> -	/* Have to finish setting up the inode to ensure it's deleted. */
> -	if (upd.ip) {
> -		xfs_finish_inode_setup(upd.ip);
> -		xfs_irele(upd.ip);
> -	}
> -out_path:
> +	error = xfs_metadir_create_file(&upd, S_IFREG, xfs_rtginode_init, &rc,
> +			&rtg->rtg_inodes[type]);
>  	kfree(upd.path);
>  	return error;
>  }
> -- 
> 2.54.0
> 
> 
