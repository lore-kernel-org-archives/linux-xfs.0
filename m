Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E54D97F3F
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 16:04:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4E25304059
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 14:04:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fJaKiGpj0S6pv0bV for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2014 14:04:00 -0800 (PST)
Date: Thu, 4 Dec 2014 09:03:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: split metadata and log buffer completion to
	separate workqueues
Message-ID: <20141203220346.GR9561@dastard>
References: <1417634659-16386-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417634659-16386-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 03, 2014 at 02:24:19PM -0500, Brian Foster wrote:
> XFS traditionally sends all buffer I/O completion work to a single
> workqueue. This includes metadata buffer completion and log buffer
> completion. The log buffer completion requires a high priority queue to
> prevent stalls due to log forces getting stuck behind other queued work.
> 
> Rather than continue to prioritize all buffer I/O completion due to the
> needs of log completion, split log buffer completion off to
> m_log_workqueue and move the high priority flag from m_buf_workqueue to
> m_log_workqueue.
> 
> Add a b_ioend_wq wq pointer to xfs_buf to allow completion workqueue
> customization on a per-buffer basis. Initialize b_ioend_wq to
> m_buf_workqueue by default in the generic buffer I/O submission path.
> Finally, override the default wq with the high priority m_log_workqueue
> in the log buffer I/O submission path.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v2:
> - Add bp->b_ioend_wq pointer to multiplex buffer I/O completion
>   workqueues.
> v1/rfc: http://oss.sgi.com/archives/xfs/2014-11/msg00240.html
> 
>  fs/xfs/xfs_buf.c   | 13 ++++++++++---
>  fs/xfs/xfs_buf.h   |  3 ++-
>  fs/xfs/xfs_log.c   |  4 ++++
>  fs/xfs/xfs_super.c |  5 ++---
>  4 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a4ce390..bb502a3 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1041,7 +1041,7 @@ xfs_buf_ioend_work(
>  	struct work_struct	*work)
>  {
>  	struct xfs_buf		*bp =
> -		container_of(work, xfs_buf_t, b_iodone_work);
> +		container_of(work, xfs_buf_t, b_ioend_work);
>  
>  	xfs_buf_ioend(bp);
>  }
> @@ -1050,8 +1050,8 @@ void
>  xfs_buf_ioend_async(
>  	struct xfs_buf	*bp)
>  {
> -	INIT_WORK(&bp->b_iodone_work, xfs_buf_ioend_work);
> -	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_iodone_work);
> +	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
> +	queue_work(bp->b_ioend_wq, &bp->b_ioend_work);
>  }
>  
>  void
> @@ -1220,6 +1220,13 @@ _xfs_buf_ioapply(
>  	 */
>  	bp->b_error = 0;
>  
> +	/*
> +	 * Initialize the I/O completion workqueue if we haven't yet or the
> +	 * submitter has not opted to specify a custom one.
> +	 */
> +	if (!bp->b_ioend_wq)
> +		bp->b_ioend_wq = bp->b_target->bt_mount->m_buf_workqueue;
> +
>  	if (bp->b_flags & XBF_WRITE) {
>  		if (bp->b_flags & XBF_SYNCIO)
>  			rw = WRITE_SYNC;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 82002c0..75ff5d5 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -164,7 +164,8 @@ typedef struct xfs_buf {
>  	struct xfs_perag	*b_pag;		/* contains rbtree root */
>  	xfs_buftarg_t		*b_target;	/* buffer target (device) */
>  	void			*b_addr;	/* virtual address of buffer */
> -	struct work_struct	b_iodone_work;
> +	struct work_struct	b_ioend_work;
> +	struct workqueue_struct	*b_ioend_wq;	/* I/O completion wq */
>  	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
>  	struct completion	b_iowait;	/* queue for I/O waiters */
>  	void			*b_fspriv;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6d6b8b..e408bf5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1806,6 +1806,8 @@ xlog_sync(
>  	XFS_BUF_ZEROFLAGS(bp);
>  	XFS_BUF_ASYNC(bp);
>  	bp->b_flags |= XBF_SYNCIO;
> +	/* use high priority completion wq */
> +	bp->b_ioend_wq = log->l_mp->m_log_workqueue;

We reuse the log buffers so this should only need to be set at
initialisation time whent eh buffers are allocated. Minor issue,
though - send a followup patch that just moves this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
