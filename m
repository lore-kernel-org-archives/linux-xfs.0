Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337511DDD1
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 20:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820669; cv=none; b=XK+n5MRoxQn4m88DQzn1KGVDOLYcP0YtiSVIbLsBtbH2/ZAW2FGc+9sDgHICU8y67nMjraOT3Kq/Y2ZxGe2WgDFfO1pqHSx/+xhZtEGjMMSZqvFjY+ll9nWyWjZNe7E9s4e0QDX/7ZzlMB4BeJQ+voIrAiyWPp+nbJBUa31DCrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820669; c=relaxed/simple;
	bh=sD77/J/ZpGQSHv/5e26dOfBKtiCmL4KLfMGXyxe/0LY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2T/gS8u+eUNbg0YuKvTIN9MDcr0ANezy+YGrgZ59FWCLPw2hvwPgpJFf5mi3bJBUFA3Tseuf+wRcS8H1M6b2fxJk2xccdfJfN+d1W0GNfTg+Ghr1Xu5Mjq4apSxKp3EDxk/JLSC8yGHeZ9zuG8HoZw6IvBw2dHFRuPNb0eQkyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KC9Nd6TY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KC9Nd6TY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD8C4CEEF;
	Tue, 29 Jul 2025 20:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753820668;
	bh=sD77/J/ZpGQSHv/5e26dOfBKtiCmL4KLfMGXyxe/0LY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KC9Nd6TYRJfWaTDaK+3zeC1zd0rRtSwnbEy4oZNcy1CmK0b3ykxVSdPGNy+fC0kQy
	 L+rpSF24FxAzl1rIsW53sa96IU1Bbx7yPhw/y1L3euaGkjYiIWDlJA1zlFS4fvULR7
	 5GdBcJj3b4NpoOvvm7zlm4lFWlAAQDZhbc/EQBJuDk94Qkjs34SLbm59eZk7kh2rkx
	 YBx3RStjD+nCfLa+RY5yLVM7jnYh8D5ge4xZqXN9VpYbk0QkR0H68tAyA82NqtIF4p
	 qsTpq9cuO6tAXekoiqHipSUsHXeDgv6j0pogt9kysOL/p5GGh7z9atrjlDj0ImihrC
	 fypjdcXN/Q+5g==
Date: Tue, 29 Jul 2025 13:24:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	bfoster@redhat.com, david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC 2/3] xfs: Refactoring the nagcount and delta calculation
Message-ID: <20250729202428.GE2672049@frogsfrogsfrogs>
References: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
 <35b8ee6d2e142aeda726752a9197eb233dc44e6d.1752746805.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35b8ee6d2e142aeda726752a9197eb233dc44e6d.1752746805.git.nirjhar.roy.lists@gmail.com>

On Thu, Jul 17, 2025 at 04:00:44PM +0530, Nirjhar Roy (IBM) wrote:
> Introduce xfs_growfs_get_delta() to calculate the nagcount
> and delta blocks and refactor the code from xfs_growfs_data_private().
> No functional changes.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 25 +++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |  3 +++
>  fs/xfs/xfs_fsops.c     | 17 ++---------------
>  3 files changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index e6ba914f6d06..dcaf5683028e 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -872,6 +872,31 @@ xfs_ag_shrink_space(
>  	return err2;
>  }
>  
> +void
> +xfs_growfs_get_delta(struct xfs_mount *mp, xfs_rfsblock_t nb,

/me suggests xfs_growfs_compute_deltas() but otherwise this hoist looks
fine to me;

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	int64_t *deltap, xfs_agnumber_t *nagcountp)
> +{
> +	xfs_rfsblock_t nb_div, nb_mod;
> +	int64_t delta;
> +	xfs_agnumber_t nagcount;
> +
> +	nb_div = nb;
> +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> +		nb_div++;
> +	else if (nb_mod)
> +		nb = nb_div * mp->m_sb.sb_agblocks;
> +
> +	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> +		nb_div = XFS_MAX_AGNUMBER + 1;
> +		nb = nb_div * mp->m_sb.sb_agblocks;
> +	}
> +	nagcount = nb_div;
> +	delta = nb - mp->m_sb.sb_dblocks;
> +	*deltap = delta;
> +	*nagcountp = nagcount;
> +}
> +
>  /*
>   * Extent the AG indicated by the @id by the length passed in
>   */
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 1f24cfa27321..190af11f6941 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -331,6 +331,9 @@ struct aghdr_init_data {
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>  int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>  			xfs_extlen_t delta);
> +void
> +xfs_growfs_get_delta(struct xfs_mount *mp, xfs_rfsblock_t nb,
> +	int64_t *deltap, xfs_agnumber_t *nagcountp);
>  int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
>  			xfs_extlen_t len);
>  int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 0ada73569394..91da9f733659 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -92,18 +92,17 @@ xfs_growfs_data_private(
>  	struct xfs_growfs_data	*in)		/* growfs data input struct */
>  {
>  	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
> +	xfs_rfsblock_t nb = in->newblocks;
>  	struct xfs_buf		*bp;
>  	int			error;
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
> -	xfs_rfsblock_t		nb, nb_div, nb_mod;
>  	int64_t			delta;
>  	bool			lastag_extended = false;
>  	struct xfs_trans	*tp;
>  	struct aghdr_init_data	id = {};
>  	struct xfs_perag	*last_pag;
>  
> -	nb = in->newblocks;
>  	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
>  	if (error)
>  		return error;
> @@ -122,20 +121,8 @@ xfs_growfs_data_private(
>  			mp->m_sb.sb_rextsize);
>  	if (error)
>  		return error;
> +	xfs_growfs_get_delta(mp, nb, &delta, &nagcount);
>  
> -	nb_div = nb;
> -	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> -	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> -		nb_div++;
> -	else if (nb_mod)
> -		nb = nb_div * mp->m_sb.sb_agblocks;
> -
> -	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> -		nb_div = XFS_MAX_AGNUMBER + 1;
> -		nb = nb_div * mp->m_sb.sb_agblocks;
> -	}
> -	nagcount = nb_div;
> -	delta = nb - mp->m_sb.sb_dblocks;
>  	/*
>  	 * Reject filesystems with a single AG because they are not
>  	 * supported, and reject a shrink operation that would cause a
> -- 
> 2.43.5
> 
> 
