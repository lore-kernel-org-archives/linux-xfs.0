Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8BUbkH096266 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 05:30:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8B7513985BA
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 03:32:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id U1B4QuNMu5hpn67P for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 03:32:04 -0800 (PST)
Date: Mon, 8 Nov 2010 06:32:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/16] xfs: reduce the number of AIL push wakeups
Message-ID: <20101108113204.GB7654@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-14-git-send-email-david@fromorbit.com>
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

>  STATIC int
> @@ -850,8 +853,17 @@ xfsaild(
>  	long		tout = 0; /* milliseconds */
>  
>  	while (!kthread_should_stop()) {
> -		schedule_timeout_interruptible(tout ?
> +		/*
> +		 * for short sleeps indicating congestion, don't allow us to
> +		 * get woken early. Otherwise all we do is bang on the AIL lock
> +		 * without making progress.
> +		 */
> +		if (tout && tout <= 20) {
> +			schedule_timeout_uninterruptible(msecs_to_jiffies(tout));
> +		} else {
> +			schedule_timeout_interruptible(tout ?
>  				msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
> +		}

How about just setting the state ourselves and calling schedule_timeout?
That seems a lot more readable to me.  Also we can switch to
TASK_KILLABLE for the short sleeps, just to not introduce any delay
in shutting down aild when kthread_stop is called.  It would look
something like this:

		if (tout && tout <= 20)
			__set_current_state(TASK_KILLABLE);
		else
			__set_current_state(TASK_UNINTERRUPTIBLE);
		schedule_timeout(tout ?
				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
