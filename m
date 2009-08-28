Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SNI1ZU183343 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 18:18:11 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/4] xfs: make sure xfs_sync_fsdata covers the log 
Date: Fri, 28 Aug 2009 18:18:24 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF3@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090827231558.057467775@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> From: Dave Chinner <david@fromorbit.com>
> 
> We want to always cover the log after writing out the superblock, and
> in case of a synchronous writeout make sure we actually wait for the
> log to be covered.  That way a filesystem that has been sync()ed can
> be considered clean by log recovery.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>



Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-07-07 16:03:51.871239376 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-07-07 18:24:48.722251281 +0200
> @@ -309,11 +309,15 @@ xfs_sync_attr(
>  STATIC int
>  xfs_commit_dummy_trans(
>  	struct xfs_mount	*mp,
> -	uint			log_flags)
> +	uint			flags)
>  {
>  	struct xfs_inode	*ip = mp->m_rootip;
>  	struct xfs_trans	*tp;
>  	int			error;
> +	int			log_flags = XFS_LOG_FORCE;
> +
> +	if (flags & SYNC_WAIT)
> +		log_flags |= XFS_LOG_SYNC;
> 
>  	/*
>  	 * Put a dummy transaction in the log to tell recovery
> @@ -331,13 +335,12 @@ xfs_commit_dummy_trans(
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ihold(tp, ip);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	/* XXX(hch): ignoring the error here.. */
>  	error = xfs_trans_commit(tp, 0);
> -
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 
> +	/* the log force ensures this transaction is pushed to disk */
>  	xfs_log_force(mp, 0, log_flags);
> -	return 0;
> +	return error;
>  }
> 
>  int
> @@ -377,6 +380,7 @@ xfs_sync_fsdata(
>  		 */
>  		if (XFS_BUF_ISPINNED(bp))
>  			xfs_log_force(mp, 0, XFS_LOG_FORCE);
> +		xfs_flush_buftarg(mp->m_ddev_targp, 1);
>  	}
> 
> 
> @@ -385,7 +389,10 @@ xfs_sync_fsdata(
>  	else
>  		XFS_BUF_ASYNC(bp);
> 
> -	return xfs_bwrite(mp, bp);
> +	error = xfs_bwrite(mp, bp);
> +	if (!error && xfs_log_need_covered(mp))
> +		error = xfs_commit_dummy_trans(mp, (flags & SYNC_WAIT));
> +	return error;
> 
>   out_brelse:
>  	xfs_buf_relse(bp);
> @@ -571,8 +578,6 @@ xfs_sync_worker(
>  		/* dgc: errors ignored here */
>  		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
>  		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
> -		if (xfs_log_need_covered(mp))
> -			error = xfs_commit_dummy_trans(mp, XFS_LOG_FORCE);
>  	}
>  	mp->m_sync_seq++;
>  	wake_up(&mp->m_wait_single_sync_task);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
