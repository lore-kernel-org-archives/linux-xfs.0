Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751923AbdEVMvP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 08:51:15 -0400
Date: Mon, 22 May 2017 08:51:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170522125110.GA11578@bfoster.bfoster>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170517005749.GO17542@dastard>
 <20170517104111.aziwbvqpfcbgxnxa@eorzea.usersys.redhat.com>
 <20170519002227.GS17542@dastard>
 <20170519112659.GB64091@bfoster.bfoster>
 <20170519233900.GT17542@dastard>
 <20170520114654.GA3888@bfoster.bfoster>
 <20170521231906.GU17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170521231906.GU17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 09:19:06AM +1000, Dave Chinner wrote:
> On Sat, May 20, 2017 at 07:46:56AM -0400, Brian Foster wrote:
> > On Sat, May 20, 2017 at 09:39:00AM +1000, Dave Chinner wrote:
> > > Adding new flags to the same field that can be asynchronously
> > > updated by RMW operations outside the ailp->xa_lock will cause
> > > problems in future. There *may not* be a problem right now, but it
> > > is poor programming practice to have different coherency processes
> > > for the same variable that is updated via RMW operations. In these
> > > situations, the only safe way to update the variable is to use an
> > > atomic operation.
> > > 
> > 
> > So is there a reason why we couldn't acquire ->xa_lock to fail the log
> > items as we would have done anyways if the metadata writeback had
> > succeeded and we were removing the log items from the AIL..
> 
> Yes. the alip->xa_lock protects AIL state is a highly contended
> lock. It should not be used for things that aren't AIL related
> because that will have performance and scalability implications.
> 

The purpose of this flag is to control AIL retry processing, how is this
not AIL related? If the I/O succeeds, we grab ->xa_lock to remove the
items from the AIL. If the I/O fails, we can't grab ->xa_lock to tag the
items as failed (so the AIL knows if/how to retry the item(s)) because
of performance and scalability concerns..?

In fact, having taken another look at the code, you could make the
argument that failure to take the ->xa_lock is a landmine should the AIL
task ever expect to observe consistent state across the affected set of
items (independent from atomic li_flags updates).

> > (e.g., why
> > introduce new serialization rules if we don't need to)?
> 
> Becuase we don't tie independent object operational state to a
> single subsystem's internal locking requirements. If the log item
> does not have it's own context lock (which it doesn't), then we need
> to use atomic operations to serialise flag updates across different
> subsystems so they can safely maintain their own independent
> internal locking schemes.
> 
> An example is the inode flags - they are serialised by the
> i_flags_lock spinlock because there are multiple state changes that
> need to be done atomically through different subsystems (including
> RCU freeing state).  We serialise these updates by an object lock
> rather than a subsystem lock because it's the only way we can share
> the flag field across different subsystems safely...
> 

This makes sense in principle and from the perspective that it might
matter for some future changes/flags, I just don't think this patch
really departs from our existing serialization model wrt to the AIL. We
aren't adding the serialization requirement to any new context where it
doesn't already exist. Therefore, (IMO) it's mostly an overcomplication
to rework serialization as a dependency for this fix.

All that said, the bitops change is harmless and there are only a few
flags to deal with, so I don't think it really matters much. I just
think it would be nice to avoid an artificial backport dependency. IOW,
I think this patch should use ->xa_lock as is and can be immediately
followed by a patch to convert the li_flags to bit ops and remove the
->xa_lock from contexts where it is no longer necessary (with documented
justification).

> > > > But otherwise given the above, that this is primarily I/O error path
> > > > code, and that we presumably already have serialization mechanisms in
> > > > place in the form of parent object locks, why not just grab the inode
> > > > lock in the appropriate places?
> > > 
> > > Because we can't guarantee that we can lock the parent object in IO
> > > completion. Deadlock is trivial: process A grabs parent object,
> > > blocks on flush lock. IO completion holds flush lock, blocks trying
> > > to get parent object lock.
> > > 
> > 
> > Ah, right. So once we acquire the flush lock and drop the ilock, we
> > can no longer block on the ilock from a context responsible for
> > releasing the flush lock.
> > 
> > That makes sense, but raises a larger question... if "process A" can
> > cause this kind of locking problem in I/O completion context, what
> > prevents it from interfering with (re)submission context just the same?
> > For example, the AIL pushes an inode, locks, flushes and submits the
> > underlying buffer. The buffer I/O fails and is ultimately released back
> > to the AIL. Process A comes in, locks the inode and blocks on the flush
> > lock.  Subsequent AIL pushes and retry attempts fail to lock the inode,
> > never even get to the point of checking for LI_FAILED and thus we're
> > back to the same problem we have today.
> > 
> > IOW, doesn't this mean we need to check and handle LI_FAILED first off
> > in ->iop_push() and not just in response to flush lock failure?
> 
> It's entirely possible that we need to do that. This whole "don't
> endlessly retry failed buffer writes" thing is a substantial change
> in behaviour, so there's bound to be interactions that we don't get
> right the first time...
> 

I'm not sure if you're referring to this patch or the broader error
configuration stuff here... Note that this patch doesn't change the
fundamental behavior that the AIL retries failed buffers (subject to the
error config). I tend to get this mixed up, but IIUC this has been
traditional behavior for things like buffers, for example, for quite
some time. The problem here is that the AIL doesn't correctly issue
retries for certain items (i.e., those with flush locks), so we're just
unraveling a livelock in the log subsystem (as opposed to changing
behavior).

Brian

> Cheers,
> 
> Dave.
> 
> > 
> > Brian
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
