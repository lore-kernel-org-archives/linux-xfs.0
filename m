Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJ47vS7231554 for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 22:07:57 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3B37D63EB8
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:08:18 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 6Ji0s6yNIhE6Kl3v for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:08:18 -0800 (PST)
Message-ID: <4B04C4AF.50501@sandeen.net>
Date: Wed, 18 Nov 2009 22:08:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] libdisk: do not install libdisk.a
References: <20091030131517.GB18462@infradead.org>
In-Reply-To: <20091030131517.GB18462@infradead.org>
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
> Since xfsprogs 3.0 libdisk is intended to be private to xfsprogs and we do
> not install the headers anymore.  But we kept installing the static library,
> which doesn't make sense.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> 
> Index: xfsprogs-dev/libdisk/Makefile
> ===================================================================
> --- xfsprogs-dev.orig/libdisk/Makefile	2009-10-30 13:12:03.000000000 +0000
> +++ xfsprogs-dev/libdisk/Makefile	2009-10-30 13:12:08.000000000 +0000
> @@ -27,6 +27,5 @@ include $(BUILDRULES)
>  install: default
>  
>  install-dev: default
> -	$(INSTALL_LTLIB_STATIC)
>  
>  install-qa: install-dev
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
