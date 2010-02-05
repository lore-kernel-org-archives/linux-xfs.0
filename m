Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15NuHWf172455 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 17:56:17 -0600
Subject: Re: [PATCH 05/10] xfs: Use delay write promotion for dquot flushing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1265153104-29680-6-git-send-email-david@fromorbit.com>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-6-git-send-email-david@fromorbit.com>
Date: Fri, 05 Feb 2010 17:55:55 -0600
Message-ID: <1265414155.2714.155.camel@doink1>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-02-03 at 10:24 +1100, Dave Chinner wrote:
> xfs_qm_dqflock_pushbuf_wait() does a very similar trick to item
> pushing used to do to flush out delayed write dquot buffers. Change
> it to use the new promotion method rather than an async flush.
> 
> Also, xfs_qm_dqflock_pushbuf_wait() can return without the flush lock
> held, yet the callers make the assumption that after this call the
> flush lock is held. Always return with the flush lock held.

Looks good.

> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/quota/xfs_dquot.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
> index f9baeed..1620a56 100644
> --- a/fs/xfs/quota/xfs_dquot.c
> +++ b/fs/xfs/quota/xfs_dquot.c
> @@ -1528,21 +1528,16 @@ xfs_qm_dqflock_pushbuf_wait(
>  	 */
>  	bp = xfs_incore(dqp->q_mount->m_ddev_targp, dqp->q_blkno,
>  		    XFS_QI_DQCHUNKLEN(dqp->q_mount), XBF_TRYLOCK);
> -	if (bp != NULL) {
> -		if (XFS_BUF_ISDELAYWRITE(bp)) {
> -			int	error;
> -
> -			if (XFS_BUF_ISPINNED(bp))
> -				xfs_log_force(dqp->q_mount, 0);
> -			error = xfs_bawrite(dqp->q_mount, bp);
> -			if (error)
> -				xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
> -					"xfs_qm_dqflock_pushbuf_wait: "
> -					"pushbuf error %d on dqp %p, bp %p",
> -					error, dqp, bp);
> -		} else {
> -			xfs_buf_relse(bp);
> -		}
> +	if (!bp)
> +		goto out_lock;
> +
> +	if (XFS_BUF_ISDELAYWRITE(bp)) {
> +		if (XFS_BUF_ISPINNED(bp))
> +			xfs_log_force(dqp->q_mount, 0);
> +		xfs_buf_delwri_promote(bp);
> +		wake_up_process(bp->b_target->bt_task);
>  	}
> +	xfs_buf_relse(bp);
> +out_lock:
>  	xfs_dqflock(dqp);
>  }



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
