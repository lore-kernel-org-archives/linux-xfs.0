Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59648 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933654AbdEWLXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 07:23:22 -0400
Date: Tue, 23 May 2017 21:23:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170523112318.GX17542@dastard>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170517005749.GO17542@dastard>
 <20170517104111.aziwbvqpfcbgxnxa@eorzea.usersys.redhat.com>
 <20170519002227.GS17542@dastard>
 <20170519112659.GB64091@bfoster.bfoster>
 <20170519233900.GT17542@dastard>
 <20170520114654.GA3888@bfoster.bfoster>
 <20170521231906.GU17542@dastard>
 <20170522125110.GA11578@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170522125110.GA11578@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 08:51:13AM -0400, Brian Foster wrote:
> On Mon, May 22, 2017 at 09:19:06AM +1000, Dave Chinner wrote:
> > On Sat, May 20, 2017 at 07:46:56AM -0400, Brian Foster wrote:
> > > On Sat, May 20, 2017 at 09:39:00AM +1000, Dave Chinner wrote:
> > > > Adding new flags to the same field that can be asynchronously
> > > > updated by RMW operations outside the ailp->xa_lock will cause
> > > > problems in future. There *may not* be a problem right now, but it
> > > > is poor programming practice to have different coherency processes
> > > > for the same variable that is updated via RMW operations. In these
> > > > situations, the only safe way to update the variable is to use an
> > > > atomic operation.
> > > > 
> > > 
> > > So is there a reason why we couldn't acquire ->xa_lock to fail the log
> > > items as we would have done anyways if the metadata writeback had
> > > succeeded and we were removing the log items from the AIL..
> > 
> > Yes. the alip->xa_lock protects AIL state is a highly contended
> > lock. It should not be used for things that aren't AIL related
> > because that will have performance and scalability implications.
> > 
> 
> The purpose of this flag is to control AIL retry processing, how is this
> not AIL related?

It's IO state, not AIL state. IO submission occurs from more places
than and AIL push (e.g. inode reclaim, inode clustering, etc) and
there's no way we should be exposing the internal AIL state lock in
places like that.

> All that said, the bitops change is harmless and there are only a few
> flags to deal with, so I don't think it really matters much. I just
> think it would be nice to avoid an artificial backport dependency. IOW,
> I think this patch should use ->xa_lock as is and can be immediately
> followed by a patch to convert the li_flags to bit ops and remove the
> ->xa_lock from contexts where it is no longer necessary (with documented
> justification).

Then it needs to be done as a single patch set with the fix you want
to backport as the first patch, otherwise the bitop change not get
done until someone does scalability tests and trips over it and then
we've got more shit to backport to fix performance regressions.

> > > IOW, doesn't this mean we need to check and handle LI_FAILED first off
> > > in ->iop_push() and not just in response to flush lock failure?
> > 
> > It's entirely possible that we need to do that. This whole "don't
> > endlessly retry failed buffer writes" thing is a substantial change
> > in behaviour, so there's bound to be interactions that we don't get
> > right the first time...
> > 
> 
> I'm not sure if you're referring to this patch or the broader error
> configuration stuff here... Note that this patch doesn't change the
> fundamental behavior that the AIL retries failed buffers (subject to the
> error config). I tend to get this mixed up, but IIUC this has been
> traditional behavior for things like buffers, for example, for quite
> some time.

Yes, but the change is that now we rely on the AIL push to trigger
cleanup of failed buffers on unmount, whereas previously the unmount
just hung endlessly retrying the failed buffers. i.e. we used to
accept this hang as "expected behaviour" but now it's considered a
bug we have to fix. Hence we now have to handle retries and failures
and untangle the locking issues we've not had to care about for 20
years.

As it is, the "only check failure if flush lock fails" idea was
designed to prevent having to lookup the backing buffer to check for
failure for every inode we wanted to flush as those lookups are too
expensive to do on every inode we need to flush. However, if we are
propagating the failure state to the log item on IO completion,
checking this state is not expensive any more, so there's no need to
hide it until we detect a state that may indicate an IO failure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
