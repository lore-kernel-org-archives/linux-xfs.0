Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D9819048A
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 20:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744661796; cv=none; b=aEzYctijtntzIKN+N0sOyebJpbvLf7cTQXSlwEG9NtHzXF3z0dMeVUcV46qwSJ3MjfrzrcraaJFdFUUjlDl6RGcQDYAd90lSAM+tD5kt4b6tAo76gIy9A4nunVytEQKBAaeTVrDGBz8GrNcoFni10dZpNynevJ+OhrDQcmHz91I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744661796; c=relaxed/simple;
	bh=EIBCP+SQPY4clQ6enRH21IMKC5FfwDLiHhWdtrnCxc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4VdKgYOppzhM2FBu2GeoipkU3ZzrVTkVsaK5faQbUJjP5TyHWkHWxxb1vkdcDAeOuA9eYWPeQ4to6yRnaMRSgSy98PtP0Ngj5uZks7NMf7+D8SoiulGo7W4zG+x0bXJituDovebLXZrsdDlB4zHoAtcFcq2glQmOd6C4qLusAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjRwIlQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjRwIlQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5A1C4CEE2;
	Mon, 14 Apr 2025 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744661796;
	bh=EIBCP+SQPY4clQ6enRH21IMKC5FfwDLiHhWdtrnCxc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TjRwIlQBwd4x2UFp9W5J5AdS6CDl046zrmQvtsFnpEZ4PTg0zo4tjiPwgQqExPmvv
	 8wTlSd7r2C39b5quiX6plmgTErp49ZFFK2AWKsp6cd6P/c2yZExz/eAbSyu3UFsikE
	 P1F9ffqNtPNCrBNByYbmSPuIJaL0gcUFt9eL3wDbCY+tpme1w00Eq2AQaxkyOpv3q7
	 +BrPDgAwJflLPPQlqOF4PtqnoRaSbP5MTa/owqdf+CAr3IFhvRFpDfBjNiuJz0lCG1
	 6zvhI5qnyWPn2d1nSi2duGMsmZ0+luSo4nSslKpBMPziaXIZkrk4QOZjeANDt2XMoM
	 lF7fR6MZF0yUw==
Date: Mon, 14 Apr 2025 13:16:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/43] FIXUP: xfs: allow internal RT devices for zoned
 mode
Message-ID: <20250414201634.GA25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
 <20250414053629.360672-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-14-hch@lst.de>

On Mon, Apr 14, 2025 at 07:35:56AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me now
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/libxfs.h    |  6 ++++++
>  include/xfs_mount.h |  7 +++++++
>  libxfs/init.c       | 13 +++++++++----
>  libxfs/rdwr.c       |  2 ++
>  repair/agheader.c   |  4 +++-
>  5 files changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 82b34b9d81c3..b968a2b88da3 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -293,4 +293,10 @@ static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
>  		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
>  }
>  
> +static inline bool xfs_sb_version_haszoned(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_ZONED);
> +}
> +
>  #endif	/* __LIBXFS_H__ */
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 7856acfb9f8e..bf9ebc25fc79 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -53,6 +53,13 @@ struct xfs_groups {
>  	 * rtgroup, so this mask must be 64-bit.
>  	 */
>  	uint64_t		blkmask;
> +
> +	/*
> +	 * Start of the first group in the device.  This is used to support a
> +	 * RT device following the data device on the same block device for
> +	 * SMR hard drives.
> +	 */
> +	xfs_fsblock_t		start_fsb;
>  };
>  
>  /*
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 5b45ed347276..a186369f3fd8 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -560,7 +560,7 @@ libxfs_buftarg_init(
>  				progname);
>  			exit(1);
>  		}
> -		if (xi->rt.dev &&
> +		if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
>  		    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
>  		     mp->m_rtdev_targp->bt_mount != mp)) {
>  			fprintf(stderr,
> @@ -577,7 +577,11 @@ libxfs_buftarg_init(
>  	else
>  		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
>  				lfail);
> -	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt, rfail);
> +	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
> +		mp->m_rtdev_targp = mp->m_ddev_targp;
> +	else
> +		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
> +				rfail);
>  }
>  
>  /* Compute maximum possible height for per-AG btree types for this fs. */
> @@ -978,7 +982,7 @@ libxfs_flush_mount(
>  			error = err2;
>  	}
>  
> -	if (mp->m_rtdev_targp) {
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
>  		err2 = libxfs_flush_buftarg(mp->m_rtdev_targp,
>  				_("realtime device"));
>  		if (!error)
> @@ -1031,7 +1035,8 @@ libxfs_umount(
>  	free(mp->m_fsname);
>  	mp->m_fsname = NULL;
>  
> -	libxfs_buftarg_free(mp->m_rtdev_targp);
> +	if (mp->m_rtdev_targp != mp->m_ddev_targp)
> +		libxfs_buftarg_free(mp->m_rtdev_targp);
>  	if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		libxfs_buftarg_free(mp->m_logdev_targp);
>  	libxfs_buftarg_free(mp->m_ddev_targp);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 35be785c435a..f06763b38bd8 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -175,6 +175,8 @@ libxfs_getrtsb(
>  	if (!mp->m_rtdev_targp->bt_bdev)
>  		return NULL;
>  
> +	ASSERT(!mp->m_sb.sb_rtstart);
> +
>  	error = libxfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
>  			XFS_FSB_TO_BB(mp, 1), 0, &bp, &xfs_rtsb_buf_ops);
>  	if (error)
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 327ba041671f..048e6c3143b5 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -485,7 +485,9 @@ secondary_sb_whack(
>  	 *
>  	 * size is the size of data which is valid for this sb.
>  	 */
> -	if (xfs_sb_version_hasmetadir(sb))
> +	if (xfs_sb_version_haszoned(sb))
> +		size = offsetofend(struct xfs_dsb, sb_rtreserved);
> +	else if (xfs_sb_version_hasmetadir(sb))
>  		size = offsetofend(struct xfs_dsb, sb_pad);
>  	else if (xfs_sb_version_hasmetauuid(sb))
>  		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
> -- 
> 2.47.2
> 
> 
