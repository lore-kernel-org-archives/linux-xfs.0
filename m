Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IMx9sF209622 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 17:59:09 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1824613F8A13
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 16:04:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LbUndJWOZp0A2FPD for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 16:04:16 -0700 (PDT)
Date: Mon, 19 Sep 2011 08:59:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: unlock the inode before log force in xfs_fsync
Message-ID: <20110918225903.GC15688@dastard>
References: <20110918204748.547510183@bombadil.infradead.org>
	<20110918204909.860669185@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110918204909.860669185@bombadil.infradead.org>
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

On Sun, Sep 18, 2011 at 04:47:49PM -0400, Christoph Hellwig wrote:
> Only read the LSN we need to push to with the ilock held, and then release
> it before we do the log force to improve concurrency.
> 
> This also removes the only direct caller of _xfs_trans_commit, thus
> allowing it to be merged into the plain xfs_trans_commit again.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2011-09-07 10:59:55.742961175 +0200
> +++ xfs/fs/xfs/xfs_file.c	2011-09-07 11:08:12.830462974 +0200
> @@ -137,6 +137,7 @@ xfs_file_fsync(
>  	struct xfs_trans	*tp;
>  	int			error = 0;
>  	int			log_flushed = 0;
> +	xfs_lsn_t		lsn = 0;
>  
>  	trace_xfs_file_fsync(ip);
>  
> @@ -214,8 +215,10 @@ xfs_file_fsync(
>  		 */
>  		xfs_trans_ijoin(tp, ip);
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -		xfs_trans_set_sync(tp);
> -		error = _xfs_trans_commit(tp, 0, &log_flushed);
> +		error = xfs_trans_commit(tp, 0);
> +
> +		ASSERT(xfs_ipincount(ip));

That's a racy assert. If the trans commit causes the CIL to be
pushed, that could complete and unpin the inode before we start
executing here again and check the pin count.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
