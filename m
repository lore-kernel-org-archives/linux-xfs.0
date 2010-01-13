Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DM0wNE193687 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:00:59 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E19E01249BF3
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:01:54 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id V7IvNjZqYeP3mJ2B for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:01:54 -0800 (PST)
Message-ID: <4B4E42D1.8090806@sandeen.net>
Date: Wed, 13 Jan 2010 16:01:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: add package_blkid.m4 to the distributed files
References: <20100113213620.GA20812@infradead.org>
In-Reply-To: <20100113213620.GA20812@infradead.org>
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
> We need to include all the m4 files in the source tarball in case people
> want to regenerate the configure script.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

sigh, yep, sorry.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> 
> Index: xfsprogs-dev/m4/Makefile
> ===================================================================
> --- xfsprogs-dev.orig/m4/Makefile	2010-01-13 22:27:54.121253788 +0100
> +++ xfsprogs-dev/m4/Makefile	2010-01-13 22:28:08.553256439 +0100
> @@ -15,6 +15,7 @@ CONFIGURE = \
>  LSRCFILES = \
>  	manual_format.m4 \
>  	package_aiodev.m4 \
> +	package_blkid.m4 \
>  	package_globals.m4 \
>  	package_libcdev.m4 \
>  	package_pthread.m4 \
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
