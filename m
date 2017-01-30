Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753658AbdA3PbD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jan 2017 10:31:03 -0500
Date: Mon, 30 Jan 2017 10:31:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Quota-enabled XFS hangs during mount
Message-ID: <20170130153100.GA8737@bfoster.bfoster>
References: <20161103204049.GA28177@dastard>
 <43ca55d0-6762-d54f-5ba9-a83f9c1988f6@zoner.cz>
 <20170123134452.GA33287@bfoster.bfoster>
 <5b41d19b-1a0d-2b74-a633-30a5f6d2f14a@zoner.cz>
 <20170125221739.GA33995@bfoster.bfoster>
 <30d56003-a517-f6f0-d188-d0ada5a9fbb7@zoner.cz>
 <20170126191254.GB39683@bfoster.bfoster>
 <27c2f5aa-517d-22b5-b55f-f0ceb277e9a3@zoner.cz>
 <20170127170734.GA49571@bfoster.bfoster>
 <20170128224242.GD316@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170128224242.GD316@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Martin Svec <martin.svec@zoner.cz>, linux-xfs@vger.kernel.org

On Sun, Jan 29, 2017 at 09:42:42AM +1100, Dave Chinner wrote:
> On Fri, Jan 27, 2017 at 12:07:34PM -0500, Brian Foster wrote:
> > The problem looks like a race between dquot reclaim and quotacheck. The
> > high level sequence of events is as follows:
> > 
> >  - During quotacheck, xfs_qm_dqiterate() walks the physical dquot
> >    buffers and queues them to the delwri queue.
> >  - Next, kswapd kicks in and attempts to reclaim a dquot that is backed
> >    by a buffer on the quotacheck delwri queue. xfs_qm_dquot_isolate()
> >    acquires the flush lock and attempts to queue to the reclaim delwri
> >    queue. This silently fails because the buffer is already queued.
> > 
> >    From this point forward, the dquot flush lock is not going to be
> >    released until the buffer is submitted for I/O and completed via
> >    quotacheck.
> >  - Quotacheck continues on to the xfs_qm_flush_one() pass, hits the
> >    dquot in question and waits on the flush lock to issue the flush of
> >    the recalculated values. *deadlock*
> > 
> > There are at least a few ways to deal with this. We could do something
> > granular to fix up the reclaim path to check whether the buffer is
> > already queued or something of that nature before we actually invoke the
> > flush. I think this is effectively pointless, however, because the first
> > part of quotacheck walks and queues all physical dquot buffers anyways.
> > 
> > In other words, I think dquot reclaim during quotacheck should probably
> > be bypassed.
> ....
> 
> > Note that I think this does mean that you could still have low memory
> > issues if you happen to have a lot of quotas defined..
> 
> Hmmm..... Really needs fixing.
> 

Perhaps...

> I think submitting the buffer list after xfs_qm_dqiterate() and
> waiting for completion will avoid this problem.
> 

Yeah. I don't _think_ there are correctness issues since this is at
mount time and thus we don't have the risk of something else dirtying
and flushing a dquot before quotacheck has updated the dquots. The
tradeoff here just seems to be performance. We're now going to write all
of the dquot buffers twice in the common cause to handle the uncommon
low memory case.

It's also worth noting that 1.) I haven't actually investigated how many
dquots would need to exist vs. how little RAM before this becomes a
problem in practice and 2.) we still build up a delwri queue of all the
buffers and despite that there will always be fewer buffers than dquots,
there's nothing to suggest that won't ever pose a problem before the
dquots do if memory is limited enough.

The flip side is that this a pretty minor change code wise..

> However, I suspect reclaim can still race with flushing, so we need
> to detect "stuck" dquots, submit the delwri buffer queue and wait,
> then flush the dquot again.
> 

How so? The first phase of quotacheck resets the dquot buffers and
populates buffer_list. If we submit the queue at that point, we've now
dropped all references to buffers from quotacheck. The next phase of
quotacheck, xfs_qm_dqusage_adjust(), will acquire and dirty the
associated dquots as we bulkstat each inode in the fs.

The prospective difference here is that the dquots can now be flushed
asynchronously by reclaim as this occurs. So quotacheck dirties a dquot,
reclaim kicks in and flushes it, but is now able to actually complete
the flush by adding it to the reclaim delwri queue and submitting the
I/O. If the dqusage_adjust() walk now encounters the dquot again, it may
very well have to allocate and dirty the dquot again (and/or re-read the
dquot buf?) if it has been reclaimed since. I think the risk here is
that we end up thrashing and send I/Os for every per-inode change to a
dquot.

Finally, we get to the xfs_qm_flush_one() walk to flush every dquot that
has been dirtied. If reclaim races at this point, reclaim and
flush_one() should contend on the dquot lock and one or the other be
allowed to flush and queue the buffer. If reclaim wins the race, we may
end up waiting on reclaim I/O in quotacheck, however, due to the
xfs_dqflock() call (perhaps that could be converted to a nowait() lock
and skipped on failure).

I don't think there is a deadlock there, unless I am missing something.
But given that all of this reclaim behavior was enabled purely by
accident and the report in this case is caused by improper serialization
as opposed to a low memory issue that actually depends on (and thus
stresses) a functional reclaim, I'm not convinced this is the right fix
for this problem. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
