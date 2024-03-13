Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431181119B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 04:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710305795; cv=none; b=pt2KrTYYRD9uiXUw4m2OfdFCbBviW+g+bU+jlUVe9fkK9bot5IfHtkWx+2N50gDoQouuYyQevYcE0MBjpspoamnqlpHrmdsOWzCZQnQOD2RN3gEU/79/HqawUgpjySevX18EJj2Vvxnx4Zs7En8VmoOxV4osV06MkVwA7XUBGtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710305795; c=relaxed/simple;
	bh=9mhfnhW4KCClsZ9chpk4FPuIQo090hLwwMZ5wghaXuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQZB4c54mdyrgZ79uK3DwhhzujL23s6yxI5+lMheX2F9HRfuVjcrF1ZQl6Zm7pxi8EUU9ZXqmlnN7R8APgjUN+WjdvbEaoRsbIsbj6sREGvvIb0U7JXkMfRJASPSenIhBXF5fajA601F+EjYqvLPUKYp6ogWef9Wz1QrPerVyp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZ51B1e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZ51B1e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEF7C433C7;
	Wed, 13 Mar 2024 04:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710305794;
	bh=9mhfnhW4KCClsZ9chpk4FPuIQo090hLwwMZ5wghaXuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CZ51B1e+QuRcV7XfilmIsBfIg6G/TIcDAI5Txy+wG58GINUA6yEIrAge+dZehxgPE
	 IKPqS3keqacN/ARx+S5htJp2a/OvuF/+MpkpLLqXWdMDiynNg7hNiaGjTBOvkwWNfe
	 ByXwrGqwqogZu12Jn0majcVGfmTzw8qkZpxAe04D9sx4rK6YsVU4l/E3g6f8gLrhF2
	 mbNX7tb3cUA3Sw/cbalYqCyIpT4stD+v7oxpdhKmBc564BZa67q2gj0C00C1kvc1oc
	 r1usCpgPB3O/1E4pkP1ATdXCuyBVmBDwdjSOZPAb1PVR479Wm1yVDOXWxfZyKTt9mm
	 u//Bst72l6i0Q==
Date: Tue, 12 Mar 2024 21:56:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: allow sunit mount option to repair bad primary sb
 stripe values
Message-ID: <20240313045634.GK1927156@frogsfrogsfrogs>
References: <20240312233006.2461827-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312233006.2461827-1-david@fromorbit.com>

On Wed, Mar 13, 2024 at 10:30:06AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If a filesystem has a busted stripe alignment configuration on disk
> (e.g. because broken RAID firmware told mkfs that swidth was smaller
> than sunit), then the filesystem will refuse to mount due to the
> stripe validation failing. This failure is triggering during distro
> upgrades from old kernels lacking this check to newer kernels with
> this check, and currently the only way to fix it is with offline
> xfs_db surgery.
> 
> This runtime validity checking occurs when we read the superblock
> for the first time and causes the mount to fail immediately. This
> prevents the rewrite of stripe unit/width via
> mount options that occurs later in the mount process. Hence there is
> no way to recover this situation without resorting to offline xfs_db
> rewrite of the values.
> 
> However, we parse the mount options long before we read the
> superblock, and we know if the mount has been asked to re-write the
> stripe alignment configuration when we are reading the superblock
> and verifying it for the first time. Hence we can conditionally
> ignore stripe verification failures if the mount options specified
> will correct the issue.
> 
> We validate that the new stripe unit/width are valid before we
> overwrite the superblock values, so we can ignore the invalid config
> at verification and fail the mount later if the new values are not
> valid. This, at least, gives users the chance of correcting the
> issue after a kernel upgrade without having to resort to xfs-db
> hacks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
>  fs/xfs/libxfs/xfs_sb.h |  3 ++-
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d991eec05436..f51b1efa2cae 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -530,7 +530,8 @@ xfs_validate_sb_common(
>  	}
>  
>  	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
> -			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
> +			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
> +			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
>  		return -EFSCORRUPTED;
>  
>  	/*
> @@ -1323,8 +1324,10 @@ xfs_sb_get_secondary(
>  }
>  
>  /*
> - * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
> - * so users won't be confused by values in error messages.
> + * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
> + * won't be confused by values in error messages. This returns false if a value
> + * is invalid and it is not the primary superblock that going to be corrected
> + * later in the mount process.

Hmm, I found this last sentence a little confusing.  How about:

"This function returns false if the stripe geometry is invalid and no
attempt will be made to correct it later in the mount process."

>   */
>  bool
>  xfs_validate_stripe_geometry(
> @@ -1332,20 +1335,21 @@ xfs_validate_stripe_geometry(
>  	__s64			sunit,
>  	__s64			swidth,
>  	int			sectorsize,
> +	bool			primary_sb,
>  	bool			silent)
>  {
>  	if (swidth > INT_MAX) {
>  		if (!silent)
>  			xfs_notice(mp,
>  "stripe width (%lld) is too large", swidth);
> -		return false;
> +		goto check_override;
>  	}
>  
>  	if (sunit > swidth) {
>  		if (!silent)
>  			xfs_notice(mp,
>  "stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> -		return false;
> +		goto check_override;
>  	}
>  
>  	if (sectorsize && (int)sunit % sectorsize) {
> @@ -1353,21 +1357,21 @@ xfs_validate_stripe_geometry(
>  			xfs_notice(mp,
>  "stripe unit (%lld) must be a multiple of the sector size (%d)",
>  				   sunit, sectorsize);
> -		return false;
> +		goto check_override;
>  	}
>  
>  	if (sunit && !swidth) {
>  		if (!silent)
>  			xfs_notice(mp,
>  "invalid stripe unit (%lld) and stripe width of 0", sunit);
> -		return false;
> +		goto check_override;
>  	}
>  
>  	if (!sunit && swidth) {
>  		if (!silent)
>  			xfs_notice(mp,
>  "invalid stripe width (%lld) and stripe unit of 0", swidth);
> -		return false;
> +		goto check_override;
>  	}
>  
>  	if (sunit && (int)swidth % (int)sunit) {
> @@ -1375,9 +1379,27 @@ xfs_validate_stripe_geometry(
>  			xfs_notice(mp,
>  "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
>  				   swidth, sunit);
> -		return false;
> +		goto check_override;
>  	}
>  	return true;
> +
> +check_override:
> +	if (!primary_sb)
> +		return false;
> +	/*
> +	 * During mount, mp->m_dalign will not be set unless the sunit mount
> +	 * option was set. If it was set, ignore the bad stripe alignment values
> +	 * and allow the validation and overwrite later in the mount process to
> +	 * attempt to overwrite the bad stripe alignment values with the values
> +	 * supplied by mount options.

What catches the case of if m_dalign/m_swidth also being garbage values?
Is it xfs_check_new_dalign?  Should that fail the mount if the
replacement values are also garbage?

> +	 */
> +	if (!mp->m_dalign)
> +		return false;
> +	if (!silent)
> +		xfs_notice(mp,
> +"Will try to correct with specified mount options sunit (%d) and swidth (%d)",
> +			BBTOB(mp->m_dalign), BBTOB(mp->m_swidth));
> +	return true;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 67a40069724c..58798b9c70ba 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -35,7 +35,8 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
>  				struct xfs_buf **bpp);
>  
>  extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,

This declaration might as well lose the extern here too.

> -		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
> +		__s64 sunit, __s64 swidth, int sectorsize, bool primary_sb,
> +		bool silent);

What should value for @primary_sb should mkfs pass into
xfs_validate_stripe_geometry from calc_stripe_factors?

--D

>  
>  uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
>  
> -- 
> 2.43.0
> 
> 
