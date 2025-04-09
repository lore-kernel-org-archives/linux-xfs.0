Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE23A1A3159
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214149; cv=none; b=tr+Q6JP6vdNQZaMhdgrLjs8K0XbLdh7Nxn9IoO04yjcJr3wKxjMk1nqHtCvHM6UNJI0dH+cRGoz3xwGz1mhQm3qGv4tkDfi2OakWw5ZpkS73zY+NFg7j3bvKGvC7qgi/VIMksoNZLCIvCi+/WDwe/CLrRr3wDZiy8AbUJo3/Pvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214149; c=relaxed/simple;
	bh=mthoxDcElzgRsLVZaRCDuKxJFn7Kz3ktjjZTjEkypMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPvmdggslVhkI2Do8ageqEBmla1suJ37MioUZEnCOThK4VBA/mr/Bl05Rw0+3sE4FNScaBdnmT40+rkNcXvITT1lgmp4cAXTojdS6yi28KyRPkSd8EomMwUi0C+NW1VOdFkRFYsOp+bkfW8lB/WSq6PP3FyD2qWGoctlu5kEjxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dscMxxdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dscMxxdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373F0C4CEE2;
	Wed,  9 Apr 2025 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214149;
	bh=mthoxDcElzgRsLVZaRCDuKxJFn7Kz3ktjjZTjEkypMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dscMxxdMxbSTLk1IP9rGkts1fkXWKexD6TIUr7k2m1WHxTm6Q50BVAz4KFqHnh2ab
	 Jk2qqOUlCKzgCRlk6R2l/NSkSbjScsFSNbNSjTdXSC/6PZv/BeCQNG3fTttB8tddM6
	 U/p5stocp+n4i646y0Weg56EkLH2KbOgYJxi4HE0Fu4SBXOrZPYIAg7aj+KtQLWviF
	 g34AZu+fCOa4z7K73uTkntq1vMQnVq7IQwJ3XjbIwRXNeP6uj0LsUWkmrm+vQfcosG
	 CIC+g+L6dJZcCWkSQktEBDQp5UQw8vasJPLLSupyN+n23pl0D7ic3vFcg1uWQGEYYs
	 1RwXN3urwFryQ==
Date: Wed, 9 Apr 2025 08:55:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/45] FIXUP: xfs: allow internal RT devices for zoned
 mode
Message-ID: <20250409155548.GV6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-14-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:16AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/libxfs.h    |  6 ++++++
>  include/xfs_mount.h |  7 +++++++
>  libfrog/fsgeom.c    |  2 +-
>  libxfs/init.c       | 13 +++++++++----
>  libxfs/rdwr.c       |  2 ++
>  repair/agheader.c   |  4 +++-
>  6 files changed, 28 insertions(+), 6 deletions(-)
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
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index b5220d2d6ffd..13df88ae43a7 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -81,7 +81,7 @@ xfs_report_geom(
>  		isint ? _("internal log") : logname ? logname : _("external"),
>  			geo->blocksize, geo->logblocks, logversion,
>  		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
> -		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
> +		!geo->rtblocks ? _("none") : rtname ? rtname : _("internal"),

Hum.  This change means that if you call xfs_db -c info without
supplying a realtime device, the info command output will claim an
internal rt device:

$ truncate -s 3g /tmp/a
$ truncate -s 3g /tmp/b
$ mkfs.xfs -f /tmp/a -r rtdev=/tmp/b
$ xfs_db -c info /tmp/a
meta-data=/tmp/a                 isize=512    agcount=4, agsize=196608 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=786432, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =internal               extsz=4096   blocks=786432, rtextents=786432
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0

The realtime device is external, you just haven't supplied one.  How
about:

static inline const char *
rtdev_name(
	const struct xfs_fsop_geo	*geo,
	const char			*rtname)
{
	if (!geo->rtblocks)
		return _("none");
	if (geo->rtstart)
		return _("internal");
	if (!rtname)
		return _("external");
	return rtname;
}

instead?

--D

>  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
>  			(unsigned long long)geo->rtextents,
>  		"", geo->rgcount, geo->rgextents);
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
> index 327ba041671f..5bb4e47e0c5b 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -485,7 +485,9 @@ secondary_sb_whack(
>  	 *
>  	 * size is the size of data which is valid for this sb.
>  	 */
> -	if (xfs_sb_version_hasmetadir(sb))
> +	if (xfs_sb_version_haszoned(sb))
> +		size = offsetofend(struct xfs_dsb, sb_rtstart);
> +	else if (xfs_sb_version_hasmetadir(sb))
>  		size = offsetofend(struct xfs_dsb, sb_pad);
>  	else if (xfs_sb_version_hasmetauuid(sb))
>  		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
> -- 
> 2.47.2
> 
> 
