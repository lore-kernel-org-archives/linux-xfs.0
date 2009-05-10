Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AISxX8197448 for <xfs@oss.sgi.com>; Sun, 10 May 2009 13:28:59 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E326DF7FC0F
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 11:33:29 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id RhDbIAYtCuB2BRcT for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 11:33:29 -0700 (PDT)
Message-ID: <4A071CEF.5050000@sandeen.net>
Date: Sun, 10 May 2009 13:29:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs: make sure xfs_sync_fsdata covers the log
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140708.037795000@bombadil.infradead.org>
In-Reply-To: <20090426140708.037795000@bombadil.infradead.org>
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

> We want to always cover the log after writing out the superblock, and
> in case of a synchronous writeout make sure we actually wait for the
> log to be covered.  That way a filesystem that has been sync()ed can
> be considered clean by log recovery.

This one looks fine to me

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:08:01.468074092 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:28:37.049956907 +0200
> @@ -208,11 +210,15 @@ xfs_sync_inodes(
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
> @@ -230,13 +236,12 @@ xfs_commit_dummy_trans(
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
> @@ -276,6 +281,7 @@ xfs_sync_fsdata(
>  		 */
>  		if (XFS_BUF_ISPINNED(bp))
>  			xfs_log_force(mp, 0, XFS_LOG_FORCE);
> +		xfs_flush_buftarg(mp->m_ddev_targp, 1);
>  	}
>  
>  
> @@ -284,7 +290,10 @@ xfs_sync_fsdata(
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
> @@ -469,8 +478,6 @@ xfs_sync_worker(
>  		/* dgc: errors ignored here */
>  		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
>  		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
