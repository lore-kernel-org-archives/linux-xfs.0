Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A875C1B219D
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 23:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734131479; cv=none; b=EMw+rrw6qSlLLuRAEB6K4YSIbn2ErKeRGsmpDF/u5UBPgNW+/qReeQuLvdqvuBVa67QfavRst/xtbK0bQeM9sabXgsTd+yQxhpba+9BVAEOeBaJ4yf0lq88V00MqvFSveDoX5O1RU5lL2pfMczf6dcqpoKBcYxL12j1+uIhYKss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734131479; c=relaxed/simple;
	bh=bVnrfEurW8VRBoFEZbyWPfe/1rV9tNsOf2y32CDPN2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpAuGVaGFn0bXJXvCN+8rqv3/X4WWnOEtasJFCzkBNOpXrYsnFgZdbAiC8csFamQP3iP63QwpIlexy6xZGn6yyls8crHrCXADUmuuA/+xzKB18hAxcuMfruZKZPdNV+6C0QBJOojmbfQlf3jpOdEi3Qg9VhOX/qs1tsVMKE59aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGrcL3iv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGrcL3iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6B4C4CED0;
	Fri, 13 Dec 2024 23:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734131476;
	bh=bVnrfEurW8VRBoFEZbyWPfe/1rV9tNsOf2y32CDPN2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eGrcL3ivVfxaGTq8HeqIkeBmIC9CIMNOyJVQXA5WW7g9mnT3Cad4T6HVdQHqO6cuW
	 JNEIXVT4ZmVc6TPil97WpUbdGTksB+68Ql0tID8KMGtQh2DQ3P2QCCC7YeMXpTvnb3
	 53qkni3X+3zko8dgMuAMkoi+wR3JrzT6/X/x/0NJ8JlHQDgzvEQ1bSAQArWrow0Hhz
	 RD1mMCbOyYag7Hl06Phpcqb6J8uHdTQPJVIn9X9bPzmVGxLjG/ojyw79tGkDO9JfbD
	 7cj6hLGOWxAKjEfh+zquVaQQ/TbQMFw2NJH8xT7dzYBP+yjrKj/3ejrMIqd9kb93Wx
	 ACIyEHGZy7qYQ==
Date: Fri, 13 Dec 2024 15:11:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/43] xfs: enable fsmap reporting for internal RT devices
Message-ID: <20241213231115.GF6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-36-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-36-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:00AM +0100, Christoph Hellwig wrote:
> File system with internal RT devices are a bit odd in that we need
> to report AGs and RGs.  To make this happen use separate synthetic
> fmr_device values for the different sections instead of the dev_t
> mapping used by other XFS configurations.
> 
> The data device is reported as file system metadata before the
> start of the RGs for the synthetic RT fmr_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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

Seeing as you report different fmr_device values for the data and rt
devices, I'd have though that you'd want the rt fsmappings to start at
fmr_physical == 0.  But then I guess for the sb_rtstart > 0 case, the
rtblock values that get written into the bmbt have that rtstart value
added in, don't they?

--D

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
