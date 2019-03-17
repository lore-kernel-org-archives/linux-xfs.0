Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:39447 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbfCQWae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Mar 2019 18:30:34 -0400
Date: Mon, 18 Mar 2019 09:30:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_grant_head_wait deadlocks on high-rolling transactions?
Message-ID: <20190317223029.GN23020@dastard>
References: <20190312181825.GH4359@magnolia>
 <20190313174330.GB58708@bfoster>
 <20190313184342.GJ4359@magnolia>
 <20190314223615.GI23020@dastard>
 <20190315113220.GA5182@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315113220.GA5182@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 15, 2019 at 07:32:21AM -0400, Brian Foster wrote:
> On Fri, Mar 15, 2019 at 09:36:15AM +1100, Dave Chinner wrote:
> > On Wed, Mar 13, 2019 at 11:43:42AM -0700, Darrick J. Wong wrote:
> > > On Wed, Mar 13, 2019 at 01:43:30PM -0400, Brian Foster wrote:
> > > > On Tue, Mar 12, 2019 at 11:18:25AM -0700, Darrick J. Wong wrote:
> > > > > This thread is stalled under xfs_trans_roll trying to reserve more log
> > > > > space because it rolled more times than tr_write.tr_logcount
> > > > > anticipated.  logcount = 8, but (having added a patch to trace log
> > > > > tickets that roll more than logcount guessed) we actually roll these
> > > > > end_cow transactions 10 times.
> > > > > 
> > > > 
> > > > I've not seen this behavior myself, FWIW.
> > > 
> > > Yes, it takes quite a bit of load to make it reproduce, and even then
> > > xfs/347 usually succeeds.
> > > 
> > > AFAICT the key ingredients here are (a) a small filesystem log relative
> > > to (b) the number of endio items in the endio workqueue and (c) having
> > > that endio workqueue spawn a lot of threads to satisfy all the requests.
> > > 
> > > In the case of xfs/347 the VM only has 4 CPUs, a 3GB XFS with a 10MB
> > > log.  I see in the sysrq-t output:
> > > 
> > >  A. Several dozen kworker threads all stuck trying to allocate a new
> > >     transaction as part of _reflink_end_cow,
> > > 
> > >  B. Probably around a dozen threads that successfully allocated the
> > >     transaction and are now waiting for the ILOCK (also under _end_cow),
> > > 
> > >  C. And a single kworker in the midst of _end_cow that is trying to grab
> > >     more reservation as part of xfs_defer_trans_roll, having taken the
> > >     ILOCK.
> > 
> > Log space deadlock. Basically the problem here is that we're
> > trying to grant more log space for an ongoing transaction, but there
> > are already transactions waiting on grant space so we sleep behind
> > them. (Ah, reading later I see this is understood.)
> > 
> > And we are doing that holding an inode lock, which is technically an
> > illegal thing to be doing when calling xfs_trans_reserve() because
> > it can cause object lock deadlocks like this, but is something we
> > allow permanent transactions to do internally when rolling because
> > the locked objects are logged in every roll and so won't pin the
> > tail of the lock and so the rolling transaction won't ever
> > self-deadlock on log space.
> > 
> > However, in this case we have multiple IO completions
> > pending for a single inode, and when one completion blocks the
> > workqueue spawns another thread, issues the next completion, which
> > allocates another transaction and then blocks again. And ti keeps
> > going until it runs out of IO completions on that inode, essentially
> > consuming log grant space for no good reason.
> > 
> 
> Ok, so from the perspective of log reservation Darrick's scenario above
> means we have a single transaction rolling and blocked on space, a bunch
> of other allocated transactions blocked on locks and then however many
> more transacation allocations blocked on log space. The rolling
> transaction is queued behind the whole lot.
> 
> This is all fine until we consider that the set of allocated
> transactions blocked on inode locks 1. consume the majority of available
> log space and 2. all depend on the (blocked) rolling transaction to
> complete to acquire the lock. IOW, if that set of allocated transactions
> were associated with different inodes, the rolling transaction may still
> block on log space but it will eventually make its way through the log
> reservation queue as the other active transactions complete.

Yes, that is the case here.

> > Fundamentally, what we are doing wrong here is trying to run single
> > threaded work concurrently. i.e. trying to process completions for a
> > single inode in parallel and so we hold N transaction reservations
> > where only one can be used at a time. it seems to me like we need to
> > probably need to serialise per-inode xfs_reflink_end_cow calls
> > before we take transation reservations so we don't end up with io
> > completions self deadlocking in cases like this.
> > 
> 
> That makes sense and sounds like the most appropriate change to me.
> 
> > I don't think there is a cross-inode completion deadlock here - each
> > inode can block waiting for log space in IO completion as long as
> > other transactions keep making progress and freeing log space. The
> > issue here is all log space is taken by the inode that needs more
> > log space to make progress. hence I suspect serialising (and then
> > perhaps aggregating sequential pending completions) per-inode IO
> > completion is the right thing to do here...
> > 
> 
> Indeed. Even if we had one allocated, inode dependent transaction
> blocked on the rolling transaction, that shouldn't be enough to trigger
> a log deadlock..

*nod*

It's worth noting that we don't have any specific mechanism in place
to prevent userspace driven transactions from tripping over the same
problem. However, most user metadata operations that have really
large transaction reservations (e.g. truncate, fallocate) on files
require taking the IO lock prior to making the transaction
reservation, whilst most of the others are serialised at the VFS
level (e.g. via the i_rwsem == IOLOCK).  Hence the userspace-driven
transaction reservations per inode are generally serialised via
higher level locks and so this problem is largely avoided in general
day-to-day userspace operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
