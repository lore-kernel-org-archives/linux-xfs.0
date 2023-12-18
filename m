Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7C374E10
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 13:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YLnKWBTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0340BC433C7;
	Mon, 18 Dec 2023 13:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702904503;
	bh=TdRwAoKaJCJldkg/YF/s1jj8K5LgirxRiYGjQVMmUnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YLnKWBTM8JxCpaNUXYCDCfDgKKGfer0OYl4XeCgtRc+0DcOt6H8EvsMHYuLMZ5MiL
	 jFWjVFNxdYUSNTjke5+nZY0Kt4P2PWgieuYXEyrSWHHSQ39m1WT2knyGNm69jmoC61
	 b39BV0tCiJJ3HE105Fk2r89f4VX4uqPtNhzrDgH1J1r5knSvrOfIjJzQ/bnA68HKbQ
	 hZbq/9T9rLxn0ewughNPqJDeYOk2F5eJ5MFa22iM/8dsUxMzyhgHy5FSZYls6j2doZ
	 U9LF15bFNo+YKu/YakvX9qYe+zP4RWc74869jYWrSlAYODQOpuNopbiBtJMAq4FIx/
	 JxVvzGf1ESEEA==
Date: Mon, 18 Dec 2023 14:01:38 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/23] libxfs: split out a libxfs_dev structure from
 struct libxfs_init
Message-ID: <2nyuull3d4ntxsh2hav72r25l2utowedqkbl64dnsrg7eowbc5@cm7zam2kpkdq>
References: <20231211163742.837427-1-hch@lst.de>
 <ptVNBCzePag7k--qlvwh0_pd0Ou55uCJzpn9XTdH7ZCpE5mVyROMwtW_WZIxLC4mWGs-pGsJI7MLfftHproh6A==@protonmail.internalid>
 <20231211163742.837427-24-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231211163742.837427-24-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:42PM +0100, Christoph Hellwig wrote:
> Most of the content of libxfs_init is members duplicated for each of the
> data, log and RT devices.  Split those members into a separate
> libxfs_dev structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  copy/xfs_copy.c     |   4 +-
>  db/info.c           |   2 +-
>  db/init.c           |  12 +--
>  db/output.c         |   2 +-
>  db/sb.c             |   8 +-
>  growfs/xfs_growfs.c |  20 ++---
>  include/libxfs.h    |  45 ++++------
>  libxfs/init.c       | 210 +++++++++++++++++++++-----------------------
>  libxfs/topology.c   |  16 ++--
>  logprint/logprint.c |  40 ++++-----
>  mkfs/xfs_mkfs.c     | 158 ++++++++++++++++-----------------
>  repair/init.c       |  12 +--
>  repair/phase2.c     |   4 +-
>  repair/sb.c         |  16 ++--
>  repair/xfs_repair.c |   8 +-
>  15 files changed, 265 insertions(+), 292 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index bd7c6d334..6e692e4f7 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -716,8 +716,8 @@ main(int argc, char **argv)
> 
>  	memset(&xargs, 0, sizeof(xargs));
>  	xargs.flags = LIBXFS_ISREADONLY | LIBXFS_DIRECT;
> -	xargs.dname = source_name;
> -	xargs.disfile = source_is_file;
> +	xargs.data.name = source_name;
> +	xargs.data.isfile = source_is_file;
> 
>  	if (!libxfs_init(&xargs))  {
>  		do_log(_("%s: couldn't initialize XFS library\n"
> diff --git a/db/info.c b/db/info.c
> index b30ada3aa..9c6203f02 100644
> --- a/db/info.c
> +++ b/db/info.c
> @@ -30,7 +30,7 @@ info_f(
>  	struct xfs_fsop_geom	geo;
> 
>  	libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
> -	xfs_report_geom(&geo, x.dname, x.logname, x.rtname);
> +	xfs_report_geom(&geo, x.data.name, x.log.name, x.rt.name);
>  	return 0;
>  }
> 
> diff --git a/db/init.c b/db/init.c
> index f240d0f66..cea25ae52 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -61,7 +61,7 @@ init(
>  			cmdline[ncmdline++] = optarg;
>  			break;
>  		case 'f':
> -			x.disfile = 1;
> +			x.data.isfile = 1;
>  			break;
>  		case 'F':
>  			force = 1;
> @@ -76,7 +76,7 @@ init(
>  			x.flags = LIBXFS_ISREADONLY;
>  			break;
>  		case 'l':
> -			x.logname = optarg;
> +			x.log.name = optarg;
>  			break;
>  		case 'x':
>  			expert_mode = 1;
> @@ -91,7 +91,7 @@ init(
>  	if (optind + 1 != argc)
>  		usage();
> 
> -	x.dname = argv[optind];
> +	x.data.name = argv[optind];
>  	x.flags |= LIBXFS_DIRECT;
> 
>  	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
> @@ -111,7 +111,7 @@ init(
>  			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
> -			"bytes)\n"), progname, x.dname);
> +			"bytes)\n"), progname, x.data.name);
>  		exit(1);
>  	}
> 
> @@ -122,7 +122,7 @@ init(
>  	sbp = &xmount.m_sb;
>  	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
>  		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
> -			progname, x.dname, sbp->sb_magicnum);
> +			progname, x.data.name, sbp->sb_magicnum);
>  		if (!force) {
>  			fprintf(stderr, _("Use -F to force a read attempt.\n"));
>  			exit(EXIT_FAILURE);
> @@ -134,7 +134,7 @@ init(
>  	if (!mp) {
>  		fprintf(stderr,
>  			_("%s: device %s unusable (not an XFS filesystem?)\n"),
> -			progname, x.dname);
> +			progname, x.data.name);
>  		exit(1);
>  	}
>  	mp->m_log = &xlog;
> diff --git a/db/output.c b/db/output.c
> index 30ae82ced..d12266c42 100644
> --- a/db/output.c
> +++ b/db/output.c
> @@ -34,7 +34,7 @@ dbprintf(const char *fmt, ...)
>  	blockint();
>  	i = 0;
>  	if (dbprefix)
> -		i += printf("%s: ", x.dname);
> +		i += printf("%s: ", x.data.name);
>  	i += vprintf(fmt, ap);
>  	unblockint();
>  	va_end(ap);
> diff --git a/db/sb.c b/db/sb.c
> index b2aa4a626..b48767f47 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -220,13 +220,13 @@ sb_logcheck(void)
>  	int		dirty;
> 
>  	if (mp->m_sb.sb_logstart) {
> -		if (x.logdev && x.logdev != x.ddev) {
> +		if (x.log.dev && x.log.dev != x.data.dev) {
>  			dbprintf(_("aborting - external log specified for FS "
>  				 "with an internal log\n"));
>  			return 0;
>  		}
>  	} else {
> -		if (!x.logdev || (x.logdev == x.ddev)) {
> +		if (!x.log.dev || (x.log.dev == x.data.dev)) {
>  			dbprintf(_("aborting - no external log specified for FS "
>  				 "with an external log\n"));
>  			return 0;
> @@ -452,10 +452,10 @@ uuid_f(
>  			}
>  		}
>  		if (mp->m_sb.sb_logstart) {
> -			if (x.logdev && x.logdev != x.ddev)
> +			if (x.log.dev && x.log.dev != x.data.dev)
>  				dbprintf(_("warning - external log specified "
>  					 "for FS with an internal log\n"));
> -		} else if (!x.logdev || (x.logdev == x.ddev)) {
> +		} else if (!x.log.dev || (x.log.dev == x.data.dev)) {
>  			dbprintf(_("warning - no external log specified "
>  				 "for FS with an external log\n"));
>  		}
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 05aea3496..4b941403e 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -183,26 +183,26 @@ main(int argc, char **argv)
>  	 */
> 
>  	memset(&xi, 0, sizeof(xi));
> -	xi.dname = datadev;
> -	xi.logname = logdev;
> -	xi.rtname = rtdev;
> +	xi.data.name = datadev;
> +	xi.log.name = logdev;
> +	xi.rt.name = rtdev;
>  	xi.flags = LIBXFS_ISREADONLY;
> 
>  	if (!libxfs_init(&xi))
>  		usage();
> 
>  	/* check we got the info for all the sections we are trying to modify */
> -	if (!xi.ddev) {
> +	if (!xi.data.dev) {
>  		fprintf(stderr, _("%s: failed to access data device for %s\n"),
>  			progname, fname);
>  		exit(1);
>  	}
> -	if (lflag && !isint && !xi.logdev) {
> +	if (lflag && !isint && !xi.log.dev) {
>  		fprintf(stderr, _("%s: failed to access external log for %s\n"),
>  			progname, fname);
>  		exit(1);
>  	}
> -	if (rflag && !xi.rtdev) {
> +	if (rflag && !xi.rt.dev) {
>  		fprintf(stderr,
>  			_("%s: failed to access realtime device for %s\n"),
>  			progname, fname);
> @@ -211,10 +211,10 @@ main(int argc, char **argv)
> 
>  	xfs_report_geom(&geo, datadev, logdev, rtdev);
> 
> -	ddsize = xi.dsize;
> -	dlsize = ( xi.logBBsize? xi.logBBsize :
> +	ddsize = xi.data.size;
> +	dlsize = (xi.log.size ? xi.log.size :
>  			geo.logblocks * (geo.blocksize / BBSIZE) );
> -	drsize = xi.rtsize;
> +	drsize = xi.rt.size;
> 
>  	/*
>  	 * Ok, Linux only has a 1024-byte resolution on device _size_,
> @@ -328,7 +328,7 @@ _("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
>  		else if (xflag)
>  			in.isint = 0;
>  		else
> -			in.isint = xi.logBBsize == 0;
> +			in.isint = xi.log.size == 0;
>  		if (lsize == geo.logblocks && (in.isint == isint)) {
>  			if (lflag)
>  				fprintf(stderr,
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 058217c2a..eb3f9ac22 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -89,38 +89,31 @@ struct iomap;
> 
>  #define xfs_isset(a,i)	((a)[(i)/(sizeof(*(a))*NBBY)] & (1ULL<<((i)%(sizeof(*(a))*NBBY))))
> 
> +struct libxfs_dev {
> +	/* input parameters */
> +	char		*name;	/* pathname of the device */
> +	bool		isfile;	/* is the device a file? */
> +	bool		create;	/* create file if it doesn't exist */
> +
> +	/* output parameters */
> +	dev_t		dev;	/* device name for the device */
> +	long long       size;	/* size of subvolume (BBs) */
> +	int		bsize;	/* device blksize */
> +	int		fd;	/* file descriptor */
> +};
> +
>  /*
>   * Argument structure for libxfs_init().
>   */
>  struct libxfs_init {
> -				/* input parameters */
> -	char            *dname;         /* pathname of data "subvolume" */
> -	char            *logname;       /* pathname of log "subvolume" */
> -	char            *rtname;        /* pathname of realtime "subvolume" */
> +	struct libxfs_dev	data;
> +	struct libxfs_dev	log;
> +	struct libxfs_dev	rt;
> +
> +	/* input parameters */
>  	unsigned	flags;		/* LIBXFS_* flags below */
> -	int             disfile;        /* data "subvolume" is a regular file */
> -	int             dcreat;         /* try to create data subvolume */
> -	int             lisfile;        /* log "subvolume" is a regular file */
> -	int             lcreat;         /* try to create log subvolume */
> -	int             risfile;        /* realtime "subvolume" is a reg file */
> -	int             rcreat;         /* try to create realtime subvolume */
> -	int		setblksize;	/* attempt to set device blksize */
> -				/* output results */
> -	dev_t           ddev;           /* device for data subvolume */
> -	dev_t           logdev;         /* device for log subvolume */
> -	dev_t           rtdev;          /* device for realtime subvolume */
> -	long long       dsize;          /* size of data subvolume (BBs) */
> -	long long       logBBsize;      /* size of log subvolume (BBs) */
> -					/* (blocks allocated for use as
> -					 * log is stored in mount structure) */
> -	long long       rtsize;         /* size of realtime subvolume (BBs) */
> -	int		dbsize;		/* data subvolume device blksize */
> -	int		lbsize;		/* log subvolume device blksize */
> -	int		rtbsize;	/* realtime subvolume device blksize */
> -	int             dfd;            /* data subvolume file descriptor */
> -	int             logfd;          /* log subvolume file descriptor */
> -	int             rtfd;           /* realtime subvolume file descriptor */
>  	int		bcache_flags;	/* cache init flags */
> +	int		setblksize;	/* value to set device blksizes to */
>  };
> 
>  /* disallow all mounted filesystems: */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 320e4d63f..63c506a69 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -62,93 +62,117 @@ check_isactive(char *name, char *block, int fatal)
>  	return 0;
>  }
> 
> -/* libxfs_device_open:
> - *     open a device and return its device number
> - */
> -static dev_t
> -libxfs_device_open(char *path, int creat, int xflags, int setblksize, int *fdp)
> +static int
> +check_open(
> +	struct libxfs_init	*xi,
> +	struct libxfs_dev	*dev)
>  {
> -	int		fd, flags;
> -	int		readonly, dio, excl;
> -	struct stat	statb;
> +	struct stat	stbuf;
> 
> -	readonly = (xflags & LIBXFS_ISREADONLY);
> -	excl = (xflags & LIBXFS_EXCLUSIVELY) && !creat;
> -	dio = (xflags & LIBXFS_DIRECT) && !creat && platform_direct_blockdev();
> +	if (stat(dev->name, &stbuf) < 0) {
> +		perror(dev->name);
> +		return 0;
> +	}
> +	if (!(xi->flags & LIBXFS_ISREADONLY) &&
> +	    !(xi->flags & LIBXFS_ISINACTIVE) &&
> +	    platform_check_ismounted(dev->name, dev->name, NULL, 1))
> +		return 0;
> 
> -retry:
> -	flags = (readonly ? O_RDONLY : O_RDWR) | \
> -		(creat ? (O_CREAT|O_TRUNC) : 0) | \
> -		(dio ? O_DIRECT : 0) | \
> -		(excl ? O_EXCL : 0);
> +	if ((xi->flags & LIBXFS_ISINACTIVE) &&
> +	    check_isactive(dev->name, dev->name, !!(xi->flags &
> +			(LIBXFS_ISREADONLY | LIBXFS_DANGEROUSLY))))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static bool
> +libxfs_device_open(
> +	struct libxfs_init	*xi,
> +	struct libxfs_dev	*dev)
> +{
> +	struct stat		statb;
> +	int			flags;
> +
> +	dev->fd = -1;
> +
> +	if (!dev->name)
> +		return true;
> +	if (!dev->isfile && !check_open(xi, dev))
> +		return false;
> +
> +	if (xi->flags & LIBXFS_ISREADONLY)
> +		flags = O_RDONLY;
> +	else
> +		flags = O_RDWR;
> 
> -	if ((fd = open(path, flags, 0666)) < 0) {
> -		if (errno == EINVAL && --dio == 0)
> +	if (dev->create) {
> +		flags |= O_CREAT | O_TRUNC;
> +	} else {
> +		if (xi->flags & LIBXFS_EXCLUSIVELY)
> +			flags |= O_EXCL;
> +		if ((xi->flags & LIBXFS_DIRECT) && platform_direct_blockdev())
> +			flags |= O_DIRECT;
> +	}
> +
> +retry:
> +	dev->fd = open(dev->name, flags, 0666);
> +	if (dev->fd < 0) {
> +		if (errno == EINVAL && (flags & O_DIRECT)) {
> +			flags &= ~O_DIRECT;
>  			goto retry;
> +		}
>  		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> -			progname, path, strerror(errno));
> +			progname, dev->name, strerror(errno));
>  		exit(1);
>  	}
> 
> -	if (fstat(fd, &statb) < 0) {
> +	if (fstat(dev->fd, &statb) < 0) {
>  		fprintf(stderr, _("%s: cannot stat %s: %s\n"),
> -			progname, path, strerror(errno));
> +			progname, dev->name, strerror(errno));
>  		exit(1);
>  	}
> 
> -	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
> +	if (!(xi->flags & LIBXFS_ISREADONLY) &&
> +	    xi->setblksize &&
> +	    (statb.st_mode & S_IFMT) == S_IFBLK) {
>  		/*
>  		 * Try to use the given explicit blocksize.  Failure to set the
>  		 * block size is only fatal for direct I/O.
>  		 */
> -		platform_set_blocksize(fd, path, statb.st_rdev, setblksize,
> -				dio);
> +		platform_set_blocksize(dev->fd, dev->name, statb.st_rdev,
> +				xi->setblksize, flags & O_DIRECT);
>  	}
> 
>  	/*
>  	 * Get the device number from the stat buf - unless we're not opening a
>  	 * real device, in which case choose a new fake device number.
>  	 */
> -	*fdp = fd;
>  	if (statb.st_rdev)
> -		return statb.st_rdev;
> -	return nextfakedev--;
> +		dev->dev = statb.st_rdev;
> +	else
> +		dev->dev = nextfakedev--;
> +	platform_findsizes(dev->name, dev->fd, &dev->size, &dev->bsize);
> +	return true;
>  }
> 
>  static void
> -libxfs_device_close(int fd, dev_t dev)
> +libxfs_device_close(
> +	struct libxfs_dev	*dev)
>  {
> -	int	ret;
> +	int			ret;
> 
> -	ret = platform_flush_device(fd, dev);
> +	ret = platform_flush_device(dev->fd, dev->dev);
>  	if (ret) {
>  		ret = -errno;
>  		fprintf(stderr,
>  	_("%s: flush of device %lld failed, err=%d"),
>  			progname, (long long)dev, ret);
>  	}
> -	close(fd);
> -}
> +	close(dev->fd);
> 
> -static int
> -check_open(char *path, int flags)
> -{
> -	int readonly = (flags & LIBXFS_ISREADONLY);
> -	int inactive = (flags & LIBXFS_ISINACTIVE);
> -	int dangerously = (flags & LIBXFS_DANGEROUSLY);
> -	struct stat	stbuf;
> -
> -	if (stat(path, &stbuf) < 0) {
> -		perror(path);
> -		return 0;
> -	}
> -	if (!readonly && !inactive && platform_check_ismounted(path, path, NULL, 1))
> -		return 0;
> -
> -	if (inactive && check_isactive(path, path, ((readonly|dangerously)?1:0)))
> -		return 0;
> -
> -	return 1;
> +	dev->fd = -1;
> +	dev->dev = 0;
>  }
> 
>  /*
> @@ -209,15 +233,12 @@ static void
>  libxfs_close_devices(
>  	struct libxfs_init	*li)
>  {
> -	if (li->ddev)
> -		libxfs_device_close(li->dfd, li->ddev);
> -	if (li->logdev && li->logdev != li->ddev)
> -		libxfs_device_close(li->logfd, li->logdev);
> -	if (li->rtdev)
> -		libxfs_device_close(li->rtfd, li->rtdev);
> -
> -	li->ddev = li->logdev = li->rtdev = 0;
> -	li->dfd = li->logfd = li->rtfd = -1;
> +	if (li->data.dev)
> +		libxfs_device_close(&li->data);
> +	if (li->log.dev && li->log.dev != li->data.dev)
> +		libxfs_device_close(&li->log);
> +	if (li->rt.dev)
> +		libxfs_device_close(&li->rt);
>  }
> 
>  /*
> @@ -227,44 +248,16 @@ libxfs_close_devices(
>  int
>  libxfs_init(struct libxfs_init *a)
>  {
> -	char		*dname;
> -	char		*logname;
> -	char		*rtname;
> -
> -	dname = a->dname;
> -	logname = a->logname;
> -	rtname = a->rtname;
> -	a->dfd = a->logfd = a->rtfd = -1;
> -	a->ddev = a->logdev = a->rtdev = 0;
> -	a->dsize = a->lbsize = a->rtbsize = 0;
> -	a->dbsize = a->logBBsize = a->rtsize = 0;
> -
>  	rcu_init();
>  	rcu_register_thread();
>  	radix_tree_init();
> 
> -	if (dname) {
> -		if (!a->disfile && !check_open(dname, a->flags))
> -			goto done;
> -		a->ddev = libxfs_device_open(dname, a->dcreat, a->flags,
> -				a->setblksize, &a->dfd);
> -		platform_findsizes(dname, a->dfd, &a->dsize, &a->dbsize);
> -	}
> -	if (logname) {
> -		if (!a->lisfile && !check_open(logname, a->flags))
> -			goto done;
> -		a->logdev = libxfs_device_open(logname, a->lcreat, a->flags,
> -				a->setblksize, &a->logfd);
> -		platform_findsizes(logname, a->logfd, &a->logBBsize,
> -				&a->lbsize);
> -	}
> -	if (rtname) {
> -		if (a->risfile && !check_open(rtname, a->flags))
> -			goto done;
> -		a->rtdev = libxfs_device_open(rtname, a->rcreat, a->flags,
> -				a->setblksize, &a->rtfd);
> -		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
> -	}
> +	if (!libxfs_device_open(a, &a->data))
> +		goto done;
> +	if (!libxfs_device_open(a, &a->log))
> +		goto done;
> +	if (!libxfs_device_open(a, &a->rt))
> +		goto done;
> 
>  	if (!libxfs_bhash_size)
>  		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
> @@ -452,8 +445,7 @@ xfs_set_inode_alloc(
>  static struct xfs_buftarg *
>  libxfs_buftarg_alloc(
>  	struct xfs_mount	*mp,
> -	dev_t			dev,
> -	int			fd,
> +	struct libxfs_dev	*dev,
>  	unsigned long		write_fails)
>  {
>  	struct xfs_buftarg	*btp;
> @@ -465,8 +457,8 @@ libxfs_buftarg_alloc(
>  		exit(1);
>  	}
>  	btp->bt_mount = mp;
> -	btp->bt_bdev = dev;
> -	btp->bt_bdev_fd = fd;
> +	btp->bt_bdev = dev->dev;
> +	btp->bt_bdev_fd = dev->fd;
>  	btp->flags = 0;
>  	if (write_fails) {
>  		btp->writes_left = write_fails;
> @@ -538,29 +530,29 @@ libxfs_buftarg_init(
> 
>  	if (mp->m_ddev_targp) {
>  		/* should already have all buftargs initialised */
> -		if (mp->m_ddev_targp->bt_bdev != xi->ddev ||
> +		if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
>  		    mp->m_ddev_targp->bt_mount != mp) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, ddev\n"),
>  				progname);
>  			exit(1);
>  		}
> -		if (!xi->logdev || xi->logdev == xi->ddev) {
> +		if (!xi->log.dev || xi->log.dev == xi->data.dev) {
>  			if (mp->m_logdev_targp != mp->m_ddev_targp) {
>  				fprintf(stderr,
>  				_("%s: bad buftarg reinit, ldev mismatch\n"),
>  					progname);
>  				exit(1);
>  			}
> -		} else if (mp->m_logdev_targp->bt_bdev != xi->logdev ||
> +		} else if (mp->m_logdev_targp->bt_bdev != xi->log.dev ||
>  			   mp->m_logdev_targp->bt_mount != mp) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, logdev\n"),
>  				progname);
>  			exit(1);
>  		}
> -		if (xi->rtdev &&
> -		    (mp->m_rtdev_targp->bt_bdev != xi->rtdev ||
> +		if (xi->rt.dev &&
> +		    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
>  		     mp->m_rtdev_targp->bt_mount != mp)) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, rtdev\n"),
> @@ -570,14 +562,12 @@ libxfs_buftarg_init(
>  		return;
>  	}
> 
> -	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi->ddev, xi->dfd, dfail);
> -	if (!xi->logdev || xi->logdev == xi->ddev)
> +	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, &xi->data, dfail);
> +	if (!xi->log.dev || xi->log.dev == xi->data.dev)
>  		mp->m_logdev_targp = mp->m_ddev_targp;
>  	else
> -		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi->logdev,
> -				xi->logfd, lfail);
> -	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi->rtdev, xi->rtfd,
> -			rfail);
> +		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, &xi->log, lfail);
> +	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, &xi->rt, rfail);
>  }
> 
>  /* Compute maximum possible height for per-AG btree types for this fs. */
> @@ -711,7 +701,7 @@ libxfs_mount(
>  	/* Initialize the precomputed transaction reservations values */
>  	xfs_trans_init(mp);
> 
> -	if (xi->ddev == 0)	/* maxtrres, we have no device so leave now */
> +	if (xi->data.dev == 0)	/* maxtrres, we have no device so leave now */
>  		return mp;
> 
>  	/* device size checks must pass unless we're a debugger. */
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index d6791c0f6..06013d429 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -299,34 +299,34 @@ get_topology(
>  	 * to try to obtain the underlying filesystem's requirements
>  	 * for direct IO; we'll set our sector size to that if possible.
>  	 */
> -	if (xi->disfile ||
> -	    (!stat(xi->dname, &statbuf) && S_ISREG(statbuf.st_mode))) {
> +	if (xi->data.isfile ||
> +	    (!stat(xi->data.name, &statbuf) && S_ISREG(statbuf.st_mode))) {
>  		int fd;
>  		int flags = O_RDONLY;
>  		long long dummy;
> 
>  		/* with xi->disfile we may not have the file yet! */
> -		if (xi->disfile)
> +		if (xi->data.isfile)
>  			flags |= O_CREAT;
> 
> -		fd = open(xi->dname, flags, 0666);
> +		fd = open(xi->data.name, flags, 0666);
>  		if (fd >= 0) {
> -			platform_findsizes(xi->dname, fd, &dummy,
> +			platform_findsizes(xi->data.name, fd, &dummy,
>  					&ft->lsectorsize);
>  			close(fd);
>  			ft->psectorsize = ft->lsectorsize;
>  		} else
>  			ft->psectorsize = ft->lsectorsize = BBSIZE;
>  	} else {
> -		blkid_get_topology(xi->dname, &ft->dsunit, &ft->dswidth,
> +		blkid_get_topology(xi->data.name, &ft->dsunit, &ft->dswidth,
>  				   &ft->lsectorsize, &ft->psectorsize,
>  				   force_overwrite);
>  	}
> 
> -	if (xi->rtname && !xi->risfile) {
> +	if (xi->rt.name && !xi->rt.isfile) {
>  		int sunit, lsectorsize, psectorsize;
> 
> -		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
> +		blkid_get_topology(xi->rt.name, &sunit, &ft->rtswidth,
>  				   &lsectorsize, &psectorsize, force_overwrite);
>  	}
>  }
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index 5349e7838..7c69cdcc7 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -64,9 +64,9 @@ logstat(
>  	 * filesystem. We need this to get the length of the
>  	 * log. Otherwise we end up seeking forever. -- mkp
>  	 */
> -	if ((fd = open(x.dname, O_RDONLY)) == -1) {
> +	if ((fd = open(x.data.name, O_RDONLY)) == -1) {
>  		fprintf(stderr, _("    Can't open device %s: %s\n"),
> -			x.dname, strerror(errno));
> +			x.data.name, strerror(errno));
>  		exit(1);
>  	}
>  	lseek(fd, 0, SEEK_SET);
> @@ -76,7 +76,7 @@ logstat(
>  	}
>  	close (fd);
> 
> -	if (!x.disfile) {
> +	if (!x.data.isfile) {
>  		struct xfs_sb	*sb = &mp->m_sb;
> 
>  		/*
> @@ -88,7 +88,7 @@ logstat(
> 
>  		xlog_init(mp, log);
> 
> -		if (!x.logname && sb->sb_logstart == 0) {
> +		if (!x.log.name && sb->sb_logstart == 0) {
>  			fprintf(stderr, _("    external log device not specified\n\n"));
>  			usage();
>  			/*NOTREACHED*/
> @@ -96,7 +96,7 @@ logstat(
>  	} else {
>  		struct stat	s;
> 
> -		stat(x.dname, &s);
> +		stat(x.data.name, &s);
> 
>  		log->l_logBBsize = s.st_size >> 9;
>  		log->l_logBBstart = 0;
> @@ -105,15 +105,15 @@ logstat(
>  		log->l_mp = mp;
>  	}
> 
> -	if (x.logname && *x.logname) {    /* External log */
> -		if ((fd = open(x.logname, O_RDONLY)) == -1) {
> +	if (x.log.name && *x.log.name) {    /* External log */
> +		if ((fd = open(x.log.name, O_RDONLY)) == -1) {
>  			fprintf(stderr, _("Can't open file %s: %s\n"),
> -				x.logname, strerror(errno));
> +				x.log.name, strerror(errno));
>  			exit(1);
>  		}
>  		close(fd);
>  	} else {                            /* Internal log */
> -		x.logdev = x.ddev;
> +		x.log.dev = x.data.dev;
>  	}
> 
>  	return 0;
> @@ -165,11 +165,11 @@ main(int argc, char **argv)
>  				break;
>  			case 'f':
>  				print_skip_uuid++;
> -				x.disfile = 1;
> +				x.data.isfile = 1;
>  				break;
>  			case 'l':
> -				x.logname = optarg;
> -				x.lisfile = 1;
> +				x.log.name = optarg;
> +				x.log.isfile = 1;
>  				break;
>  			case 'i':
>  				print_inode++;
> @@ -203,9 +203,9 @@ main(int argc, char **argv)
>  	if (argc - optind != 1)
>  		usage();
> 
> -	x.dname = argv[optind];
> +	x.data.name = argv[optind];
> 
> -	if (x.dname == NULL)
> +	if (x.data.name == NULL)
>  		usage();
> 
>  	x.flags = LIBXFS_ISINACTIVE;
> @@ -216,20 +216,20 @@ main(int argc, char **argv)
>  	libxfs_buftarg_init(&mount, &x);
>  	logstat(&mount, &log);
> 
> -	logfd = (x.logfd < 0) ? x.dfd : x.logfd;
> +	logfd = (x.log.fd < 0) ? x.data.fd : x.log.fd;
> 
> -	printf(_("    data device: 0x%llx\n"), (unsigned long long)x.ddev);
> +	printf(_("    data device: 0x%llx\n"), (unsigned long long)x.data.dev);
> 
> -	if (x.logname) {
> -		printf(_("    log file: \"%s\" "), x.logname);
> +	if (x.log.name) {
> +		printf(_("    log file: \"%s\" "), x.log.name);
>  	} else {
> -		printf(_("    log device: 0x%llx "), (unsigned long long)x.logdev);
> +		printf(_("    log device: 0x%llx "), (unsigned long long)x.log.dev);
>  	}
> 
>  	printf(_("daddr: %lld length: %lld\n\n"),
>  		(long long)log.l_logBBstart, (long long)log.l_logBBsize);
> 
> -	ASSERT(log.l_logBBsize <= INT_MAX);
> +	ASSERT(x.log.size <= INT_MAX);
> 
>  	switch (print_operation) {
>  	case OP_PRINT:
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 01c6ce33b..fcbf54132 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1092,37 +1092,35 @@ invalid_cfgfile_opt(
> 
>  static void
>  check_device_type(
> -	const char	*name,
> -	int		*isfile,
> -	bool		no_size,
> -	bool		no_name,
> -	int		*create,
> -	const char	*optname)
> +	struct libxfs_dev	*dev,
> +	bool			no_size,
> +	bool			dry_run,
> +	const char		*optname)
>  {
>  	struct stat statbuf;
> 
> -	if (*isfile && (no_size || no_name)) {
> +	if (dev->isfile && (no_size || !dev->name)) {
>  		fprintf(stderr,
>  	_("if -%s file then -%s name and -%s size are required\n"),
>  			optname, optname, optname);
>  		usage();
>  	}
> 
> -	if (!name) {
> +	if (!dev->name) {
>  		fprintf(stderr, _("No device name specified\n"));
>  		usage();
>  	}
> 
> -	if (stat(name, &statbuf)) {
> -		if (errno == ENOENT && *isfile) {
> -			if (create)
> -				*create = 1;
> +	if (stat(dev->name, &statbuf)) {
> +		if (errno == ENOENT && dev->isfile) {
> +			if (!dry_run)
> +				dev->create = 1;
>  			return;
>  		}
> 
>  		fprintf(stderr,
>  	_("Error accessing specified device %s: %s\n"),
> -				name, strerror(errno));
> +				dev->name, strerror(errno));
>  		usage();
>  		return;
>  	}
> @@ -1133,18 +1131,18 @@ check_device_type(
>  	 * this case to trigger that behaviour.
>  	 */
>  	if (S_ISREG(statbuf.st_mode)) {
> -		if (!*isfile)
> -			*isfile = 1;
> -		else if (create)
> -			*create = 1;
> +		if (!dev->isfile)
> +			dev->isfile = 1;
> +		else if (!dry_run)
> +			dev->create = 1;
>  		return;
>  	}
> 
>  	if (S_ISBLK(statbuf.st_mode)) {
> -		if (*isfile) {
> +		if (dev->isfile) {
>  			fprintf(stderr,
>  	_("specified \"-%s file\" on a block device %s\n"),
> -				optname, name);
> +				optname, dev->name);
>  			usage();
>  		}
>  		return;
> @@ -1152,7 +1150,7 @@ check_device_type(
> 
>  	fprintf(stderr,
>  	_("specified device %s not a file or block device\n"),
> -		name);
> +		dev->name);
>  	usage();
>  }
> 
> @@ -1258,7 +1256,7 @@ zero_old_xfs_structures(
>  	/*
>  	 * We open regular files with O_TRUNC|O_CREAT. Nothing to do here...
>  	 */
> -	if (xi->disfile && xi->dcreat)
> +	if (xi->data.isfile && xi->data.create)
>  		return;
> 
>  	/*
> @@ -1279,9 +1277,9 @@ zero_old_xfs_structures(
>  	 * return zero bytes. It's not a failure we need to warn about in this
>  	 * case.
>  	 */
> -	off = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
> +	off = pread(xi->data.fd, buf, new_sb->sb_sectsize, 0);
>  	if (off != new_sb->sb_sectsize) {
> -		if (!xi->disfile)
> +		if (!xi->data.isfile)
>  			fprintf(stderr,
>  	_("error reading existing superblock: %s\n"),
>  				strerror(errno));
> @@ -1316,7 +1314,7 @@ zero_old_xfs_structures(
>  	off = 0;
>  	for (i = 1; i < sb.sb_agcount; i++)  {
>  		off += sb.sb_agblocks;
> -		if (pwrite(xi->dfd, buf, new_sb->sb_sectsize,
> +		if (pwrite(xi->data.fd, buf, new_sb->sb_sectsize,
>  					off << sb.sb_blocklog) == -1)
>  			break;
>  	}
> @@ -1561,10 +1559,10 @@ data_opts_parser(
>  		cli->agsize = getstr(value, opts, subopt);
>  		break;
>  	case D_FILE:
> -		cli->xi->disfile = getnum(value, opts, subopt);
> +		cli->xi->data.isfile = getnum(value, opts, subopt);
>  		break;
>  	case D_NAME:
> -		cli->xi->dname = getstr(value, opts, subopt);
> +		cli->xi->data.name = getstr(value, opts, subopt);
>  		break;
>  	case D_SIZE:
>  		cli->dsize = getstr(value, opts, subopt);
> @@ -1673,7 +1671,7 @@ log_opts_parser(
>  		cli->logagno = getnum(value, opts, subopt);
>  		break;
>  	case L_FILE:
> -		cli->xi->lisfile = getnum(value, opts, subopt);
> +		cli->xi->log.isfile = getnum(value, opts, subopt);
>  		break;
>  	case L_INTERNAL:
>  		cli->loginternal = getnum(value, opts, subopt);
> @@ -1686,7 +1684,7 @@ log_opts_parser(
>  		break;
>  	case L_NAME:
>  	case L_DEV:
> -		cli->xi->logname = getstr(value, opts, subopt);
> +		cli->xi->log.name = getstr(value, opts, subopt);
>  		cli->loginternal = 0;
>  		break;
>  	case L_VERSION:
> @@ -1819,11 +1817,11 @@ rtdev_opts_parser(
>  		cli->rtextsize = getstr(value, opts, subopt);
>  		break;
>  	case R_FILE:
> -		cli->xi->risfile = getnum(value, opts, subopt);
> +		cli->xi->rt.isfile = getnum(value, opts, subopt);
>  		break;
>  	case R_NAME:
>  	case R_DEV:
> -		cli->xi->rtname = getstr(value, opts, subopt);
> +		cli->xi->rt.name = getstr(value, opts, subopt);
>  		break;
>  	case R_SIZE:
>  		cli->rtsize = getstr(value, opts, subopt);
> @@ -1962,24 +1960,18 @@ validate_sectorsize(
>  	 * Before anything else, verify that we are correctly operating on
>  	 * files or block devices and set the control parameters correctly.
>  	 */
> -	check_device_type(cli->xi->dname, &cli->xi->disfile,
> -			  !cli->dsize, !cli->xi->dname,
> -			  dry_run ? NULL : &cli->xi->dcreat, "d");
> +	check_device_type(&cli->xi->data, !cli->dsize, dry_run, "d");
>  	if (!cli->loginternal)
> -		check_device_type(cli->xi->logname, &cli->xi->lisfile,
> -				  !cli->logsize, !cli->xi->logname,
> -				  dry_run ? NULL : &cli->xi->lcreat, "l");
> -	if (cli->xi->rtname)
> -		check_device_type(cli->xi->rtname, &cli->xi->risfile,
> -				  !cli->rtsize, !cli->xi->rtname,
> -				  dry_run ? NULL : &cli->xi->rcreat, "r");
> +		check_device_type(&cli->xi->log, !cli->logsize, dry_run, "l");
> +	if (cli->xi->rt.name)
> +		check_device_type(&cli->xi->rt, !cli->rtsize, dry_run, "r");
> 
>  	/*
>  	 * Explicitly disable direct IO for image files so we don't error out on
>  	 * sector size mismatches between the new filesystem and the underlying
>  	 * host filesystem.
>  	 */
> -	if (cli->xi->disfile || cli->xi->lisfile || cli->xi->risfile)
> +	if (cli->xi->data.isfile || cli->xi->log.isfile || cli->xi->rt.isfile)
>  		cli->xi->flags &= ~LIBXFS_DIRECT;
> 
>  	memset(ft, 0, sizeof(*ft));
> @@ -2294,7 +2286,7 @@ _("inode btree counters not supported without finobt support\n"));
>  		cli->sb_feat.inobtcnt = false;
>  	}
> 
> -	if (cli->xi->rtname) {
> +	if (cli->xi->rt.name) {
>  		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
>  			fprintf(stderr,
>  _("reflink not supported with realtime devices\n"));
> @@ -2461,8 +2453,8 @@ validate_rtextsize(
>  		 */
>  		uint64_t	rswidth;
> 
> -		if (!cfg->sb_feat.nortalign && !cli->xi->risfile &&
> -		    !(!cli->rtsize && cli->xi->disfile))
> +		if (!cfg->sb_feat.nortalign && !cli->xi->rt.isfile &&
> +		    !(!cli->rtsize && cli->xi->data.isfile))
>  			rswidth = ft->rtswidth;
>  		else
>  			rswidth = 0;
> @@ -2840,7 +2832,7 @@ open_devices(
>  	xi->setblksize = cfg->sectorsize;
>  	if (!libxfs_init(xi))
>  		usage();
> -	if (!xi->ddev) {
> +	if (!xi->data.dev) {
>  		fprintf(stderr, _("no device name given in argument list\n"));
>  		usage();
>  	}
> @@ -2856,9 +2848,9 @@ open_devices(
>  	 * multiple of the sector size, or 1024, whichever is larger.
>  	 */
>  	sector_mask = (uint64_t)-1 << (max(cfg->sectorlog, 10) - BBSHIFT);
> -	xi->dsize &= sector_mask;
> -	xi->rtsize &= sector_mask;
> -	xi->logBBsize &= (uint64_t)-1 << (max(cfg->lsectorlog, 10) - BBSHIFT);
> +	xi->data.size &= sector_mask;
> +	xi->rt.size &= sector_mask;
> +	xi->log.size &= (uint64_t)-1 << (max(cfg->lsectorlog, 10) - BBSHIFT);
>  }
> 
>  static void
> @@ -2870,12 +2862,12 @@ discard_devices(
>  	 * This function has to be called after libxfs has been initialized.
>  	 */
> 
> -	if (!xi->disfile)
> -		discard_blocks(xi->dfd, xi->dsize, quiet);
> -	if (xi->rtdev && !xi->risfile)
> -		discard_blocks(xi->rtfd, xi->rtsize, quiet);
> -	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
> -		discard_blocks(xi->logfd, xi->logBBsize, quiet);
> +	if (!xi->data.isfile)
> +		discard_blocks(xi->data.fd, xi->data.size, quiet);
> +	if (xi->rt.dev && !xi->rt.isfile)
> +		discard_blocks(xi->rt.fd, xi->rt.size, quiet);
> +	if (xi->log.dev && xi->log.dev != xi->data.dev && !xi->log.isfile)
> +		discard_blocks(xi->log.fd, xi->log.size, quiet);
>  }
> 
>  static void
> @@ -2885,29 +2877,29 @@ validate_datadev(
>  {
>  	struct libxfs_init	*xi = cli->xi;
> 
> -	if (!xi->dsize) {
> +	if (!xi->data.size) {
>  		/*
>  		 * if the device is a file, we can't validate the size here.
>  		 * Instead, the file will be truncated to the correct length
>  		 * later on. if it's not a file, we've got a dud device.
>  		 */
> -		if (!xi->disfile) {
> +		if (!xi->data.isfile) {
>  			fprintf(stderr, _("can't get size of data subvolume\n"));
>  			usage();
>  		}
>  		ASSERT(cfg->dblocks);
>  	} else if (cfg->dblocks) {
>  		/* check the size fits into the underlying device */
> -		if (cfg->dblocks > DTOBT(xi->dsize, cfg->blocklog)) {
> +		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
>  			fprintf(stderr,
>  _("size %s specified for data subvolume is too large, maximum is %lld blocks\n"),
>  				cli->dsize,
> -				(long long)DTOBT(xi->dsize, cfg->blocklog));
> +				(long long)DTOBT(xi->data.size, cfg->blocklog));
>  			usage();
>  		}
>  	} else {
>  		/* no user size, so use the full block device */
> -		cfg->dblocks = DTOBT(xi->dsize, cfg->blocklog);
> +		cfg->dblocks = DTOBT(xi->data.size, cfg->blocklog);
>  	}
> 
>  	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS(cfg)) {
> @@ -2917,11 +2909,11 @@ _("size %lld of data subvolume is too small, minimum %lld blocks\n"),
>  		usage();
>  	}
> 
> -	if (xi->dbsize > cfg->sectorsize) {
> +	if (xi->data.bsize > cfg->sectorsize) {
>  		fprintf(stderr, _(
>  "Warning: the data subvolume sector size %u is less than the sector size \n\
>  reported by the device (%u).\n"),
> -			cfg->sectorsize, xi->dbsize);
> +			cfg->sectorsize, xi->data.bsize);
>  	}
>  }
> 
> @@ -2961,31 +2953,31 @@ _("log size %lld too large for internal log\n"),
>  	}
> 
>  	/* External/log subvolume checks */
> -	if (!*xi->logname || !xi->logdev) {
> +	if (!*xi->log.name || !xi->log.dev) {
>  		fprintf(stderr, _("no log subvolume or external log.\n"));
>  		usage();
>  	}
> 
>  	if (!cfg->logblocks) {
> -		if (xi->logBBsize == 0) {
> +		if (xi->log.size == 0) {
>  			fprintf(stderr,
>  _("unable to get size of the log subvolume.\n"));
>  			usage();
>  		}
> -		cfg->logblocks = DTOBT(xi->logBBsize, cfg->blocklog);
> -	} else if (cfg->logblocks > DTOBT(xi->logBBsize, cfg->blocklog)) {
> +		cfg->logblocks = DTOBT(xi->log.size, cfg->blocklog);
> +	} else if (cfg->logblocks > DTOBT(xi->log.size, cfg->blocklog)) {
>  		fprintf(stderr,
>  _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  			cli->logsize,
> -			(long long)DTOBT(xi->logBBsize, cfg->blocklog));
> +			(long long)DTOBT(xi->log.size, cfg->blocklog));
>  		usage();
>  	}
> 
> -	if (xi->lbsize > cfg->lsectorsize) {
> +	if (xi->log.bsize > cfg->lsectorsize) {
>  		fprintf(stderr, _(
>  "Warning: the log subvolume sector size %u is less than the sector size\n\
>  reported by the device (%u).\n"),
> -			cfg->lsectorsize, xi->lbsize);
> +			cfg->lsectorsize, xi->log.bsize);
>  	}
>  }
> 
> @@ -2996,7 +2988,7 @@ validate_rtdev(
>  {
>  	struct libxfs_init	*xi = cli->xi;
> 
> -	if (!xi->rtdev) {
> +	if (!xi->rt.dev) {
>  		if (cli->rtsize) {
>  			fprintf(stderr,
>  _("size specified for non-existent rt subvolume\n"));
> @@ -3008,28 +3000,28 @@ _("size specified for non-existent rt subvolume\n"));
>  		cfg->rtbmblocks = 0;
>  		return;
>  	}
> -	if (!xi->rtsize) {
> +	if (!xi->rt.size) {
>  		fprintf(stderr, _("Invalid zero length rt subvolume found\n"));
>  		usage();
>  	}
> 
>  	if (cli->rtsize) {
> -		if (cfg->rtblocks > DTOBT(xi->rtsize, cfg->blocklog)) {
> +		if (cfg->rtblocks > DTOBT(xi->rt.size, cfg->blocklog)) {
>  			fprintf(stderr,
>  _("size %s specified for rt subvolume is too large, maxi->um is %lld blocks\n"),
>  				cli->rtsize,
> -				(long long)DTOBT(xi->rtsize, cfg->blocklog));
> +				(long long)DTOBT(xi->rt.size, cfg->blocklog));
>  			usage();
>  		}
> -		if (xi->rtbsize > cfg->sectorsize) {
> +		if (xi->rt.bsize > cfg->sectorsize) {
>  			fprintf(stderr, _(
>  "Warning: the realtime subvolume sector size %u is less than the sector size\n\
>  reported by the device (%u).\n"),
> -				cfg->sectorsize, xi->rtbsize);
> +				cfg->sectorsize, xi->rt.bsize);
>  		}
>  	} else {
>  		/* grab volume size */
> -		cfg->rtblocks = DTOBT(xi->rtsize, cfg->blocklog);
> +		cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
>  	}
> 
>  	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
> @@ -3770,9 +3762,9 @@ prepare_devices(
>  	 * needed so that the reads for the end of the device in the mount code
>  	 * will succeed.
>  	 */
> -	if (xi->disfile &&
> -	    xi->dsize * xi->dbsize < cfg->dblocks * cfg->blocksize) {
> -		if (ftruncate(xi->dfd, cfg->dblocks * cfg->blocksize) < 0) {
> +	if (xi->data.isfile &&
> +	    xi->data.size * xi->data.bsize < cfg->dblocks * cfg->blocksize) {
> +		if (ftruncate(xi->data.fd, cfg->dblocks * cfg->blocksize) < 0) {
>  			fprintf(stderr,
>  				_("%s: Growing the data section failed\n"),
>  				progname);
> @@ -3780,7 +3772,7 @@ prepare_devices(
>  		}
> 
>  		/* update size to be able to whack blocks correctly */
> -		xi->dsize = BTOBB(cfg->dblocks * cfg->blocksize);
> +		xi->data.size = BTOBB(cfg->dblocks * cfg->blocksize);
>  	}
> 
>  	/*
> @@ -3788,7 +3780,7 @@ prepare_devices(
>  	 * the end of the device.  (MD sb is ~64k from the end, take out a wider
>  	 * swath to be sure)
>  	 */
> -	buf = alloc_write_buf(mp->m_ddev_targp, (xi->dsize - whack_blks),
> +	buf = alloc_write_buf(mp->m_ddev_targp, (xi->data.size - whack_blks),
>  			whack_blks);
>  	memset(buf->b_addr, 0, WHACK_SIZE);
>  	libxfs_buf_mark_dirty(buf);
> @@ -4183,7 +4175,7 @@ main(
>  		fprintf(stderr, _("extra arguments\n"));
>  		usage();
>  	} else if (argc - optind == 1) {
> -		xi.dname = getstr(argv[optind], &dopts, D_NAME);
> +		xi.data.name = getstr(argv[optind], &dopts, D_NAME);
>  	}
> 
>  	/*
> @@ -4236,7 +4228,7 @@ main(
>  	 * Open and validate the device configurations
>  	 */
>  	open_devices(&cfg, &xi);
> -	validate_overwrite(xi.dname, force_overwrite);
> +	validate_overwrite(xi.data.name, force_overwrite);
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli);
>  	validate_rtdev(&cfg, &cli);
> @@ -4280,7 +4272,7 @@ main(
>  		struct xfs_fsop_geom	geo;
> 
>  		libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
> -		xfs_report_geom(&geo, xi.dname, xi.logname, xi.rtname);
> +		xfs_report_geom(&geo, xi.data.name, xi.log.name, xi.rt.name);
>  		if (dry_run)
>  			exit(0);
>  	}
> diff --git a/repair/init.c b/repair/init.c
> index 2dc439a22..3788d00f2 100644
> --- a/repair/init.c
> +++ b/repair/init.c
> @@ -56,19 +56,19 @@ xfs_init(struct libxfs_init *args)
>  {
>  	memset(args, 0, sizeof(*args));
> 
> -	args->dname = fs_name;
> -	args->disfile = isa_file;
> +	args->data.name = fs_name;
> +	args->data.isfile = isa_file;
> 
>  	if (log_spec)  {	/* External log specified */
> -		args->logname = log_name;
> -		args->lisfile = (isa_file?1:0);
> +		args->log.name = log_name;
> +		args->log.isfile = isa_file;
>  		/* XXX assume data file also means log file */
>  		/* REVISIT: Need to do fs sanity / log validity checking */
>  	}
> 
>  	if (rt_spec)  {	/* RT device specified */
> -		args->rtname = rt_name;
> -		args->risfile = (isa_file?1:0);
> +		args->rt.name = rt_name;
> +		args->rt.isfile = isa_file;
>  		/* XXX assume data file also means rt file */
>  	}
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 48263e161..063748179 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -341,11 +341,11 @@ phase2(
> 
>  	/* Check whether this fs has internal or external log */
>  	if (mp->m_sb.sb_logstart == 0) {
> -		if (!x.logname)
> +		if (!x.log.name)
>  			do_error(_("This filesystem has an external log.  "
>  				   "Specify log device with the -l option.\n"));
> 
> -		do_log(_("Phase 2 - using external log on %s\n"), x.logname);
> +		do_log(_("Phase 2 - using external log on %s\n"), x.log.name);
>  	} else
>  		do_log(_("Phase 2 - using internal log\n"));
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index b823ba3a9..dedac53af 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -125,13 +125,11 @@ __find_secondary_sb(
>  		/*
>  		 * read disk 1 MByte at a time.
>  		 */
> -		if (lseek(x.dfd, off, SEEK_SET) != off)  {
> +		if (lseek(x.data.fd, off, SEEK_SET) != off)
>  			done = 1;
> -		}
> 
> -		if (!done && (bsize = read(x.dfd, sb, BSIZE)) <= 0)  {
> +		if (!done && (bsize = read(x.data.fd, sb, BSIZE)) <= 0)
>  			done = 1;
> -		}
> 
>  		do_warn(".");
> 
> @@ -192,7 +190,7 @@ guess_default_geometry(
>  	 */
>  	blocklog = 12;
>  	multidisk = ft.dswidth | ft.dsunit;
> -	dblocks = x->dsize >> (blocklog - BBSHIFT);
> +	dblocks = x->data.size >> (blocklog - BBSHIFT);
>  	calc_default_ag_geometry(blocklog, dblocks, multidisk,
>  				 agsize, agcount);
> 
> @@ -533,7 +531,7 @@ write_primary_sb(xfs_sb_t *sbp, int size)
>  	}
>  	memset(buf, 0, size);
> 
> -	if (lseek(x.dfd, 0LL, SEEK_SET) != 0LL) {
> +	if (lseek(x.data.fd, 0LL, SEEK_SET) != 0LL) {
>  		free(buf);
>  		do_error(_("couldn't seek to offset 0 in filesystem\n"));
>  	}
> @@ -543,7 +541,7 @@ write_primary_sb(xfs_sb_t *sbp, int size)
>  	if (xfs_sb_version_hascrc(sbp))
>  		xfs_update_cksum((char *)buf, size, XFS_SB_CRC_OFF);
> 
> -	if (write(x.dfd, buf, size) != size) {
> +	if (write(x.data.fd, buf, size) != size) {
>  		free(buf);
>  		do_error(_("primary superblock write failed!\n"));
>  	}
> @@ -572,7 +570,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
> 
>  	/* try and read it first */
> 
> -	if (lseek(x.dfd, off, SEEK_SET) != off)  {
> +	if (lseek(x.data.fd, off, SEEK_SET) != off)  {
>  		do_warn(
>  	_("error reading superblock %u -- seek to offset %" PRId64 " failed\n"),
>  			agno, off);
> @@ -580,7 +578,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
>  		return(XR_EOF);
>  	}
> 
> -	if ((rval = read(x.dfd, buf, size)) != size)  {
> +	if ((rval = read(x.data.fd, buf, size)) != size)  {
>  		error = errno;
>  		do_warn(
>  	_("superblock read failed, offset %" PRId64 ", size %d, ag %u, rval %d\n"),
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index cdbdbe855..ba9d28330 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -728,7 +728,7 @@ check_fs_vs_host_sectsize(
>  	long	old_flags;
>  	struct xfs_fsop_geom	geom = { 0 };
> 
> -	ret = -xfrog_geometry(x.dfd, &geom);
> +	ret = -xfrog_geometry(x.data.fd, &geom);
>  	if (ret) {
>  		do_log(_("Cannot get host filesystem geometry.\n"
>  	"Repair may fail if there is a sector size mismatch between\n"
> @@ -737,8 +737,8 @@ check_fs_vs_host_sectsize(
>  	}
> 
>  	if (sb->sb_sectsize < geom.sectsize) {
> -		old_flags = fcntl(x.dfd, F_GETFL, 0);
> -		if (fcntl(x.dfd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
> +		old_flags = fcntl(x.data.fd, F_GETFL, 0);
> +		if (fcntl(x.data.fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
>  			do_warn(_(
>  	"Sector size on host filesystem larger than image sector size.\n"
>  	"Cannot turn off direct IO, so exiting.\n"));
> @@ -986,7 +986,7 @@ main(int argc, char **argv)
>  	if (!isa_file) {
>  		struct stat	statbuf;
> 
> -		if (fstat(x.dfd, &statbuf) < 0)
> +		if (fstat(x.data.fd, &statbuf) < 0)
>  			do_warn(_("%s: couldn't stat \"%s\"\n"),
>  				progname, fs_name);
>  		else if (S_ISREG(statbuf.st_mode))
> --
> 2.39.2
> 
> 
