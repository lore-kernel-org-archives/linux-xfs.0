Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jan 2008 21:04:13 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0M541cu012094
	for <xfs@oss.sgi.com>; Mon, 21 Jan 2008 21:04:06 -0800
Message-ID: <47957A1C.3060806@sgi.com>
Date: Tue, 22 Jan 2008 16:07:40 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [patch] reduce log I/O latency V2
References: <20080121041649.GA155259@sgi.com> <47956615.90700@sgi.com> <20080122035817.GT155259@sgi.com>
In-Reply-To: <20080122035817.GT155259@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Yup, all good now.

David Chinner wrote:
> On Tue, Jan 22, 2008 at 02:42:13PM +1100, Lachlan McIlroy wrote:
>> Looks good Dave.  Shouldn't we also tag the second buffer in the
>> split log write case?
> 
> Hmm - I thought it was being tagged. looks like I missed a reject
> on my last set of patch re-orderings - updated patch attached.
> 
> ---
> 
> Reduce log I/O latency
> 
> To ensure that log I/O is issued as the highest priority I/O, set
> the I/O priority of the log I/O to the highest possible. This will
> ensure that log I/O is not held up behind bulk data or other
> metadata I/O as delaying log I/O can pause the entire transaction
> subsystem. Introduce a new buffer flag to allow us to tag the log
> buffers so we can discriminate when issuing the I/O.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    3 +++
>  fs/xfs/linux-2.6/xfs_buf.h |    5 ++++-
>  fs/xfs/xfs_log.c           |    3 +++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-01-18 19:13:07.499131222 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2008-01-22 14:56:58.738098626 +1100
> @@ -1198,6 +1198,9 @@ next_chunk:
>  
>  submit_io:
>  	if (likely(bio->bi_size)) {
> +		/* log I/O should not be delayed by anything except realtime. */
> +		if (bp->b_flags & XBF_LOG_BUFFER)
> +			bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0));
>  		submit_bio(rw, bio);
>  		if (size)
>  			goto next_chunk;
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-01-18 19:13:07.503130710 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.h	2008-01-18 19:13:29.448320166 +1100
> @@ -53,7 +53,8 @@ typedef enum {
>  	XBF_DELWRI = (1 << 6),  /* buffer has dirty pages                  */
>  	XBF_STALE = (1 << 7),	/* buffer has been staled, do not find it  */
>  	XBF_FS_MANAGED = (1 << 8),  /* filesystem controls freeing memory  */
> - 	XBF_ORDERED = (1 << 11),    /* use ordered writes		   */
> +	XBF_LOG_BUFFER = (1 << 9),  /* Buffer issued by the log		   */
> +	XBF_ORDERED = (1 << 11),    /* use ordered writes		   */
>  	XBF_READ_AHEAD = (1 << 12), /* asynchronous read-ahead		   */
>  
>  	/* flags used only as arguments to access routines */
> @@ -339,6 +340,8 @@ extern void xfs_buf_trace(xfs_buf_t *, c
>  #define XFS_BUF_TARGET(bp)		((bp)->b_target)
>  #define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
>  
> +#define XFS_BUF_SET_LOGBUF(bp)	((bp)->b_flags |= XBF_LOG_BUFFER)
> +
>  static inline int xfs_bawrite(void *mp, xfs_buf_t *bp)
>  {
>  	bp->b_fspriv3 = mp;
> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-01-18 19:13:07.519128661 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-01-22 14:56:57.550673091 +1100
> @@ -1462,6 +1462,8 @@ xlog_sync(xlog_t		*log,
>  	XFS_BUF_ZEROFLAGS(bp);
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_ASYNC(bp);
> +	XFS_BUF_SET_LOGBUF(bp);
> +
>  	/*
>  	 * Do an ordered write for the log block.
>  	 * Its unnecessary to flush the first split block in the log wrap case.
> @@ -1499,6 +1501,7 @@ xlog_sync(xlog_t		*log,
>  		XFS_BUF_ZEROFLAGS(bp);
>  		XFS_BUF_BUSY(bp);
>  		XFS_BUF_ASYNC(bp);
> +		XFS_BUF_SET_LOGBUF(bp);
>  		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
>  			XFS_BUF_ORDERED(bp);
>  		dptr = XFS_BUF_PTR(bp);
> 
> 
> 
