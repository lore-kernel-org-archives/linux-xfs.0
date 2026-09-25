Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B0A501F39
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375840; cv=none; b=mfaJJYBXZpesqfSahoMldDHqoldwTC6ZdBc7NCDZzyffEgoqXWFJ7uSsT120ptV7IdedYqHnY2QKvoyuA7LHBVc6ii/bl0D74CVJETci41JxJl1cCsOluPGmwCa94iINERFEN8gdtYq4f6ThepplW8tSKKJ7oh29n394KrHOQNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375840; c=relaxed/simple;
	bh=NQtwQMDOvVl1X5y1hWS1A4Nq1saqVna4caGQllXkbPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbH1H9+xU5HkVGb8oQkd5E4cjA1YiaoTOeWnwqYqNU7NQK5TqrT0U+6OcH5WGnqgNtMcQy18b738JXNumg6gqkk396rb0SCF/9PFdXKLlv5oYi2E6AwzTOVrL2LTySCSlerCOaqknExLtRVggRENB9y0TQTEYSK0g0bpMmzFe8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a34PVDIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a34PVDIL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 15A191F000FF;
	Fri, 25 Sep 2026 22:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790375837;
	bh=bMGBQi7BaRh5fQqzHxFeppzCK7vJEJAUVhcJlRnoZqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a34PVDILVlV0gL+AeLS96KiPhthQ134zMbef7uVVfxhgEpb2BVS5fAqRPUGbjPjp0
	 cYL5ig4CV/ZoT+WLOWfYfSPnHMsl5zly14u8tlaZOtp7mZ7sOADsGXas6IohbO3p4v
	 VihnXcAFnfX1p7M0+yqsXcWfRUPPULaPVnj3aEbVtxNxbtzg3Aq+OqOIt41yBosr0D
	 yXqgWeS2ZXHT/Ez76Z0tTHwcwqhRjoohaWuJNgVbs78hSjX2brJrkQNKpO635pV4HX
	 zKSC3/6GEUqNuRJwCcSVRFaulHbULZHmUjF8BRL1O9Oei8xgX9VpCNoeW3JS0NT65r
	 3XCKVR3MgtZBA==
Date: Fri, 25 Sep 2026 15:37:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] libxfs: unify buftarg handling with the kernel
Message-ID: <20260925223716.GS2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-5-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:50AM +0200, Christoph Hellwig wrote:
> In the kernel, the RT buftarg is set to NULL when not realtime device is
> present, but libxfs still allocates one, and all users instead check for
> a NULL ->bt_bdev.
> 
> Switch to the kernel model of never allocating the buftarg, and check
> mp->m_rtdev_targp for NULL instead of just ->bt_bdev.

Might want to mention that xfsprogs now matches what the kernel does.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that added in,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  db/io.c         |  4 ++--
>  db/metadump.c   |  7 +++----
>  libxfs/init.c   | 40 +++++++++++++++++++---------------------
>  libxfs/rdwr.c   | 25 ++++++++++++++++---------
>  mkfs/xfs_mkfs.c |  6 ++----
>  5 files changed, 42 insertions(+), 40 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index fc9a25d41024..6aafe5bd8a15 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -651,7 +651,7 @@ set_log_cur(
>  	int		ring_flag,
>  	bbmap_t		*bbmap)
>  {
> -	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
> +	if (mp->m_logdev_targp == mp->m_ddev_targp) {
>  		fprintf(stderr, "no external log specified\n");
>  		exitcode = 1;
>  		return;
> @@ -668,7 +668,7 @@ set_rt_cur(
>  	int		ring_flag,
>  	bbmap_t		*bbmap)
>  {
> -	if (!mp->m_rtdev_targp->bt_bdev) {
> +	if (!mp->m_rtdev_targp) {
>  		printf(_("realtime device not loaded, use -R.\n"));
>  		return ENODEV;
>  	}
> diff --git a/db/metadump.c b/db/metadump.c
> index 39639a0d51b0..6c12a5270fea 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -3344,8 +3344,7 @@ write_metadump_v2(
>  	uint64_t		addr;
>  
>  	addr = off;
> -	if (type == TYP_LOG &&
> -	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
> +	if (type == TYP_LOG && mp->m_logdev_targp != mp->m_ddev_targp)
>  		addr |= XME_ADDR_LOG_DEVICE;
>  	else if (type == TYP_RTSB)
>  		addr |= XME_ADDR_RT_DEVICE;
> @@ -3464,7 +3463,7 @@ metadump_f(
>  		return 0;
>  	}
>  
> -	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
> +	if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		metadump.external_log = true;
>  
>  	if (metadump.external_log && !version_opt_set)
> @@ -3481,7 +3480,7 @@ metadump_f(
>  	 * enabled.
>  	 */
>  	if (xfs_has_realtime(mp) && xfs_has_rtsb(mp)) {
> -		if (mp->m_rtdev_targp->bt_bdev) {
> +		if (mp->m_rtdev_targp) {
>  			metadump.realtime_data = true;
>  			if (!version_opt_set)
>  				metadump.version = 2;
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 1613ce2d14a3..65dadb1a23f7 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -307,7 +307,7 @@ rtmount_init(
>  		return -1;
>  	}
>  
> -	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
> +	if (!mp->m_rtdev_targp && !xfs_is_debugger(mp)) {
>  		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
>  			progname);
>  		return -1;
> @@ -541,27 +541,26 @@ libxfs_buftarg_reinit(
>  		exit(1);
>  	}
>  
> -	if (!xi->log.dev || xi->log.dev == xi->data.dev) {
> -		if (mp->m_logdev_targp != mp->m_ddev_targp) {
> +	if (mp->m_logdev_targp != mp->m_ddev_targp) {
> +		if ((xi->log.dev && xi->log.dev == xi->data.dev) ||
> +		    mp->m_logdev_targp->bt_bdev != xi->log.dev ||
> +		    mp->m_logdev_targp->bt_mount != mp) {
>  			fprintf(stderr,
> -			_("%s: bad buftarg reinit, ldev mismatch\n"),
> +				_("%s: bad buftarg reinit, logdev\n"),
>  				progname);
>  			exit(1);
>  		}
> -	} else if (mp->m_logdev_targp->bt_bdev != xi->log.dev ||
> -		   mp->m_logdev_targp->bt_mount != mp) {
> -		fprintf(stderr,
> -			_("%s: bad buftarg reinit, logdev\n"),
> -			progname);
> -		exit(1);
>  	}
> -	if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
> -	    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
> -	     mp->m_rtdev_targp->bt_mount != mp)) {
> -		fprintf(stderr,
> -			_("%s: bad buftarg reinit, rtdev\n"),
> -			progname);
> -		exit(1);
> +
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> +		if ((xi->rt.dev && xi->rt.dev == xi->data.dev) ||
> +		    mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
> +		    mp->m_rtdev_targp->bt_mount != mp) {
> +			fprintf(stderr,
> +				_("%s: bad buftarg reinit, rtdev\n"),
> +				progname);
> +			exit(1);
> +		}
>  	}
>  }
>  
> @@ -687,7 +686,7 @@ check_many_rtgroups(
>  	xfs_daddr_t		d;
>  	int			error;
>  
> -	if (!mp->m_rtdev_targp->bt_bdev) {
> +	if (!mp->m_rtdev_targp) {
>  		fprintf(stderr, _("%s: no rt device, ignoring rgcount %u\n"),
>  				progname, sbp->sb_rgcount);
>  		if (!xfs_is_debugger(mp))
> @@ -824,8 +823,7 @@ libxfs_mount(
>  	} else
>  		libxfs_buf_relse(bp);
>  
> -	if (mp->m_logdev_targp->bt_bdev &&
> -	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
> +	if (mp->m_logdev_targp != mp->m_ddev_targp) {
>  		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
>  		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
>  		    libxfs_buf_read(mp->m_logdev_targp,
> @@ -1045,7 +1043,7 @@ libxfs_umount(
>  	free(mp->m_fsname);
>  	mp->m_fsname = NULL;
>  
> -	if (mp->m_rtdev_targp != mp->m_ddev_targp)
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
>  		libxfs_buftarg_free(mp->m_rtdev_targp);
>  	if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		libxfs_buftarg_free(mp->m_logdev_targp);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 90f2d56687ca..14cfec7a2859 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -171,7 +171,7 @@ libxfs_getrtsb(
>  	struct xfs_buf		*bp;
>  	int			error;
>  
> -	if (!mp->m_rtdev_targp->bt_bdev)
> +	if (!mp->m_rtdev_targp)
>  		return NULL;
>  
>  	ASSERT(!mp->m_sb.sb_rtstart);
> @@ -1028,7 +1028,8 @@ libxfs_bcache_purge(struct xfs_mount *mp)
>  		return;
>  	cache_purge(mp->m_ddev_targp->bcache);
>  	cache_purge(mp->m_logdev_targp->bcache);
> -	cache_purge(mp->m_rtdev_targp->bcache);
> +	if (mp->m_rtdev_targp)
> +		cache_purge(mp->m_rtdev_targp->bcache);
>  }
>  
>  void
> @@ -1038,7 +1039,8 @@ libxfs_bcache_flush(struct xfs_mount *mp)
>  		return;
>  	cache_flush(mp->m_ddev_targp->bcache);
>  	cache_flush(mp->m_logdev_targp->bcache);
> -	cache_flush(mp->m_rtdev_targp->bcache);
> +	if (mp->m_rtdev_targp)
> +		cache_flush(mp->m_rtdev_targp->bcache);
>  }
>  
>  int
> @@ -1046,7 +1048,8 @@ libxfs_bcache_overflowed(struct xfs_mount *mp)
>  {
>  	return cache_overflowed(mp->m_ddev_targp->bcache) ||
>  		cache_overflowed(mp->m_logdev_targp->bcache) ||
> -		cache_overflowed(mp->m_rtdev_targp->bcache);
> +		(mp->m_rtdev_targp &&
> +		 cache_overflowed(mp->m_rtdev_targp->bcache));
>  }
>  
>  struct cache_operations libxfs_bcache_operations = {
> @@ -1185,15 +1188,19 @@ libxfs_log_clear(
>  	xfs_daddr_t		end_blk;
>  	char			*ptr;
>  
> -	if (((btp && dptr) || (!btp && !dptr)) ||
> -	    (btp && !btp->bt_bdev) || !fs_uuid)
> +	if (!fs_uuid)
>  		return -EINVAL;
>  
> -	/* first zero the log */
> -	if (btp)
> +	if (btp) {
> +		if (dptr)
> +			return -EINVAL;
> +		/* first zero the log */
>  		libxfs_device_zero(btp, start, length);
> -	else
> +	} else {
> +		if (!dptr)
> +			return -EINVAL;
>  		memset(dptr, 0, BBTOB(length));
> +	}
>  
>  	/*
>  	 * Initialize the log record length and LSNs. XLOG_INIT_CYCLE is a
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3ce49a36eaa8..6eca76f0c3c9 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -5632,10 +5632,8 @@ prepare_devices(
>  			 &sbp->sb_uuid, cfg->sb_feat.log_version,
>  			 lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
>  	/* finally, check we can write the last block in the realtime area */
> -	if (mp->m_rtdev_targp->bt_bdev &&
> -	    mp->m_rtdev_targp != mp->m_ddev_targp &&
> -	    cfg->rtblocks > 0 &&
> -	    !xfs_has_zoned(mp)) {
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
> +	    cfg->rtblocks > 0 && !xfs_has_zoned(mp)) {
>  		buf = alloc_write_buf(mp->m_rtdev_targp,
>  				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
>  				BTOBB(cfg->blocksize));
> -- 
> 2.53.0
> 
> 
