Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19425 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964821AbdBQXPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2017 18:15:42 -0500
Date: Sat, 18 Feb 2017 10:12:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: bypass dquot reclaim to avoid quotacheck
 deadlock
Message-ID: <20170217231215.GD15349@dastard>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
 <1487173247-5965-2-git-send-email-bfoster@redhat.com>
 <20170216223705.GC15349@dastard>
 <20170217183009.GB20429@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170217183009.GB20429@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Fri, Feb 17, 2017 at 01:30:09PM -0500, Brian Foster wrote:
> On Fri, Feb 17, 2017 at 09:37:05AM +1100, Dave Chinner wrote:
> > On Wed, Feb 15, 2017 at 10:40:43AM -0500, Brian Foster wrote:
> > > Reclaim during quotacheck can lead to deadlocks on the dquot flush lock:
> > > 
> > >  - Quotacheck populates a local delwri queue with the physical dquot
> > >    buffers.
> > >  - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and dirties
> > >    all of the dquots.
> > >  - Reclaim kicks in and attempts to flush a dquot whose buffer is
> > >    already queud on the quotacheck queue. The flush succeeds but
> > >    queueing to the reclaim delwri queue fails as the backing buffer is
> > >    already queued. The flush unlock is now deferred to I/O completion of
> > >    the buffer from the quotacheck queue.
> > >  - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires the
> > >    flush lock to update the backing buffers with the in-core
> > >    recalculated values. This deadlocks as the flush lock was acquired by
> > >    reclaim but the buffer never submitted for I/O as it already resided
> > >    on the quotacheck queue.
> > > 
> > > This is reproduced by running quotacheck on a filesystem with a couple
> > > million inodes in low memory (512MB-1GB) situations.
> > > 
> > > Quotacheck first resets and collects the physical dquot buffers in a
> > > delwri queue. Then, it traverses the filesystem inodes via bulkstat,
> > > updates the in-core dquots, flushes the corrected dquots to the backing
> > > buffers and finally submits the delwri queue for I/O. Since the backing
> > > buffers are queued across the entire quotacheck operation, dquot reclaim
> > > cannot possibly complete a dquot flush before quotacheck completes.
> > > Therefore, dquot reclaim provides no real value during quotacheck.
> > 
> > Which is an OOM vector on systems with lots of dquots and low memory
> > at mount time. Turning off dquot reclaim doesn't change that.
> > 
> 
> It's not intended to. The inefficient design of quotacheck wrt to memory
> usage is a separate problem. AFAICT, that problem goes back as far as my
> git tree does (2.6.xx).
> 
> Looking back through the git history, this deadlock appears to be a
> regression as of commit 43ff2122e6 ("xfs: on-stack delayed write buffer
> lists") in 2012, which replaced a trylock/push sequence from the
> quotacheck flush walk with a synchronous flush lock.

Right - that's the commit that changed the code to what it is now.
That's what I implied needs fixing....

> > Address the root cause - the buffer list is never flushed and so
> > pins the memory quotacheck requires, so we need to flush the buffer
> > list more often.  We also need to submit the buffer list before the
> > flush walks begin, thereby unlocking all the dquots before doing the
> > flush walk and avoiding the deadlock.
> > 
> 
> I acknowledge that this patch doesn't address the root problem, but
> neither does this proposal. The root cause is not that quotacheck uses
> too much memory, it's that the serialization between quotacheck and
> dquot reclaim is bogus.
> 
> For example, if we drop the buffer list being held across the adjust and
> flush walks, we do indeed unpin the buffers and dquots for memory
> reclaim, particularly during the dqadjust bulkstat. The flush walk then
> still has to cycle the flush lock of every dquot to guarantee we wait on
> dquots being flushed by reclaim (otherwise we risk corruption with the
> xfs_qm_flush_one() logic is it is today). The same deadlock vector still
> exists, albeit with a smaller window, if reclaim happens to flush a
> dquot that is backed by a buffer that has already been queued by the
> flush walk. AFAICT, the only requirements for this to occur are a couple
> of dquots on a single backing buffer and some memory pressure from
> somewhere, so the local memory usage is irrelevant.

Except that the window is *tiny* because the dquots are walked in
order and so all the dquots are processed in ascending order. This
means all the dquots in a buffer are flushed sequentially, and each
dquot lookup resets the reclaim reference count count on the dquot
buffer. Hence it is extremely unlikely that a dquot buffer will be
reclaimed while it is partially flushed during the flush walk.

> I'm specifically trying to address the deadlock problem here. If we
> don't want to bypass reclaim, the other options I see are to rework the
> logic on the reclaim side to check the buffer state before we flush the
> dquot, or push on the buffer from the quotacheck side like we used to
> before the commit above.

The latter is effectively what flushing the buffer list before the
flush walk is run does.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
