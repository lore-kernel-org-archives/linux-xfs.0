Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKBhqge152829 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 05:43:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BCBA16293CF
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 03:43:48 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FDfQdCtbJo6XBsrr for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 03:43:48 -0800 (PST)
Date: Sun, 20 Nov 2011 06:43:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Remove the entries from the queue while waking them
	up.
Message-ID: <20111120114342.GA11278@infradead.org>
References: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
	<20111119181929.GA25739@infradead.org>
	<20111120082235.GN7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111120082235.GN7046@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Chandra Seetharaman <sekharan@us.ibm.com>, XFS Mailing List <xfs@oss.sgi.com>

On Sun, Nov 20, 2011 at 07:22:35PM +1100, Dave Chinner wrote:
> Be nice to factor these into a single function - they do exactly the
> same thing except for the queue they walk and the need_bytes
> calculation.

I thought about it, and I think we can do it as a broader refactoring
of the two list/lock/head tuples for the reserve/grant queues.  But
I'd rather do a simple minimal patch that can easily be backported
first.

> 
> > +
> >  void
> >  xfs_log_move_tail(xfs_mount_t	*mp,
> >  		  xfs_lsn_t	tail_lsn)
> 
> Also, wouldn't it be a good idea to use these helpers in
> xfs_log_move_tail() and remove the code duplication from there as
> well? i.e. the four places we do this open coded wakeup walk could
> be replaced with a single implementation....

Yes, I even hinted at that in the changelog.  To make it not ugly
it requires removing the opportunistic wakers.  Fortunately I already
have patches for that, which I plan to sumit for 3.3.  We an easily
do that factoring as part of that patchset.

> Same with this function and xlog_writeq_wait - they are identical
> code just operating on a different grant head. If we had
> 
> struct xlog_grant_head {
> 	spinlock_t	lock;
> 	struct list_head queue;
> 	atomic64_t	head;
> };
> 
> Rather than the current open-coded definitions, then this could all
> share the same code rather than continuing to duplicate it. If we've
> got to restructure the code to fix the bug, it makes sense to me to
> remove the code duplication as well...

I agree.  But let's fix the issue first and to the cleanups later.

> .....
> >  	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
> > +	if (!list_empty_careful(&log->l_reserveq)) {
> >  		spin_lock(&log->l_grant_reserve_lock);
> .....
> > +		if (!xlog_wake_reserveq(log, free_bytes))
> > +			error = xlog_reserveq_wait(log, tic, need_bytes);
> > +		spin_unlock(&log->l_grant_reserve_lock);
> > +	} else if (free_bytes < need_bytes) {
> >  		spin_lock(&log->l_grant_reserve_lock);
> > -		list_del_init(&tic->t_queue);
> > +		error = xlog_reserveq_wait(log, tic, need_bytes);
> >  		spin_unlock(&log->l_grant_reserve_lock);
> >  	}
> 
> I don't think this logic is quite correct. When we have a waiter on
> the queue, we try to wake all the waiters before sleeping if that
> did not succeed. If we woke everyone, we allow this process to
> continue. The problem is that we don't check to see if there is
> space remaining for this process to continue after doing all the
> wakeups.
> 
> i.e. if need_bytes = 10000 and free_bytes = 50000, and the waiters
> on the queue total 45000 bytes, then we fall through with free_bytes
> = 5000 and need_bytes = 10000. In that case, we should have gone to
> sleep because we are 5000 bytes short of our required space but we
> don't and potentially deadlock due to oversubscribing the log space.
> 
> IOWs, xlog_wake_reserveq() needs to return the amount of remaining
> free space after the wakeups so we can then run the if (free_bytes <
> need_bytes) check unconditionally....

Indeed.  I think the better way to do it is to make the free_bytes in
xlog_wake_reserveq a pointer, so that the caller sees the update and
then do:


 	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
	if (!list_empty_careful(&log->l_reserveq)) {
 		spin_lock(&log->l_grant_reserve_lock);
		if (!xlog_wake_reserveq(log, &free_bytes) ||
		    free_bytes < need_bytes)
			error = xlog_reserveq_wait(log, tic, need_bytes);
		spin_unlock(&log->l_grant_reserve_lock);
	} else if (free_bytes < need_bytes) {
 		spin_lock(&log->l_grant_reserve_lock);
		list_del_init(&tic->t_queue);
		error = xlog_reserveq_wait(log, tic, need_bytes);
  		spin_unlock(&log->l_grant_reserve_lock);
  	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
