Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04FFQnM124297 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 09:15:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3848F1C28A28
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 07:16:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LwgOgzIWfbm5DbtY for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2010 07:16:16 -0800 (PST)
Date: Mon, 4 Jan 2010 10:16:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] XFS: Don't wake the aild once per second
Message-ID: <20100104151616.GB24810@infradead.org>
References: <1262400215-19443-1-git-send-email-david@fromorbit.com>
	<1262400215-19443-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262400215-19443-2-git-send-email-david@fromorbit.com>
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

On Sat, Jan 02, 2010 at 01:43:34PM +1100, Dave Chinner wrote:
> Now that the AIL push algorithm is traversal safe, we don't need a
> watchdog function in the xfsaild to catch pushes that fail to make
> progress. Remove the watchdog timeout and make pushes purely driven
> by demand. This will remove the once-per-second wakeup that is seen
> when the filesystem is idle and make laptop power misers happy.

Looks good, but a few nitpicks below:

> -	long		tout = 0;
> +	long		tout = 1000; /* milliseconds */

Why do we use a timeout when starting up now?  If there's a good reason
for it the reason at least should be explained in a comment here.

>  	while (!kthread_should_stop()) {
> -		if (tout)
> -			schedule_timeout_interruptible(msecs_to_jiffies(tout));
> -		tout = 1000;
> +		tout = !tout ? MAX_SCHEDULE_TIMEOUT : msecs_to_jiffies(tout);

Why not just:

		schedule_timeout_interruptible(tout ?
				msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);

that avoids the assignment of different units to the same variable, and
also the negation.

> +	long		tout = 0;
>  	xfs_lsn_t	last_pushed_lsn = *last_lsn;
>  	xfs_lsn_t	target =  ailp->xa_target;
>  	xfs_lsn_t	lsn;
> @@ -279,7 +280,6 @@ xfsaild_push(
>  	 * prevents use from spinning when we can't do anything or there is
>  	 * lots of contention on the AIL lists.
>  	 */
> -	tout = 10;
>  	lsn = lip->li_lsn;
>  	flush_log = stuck = count = 0;
>  	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
> @@ -376,14 +376,14 @@ xfsaild_push(
>  
>  	if (!count) {
>  		/* We're past our target or empty, so idle */
> -		tout = 1000;
> +		tout = 0;

tout always is 0 here already.


>  	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
>  		/*
>  		 * We reached the target so wait a bit longer for I/O to
>  		 * complete and remove pushed items from the AIL before we
>  		 * start the next scan from the start of the AIL.
>  		 */
> -		tout += 20;
> +		tout = 50;
>  		last_pushed_lsn = 0;
>  	} else if ((stuck * 100) / count > 90) {
>  		/*
> @@ -395,11 +395,14 @@ xfsaild_push(
>  		 * Backoff a bit more to allow some I/O to complete before
>  		 * continuing from where we were.
>  		 */
> -		tout += 10;
> +		tout = 20;
> +	} else {
> +		/* more to do, but wait a short while before continuing */
> +		tout = 10;
>  	}
>  	*last_lsn = last_pushed_lsn;
>  	return tout;
> -}	/* xfsaild_push */
> +}

All the += and co here is a bit confusing.  We always return 0 now
except for those last two cases that return 20 or 10.  So I'd just
change them to a tout = 10/20;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
