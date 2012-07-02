Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q628Tumw190336 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 03:29:56 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4zvsLXi5SkJCHPlK for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 01:29:54 -0700 (PDT)
Date: Mon, 2 Jul 2012 18:29:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120702082952.GR19223@dastard>
References: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
	<20120702070502.GA25568@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120702070502.GA25568@infradead.org>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Jul 02, 2012 at 03:05:02AM -0400, Christoph Hellwig wrote:
> >  			__set_current_state(TASK_KILLABLE);
> >  		else
> >  			__set_current_state(TASK_INTERRUPTIBLE);
> > -		schedule_timeout(tout ?
> > -				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
> > +
> > +		spin_lock(&ailp->xa_lock);
> > +
> > +		/*
> > +		 * Idle if the AIL is empty and we are not racing with a target
> > +		 * update. We check the AIL after we set the task to a sleep
> > +		 * state to guarantee that we either catch an xa_target update
> > +		 * or that a wake_up resets the state to TASK_RUNNING.
> > +		 * Otherwise, we run the risk of sleeping indefinitely.
> > +		 *
> > +		 * The barrier matches the xa_target update in xfs_ail_push().
> > +		 */
> > +		smp_rmb();
> > +		if (!xfs_ail_min(ailp) &&
> > +		    ailp->xa_target == ailp->xa_target_prev) {
> > +			spin_unlock(&ailp->xa_lock);
> > +			schedule();
> > +			tout = 0;
> > +			continue;
> > +		}
> 
> I still don't like this at all all - we have one place to do all the
> timeout decisions, and that is and then end of xfsaild_push.  Splitting
> this decision over two functions makes the code a lot harder to
> understand and maintain over the long run.

The timeout decision is separate to idling, though - the idle check
has to be done when we are already in
TASK_INTERRUPTIBLE/TASK_KILLABLE state. If we do the check before
changing the task state, we can miss wakeups when the target is
changed between the "are we really idle" check and the schedule()
call because the wakeup is ignored if the task is still in the
running state.

> That doesn't mean I don't like the algorithm behind this patch, it just
> needs to move into the right place.

I'm not sure it can be moved into xfsaild_push and still be nice and
clean because of the above requirement...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
