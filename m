Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726503AbfCOLcY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Mar 2019 07:32:24 -0400
Date: Fri, 15 Mar 2019 07:32:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xlog_grant_head_wait deadlocks on high-rolling transactions?
Message-ID: <20190315113220.GA5182@bfoster>
References: <20190312181825.GH4359@magnolia>
 <20190313174330.GB58708@bfoster>
 <20190313184342.GJ4359@magnolia>
 <20190314223615.GI23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314223615.GI23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 15, 2019 at 09:36:15AM +1100, Dave Chinner wrote:
> On Wed, Mar 13, 2019 at 11:43:42AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 13, 2019 at 01:43:30PM -0400, Brian Foster wrote:
> > > On Tue, Mar 12, 2019 at 11:18:25AM -0700, Darrick J. Wong wrote:
> > > > Hi all,
> > > > 
> > > > Does anyone /else/ occasionally see fstests hang with a hojillion
> > > > threads stuck in xlog_grant_head_wait?  I periodically see xfs/347 hang
> > > > with a hojillion threads stuck in:
> > > > 
> > > > kworker/0:214   D13120 26117      2 0x80000000
> > > > Workqueue: xfs-conv/sdf xfs_end_io [xfs]
> > > > Call Trace:
> > > >  schedule+0x36/0x90
> > > >  xlog_grant_head_wait+0x66/0x450 [xfs]
> > > >  xlog_grant_head_check+0xf0/0x170 [xfs]
> > > >  xfs_log_reserve+0x166/0x500 [xfs]
> > > >  xfs_trans_reserve+0x1ac/0x2b0 [xfs]
> > > >  xfs_trans_alloc+0xda/0x220 [xfs]
> > > >  xfs_reflink_end_cow_extent+0xda/0x3a0 [xfs]
> > > >  xfs_reflink_end_cow+0x92/0x2a0 [xfs]
> > > >  xfs_end_io+0xd0/0x120 [xfs]
> > > >  process_one_work+0x252/0x600
> > > >  worker_thread+0x3d/0x390
> > > >  kthread+0x11f/0x140
> > > >  ret_from_fork+0x24/0x30
> > > > 
> > > > Which is the end io worker stalled under xfs_trans_alloc trying to
> > > > reserve log space to remap extents from the COW fork to the data fork.
> > > > I also observe one thread stuck here:
> > > > 
> > > > kworker/0:215   D13120 26118      2 0x80000000
> > > > Workqueue: xfs-conv/sdf xfs_end_io [xfs]
> > > > Call Trace:
> > > >  schedule+0x36/0x90
> > > >  xlog_grant_head_wait+0x66/0x450 [xfs]
> > > >  xlog_grant_head_check+0xf0/0x170 [xfs]
> > > >  xfs_log_regrant+0x155/0x3b0 [xfs]
> > > >  xfs_trans_reserve+0xa5/0x2b0 [xfs]
> > > >  xfs_trans_roll+0x9c/0x190 [xfs]
> > > >  xfs_defer_trans_roll+0x16e/0x5b0 [xfs]
> > > >  xfs_defer_finish_noroll+0xf1/0x7e0 [xfs]
> > > >  __xfs_trans_commit+0x1c3/0x630 [xfs]
> > > >  xfs_reflink_end_cow_extent+0x285/0x3a0 [xfs]
> > > >  xfs_reflink_end_cow+0x92/0x2a0 [xfs]
> > > >  xfs_end_io+0xd0/0x120 [xfs]
> > > >  process_one_work+0x252/0x600
> > > >  worker_thread+0x3d/0x390
> > > >  kthread+0x11f/0x140
> > > >  ret_from_fork+0x24/0x30
> > > > 
> > > > This thread is stalled under xfs_trans_roll trying to reserve more log
> > > > space because it rolled more times than tr_write.tr_logcount
> > > > anticipated.  logcount = 8, but (having added a patch to trace log
> > > > tickets that roll more than logcount guessed) we actually roll these
> > > > end_cow transactions 10 times.
> > > > 
> > > 
> > > I've not seen this behavior myself, FWIW.
> > 
> > Yes, it takes quite a bit of load to make it reproduce, and even then
> > xfs/347 usually succeeds.
> > 
> > AFAICT the key ingredients here are (a) a small filesystem log relative
> > to (b) the number of endio items in the endio workqueue and (c) having
> > that endio workqueue spawn a lot of threads to satisfy all the requests.
> > 
> > In the case of xfs/347 the VM only has 4 CPUs, a 3GB XFS with a 10MB
> > log.  I see in the sysrq-t output:
> > 
> >  A. Several dozen kworker threads all stuck trying to allocate a new
> >     transaction as part of _reflink_end_cow,
> > 
> >  B. Probably around a dozen threads that successfully allocated the
> >     transaction and are now waiting for the ILOCK (also under _end_cow),
> > 
> >  C. And a single kworker in the midst of _end_cow that is trying to grab
> >     more reservation as part of xfs_defer_trans_roll, having taken the
> >     ILOCK.
> 
> Log space deadlock. Basically the problem here is that we're
> trying to grant more log space for an ongoing transaction, but there
> are already transactions waiting on grant space so we sleep behind
> them. (Ah, reading later I see this is understood.)
> 
> And we are doing that holding an inode lock, which is technically an
> illegal thing to be doing when calling xfs_trans_reserve() because
> it can cause object lock deadlocks like this, but is something we
> allow permanent transactions to do internally when rolling because
> the locked objects are logged in every roll and so won't pin the
> tail of the lock and so the rolling transaction won't ever
> self-deadlock on log space.
> 
> However, in this case we have multiple IO completions
> pending for a single inode, and when one completion blocks the
> workqueue spawns another thread, issues the next completion, which
> allocates another transaction and then blocks again. And ti keeps
> going until it runs out of IO completions on that inode, essentially
> consuming log grant space for no good reason.
> 

Ok, so from the perspective of log reservation Darrick's scenario above
means we have a single transaction rolling and blocked on space, a bunch
of other allocated transactions blocked on locks and then however many
more transacation allocations blocked on log space. The rolling
transaction is queued behind the whole lot.

This is all fine until we consider that the set of allocated
transactions blocked on inode locks 1. consume the majority of available
log space and 2. all depend on the (blocked) rolling transaction to
complete to acquire the lock. IOW, if that set of allocated transactions
were associated with different inodes, the rolling transaction may still
block on log space but it will eventually make its way through the log
reservation queue as the other active transactions complete.

> Fundamentally, what we are doing wrong here is trying to run single
> threaded work concurrently. i.e. trying to process completions for a
> single inode in parallel and so we hold N transaction reservations
> where only one can be used at a time. it seems to me like we need to
> probably need to serialise per-inode xfs_reflink_end_cow calls
> before we take transation reservations so we don't end up with io
> completions self deadlocking in cases like this.
> 

That makes sense and sounds like the most appropriate change to me.

> I don't think there is a cross-inode completion deadlock here - each
> inode can block waiting for log space in IO completion as long as
> other transactions keep making progress and freeing log space. The
> issue here is all log space is taken by the inode that needs more
> log space to make progress. hence I suspect serialising (and then
> perhaps aggregating sequential pending completions) per-inode IO
> completion is the right thing to do here...
> 

Indeed. Even if we had one allocated, inode dependent transaction
blocked on the rolling transaction, that shouldn't be enough to trigger
a log deadlock..

> > > > Unfortunately, the alloc transactions got to the grant waiter list
> > > > first, and there's not enough space for them, so the entire list waits.
> > > > There seems to be enough space to grant the rolling transaction its
> > > > smaller amount of space, so at least in theory that transaction could
> > > > finish (and release a lot of space) if it could be bumped to the head of
> > > > the waiter list.
> > > > 
> > > 
> > > I have to read through and page in the reservation code to make more
> > > sense of this whole issue, but I think it's an interesting idea to
> > > consider if it's possible to give an in-progress rolling transaction
> > > (that has run out of reservation) priority over new transaction
> > > allocations in the queue. That said, I'm still fuzzy on the underlying
> > > problem and so it's not clear if that's an ideal solution.
> > 
> > Same here. :)
> 
> Yes, that crossed my mind too, but I think it's an orthogonal issue.
> AFAICT the real problem here is allocating resources to do things
> concurrently when there is no possibility of concurrent processing,
> and that is exhausting the resource pool needed to make forwards
> progress...
> 

Agreed.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
