Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34C6C7F37
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 20:52:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F342304039
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 18:51:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rnz2umY3LOlfHGQq for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 18:51:53 -0700 (PDT)
Date: Thu, 9 Jul 2015 11:51:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: close xc_cil list_empty() races with cil commit
	sequence
Message-ID: <20150709015151.GF3902@dastard>
References: <1435154641-7790-1-git-send-email-bfoster@redhat.com>
	<20150708000909.GA7943@dastard>
	<20150708183152.GB60462@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150708183152.GB60462@bfoster.bfoster>
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

On Wed, Jul 08, 2015 at 02:31:53PM -0400, Brian Foster wrote:
> On Wed, Jul 08, 2015 at 10:09:09AM +1000, Dave Chinner wrote:
> > On Wed, Jun 24, 2015 at 10:04:01AM -0400, Brian Foster wrote:
> > > We have seen somewhat rare reports of the following assert from
> > > xlog_cil_push_background() failing during ltp tests or somewhat
> > > innocuous desktop root fs workloads (e.g., virt operations, initramfs
> > > construction):
> > > 
> > > 	ASSERT(!list_empty(&cil->xc_cil));
> > > 
> > > The reasoning behind the assert is that the transaction has inserted
> > > items to the CIL and hit background push codepath all with
> > > cil->xc_ctx_lock held for reading. This locks out background commit from
> > > emptying the CIL, which acquires the lock for writing. Therefore, the
> > > reasoning is that the items previously inserted in the CIL should still
> > > be present.
> > > 
> > > The cil->xc_ctx_lock read lock is not sufficient to protect the xc_cil
> > > list, however, due to how CIL insertion is handled.
> > > xlog_cil_insert_items() inserts and reorders the dirty transaction items
> > > to the tail of the CIL under xc_cil_lock. It uses list_move_tail() to
> > > achieve insertion and reordering in the same block of code. This
> > > function removes and reinserts an item to the tail of the list. If a
> > > transaction commits an item that was already logged and thus already
> > > resides in the CIL, and said item is the sole item on the list, the
> > > removal and reinsertion creates a temporary state where the list is
> > > actually empty.
> > 
> > The only way I can see this occurring is that we have to be committing a transaction that
> > modifies the same object as the previous transaction commit that
> > is still running through xfs_log_commit_cil(). e.g. racing
> > timestamp modifications on an inode, and the CIL is empty:
> > 
> > thread A			thread B
> > 
> > lock(inode)			lock(inode)
> > xfs_trans_join(inode)		<schedule>
> > xfs_trans_log(inode)
> > xfs_trans_commit(tp)
> >   xfs_log_commit_cil()
> >     lock(xc_ctx_lock)
> >     <add inode to cil>
> >     xfs_trans_free_items()
> >       unlock(inode)
> >       <schedule>
> > 				<runs with inode lock>
> > 				xfs_trans_join(inode)
> > 				xfs_trans_log(inode)
> > 				xfs_trans_commit(tp)
> > 				  xfs_log_commit_cil()
> > 				    lock(xc_ctx_lock)
> > 				    xlog_cil_insert_items()
> > 				      xlog_cil_insert_format_items()
> >       <runs again>
> >       xlog_cil_push_background
> > 	ASSERT(!list_empty(cil))      list_move_tail(item, cil)
> > 
> 
> Yes. I don't have the exact details of the original reproducer but it
> basically required transactions to recommit an already CIL-resident item
> with that item as the only entry in the CIL. The first transaction
> inserts or reinserts and heads to the background push while the second
> reinserts and creates the transient empty list state. I don't think the
> CIL necessarily has to be empty to start, but either way the above looks
> about right to me.
> 
> > 
> > If that is the race, then the fix appears simple to me: call
> > xlog_cil_push_background() before xfs_trans_free_items() so that we
> > push the CIL before we unlock the items we just added to the CIL.
> > i.e.:
> > 
> > thread A			thread B
> > 
> > lock(inode)			lock(inode)
> > xfs_trans_join(inode)		<schedule>
> > xfs_trans_log(inode)
> > xfs_trans_commit(tp)
> >   xfs_log_commit_cil()
> >     lock(xc_ctx_lock)
> >     <add inode to cil>
> >     log_cil_push_background
> > 	ASSERT(!list_empty(cil))
> >     xfs_trans_free_items()
> >       unlock(inode)
> >       <schedule>
> > 				<runs with inode lock>
> > 				xfs_trans_join(inode)
> > 				xfs_trans_log(inode)
> > 				xfs_trans_commit(tp)
> > 				  xfs_log_commit_cil()
> > 				    lock(xc_ctx_lock)
> > 				    xlog_cil_insert_items()
> > 				      xlog_cil_insert_format_items()
> > 				      list_move_tail(item, cil)
> 
> That seems like it should work for this particular case. I suppose it
> depends on the nature of the transactions as opposed to closing the race
> directly. It would require independent transactions to relog the same
> item without locking to expose this instance of the race again, which
> probably should never happen.
> 
> That doesn't help us for the other push side users of list_empty(),
> however. For example, what about xlog_cil_push_now(), etc.? AFAICS, that
> code still seems racy.

If we get a transient empty list there, we shouldn't have to care as
the retry condition in xlog_cil_force_lsn() should catch it. I guess
it is possible that both the original push and the retry
list-empty() check could *both* see transient empty lists (however
unlikely that is!).

However, a log force is a fairly rare occurrence outside of
sync/fsync heavy workloads, so adding the xc_cil_lock there
shouldn't cause any serious performance issues because everything in
a sync/fsync heavy workload will back waiting on the log forces
completing rather than formatting changes into the CIL...

The other places we check for empty xc_cil:

	- xlog_cil_push() holds xc_ctx_lock in write mode, so cannot
	  race at all with xfs_log_commit_cil(). No need for
	  additional locking there.
	- xlog_cil_empty() is only used by the log covering code,
	  so we simply don't care if we get a transient empty there
	  because that implies the log is active and shouldn't be
	  covered.
	- xfs_log_item_in_current_chkpt() is only called from
	  xfs_buf_item_format() and so is done with the buffer
	  locked and the xc_ctx_lock in read mode.
	  Hence it can't race with itself being removed or a CIl push
	  removing all the entries and so a
	  transient false empty implies that the buffer itself is
	  not in the CIL. Therefore it functions correctly even if
	  we get a transient CIL empty occurring...

So, really, there isn't a fundamental problem with the locking
during the corner case where a transient empty can be detected as
everything functions correctly even when a transient is detected.
The only place I'd be concerned is the unlikely case of a double
transient in the log force situation, but even then I'd question if
it is even possible because we only force the log when we know that
we have something that needs pushing....

> > > This state is not valid and thus should never be observed by concurrent
> > > transaction commit-side checks in the circumstances outlined above.
> > > Update all of the xc_cil checks to acquire xc_cil_lock before assessing
> > > the state of xc_cil.
> > 
> > That will reintroduce the problem of lock contention between the
> > commit and the push sides of the CIL, which the cil/push lock
> > separation was added to solve:
> > 
> 
> If the lock is a problem, how about trying to close the race on the
> insert side? E.g., something like the following in
> xlog_cil_insert_items():
> 
> 	if (!list_is_last(&lip->li_cil, &cil->xc_cil))
> 		list_move_tail(&lip->li_cil, &cil->xc_cil);
> 
> ... such that the list with a single item is never transiently empty.
> Thoughts?

Yeah, that would work. I like KISS solutions and sometimes I get so
far into the code I can't see them. Good thinking, Brain!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
