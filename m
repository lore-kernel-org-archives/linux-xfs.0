Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD231A681B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375325; cv=none; b=Hv0PDP4KTMwjJIHfqr9l5Y0D9iDLoY2dcOcPwxkqQir2QPdun3zkm20s97+9sTwGhcUOZr+8JI6q14SQw/JP+h1KKWNFn9RobFXszKfMsiWiB2xq7aBIYw+yQ/2IPR2k6aBhMKoMuMMAUqWFB77Yo2FZGTgE+zeINpuZcY1oXK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375325; c=relaxed/simple;
	bh=j4dm/KXalVhxk2bjHX5hUbnQAXkdHBLJeJNTDeiC4C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQjSqyBNdjY+ZR7UO46LXik1WhKMDIUj4mN4b6E/IZUWrGKfQAvcX8R4fXXDyW33svpMNsFyt7+pWVtX+b4efPia5bQLtVp21vJsg4VqSMpJFLB7ApnMbPOLQ+mCSZZIxq2ddynhZ4lxQE6l4CCTAtXeDebVGUFCy4cfW8zxHhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/1B/Kf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/1B/Kf9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 98B601F00893;
	Tue,  2 Jun 2026 04:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375323;
	bh=SHU6fu8hfbbhnWh4eB9cb4wskwxv1kqdPfnQghtipXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k/1B/Kf9vbsSO5F5e4RGgGdLAuos4bsapagOjoXN7cMddo6RAmjAYEK/EVV/VUI/D
	 fngvP+CEw49T7kf7ANWa3fEXl+EVcnspaAHX+kWHEQU6SBh5zvvGBObYiQgebbv4Z1
	 py76dYecXlz1JuHCRPWDItnDQIxXeQKdzRsCsgBTZ5omO7bURa0c0L5zASe287+RWC
	 rTPoX9JYXQtfYe7Th+tr2On/LLKAE+Q3oi7omkOr9WhmJnoC2vz3IPbu6vAEFnyrxf
	 M+bRRP4uFWLTrhXEa/5jauWa1Iww3U5v4kVxkqZFNiAvff0qqVLz/lWN8I2BoTZEbt
	 /hgjTOEqkjFqw==
Date: Mon, 1 Jun 2026 21:42:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: cleanup xfs_growfs_compute_deltas
Message-ID: <20260602044203.GN6078@frogsfrogsfrogs>
References: <20260601110824.3392683-1-hch@lst.de>
 <20260601110824.3392683-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601110824.3392683-3-hch@lst.de>

On Mon, Jun 01, 2026 at 01:07:53PM +0200, Christoph Hellwig wrote:
> xfs_growfs_compute_deltas has an odd calling conventions, and looks
> very convoluted due to the use of do_div and strangely named and typed
> variables.
> 
> Rename it, make it return the agcount and let the caller calculate the
> delta.  The internally use the better div_u64_rem helper and descriptive
> variable names and types.  Also add a comment describing what the
> function is used for.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

AFAICT the logic is the same before and after, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Though I half wonder if that XFS_MAX_AGNUMBER+1 comparison is really
correct.  MAX_AGNUMBER is defined to be ((xfs_agnumber_t)-2) so we're
checking if an unsigned 32-bit number is greater than 0xFFFFFFFF?
Which is also NULLAGNUMBER?

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c | 44 ++++++++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_ag.h |  5 ++---
>  fs/xfs/xfs_fsops.c     |  4 +++-
>  3 files changed, 26 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 0c5f0548021f..095af128d2fb 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -863,32 +863,30 @@ xfs_ag_shrink_space(
>  	return err2;
>  }
>  
> -void
> -xfs_growfs_compute_deltas(
> +/*
> + * Return the agcount for the new file system size passed in *nb and adjust *nb
> + * when it has to be reduced because of maximum AG count or because it would
> + * create a below minimum size AG.
> + */
> +xfs_agnumber_t
> +xfs_growfs_compute_agcount(
>  	struct xfs_mount	*mp,
> -	xfs_rfsblock_t		*nb,
> -	int64_t			*deltap,
> -	xfs_agnumber_t		*nagcountp)
> +	xfs_rfsblock_t		*nb)
>  {
> -	xfs_rfsblock_t	nb_div, nb_mod;
> -	int64_t		delta;
> -	xfs_agnumber_t	nagcount;
> -
> -	nb_div = *nb;
> -	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> -	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> -		nb_div++;
> -	else if (nb_mod)
> -		*nb = nb_div * mp->m_sb.sb_agblocks;
> -
> -	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> -		nb_div = XFS_MAX_AGNUMBER + 1;
> -		*nb = nb_div * mp->m_sb.sb_agblocks;
> +	xfs_agnumber_t		agcount;
> +	xfs_extlen_t		remainder;
> +
> +	agcount = div_u64_rem(*nb, mp->m_sb.sb_agblocks, &remainder);
> +	if (agcount > XFS_MAX_AGNUMBER + 1) {
> +		agcount = XFS_MAX_AGNUMBER + 1;
> +		remainder = 0;
> +	}
> +	*nb = (xfs_rfsblock_t)agcount * mp->m_sb.sb_agblocks;
> +	if (remainder >= XFS_MIN_AG_BLOCKS) {
> +		*nb += remainder;
> +		agcount++;
>  	}
> -	nagcount = nb_div;
> -	delta = *nb - mp->m_sb.sb_dblocks;
> -	*deltap = delta;
> -	*nagcountp = nagcount;
> +	return agcount;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 8aa4266c5571..fd22fe598931 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -329,12 +329,11 @@ struct aghdr_init_data {
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>  int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>  			xfs_extlen_t delta);
> -void
> -xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t *nb,
> -			int64_t *deltap, xfs_agnumber_t *nagcountp);
>  int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
>  			xfs_extlen_t len);
>  int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
> +xfs_agnumber_t xfs_growfs_compute_agcount(struct xfs_mount *mp,
> +		xfs_rfsblock_t *nb);
>  
>  static inline xfs_fsblock_t
>  xfs_agbno_to_fsb(
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 436857356a0a..67624a804a7f 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -124,7 +124,9 @@ xfs_growfs_data_private(
>  			mp->m_sb.sb_rextsize);
>  	if (error)
>  		return error;
> -	xfs_growfs_compute_deltas(mp, &nb, &delta, &nagcount);
> +
> +	nagcount = xfs_growfs_compute_agcount(mp, &nb);
> +	delta = nb - mp->m_sb.sb_dblocks;
>  
>  	/*
>  	 * Reject filesystems with a single AG because they are not
> -- 
> 2.53.0
> 
> 
