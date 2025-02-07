Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63306154439
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903142; cv=none; b=MOHk44vEIMB3bOhRwK/tgUuKjeC5wQ1E5gdAVSmsASF7sfE9ftoiKVy9GfcU0lSGK556tRsHUIIpqoVtB5oJma4hCJfz+0cTl89XzJl4aRP24Pvidb0uqrc6kKNhv8+XeLmU/NoscAgMLe989cY0Xn3uYi4SgmLmGr7W1zp9rzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903142; c=relaxed/simple;
	bh=VT+UDXIvrjLrOH5mmfrazLOm/nVgWuVsGIrbD0HtSJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8la1cjfsSe8cepZW0mjh7AfD+7OdpY8MHZPOwkPEiCeyL6qr+wpP2nEhlSRaL5+Y6h8OiyEUL2Ofgh+suPFEttXNnKbMrf+bHzsmPQTpH/zVFhLzofSOjMvQbsPaEbDGp30h2oab7EHUlYyjNkafF0Xrs0yEBDJmFMCUwVHqJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiyFHsfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiyFHsfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E23C4CED1;
	Fri,  7 Feb 2025 04:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738903141;
	bh=VT+UDXIvrjLrOH5mmfrazLOm/nVgWuVsGIrbD0HtSJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SiyFHsfmIjk/QjlU1CurRGckejs1Mr/oLqhZz4sKeQpnN6BUtiSpV+W/72WMISoHM
	 6VaYawC5uyFy0zetR2CEo/KV1R0LT2H5W/dvh6kqZlcoNTRJZUuhEH7WVQgaQ6n1Cs
	 BD717+VHcULgk30JaaZ82heAvqX8fZKAbTUvOU6bw4uUHSr0B2igbk34SVZg27YDZU
	 8odbLK+auqh5IryN6qau3ZzU2rUdKbAABxBQo+vS6knDnSEcS/6MqnxzWfvUZccOKb
	 1gavB6lTQMTwsOPBzr1DcsBLLiX7PchAS9uc8Qu1WAnei/kNUgrV3X9Yb1aW6V6R8h
	 pC9THbn6JNRwg==
Date: Thu, 6 Feb 2025 20:39:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs: enable fsmap reporting for internal RT devices
Message-ID: <20250207043901.GP21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-34-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-34-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:49AM +0100, Christoph Hellwig wrote:
> File system with internal RT devices are a bit odd in that we need
> to report AGs and RGs.  To make this happen use separate synthetic
> fmr_device values for the different sections instead of the dev_t
> mapping used by other XFS configurations.
> 
> The data device is reported as file system metadata before the
> start of the RGs for the synthetic RT fmr_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I've thought a bit more about something you said last time:

> The bmbt values are all relative to rtstart, the daddr translation is
> what adds the offset.  So if we want to take the offset out of the
> fsmap reporting, I'll need new helpers to not add it or manually
> subtract it afterwards.  If that's preferred it should be doable, even
> if the fsmap code keeps confusing me more each time I look at it.

The fmr_physical addresses of the fsmaps reported for the "XFS_DEV_RT"
device (aka when sb_rtstart > 0) are relative to the start of the data
device, right?  In a way, that makes it easier to figure out how to set
up a media scan or a block device to file translation, because the
fmr_physical number you feed in and get out of fsmap always matches the
device LBA.

So assuming that's still the case, then I like this enough to say
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_fs.h |  9 +++++
>  fs/xfs/xfs_fsmap.c     | 80 +++++++++++++++++++++++++++++++++---------
>  2 files changed, 72 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 5e66fb2b2cc7..12463ba766da 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -1082,6 +1082,15 @@ struct xfs_rtgroup_geometry {
>  #define XFS_IOC_COMMIT_RANGE	     _IOW ('X', 131, struct xfs_commit_range)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
> +/*
> + * Devices supported by a single XFS file system.  Reported in fsmaps fmr_device
> + * when using internal RT devices.
> + */
> +enum xfs_device {
> +	XFS_DEV_DATA	= 1,
> +	XFS_DEV_LOG	= 2,
> +	XFS_DEV_RT	= 3,
> +};
>  
>  #ifndef HAVE_BBMACROS
>  /*
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 917d4d0e51b3..a4bc1642fe56 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -879,17 +879,39 @@ xfs_getfsmap_rtdev_rmapbt(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_rtgroup		*rtg = NULL;
>  	struct xfs_btree_cur		*bt_cur = NULL;
> +	xfs_daddr_t			rtstart_daddr;
>  	xfs_rtblock_t			start_rtb;
>  	xfs_rtblock_t			end_rtb;
>  	xfs_rgnumber_t			start_rg, end_rg;
>  	uint64_t			eofs;
>  	int				error = 0;
>  
> -	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
> +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart + mp->m_sb.sb_rblocks);
>  	if (keys[0].fmr_physical >= eofs)
>  		return 0;
> -	start_rtb = xfs_daddr_to_rtb(mp, keys[0].fmr_physical);
> -	end_rtb = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
> +
> +	rtstart_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
> +	if (keys[0].fmr_physical < rtstart_daddr) {
> +		struct xfs_fsmap_irec		frec = {
> +			.owner			= XFS_RMAP_OWN_FS,
> +			.len_daddr		= rtstart_daddr,
> +		};
> +
> +		/* Adjust the low key if we are continuing from where we left off. */
> +		if (keys[0].fmr_length > 0) {
> +			info->low_daddr = keys[0].fmr_physical + keys[0].fmr_length;
> +			return 0;
> +		}
> +
> +		/* Fabricate an rmap entry for space occupied by the data dev */
> +		error = xfs_getfsmap_helper(tp, info, &frec);
> +		if (error)
> +			return error;
> +	}
> +
> +	start_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr + keys[0].fmr_physical);
> +	end_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr +
> +			min(eofs - 1, keys[1].fmr_physical));
>  
>  	info->missing_owner = XFS_FMR_OWN_FREE;
>  
> @@ -1004,22 +1026,40 @@ xfs_getfsmap_rtdev_rmapbt(
>  }
>  #endif /* CONFIG_XFS_RT */
>  
> +static uint32_t
> +xfs_getfsmap_device(
> +	struct xfs_mount	*mp,
> +	enum xfs_device		dev)
> +{
> +	if (mp->m_sb.sb_rtstart)
> +		return dev;
> +
> +	switch (dev) {
> +	case XFS_DEV_DATA:
> +		return new_encode_dev(mp->m_ddev_targp->bt_dev);
> +	case XFS_DEV_LOG:
> +		return new_encode_dev(mp->m_logdev_targp->bt_dev);
> +	case XFS_DEV_RT:
> +		if (!mp->m_rtdev_targp)
> +			break;
> +		return new_encode_dev(mp->m_rtdev_targp->bt_dev);
> +	}
> +
> +	return -1;
> +}
> +
>  /* Do we recognize the device? */
>  STATIC bool
>  xfs_getfsmap_is_valid_device(
>  	struct xfs_mount	*mp,
>  	struct xfs_fsmap	*fm)
>  {
> -	if (fm->fmr_device == 0 || fm->fmr_device == UINT_MAX ||
> -	    fm->fmr_device == new_encode_dev(mp->m_ddev_targp->bt_dev))
> -		return true;
> -	if (mp->m_logdev_targp &&
> -	    fm->fmr_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
> -		return true;
> -	if (mp->m_rtdev_targp &&
> -	    fm->fmr_device == new_encode_dev(mp->m_rtdev_targp->bt_dev))
> -		return true;
> -	return false;
> +	return fm->fmr_device == 0 ||
> +		fm->fmr_device == UINT_MAX ||
> +		fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_DATA) ||
> +		fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_LOG) ||
> +		(mp->m_rtdev_targp &&
> +		 fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_RT));
>  }
>  
>  /* Ensure that the low key is less than the high key. */
> @@ -1126,7 +1166,7 @@ xfs_getfsmap(
>  	/* Set up our device handlers. */
>  	memset(handlers, 0, sizeof(handlers));
>  	handlers[0].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> -	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
> +	handlers[0].dev = xfs_getfsmap_device(mp, XFS_DEV_DATA);
>  	if (use_rmap)
>  		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
>  	else
> @@ -1134,7 +1174,7 @@ xfs_getfsmap(
>  	if (mp->m_logdev_targp != mp->m_ddev_targp) {
>  		handlers[1].nr_sectors = XFS_FSB_TO_BB(mp,
>  						       mp->m_sb.sb_logblocks);
> -		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
> +		handlers[1].dev = xfs_getfsmap_device(mp, XFS_DEV_LOG);
>  		handlers[1].fn = xfs_getfsmap_logdev;
>  	}
>  #ifdef CONFIG_XFS_RT
> @@ -1144,7 +1184,7 @@ xfs_getfsmap(
>  	 */
>  	if (mp->m_rtdev_targp && (use_rmap || !xfs_has_zoned(mp))) {
>  		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
> -		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
> +		handlers[2].dev = xfs_getfsmap_device(mp, XFS_DEV_RT);
>  		if (use_rmap)
>  			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
>  		else
> @@ -1234,7 +1274,13 @@ xfs_getfsmap(
>  
>  	if (tp)
>  		xfs_trans_cancel(tp);
> -	head->fmh_oflags = FMH_OF_DEV_T;
> +
> +	/*
> +	 * For internal RT device we need to report different synthetic devices
> +	 * for a single physical device, and thus can't report the actual dev_t.
> +	 */
> +	if (!mp->m_sb.sb_rtstart)
> +		head->fmh_oflags = FMH_OF_DEV_T;
>  	return error;
>  }
>  
> -- 
> 2.45.2
> 
> 
