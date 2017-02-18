Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbdBRMzi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Feb 2017 07:55:38 -0500
Date: Sat, 18 Feb 2017 07:55:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: bypass dquot reclaim to avoid quotacheck
 deadlock
Message-ID: <20170218125536.GA25016@bfoster.bfoster>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
 <1487173247-5965-2-git-send-email-bfoster@redhat.com>
 <20170216223705.GC15349@dastard>
 <20170217183009.GB20429@bfoster.bfoster>
 <20170217231215.GD15349@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170217231215.GD15349@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Sat, Feb 18, 2017 at 10:12:15AM +1100, Dave Chinner wrote:
> On Fri, Feb 17, 2017 at 01:30:09PM -0500, Brian Foster wrote:
> > On Fri, Feb 17, 2017 at 09:37:05AM +1100, Dave Chinner wrote:
> > > On Wed, Feb 15, 2017 at 10:40:43AM -0500, Brian Foster wrote:
> > > > Reclaim during quotacheck can lead to deadlocks on the dquot flush lock:
> > > > 
> > > >  - Quotacheck populates a local delwri queue with the physical dquot
> > > >    buffers.
> > > >  - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and dirties
> > > >    all of the dquots.
> > > >  - Reclaim kicks in and attempts to flush a dquot whose buffer is
> > > >    already queud on the quotacheck queue. The flush succeeds but
> > > >    queueing to the reclaim delwri queue fails as the backing buffer is
> > > >    already queued. The flush unlock is now deferred to I/O completion of
> > > >    the buffer from the quotacheck queue.
> > > >  - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires the
> > > >    flush lock to update the backing buffers with the in-core
> > > >    recalculated values. This deadlocks as the flush lock was acquired by
> > > >    reclaim but the buffer never submitted for I/O as it already resided
> > > >    on the quotacheck queue.
> > > > 
> > > > This is reproduced by running quotacheck on a filesystem with a couple
> > > > million inodes in low memory (512MB-1GB) situations.
> > > > 
> > > > Quotacheck first resets and collects the physical dquot buffers in a
> > > > delwri queue. Then, it traverses the filesystem inodes via bulkstat,
> > > > updates the in-core dquots, flushes the corrected dquots to the backing
> > > > buffers and finally submits the delwri queue for I/O. Since the backing
> > > > buffers are queued across the entire quotacheck operation, dquot reclaim
> > > > cannot possibly complete a dquot flush before quotacheck completes.
> > > > Therefore, dquot reclaim provides no real value during quotacheck.
> > > 
> > > Which is an OOM vector on systems with lots of dquots and low memory
> > > at mount time. Turning off dquot reclaim doesn't change that.
> > > 
> > 
> > It's not intended to. The inefficient design of quotacheck wrt to memory
> > usage is a separate problem. AFAICT, that problem goes back as far as my
> > git tree does (2.6.xx).
> > 
> > Looking back through the git history, this deadlock appears to be a
> > regression as of commit 43ff2122e6 ("xfs: on-stack delayed write buffer
> > lists") in 2012, which replaced a trylock/push sequence from the
> > quotacheck flush walk with a synchronous flush lock.
> 
> Right - that's the commit that changed the code to what it is now.
> That's what I implied needs fixing....
> 

Ok, but that commit has nothing to do with the design of quotacheck.

> > > Address the root cause - the buffer list is never flushed and so
> > > pins the memory quotacheck requires, so we need to flush the buffer
> > > list more often.  We also need to submit the buffer list before the
> > > flush walks begin, thereby unlocking all the dquots before doing the
> > > flush walk and avoiding the deadlock.
> > > 
> > 
> > I acknowledge that this patch doesn't address the root problem, but
> > neither does this proposal. The root cause is not that quotacheck uses
> > too much memory, it's that the serialization between quotacheck and
> > dquot reclaim is bogus.
> > 
> > For example, if we drop the buffer list being held across the adjust and
> > flush walks, we do indeed unpin the buffers and dquots for memory
> > reclaim, particularly during the dqadjust bulkstat. The flush walk then
> > still has to cycle the flush lock of every dquot to guarantee we wait on
> > dquots being flushed by reclaim (otherwise we risk corruption with the
> > xfs_qm_flush_one() logic is it is today). The same deadlock vector still
> > exists, albeit with a smaller window, if reclaim happens to flush a
> > dquot that is backed by a buffer that has already been queued by the
> > flush walk. AFAICT, the only requirements for this to occur are a couple
> > of dquots on a single backing buffer and some memory pressure from
> > somewhere, so the local memory usage is irrelevant.
> 
> Except that the window is *tiny* because the dquots are walked in
> order and so all the dquots are processed in ascending order. This
> means all the dquots in a buffer are flushed sequentially, and each
> dquot lookup resets the reclaim reference count count on the dquot
> buffer. Hence it is extremely unlikely that a dquot buffer will be
> reclaimed while it is partially flushed during the flush walk.
> 

At a high level, this fundamentally makes dquot reclaim safe during the
dqadjust bulkstat. We are susceptible to the same exact problem during
the flush walk... it is true that the race window is now reduced to the
time spent processing dquots for a particular buffer at time. The logic
used to explain away the race here doesn't make a lot of sense,
however...

First, the reference count on the underlying buffer is irrelevant
because dquot reclaim is what causes the race. All dquot reference
counts are zero when the flush walk begins. In other words, all in-core
dquots are on the lru and thus subject to reclaim at this point in time.

Second, the window is definitely not tiny. According to xfs_qm.h, we
have 30 dquots per 4k block. The only way a flush via dquot reclaim does
_not_ deadlock is if reclaim is first to flush a dquot of a particular
buffer (such that it can queue the buffer). In most reclaim scans this
may work fine, but if dquots are flushed in ascending order, that means
if reclaim ever has to flush a dquot, it's pretty much caught up to the
flush walk or will intersect eventually.

Further, the flush walk code iterates 32 dquots at a time. That's
effectively a qi_tree_lock cycle and radix tree lookup per dquot buffer.
With thousands of dquots around in memory, I think that presents ample
opportunity for reclaim to kick in and flush a dquot that's not the
first to be flushed to its backing buffer. All it probably takes is for
the tree lock cycle and the radix tree lookup for the next batch of 32
dquots to occur before the end of a particular buffer to present an even
bigger window for reclaim to kick in and flush one of the remaining
dquots on that particular buffer. Again, that's going to occur for
almost every dquot buffer.

This is all kind of pointless analysis anyways because if the buffer
list is submitted before the flush walk, the flush walk in its current
form is not sufficient to serialize quotacheck against I/O completion of
underlying dquot buffers. dquot reclaim can now flush and free any
number of dquots for which quotacheck won't have any window into the
state of the underlying buffer I/O. This probably means the
xfs_qm_dquot_walk() (radix tree) based flush walk needs to be replaced
with something that visits every dquot (or dquot buffer) in the fs,
reallocating them if necessary (which adds more flush walk -> reclaim
contention than we've considered above), in order to serialize against
the underlying buffer. Either way, to just submit the buffer list before
the flush walk and make no other changes to account for the lost buffer
serialization is to break quotacheck.

> > I'm specifically trying to address the deadlock problem here. If we
> > don't want to bypass reclaim, the other options I see are to rework the
> > logic on the reclaim side to check the buffer state before we flush the
> > dquot, or push on the buffer from the quotacheck side like we used to
> > before the commit above.
> 
> The latter is effectively what flushing the buffer list before the
> flush walk is run does.
> 

The buffer push forcibly writes out the buffer for any dquot that is
found flush locked during the quotacheck flush walk and waits on the
flush lock again to serialize against the write and allow us to flush
such dquots to the buffer without a deadlock. Flushing the buffer list
before the flush walk doesn't protect us from deadlock once the flush
walk actually begins, and creates new serialization problems with
broader quotacheck that can cause corruption if not handled properly.

I can try to put something together next week to resurrect the buffer
push similar to as implemented historically prior to commit 43ff2122e6
if you're Ok with that approach for the locking problem (or have some
other suggestion that doesn't handwave away the serialization problem
;)... Otherwise, I guess we can leave things as they are. I don't want
to rely on things like indeterminate cache walk and reclaim ordering to
try and justify whether a clear serialization problem is going to
trigger or not in various high/low memory/dquot configurations. Even if
it doesn't trigger right now, if we change something innocuous down the
road like the dquot buffer size then all of this logic goes out the
window and we have a "new" deadlock to track and down and resolve..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
