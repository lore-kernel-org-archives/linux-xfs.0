Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALNIx2c022135 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 17:18:59 -0600
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA90D15C3ADB
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 15:18:58 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id tHkKh7KX999ZE8Jx for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2008 15:18:58 -0800 (PST)
Date: Fri, 21 Nov 2008 18:09:48 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix spurious gcc warnings
Message-ID: <20081121230948.GZ4144@josefsipek.net>
References: <20081112114738.GC15216@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081112114738.GC15216@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 12, 2008 at 06:47:38AM -0500, Christoph Hellwig wrote:
> Some recent gcc warnings don't like passing string variables to
> printf-like functions without using at least a "%s" format string.
> Chaneg the two occurances of that in xfs to please gcc.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> fs/xfs/linux-2.6/xfs_stats.c: In function "xfs_read_xfssta":
> fs/xfs/linux-2.6/xfs_stats.c:64: warning: format not a string literal and no format arguments
> fs/xfs/linux-2.6/xfs_super.c: In function "init_xfs_fs":
> fs/xfs/linux-2.6/xfs_super.c:1833: warning: format not a string literal and no format arguments
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.c	2008-11-12 11:12:49.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c	2008-11-12 11:13:05.000000000 +0100
> @@ -61,7 +61,7 @@ xfs_read_xfsstats(
>  
>  	/* Loop over all stats groups */
>  	for (i=j=len = 0; i < ARRAY_SIZE(xstats); i++) {
> -		len += sprintf(buffer + len, xstats[i].desc);
> +		len += sprintf(buffer + len, "%s", xstats[i].desc);

Why not use strcpy here?

Josef 'Jeff' Sipek.

--
Real Programmers consider "what you see is what you get" to be just as bad a
concept in Text Editors as it is in women. No, the Real Programmer wants a
"you asked for it, you got it" text editor -- complicated, cryptic,
powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
