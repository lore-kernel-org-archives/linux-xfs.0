Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C3R9PA262103 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 22:27:10 -0500
Subject: Re: [PATCH] xfs: remove incorrect log write optimization
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100628143434.GA5473@infradead.org>
References: <20100628143434.GA5473@infradead.org>
Date: Sun, 11 Jul 2010 22:30:00 -0500
Message-ID: <1278905400.7456.14.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2010-06-28 at 10:34 -0400, Christoph Hellwig wrote:
> We do need a barrier for the first buffer of a split log write.  Otherwise
> we might incorrectly stamp the tail LSN into transactions in the first
> block, or not flush data I/O before updating the inode size.

I'm not sure whether "first block" means the one at the beginning
of the log, or the one at the beginning of a split log write.  In
any case recovery handles the situation correctly if the write at
the end of the log didn't make it to disk before the start of the
log.  I think you're right about ordering with respect to data I/O
though.

This looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-dev/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs-dev.orig/fs/xfs/xfs_log.c	2010-06-28 11:51:30.423004228 +0200
> +++ xfs-dev/fs/xfs/xfs_log.c	2010-06-28 11:52:52.559255519 +0200
> @@ -1423,11 +1423,8 @@ xlog_sync(xlog_t		*log,
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_ASYNC(bp);
>  	bp->b_flags |= XBF_LOG_BUFFER;
> -	/*
> -	 * Do an ordered write for the log block.
> -	 * Its unnecessary to flush the first split block in the log wrap case.
> -	 */
> -	if (!split && (log->l_mp->m_flags & XFS_MOUNT_BARRIER))
> +
> +	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
>  		XFS_BUF_ORDERED(bp);
>  
>  	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
