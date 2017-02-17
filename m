Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934144AbdBQSkO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:40:14 -0500
Date: Fri, 17 Feb 2017 13:30:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: bypass dquot reclaim to avoid quotacheck
 deadlock
Message-ID: <20170217183009.GB20429@bfoster.bfoster>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
 <1487173247-5965-2-git-send-email-bfoster@redhat.com>
 <20170216223705.GC15349@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170216223705.GC15349@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Fri, Feb 17, 2017 at 09:37:05AM +1100, Dave Chinner wrote:
> On Wed, Feb 15, 2017 at 10:40:43AM -0500, Brian Foster wrote:
> > Reclaim during quotacheck can lead to deadlocks on the dquot flush lock:
> > 
> >  - Quotacheck populates a local delwri queue with the physical dquot
> >    buffers.
> >  - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and dirties
> >    all of the dquots.
> >  - Reclaim kicks in and attempts to flush a dquot whose buffer is
> >    already queud on the quotacheck queue. The flush succeeds but
> >    queueing to the reclaim delwri queue fails as the backing buffer is
> >    already queued. The flush unlock is now deferred to I/O completion of
> >    the buffer from the quotacheck queue.
> >  - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires the
> >    flush lock to update the backing buffers with the in-core
> >    recalculated values. This deadlocks as the flush lock was acquired by
> >    reclaim but the buffer never submitted for I/O as it already resided
> >    on the quotacheck queue.
> > 
> > This is reproduced by running quotacheck on a filesystem with a couple
> > million inodes in low memory (512MB-1GB) situations.
> > 
> > Quotacheck first resets and collects the physical dquot buffers in a
> > delwri queue. Then, it traverses the filesystem inodes via bulkstat,
> > updates the in-core dquots, flushes the corrected dquots to the backing
> > buffers and finally submits the delwri queue for I/O. Since the backing
> > buffers are queued across the entire quotacheck operation, dquot reclaim
> > cannot possibly complete a dquot flush before quotacheck completes.
> > Therefore, dquot reclaim provides no real value during quotacheck.
> 
> Which is an OOM vector on systems with lots of dquots and low memory
> at mount time. Turning off dquot reclaim doesn't change that.
> 

It's not intended to. The inefficient design of quotacheck wrt to memory
usage is a separate problem. AFAICT, that problem goes back as far as my
git tree does (2.6.xx).

Looking back through the git history, this deadlock appears to be a
regression as of commit 43ff2122e6 ("xfs: on-stack delayed write buffer
lists") in 2012, which replaced a trylock/push sequence from the
quotacheck flush walk with a synchronous flush lock.

> Address the root cause - the buffer list is never flushed and so
> pins the memory quotacheck requires, so we need to flush the buffer
> list more often.  We also need to submit the buffer list before the
> flush walks begin, thereby unlocking all the dquots before doing the
> flush walk and avoiding the deadlock.
> 

I acknowledge that this patch doesn't address the root problem, but
neither does this proposal. The root cause is not that quotacheck uses
too much memory, it's that the serialization between quotacheck and
dquot reclaim is bogus.

For example, if we drop the buffer list being held across the adjust and
flush walks, we do indeed unpin the buffers and dquots for memory
reclaim, particularly during the dqadjust bulkstat. The flush walk then
still has to cycle the flush lock of every dquot to guarantee we wait on
dquots being flushed by reclaim (otherwise we risk corruption with the
xfs_qm_flush_one() logic is it is today). The same deadlock vector still
exists, albeit with a smaller window, if reclaim happens to flush a
dquot that is backed by a buffer that has already been queued by the
flush walk. AFAICT, the only requirements for this to occur are a couple
of dquots on a single backing buffer and some memory pressure from
somewhere, so the local memory usage is irrelevant.

I'm specifically trying to address the deadlock problem here. If we
don't want to bypass reclaim, the other options I see are to rework the
logic on the reclaim side to check the buffer state before we flush the
dquot, or push on the buffer from the quotacheck side like we used to
before the commit above. I think the latter may be more robust as it
isolates the logic to quotacheck. The risk there is that we're open to
pushing buffers off the reclaim list, but that might be fine so long as
we have the buffer lock.

I'm open to other ideas of course, but so far "flushing the buffer list
more often" isn't clear enough to suggest it actually solves the locking
problem... I'll put a quotacheck rework on my todo list as well, but
that's something I'll have to get to separately (but I'm happy to help
if anybody else wants to jump on that sooner.. ;).

Brian

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
