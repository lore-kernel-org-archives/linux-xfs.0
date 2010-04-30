Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U3D7mb124234 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 22:13:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F5281AFDA2B
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:15:12 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 2LbOHyQsA8A0j9hh for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:15:12 -0700 (PDT)
Message-ID: <4BDA4B40.7070709@sandeen.net>
Date: Thu, 29 Apr 2010 22:15:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: bump version and update changelog
References: <20100429102805.GA4895@infradead.org>
In-Reply-To: <20100429102805.GA4895@infradead.org>
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
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/VERSION
> ===================================================================
> --- xfsprogs-dev.orig/VERSION	2010-04-29 12:21:54.074004868 +0200
> +++ xfsprogs-dev/VERSION	2010-04-29 12:21:59.188004170 +0200
> @@ -3,5 +3,5 @@
>  #
>  PKG_MAJOR=3
>  PKG_MINOR=1
> -PKG_REVISION=1
> +PKG_REVISION=2
>  PKG_BUILD=1
> Index: xfsprogs-dev/doc/CHANGES
> ===================================================================
> --- xfsprogs-dev.orig/doc/CHANGES	2010-04-29 12:21:54.084013459 +0200
> +++ xfsprogs-dev/doc/CHANGES	2010-04-29 12:22:37.625255672 +0200
> @@ -1,3 +1,15 @@
> +xfsprogs-3.1.2
> +	- Fix missing thread synchronization in xfs_repair duplicate
> +	  extent tracking.
> +	- Fix handling of dynamic attribute fork roots in xfs_fsr.
> +	- Fix sb_bad_features2 manipulations when tweaking the lazy count
> +	  flag.
> +	- Add support for building on Debian GNU/kFreeBSD, thanks
> +	  to Petr Salinger.
> +	- Improvements to the mkfs.xfs manpage, thanks to Wengang Wang.
> +	- Various small blkid integreation fixes in mkfs.xfs.

"integration"

Other than that, looks good, was time for a new release. :)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> +	- Fix build against stricter system headers.
> +
>  xfsprogs-3.1.1 (29 January 2010)
>  	- Fix various blkid topology support problems in mkfs.xfs.
>  	- Fix various build warnings.
> Index: xfsprogs-dev/debian/changelog
> ===================================================================
> --- xfsprogs-dev.orig/debian/changelog	2010-01-30 20:39:41.872254549 +0100
> +++ xfsprogs-dev/debian/changelog	2010-04-29 12:23:53.931253925 +0200
> @@ -1,3 +1,10 @@
> +xfsprogs (3.1.2) unstable; urgency=low
> +
> +  * New upstream release
> +  * Allow for building on GNU/kFreeBSD (closes: #485796)
> +
> + -- Nathan Scott <nathans@debian.org>  Thu, 29 Apr 2010 14:25:43 +1100
> +
>  xfsprogs (3.1.1) unstable; urgency=low
>  
>    * New upstream release
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
