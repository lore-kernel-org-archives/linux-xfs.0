Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CJ0W5X056747 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 13:00:33 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfsdump: bump version and update changelog
Date: Tue, 12 Jan 2010 13:00:18 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6953@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100112165936.GA5085@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Cc: nathans@debian.org

Christoph Hellwig wrote:
> Including a debian changelog update Nathan sent me earlier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfsdump-dev/debian/changelog
> ===================================================================
> --- xfsdump-dev.orig/debian/changelog	2010-01-06 18:42:23.013011836 +0100
> +++ xfsdump-dev/debian/changelog	2010-01-12 17:55:30.278005578 +0100
> @@ -1,3 +1,9 @@
> +xfsdump (3.0.4) unstable; urgency=low
> +
> +  * New bugfix release
> +
> + -- Nathan Scott <nathans@debian.org>  Tue, 12 Jan 2009 17:46:03 +1100
> +
>  xfsdump (3.0.2) unstable; urgency=low
> 
>    * New bugfix release
> Index: xfsdump-dev/VERSION
> ===================================================================
> --- xfsdump-dev.orig/VERSION	2010-01-12 17:50:51.818254512 +0100
> +++ xfsdump-dev/VERSION	2010-01-12 17:51:01.847006343 +0100
> @@ -3,5 +3,5 @@
>  #
>  PKG_MAJOR=3
>  PKG_MINOR=0
> -PKG_REVISION=2
> +PKG_REVISION=4
>  PKG_BUILD=1
> Index: xfsdump-dev/doc/CHANGES
> ===================================================================
> --- xfsdump-dev.orig/doc/CHANGES	2010-01-12 17:51:04.440274239 +0100
> +++ xfsdump-dev/doc/CHANGES	2010-01-12 17:54:59.819255971 +0100
> @@ -1,3 +1,8 @@
> +xfsdump-3.0.4
> +	- Improve xfsinvutil man page and argument processing.
> +	- Fix timestamp handling on 64-bit architectures in xfsinvutil.
> +	- Various build system improvements.
> +
>  xfsdump-3.0.2 (9 May 2009)
>  	- Update the Debian packaging and resolve xfsprogs dependencies.
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
