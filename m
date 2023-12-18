Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E1F73470
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwXuyeHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF75C433C9;
	Mon, 18 Dec 2023 12:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702904292;
	bh=R0ow3rgp3gOMfGNWCt7FsrxRoeKKqApgabQRs0dWcPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwXuyeHRt+n3SrYWGrXcUJpdX3umnnbL+fU7kXDKczGoXUfJ/1hpx1tOLrLIxvj4t
	 WKHMX7utDVBzXZA7hlX+YAdCgFwpADPi10U4cvv60JrWlDaU5RQJnZb9mPIsMFT30f
	 Vhh/+N6eSxkBUGlth/HSFD8QlSoJzMvX5j/hnJ7j23jQ9txTYOwSV+6qv25n1ncwdM
	 mEredqM+PVxQKRjPmgGB2i9LwFXV3al5k1kS7ZSeVfFhV4NSgWQHGvm5UUGVMy/EQ0
	 c2j8rC2SbJRE/TQ5KAFzdm2jnE81xlsvHW50cG5p3GBmHllbZqHDEnMBWgtp2Jlvoq
	 VyxOjh0XEsXLA==
Date: Mon, 18 Dec 2023 13:58:08 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/23] libxfs: stash away the device fd in struct
 xfs_buftarg
Message-ID: <qs2z2zual7ehwjndfwexoyre2alwutz5jhtgw3wicpf7csutp2@hikh7z2zvb34>
References: <20231211163742.837427-1-hch@lst.de>
 <tYknZ23nnvvyrVQDc1Qc4a48IXeGl4K3Vcj7Lxo47VtrHqQ07UJJQWF_v7lzl9qlGzEojQAoICAUSfkKzNCYFA==@protonmail.internalid>
 <20231211163742.837427-23-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-23-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:41PM +0100, Christoph Hellwig wrote:
> Cache the open file descriptor for each device in the buftarg
> structure and remove the now unused dev_map infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  include/libxfs.h   |   1 -
>  libxfs/init.c      | 108 +++++++++++----------------------------------
>  libxfs/libxfs_io.h |   1 +
>  libxfs/rdwr.c      |  16 +++----
>  repair/prefetch.c  |   2 +-
>  5 files changed, 34 insertions(+), 94 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 68efe9caa..058217c2a 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -147,7 +147,6 @@ extern xfs_lsn_t libxfs_max_lsn;
>  int		libxfs_init(struct libxfs_init *);
>  void		libxfs_destroy(struct libxfs_init *li);
> 
> -extern int	libxfs_device_to_fd (dev_t);
>  extern int	libxfs_device_alignment (void);
>  extern void	libxfs_report(FILE *);
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 866e5f425..320e4d63f 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -36,15 +36,7 @@ int libxfs_bhash_size;		/* #buckets in bcache */
> 
>  int	use_xfs_buf_lock;	/* global flag: use xfs_buf locks for MT */
> 
> -/*
> - * dev_map - map open devices to fd.
> - */
> -#define MAX_DEVS 10	/* arbitary maximum */
>  static int nextfakedev = -1;	/* device number to give to next fake device */
> -static struct dev_to_fd {
> -	dev_t	dev;
> -	int	fd;
> -} dev_map[MAX_DEVS]={{0}};
> 
>  /*
>   * Checks whether a given device has a mounted, writable
> @@ -70,33 +62,13 @@ check_isactive(char *name, char *block, int fatal)
>  	return 0;
>  }
> 
> -/* libxfs_device_to_fd:
> - *     lookup a device number in the device map
> - *     return the associated fd
> - */
> -int
> -libxfs_device_to_fd(dev_t device)
> -{
> -	int	d;
> -
> -	for (d = 0; d < MAX_DEVS; d++)
> -		if (dev_map[d].dev == device)
> -			return dev_map[d].fd;
> -
> -	fprintf(stderr, _("%s: %s: device %lld is not open\n"),
> -		progname, __FUNCTION__, (long long)device);
> -	exit(1);
> -	/* NOTREACHED */
> -}
> -
>  /* libxfs_device_open:
>   *     open a device and return its device number
>   */
>  static dev_t
>  libxfs_device_open(char *path, int creat, int xflags, int setblksize, int *fdp)
>  {
> -	dev_t		dev;
> -	int		fd, d, flags;
> +	int		fd, flags;
>  	int		readonly, dio, excl;
>  	struct stat	statb;
> 
> @@ -134,61 +106,28 @@ retry:
>  	}
> 
>  	/*
> -	 * Get the device number from the stat buf - unless
> -	 * we're not opening a real device, in which case
> -	 * choose a new fake device number.
> +	 * Get the device number from the stat buf - unless we're not opening a
> +	 * real device, in which case choose a new fake device number.
>  	 */
> -	dev = (statb.st_rdev) ? (statb.st_rdev) : (nextfakedev--);
> -
> -	for (d = 0; d < MAX_DEVS; d++)
> -		if (dev_map[d].dev == dev) {
> -			fprintf(stderr, _("%s: device %lld is already open\n"),
> -			    progname, (long long)dev);
> -			exit(1);
> -		}
> -
> -	for (d = 0; d < MAX_DEVS; d++)
> -		if (!dev_map[d].dev) {
> -			dev_map[d].dev = dev;
> -			dev_map[d].fd = fd;
> -			*fdp = fd;
> -
> -			return dev;
> -		}
> -
> -	fprintf(stderr, _("%s: %s: too many open devices\n"),
> -		progname, __FUNCTION__);
> -	exit(1);
> -	/* NOTREACHED */
> +	*fdp = fd;
> +	if (statb.st_rdev)
> +		return statb.st_rdev;
> +	return nextfakedev--;
>  }
> 
>  static void
> -libxfs_device_close(dev_t dev)
> +libxfs_device_close(int fd, dev_t dev)
>  {
> -	int	d;
> +	int	ret;
> 
> -	for (d = 0; d < MAX_DEVS; d++)
> -		if (dev_map[d].dev == dev) {
> -			int	fd, ret;
> -
> -			fd = dev_map[d].fd;
> -			dev_map[d].dev = dev_map[d].fd = 0;
> -
> -			ret = platform_flush_device(fd, dev);
> -			if (ret) {
> -				ret = -errno;
> -				fprintf(stderr,
> +	ret = platform_flush_device(fd, dev);
> +	if (ret) {
> +		ret = -errno;
> +		fprintf(stderr,
>  	_("%s: flush of device %lld failed, err=%d"),
> -						progname, (long long)dev, ret);
> -			}
> -			close(fd);
> -
> -			return;
> -		}
> -
> -	fprintf(stderr, _("%s: %s: device %lld is not open\n"),
> -			progname, __FUNCTION__, (long long)dev);
> -	exit(1);
> +			progname, (long long)dev, ret);
> +	}
> +	close(fd);
>  }
> 
>  static int
> @@ -271,11 +210,11 @@ libxfs_close_devices(
>  	struct libxfs_init	*li)
>  {
>  	if (li->ddev)
> -		libxfs_device_close(li->ddev);
> +		libxfs_device_close(li->dfd, li->ddev);
>  	if (li->logdev && li->logdev != li->ddev)
> -		libxfs_device_close(li->logdev);
> +		libxfs_device_close(li->logfd, li->logdev);
>  	if (li->rtdev)
> -		libxfs_device_close(li->rtdev);
> +		libxfs_device_close(li->rtfd, li->rtdev);
> 
>  	li->ddev = li->logdev = li->rtdev = 0;
>  	li->dfd = li->logfd = li->rtfd = -1;
> @@ -514,6 +453,7 @@ static struct xfs_buftarg *
>  libxfs_buftarg_alloc(
>  	struct xfs_mount	*mp,
>  	dev_t			dev,
> +	int			fd,
>  	unsigned long		write_fails)
>  {
>  	struct xfs_buftarg	*btp;
> @@ -526,6 +466,7 @@ libxfs_buftarg_alloc(
>  	}
>  	btp->bt_mount = mp;
>  	btp->bt_bdev = dev;
> +	btp->bt_bdev_fd = fd;
>  	btp->flags = 0;
>  	if (write_fails) {
>  		btp->writes_left = write_fails;
> @@ -629,13 +570,14 @@ libxfs_buftarg_init(
>  		return;
>  	}
> 
> -	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi->ddev, dfail);
> +	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi->ddev, xi->dfd, dfail);
>  	if (!xi->logdev || xi->logdev == xi->ddev)
>  		mp->m_logdev_targp = mp->m_ddev_targp;
>  	else
>  		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi->logdev,
> -				lfail);
> -	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi->rtdev, rfail);
> +				xi->logfd, lfail);
> +	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi->rtdev, xi->rtfd,
> +			rfail);
>  }
> 
>  /* Compute maximum possible height for per-AG btree types for this fs. */
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index bf4d4ecd9..267ea9796 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -26,6 +26,7 @@ struct xfs_buftarg {
>  	pthread_mutex_t		lock;
>  	unsigned long		writes_left;
>  	dev_t			bt_bdev;
> +	int			bt_bdev_fd;
>  	unsigned int		flags;
>  };
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index ccd1501ab..0e332110b 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -62,13 +62,13 @@ static void libxfs_brelse(struct cache_node *node);
>  int
>  libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  {
> +	int		fd = btp->bt_bdev_fd;
>  	xfs_off_t	start_offset, end_offset, offset;
>  	ssize_t		zsize, bytes;
>  	size_t		len_bytes;
>  	char		*z;
> -	int		error, fd;
> +	int		error;
> 
> -	fd = libxfs_device_to_fd(btp->bt_bdev);
>  	start_offset = LIBXFS_BBTOOFF64(start);
> 
>  	/* try to use special zeroing methods, fall back to writes if needed */
> @@ -598,7 +598,7 @@ int
>  libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
>  		int len, int flags)
>  {
> -	int	fd = libxfs_device_to_fd(btp->bt_bdev);
> +	int	fd = btp->bt_bdev_fd;
>  	int	bytes = BBTOB(len);
>  	int	error;
> 
> @@ -631,12 +631,11 @@ libxfs_readbuf_verify(
>  int
>  libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
>  {
> -	int	fd;
> +	int	fd = btp->bt_bdev_fd;
>  	int	error = 0;
>  	void	*buf;
>  	int	i;
> 
> -	fd = libxfs_device_to_fd(btp->bt_bdev);
>  	buf = bp->b_addr;
>  	for (i = 0; i < bp->b_nmaps; i++) {
>  		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
> @@ -820,7 +819,7 @@ int
>  libxfs_bwrite(
>  	struct xfs_buf	*bp)
>  {
> -	int		fd = libxfs_device_to_fd(bp->b_target->bt_bdev);
> +	int		fd = bp->b_target->bt_bdev_fd;
> 
>  	/*
>  	 * we never write buffers that are marked stale. This indicates they
> @@ -1171,13 +1170,12 @@ int
>  libxfs_blkdev_issue_flush(
>  	struct xfs_buftarg	*btp)
>  {
> -	int			fd, ret;
> +	int			ret;
> 
>  	if (btp->bt_bdev == 0)
>  		return 0;
> 
> -	fd = libxfs_device_to_fd(btp->bt_bdev);
> -	ret = platform_flush_device(fd, btp->bt_bdev);
> +	ret = platform_flush_device(btp->bt_bdev_fd, btp->bt_bdev);
>  	return ret ? -errno : 0;
>  }
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 017750e9a..78c1e3974 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -876,7 +876,7 @@ init_prefetch(
>  	xfs_mount_t		*pmp)
>  {
>  	mp = pmp;
> -	mp_fd = libxfs_device_to_fd(mp->m_ddev_targp->bt_bdev);
> +	mp_fd = mp->m_ddev_targp->bt_bdev_fd;;
>  	pf_max_bytes = sysconf(_SC_PAGE_SIZE) << 7;
>  	pf_max_bbs = pf_max_bytes >> BBSHIFT;
>  	pf_max_fsbs = pf_max_bytes >> mp->m_sb.sb_blocklog;
> --
> 2.39.2
> 
