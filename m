Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173532C84F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710870916; cv=none; b=aIlQ/ulGy0pjm9lUhT+2hRr54xRiCJYfCq4w0kg577F0ORs5QY7+q6p4oSDMtunS7iD65zEB3DGnOvP765JQ1U6U0Rx2LxGQT0n7u3oMhWcS7kf2Yy4aJf0PA8DxCDAXfA8fzICkauuVuTLbpgvZlOfNpm1KIis8QPhot/bOVtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710870916; c=relaxed/simple;
	bh=lL8qj6nY5iECZapADnXblYGP6Bds6bwFTupf+fx9Euc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HbY8XBwd94ZM8c0D9jAUF/759ySOcP6mrv2cWakqp5kxFUp3AnTqT/93DBEh/OMp8OlQpXkZeI6MwGgoj+L5N63zq4ibTSJnHmjsjGEg/XfIDP+DRqzcuvMnq+WyYFI3tCqedfj79CmzVrQJsjK1+JxeTdiwJdX05nukMwu4vpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXdpoKIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXdpoKIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F10C433F1;
	Tue, 19 Mar 2024 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710870915;
	bh=lL8qj6nY5iECZapADnXblYGP6Bds6bwFTupf+fx9Euc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pXdpoKITzd7EZSAOhZE2o8yme160tYHn4jN4YGcitQwi1EQU1rD3XKo+m3U6oiVL7
	 /ts33si4w4leUTORrqLzM2UYeRsAlirJy+TpdoLDDimhttRweARmJN0gW0FWD9At56
	 WIDE9st6oUX2+C/wBqWyz1F0KW9Ex2edHB/Zg5m7EfxF9xT6NvNHBH/2RLZw8oukLd
	 upXHRfOFEMb/dLqyHiMhSW8zHQ2M/i0+7bhb8xx8/eVU/ONQTO7F1PAg/jx4S9pL5F
	 m7rervhXiYyXFkcWejbxPJ43LVSY9wDb3maU51QTKXFSIqlbX6IvRzTExW2hqCUiES
	 RcFDu0a/Vdgig==
Date: Tue, 19 Mar 2024 10:55:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: allow sunit mount option to repair bad primary
 sb stripe values
Message-ID: <20240319175515.GX1927156@frogsfrogsfrogs>
References: <ZfjcTxZEYl5Mzg9O@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfjcTxZEYl5Mzg9O@dread.disaster.area>

On Tue, Mar 19, 2024 at 11:29:03AM +1100, Dave Chinner wrote:
> 
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Version 2:
> - reworded comment desribing xfs_validate_stripe_geometry() return
>   value.
> - renamed @primary_sb to @may_repair to indicate that the caller may
>   be able to fix any inconsistency that is found, rather than
>   indicate that this is being called to validate the primary
>   superblock during mount.
> - don't need 'extern' for prototypes in headers.
> 
>  fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
>  fs/xfs/libxfs/xfs_sb.h |  5 +++--
>  2 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d991eec05436..73a4b895de67 100644
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
> + * won't be confused by values in error messages.  This function returns false
> + * if the stripe geometry is invalid and the caller is unable to repair the
> + * stripe configuration later in the mount process.
>   */
>  bool
>  xfs_validate_stripe_geometry(
> @@ -1332,20 +1335,21 @@ xfs_validate_stripe_geometry(
>  	__s64			sunit,
>  	__s64			swidth,
>  	int			sectorsize,
> +	bool			may_repair,
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
> +	if (!may_repair)
> +		return false;
> +	/*
> +	 * During mount, mp->m_dalign will not be set unless the sunit mount
> +	 * option was set. If it was set, ignore the bad stripe alignment values
> +	 * and allow the validation and overwrite later in the mount process to
> +	 * attempt to overwrite the bad stripe alignment values with the values
> +	 * supplied by mount options.
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
> index 2e8e8d63d4eb..37b1ed1bc209 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -35,8 +35,9 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
>  				struct xfs_buf **bpp);
>  
> -extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
> -		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
> +bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
> +		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
> +		bool silent);
>  
>  uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
>  
> 
