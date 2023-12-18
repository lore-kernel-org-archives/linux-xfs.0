Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DDB125C1
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 09:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/hss0lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA62C433C7;
	Mon, 18 Dec 2023 09:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702891294;
	bh=rizfVKQWhe1H+lWyZcFDoW+yQvSzfnP0FZqVXVULIb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/hss0lZ5mkfsXnCkw8PBtAIC5kZFwDAvWRuGoBPvMC2nGCwdvKCRU4wIoQF5dy2/
	 rgyJeL9zRs99/AB/Z7MvVuHn1d7Z1i5W/VJ/uFzV1z+MOL29MEAoYaHvqktfaf1UY6
	 ceXE9PVFV0hgY7lq+elwFb9/OWxJ4aQ8Cis+hHW+60/9MOBYFxjm7lMrBcwN7CWScs
	 4bOKFLtuN4yrFzUXLO8papDWHCv5g1jlT4Y2JcFDiRD+uwkVnnYjWN79jllHmLqf6V
	 mmMJixSdQ6sYeN5BevEokMtQjOOfUng+vmdf+y4RpcU2xej876znvEuKhF1NsD4yfM
	 sL5BIIU9Hfzvw==
Date: Mon, 18 Dec 2023 10:21:30 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/23] libxfs: pass a struct libxfs_init to libxfs_mount
Message-ID: <xst7kca2t5pikuqjexe3ky7qhkzlvdy7tc22sutmkuqxvxt5y7@rydkbirqnme7>
References: <20231211163742.837427-1-hch@lst.de>
 <JdvbY1S3ywiiWUIKBCbTVHVstV4oDq0WijNB9AMJmvkAnOt11HwthjtSrz0vJiuMQhSNoeEdi_bpctRw5PGiLQ==@protonmail.internalid>
 <20231211163742.837427-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-12-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:30PM +0100, Christoph Hellwig wrote:
> Pass a libxfs_init structure to libxfs_mount instead of three separate
> dev_t values.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  copy/xfs_copy.c     | 2 +-
>  db/init.c           | 3 +--
>  include/xfs_mount.h | 3 ++-
>  libxfs/init.c       | 8 +++-----
>  mkfs/xfs_mkfs.c     | 5 +++--
>  repair/xfs_repair.c | 2 +-
>  6 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 12ad81eb1..fbccd32a1 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -755,7 +755,7 @@ main(int argc, char **argv)
>  	}
>  	libxfs_buf_relse(sbp);
> 
> -	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
> +	mp = libxfs_mount(&mbuf, sb, &xargs, 0);
>  	if (mp == NULL) {
>  		do_log(_("%s: %s filesystem failed to initialize\n"
>  			"%s: Aborting.\n"), progname, source_name, progname);
> diff --git a/db/init.c b/db/init.c
> index 36e2bb89d..74c63e218 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -130,8 +130,7 @@ init(
>  	}
> 
>  	agcount = sbp->sb_agcount;
> -	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
> -			  LIBXFS_MOUNT_DEBUGGER);
> +	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
>  		fprintf(stderr,
>  			_("%s: device %s unusable (not an XFS filesystem?)\n"),
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 99d1d9ab1..9adc1f898 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -10,6 +10,7 @@
>  struct xfs_inode;
>  struct xfs_buftarg;
>  struct xfs_da_geometry;
> +struct libxfs_init;
> 
>  typedef void (*buf_writeback_fn)(struct xfs_buf *bp);
> 
> @@ -272,7 +273,7 @@ __XFS_UNSUPP_OPSTATE(shutdown)
> 
>  void libxfs_compute_all_maxlevels(struct xfs_mount *mp);
>  struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
> -		dev_t dev, dev_t logdev, dev_t rtdev, unsigned int flags);
> +		struct libxfs_init *xi, unsigned int flags);
>  int libxfs_flush_mount(struct xfs_mount *mp);
>  int		libxfs_umount(struct xfs_mount *mp);
>  extern void	libxfs_rtmount_destroy (xfs_mount_t *);
> diff --git a/libxfs/init.c b/libxfs/init.c
> index cafd40b11..1b7397819 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -744,9 +744,7 @@ struct xfs_mount *
>  libxfs_mount(
>  	struct xfs_mount	*mp,
>  	struct xfs_sb		*sb,
> -	dev_t			dev,
> -	dev_t			logdev,
> -	dev_t			rtdev,
> +	struct libxfs_init	*xi,
>  	unsigned int		flags)
>  {
>  	struct xfs_buf		*bp;
> @@ -759,7 +757,7 @@ libxfs_mount(
>  		xfs_set_debugger(mp);
>  	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
>  		xfs_set_reporting_corruption(mp);
> -	libxfs_buftarg_init(mp, dev, logdev, rtdev);
> +	libxfs_buftarg_init(mp, xi->ddev, xi->logdev, xi->rtdev);
> 
>  	mp->m_finobt_nores = true;
>  	xfs_set_inode32(mp);
> @@ -825,7 +823,7 @@ libxfs_mount(
>  	/* Initialize the precomputed transaction reservations values */
>  	xfs_trans_init(mp);
> 
> -	if (dev == 0)	/* maxtrres, we have no device so leave now */
> +	if (xi->ddev == 0)	/* maxtrres, we have no device so leave now */
>  		return mp;
> 
>  	/* device size checks must pass unless we're a debugger. */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 346516e13..5aadf0f94 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3483,11 +3483,12 @@ calculate_log_size(
>  	int			min_logblocks;	/* absolute minimum */
>  	int			max_logblocks;	/* absolute max for this AG */
>  	struct xfs_mount	mount;
> +	struct libxfs_init	dummy_init = { };
> 
>  	/* we need a temporary mount to calculate the minimum log size. */
>  	memset(&mount, 0, sizeof(mount));
>  	mount.m_sb = *sbp;
> -	libxfs_mount(&mount, &mp->m_sb, 0, 0, 0, 0);
> +	libxfs_mount(&mount, &mp->m_sb, &dummy_init, 0);
>  	min_logblocks = libxfs_log_calc_minimum_size(&mount);
>  	libxfs_umount(&mount);
> 
> @@ -4320,7 +4321,7 @@ main(
>  	 * mount.
>  	 */
>  	prepare_devices(&cfg, &xi, mp, sbp, force_overwrite);
> -	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
> +	mp = libxfs_mount(mp, sbp, &xi, 0);
>  	if (mp == NULL) {
>  		fprintf(stderr, _("%s: filesystem failed to initialize\n"),
>  			progname);
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index ff29bea97..8a6cf31b4 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1034,7 +1034,7 @@ main(int argc, char **argv)
>  	 * initialized in phase 2.
>  	 */
>  	memset(&xfs_m, 0, sizeof(xfs_mount_t));
> -	mp = libxfs_mount(&xfs_m, &psb, x.ddev, x.logdev, x.rtdev, 0);
> +	mp = libxfs_mount(&xfs_m, &psb, &x, 0);
> 
>  	if (!mp)  {
>  		fprintf(stderr,
> --
> 2.39.2
> 
> 
