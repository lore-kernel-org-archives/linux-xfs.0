Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C692A46EC73
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790276239; cv=none; b=laxMi9JJaEUaaH3+oRJzOAcfpXJdnB26Yx66+EYjGMi3dekIPhz/C4qVrzhy7/TxUq+9hEysfeDG+s/b12cfOKIB+jZvEpQVVZU/WpZQEXfgIw8j+dIuXrw96hnMKW1fUsAXHcVUcgxuQZjpftWMOYqwZnKwECXbvFojSBDpNHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790276239; c=relaxed/simple;
	bh=yI6zL61qWZwq/pfaeHlOaEBjMvKwkj6NMjYeG88ZJoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeCkGcsLkB9L/xvwkVoIyncgzRwXUFNKmuyMi6Mev8cU0EJpdxvfIR+pKYqknowCBdh2ighu408mRbEw+yISyHltefSciflSgpLyW9vYDI7z/G+LsRxO8oY3A84ErOzbWQsWfdl+YNoQzskKQZqrAx3/1ZrP7FAdzt8pv66JT4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6y0VJ2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6y0VJ2B"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E01A81F00893;
	Thu, 24 Sep 2026 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790276237;
	bh=m2WR+w5sMN5lVPmfDPHJYrVszXmVHIMgbTNR6LMXmdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G6y0VJ2BfQMx/chkjOxVWRkHgsjAhGr2FYFYNy6rka2noSg2/ejYgBMkdGdeCS0M1
	 IBFaAq+zW2qVBf/5k0ZbW+g+zbop+ehVALOoynhOPW+KvjptuaeDQzSFoUfndjki31
	 /M/Ns0p4Gbdby0NVuEcjOcPuBi10EW3cAqVww7EGgivxXiqRxzdFtExp7DfO2sHFzj
	 CM1bBVE/0ZqRRJYlXpDXuYj/kTAU3odv5Y4apZujSzITiYhcwUZq++VrezWuki70dz
	 z1D3VZb+jGdNE6YmG4ekcd7xSUVO5KeTx5OU38ymmJwf7MunboyodvNAz4ZgTR8y6n
	 z3D5mQTlQOeZA==
Date: Thu, 24 Sep 2026 11:57:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, sandeen@sandeen.net
Subject: Re: [PATCH v4 2/3] xfs: introduce xfs_trans_cancel_error()
Message-ID: <20260924185716.GN2705364@frogsfrogsfrogs>
References: <20260924151638.38535-1-cem@kernel.org>
 <20260924151638.38535-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924151638.38535-3-cem@kernel.org>

On Thu, Sep 24, 2026 at 05:16:29PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Once in a while it's useful to know exactly what kind of error caused a
> transaction to be cancelled. Currently xfs_trans_cancel() is unable to
> print out this information. So rename old xfs_trans_cancel to
> xfs_trans_cancel_error() which will accept an error code to be printed
> and add a new inline xfs_trans_cancel() to be used on places where an
> error number report is not explicitly needed (and also avoid dozens of
> file modifications to the new API).
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V4:
> 	- Remove macros in lieu of an inline function
> 	- Rename patch to a better description

Looks good still; thanks to hch for pointing out a more sensible way to
do the cancel function.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> V3:
> 	- Kill typedef from __xfs_trans_cancel
> 	- Remove uneeded wrap of parameter 0
> 
>  fs/xfs/xfs_trans.c | 8 +++++---
>  fs/xfs/xfs_trans.h | 9 ++++++++-
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 5c522790e5be..8f0c308f312f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -943,8 +943,9 @@ xfs_trans_commit(
>   * xfs_trans_commit().
>   */
>  void
> -xfs_trans_cancel(
> -	struct xfs_trans	*tp)
> +xfs_trans_cancel_error(
> +	struct xfs_trans	*tp,
> +	int			error)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xlog		*log = mp->m_log;
> @@ -971,7 +972,8 @@ xfs_trans_cancel(
>  	 * here.
>  	 */
>  	if (dirty && !xfs_is_shutdown(mp)) {
> -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
> +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW,
> +				 error, mp);
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index eb83c5dac032..edb0cfff4d3c 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -237,7 +237,7 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
>  int		xfs_trans_commit(struct xfs_trans *);
>  int		xfs_trans_roll(struct xfs_trans **);
>  int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> -void		xfs_trans_cancel(xfs_trans_t *);
> +void		xfs_trans_cancel_error(struct xfs_trans *, int);
>  int		xfs_trans_ail_init(struct xfs_mount *);
>  void		xfs_trans_ail_destroy(struct xfs_mount *);
>  
> @@ -280,4 +280,11 @@ xfs_trans_clear_context(
>  	memalloc_nofs_restore(tp->t_pflags);
>  }
>  
> +static inline void
> +xfs_trans_cancel(
> +	struct xfs_trans	*tp)
> +{
> +	return xfs_trans_cancel_error(tp, 0);
> +}
> +
>  #endif	/* __XFS_TRANS_H__ */
> -- 
> 2.55.0
> 
> 
