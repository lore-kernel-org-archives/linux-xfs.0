Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2CC8A7CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 09:24:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C985D8F8033
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 07:24:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bwzUTBoPnJfGjfqQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Apr 2016 07:24:48 -0700 (PDT)
Date: Mon, 25 Apr 2016 10:24:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: idle aild if the AIL is pushed up to the target LSN
Message-ID: <20160425142444.GC33882@bfoster.bfoster>
References: <1461570163-4083-1-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461570163-4083-1-git-send-email-dev@lynxeye.de>
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
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 25, 2016 at 09:42:43AM +0200, Lucas Stach wrote:
> The current logic only idles aild if the AIL is empty, rescheduling
> the worker with a timeout of 50ms otherwise. If the target LSN isn't
> moved forward, the worker will not make any progress as it only
> pushes the AIL up to the target LSN, leading to the empty AIL
> condition to only be met after the log worker pushed the complete
> AIL. As the log worker runs on the scale of minutes, this leaves
> aild in the "no progress, 50ms timeout" state for extended periods of
> time, causing many unecessary wakeups.
> 

Where do you get the "scale of minutes" from? I believe the default log
worker interval is 30s, though it can be increased by the admin.

The other thing to note is that the AIL target is also driven by demand
on log space. E.g., see xlog_grant_push_ail(), which executes when a
transaction attempts to reserve log space that isn't currently available
in the log.

That said, I'm not sure whether there's a notable benefit of idling for
50ms over just scheduling out when we've hit the target lsn. It seems
like that anybody who pushes the target forward again is going to wake
up the thread anyways. On the other hand, if the fs is idle the thread
will eventually schedule out indefinitely. Have you observed problematic
behavior due to the current heuristic?

> Fix this by idling aild as soon as the AIL is pushed up to the target
> LSN. All code paths that move the target LSN forward already ensure
> that aild is woken up again when needed.
> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> ---
> I'm pretty sure that the above deduction is correct, but as this my
> first real encounter with the XFS code base, someone with a bit more
> knowledge than me should give this some thought.
> ---
>  fs/xfs/xfs_trans_ail.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index d6c9c3e..7eca852 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -495,6 +495,7 @@ xfsaild(
>  {
>  	struct xfs_ail	*ailp = data;
>  	long		tout = 0;	/* milliseconds */
> +	struct xfs_log_item *lip;
>  
>  	current->flags |= PF_MEMALLOC;
>  	set_freezable();
> @@ -508,7 +509,8 @@ xfsaild(
>  		spin_lock(&ailp->xa_lock);
>  
>  		/*
> -		 * Idle if the AIL is empty and we are not racing with a target
> +		 * Idle if the AIL is empty or pushed up to the requested
> +		 * target LSN and we are not racing with a target
>  		 * update. We check the AIL after we set the task to a sleep
>  		 * state to guarantee that we either catch an xa_target update
>  		 * or that a wake_up resets the state to TASK_RUNNING.
> @@ -517,7 +519,8 @@ xfsaild(
>  		 * The barrier matches the xa_target update in xfs_ail_push().
>  		 */
>  		smp_rmb();
> -		if (!xfs_ail_min(ailp) &&
> +		lip = xfs_ail_min(ailp);
> +		if ((!lip || XFS_LSN_CMP(lip->li_lsn, ailp->xa_target) >= 0) &&

I think you'd want to use > 0, as == 0 suggests you have an item that
matches the target.

FWIW, another option might be to increase the timeout to something much
larger than the current 50ms when we've hit the target. See towards the
end of xfsaild_push() where tout is determined based on the state of the
push (and we already have logic to check against xa_target).

Brian

>  		    ailp->xa_target == ailp->xa_target_prev) {
>  			spin_unlock(&ailp->xa_lock);
>  			freezable_schedule();
> -- 
> 2.5.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
