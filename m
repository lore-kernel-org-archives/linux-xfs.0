Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4BGPTov002095 for <xfs@oss.sgi.com>; Mon, 11 May 2009 11:25:30 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76EB0279414
	for <xfs@oss.sgi.com>; Mon, 11 May 2009 09:25:34 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id QsmzDJ3k5ijgN4Le for <xfs@oss.sgi.com>;
	Mon, 11 May 2009 09:25:34 -0700 (PDT)
Message-ID: <4A085173.5040208@sandeen.net>
Date: Mon, 11 May 2009 11:25:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: update max log size
References: <20090511160609.GA18278@infradead.org>
In-Reply-To: <20090511160609.GA18278@infradead.org>
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
> Commit a6634fba3dec4a92f0a2c4e30c80b634c0576ad5 in xfsprogs increased the
> maximum log size supported by mkfs.  Merged back the changes to xfs_fs.h
> so the growfs enforced the same limit and the headers are in sync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ok, looks like kernelspace only cares about this during
xfs_growfs_log_private(), and that's not actually implemented yet,
right?  So no worries about kernel<->userspace version correlation I think.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfs/fs/xfs/xfs_fs.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_fs.h	2009-02-08 21:51:06.576943974 +0100
> +++ xfs/fs/xfs/xfs_fs.h	2009-05-10 21:33:30.970822643 +0200
> @@ -239,10 +239,13 @@ typedef struct xfs_fsop_resblks {
>   * Minimum and maximum sizes need for growth checks
>   */
>  #define XFS_MIN_AG_BLOCKS	64
> -#define XFS_MIN_LOG_BLOCKS	512
> -#define XFS_MAX_LOG_BLOCKS	(64 * 1024)
> -#define XFS_MIN_LOG_BYTES	(256 * 1024)
> -#define XFS_MAX_LOG_BYTES	(128 * 1024 * 1024)
> +#define XFS_MIN_LOG_BLOCKS	512ULL
> +#define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
> +#define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
> +
> +/* keep the maximum size under 2^31 by a small amount */
> +#define XFS_MAX_LOG_BYTES \
> +	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
>  
>  /*
>   * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
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
