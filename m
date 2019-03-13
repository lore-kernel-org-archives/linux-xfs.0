Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36762 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfCMSoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Mar 2019 14:44:00 -0400
Date: Wed, 13 Mar 2019 11:43:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xlog_grant_head_wait deadlocks on high-rolling transactions?
Message-ID: <20190313184342.GJ4359@magnolia>
References: <20190312181825.GH4359@magnolia>
 <20190313174330.GB58708@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313174330.GB58708@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Wed, Mar 13, 2019 at 01:43:30PM -0400, Brian Foster wrote:
> On Tue, Mar 12, 2019 at 11:18:25AM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Does anyone /else/ occasionally see fstests hang with a hojillion
> > threads stuck in xlog_grant_head_wait?  I periodically see xfs/347 hang
> > with a hojillion threads stuck in:
> > 
> > kworker/0:214   D13120 26117      2 0x80000000
> > Workqueue: xfs-conv/sdf xfs_end_io [xfs]
> > Call Trace:
> >  schedule+0x36/0x90
> >  xlog_grant_head_wait+0x66/0x450 [xfs]
> >  xlog_grant_head_check+0xf0/0x170 [xfs]
> >  xfs_log_reserve+0x166/0x500 [xfs]
> >  xfs_trans_reserve+0x1ac/0x2b0 [xfs]
> >  xfs_trans_alloc+0xda/0x220 [xfs]
> >  xfs_reflink_end_cow_extent+0xda/0x3a0 [xfs]
> >  xfs_reflink_end_cow+0x92/0x2a0 [xfs]
> >  xfs_end_io+0xd0/0x120 [xfs]
> >  process_one_work+0x252/0x600
> >  worker_thread+0x3d/0x390
> >  kthread+0x11f/0x140
> >  ret_from_fork+0x24/0x30
> > 
> > Which is the end io worker stalled under xfs_trans_alloc trying to
> > reserve log space to remap extents from the COW fork to the data fork.
> > I also observe one thread stuck here:
> > 
> > kworker/0:215   D13120 26118      2 0x80000000
> > Workqueue: xfs-conv/sdf xfs_end_io [xfs]
> > Call Trace:
> >  schedule+0x36/0x90
> >  xlog_grant_head_wait+0x66/0x450 [xfs]
> >  xlog_grant_head_check+0xf0/0x170 [xfs]
> >  xfs_log_regrant+0x155/0x3b0 [xfs]
> >  xfs_trans_reserve+0xa5/0x2b0 [xfs]
> >  xfs_trans_roll+0x9c/0x190 [xfs]
> >  xfs_defer_trans_roll+0x16e/0x5b0 [xfs]
> >  xfs_defer_finish_noroll+0xf1/0x7e0 [xfs]
> >  __xfs_trans_commit+0x1c3/0x630 [xfs]
> >  xfs_reflink_end_cow_extent+0x285/0x3a0 [xfs]
> >  xfs_reflink_end_cow+0x92/0x2a0 [xfs]
> >  xfs_end_io+0xd0/0x120 [xfs]
> >  process_one_work+0x252/0x600
> >  worker_thread+0x3d/0x390
> >  kthread+0x11f/0x140
> >  ret_from_fork+0x24/0x30
> > 
> > This thread is stalled under xfs_trans_roll trying to reserve more log
> > space because it rolled more times than tr_write.tr_logcount
> > anticipated.  logcount = 8, but (having added a patch to trace log
> > tickets that roll more than logcount guessed) we actually roll these
> > end_cow transactions 10 times.
> > 
> 
> I've not seen this behavior myself, FWIW.

Yes, it takes quite a bit of load to make it reproduce, and even then
xfs/347 usually succeeds.

AFAICT the key ingredients here are (a) a small filesystem log relative
to (b) the number of endio items in the endio workqueue and (c) having
that endio workqueue spawn a lot of threads to satisfy all the requests.

In the case of xfs/347 the VM only has 4 CPUs, a 3GB XFS with a 10MB
log.  I see in the sysrq-t output:

 A. Several dozen kworker threads all stuck trying to allocate a new
    transaction as part of _reflink_end_cow,

 B. Probably around a dozen threads that successfully allocated the
    transaction and are now waiting for the ILOCK (also under _end_cow),

 C. And a single kworker in the midst of _end_cow that is trying to grab
    more reservation as part of xfs_defer_trans_roll, having taken the
    ILOCK.

> > I think the problem was introduced when we added the deferred AGFL log
> > item, because the bunmapi of the old data fork extent and the map_extent
> > of the new extent can both add separate deferred AGFL log items to the
> > defer chain.  It's also possible that I underestimated
> > XFS_WRITE_LOG_COUNT_REFLINK way back when.
> > 
> 
> Sounds plausible, but IIRC a rolling transaction isn't necessarily
> required to make the entire reservation up front. The initial
> reservation (regrant) size is essentially a tradeoff between minimizing
> the need to wait on additional log regrants in the common case vs.
> having a reasonably sized initial reservation.
> 
> Am I following correctly that you are reproducing a hard lockup and not
> necessarily stalls or otherwise similar performance problems?

It's not so hard of a lockup that I can't get into the VM to poke
around, but there are dozens of kworker threads all in D state with no
ongoing disk IO or CPU usage.

> If so, is
> the problem you're seeing that a long-running rolling transaction is
> essentially blocked on acquiring new reservation by new transaction
> reservations that have come in since the rolling transaction started,

Correct.

> and then those new transactions are somehow or another blocked on the
> rolling transaction(s) that cannot complete?

Right.  The (B) cases are waiting for (C) to release the ILOCK; the (A)
cases are waiting for (C) to release transaction space; and (C) is
waiting in line behind (A) and (B) for more transaction space.

To draw an oversimplified picture, imagine that we have enough log space
to handle 16 rolls of tr_write:

Log: ----------------
Waitlist: <empty>

Transaction 1 reserves 8 blocks, takes the ILOCK, and begins working:

L: 11111111-------
W: <empty>

Transaction 2 reserves 8 blocks, and blocks on the ILOCK:

L: 1111111122222222
W: <empty>

Now there's no more reservation space.  Transaction 3 tries to get 8
blocks but ends up on the wait list:

L: 1111111122222222
W: (3)

Transaction 4 suffers the same fate:

L: 1111111122222222
W: (3) (4)

Now transaction 1 runs its 9th roll and it needs more space, so it ends
up on the waitlist too:

L: 1111111122222222
W: (3) (4) (1)

Now we're dead in the water.

> > Either way, the xfs_trans_roll transaction wants (logres) more space,
> > and the xfs_trans_alloc transactions want (logres * logcount) space.
> > Unfortunately, the alloc transactions got to the grant waiter list
> > first, and there's not enough space for them, so the entire list waits.
> > There seems to be enough space to grant the rolling transaction its
> > smaller amount of space, so at least in theory that transaction could
> > finish (and release a lot of space) if it could be bumped to the head of
> > the waiter list.
> > 
> 
> I have to read through and page in the reservation code to make more
> sense of this whole issue, but I think it's an interesting idea to
> consider if it's possible to give an in-progress rolling transaction
> (that has run out of reservation) priority over new transaction
> allocations in the queue. That said, I'm still fuzzy on the underlying
> problem and so it's not clear if that's an ideal solution.

Same here. :)

> > Another way to solve this problem of course is to increase tr_logcount
> > from 8 to 10, though this could cause some user heartburn for small
> > filesystems because the minimum log size would increase.  However, I'm
> > not sure about the relative merits of either approach, so I'm kicking
> > this to the list for further input (while I go have lunch :P)
> > 
> 
> We may want to do that regardless if that's the ideal reservation, but
> if there's a deadlock involved I wouldn't necessarily consider that a
> fix for the underlying problem. We'd just be avoiding the case where a
> rolling transaction needs to acquire more reservation in these reflink
> contexts.

Right.

> We'd still be fundamentally susceptible to deadlocks if there
> are less common conditions where blocking regrants can occur, right?

Right.  The reflink remap code is a good example of one of those places,
but really, any time we have to ask for a log regrant with a lock held
we're asking for trouble, I think.

--D

> Brian
> 
> > The second problem I noticed is that the reflink cancel cow and reflink
> > remap functions follow the pattern of allocating one transaction and
> > rolling it for every extent it encounters.  This results in /very/ high
> > roll counts for the transaction, which (on a very busy system with a
> > smallish log) seems like it could land us right back in this deadlock.
> > I think the answer is to split those up to run one transaction per
> > extent (like I did for reflink end_cow), though I'd have to ensure that
> > we can drop the ILOCK safely to get a new transaction.
> > 
> > Thoughts?
> > 
> > --D
