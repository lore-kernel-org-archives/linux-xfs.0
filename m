Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0OI1AZ5026342 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 12:01:11 -0600
In-Reply-To: <20090124143938.GA31680@lst.de>
References: <20090124143938.GA31680@lst.de>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <679A4CA4-6A48-42B9-945E-7281BA709BC0@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] xfs_io: fix comment in bmap.c
Date: Sat, 24 Jan 2009 11:59:51 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com


On Jan 24, 2009, at 8:39 AM, Christoph Hellwig wrote:

> Based on a patch from Tomasz Majkowski <moosh009@gmail.com> in  
> bugzilla
> #785.

Easy one, make comments reflect the code.
Looks good.

Felix

>
>
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
>  /*	Try the xfsctl(XFS_IOC_GETBMAPX) for the number of extents  
> specified
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
