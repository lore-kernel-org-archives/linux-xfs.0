Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfC0OON (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Mar 2019 10:14:13 -0400
Date: Wed, 27 Mar 2019 10:13:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190327141359.GB2882@bfoster>
References: <20190320050408.GA24923@magnolia>
 <20190320170305.GA29010@bfoster>
 <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
 <20190321121152.GA33001@bfoster>
 <20190321211051.GV23020@dastard>
 <20190326171324.GA58320@bfoster>
 <20190327010552.GF23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327010552.GF23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 27, 2019 at 12:05:52PM +1100, Dave Chinner wrote:
> On Tue, Mar 26, 2019 at 01:13:24PM -0400, Brian Foster wrote:
> > On Fri, Mar 22, 2019 at 08:10:51AM +1100, Dave Chinner wrote:
> > ...
> > > 
> > > So given that inode reclaim already waits for inodes to be unpinned
> > > and there is a xfs_buf_unpin_wait() call in
> > > xfs_bwrite()->xfs_buf_submit() path that will issue a log force on
> > > the buffer from the inode reclaim path, we don't actually need the
> > > log force in xfs_iflush() at all. i.e.  the AIL will capture the
> > > buffer state and unpin inode and dquot buffers automatically, and so
> > > we can simply remove the pinned-buffer log forces from the
> > > inode/dquot flush code....
> > > 
> > 
> > Hmm, where is the log force you reference above in the inode reclaim (->
> > xfs_bwrite()) path if the buffer happens to be pinned? I see the
> > xfs_buf_wait_unpin() in the submit path, but that just waits on the pin
> > count (which I think is safe). It actually looks to me that reclaim
> > could be susceptible to the write delay problem you referenced earlier
> > in this thread without the log force from xfs_iflush()..
> 
> I was thinking that the unpin wait code issued the log force.
> Oh, we only issue a log force in xfs_iunpin_wait(), not in the
> xfs_buf_wait_unpin(). Ugh. My mistake.
> 
> As for the write delay problem, it's entire possible that this could
> occur, but I have no evidence that it is actually a problem for
> reclaim - I have only ever found reclaim blocking waiting on IO in
> synchronous reclaim, never blocking on buffer unpin waits in async
> reclaim. That's not to say it doesn't happen, I've just never seen
> it and I've been looking at inode reclaim blocking vectors quite a
> lot in the past couple of years....
> 

Good info, thanks. So this is something we should at least be cognizant
of, but it sounds like it's not a critical or likely state for reclaim.

> > It also occurs to me that the xfs_iflush() log force isn't blocking
> > because it's a a sync force, but rather because there is already a CIL
> > push in progress. The flush_work() call basically means that a non-sync
> > force can either queue a workqueue job and return or turn somewhat
> > synchronous by waiting for whatever push happens to be in progress.
> 
> xfs_log_force() isn't a non-blocking operation - it is supposed to
> write and dispatch all the pending changes in memory. If
> XFS_LOG_SYNC is not set then it does not wait for IO completion - it
> is expected that the caller will then wait on whatever it needs
> unpinning, not wait for everything in the log flush to be completed.
> e.g. this is why xfs_iunpin_wait() does not use XFS_LOG_SYNC - we
> only need to wait for the inode to be unpinned, not everything in
> the log.
> 

Yes, I don't mean to imply it's nonblocking. I was thinking that the
case where we queue the CIL push could prevent the caller from blocking
on the force completion (even though we still wait on the commit
completion). Looking closer, I see that the CIL push is where we
actually abort the CIL context (xlog_cil_push() calls
xlog_cil_committed(..., XFS_LI_ABORTED)) and that occurs before the wake
of the commit completion, so the behavior would probably be the same
even without calling flush_work().

But the interesting thing to note here is that in the normal case,
xc_commit_wait is awoken after submission (at the tail end of
xlog_cil_push()) right when we assign ->commit_lsn. In the abort case,
xc_commit_wait is technically awoken after callback completion
processing in xlog_cil_committed(). This occurs after the
xfs_trans_committed_bulk() call and thus serializes on unpin processing
(where we need the buffer lock).

It's not clear to me why the wake is here. From the code, I assume it's
just to batch things into a single xc_push_lock critical section. We
need a wake somewhere of course because we haven't assigned a commit_lsn
in the abort case, but I wonder if without this particular ordering an
async log force would now be safe from deadlock. For example, if
xlog_cil_committed() awoke xc_commit_wait earlier, the CIL push could
unwind in parallel to the CIL context abort. It already doesn't wait on
log force completion because it's an async force (no XFS_LOG_SYNC), and
thus xfs_iflush() can unwind and (eventually) unlock the buffer. I.e.,
this would be safe for shutdown cases in the same general manner it's
currently safe for the non-shutdown case. Hmmm....

Darrick, since I haven't been able to reproduce this problem, could you
give the appended (untested) patch a try and let me know whether it
helps at all?

> > That
> > implies another potential workaround could be to find a way around this
> > sync behavior (assuming that would be fundamentally more simple than
> > just avoiding log forces entirely while holding non-transactional buffer
> > locks).
> 
> Or we can just remove it altogether and put the necessary log forces
> in the callers where the buffer is no longer held.
> 

Yep, that's what I meant by just avoiding the situation entirely..

> > Of course that assumes there aren't other variants of this. I still need
> > to poke around more to get a better idea of the scope. One that looks
> > like a possibility to me right now is the xfs_iflush_cluster() ->
> > xfs_force_shutdown() -> xfs_log_force() sequence (in the event of a
> 
> The xfs_iflush_cluster error handling has always been full of
> shutdown-related bugs.
> 

Indeed, I recall dealing with these various problems in the past.

> xfs_iflush() gets this buffer-vs-shutdown ordering right, but if
> it's ok to just release the buffer with the inode still attached to
> it in the xfs_iflush() case, then why isn't it ok to do exactly the
> same thing in xfs_iflush_cluster()?
> 
> Oh, it's because the xfs_iflush() error handling doesn't need to
> remove the inode from the buffer to get a reference to it to call
> xfs_iflush_abort() to remove the inode from the AIL.
> 
> IOWs, I think xfs_iflush_cluster() should really be doing the same
> thing - pull the list of inodes off the buffer, release the buffer,
> trigger a shutdown, then call xfs_iflush_abort() on each of those
> inodes....
> 

I'll have to take a closer look at the broader iflush[_cluster]() error
handling to wrap my head around this.

> > corrupt in-core inode on the same pinned buffer) down in the same iflush
> > path. Another could be in xfs_trans_read_buf_map() where if we somehow
> > grab a dirty+pinned buffer with b_error set, we can issue a shutdown if
> > the transaction is dirty before we release the failed buffer.
> 
> Again, that would be indicative of a bug somewhere else. A buffer
> found by a buffer should not be pinned and dirty in memory with a
> b_error value on it.  Whatever recorded the error should have
> processed and cleared the error, marked the buffer as stale, and/or
> shut down the filesystem, not left it it in cache for someone else
> to trip over.
> 

Completely agreed that this should never happen. I'm fine with
categorizing these kind of scenarios as a separate bug. I'm just
describing the complexity involved with trying to reason about the
scope of the general problem.

> e.g. see xfs_buf_iodone_callback_error(). If it's a transient error,
> it clears b_error before it returns. If it's a permanent error, it
> shuts down the filesystem and stales the buffer and so it will not
> ever be seen again on lookup.
> 
> i.e. The code in xfs_trans_read_buf_map() is detecting physical read
> IO errors bringing new metadata into the cache and reacting
> appropriately. Clean transactions can back out gracefully, while
> dirty transactions will trigger a shutdown during cancellation
> anyway, so the early shutdown is just a way of ensuring we error
> out appropriately. Maybe all the callers get the error handling
> right, and if that is the case the we can remove the shutdowns from
> xfs_trans_read_buf_map() altogether.....
> 
> > That
> > combination of events should probably never happen (and the vector is
> > probably closed by just releasing the buffer before the shutdown), but
> > it kind of illustrates the potential for whack-a-mole with log forces
> > and shutdown calls scattered around in so many places.. :/
> 
> If we end up in this kind of "whack-a-mole" scenario, it indicates
> we have other bugs that need fixing. Calling xfs_force_shutdown()
> holding inappropriate locks is a bug that should be fixed; changing
> how xfs_log_force() works is a much more risky proposition than
> fixing the callers that aren't safe...
> 

I agree in principle on changing xfs_log_force() behavior, but I think
there's a possibility that CIL context abort simply has a bug that
causes this problem for async log forces that happen to race with a
shutdown (re: the analysis above).

That aside, having some kind of guideline on when (not) to call a sync
log force or shutdown is partly what I'm trying to reason about. Your
statement above implies that such a guideline could be to not do so in
general while holding things like buffer locks. That sounds perfectly
reasonable to me and is much more straightforward of a concept to apply
to future code on review rather than trying to work out whether each
sync log force or shutdown site can somehow result in a shutdown
deadlock. The only open question I see is whether this needs to apply to
all log forces or only sync log forces...

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d3884e08b43c..5e595948bc5a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -582,6 +582,19 @@ xlog_cil_committed(
 	struct xfs_cil_ctx	*ctx = args;
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
 
+	/*
+	 * If the I/O failed, we're aborting the commit and already shutdown.
+	 * Wake any commit waiters before aborting the log items so we don't
+	 * block async log pushers on callbacks. Async log pushers explicitly do
+	 * not wait on log force completion because they may be holding locks
+	 * required to unpin items.
+	 */
+	if (abort) {
+		spin_lock(&ctx->cil->xc_push_lock);
+		wake_up_all(&ctx->cil->xc_commit_wait);
+		spin_unlock(&ctx->cil->xc_push_lock);
+	}
+
 	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
 					ctx->start_lsn, abort);
 
@@ -589,15 +602,7 @@ xlog_cil_committed(
 	xfs_extent_busy_clear(mp, &ctx->busy_extents,
 			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
 
-	/*
-	 * If we are aborting the commit, wake up anyone waiting on the
-	 * committing list.  If we don't, then a shutdown we can leave processes
-	 * waiting in xlog_cil_force_lsn() waiting on a sequence commit that
-	 * will never happen because we aborted it.
-	 */
 	spin_lock(&ctx->cil->xc_push_lock);
-	if (abort)
-		wake_up_all(&ctx->cil->xc_commit_wait);
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_push_lock);
 
