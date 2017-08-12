Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdHLOEg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 12 Aug 2017 10:04:36 -0400
Date: Sat, 12 Aug 2017 10:04:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170812140433.GA31523@bfoster.bfoster>
References: <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
 <20170810113322.GM21024@dastard>
 <63920C3663124B75BC0983A17533395A@alyakaslap>
 <20170810145248.GE3777@bfoster.bfoster>
 <20170810175548.GX24087@magnolia>
 <20170810183233.GG3777@bfoster.bfoster>
 <20170811022204.GQ21024@dastard>
 <20170811142741.GA18609@bfoster.bfoster>
 <20170812001637.GW21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170812001637.GW21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Sat, Aug 12, 2017 at 10:16:37AM +1000, Dave Chinner wrote:
> On Fri, Aug 11, 2017 at 10:27:43AM -0400, Brian Foster wrote:
> > On Fri, Aug 11, 2017 at 12:22:04PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 10, 2017 at 02:32:33PM -0400, Brian Foster wrote:
> > > > On Thu, Aug 10, 2017 at 10:55:48AM -0700, Darrick J. Wong wrote:
> > > > > On Thu, Aug 10, 2017 at 10:52:49AM -0400, Brian Foster wrote:
...
> > > > The question I have for buffer relogging is what's the best way to track
> > > > the parts of the buffer that need to be relogged after a roll?
> > > > Copy/translate the dirty (xfs_buf_log_format) segment map(s)?
> > > 
> > > Just mark it ordered?
> > > 
> > > That way it goes through the transaction commit, pinned and put into
> > > the CIL and  gets moved forward in the AIL when the log checkpoints.
> > > We don't need to relog the actual contents in this case, just ensure
> > > it moves forward in the AIL appropriately while we hold it locked.
> > 
> > Hmm.. is it safe to mark a previously logged and AIL resident buffer
> > ordered in a subsequent transaction?
> 
> That's what I'm asking - can we mark it ordered and not have to
> worry about what is already dirty?
> 

Ok..

> > The problem in this particular
> > example is that the empty leaf buffer is logged, committed and unpinned
> > (and thus AIL resident). We want to relog the buffer to move it forward
> > in the AIL on the next transaction because we're holding it locked and
> > thus it cannot be written back (and thus could pin the log tail).
> 
> Yup.
> 
> > If we mark the buffer ordered in the subsequent transaction and that
> > transaction commits/checkpoints to the log, don't we push the buffer
> > forward in the AIL to a checkpoint that doesn't have the originally
> > logged data..? IOW, it seems like if this does end up pushing the tail
> > of the log and we crash, we've thrown away checkpointed but not written
> > back metadata and potentially corrupted the fs. Hm?
> 
> Relogging of existing dirty regions is supposed to solve this
> problem. i.e. while the log item is dirty in the AIL, any
> transaction that logs and commits the log item will also log all the
> existing dirty regions on the buffer, hence the next checkpoint will
> contain everything it's supposed to.
> 
> Hence in this case, we don't need to log any new regions of the
> buffer because it already has a record of all the dirty regions on
> it from the prior transaction we committed.  That means we don't
> actually need to mark any new ranges dirty, we just need to mark the
> log item dirty again to trigger relogging of the existing dirty
> ranges on the buffer.
> 

Yep, this is what I was alluding to as an alternative solution in my
last mail. Just a nit: note that we need to mark the log item descriptor
dirty in the transaction (as opposed to the log item, which is already
dirty in this case) so it isn't thrown away at commit time.

> Using XFS_BLI_ORDERED allows us to log the buffer without recording
> a new dirty range on the buffer. IOWs, it retains whatever dirty range
> it already had, and so after joining, marking it ordered and then
> logging the buffer, we have a XFS_BLI_DIRTY | XFS_BLI_ORDERED buffer
> in the transaction.
> 
> The question is this: what happens when a XFS_BLI_ORDERED buffer
> with a pre-existing dirty region is formatted for the CIL? We
> haven't done that before, so I'm betting that we don't relog the
> dirty region like we should be doing....
> 
> ... and we don't relog the existing dirty range because the
> ordered flag takes precedence.
> 

Right.. so it seems that the current implementation for ordered buffers
assumes a buffer is only ever used in one mode or the other.
Additionally, the AIL assumes that any reinserted item has been fully
relogged and so it moves the LSN forward unconditionally. Current
ordered buffer processing violates this constraint for an already logged
buffer.

> Ok, the ordered buffer checks in xfs_buf_item_size() and
> xfs_buf_item_format() need to also check for dirty regions. If dirty
> regions exist, then we treat it like a normal buffer rather than an
> ordered buffer. We can factor the dirty region check out of
> xfs_buf_item_unlock() for this...
> 
> Actually, check the case in xfs_buf_item_size() and remove the
> ordered flag if there are dirty regions. Then xfs_buf_item_format()
> will do the right thing without needing a duplicate check...
> 

I think that would work, assuming we actually check the
xfs_buf_log_format for dirty-ness rather than just the log item. As it
is, note that ordered buffers are still "logged" in the transaction
because otherwise the transaction infrastructure will assume it made no
change to the buf and toss the log item at commit time (we also need to
set up I/O completion on the buf and whatnot).

What concerns me about this approach is that I think we introduce the
possibility for subtle bugs. Existing ordered buffer code does this:

        xfs_trans_ordered_buf(tp, fbuf);
        xfs_trans_log_buf(tp, fbuf, 0,
                          BBTOB(fbuf->b_length) - 1);

... which should continue to work fine. Allowing ordered buffers to
physically log means that something like this:

        xfs_trans_log_buf(tp, fbuf, 0,
                          BBTOB(fbuf->b_length) - 1);
        xfs_trans_ordered_buf(tp, fbuf);

... is now a bug that is only apparent after scrutiny of xfs_trans_*()
and logging internals. Granted, the above already is incorrect, but it
technically still works as expected. I don't see the need to turn that
into a real problem by actually logging the buffer when we might not
expect to.

So while I agree that this could probably be made to work and I think it
is ideal to doing any kind of logged range tracking in the deferred ops
code, it still seems more tricky than it needs to be. To relog a held
buffer in a new transaction, why not just mark the lidp dirty in the new
transaction so it inherits all existing dirty segments? AFAICT, all we
really need to do is:

        tp->t_flags |= XFS_TRANS_DIRTY;
        lidp->lid_flags |= XFS_LID_DIRTY;

... on the new transaction and everything should just work as designed
(for a buffer that has been previously logged, held, rolled and
rejoined).

To elaborate a bit, I think we could refactor xfs_trans_log_buf() into a
new xfs_trans_dirty_buf() helper that covers all of the relevant bits
not related to actually dirtying the bli. xfs_trans_log_buf() would call
xfs_trans_dirty_buf() and thus would not change functionally.
xfs_trans_ordered_buf() could now call xfs_trans_dirty_buf() and thus
the existing ordered buf users would no longer need to log a range of
the buffer (which doesn't make much sense anyways). Finally, the
deferred infrastructure could join/dirty/hold the buffer to the new
transaction after each roll without needing to track and relog specific
regions of the buffer. Thoughts?

Unless I'm missing something as to why this is busted, I'll take a
closer look at the code and float an rfc next week since otherwise it
sounds like this is something we could actually fix up in the ordered
buffer code today.

> Nothing in XFS is ever simple, is it? :P
> 

There used to be a level of satisfaction at feeling I understood some
new corner of XFS. Nowadays I know that just means I'm not yet aware of
whatever dragons remain in that corner (is that paranoia? not if it's
true!). :P

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
