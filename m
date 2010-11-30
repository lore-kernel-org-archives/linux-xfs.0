Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAUKI445136456 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:18:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30CBF1400D4A
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 12:19:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cON6ks2dLITciPYn for
	<xfs@oss.sgi.com>; Tue, 30 Nov 2010 12:19:46 -0800 (PST)
Date: Tue, 30 Nov 2010 15:19:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] xfs: reduce the number of AIL push wakeups
Message-ID: <20101130201946.GC16079@infradead.org>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290993152-20999-5-git-send-email-david@fromorbit.com>
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

On Mon, Nov 29, 2010 at 12:12:28PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xfaild often tries to rest to wait for congestion to pass of for
> IO to complete, but is regularly woken in tail-pushing situations.
> In severe cases, the xfsaild is getting woken tens of thousands of
> times a second. Reduce the number needless wakeups by only waking
> the xfsaild if the new target is larger than the old one. Further
> make short sleeps uninterruptible as they occur when the xfsaild has
> decided it needs to back off to allow some IO to complete and being
> woken early is counter-productive.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/linux-2.6/xfs_super.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 6cbebb2..8546805 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -834,8 +834,11 @@ xfsaild_wakeup(
>  	struct xfs_ail		*ailp,
>  	xfs_lsn_t		threshold_lsn)
>  {
> -	ailp->xa_target = threshold_lsn;
> -	wake_up_process(ailp->xa_task);
> +	/* only ever move the target forwards */
> +	if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0) {
> +		ailp->xa_target = threshold_lsn;
> +		wake_up_process(ailp->xa_task);
> +	}
>  }
>  
>  STATIC int
> @@ -847,8 +850,17 @@ xfsaild(
>  	long		tout = 0; /* milliseconds */
>  
>  	while (!kthread_should_stop()) {
> -		schedule_timeout_interruptible(tout ?
> -				msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
> +		/*
> +		 * for short sleeps indicating congestion, don't allow us to
> +		 * get woken early. Otherwise all we do is bang on the AIL lock
> +		 * without making progress.
> +		 */
> +		if (tout && tout <= 20)
> +			__set_current_state(TASK_KILLABLE);
> +		else
> +			__set_current_state(TASK_UNINTERRUPTIBLE);
> +		schedule_timeout(tout ?
> +				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
>  
>  		/* swsusp */
>  		try_to_freeze();
> -- 
> 1.7.2.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
