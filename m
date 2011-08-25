Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7PKvvlC238400 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 15:57:57 -0500
Subject: Re: [PATCH 4/6] xfs: reduce the number of log forces from tail pushing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1314256626-11136-5-git-send-email-david@fromorbit.com>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
	<1314256626-11136-5-git-send-email-david@fromorbit.com>
Date: Thu, 25 Aug 2011 15:57:06 -0500
Message-ID: <1314305826.3136.102.camel@doink>
MIME-Version: 1.0
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

On Thu, 2011-08-25 at 17:17 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AIL push code will issue a log force on ever single push loop
> that it exits and has encountered pinned items. It doesn't rescan
> these pinned items until it revisits the AIL from the start. Hence
> we only need to force the log once per walk from the start of the
> AIL to the target LSN.
> 
> This results in numbers like this:
> 
> 	xs_push_ail_flush.....         1456
> 	xs_log_force.........          1485
> 
> For an 8-way 50M inode create workload - almost all the log forces
> are coming from the AIL pushing code.
> 
> Reduce the number of log forces by only forcing the log if the
> previous walk found pinned buffers. This reduces the numbers to:
> 
> 	xs_push_ail_flush.....          665
> 	xs_log_force.........           682
> 
> For the same test.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This looks good to me and if you don't update it
I can take it as-is.  A couple trivial things below
if you decide to update.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/xfs_trans_ail.c  |   28 ++++++++++++++++------------
>  fs/xfs/xfs_trans_priv.h |    1 +
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index c15aa29..dd966e0 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -372,12 +372,24 @@ xfs_ail_worker(
>  	xfs_lsn_t		lsn;
>  	xfs_lsn_t		target;
>  	long			tout = 10;
> -	int			flush_log = 0;
>  	int			stuck = 0;
>  	int			count = 0;
>  	int			push_xfsbufd = 0;
>  
> +	/*
> +	 * If last time we ran we encountered pinned items, force the log first,
> +	 * wait for it and then push again.
          * and wait for it before we push it again.
          */

> +	 */
>  	spin_lock(&ailp->xa_lock);
> +	if (ailp->xa_last_pushed_lsn == 0 && ailp->xa_log_flush &&
> +	    !list_empty(&ailp->xa_ail)) {
> +		ailp->xa_log_flush = 0;
> +		spin_unlock(&ailp->xa_lock);
> +		XFS_STATS_INC(xs_push_ail_flush);
> +		xfs_log_force(mp, XFS_LOG_SYNC);
> +		spin_lock(&ailp->xa_lock);
> +	}

This is a definite improvement over the previous version.

> +
>  	target = ailp->xa_target;
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
>  	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
> @@ -391,6 +403,7 @@ xfs_ail_worker(
>  
>  	XFS_STATS_INC(xs_push_ail);
>  
> +
>  	/*
>  	 * While the item we are looking at is below the given threshold
>  	 * try to flush it out. We'd like not to stop until we've at least

Kill this hunk.

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
