Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E18C7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 20:48:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E04D304039
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 18:48:18 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2pz6tHpyHB6sNRIF for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 18:48:16 -0800 (PST)
Date: Fri, 28 Nov 2014 13:48:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC v3 2/2] xfs: split metadata and log buffer completion
	to separate workqueues
Message-ID: <20141128024814.GB16151@dastard>
References: <1415906641-43587-1-git-send-email-bfoster@redhat.com>
	<1415906641-43587-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415906641-43587-3-git-send-email-bfoster@redhat.com>
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

On Thu, Nov 13, 2014 at 02:24:01PM -0500, Brian Foster wrote:
> XFS traditionally sends all buffer I/O completion work to a single
> queue. This includes metadata buffer completion and log buffer
> completion. The log buffer completion requires a high priority queue to
> prevent stalls due to log forces getting stuck behind other queued work.
> 
> Rather than continue to prioritize all buffer I/O completion due to the
> needs of log completion, split log buffer completion off to
> m_log_workqueue and move the high priority flag from m_buf_workqueue to
> m_log_workqueue.
> 
> [XXX: Use of XBF_SYNCIO is purely for demonstration. Define a new flag.]
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c   | 9 ++++++++-
>  fs/xfs/xfs_super.c | 5 ++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c06d790..58d729c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1050,8 +1050,15 @@ void
>  xfs_buf_ioend_async(
>  	struct xfs_buf	*bp)
>  {
> +	struct workqueue_struct *wq;
> +
> +	if (bp->b_flags & XBF_SYNCIO)
> +		wq = bp->b_target->bt_mount->m_log_workqueue;
> +	else
> +		wq = bp->b_target->bt_mount->m_buf_workqueue;
> +
>  	INIT_WORK(&bp->b_iodone_work, xfs_buf_ioend_work);
> -	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_iodone_work);
> +	queue_work(wq, &bp->b_iodone_work);

I can see what you are doing here, but I still think it would be
better to set this up at IO submission rather than taking all those
cacheline misses chasing pointers on IO completion. Adding an extra
pointer to the struct xfs_buf is not a big deal....

Otherwise this looks fine....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
