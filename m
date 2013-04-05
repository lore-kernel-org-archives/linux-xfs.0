Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6F9D7F37
	for <xfs@oss.sgi.com>; Thu,  4 Apr 2013 19:45:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FD78AC003
	for <xfs@oss.sgi.com>; Thu,  4 Apr 2013 17:45:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rd4fCv5PnAYHwcIa for <xfs@oss.sgi.com>;
	Thu, 04 Apr 2013 17:45:44 -0700 (PDT)
Date: Fri, 5 Apr 2013 11:45:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't free EFIs before the EFDs are committed
Message-ID: <20130405004540.GF12011@dastard>
References: <1364958561-12440-1-git-send-email-david@fromorbit.com>
	<515DF967.7000207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515DF967.7000207@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 04, 2013 at 05:06:31PM -0500, Mark Tinguely wrote:
> On 04/02/13 22:09, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Filesystems are occasionally being shut down with this error:
> >
> >xfs_trans_ail_delete_bulk: attempting to delete a log item that is
> >not in the AIL.
> >
> >It was diagnosed to be related to the EFI/EFD commit order when the
> >EFI and EFD are in different checkpoints and the EFD is committed
> >before the EFI here:
> >
> >http://oss.sgi.com/archives/xfs/2013-01/msg00082.html
> >
> >The real problem is that a single bit cannot fully describe the
> >states that the EFI/EFD processing can be in. These completion
> >states are:
> >
> >EFI			EFI in AIL	EFD		Result
> >committed/unpinned	Yes		committed	OK
> >committed/pinned	No		committed	Shutdown
> >uncommitted		No		committed	Shutdown
> >
> >
> >Note that the "result" field is what should happen, not what does
> >happen. The current logic is broken and handles the first two cases
> >correctly by luck.  That is, the code will free the EFI if the
> >XFS_EFI_COMMITTED bit is *not* set, rather than if it is set. The
> >inverted logic "works" because if both EFI and EFD are committed,
> >then the first __xfs_efi_release() call clears the XFS_EFI_COMMITTED
> >bit, and the second frees the EFI item. Hence as long as
> >xfs_efi_item_committed() has been called, everything appears to be
> >fine.
> >
> >It is the third case where the logic fails - where
> >xfs_efd_item_committed() is called before xfs_efi_item_committed(),
> >and that results in the EFI being freed before it has been
> >committed. That is the bug that triggered the shutdown, and hence
> >keeping track of whether the EFI has been committed or not is
> >insufficient to correctly order the EFI/EFD operations w.r.t. the
> >AIL.
> >
> >What we really want is this: the EFI is always placed into the
> >AIL before the last reference goes away. The only way to guarantee
> >that is that the EFI is not freed until after it has been unpinned
> >*and* the EFD has been committed. That is, restructure the logic so
> >that the only case that can occur is the first case.
> >
> >This can be done easily by replacing the XFS_EFI_COMMITTED with an
> >EFI reference count. The EFI is initialised with it's own count, and
> >that is not released until it is unpinned. However, there is a
> >complication to this method - the high level EFI/EFD code in
> >xfs_bmap_finish() does not hold direct references to the EFI
> >structure, and runs a transaction commit between the EFI and EFD
> >processing. Hence the EFI can be freed even before the EFD is
> >created using such a method.
> >
> >Further, log recovery uses the AIL for tracking EFI/EFDs that need
> >to be recovered, but it uses the AIL *differently* to the EFI
> >transaction commit. Hence log recovery never pins or unpins EFIs, so
> >we can't drop the EFI reference count indirectly to free the EFI.
> >
> >However, this doesn't prevent us from using a reference count here.
> >There is a 1:1 relationship between EFIs and EFDs, so when we
> >initialise the EFI we can take a reference count for the EFD as
> >well. This solves the xfs_bmap_finish() issue - the EFI will never
> >be freed until the EFD is processed. In terms of log recovery,
> >during the committing of the EFD we can look for the
> >XFS_EFI_RECOVERED bit being set and drop the EFI reference as well,
> >thereby ensuring everything works correctly there as well.
> 
> Duh me, beside what our problem where the cil push callbacks are
> called out of order, there can be several xfs_trans_committed_bulk()
> running at the same time.

I'm not sure that can actually happen - callback processing is
supposed to be serialised by xlog_state_do_callback()....

> Yep, the counter allows efi and efd to happen in any order and make
> sure the efi is entered into the AIL.
> 
> Okay, the pass2 of recovery places the efi item into the AIL, and
> the second decrement on the counter when the XFS_EFI_RECOVERED bit
> gets the counter to zero in the recovery case because there is no
> unpin.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Thank you.

> This patch also prevents the only chance of detecting of out of
> sequence ctx callbacks.

I don't think the callbacks are being attached out of order.  Like I
said previously: if that were happening then the commit records are
being written to the log in the wrong order and that is a *major*
issue.

As such, I've attached the informal proof that I just ran through to
verify that the current code is ordering commit records and hence
callbacks on iclogs correctly for multiple outstanding checkpoints.
I don't see any obvious hole in the logic as the callbacks are
attached to the iclog the commit record is written into and the
commit records are strictly serialised and ordered...

> The out of sequence ctx callbacks *does*
> matter because the li_lsn is set by the ctx->start_lsn and the
> lowest li_lsn is used to move the tail. When the callbacks are out
> of order, it is possible for the larger lsn of the greater ctx
> sequence to move the log tail beyond a lower ctx sequence entries
> before the entries for the lower sequence ctx are moved into the
> AIL.

Assuming we are getting callbacks running out of order, this is only
a problem if the AIL is empty at the time the out of order callbacks
are run. If the AIL is not empty, then the tail of the log is
derived directly from the LSN of the first item in the AIL and that
LSN will be from an item committed from a previous checkpoint, not
the current one that is runing out of order. Hence the tail of the
log is not affected in this case.

If the AIL is empty, then the tail LSN is determined by the lowest
LSN of the iclogs being processed concurrently. This code in
xlog_state_do_callback() is supposed to serialise and order the
completion of multiple concurrent iclog completions:

		lowest_lsn = xlog_get_lowest_lsn(log);
		if (lowest_lsn &&
		    XFS_LSN_CMP(lowest_lsn,
				be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
			iclog = iclog->ic_next;
			continue; /* Leave this iclog for
				   * another thread */
		}

IOWs, if the current iclog being checked for IO completion
processing has a higher LSN than the lowest in all the iclogs that
are not clean, then skip over it and check the next iclog. So, even
if we have multiple concurrent iclogs in
XLOG_STATE_DONE_SYNC/XLOG_STATE_DO_CALLBACK state, only the first
that comes across the iclog with the lowest LSN in these states is
supposed to run callbacks. And an iclog is considered in the
xlog_get_lowest_lsn() calculation until it becomes dirty/active,
which is a state transition that occurs *after* callbacks are run
on the iclog.

Further, once an iclog has been selected for callback processing, if
it has callbacks on it, we do this:

		if (iclog->ic_callback)
			atomic64_set(&log->l_last_sync_lsn,
				be64_to_cpu(iclog->ic_header.h_lsn));

to set the tail of the log to match that of the current LSN
of the iclog that is being processed. This is an "advance" update of
the log tail that will be used until items are inserted into
the AIL by callback processing (see xlog_assign_tail_lsn()). If
there are not items to be placed into the AIL (i.e. it remains
empty) then this ensures that the next log write still gets the tail
LSN correct.

And by this analysis, we should not be seeing concurrent execution
of callbacks on different iclogs, nor should we be seeing out of
order execution of callbacks on different iclogs. And because
callbacks are ordered correctly by the CIL push code we shouldn't be
seeing callbacks on a single iclog being run out of order
either.

IOWs, the tail LSN of the log should not be jumping around due to
out of order iclog and/or callback processing.  Unless there
is a problem in xlog_state_do_callback() with serialising and
ordering iclog IO completion processing, there shouldn't be a
problem with out of order callback processing, either.

Note that I haven't been through the iclog state machine in fine
detail since 2007, so I'm going to need to spend a bit of time
looking at it again to confirm this. I don't see any obvious problem
at the moment, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

commit CIL operation:

	down_write(ctx lock)
	increment sequence
	switch ctxs
	spin_lock(cil lock)
	add old ctx to commit list
	spin_unlock(cil lock)
	up_write(ctx lock)

	write checkpoint to log

	spin_lock(cil lock)
	walk commiting list and wait for prior sequences to commit
	spin_unlock(cil lock)

	xfs_log_done()		-> writes commit record, returns iclog, commit_lsn
	xfs_log_notify()	-> attaches callback to iclog tail

	spin_lock(cil lock)
	ctx->commit_lsn = commit_lsn
	wake waiters
	spin_unlock(cil lock)
	release iclog

	<iclog IO started>
	<iclog IO complete>
	<iclog run callbacks>

	spin_lock(cil lock)
	remove from committing list.
	spin_unlock(cil lock)


Informal proof of sequence commit order correctness by induction:

The initial context switching segment runs under an exclusive lock, and it means
that S2 can not be started (and hence committed) until S1 is already in the
committing list. So when S2 commits, if S1 has not yet written a commit record
we have the initial condition of:

	commiting list:
		S2, commit_lsn = 0
		S1, commit_lsn = 0

Now, if S2 writes it's checkpoint into the iclogs before S1 completes (e.g. S1
is a 10MB checkpoint, S2 is single inode core from a fsync) S2 enters the
committing list check and sees:

528 restart:
529         spin_lock(&cil->xc_cil_lock);
530         list_for_each_entry(new_ctx, &cil->xc_committing, committing) {

First entry is S2

531                 /*
532                  * Higher sequences will wait for this one so skip them.
533                  * Don't wait for own own sequence, either.
534                  */
535                 if (new_ctx->sequence >= ctx->sequence)
536                         continue;

new_ctx->sequence = S2, ctx->sequence = S2, so continue;

Second entry is S1, so we see:

new_ctx->sequence = S1, ctx->sequence = S2, so we  now check the commit lsn:

537                 if (!new_ctx->commit_lsn) {

new_ctx->commit_lsn = 0, so we:

538                         /*
539                          * It is still being pushed! Wait for the push to
540                          * complete, then start again from the beginning.
541                          */
542                         xlog_wait(&cil->xc_commit_wait, &cil->xc_cil_lock);
543                         goto restart;

wait and restart once woken.

544                 }
545         }
546         spin_unlock(&cil->xc_cil_lock);

Eventually, S1 finishes writing the checkpoint, and enters the commit record loop:

528 restart:
529         spin_lock(&cil->xc_cil_lock);
530         list_for_each_entry(new_ctx, &cil->xc_committing, committing) {

First entry is S2

531                 /*
532                  * Higher sequences will wait for this one so skip them.
533                  * Don't wait for own own sequence, either.
534                  */
535                 if (new_ctx->sequence >= ctx->sequence)
536                         continue;

new_ctx->sequence = S2, ctx->sequence = S1, so we continue.

Second entry is S1, so again we continue, hit the end of list and drop out of
the loop. At this point S1 writes the commit record, then attaches the callbacks
to the *tail* of the iclog callback list. In doing this, it gets the commit_lsn
of the commit record, so it does:

	ctx->commit_lsn = commit_lsn
	wakeup_all(&cil->xc_commit_wait);

Which wakes up S2. S2 now does:

_
528 restart:
529         spin_lock(&cil->xc_cil_lock);
530         list_for_each_entry(new_ctx, &cil->xc_committing, committing) {

First entry is S2

531                 /*
532                  * Higher sequences will wait for this one so skip them.
533                  * Don't wait for own own sequence, either.
534                  */
535                 if (new_ctx->sequence >= ctx->sequence)
536                         continue;

new_ctx->sequence = S2, ctx->sequence = S2, so we continue.

Second entry is S1, so we now check the commit lsn:

537                 if (!new_ctx->commit_lsn) {

new_ctx->commit_lsn != 0, so again we continue, hit the end of list and fall
through to the commit record write. This attaches the callback to the *tail* of
the iclog callback list, so it ordered *after* the callbacks for S1.

Hence the commit records appear to be correctly ordered by this code, as are the
callbacks being attached to iclogs. So, for the case of S1, S2 the code is safe.

For the case of S1, S2, S3, we have the same initial conditions:

	- S2 is not made active until S1 is on the commit list
	- S3 is not made active until S2 is on the commit list

Hence if we have S1 still committing while S2 and S3 have completed their
commits, the wait cycle looks like:

S2:
	Sees S2, continue;
	Sees S1, sees commit_lsn == 0, waits
S3:
	Sees S3, continue;
	Sees S2, sees commit_lsn == 0, waits

S1: completes commit,
	Sees S3, continue;
	Sees S2, continue;
	Sees S1, continue;
	Writes commit record
	Attaches callbacks
	sets commit_lsn
	wakeup_all()

S2:						S3:
	wake, restart				wake, restart
						[win wakeup race on cil lock]
						Sees S3, continue
						Sees S2, sees commit_lsn == 0, wait

	Sees S3, continue
	Sees S2, continue
	Sees S1, sees commit_lsn != 0, continue
						[lost wakeup race, spins on cil lock]
						[not woken until S2 already through]
						Sees S3, continue
						Sees S2, sees commit_lsn == 0, wait

	Writes commit record
	Attaches callbacks
	sets commit_lsn
	wakeup_all()

S3:
	Sees S3, continue
	Sees S2, sees commit_lsn != 0, continue
	Sees S1, sees commit_lsn != 0, continue
	Writes commit record
	Attaches callbacks
	sets commit_lsn
	wakeup_all()

And so the ordering of commit records and multiple callbacks on the same iclog
are correct for S1, S2 and S3.

So, for and arbitrary set of sequences {S1...Sn, S(n+1)}, the initial conditions are:

	- S2 is not made active until S1 is on the commit list
	....
	- S(n+1) is not made active until Sn is on the commit list

Hence if we have S1 still committing while Sn and S(n+1) have completed their
commits, the wait cycle looks like:

Sn:
	Sees Sn, continue;
	.....
	Sees S1, sees commit_lsn == 0, waits
S(n+1_:
	Sees S(n+1), continue;
	Sees Sn, sees commit_lsn == 0, waits

S1: completes commit,
	Sees S(n+1), continue;
	Sees Sn, continue;
	.....
	Sees S1, continue;
	Writes commit record
	Attaches callbacks
	sets commit_lsn
	wakeup_all()

Sn:						S(n+1):
	wake, restart				wake, restart
						[win wakeup race on cil lock]
						Sees S(n+1), continue
						Sees Sn, sees commit_lsn == 0, wait

	Sees S(n+1), continue
	Sees Sn, continue
	.....
	Sees S1, sees commit_lsn != 0, continue
						[lost wakeup race, spins on cil lock]
						[not woken until Sn already through]
						Sees S(n+1), continue
						Sees Sn, sees commit_lsn == 0, wait

	Writes commit record
	Attaches callbacks
	sets commit_lsn
	wakeup_all()

S3:
	Sees S(n+1), continue
	Sees Sn, sees commit_lsn != 0, continue
	.....
	Sees S1, sees commit_lsn != 0, continue
	Writes commit record
	Attaches callbacks
	sets commit_lsn
	wakeup_all()

Hence by induction the ordering of commit records and multiple callbacks on the
same iclog are correct for {S1...Sn, S(n+1)}

QED

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
