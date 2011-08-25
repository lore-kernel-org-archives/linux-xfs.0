Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7PNl2MM256880 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 18:47:03 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9D7B117DB5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 16:47:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SPNwWq6IhDyvvX3d for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 16:47:00 -0700 (PDT)
Date: Fri, 26 Aug 2011 09:46:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: convert xfsbufd to use a workqueue
Message-ID: <20110825234656.GS3162@dastard>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
	<1314256626-11136-7-git-send-email-david@fromorbit.com>
	<1314305839.3136.104.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314305839.3136.104.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 25, 2011 at 03:57:19PM -0500, Alex Elder wrote:
> On Thu, 2011-08-25 at 17:17 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > There is no reason we need a thread per filesystem to do the
> > flushing of the delayed write buffer queue. This can be easily
> > handled by a global concurrency managed workqueue.
> > 
> > Convert the delayed write buffer handling to use workqueues and
> > workqueue flushes to implement buffer writeback by embedding a
> > delayed work structure into the struct xfs_buftarg and using that to
> > control flushing.  This greatly simplifes the process of flushing
> > and also removes a bunch of duplicated code between buftarg flushing
> > and delwri buffer writeback.
> 
> I point out one bug below.  I also question one of the
> changes and have some suggestions.  I'd like to see this
> updated and get another chance to review the result.
> 
> 					-Alex
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c       |  165 ++++++++++++++++++++----------------------------
> >  fs/xfs/xfs_buf.h       |    5 +-
> >  fs/xfs/xfs_dquot.c     |    1 -
> >  fs/xfs/xfs_trans_ail.c |    2 +-
> >  4 files changed, 72 insertions(+), 101 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 410de9f..b1b8c0c 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> 
> . . .
> 
> > @@ -1407,8 +1407,9 @@ xfs_buf_delwri_queue(
> >  	}
> >  
> >  	if (list_empty(dwq)) {
> > -		/* start xfsbufd as it is about to have something to do */
> > -		wake_up_process(bp->b_target->bt_task);
> > +		/* queue a delayed flush as we are about to queue a buffer */
> > +		queue_delayed_work(xfs_buf_wq, &bp->b_target->bt_delwrite_work,
> > +			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
> 
> I think this should be done *after* the buffer has been
> added to the delayed work queue.  I realize there will be
> a small delay so it should be fine, but...  It also doesn't
> have to be done with bt_delwrite_lock held.

The reason it is done there is so we don't need a local variable to
store whether we need to queue work. The fact that the worker must
then first grab the bt_delwrite_lock before it will do anything
means that even if th worker runs immediately, it will block until
we've finished adding this item to the list and dropped the lock
so it really doesn't matter that we queue the work before adding the
buffer to the list. And the code is actually simpler doing it this way....

> 
> >  	}
> >  
> >  	bp->b_flags |= _XBF_DELWRI_Q;
> > @@ -1486,13 +1487,13 @@ STATIC int
> >  xfs_buf_delwri_split(
> >  	xfs_buftarg_t	*target,
> >  	struct list_head *list,
> > -	unsigned long	age)
> > +	unsigned long	age,
> > +	int		force)
> >  {
> >  	xfs_buf_t	*bp, *n;
> >  	struct list_head *dwq = &target->bt_delwrite_queue;
> >  	spinlock_t	*dwlk = &target->bt_delwrite_lock;
> >  	int		skipped = 0;
> > -	int		force;
> >  
> >  	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
> 
> You forgot to delete this line when you made "force" be
> an argument to this function.

Oops. So I did. I screwed that up when updating it after all the
recent xfs_buf.c changes. Will fix.

> I think if you delete this line all is well, but you
> need to test this.

Of course ;)

> > -	xfs_buf_runall_queues(xfsconvertd_workqueue);
> > -	xfs_buf_runall_queues(xfsdatad_workqueue);
> > -	xfs_buf_runall_queues(xfslogd_workqueue);
> > +	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
> > +	int		force = 0;
> >  
> > -	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
> > -	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
> > +	if (test_and_clear_bit(XBT_FORCE_FLUSH, &btp->bt_flags)) {
> > +		force = 1;
> > +		age = 0;
> > +	}
> 
> xfs_buf_delwri_split() ignores its "age" argument if "force"
> is set.  This function never uses "age" otherwise.  So the
> above can just be:
> 
> 	force = test_and_clear_bit(XBT_FORCE_FLUSH, &btp->bt_flags);

Ok.

> > +/*
> > + * Flush all the queued buffer work, then flush any remaining dirty buffers
> > + * and wait for them to complete. If there are buffers remaining on the delwri
> > + * queue, then they were pinned so couldn't be flushed. Return a value of 1 to
> > + * indicate that there were pinned buffers and the caller needs to retry the
> > + * flush.
> > + */
> > +int
> > +xfs_flush_buftarg(
> > +	xfs_buftarg_t	*target,
> > +	int		wait)
> 
> Since this function now ignores its "wait" argument,
> you could eliminate it, and perhaps get rid of the
> one (first) call in xfs_quiesce_fs() that passes 0.

I'll leave that to a another patch.

> 
> > +{
> > +	xfs_buf_runall_queues(xfsconvertd_workqueue);
> > +	xfs_buf_runall_queues(xfsdatad_workqueue);
> > +	xfs_buf_runall_queues(xfslogd_workqueue);
> > +
> > +	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
> > +	flush_delayed_work_sync(&target->bt_delwrite_work);
> > +
> > +	if (!list_empty(&target->bt_delwrite_queue))
> > +		return 1;
> > +	return 0;
>  
> Maybe just:
> 	return !list_empty(&target->bt_delwrite_queue);
> 
> (But I understand why you might prefer what you did.)

Yeah, I prefer the explict return values than having to work out
whether it is returning 0 or 1. Call me lazy. ;)

> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index db62959..1fb9d93 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1446,7 +1446,6 @@ xfs_qm_dqflock_pushbuf_wait(
> >  		if (xfs_buf_ispinned(bp))
> >  			xfs_log_force(mp, 0);
> >  		xfs_buf_delwri_promote(bp);
> > -		wake_up_process(bp->b_target->bt_task);
> 
> Why does this not need to be replaced with a
> flush_delayed_work() call?  Was this wake_up_process()
> not needed before?

The wake up that is done here is simply to cause the delwri buffer
queue to be flushed immediately, rather than wait for the next
timeout. The thing is that the xfsbufd can idle with no next defined
wakeup, so this was added to ensure the xfsbufd was woken and the
buffer flushed. xfs_qm_dqflock_pushbuf_wait, however, is
never called in a performance or latency critical path, so this
was purely defensive to ensure the xfsbufd was awake as I wasn't
certain I'd got everything right in the xfsbufd idling code.

With the workqueue changeover, I'm pretty certain that the delayed
workqueue processing will continue until the delwri queue is empty,
so tehre is no need for a defensive flush of it here - the dquot
buffer will get flushed in a short while now that it is at the head
of the delwri queue without needing to explicitly ensure the queue
is running...

> If that's the case it seems like
> that change is independent of the switch to work queues
> and should be done separately (first).

I don't think it is separable from the workqueue changeover...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
