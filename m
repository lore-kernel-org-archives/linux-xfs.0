Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8NoIsA124980 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:50:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7C0F16417C
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:51:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	OIqwESW8HZZHaFGn for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 15:51:44 -0800 (PST)
Date: Tue, 9 Nov 2010 10:51:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/16] xfs: reduce the number of AIL push wakeups
Message-ID: <20101108235142.GV2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-14-git-send-email-david@fromorbit.com>
	<20101108113204.GB7654@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101108113204.GB7654@infradead.org>
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

On Mon, Nov 08, 2010 at 06:32:04AM -0500, Christoph Hellwig wrote:
> >  STATIC int
> > @@ -850,8 +853,17 @@ xfsaild(
> >  	long		tout = 0; /* milliseconds */
> >  
> >  	while (!kthread_should_stop()) {
> > -		schedule_timeout_interruptible(tout ?
> > +		/*
> > +		 * for short sleeps indicating congestion, don't allow us to
> > +		 * get woken early. Otherwise all we do is bang on the AIL lock
> > +		 * without making progress.
> > +		 */
> > +		if (tout && tout <= 20) {
> > +			schedule_timeout_uninterruptible(msecs_to_jiffies(tout));
> > +		} else {
> > +			schedule_timeout_interruptible(tout ?
> >  				msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
> > +		}
> 
> How about just setting the state ourselves and calling schedule_timeout?
> That seems a lot more readable to me.  Also we can switch to
> TASK_KILLABLE for the short sleeps, just to not introduce any delay
> in shutting down aild when kthread_stop is called.  It would look
> something like this:
> 
> 		if (tout && tout <= 20)
> 			__set_current_state(TASK_KILLABLE);
> 		else
> 			__set_current_state(TASK_UNINTERRUPTIBLE);
> 		schedule_timeout(tout ?
> 				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);

Yes, seems reasonable. I'll convert it to do this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
