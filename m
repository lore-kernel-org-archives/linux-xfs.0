Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAEE134A6
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 09:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M031Qw4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3701C433C8;
	Mon, 18 Dec 2023 09:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702891321;
	bh=KaAASd/ZaEO4ZJ03M7kD8DCzDxp4IZ0lyEeLF8wYzW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M031Qw4M9XZRv2Ry6i3xVZDX3f5yV8zV11Z7aUrvdrLs9kWfP8EiDLQS8ay7Ou2/X
	 Q144WpzdZIT99knQfTqLxO3luIyCqdSa1ldfAG2x+vP4cfSpEIXPefPDe/fU25fw54
	 Rngv74uEwvpPEcFCKM8zbeJkN9HZhdxT/EOV7kl4oa5Hf/X138Mk0HEDwmOZqlXvTc
	 j9RmKkafdNyTpCOhbWqIzf+afI4mCXB95/KvhNxE+n16RYuYxPzLxB94YGVDuBAwKk
	 KOoII7fWHFulo/NqYCfD8xiKY0ycYo/RZx8iYvrhbUj3kppAp20lxtTjU+GlL2u4UK
	 f2gpqnDw+JsHQ==
Date: Mon, 18 Dec 2023 10:21:57 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/23] libxfs: pass a struct libxfs_init to
 libxfs_alloc_buftarg
Message-ID: <qq2w6crlkqtuko5rsj54omkwdldprcpob7bwfxnjji5uqgqgto@grsp4jzgq6vf>
References: <20231211163742.837427-1-hch@lst.de>
 <BKSHI8u1Uo77oLyza13njxEDPul2zFQrJmRc5BRp8qb_Ww1zv003yqKFHxN0onH89za34Pb2O273qflLyw4Xog==@protonmail.internalid>
 <20231211163742.837427-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-13-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:31PM +0100, Christoph Hellwig wrote:
> Pass a libxfs_init structure to libxfs_alloc_buftarg instead of three
> separate dev_t values.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  copy/xfs_copy.c     |  2 +-
>  db/init.c           |  2 +-
>  db/sb.c             |  2 +-
>  libxfs/init.c       | 26 +++++++++++++-------------
>  libxfs/libxfs_io.h  |  4 ++--
>  logprint/logprint.c |  2 +-
>  mkfs/xfs_mkfs.c     |  2 +-
>  7 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index fbccd32a1..2f98ae8fb 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -730,7 +730,7 @@ main(int argc, char **argv)
>  	memset(&mbuf, 0, sizeof(xfs_mount_t));
> 
>  	/* We don't yet know the sector size, so read maximal size */
> -	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
> +	libxfs_buftarg_init(&mbuf, &xargs);
>  	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
>  			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &sbp, NULL);
>  	if (error) {
> diff --git a/db/init.c b/db/init.c
> index 74c63e218..8bd8e83f6 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -106,7 +106,7 @@ init(
>  	 * tool and so need to be able to mount busted filesystems.
>  	 */
>  	memset(&xmount, 0, sizeof(struct xfs_mount));
> -	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
> +	libxfs_buftarg_init(&xmount, &x);
>  	error = -libxfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
>  			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
>  	if (error) {
> diff --git a/db/sb.c b/db/sb.c
> index 2f046c6aa..30709e84e 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -233,7 +233,7 @@ sb_logcheck(void)
>  		}
>  	}
> 
> -	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
> +	libxfs_buftarg_init(mp, &x);
> 
>  	dirty = xlog_is_dirty(mp, mp->m_log);
>  	if (dirty == -1) {
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 1b7397819..14962b9fa 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -607,9 +607,7 @@ static char *wf_opts[] = {
>  void
>  libxfs_buftarg_init(
>  	struct xfs_mount	*mp,
> -	dev_t			dev,
> -	dev_t			logdev,
> -	dev_t			rtdev)
> +	struct libxfs_init	*xi)
>  {
>  	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
>  	unsigned long		dfail = 0, lfail = 0, rfail = 0;
> @@ -653,29 +651,30 @@ libxfs_buftarg_init(
> 
>  	if (mp->m_ddev_targp) {
>  		/* should already have all buftargs initialised */
> -		if (mp->m_ddev_targp->bt_bdev != dev ||
> +		if (mp->m_ddev_targp->bt_bdev != xi->ddev ||
>  		    mp->m_ddev_targp->bt_mount != mp) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, ddev\n"),
>  				progname);
>  			exit(1);
>  		}
> -		if (!logdev || logdev == dev) {
> +		if (!xi->logdev || xi->logdev == xi->ddev) {
>  			if (mp->m_logdev_targp != mp->m_ddev_targp) {
>  				fprintf(stderr,
>  				_("%s: bad buftarg reinit, ldev mismatch\n"),
>  					progname);
>  				exit(1);
>  			}
> -		} else if (mp->m_logdev_targp->bt_bdev != logdev ||
> +		} else if (mp->m_logdev_targp->bt_bdev != xi->logdev ||
>  			   mp->m_logdev_targp->bt_mount != mp) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, logdev\n"),
>  				progname);
>  			exit(1);
>  		}
> -		if (rtdev && (mp->m_rtdev_targp->bt_bdev != rtdev ||
> -			      mp->m_rtdev_targp->bt_mount != mp)) {
> +		if (xi->rtdev &&
> +		    (mp->m_rtdev_targp->bt_bdev != xi->rtdev ||
> +		     mp->m_rtdev_targp->bt_mount != mp)) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, rtdev\n"),
>  				progname);
> @@ -684,12 +683,13 @@ libxfs_buftarg_init(
>  		return;
>  	}
> 
> -	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev, dfail);
> -	if (!logdev || logdev == dev)
> +	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi->ddev, dfail);
> +	if (!xi->logdev || xi->logdev == xi->ddev)
>  		mp->m_logdev_targp = mp->m_ddev_targp;
>  	else
> -		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev, lfail);
> -	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev, rfail);
> +		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi->logdev,
> +				lfail);
> +	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi->rtdev, rfail);
>  }
> 
>  /* Compute maximum possible height for per-AG btree types for this fs. */
> @@ -757,7 +757,7 @@ libxfs_mount(
>  		xfs_set_debugger(mp);
>  	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
>  		xfs_set_reporting_corruption(mp);
> -	libxfs_buftarg_init(mp, xi->ddev, xi->logdev, xi->rtdev);
> +	libxfs_buftarg_init(mp, xi);
> 
>  	mp->m_finobt_nores = true;
>  	xfs_set_inode32(mp);
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index fae864272..bf4d4ecd9 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -14,6 +14,7 @@
>  struct xfs_buf;
>  struct xfs_mount;
>  struct xfs_perag;
> +struct libxfs_init;
> 
>  /*
>   * IO verifier callbacks need the xfs_mount pointer, so we have to behave
> @@ -50,8 +51,7 @@ xfs_buftarg_trip_write(
>  	pthread_mutex_unlock(&btp->lock);
>  }
> 
> -extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
> -				    dev_t logdev, dev_t rtdev);
> +void libxfs_buftarg_init(struct xfs_mount *mp, struct libxfs_init *xi);
>  int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
> 
>  #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index c6e5051e8..c2976333d 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -213,7 +213,7 @@ main(int argc, char **argv)
>  	if (!libxfs_init(&x))
>  		exit(1);
> 
> -	libxfs_buftarg_init(&mount, x.ddev, x.logdev, x.rtdev);
> +	libxfs_buftarg_init(&mount, &x);
>  	logstat(&mount, &log);
> 
>  	logfd = (x.logfd < 0) ? x.dfd : x.logfd;
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5aadf0f94..50b0a7e19 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4313,7 +4313,7 @@ main(
>  	/*
>  	 * we need the libxfs buffer cache from here on in.
>  	 */
> -	libxfs_buftarg_init(mp, xi.ddev, xi.logdev, xi.rtdev);
> +	libxfs_buftarg_init(mp, &xi);
> 
>  	/*
>  	 * Before we mount the filesystem we need to make sure the devices have
> --
> 2.39.2
> 
