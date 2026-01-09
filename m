Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972E2773DA
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975649; cv=none; b=RwMwKzmvX/ewr8dE1UVmDs4FzvbF8PVMUOzBxeVkpvT018WCuMm1eJNeLEmMDsmJtAR1oRXoNyLrxzwzukPWRBbihZ0011AUdG2uzKUyuQd60OUaDh9izL6PTWEt4YBSSoiqYpGa6JEA0NwMEieJnC+yDbuBlK5wbljYYHplyTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975649; c=relaxed/simple;
	bh=o21u9KxIPAPFVQkx6ogdgMkV7I0lCEKG5v3K4wWKWwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+LBoc0AaydzZL61yVK83UH5JzlM4UZChBGRsipv7Vxr0pvdfmQI+KvD/tiMn3xDlvQ7sR22xZNNbCT9+REewOUYMLG2CMzifzxrkZZnHsyyr9i1W+IeGzoHFcDf0SEcGr3HLK/vlV4oHtqsP/Ls14QYBldi35rTzncjVrbuzhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LebYU2Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LebYU2Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CD3C4CEF1;
	Fri,  9 Jan 2026 16:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767975649;
	bh=o21u9KxIPAPFVQkx6ogdgMkV7I0lCEKG5v3K4wWKWwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LebYU2MdMUT+3KuM9bZhzUw4wdWmKRdBbR/3EYP7dr9LiC9pTCUpOZLJdqUFnd4dh
	 l6dTKT6HBvE4XePakP6fa7IdsMs0wAvimXUflfnwcLGaLDpXO5A4NIkqgpVDuLiXkL
	 jnXSvX3opPOjEbn+UqvJgMDiYWkfm+1LXU1A9Gme2Gf7O6K+5Jo8i8KihMlsFvDVcQ
	 xKYssry80iPXGy2wZ0nK1JO7LYEcSgxrFNJsVy7PU7iZBQ64HM3K7Eo2LQay7OA4Wn
	 3RZ42KGcnQuL+E+FpgwfsvFGMqi5Q/j2TlJBhUGeUtLJbI5AGijMuB8A9ouKqRmV79
	 lZ4Ezu8VOyTHA==
Date: Fri, 9 Jan 2026 08:20:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: mark __xfs_rtgroup_extents static
Message-ID: <20260109162048.GP15551@frogsfrogsfrogs>
References: <20260109151901.2376971-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109151901.2376971-1-hch@lst.de>

On Fri, Jan 09, 2026 at 04:18:53PM +0100, Christoph Hellwig wrote:
> __xfs_rtgroup_extents is not used outside of xfs_rtgroup.c, so mark it
> static.  Move it and xfs_rtgroup_extents up in the file to avoid forward
> declarations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtgroup.c | 50 ++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_rtgroup.h |  2 --
>  2 files changed, 25 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index 9186c58e83d5..5a3d0dc6ae1b 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -48,6 +48,31 @@ xfs_rtgroup_min_block(
>  	return 0;
>  }
>  
> +/* Compute the number of rt extents in this realtime group. */
> +static xfs_rtxnum_t
> +__xfs_rtgroup_extents(
> +	struct xfs_mount	*mp,
> +	xfs_rgnumber_t		rgno,
> +	xfs_rgnumber_t		rgcount,
> +	xfs_rtbxlen_t		rextents)
> +{
> +	ASSERT(rgno < rgcount);
> +	if (rgno == rgcount - 1)
> +		return rextents - ((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
> +
> +	ASSERT(xfs_has_rtgroups(mp));
> +	return mp->m_sb.sb_rgextents;
> +}
> +
> +xfs_rtxnum_t
> +xfs_rtgroup_extents(
> +	struct xfs_mount	*mp,
> +	xfs_rgnumber_t		rgno)
> +{
> +	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
> +			mp->m_sb.sb_rextents);
> +}
> +
>  /* Precompute this group's geometry */
>  void
>  xfs_rtgroup_calc_geometry(
> @@ -136,31 +161,6 @@ xfs_initialize_rtgroups(
>  	return error;
>  }
>  
> -/* Compute the number of rt extents in this realtime group. */
> -xfs_rtxnum_t
> -__xfs_rtgroup_extents(
> -	struct xfs_mount	*mp,
> -	xfs_rgnumber_t		rgno,
> -	xfs_rgnumber_t		rgcount,
> -	xfs_rtbxlen_t		rextents)
> -{
> -	ASSERT(rgno < rgcount);
> -	if (rgno == rgcount - 1)
> -		return rextents - ((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
> -
> -	ASSERT(xfs_has_rtgroups(mp));
> -	return mp->m_sb.sb_rgextents;
> -}
> -
> -xfs_rtxnum_t
> -xfs_rtgroup_extents(
> -	struct xfs_mount	*mp,
> -	xfs_rgnumber_t		rgno)
> -{
> -	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
> -			mp->m_sb.sb_rextents);
> -}
> -
>  /*
>   * Update the rt extent count of the previous tail rtgroup if it changed during
>   * recovery (i.e. recovery of a growfs).
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index 03f1e2493334..73cace4d25c7 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -285,8 +285,6 @@ void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
>  int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
>  		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
>  
> -xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
> -		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
>  xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
>  void xfs_rtgroup_calc_geometry(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
>  		xfs_rgnumber_t rgno, xfs_rgnumber_t rgcount,
> -- 
> 2.47.3
> 
> 
