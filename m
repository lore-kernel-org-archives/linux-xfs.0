Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:56392 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751710AbdEXBGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 21:06:46 -0400
Date: Wed, 24 May 2017 11:06:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170524010601.GX12369@dastard>
References: <20170517005749.GO17542@dastard>
 <20170517104111.aziwbvqpfcbgxnxa@eorzea.usersys.redhat.com>
 <20170519002227.GS17542@dastard>
 <20170519112659.GB64091@bfoster.bfoster>
 <20170519233900.GT17542@dastard>
 <20170520114654.GA3888@bfoster.bfoster>
 <20170521231906.GU17542@dastard>
 <20170522125110.GA11578@bfoster.bfoster>
 <20170523112318.GX17542@dastard>
 <20170523162202.GB7632@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523162202.GB7632@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 23, 2017 at 12:22:04PM -0400, Brian Foster wrote:
> On Tue, May 23, 2017 at 09:23:18PM +1000, Dave Chinner wrote:
> > On Mon, May 22, 2017 at 08:51:13AM -0400, Brian Foster wrote:
> > > On Mon, May 22, 2017 at 09:19:06AM +1000, Dave Chinner wrote:
> > > > On Sat, May 20, 2017 at 07:46:56AM -0400, Brian Foster wrote:
> > > > > On Sat, May 20, 2017 at 09:39:00AM +1000, Dave Chinner wrote:
> > > > > > Adding new flags to the same field that can be asynchronously
> > > > > > updated by RMW operations outside the ailp->xa_lock will cause
> > > > > > problems in future. There *may not* be a problem right now, but it
> > > > > > is poor programming practice to have different coherency processes
> > > > > > for the same variable that is updated via RMW operations. In these
> > > > > > situations, the only safe way to update the variable is to use an
> > > > > > atomic operation.
> > > > > > 
> > > > > 
> > > > > So is there a reason why we couldn't acquire ->xa_lock to fail the log
> > > > > items as we would have done anyways if the metadata writeback had
> > > > > succeeded and we were removing the log items from the AIL..
> > > > 
> > > > Yes. the alip->xa_lock protects AIL state is a highly contended
> > > > lock. It should not be used for things that aren't AIL related
> > > > because that will have performance and scalability implications.
> > > > 
> > > 
> > > The purpose of this flag is to control AIL retry processing, how is this
> > > not AIL related?
> > 
> > It's IO state, not AIL state. IO submission occurs from more places
> > than and AIL push (e.g. inode reclaim, inode clustering, etc) and
> > there's no way we should be exposing the internal AIL state lock in
> > places like that.
> > 
> 
> That's reasonable, though it suggests different code from what this
> patchset currently does. This would be far more useful if we could focus
> on correctness of the code first and foremost. If the code we commit
> actually warrants this kind of change, then this becomes a much easier
> (i.e., pointless :P) discussion from my end.

Hmmm - this is not the first time recently you've said something
similar in a review discussion where you didn't like this issues
have been pointed out. Last time is was "handwavey", now it's
"pointless". We haven't worked out a solution that solves all the
known problems, so these sorts of comments really don't help close
on one....

> As it is, this patch only ever clears the flag on AIL resubmission. ISTM
> you are indirectly suggesting that should occur in other contexts as
> well (e.g., consider a reclaim and flush of another inode backed by a
> buffer that is already failed, and has other inodes sitting in the AIL
> flush locked). If that is the case, please elaborate, because otherwise
> it is kind of impossible to evaluate and discuss without specifics.

All I've done is take the deadlock scenario you pointed
out and applied to it other places we block on the flush lock.

Go look at inode reclaim - it can do blocking reclaim and so will
block on the flush lock. How is this code supposed to handle hitting
a failed, flush locked inode?  If it just blocks, then it's a likely
deadlock vector as you've already pointed out. Hence we'll need the
same failed write checks to trigger buffer resubmission before we
retry the inode reclaim process.

[....]

> As it is, this patch would only add an acquisition of ->xa_lock in
> completion context on I/O failure. Exactly what workload would you
> expect to be affected by changes to I/O error handling? How would it be
> any different than what we already do on normal I/O completion?

If you want to check and clear the failed flag in the log item in a
non-racy way  in IO submission (because we have to do this outside
the flush lock) then we'd have to hold the AIL lock. And that means
the AIL lock is then in the hot path of inode flushing in all
situations, not just in IO completion.

We've known for a long time that the AIL lock is the second most
contended lock in the filesystem (behind the CIL context lock), and
that it is most heavily contended on inode IO completion because
completion runs on the CPU that the interrupt is delivered to and
so the AIL lock gets contended from multiple CPUs at once on
multi-disk filesystems (see xfs_iflush_done() for more info).
As such, we do not want to increase it's use anywhere in the inode
IO submission/completion path at all if we can possibly avoid it.

So with all the problems that leaving failed inodes flush locked
presents, I'm starting to think that the inode failed callback
should remove the inode from the buffer and drop the flush lock
rather than leave it held and attached to the buffer. We can check
the LI_FAILED flag in xfs_iflush_int() and simply skip the inode
flush to the buffer to effectively "resubmit" the inode unchanged.
If we then clear the LI_FAILED flag in xfs_iflush_done() (i.e. only
when a successful write occurs), we don't need to jump through hoops
to clear the flag at IO submission time. We'd probably also need a
failed flag on the buffer (maybe with a hold ref, too) so that it
isn't reclaimed by memory pressure while we have inodes in the
failed state pending writeback.

This leaves the rest of the submission code completely unchanged -
including the write clustering.  It also gets rid of all the flush
lock deadlock scenarios because we always unlock the flush lock on
IO completion, regardless of whether the buffer IO succeeded or not.
ANd we don't have to change any infrastructure, either - it all just
works as it is because the LI_FAILED flag is handled at the lowest
levels possible.

This, to me, seems like a far cleaner solution than anything we've
discussed so far....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
