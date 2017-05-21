Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:7593 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932463AbdEUXTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 May 2017 19:19:10 -0400
Date: Mon, 22 May 2017 09:19:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170521231906.GU17542@dastard>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170517005749.GO17542@dastard>
 <20170517104111.aziwbvqpfcbgxnxa@eorzea.usersys.redhat.com>
 <20170519002227.GS17542@dastard>
 <20170519112659.GB64091@bfoster.bfoster>
 <20170519233900.GT17542@dastard>
 <20170520114654.GA3888@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170520114654.GA3888@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sat, May 20, 2017 at 07:46:56AM -0400, Brian Foster wrote:
> On Sat, May 20, 2017 at 09:39:00AM +1000, Dave Chinner wrote:
> > Adding new flags to the same field that can be asynchronously
> > updated by RMW operations outside the ailp->xa_lock will cause
> > problems in future. There *may not* be a problem right now, but it
> > is poor programming practice to have different coherency processes
> > for the same variable that is updated via RMW operations. In these
> > situations, the only safe way to update the variable is to use an
> > atomic operation.
> > 
> 
> So is there a reason why we couldn't acquire ->xa_lock to fail the log
> items as we would have done anyways if the metadata writeback had
> succeeded and we were removing the log items from the AIL..

Yes. the alip->xa_lock protects AIL state is a highly contended
lock. It should not be used for things that aren't AIL related
because that will have performance and scalability implications.

> (e.g., why
> introduce new serialization rules if we don't need to)?

Becuase we don't tie independent object operational state to a
single subsystem's internal locking requirements. If the log item
does not have it's own context lock (which it doesn't), then we need
to use atomic operations to serialise flag updates across different
subsystems so they can safely maintain their own independent
internal locking schemes.

An example is the inode flags - they are serialised by the
i_flags_lock spinlock because there are multiple state changes that
need to be done atomically through different subsystems (including
RCU freeing state).  We serialise these updates by an object lock
rather than a subsystem lock because it's the only way we can share
the flag field across different subsystems safely...

> > > But otherwise given the above, that this is primarily I/O error path
> > > code, and that we presumably already have serialization mechanisms in
> > > place in the form of parent object locks, why not just grab the inode
> > > lock in the appropriate places?
> > 
> > Because we can't guarantee that we can lock the parent object in IO
> > completion. Deadlock is trivial: process A grabs parent object,
> > blocks on flush lock. IO completion holds flush lock, blocks trying
> > to get parent object lock.
> > 
> 
> Ah, right. So once we acquire the flush lock and drop the ilock, we
> can no longer block on the ilock from a context responsible for
> releasing the flush lock.
> 
> That makes sense, but raises a larger question... if "process A" can
> cause this kind of locking problem in I/O completion context, what
> prevents it from interfering with (re)submission context just the same?
> For example, the AIL pushes an inode, locks, flushes and submits the
> underlying buffer. The buffer I/O fails and is ultimately released back
> to the AIL. Process A comes in, locks the inode and blocks on the flush
> lock.  Subsequent AIL pushes and retry attempts fail to lock the inode,
> never even get to the point of checking for LI_FAILED and thus we're
> back to the same problem we have today.
> 
> IOW, doesn't this mean we need to check and handle LI_FAILED first off
> in ->iop_push() and not just in response to flush lock failure?

It's entirely possible that we need to do that. This whole "don't
endlessly retry failed buffer writes" thing is a substantial change
in behaviour, so there's bound to be interactions that we don't get
right the first time...

Cheers,

Dave.

> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

-- 
Dave Chinner
david@fromorbit.com
