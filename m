Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALIX1qW032187 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 12:33:01 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30FE915BF048
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 10:33:00 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id LiqPJpRx1J8FDyz5 for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2008 10:33:00 -0800 (PST)
Message-ID: <4926F885.8010905@sandeen.net>
Date: Fri, 21 Nov 2008 12:05:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix spurious gcc warnings
References: <20081112114738.GC15216@infradead.org>
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

Christoph Hellwig wrote:
> Some recent gcc warnings don't like passing string variables to
> printf-like functions without using at least a "%s" format string.
> Chaneg the two occurances of that in xfs to please gcc.

Looks fine to me (might re-spell "Chaneg" though ;) )

-Eric

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
>  		/* inner loop does each group */
>  		while (j < xstats[i].endpoint) {
>  			val = 0;
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-11-12 11:13:11.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-11-12 11:13:43.000000000 +0100
> @@ -1827,10 +1827,9 @@ STATIC int __init
>  init_xfs_fs(void)
>  {
>  	int			error;
> -	static char		message[] __initdata = KERN_INFO \
> -		XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled\n";
>  
> -	printk(message);
> +	printk(KERN_INFO XFS_VERSION_STRING " with "
> +			 XFS_BUILD_OPTIONS " enabled\n");
>  
>  	ktrace_init(64);
>  	vn_init();
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
