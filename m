Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61577 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730333AbfC0BF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 21:05:58 -0400
Date: Wed, 27 Mar 2019 12:05:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190327010552.GF23020@dastard>
References: <20190320050408.GA24923@magnolia>
 <20190320170305.GA29010@bfoster>
 <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
 <20190321121152.GA33001@bfoster>
 <20190321211051.GV23020@dastard>
 <20190326171324.GA58320@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326171324.GA58320@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 26, 2019 at 01:13:24PM -0400, Brian Foster wrote:
> On Fri, Mar 22, 2019 at 08:10:51AM +1100, Dave Chinner wrote:
> ...
> > 
> > So given that inode reclaim already waits for inodes to be unpinned
> > and there is a xfs_buf_unpin_wait() call in
> > xfs_bwrite()->xfs_buf_submit() path that will issue a log force on
> > the buffer from the inode reclaim path, we don't actually need the
> > log force in xfs_iflush() at all. i.e.  the AIL will capture the
> > buffer state and unpin inode and dquot buffers automatically, and so
> > we can simply remove the pinned-buffer log forces from the
> > inode/dquot flush code....
> > 
> 
> Hmm, where is the log force you reference above in the inode reclaim (->
> xfs_bwrite()) path if the buffer happens to be pinned? I see the
> xfs_buf_wait_unpin() in the submit path, but that just waits on the pin
> count (which I think is safe). It actually looks to me that reclaim
> could be susceptible to the write delay problem you referenced earlier
> in this thread without the log force from xfs_iflush()..

I was thinking that the unpin wait code issued the log force.
Oh, we only issue a log force in xfs_iunpin_wait(), not in the
xfs_buf_wait_unpin(). Ugh. My mistake.

As for the write delay problem, it's entire possible that this could
occur, but I have no evidence that it is actually a problem for
reclaim - I have only ever found reclaim blocking waiting on IO in
synchronous reclaim, never blocking on buffer unpin waits in async
reclaim. That's not to say it doesn't happen, I've just never seen
it and I've been looking at inode reclaim blocking vectors quite a
lot in the past couple of years....

> It also occurs to me that the xfs_iflush() log force isn't blocking
> because it's a a sync force, but rather because there is already a CIL
> push in progress. The flush_work() call basically means that a non-sync
> force can either queue a workqueue job and return or turn somewhat
> synchronous by waiting for whatever push happens to be in progress.

xfs_log_force() isn't a non-blocking operation - it is supposed to
write and dispatch all the pending changes in memory. If
XFS_LOG_SYNC is not set then it does not wait for IO completion - it
is expected that the caller will then wait on whatever it needs
unpinning, not wait for everything in the log flush to be completed.
e.g. this is why xfs_iunpin_wait() does not use XFS_LOG_SYNC - we
only need to wait for the inode to be unpinned, not everything in
the log.

> That
> implies another potential workaround could be to find a way around this
> sync behavior (assuming that would be fundamentally more simple than
> just avoiding log forces entirely while holding non-transactional buffer
> locks).

Or we can just remove it altogether and put the necessary log forces
in the callers where the buffer is no longer held.

> Of course that assumes there aren't other variants of this. I still need
> to poke around more to get a better idea of the scope. One that looks
> like a possibility to me right now is the xfs_iflush_cluster() ->
> xfs_force_shutdown() -> xfs_log_force() sequence (in the event of a

The xfs_iflush_cluster error handling has always been full of
shutdown-related bugs.

xfs_iflush() gets this buffer-vs-shutdown ordering right, but if
it's ok to just release the buffer with the inode still attached to
it in the xfs_iflush() case, then why isn't it ok to do exactly the
same thing in xfs_iflush_cluster()?

Oh, it's because the xfs_iflush() error handling doesn't need to
remove the inode from the buffer to get a reference to it to call
xfs_iflush_abort() to remove the inode from the AIL.

IOWs, I think xfs_iflush_cluster() should really be doing the same
thing - pull the list of inodes off the buffer, release the buffer,
trigger a shutdown, then call xfs_iflush_abort() on each of those
inodes....

> corrupt in-core inode on the same pinned buffer) down in the same iflush
> path. Another could be in xfs_trans_read_buf_map() where if we somehow
> grab a dirty+pinned buffer with b_error set, we can issue a shutdown if
> the transaction is dirty before we release the failed buffer.

Again, that would be indicative of a bug somewhere else. A buffer
found by a buffer should not be pinned and dirty in memory with a
b_error value on it.  Whatever recorded the error should have
processed and cleared the error, marked the buffer as stale, and/or
shut down the filesystem, not left it it in cache for someone else
to trip over.

e.g. see xfs_buf_iodone_callback_error(). If it's a transient error,
it clears b_error before it returns. If it's a permanent error, it
shuts down the filesystem and stales the buffer and so it will not
ever be seen again on lookup.

i.e. The code in xfs_trans_read_buf_map() is detecting physical read
IO errors bringing new metadata into the cache and reacting
appropriately. Clean transactions can back out gracefully, while
dirty transactions will trigger a shutdown during cancellation
anyway, so the early shutdown is just a way of ensuring we error
out appropriately. Maybe all the callers get the error handling
right, and if that is the case the we can remove the shutdowns from
xfs_trans_read_buf_map() altogether.....

> That
> combination of events should probably never happen (and the vector is
> probably closed by just releasing the buffer before the shutdown), but
> it kind of illustrates the potential for whack-a-mole with log forces
> and shutdown calls scattered around in so many places.. :/

If we end up in this kind of "whack-a-mole" scenario, it indicates
we have other bugs that need fixing. Calling xfs_force_shutdown()
holding inappropriate locks is a bug that should be fixed; changing
how xfs_log_force() works is a much more risky proposition than
fixing the callers that aren't safe...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
