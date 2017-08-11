Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752723AbdHKOam (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 10:30:42 -0400
Date: Fri, 11 Aug 2017 10:30:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170811143039.GB18609@bfoster.bfoster>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
 <20170810113322.GM21024@dastard>
 <63920C3663124B75BC0983A17533395A@alyakaslap>
 <20170810145248.GE3777@bfoster.bfoster>
 <20170810175548.GX24087@magnolia>
 <20170811020956.GP21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811020956.GP21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Fri, Aug 11, 2017 at 12:09:56PM +1000, Dave Chinner wrote:
> On Thu, Aug 10, 2017 at 10:55:48AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 10, 2017 at 10:52:49AM -0400, Brian Foster wrote:
> > > On Thu, Aug 10, 2017 at 03:09:09PM +0300, Alex Lyakas wrote:
> > > > Hi Dave,
> > > > 
> > > > Thanks for the explanation. So it seems we cannot move forward with this
> > > > fix.
> > > > 
> > > 
> > > I don't think this completely invalidates the fix.. Dave is pointing out
> > > a flaw that the deferred ops infrastructure doesn't properly handle the
> > > technique we want to use here. IOW, it means there's a dependency that
> > > needs to be implemented first.
> > > 
> > > FWIW, I also think this means that your approach on the older kernel to
> > > join/hold the buffer to the finished transaction may be the right
> > > approach (depending on whether I follow the perm transaction code
> > > correctly or not, see below), but I think you'd need to relog the buffer
> > > as well.
> 
> Yes, the problem exists in 3.18 via the roll in xfs_bmap_finish()
> so it would also need to be done there, too.
> 

The argument to fix the deferred ops problem in the current code first
because its fairly straightforward makes sense to me.

That said, what I wrote below in 1. suggests that this is not a problem
in the v3.18 xfs_attr_set() code. The argument is basically that the old
xfs_bmap_finish() only committed the transaction once at most and so
this codepath never waits on log reservation after the initial
xfs_trans_reserve(). IOW, the problem in this case (in principle) is
that the xfs_defer_finish() can roll the transaction an arbitrary number
of times. Am I missing something?

Brian

> > > 
> > > > Will somebody else in XFS community be working on fixing this issue? As you
> > > > pointed out, it exists for over two decades. Our production systems hit this
> > > > every couple of days, and shutting down the filesystem causes outage.
> > > > 
> > > 
> > > I'm guessing the defer infrastructure needs to handle relogging a buffer
> > > similar to how it currently handles joining/relogging inodes..?
> 
> Yup, pretty much identical, and only a 10-20 lines of new code, I
> think.
> 
> > > > The problem is that the locked buffer is not joined and logged in
> > > > the rolling transactions run in xfs_defer_ops. Hence it can pin the
> > > > tail of the AIL, and this can prevent the transaction roll from
> > > > regranting the log space necessary to continue rolling the
> > > > transaction for the required number of transactions to complete the
> > > > deferred ops. If this happens, we end up with a log space deadlock.
> > > > 
> > > > Hence if we are holding an item that we logged in a transaction
> > > > locked and we roll the transaction, we have to join, hold and log it
> > > > in each subsequent transaction until we have finished with the item
> > > > and can unlock and release it.
> > > > 
> > > > This is documented in xfs_trans_roll():
> > > > 
> > > >        /*
> > > >         * Reserve space in the log for th next transaction.
> > > >         * This also pushes items in the "AIL", the list of logged items,
> > > >         * out to disk if they are taking up space at the tail of the log
> > > >         * that we want to use.  This requires that either nothing be locked
> > > >         * across this call, or that anything that is locked be logged in
> > > >         * the prior and the next transactions.
> > > >         */
> > > > 
> > > 
> > > Good catch, though I'm wondering whether it's a real enough problem atm
> > > to block this fix. A few thoughts/questions:
> > > 
> > > 1.) The transaction in this case has a t_log_count of 3, presumably to
> > > cover the commits by the historical bmap_finish, the trans roll and the
> > > final commit. If I'm following the permanent transaction code correctly,
> > > doesn't that mean that we have room for at least 2 rolls (and 3 commits)
> > > before this task would actually block on log reservation? AFAICT it
> > > looks like the commit would dec ticket->t_cnt and replenish the current
> > > log reservation. The subsequent xfs_trans_reserve() would just return if
> > > t_cnt > 0.
> > > 
> > > This of course doesn't accommodate the fact the xfs_defer_finish() can
> > > now roll a transaction an indeterminate number of times, which probably
> > > needs to be handled in general, but...
> > 
> > I'd been wondering if tr_logcount needed upward adjusting, but so far
> > haven't observed any problems.
> 
> That won't avoid the general problem, though, just increase log
> reservation pressure from active transactions.
> 
> > > 2.) It doesn't look like we actually defer any ops in this situation
> > > unless rmapbt is enabled, assuming that we limit holding the buffer to
> > > the empty leaf case, at least (see my comment on the previous version).
> > > I also don't see where a deferred rmapbt update would itself ever roll
> > > the transaction.
> > 
> > rmapbt split causes the agfl to hit the low water mark and refresh,
> > requiring an allocation ... but I think that's all stuffed in the same
> > transaction.  (So yeah I think I agree with you)
> 
> I haven't looked that far, but I'd prefer we fix the problem now
> while we are looking at it because it doesn't seem that hard to
> fix...
> 
> > > 3.) The buffer in this case is a new allocation, which I think means the
> > > risk of it pinning the tail and causing a log deadlock here means that
> > > on top of somehow depleting the initial permanent reservation, we'd have
> > > to exhaust the log in the time between the first commit and the last
> > > reservation.
> > > 
> > > Given the above, it seems reasonably safe enough to me to merge this
> > > change as is and fix up the deferred ops stuff after the fact
> > > (considering we know we need to rework the xattr stuff as such anyways).
> > > This is still a landmine that should be fixed up, but I wouldn't be
> > > against an ASSERT() or something for the time being if we could somehow
> > > verify that the transaction ticket didn't require any extra reservation.
> > > 
> > > OTOH, just adding deferred ops buffer relogging might not be too much
> > > trouble either. ;) Anyways, thoughts?
> > 
> > I don't think it'd be difficult to add a _defer_bjoin operation that
> > maintains a list of buffers that we need to bhold across rolls.
> 
> Just a small array like inodes currently use would be sufficient.
> We only need to hold one buffer right now....
> 
> > I think xfs_buf->b_list is only used for delwri buffers, and a buffer
> > cannot be part of a transaction /and/ on a delwri list at the same time,
> > right?  So it shouldn't be hard to whip something up and couple this
> > patch to that.
> 
> Reading xfs_buf_item_push() answers that question:
> 
>         if (!xfs_buf_delwri_queue(bp, buffer_list))
>                 rval = XFS_ITEM_FLUSHING;
>         xfs_buf_unlock(bp);
>         return rval;
> 
> So, yes, a buffer can be on the delwri queue and be part of a
> transaction at the same time because the buffers on the delwri queue
> get unlocked once they are queued. If a transaction locks and joins
> the buffer while it is on the delwri queue, the commit will pin the
> buffer in memory before unlocking it and
> xfs_buf_delwri_submit_nowait() will see it pinned and skip over it.
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
