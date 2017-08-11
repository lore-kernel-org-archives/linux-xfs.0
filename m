Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14409 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752968AbdHKO1q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 10:27:46 -0400
Date: Fri, 11 Aug 2017 10:27:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170811142741.GA18609@bfoster.bfoster>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
 <20170810113322.GM21024@dastard>
 <63920C3663124B75BC0983A17533395A@alyakaslap>
 <20170810145248.GE3777@bfoster.bfoster>
 <20170810175548.GX24087@magnolia>
 <20170810183233.GG3777@bfoster.bfoster>
 <20170811022204.GQ21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811022204.GQ21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Fri, Aug 11, 2017 at 12:22:04PM +1000, Dave Chinner wrote:
> On Thu, Aug 10, 2017 at 02:32:33PM -0400, Brian Foster wrote:
> > On Thu, Aug 10, 2017 at 10:55:48AM -0700, Darrick J. Wong wrote:
> > > On Thu, Aug 10, 2017 at 10:52:49AM -0400, Brian Foster wrote:
> > > > On Thu, Aug 10, 2017 at 03:09:09PM +0300, Alex Lyakas wrote:
> > ...
> > > > OTOH, just adding deferred ops buffer relogging might not be too much
> > > > trouble either. ;) Anyways, thoughts?
> > > 
> > > I don't think it'd be difficult to add a _defer_bjoin operation that
> > > maintains a list of buffers that we need to bhold across rolls.
> > > 
> > > I think xfs_buf->b_list is only used for delwri buffers, and a buffer
> > > cannot be part of a transaction /and/ on a delwri list at the same time,
> > > right?  So it shouldn't be hard to whip something up and couple this
> > > patch to that.
> > > 
> > 
> > Hmm.. so if a buffer is modified, logged, committed, put on the AIL and
> > pushed, xfs_buf_item_push() locks it, puts it on the delwri queue and
> > unlocks. At that point, I _think_ it may be possible for another thread
> > to lock the buffer and join it to a new transaction. The delwri submit
> > skips the buffer if it has become pinned or locked since the delwri
> > queue (though I'm wondering if that unlocked pin check is racy against
> > locked buffer modifications. I suppose that would require a full
> > lock->pin->unlock cycle between the pin check and trylock however).
> 
> If it does race, we still catch pinned buffers in xfs_buf_submit() and
> block there on them. SO a race is just sub-optimal behaviour, not a
> bug.
> 

Ah I see, thanks.

> > The question I have for buffer relogging is what's the best way to track
> > the parts of the buffer that need to be relogged after a roll?
> > Copy/translate the dirty (xfs_buf_log_format) segment map(s)?
> 
> Just mark it ordered?
> 
> That way it goes through the transaction commit, pinned and put into
> the CIL and  gets moved forward in the AIL when the log checkpoints.
> We don't need to relog the actual contents in this case, just ensure
> it moves forward in the AIL appropriately while we hold it locked.

Hmm.. is it safe to mark a previously logged and AIL resident buffer
ordered in a subsequent transaction? The problem in this particular
example is that the empty leaf buffer is logged, committed and unpinned
(and thus AIL resident). We want to relog the buffer to move it forward
in the AIL on the next transaction because we're holding it locked and
thus it cannot be written back (and thus could pin the log tail).

If we mark the buffer ordered in the subsequent transaction and that
transaction commits/checkpoints to the log, don't we push the buffer
forward in the AIL to a checkpoint that doesn't have the originally
logged data..? IOW, it seems like if this does end up pushing the tail
of the log and we crash, we've thrown away checkpointed but not written
back metadata and potentially corrupted the fs. Hm?

In reading through some of this code, perhaps it doesn't matter which
part of the buffer we relog. We just need to make sure that the buffer
is marked dirty in the next transaction (i.e., via the log item
descriptor). If the buffer is held across transactions, I think that
means the underlying log item can't go away because the buffer can't be
written back. IIUC, the bli hangs around until writeback completion
precisely to allow this kind of relogging to occur by retaining the
dirty bitmap associated the buffer across potentially separate
transactions. If I'm following all that correctly (?), perhaps a new
xfs_trans_buf_relog() helper that just flags a buffer/transaction dirty
would suffice. Thoughts?

Brian

> The ordered flag is removed at each commit the buffer goes through,
> so as soon as we commit the final transaction it'll go back to
> behaving like a normal buffer...
> 
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
