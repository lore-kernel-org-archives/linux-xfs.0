Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31661 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754223AbdDRCfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Apr 2017 22:35:54 -0400
Date: Tue, 18 Apr 2017 12:35:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid
 quotacheck deadlock
Message-ID: <20170418023548.GX17542@dastard>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-3-git-send-email-bfoster@redhat.com>
 <20170410050001.GI23007@dastard>
 <20170410141521.GB3991@bfoster.bfoster>
 <20170410235525.GA12369@dastard>
 <20170411145300.GA12111@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411145300.GA12111@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Tue, Apr 11, 2017 at 10:53:03AM -0400, Brian Foster wrote:
> On Tue, Apr 11, 2017 at 09:55:25AM +1000, Dave Chinner wrote:
> > We hold the buffer locked, the dquot is locked and the dquot is
> > flush locked already, right? We know the IO has not been submitted
> > because we have the buffer lock and the dquot is still flush locked,
> > which means /some/ dirty dquot data is already in the buffer.
> > 
> 
> Essentially. The buffer is queued and the dquot flush locked by reclaim.
> By the time we get to the problematic scenario, we acquire the dquot
> lock and can acquire the buffer lock in response to flush lock failure.
> The buffer cannot be under I/O because we hold it on the local delwri
> queue.

Seems to me that you've missed the fundamental reason that the
buffer can't be under IO. It's not because it's on some local
private queue, it can't be under IO because /we hold the buffer
lock/.

> > So why can't we just modify the dquot in the buffer?  We already
> > hold all the locks needed to guarantee exclusive access to the dquot
> > and buffer, and they are all we hold when we do the initial flush to
> > the buffer. So why do we need to do IO to unlock the dquot flush
> > lock when we could just rewrite before we submit the buffer for IO?
> > 
> 
> Are you suggesting to essentially ignore the flush lock? I suppose we
> could get away with this in dq_flush_one() since it is only called from
> quotacheck, but we may have to kill off any assertions that expect the
> flush lock in xfs_dqflush(), and perhaps refactor that code to accept a
> locked buffer as a param.

No, I'm not suggesting we ignore the flush lock. What the flush
"lock" does is prevent higher layer attempts to flush the dquot to
the backing buffer whilst IO may be in progress. It's higher level
function is to allows async log item state updates to be done
correctly w.r.t. relogging and flushing, as we allow transactional
modifications to inodes and dquots while they are under IO.

But to flush an object, we have to own the object lock, the flush
lock and the underlying buffer lock. To flush a dquot (or inode) we
need to, in order:

	a) lock the dquot (inode)
	b) obtain the flush lock
	c) obtain the buffer lock
	d) flush the dquot to the buffer
	e) update log item state
	f) unlock the buffer

IO is then effectively:

	a) lock buffer
	b) submit IO
	<IO completes>
	b) dquot callback unlocks flush lock
	a) buffer is unlocked

IOWs, the flush "lock" does not work on it's own. It's really a
completion notifier, not a lock, and it's actually implemented that
way now. The name is historical because it used a semaphore when
that was all Irix or Linux had to implement an async non-owner
object release. That is, when we lock and flush the object, we
effective hand the "flush lock" to the buffer, as it is the buffer
that is responsible for "unlocking" it on IO completion.

The "lock" function prevents the higher layers from trying to update
the buffer until the buffer says "it's OK to modify me", but it does
not mean we cannot modify the buffer contents if we hold all the
correct context - the "modify the buffer" action is the inner most.

IOWs, if we lock the buffer and the buffer owns the flush lock state
for the object, then if we are able to lock the object, we have now
have exclusive access to both the logical object, the log item
associated with it, the backing buffer and the flush context lock.
And with all that context held, it is safe to flush the logical
object state to the backing buffer....

i.e. rather than locking from the top down to get to the state where
we can flush an object, we can lock objects from the bottom up and
end up in the same place...

> I don't see anything that would break off hand, but my first reaction is
> it sounds more hackish than this patch or the previous patch that just
> disabled reclaim during quotacheck.

I thought we'd done that discussion. i.e. we can't disable reclaim
in quotacheck because that can set off the OOM killer...

> In fact, if we're going to hack
> around avoiding the flush lock, why not just hack up xfs_buf_submit() to
> allow submission of a buffer while it remains on a delwri queue? AFAICT,
> that would only require removing an assert and not clearing the flag on
> I/O completion. I'm not convinced I'd post something for either
> approach, but I'd have to think about it some more.
> 
> > Indeed, let's go look at inodes for an example of this, 
> > xfs_ifree_cluster() to be precise:
> > 
> >                 /*                                                               
> >                  * We obtain and lock the backing buffer first in the process    
> >                  * here, as we have to ensure that any dirty inode that we       
> >                  * can't get the flush lock on is attached to the buffer.        
> >                  * If we scan the in-memory inodes first, then buffer IO can     
> >                  * complete before we get a lock on it, and hence we may fail    
> >                  * to mark all the active inodes on the buffer stale.            
> >                  */                                                              
> >  .....
> >                 /*                                                               
> >                  * Walk the inodes already attached to the buffer and mark them  
> >                  * stale. These will all have the flush locks held, so an        
> >                  * in-memory inode walk can't lock them. By marking them all     
> >                  * stale first, we will not attempt to lock them in the loop     
> >                  * below as the XFS_ISTALE flag will be set.                     
> >                  */                                                              
> > .....
> >                 /*                                                               
> >                  * For each inode in memory attempt to add it to the inode       
> >                  * buffer and set it up for being staled on buffer IO            
> >                  * completion.  This is safe as we've locked out tail pushing    
> >                  * and flushing by locking the buffer.                           
> >                  *                                                               
> >                  * We have already marked every inode that was part of a         
> >                  * transaction stale above, which means there is no point in     
> >                  * even trying to lock them.                                     
> >                  */                                                              
> > 
> > IOWs, what we have here is precendence for modifying the flush
> > locked objects attached to a buffer after first locking the buffer.
> > dquots have the same transaction/flush model as inodes, so I'm
> > pretty sure this will lead to the simplest, cleanest way to avoid
> > this deadlock....
> > 
> 
> The simplest approach to avoid the deadlock is to disable dquot reclaim
> during quotacheck. ;)
> 
> On a quick scan through the inode code, it seems the above refer to
> using the buffer lock to serialize invalidation of higher level objects
> based on the buffer. IOW, to ensure that we don't leave "valid" in-core
> inode objects referring to an inode metadata buffer that is about to be
> invalidated.

Yes, we lock from the bottom up until we have exclusive access to
the objects. Invalidation is the /purpose/ of that code, not the
architectural mechanism used to lock the objects into a state where
we can then invalidate them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
