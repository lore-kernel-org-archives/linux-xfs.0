Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 15:43:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6AMhZDP030789
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 15:43:36 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B68F5DF358C
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 15:44:40 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 6RloNwfu7twzruql for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 15:44:40 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KH4sR-0002mD-Gb
	for xfs@oss.sgi.com; Fri, 11 Jul 2008 08:44:39 +1000
Date: Fri, 11 Jul 2008 08:44:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] allow mkfs to make larger logs
Message-ID: <20080710224434.GY11558@disturbed>
References: <20080522061222.GQ173056135@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522061222.GQ173056135@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

ping?

On Thu, May 22, 2008 at 04:12:22PM +1000, David Chinner wrote:
> 
> Increase the maximum log size supported by mkfs.
> 
> The log size can be increased easily in mkfs by changing a few
> defines and a couple of types to allow the log size to increase to
> just under 2GB. Theoretically, the log size can be made much, much
> larger than this (up to 2^32 sectors), but going beyond 2^31
> *bytes* causes integer overflow issues in the kernel log code.
> 
> We use a maximum size of just under 2GB as exactly 2GB will cause
> overflow issues on the first transaction reservation.
> 
> Maximum log size is now reached at a fs size of ~4TB.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfsprogs/include/xfs_fs.h |   11 +++++++----
>  xfsprogs/mkfs/xfs_mkfs.c  |   14 +++++++-------
>  2 files changed, 14 insertions(+), 11 deletions(-)
> 
> Index: xfs-cmds/xfsprogs/include/xfs_fs.h
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/include/xfs_fs.h	2008-05-15 16:32:52.929462025 +1000
> +++ xfs-cmds/xfsprogs/include/xfs_fs.h	2008-05-15 18:50:19.494520368 +1000
> @@ -248,10 +248,13 @@ typedef struct xfs_fsop_resblks {
>   * Minimum and maximum sizes need for growth checks
>   */
>  #define XFS_MIN_AG_BLOCKS	64
> -#define XFS_MIN_LOG_BLOCKS	512
> -#define XFS_MAX_LOG_BLOCKS	(64 * 1024)
> -#define XFS_MIN_LOG_BYTES	(256 * 1024)
> -#define XFS_MAX_LOG_BYTES	(128 * 1024 * 1024)
> +#define XFS_MIN_LOG_BLOCKS	512ULL
> +#define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
> +#define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
> +
> +/* keep the maximum size under 2^31 by a small amount */
> +#define XFS_MAX_LOG_BYTES \
> +	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
>  
>  /*
>   * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
> Index: xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/mkfs/xfs_mkfs.c	2008-05-15 16:32:53.013451121 +1000
> +++ xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c	2008-05-15 18:47:54.093343349 +1000
> @@ -362,13 +362,13 @@ validate_log_size(__uint64_t logblocks, 
>  	}
>  	if (logblocks > XFS_MAX_LOG_BLOCKS) {
>  		fprintf(stderr,
> -	_("log size %lld blocks too large, maximum size is %d blocks\n"),
> +	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
>  			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
>  		usage();
>  	}
>  	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
>  		fprintf(stderr,
> -	_("log size %lld bytes too large, maximum size is %d bytes\n"),
> +	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
>  			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
>  		usage();
>  	}
> @@ -1724,7 +1724,7 @@ reported by the device (%u).\n"),
>  	min_logblocks = max_tr_res * XFS_MIN_LOG_FACTOR;
>  	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
>  	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
> -		min_logblocks = MAX(min_logblocks, (10*1024*1024)>>blocklog);
> +		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
>  	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
>  		fprintf(stderr,
>  _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
> @@ -1744,10 +1744,10 @@ _("size %s specified for log subvolume i
>  		logblocks = 0;
>  	} else if (loginternal && !logsize) {
>  		/*
> -		 * logblocks grows from min_logblocks to XFS_MAX_LOG_BLOCKS
> -		 * at 128GB
> -		 *
> -		 * 2048 = 128GB / MAX_LOG_BYTES
> +		 * With a 2GB max log size, default to maximum size
> +		 * at 4TB. This keeps the same ratio from the older
> +		 * max log size of 128M at 256GB fs size. IOWs,
> +		 * the ratio of fs size to log size is 2048:1.
>  		 */
>  		logblocks = (dblocks << blocklog) / 2048;
>  		logblocks = logblocks >> blocklog;
> 
> 

-- 
Dave Chinner
david@fromorbit.com
