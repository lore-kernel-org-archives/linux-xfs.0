Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:65499 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751715AbdHLAQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 20:16:58 -0400
Date: Sat, 12 Aug 2017 10:16:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170812001637.GW21024@dastard>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
 <20170810113322.GM21024@dastard>
 <63920C3663124B75BC0983A17533395A@alyakaslap>
 <20170810145248.GE3777@bfoster.bfoster>
 <20170810175548.GX24087@magnolia>
 <20170810183233.GG3777@bfoster.bfoster>
 <20170811022204.GQ21024@dastard>
 <20170811142741.GA18609@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811142741.GA18609@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Fri, Aug 11, 2017 at 10:27:43AM -0400, Brian Foster wrote:
> On Fri, Aug 11, 2017 at 12:22:04PM +1000, Dave Chinner wrote:
> > On Thu, Aug 10, 2017 at 02:32:33PM -0400, Brian Foster wrote:
> > > On Thu, Aug 10, 2017 at 10:55:48AM -0700, Darrick J. Wong wrote:
> > > > On Thu, Aug 10, 2017 at 10:52:49AM -0400, Brian Foster wrote:
> > > > > On Thu, Aug 10, 2017 at 03:09:09PM +0300, Alex Lyakas wrote:
> > > ...
> > > > > OTOH, just adding deferred ops buffer relogging might not be too much
> > > > > trouble either. ;) Anyways, thoughts?
> > > > 
> > > > I don't think it'd be difficult to add a _defer_bjoin operation that
> > > > maintains a list of buffers that we need to bhold across rolls.
> > > > 
> > > > I think xfs_buf->b_list is only used for delwri buffers, and a buffer
> > > > cannot be part of a transaction /and/ on a delwri list at the same time,
> > > > right?  So it shouldn't be hard to whip something up and couple this
> > > > patch to that.
> > > > 
> > > 
> > > Hmm.. so if a buffer is modified, logged, committed, put on the AIL and
> > > pushed, xfs_buf_item_push() locks it, puts it on the delwri queue and
> > > unlocks. At that point, I _think_ it may be possible for another thread
> > > to lock the buffer and join it to a new transaction. The delwri submit
> > > skips the buffer if it has become pinned or locked since the delwri
> > > queue (though I'm wondering if that unlocked pin check is racy against
> > > locked buffer modifications. I suppose that would require a full
> > > lock->pin->unlock cycle between the pin check and trylock however).
> > 
> > If it does race, we still catch pinned buffers in xfs_buf_submit() and
> > block there on them. SO a race is just sub-optimal behaviour, not a
> > bug.
> > 
> 
> Ah I see, thanks.
> 
> > > The question I have for buffer relogging is what's the best way to track
> > > the parts of the buffer that need to be relogged after a roll?
> > > Copy/translate the dirty (xfs_buf_log_format) segment map(s)?
> > 
> > Just mark it ordered?
> > 
> > That way it goes through the transaction commit, pinned and put into
> > the CIL and  gets moved forward in the AIL when the log checkpoints.
> > We don't need to relog the actual contents in this case, just ensure
> > it moves forward in the AIL appropriately while we hold it locked.
> 
> Hmm.. is it safe to mark a previously logged and AIL resident buffer
> ordered in a subsequent transaction?

That's what I'm asking - can we mark it ordered and not have to
worry about what is already dirty?

> The problem in this particular
> example is that the empty leaf buffer is logged, committed and unpinned
> (and thus AIL resident). We want to relog the buffer to move it forward
> in the AIL on the next transaction because we're holding it locked and
> thus it cannot be written back (and thus could pin the log tail).

Yup.

> If we mark the buffer ordered in the subsequent transaction and that
> transaction commits/checkpoints to the log, don't we push the buffer
> forward in the AIL to a checkpoint that doesn't have the originally
> logged data..? IOW, it seems like if this does end up pushing the tail
> of the log and we crash, we've thrown away checkpointed but not written
> back metadata and potentially corrupted the fs. Hm?

Relogging of existing dirty regions is supposed to solve this
problem. i.e. while the log item is dirty in the AIL, any
transaction that logs and commits the log item will also log all the
existing dirty regions on the buffer, hence the next checkpoint will
contain everything it's supposed to.

Hence in this case, we don't need to log any new regions of the
buffer because it already has a record of all the dirty regions on
it from the prior transaction we committed.  That means we don't
actually need to mark any new ranges dirty, we just need to mark the
log item dirty again to trigger relogging of the existing dirty
ranges on the buffer.

Using XFS_BLI_ORDERED allows us to log the buffer without recording
a new dirty range on the buffer. IOWs, it retains whatever dirty range
it already had, and so after joining, marking it ordered and then
logging the buffer, we have a XFS_BLI_DIRTY | XFS_BLI_ORDERED buffer
in the transaction.

The question is this: what happens when a XFS_BLI_ORDERED buffer
with a pre-existing dirty region is formatted for the CIL? We
haven't done that before, so I'm betting that we don't relog the
dirty region like we should be doing....

... and we don't relog the existing dirty range because the
ordered flag takes precedence.

Ok, the ordered buffer checks in xfs_buf_item_size() and
xfs_buf_item_format() need to also check for dirty regions. If dirty
regions exist, then we treat it like a normal buffer rather than an
ordered buffer. We can factor the dirty region check out of
xfs_buf_item_unlock() for this...

Actually, check the case in xfs_buf_item_size() and remove the
ordered flag if there are dirty regions. Then xfs_buf_item_format()
will do the right thing without needing a duplicate check...

Nothing in XFS is ever simple, is it? :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
