Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 14:06:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k96L67aG032492
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 14:06:09 -0700
Message-ID: <4526BE61.8020305@tulane.edu>
Date: Fri, 06 Oct 2006 15:36:49 -0500
From: Rene Salmon <rsalmon@tulane.edu>
MIME-Version: 1.0
Subject: Re: LVM and XFS cannot set blocksize on block device
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu> <20060926224053.GA31542@tuatara.stupidest.org> <451A669D.9020503@agami.com> <452212CB.60103@sgi.com>
In-Reply-To: <452212CB.60103@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Shailendra Tripathi <stripathi@agami.com>, Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

We are currently running SLES 10 on this box.  I have called IBM and 
they submitted a bug report to Novell and LTC Bugzilla 28003.

Is this all we need to do to get the patch into maybe SLES 10 SP1?

thanks

Rene



Timothy Shimmin wrote:
> Shailendra Tripathi wrote:
>>>> Thanks for the reply. The "-s size=4096" helped I was able to create
>>>> the file system, then mount it and use it.  I did however get a
>>>> warning still about "cannot set blocksize on block device".
>>
>>>
>>> I don't know much about the LVM code, my guess is that
>>> ioctl(... ,BLKBSZSET, ...) is failing, strace would confirm this.
>>
>>
>> libxfs_device_open () seems to be working with the pre-conceived 
>> notion of assuming block devices of only 512 bytes in size.
>>
>> if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK)
>>    platform_set_blocksize(fd, path, statb.st_rdev, 512);
>>
>> This eventually calls to set the blk sz to 512. Since, your volume 
>> does not support less than 4k, it returns EINVAL. I think, libxfs_init 
>> should be modified to take pass on the -s size option to this call so 
>> that it does not happen.
> 
> 
> I've attached a patch.
> Is this the sort of thing you were after?
> 
> --Tim
> 
> 
> ------------------------------------------------------------------------
> 
> Subject: Re: LVM and XFS cannot set blocksize on block device
> 
> Shailendra wrote:
>     libxfs_device_open () seems to be working with the pre-conceived notion
>     of assuming block devices of only 512 bytes in size.
>     This eventually calls to set the blk sz to 512. Since, your volume does
>     not support less than 4k, it returns EINVAL. I think, libxfs_init should
>     be modified to pass on the -s size option to this call so that it
>     does not happen.
>     ...
> 
> Index: xfsprogs/libxfs/darwin.c
> ===================================================================
> --- xfsprogs/libxfs/darwin.c.orig	2006-10-03 16:10:41.000000000 +1000
> +++ xfsprogs/libxfs/darwin.c	2006-10-03 16:03:48.000000000 +1000
> @@ -51,8 +51,8 @@
>  	return (writable == 0);
>  }
>  
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
>  {
>  }
>  
> Index: xfsprogs/libxfs/freebsd.c
> ===================================================================
> --- xfsprogs/libxfs/freebsd.c.orig	2006-10-03 16:10:41.000000000 +1000
> +++ xfsprogs/libxfs/freebsd.c	2006-10-03 16:03:48.000000000 +1000
> @@ -91,8 +91,8 @@
>  	return 0;
>  }
>  
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
>  {
>  	return;
>  }
> Index: xfsprogs/libxfs/init.c
> ===================================================================
> --- xfsprogs/libxfs/init.c.orig	2006-10-03 16:10:41.000000000 +1000
> +++ xfsprogs/libxfs/init.c	2006-10-03 16:34:41.000000000 +1000
> @@ -116,8 +116,16 @@
>  		exit(1);
>  	}
>  
> -	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK)
> -		platform_set_blocksize(fd, path, statb.st_rdev, 512);
> +	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
> +		if (setblksize == 1)
> +			/* use the default blocksize */
> +			(void)platform_set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
> +		else {
> +			/* given an explicit blocksize to use */
> +			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
> +			    exit(1);
> +		}
> +	}
>  
>  	/*
>  	 * Get the device number from the stat buf - unless
> Index: xfsprogs/libxfs/irix.c
> ===================================================================
> --- xfsprogs/libxfs/irix.c.orig	2006-10-03 16:10:41.000000000 +1000
> +++ xfsprogs/libxfs/irix.c	2006-10-03 16:03:48.000000000 +1000
> @@ -36,8 +36,8 @@
>  	return 1;
>  }
>  
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
>  {
>  	return;
>  }
> Index: xfsprogs/libxfs/linux.c
> ===================================================================
> --- xfsprogs/libxfs/linux.c.orig	2006-10-03 16:10:41.000000000 +1000
> +++ xfsprogs/libxfs/linux.c	2006-10-03 16:03:48.000000000 +1000
> @@ -102,16 +102,20 @@
>  	return sts;
>  }
>  
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
>  {
> +	int error = 0;
> +
>  	if (major(device) != RAMDISK_MAJOR) {
> -		if (ioctl(fd, BLKBSZSET, &blocksize) < 0) {
> -			fprintf(stderr, _("%s: warning - cannot set blocksize "
> +		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
> +			fprintf(stderr, _("%s: %s - cannot set blocksize "
>  					"on block device %s: %s\n"),
> -				progname, path, strerror(errno));
> +				progname, fatal ? "error": "warning",
> +				path, strerror(errno));
>  		}
>  	}
> +	return error;
>  }
>  
>  void
> Index: xfsprogs/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfsprogs/mkfs/xfs_mkfs.c.orig	2006-10-03 16:10:41.000000000 +1000
> +++ xfsprogs/mkfs/xfs_mkfs.c	2006-10-03 16:03:48.000000000 +1000
> @@ -634,7 +634,6 @@
>  	bzero(&fsx, sizeof(fsx));
>  
>  	bzero(&xi, sizeof(xi));
> -	xi.setblksize = 1;
>  	xi.isdirect = LIBXFS_DIRECT;
>  	xi.isreadonly = LIBXFS_EXCLUSIVELY;
>  
> @@ -1506,6 +1505,11 @@
>  	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
>  				&dsunit, &dswidth, &lsunit);
>  
> +	if (slflag || ssflag)
> +	    xi.setblksize = sectorsize;
> +	else
> +	    xi.setblksize = 1;
> +
>  	/*
>  	 * Initialize.  This will open the log and rt devices as well.
>  	 */
> Index: xfsprogs/libxfs/init.h
> ===================================================================
> --- xfsprogs/libxfs/init.h.orig	2006-10-03 16:10:41.000000000 +1000
> +++ xfsprogs/libxfs/init.h	2006-10-03 16:03:48.000000000 +1000
> @@ -25,7 +25,7 @@
>  extern int platform_check_iswritable (char *path, char *block,
>  					struct stat64 *sptr, int fatal);
>  extern void platform_findsizes (char *path, int fd, long long *sz, int *bsz);
> -extern void platform_set_blocksize (int fd, char *path, dev_t device, int bsz);
> +extern int platform_set_blocksize (int fd, char *path, dev_t device, int bsz, int fatal);
>  extern void platform_flush_device (int fd, dev_t device);
>  extern char *platform_findrawpath(char *path);
>  extern char *platform_findrawpath (char *path);
