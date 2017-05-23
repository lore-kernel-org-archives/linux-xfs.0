Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752359AbdEWQWG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 12:22:06 -0400
Date: Tue, 23 May 2017 12:22:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170523162202.GB7632@bfoster.bfoster>
References: <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170517005749.GO17542@dastard>
 <20170517104111.aziwbvqpfcbgxnxa@eorzea.usersys.redhat.com>
 <20170519002227.GS17542@dastard>
 <20170519112659.GB64091@bfoster.bfoster>
 <20170519233900.GT17542@dastard>
 <20170520114654.GA3888@bfoster.bfoster>
 <20170521231906.GU17542@dastard>
 <20170522125110.GA11578@bfoster.bfoster>
 <20170523112318.GX17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523112318.GX17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 23, 2017 at 09:23:18PM +1000, Dave Chinner wrote:
> On Mon, May 22, 2017 at 08:51:13AM -0400, Brian Foster wrote:
> > On Mon, May 22, 2017 at 09:19:06AM +1000, Dave Chinner wrote:
> > > On Sat, May 20, 2017 at 07:46:56AM -0400, Brian Foster wrote:
> > > > On Sat, May 20, 2017 at 09:39:00AM +1000, Dave Chinner wrote:
> > > > > Adding new flags to the same field that can be asynchronously
> > > > > updated by RMW operations outside the ailp->xa_lock will cause
> > > > > problems in future. There *may not* be a problem right now, but it
> > > > > is poor programming practice to have different coherency processes
> > > > > for the same variable that is updated via RMW operations. In these
> > > > > situations, the only safe way to update the variable is to use an
> > > > > atomic operation.
> > > > > 
> > > > 
> > > > So is there a reason why we couldn't acquire ->xa_lock to fail the log
> > > > items as we would have done anyways if the metadata writeback had
> > > > succeeded and we were removing the log items from the AIL..
> > > 
> > > Yes. the alip->xa_lock protects AIL state is a highly contended
> > > lock. It should not be used for things that aren't AIL related
> > > because that will have performance and scalability implications.
> > > 
> > 
> > The purpose of this flag is to control AIL retry processing, how is this
> > not AIL related?
> 
> It's IO state, not AIL state. IO submission occurs from more places
> than and AIL push (e.g. inode reclaim, inode clustering, etc) and
> there's no way we should be exposing the internal AIL state lock in
> places like that.
> 

That's reasonable, though it suggests different code from what this
patchset currently does. This would be far more useful if we could focus
on correctness of the code first and foremost. If the code we commit
actually warrants this kind of change, then this becomes a much easier
(i.e., pointless :P) discussion from my end.

As it is, this patch only ever clears the flag on AIL resubmission. ISTM
you are indirectly suggesting that should occur in other contexts as
well (e.g., consider a reclaim and flush of another inode backed by a
buffer that is already failed, and has other inodes sitting in the AIL
flush locked). If that is the case, please elaborate, because otherwise
it is kind of impossible to evaluate and discuss without specifics.

> > All that said, the bitops change is harmless and there are only a few
> > flags to deal with, so I don't think it really matters much. I just
> > think it would be nice to avoid an artificial backport dependency. IOW,
> > I think this patch should use ->xa_lock as is and can be immediately
> > followed by a patch to convert the li_flags to bit ops and remove the
> > ->xa_lock from contexts where it is no longer necessary (with documented
> > justification).
> 
> Then it needs to be done as a single patch set with the fix you want
> to backport as the first patch, otherwise the bitop change not get
> done until someone does scalability tests and trips over it and then
> we've got more shit to backport to fix performance regressions.
> 

The point is that the atomic bitmask change doesn't need to be
backported at all. Notwithstanding potential changes to the patches as
they currently stand (as noted above), it doesn't actually fix anything,
performance or otherwise.

As it is, this patch would only add an acquisition of ->xa_lock in
completion context on I/O failure. Exactly what workload would you
expect to be affected by changes to I/O error handling? How would it be
any different than what we already do on normal I/O completion?

> > > > IOW, doesn't this mean we need to check and handle LI_FAILED first off
> > > > in ->iop_push() and not just in response to flush lock failure?
> > > 
> > > It's entirely possible that we need to do that. This whole "don't
> > > endlessly retry failed buffer writes" thing is a substantial change
> > > in behaviour, so there's bound to be interactions that we don't get
> > > right the first time...
> > > 
> > 
> > I'm not sure if you're referring to this patch or the broader error
> > configuration stuff here... Note that this patch doesn't change the
> > fundamental behavior that the AIL retries failed buffers (subject to the
> > error config). I tend to get this mixed up, but IIUC this has been
> > traditional behavior for things like buffers, for example, for quite
> > some time.
> 
> Yes, but the change is that now we rely on the AIL push to trigger
> cleanup of failed buffers on unmount, whereas previously the unmount
> just hung endlessly retrying the failed buffers. i.e. we used to
> accept this hang as "expected behaviour" but now it's considered a
> bug we have to fix. Hence we now have to handle retries and failures
> and untangle the locking issues we've not had to care about for 20
> years.
> 

This completely mischaracterizes the problem. If this problem occurs,
log deadlock is the most likely outcome. An unmount is simply part of
the most common test method to immediately observe a hang that is
otherwise already imminent based on previous events. This is not a pure
unmount problem and afaict not associated with any recent behavior
changes with regard to buffer I/O error handling.

> As it is, the "only check failure if flush lock fails" idea was
> designed to prevent having to lookup the backing buffer to check for
> failure for every inode we wanted to flush as those lookups are too
> expensive to do on every inode we need to flush. However, if we are
> propagating the failure state to the log item on IO completion,
> checking this state is not expensive any more, so there's no need to
> hide it until we detect a state that may indicate an IO failure....
> 

Indeed.

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
