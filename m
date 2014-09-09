Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12F6D7F51
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:04:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D91308F8033
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 15:04:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Ijq8iyavoCHuZLlp for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 15:04:10 -0700 (PDT)
Date: Wed, 10 Sep 2014 08:04:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: xlog_cil_force_lsn doesn't always wait correctly
Message-ID: <20140909220359.GG20518@dastard>
References: <1410226995-15714-1-git-send-email-david@fromorbit.com>
	<20140909134458.GA35182@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140909134458.GA35182@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 09:44:58AM -0400, Brian Foster wrote:
> On Tue, Sep 09, 2014 at 11:43:15AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When running a tight mount/unmount loop on an older kernel, RedHat
> > QE found that unmount would occasionally hang in
> > xfs_buf_unpin_wait() on the superblock buffer. Tracing and other
> > debug work by Eric Sandeen indicated that it was hanging on the
> > writing of the superblock during unmount immediately after logging
> > the superblock counters in a synchronous transaction. Further debug
> > indicated that the synchronous transaction was not waiting for
> > completion correctly, and we narrowed it down to
> > xlog_cil_force_lsn() returning NULLCOMMITLSN and hence not pushing
> > the transaction in the iclog buffer to disk correctly.
> > 
> > While this unmount superblock write code is now very different in
> > mainline kernels, the xlog_cil_force_lsn() code is identical, and it
> > was bisected to the backport of commit f876e44 ("xfs: always do log
> > forces via the workqueue"). This commit made the CIL push
> > asynchronous for log forces and hence exposed a race condition that
> > couldn't occur on a synchronous push.
> > 
> > Essentially, the xlog_cil_force_lsn() relied implicitly on the fact
> > that the sequence push would be complete by the time
> > xlog_cil_push_now() returned, resulting in the context being pushed
> > being in the committing list. When it was made asynchronous, it was
> > recognised that there was a race condition in detecting whether an
> > asynchronous push has started or not and code was added to handle
> > it.
> > 
> > Unfortunately, the fix was not quite right and left a race condition
> > where it it would detect an empty CIL while a push was in progress
> > before the context had been added to the committing list. This was
> > incorrectly seen as a "nothing to do" condition and so would tell
> > xfs_log_force_lsn() that there is nothing to wait for, and hence it
> > would push the iclogbufs in memory.
> > 
> > The fix is simple, but explaining the logic and the race condition
> > is a lot more complex. The fix is to add the context to the
> > committing list before we start emptying the CIL. This allows us to
> > detect the difference between an empty "do nothing" push and a push
> > that has not started by adding a discrete "emptying the CIL" state
> > to avoid the transient, incorrect "empty" condition that the
> > (unchanged) waiting code was seeing.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Tested-by: Eric Sandeen <esandeen@redhat.com>
> > ---
> 
> The pusher side queues the work, acquires xc_push_lock, walks the
> committing list and then does this:
> 
> 	if (sequence == cil->xc_current_sequence &&
> 	    !list_empty(&cil->xc_cil)) {
> 		spin_unlock(&cil->xc_push_lock);
> 		goto restart;
> 	}
> 
> ... which is effectively peeking into the cil state to see if the push
> actually needed to do anything. The purpose is to identify the case
> where the push hasn't occurred and the previous committing list
> traversal was insufficient.
> 
> The "pushee" side drains the cil, updates the current sequence and adds
> the ctx to the committing list. The time between the cil drain and
> list_add() creates a window where, according to the logic above, the cil
> push looks like it wasn't going to do anything from the pusher
> perspective. The latter two bits occur under xc_push_lock (spinlock), so
> perhaps that widens a window to make this slightly more reproducible.
> 
> The pushee work is all done under xc_ctx_lock, so generally this is an
> issue because the pusher doesn't acquire xc_ctx_lock, and thus the cil
> drain and ctx update are not seen as atomic. I presume this is lockless
> by design, so taking the lock is not a desired solution.
> 
> Therefore, the order of changes to data structures that the pusher peeks
> into is updated on the pushee side to add to the committing list, drain
> the cil and update the current sequence number.
> 
> For the pusher side, this means the committing list walk and logic above
> (all under xc_push_lock) either sees the ctx on the list or not. If the
> ctx is on the list, then we waited for it and there is no race. If the
> ctx is not on the list, it is either populated and waiting to be added
> to the list (e.g., we hold xc_push_lock) or empty and there's nothing to
> do (regardless of whether the pusher side has run or not).
> 
> That seems sound to me. It would be nice of we could somehow make this
> explicitly more simple rather than dependent on complex ordering (e.g.,
> a push completion or something of that sort), but that's for another
> time. One nit below...

Yeah, it's complex and order dependent. I think I broke Eric trying
to explain it to him when debugging it. ;)

But the complexity is a side effect of the push lock being a
critically hot lock and so anything we can do to avoid needing to
hold it for longer or take it more often is worth the complexity. If
you can think of a way that is simpler and doesn't introduce new
contention points between pushers, forces and commits then I'm all
ears ;)


....

> Looks like out_skip could unlock xc_push_lock now.

Probably can be, but I'll leave it as is right now.

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
