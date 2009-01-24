Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0OFCDU6018872 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 09:12:13 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D27F01BA9A20
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 07:11:29 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 6S31MBcjK01BKnER for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 07:11:29 -0800 (PST)
Message-ID: <497B2F7E.9040501@sandeen.net>
Date: Sat, 24 Jan 2009 09:10:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: fix comment in bmap.c
References: <20090124143938.GA31680@lst.de>
In-Reply-To: <20090124143938.GA31680@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Based on a patch from Tomasz Majkowski <moosh009@gmail.com> in bugzilla
> #785.
> 

Heh, I can ACK this one :)

-Eric

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/io/bmap.c
> ===================================================================
> --- xfsprogs-dev.orig/io/bmap.c	2009-01-24 15:36:56.780113315 +0100
> +++ xfsprogs-dev/io/bmap.c	2009-01-24 15:37:17.875168142 +0100
> @@ -140,7 +140,7 @@ bmap_f(
>  		}
>  	}
>  
> -	map_size = nflag ? nflag+2 : 32;	/* initial guess - 256 */
> +	map_size = nflag ? nflag+2 : 32;	/* initial guess - 32 */
>  	map = malloc(map_size*sizeof(*map));
>  	if (map == NULL) {
>  		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
> @@ -151,7 +151,7 @@ bmap_f(
>  
>  
>  /*	Try the xfsctl(XFS_IOC_GETBMAPX) for the number of extents specified
> - *	by nflag, or the initial guess number of extents (256).
> + *	by nflag, or the initial guess number of extents (32).
>   *
>   *	If there are more extents than we guessed, use xfsctl
>   *	(XFS_IOC_FSGETXATTR[A]) to get the extent count, realloc some more
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
