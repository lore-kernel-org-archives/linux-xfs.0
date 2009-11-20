Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAK0Zp6V085389 for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 18:35:52 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D40A218B0162
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 16:36:13 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id tQcL6PFD75AcxyVq for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2009 16:36:13 -0800 (PST)
References: <20091119231418.GA7161@infradead.org>
Message-Id: <22F8A8E4-38C5-4689-9CEB-89C23174BBC3@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20091119231418.GA7161@infradead.org>
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] xfsprogs: stop using off64_t in platform headers
Date: Thu, 19 Nov 2009 18:36:03 -0600
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>



On Nov 19, 2009, at 5:14 PM, Christoph Hellwig <hch@infradead.org>  
wrote:

> Using off64_t may require special headers or compiler flags that  
> aren't
> always available, e.g. in the configure check in xfstests.  Rever to  
> a plain
> uint64_t to make apps compile as before.
>
> While we're at it also rename the second argument of  
> platform_discard_blocks
> from end to len as that's what the BLKDISCARD ioctl excepts - we  
> currently
> always discard the whole device so it doesn't matter in practice.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
Thanks.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
> Index: xfsprogs-dev/include/darwin.h
> ===================================================================
> --- xfsprogs-dev.orig/include/darwin.h    2009-11-19 23:12:05.000000000 
>  +0000
> +++ xfsprogs-dev/include/darwin.h    2009-11-19 23:12:30.000000000  
> +0000
> @@ -155,7 +155,7 @@ typedef unsigned char    uchar_t;
> #define HAVE_FID    1
>
> static __inline__ int
> -platform_discard_blocks(int fd, off64_t start, off64_t end)
> +platform_discard_blocks(int fd, uint64_t start, uint64_t len)
> {
>    return 0;
> }
> Index: xfsprogs-dev/include/freebsd.h
> ===================================================================
> --- xfsprogs-dev.orig/include/freebsd.h    2009-11-19 23:12:05.000000000 
>  +0000
> +++ xfsprogs-dev/include/freebsd.h    2009-11-19 23:12:30.000000000  
> +0000
> @@ -140,7 +140,7 @@ static __inline__ void platform_uuid_cop
> }
>
> static __inline__ int
> -platform_discard_blocks(int fd, off64_t start, off64_t end)
> +platform_discard_blocks(int fd, uint64_t start, uint64_t len)
> {
>    return 0;
> }
> Index: xfsprogs-dev/include/irix.h
> ===================================================================
> --- xfsprogs-dev.orig/include/irix.h    2009-11-19  
> 23:12:05.000000000 +0000
> +++ xfsprogs-dev/include/irix.h    2009-11-19 23:12:30.000000000 +0000
> @@ -338,7 +338,7 @@ static __inline__ void platform_uuid_cop
> }
>
> static __inline__ int
> -platform_discard_blocks(int fd, off64_t start, off64_t end)
> +platform_discard_blocks(int fd, uint64_t start, uint64_t len)
> {
>    return 0;
> }
> Index: xfsprogs-dev/include/linux.h
> ===================================================================
> --- xfsprogs-dev.orig/include/linux.h    2009-11-19  
> 23:12:04.000000000 +0000
> +++ xfsprogs-dev/include/linux.h    2009-11-19 23:12:40.000000000  
> +0000
> @@ -98,9 +98,9 @@ static __inline__ void platform_uuid_cop
> #endif
>
> static __inline__ int
> -platform_discard_blocks(int fd, off64_t start, off64_t end)
> +platform_discard_blocks(int fd, uint64_t start, uint64_t len)
> {
> -    __uint64_t range[2] = { start, end };
> +    __uint64_t range[2] = { start, len };
>
>    if (ioctl(fd, BLKDISCARD, &range) < 0)
>        return errno;
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
