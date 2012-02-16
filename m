Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GLP3D8020547 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 15:25:03 -0600
Date: Thu, 16 Feb 2012 15:25:06 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 11/12] xfs: share code for grant head availability checks
Message-ID: <20120216212506.GZ7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141435.484216051@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141435.484216051@bombadil.infradead.org>
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

Add xlog_grant_head_check() to replace sections of
xlog_regrant_write_log_space() and xlog_grant_log_space().

On Mon, Dec 12, 2011 at 09:13:58AM -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_log.c |  133 ++++++++++++++++++++++++-------------------------------
>  1 file changed, 60 insertions(+), 73 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:32:08.763640044 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:36:10.395664344 +0100
> @@ -245,6 +245,60 @@ shutdown:
>  	return XFS_ERROR(EIO);
>  }
>  
> +/*
> + * Atomically get the log space required for a log ticket.
> + *
> + * Once a ticket gets put onto head->waiters, it will only return after the
> + * needed reservation is satisfied.
> + *
> + * This function is structured so that it has a lock free fast path. This is
> + * necessary because every new transaction reservation will come through this
> + * path. Hence any lock will be globally hot if we take it unconditionally on
> + * every pass.
> + *
> + * As tickets are only ever moved on and off head->waiters under head->lock, we
> + * only need to take that lock if we are going to add the ticket to the queue
> + * and sleep. We can avoid taking the lock if the ticket was never added to
> + * head->waiters because the t_queue list head will be empty and we hold the
> + * only reference to it so it can safely be checked unlocked.
> + */
> +STATIC int
> +xlog_grant_head_check(
> +	struct log		*log,
> +	struct xlog_grant_head	*head,
> +	struct xlog_ticket	*tic,
> +	int			*need_bytes)
> +{
> +	int			free_bytes;
> +	int			error = 0;
> +
> +	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
> +
> +	/*
> +	 * If there are other waiters on the queue then give them a chance at
> +	 * logspace before us.  Wake up the first waiters, if we do not wake
> +	 * up all the waiters then go to sleep waiting for more free space,
> +	 * otherwise try to get some space for this transaction.
> +	 */
> +	*need_bytes = xlog_ticket_reservation(log, head, tic);
> +	free_bytes = xlog_space_left(log, &head->grant);
> +	if (!list_empty_careful(&head->waiters)) {
> +		spin_lock(&head->lock);
> +		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
> +		    free_bytes < *need_bytes) {
> +			error = xlog_grant_head_wait(log, head, tic,
> +						     *need_bytes);
> +		}
> +		spin_unlock(&head->lock);
> +	} else if (free_bytes < *need_bytes) {
> +		spin_lock(&head->lock);
> +		error = xlog_grant_head_wait(log, head, tic, *need_bytes);
> +		spin_unlock(&head->lock);
> +	}
> +
> +	return error;
> +}
> +
>  static void
>  xlog_tic_reset_res(xlog_ticket_t *tic)
>  {
> @@ -2511,59 +2565,18 @@ restart:
>  	return 0;
>  }	/* xlog_state_get_iclog_space */
>  
> -/*
> - * Atomically get the log space required for a log ticket.
> - *
> - * Once a ticket gets put onto the reserveq, it will only return after the
> - * needed reservation is satisfied.
> - *
> - * This function is structured so that it has a lock free fast path. This is
> - * necessary because every new transaction reservation will come through this
> - * path. Hence any lock will be globally hot if we take it unconditionally on
> - * every pass.
> - *
> - * As tickets are only ever moved on and off the l_reserve.waiters under the
> - * l_reserve.lock, we only need to take that lock if we are going to add
> - * the ticket to the queue and sleep. We can avoid taking the lock if the ticket
> - * was never added to the reserveq because the t_queue list head will be empty
> - * and we hold the only reference to it so it can safely be checked unlocked.
> - */
>  STATIC int
>  xlog_grant_log_space(
>  	struct log		*log,
>  	struct xlog_ticket	*tic)
>  {
> -	int			free_bytes, need_bytes;
> +	int			need_bytes;
>  	int			error = 0;
>  
> -	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
> -
>  	trace_xfs_log_grant_enter(log, tic);
>  
> -	/*
> -	 * If there are other waiters on the queue then give them a chance at
> -	 * logspace before us.  Wake up the first waiters, if we do not wake
> -	 * up all the waiters then go to sleep waiting for more free space,
> -	 * otherwise try to get some space for this transaction.
> -	 */
> -	need_bytes = tic->t_unit_res;
> -	if (tic->t_flags & XFS_LOG_PERM_RESERV)
> -		need_bytes *= tic->t_ocnt;
				     ^
Here the calculation was done with tic->t_ocnt.

You don't see it in this patch, but xlog_ticket_reservation is using
t_cnt.  I haven't looked into which is correct.

Other than that this patch looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
