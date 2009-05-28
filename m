Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4S9uhMI246901 for <xfs@oss.sgi.com>; Thu, 28 May 2009 04:56:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26506125FC49
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 03:02:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1o3eELmTjB6RDttn for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 03:02:57 -0700 (PDT)
Date: Thu, 28 May 2009 05:56:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] Use xfs.h rather than libxfs.h
Message-ID: <20090528095657.GA651@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-2-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1243450413-12681-2-git-send-email-sandeen@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, May 27, 2009 at 01:53:25PM -0500, Eric Sandeen wrote:
> Use xfs/xfs.h when possible rather than xfs/libxfs.h,
> now that libxfs.h isn't part of a normal xfsprogs-devel
> install.

> +/*
> + * MAXNAMELEN is the length (including the terminating null) of
> + * the longest permissible file (component) name.
> + */
> +#ifndef MAXNAMELEN
> +#define MAXNAMELEN 256
> +#endif

Just switch all users to the posix NAME_MAX instead.  Note that NAME_MAX
does not include the NULL termination, so it's one-off vs MAXNAMELEN.

> diff --git a/src/godown.c b/src/godown.c
> index 4105aee..fa04f24 100644
> --- a/src/godown.c
> +++ b/src/godown.c
> @@ -18,7 +18,7 @@
>  
>  #include "global.h"
>  
> -/* These should be in libxfs.h */
> +/* These should be in xfs.h */
>  #ifndef XFS_IOC_GOINGDOWN
>  #define XFS_IOC_GOINGDOWN           _IOR ('X', 125, __uint32_t)
>  #endif

Might be worth to remove now as we had it in xfs_fs.h forever.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
