Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752578AbeEKNYv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 09:24:51 -0400
Date: Fri, 11 May 2018 09:24:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: fix double ijoin in xfs_inactive_symlink_rmt()
Message-ID: <20180511132449.GA104776@bfoster.bfoster>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-6-david@fromorbit.com>
 <20180508141810.GF4764@bfoster.bfoster>
 <20180509002428.GN23861@dastard>
 <20180509101042.GA64624@bfoster.bfoster>
 <20180509150238.GM11261@magnolia>
 <20180511020425.GW10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511020425.GW10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 12:04:25PM +1000, Dave Chinner wrote:
> On Wed, May 09, 2018 at 08:02:38AM -0700, Darrick J. Wong wrote:
> > On Wed, May 09, 2018 at 06:10:42AM -0400, Brian Foster wrote:
> > > On Wed, May 09, 2018 at 10:24:28AM +1000, Dave Chinner wrote:
> > > > On Tue, May 08, 2018 at 10:18:11AM -0400, Brian Foster wrote:
> > > > > On Tue, May 08, 2018 at 01:41:58PM +1000, Dave Chinner wrote:
> > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > 
> > > > > > xfs_inactive_symlink_rmt() does something nasty - it joins an inode
> > > > > > into a transaction it is already joined to. This means the inode can
> > > > > > have multiple log item descriptors attached to the transaction for
> > > > > > it. This breaks teh 1:1 mapping that is supposed to exist
> > > > > > between the log item and log item descriptor.
> > > > > > 
> > > > > > This results in the log item being processed twice during
> > > > > > transaction commit and CIL formatting, and there are lots of other
> > > > > > potential issues tha arise from double processing of log items in
> > > > > > the transaction commit state machine.
> > > > > > 
> > > > > > In this case, the inode is already held by the rolling transaction
> > > > > > returned from xfs_defer_finish(), so there's no need to join it
> > > > > > again.
> > > > > > 
> > > > > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > > > ---
> > > > > >  fs/xfs/xfs_symlink.c | 9 ++-------
> > > > > >  1 file changed, 2 insertions(+), 7 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > > > > > index 5b66ac12913c..27870e5cd259 100644
> > > > > > --- a/fs/xfs/xfs_symlink.c
> > > > > > +++ b/fs/xfs/xfs_symlink.c
> > > > > > @@ -488,16 +488,11 @@ xfs_inactive_symlink_rmt(
> > > > > >  	error = xfs_defer_finish(&tp, &dfops);
> > > > > >  	if (error)
> > > > > >  		goto error_bmap_cancel;
> > > > > > -	/*
> > > > > > -	 * The first xact was committed, so add the inode to the new one.
> > > > > > -	 * Mark it dirty so it will be logged and moved forward in the log as
> > > > > > -	 * part of every commit.
> > > > > > -	 */
> > > > > > -	xfs_trans_ijoin(tp, ip, 0);
> > > > > > -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > > > > > +
> > > > > >  	/*
> > > > > >  	 * Commit the transaction containing extent freeing and EFDs.
> > > > > >  	 */
> > > > > > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > > > > 
> > > > > Seems fine.. but do we even need this call? We're about to commit the
> > > > > transaction and unlock the inode...
> > > > 
> > > > Yes, I think we do. We need it to be committed in each of the
> > > > rolling transactions so that the inode doesn't get written/replayed
> > > > before any of the other dependent metadata changes in this final
> > > > transaction.
> > > > 
> > > 
> > > Hmm, I don't follow what that means. IIUC the act of logging it again
> > > simply moves it forward in the log. That makes sense down in the dfops
> > > code but seems unecessary here given that we are about to complete the
> > > chain of transactions.
> > > 
> > > xfs_inactive_symlink_rmt() makes changes to the inode, invals/unmaps the
> > > remote bufs, joins the inode to the dfops and finishes the dfops. We
> > > return from xfs_defer_finish() having committed the (still locked) inode
> > > modifications and have a new/rolled transaction that covers the free of
> > > the associated blocks (EFDs). I could certainly be missing something,
> > > but from that point what difference does it make whether the final
> > > transaction relogs the inode before it commits?
> 
> It ensures the inode changes are sanely ordered. i.e. we don't
> write the inode to disk before all the other changes made in the
> rolling transaction are written to disk. And the same goes for
> recovery.
> 

But what exactly does that accomplish? The inode changes, block unmap
and and EFIs are all logged in the same transaction. Given the inode
remains locked, what difference does it make whether it is relogged in
the transaction that processes the EFIs? IOW, what can go wrong here
without the additional inode relog?

Also, what do you mean by "sanely ordered?" AFAICT, there is no such
writeback ordering guarantee even if the log items are part of the same
transaction. Suppose we return from xfs_inactive_symlink_rmt(),
everything is committed/unlocked and an AIL push occurs. Nothing
prevents a completely unrelated transaction from locking those same
allocation btree buffers that were in the same (rolled) transaction as
the EFD (plus relogged inode) before xfsaild gets to them, which means
the associated items could be written back in arbitrary order anyways.

I think that unrelated transaction could even relog those allocbt
buffers, which means technically the inode and final written back buffer
ended up in different checkpoints (or the inode was written back and
only the buffer changes are in the log after a crash, etc.). But that's
probably getting too far into the weeds..

> > > The in-core inode is
> > > still locked and the previous inode modifications may very well already
> > > be in the on-disk log.
> > > 
> > > That said, it seems harmless despite not understanding what it's for. So
> > > with or without the xfs_trans_log_inode() call:
> > 
> > <shrug> I interpreted this as Dave being fastidious about relogging
> > inodes after every transaction roll even if it's not strictly necessary
> > (but not otherwise harmful)
> 
> That's wrong. It is a requirement of rolling transactions that we
> log every object that is held locked across xfs_trans_commit()
> regardless of whether it was dirtied in that specific transaction or
> not.
> 
> That's because we call xfs_trans_reserve() when rolling the
> transaction, and that means the locked objects cannot be written to
> disk during that rolling transaction sequence.  That means we can
> deadlock if the object we hold locked pins the tail of the log and
> there isn't space for the re-reservation of log space for the next
> transaction in the sequence.
> 

Right.. this is my understanding for why we relog items in rolling
transactions. I think that in this case the log is pinned regardless of
the inode because the first transaction commits an EFI.

(Which has me wondering a bit over whether we even need to join the
inode to the dfops as opposed to transfer the ilock to the transaction,
but that's another train of thought..).

> IOWs, the simple rule of thumb is that objects held locked across
> xfs_trans_commit() should be logged in that transaction. Follow that
> simple rule everywhere, and we don't leave nasty landmines around
> to step on when we change code around....
> 

I'm all for following simple guidelines as such to reduce the likelihood
or impact of landmines. That's a different argument from the above
though. I'd at least like to clear up whether I'm missing some reason
for the extra relog being required or if we're just trying to keep
things simple/safe. Hm?

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
