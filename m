Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8D4Ykl7048024 for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 23:34:47 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9D9117DF1B1
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 21:35:32 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 4AvjdwFuaKZMwgcH for
	<xfs@oss.sgi.com>; Sun, 12 Sep 2010 21:35:32 -0700 (PDT)
Message-ID: <4C8DAA13.4050809@sandeen.net>
Date: Sun, 12 Sep 2010 23:35:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_fsr: use /proc/mounts if available
References: <20100912163428.GA10843@infradead.org>
In-Reply-To: <20100912163428.GA10843@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Prefer /proc/mounts if it exists over /etc/mtab to get a correct picture
> of the kernels mount table for this process.  This works arounds some
> userspace like pam_mount polluting /etc/mtab with incorrect entries.
> 
> Also remove the "mtab" global variable and instead pass it explicitly
> to fsrallfs, like we already do for other functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfsprogs-dev/fsr/xfs_fsr.c
> ===================================================================
> --- xfsprogs-dev.orig/fsr/xfs_fsr.c	2010-09-11 20:06:15.000000000 +0000
> +++ xfsprogs-dev/fsr/xfs_fsr.c	2010-09-12 16:28:17.000000000 +0000
> @@ -42,7 +42,9 @@
>  #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
>  #endif
>  
> -#define _PATH_FSRLAST	"/var/tmp/.fsrlast_xfs"
> +#define _PATH_FSRLAST		"/var/tmp/.fsrlast_xfs"
> +#define _PATH_PROC_MOUNTS	"/proc/mounts"
> +
>  
>  char *progname;
>  
> @@ -79,7 +81,6 @@ static __int64_t	minimumfree = 2048;
>  
>  static time_t howlong = 7200;		/* default seconds of reorganizing */
>  static char *leftofffile = _PATH_FSRLAST; /* where we left off last */
> -static char *mtab = MOUNTED;
>  static time_t endtime;
>  static time_t starttime;
>  static xfs_ino_t	leftoffino = 0;
> @@ -94,7 +95,7 @@ static int  packfile(char *fname, char *
>  static void fsrdir(char *dirname);
>  static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
>  static void initallfs(char *mtab);
> -static void fsrallfs(int howlong, char *leftofffile);
> +static void fsrallfs(char *mtab, int howlong, char *leftofffile);
>  static void fsrall_cleanup(int timeout);
>  static int  getnextents(int);
>  int xfsrtextsize(int fd);
> @@ -187,6 +188,7 @@ main(int argc, char **argv)
>  	struct mntent mntpref;
>  	register struct mntent *mntp;
>  	struct mntent ment;
> +	char *mtab = NULL;
>  	register FILE *mtabp;
>  
>  	setlinebuf(stdout);
> @@ -198,7 +200,7 @@ main(int argc, char **argv)
>  
>  	gflag = ! isatty(0);
>  
> -	while ((c = getopt(argc, argv, "C:p:e:MgsdnvTt:f:m:b:N:FV")) != -1 )
> +	while ((c = getopt(argc, argv, "C:p:e:MgsdnvTt:f:m:b:N:FV")) != -1) {
>  		switch (c) {
>  		case 'M':
>  			Mflag = 1;
> @@ -250,6 +252,22 @@ main(int argc, char **argv)
>  		default:
>  			usage(1);
>  		}
> +	}
> +
> +	/*
> +	 * If the user did not specify an explicit mount table, try to use
> +	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
> +	 * /proc/mounts because it is kernel controlled, while /etc/mtab
> +	 * may contain garbage that userspace tools like pam_mounts wrote
> +	 * into it.
> +	 */
> +	if (!mtab) {
> +		if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
> +			mtab = _PATH_PROC_MOUNTS;
> +		else
> +			mtab = _PATH_MOUNTED;
> +	}
> +
>  	if (vflag)
>  		setbuf(stdout, NULL);
>  
> @@ -330,7 +348,7 @@ main(int argc, char **argv)
>  		}
>  	} else {
>  		initallfs(mtab);
> -		fsrallfs(howlong, leftofffile);
> +		fsrallfs(mtab, howlong, leftofffile);
>  	}
>  	return 0;
>  }
> @@ -447,7 +465,7 @@ initallfs(char *mtab)
>  }
>  
>  static void
> -fsrallfs(int howlong, char *leftofffile)
> +fsrallfs(char *mtab, int howlong, char *leftofffile)
>  {
>  	int fd;
>  	int error;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
