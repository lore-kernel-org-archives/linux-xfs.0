Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBKMpseQ018587 for <xfs@oss.sgi.com>; Sat, 20 Dec 2008 16:51:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC7381769FD4
	for <xfs@oss.sgi.com>; Sat, 20 Dec 2008 14:51:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zpaq8wksAWXXqQz4 for
	<xfs@oss.sgi.com>; Sat, 20 Dec 2008 14:51:53 -0800 (PST)
Date: Sat, 20 Dec 2008 17:51:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Debian userspace updates
Message-ID: <20081220225152.GA16671@infradead.org>
References: <1229732749.4496.28.camel@verge.scott.net.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1229732749.4496.28.camel@verge.scott.net.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 20, 2008 at 11:25:49AM +1100, Nathan Scott wrote:
> Hi,
> 
> Here's a couple of trivial patches from updating the Debian
> userspace packages.  Please merge - thanks!

2.10.2 is purely a tarball release,

> Index: xfsprogs-2.10.2/debian/changelog
> ===================================================================
> --- xfsprogs-2.10.2.orig/debian/changelog	2008-12-20 11:18:09.875260474 +1100
> +++ xfsprogs-2.10.2/debian/changelog	2008-12-20 11:18:13.473172568 +1100
> @@ -1,3 +1,13 @@
> +xfsprogs (2.10.2-1) unstable; urgency=low
> +
> +  * New upstream release
> +  * No longer ignore -i maxpct option in mkfs.xfs (closes: #500593)
> +  * Correct features2 superblock field handling (closes: #473135)
> +  * 32 bit emulation on 64 bit kernels works (closes: #485020)
> +  * Fix up large sector handling in mkfs (closes: #489421)
> +
> + -- Nathan Scott <nathans@debian.org>  Sat, 20 Dec 2008 10:14:27 +1100

But we should probably throw this into the git tree so it's in there
once 3.0 is released.

> Index: xfsprogs-2.10.2/libxfs/xfs_dir2.c
> ===================================================================
> --- xfsprogs-2.10.2.orig/libxfs/xfs_dir2.c	2008-12-20 11:21:21.985184849 +1100
> +++ xfsprogs-2.10.2/libxfs/xfs_dir2.c	2008-12-20 11:21:33.795013403 +1100
> @@ -21,6 +21,7 @@
>   * Top-level and utility routines.
>   */
>  
> +#include <ctype.h>
>  #include <xfs.h>
>  
>  extern const struct xfs_nameops xfs_default_nameops;

While this one has been fixed in the meantime by including ctype.h in
platform_defs.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
