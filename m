Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBFKBoPf255263 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 14:11:50 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH v2] xfs: improve metadata I/O merging in the elevator
Date: Tue, 15 Dec 2009 14:12:26 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A686C@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091124180315.GB1211@infradead.org>
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
> From: Dave Chinner <dgc@sgi.com>
> 
> Change all async metadata buffers to use [READ|WRITE]_META I/O types
> so that the I/O doesn't get issued immediately. This allows merging
> of adjacent metadata requests but still prioritises them over bulk
> data. This shows a 10-15% improvement in sequential create speed of
> small files.
> 
> Don't include the log buffers in this classification - leave them
> as sync types so they are issued immediately.

Looks good.

> Signed-off-by: Dave Chinner <dgc@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-11-16 12:03:21.940253900 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-11-16 12:05:54.224256517 +0100
> @@ -1177,10 +1177,14 @@ _xfs_buf_ioapply(
>  	if (bp->b_flags & XBF_ORDERED) {
>  		ASSERT(!(bp->b_flags & XBF_READ));
>  		rw = WRITE_BARRIER;
> -	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
> +	} else if (bp->b_flags & XBF_LOG_BUFFER) {
>  		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
>  		bp->b_flags &= ~_XBF_RUN_QUEUES;
>  		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
> +	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
> +		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
> +		bp->b_flags &= ~_XBF_RUN_QUEUES;
> +		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
>  	} else {
>  		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
>  		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
> Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-11-16 12:03:21.945261731 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-11-16 12:03:23.796003934 +0100
> @@ -55,6 +55,7 @@ typedef enum {
>  	XBF_FS_MANAGED = (1 << 8),  /* filesystem controls freeing memory  */
>   	XBF_ORDERED = (1 << 11),    /* use ordered writes		   */
>  	XBF_READ_AHEAD = (1 << 12), /* asynchronous read-ahead		   */
> +	XBF_LOG_BUFFER = (1 << 13), /* this is a buffer used for the log   */
> 
>  	/* flags used only as arguments to access routines */
>  	XBF_LOCK = (1 << 14),       /* lock requested			   */
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2009-11-16 12:03:21.952261854 +0100
> +++ xfs/fs/xfs/xfs_log.c	2009-11-16 12:03:23.798003071 +0100
> @@ -1524,6 +1524,7 @@ xlog_sync(xlog_t		*log,
>  	XFS_BUF_ZEROFLAGS(bp);
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_ASYNC(bp);
> +	bp->b_flags |= XBF_LOG_BUFFER;
>  	/*
>  	 * Do an ordered write for the log block.
>  	 * Its unnecessary to flush the first split block in the log wrap case.
> @@ -1561,6 +1562,7 @@ xlog_sync(xlog_t		*log,
>  		XFS_BUF_ZEROFLAGS(bp);
>  		XFS_BUF_BUSY(bp);
>  		XFS_BUF_ASYNC(bp);
> +		bp->b_flags |= XBF_LOG_BUFFER;
>  		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
>  			XFS_BUF_ORDERED(bp);
>  		dptr = XFS_BUF_PTR(bp);
> Index: xfs/include/linux/fs.h
> ===================================================================
> --- xfs.orig/include/linux/fs.h	2009-11-16 12:04:49.799002997 +0100
> +++ xfs/include/linux/fs.h	2009-11-16 12:05:10.130255677 +0100
> @@ -151,6 +151,7 @@ struct inodes_stat_t {
>  #define READ_META	(READ | (1 << BIO_RW_META))
>  #define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
>  #define WRITE_SYNC	(WRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
> +#define WRITE_META	(WRITE | (1 << BIO_RW_META))
>  #define WRITE_ODIRECT	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
>  #define SWRITE_SYNC_PLUG	\
>  			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
