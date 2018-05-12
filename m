Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63978 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750793AbeELCAK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 22:00:10 -0400
Date: Sat, 12 May 2018 12:00:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: fix double ijoin in xfs_inactive_symlink_rmt()
Message-ID: <20180512020007.GC23861@dastard>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-6-david@fromorbit.com>
 <20180508141810.GF4764@bfoster.bfoster>
 <20180509002428.GN23861@dastard>
 <20180509101042.GA64624@bfoster.bfoster>
 <20180509150238.GM11261@magnolia>
 <20180511020425.GW10363@dastard>
 <20180511132449.GA104776@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511132449.GA104776@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 09:24:49AM -0400, Brian Foster wrote:
> On Fri, May 11, 2018 at 12:04:25PM +1000, Dave Chinner wrote:
> > On Wed, May 09, 2018 at 08:02:38AM -0700, Darrick J. Wong wrote:
> > > On Wed, May 09, 2018 at 06:10:42AM -0400, Brian Foster wrote:
> > > > On Wed, May 09, 2018 at 10:24:28AM +1000, Dave Chinner wrote:
> > > > > On Tue, May 08, 2018 at 10:18:11AM -0400, Brian Foster wrote:
> > > > > > On Tue, May 08, 2018 at 01:41:58PM +1000, Dave Chinner wrote:
> > > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > > 
> > > > > > > xfs_inactive_symlink_rmt() does something nasty - it joins an inode
> > > > > > > into a transaction it is already joined to. This means the inode can
> > > > > > > have multiple log item descriptors attached to the transaction for
> > > > > > > it. This breaks teh 1:1 mapping that is supposed to exist
> > > > > > > between the log item and log item descriptor.
> > > > > > > 
> > > > > > > This results in the log item being processed twice during
> > > > > > > transaction commit and CIL formatting, and there are lots of other
> > > > > > > potential issues tha arise from double processing of log items in
> > > > > > > the transaction commit state machine.
> > > > > > > 
> > > > > > > In this case, the inode is already held by the rolling transaction
> > > > > > > returned from xfs_defer_finish(), so there's no need to join it
> > > > > > > again.
> > > > > > > 
> > > > > > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > > > > ---
> > > > > > >  fs/xfs/xfs_symlink.c | 9 ++-------
> > > > > > >  1 file changed, 2 insertions(+), 7 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > > > > > > index 5b66ac12913c..27870e5cd259 100644
> > > > > > > --- a/fs/xfs/xfs_symlink.c
> > > > > > > +++ b/fs/xfs/xfs_symlink.c
> > > > > > > @@ -488,16 +488,11 @@ xfs_inactive_symlink_rmt(
> > > > > > >  	error = xfs_defer_finish(&tp, &dfops);
> > > > > > >  	if (error)
> > > > > > >  		goto error_bmap_cancel;
> > > > > > > -	/*
> > > > > > > -	 * The first xact was committed, so add the inode to the new one.
> > > > > > > -	 * Mark it dirty so it will be logged and moved forward in the log as
> > > > > > > -	 * part of every commit.
> > > > > > > -	 */
> > > > > > > -	xfs_trans_ijoin(tp, ip, 0);
> > > > > > > -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > > > > > > +
> > > > > > >  	/*
> > > > > > >  	 * Commit the transaction containing extent freeing and EFDs.
> > > > > > >  	 */
> > > > > > > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > > > > > 
> > > > > > Seems fine.. but do we even need this call? We're about to commit the
> > > > > > transaction and unlock the inode...
> > > > > 
> > > > > Yes, I think we do. We need it to be committed in each of the
> > > > > rolling transactions so that the inode doesn't get written/replayed
> > > > > before any of the other dependent metadata changes in this final
> > > > > transaction.
> > > > > 
> > > > 
> > > > Hmm, I don't follow what that means. IIUC the act of logging it again
> > > > simply moves it forward in the log. That makes sense down in the dfops
> > > > code but seems unecessary here given that we are about to complete the
> > > > chain of transactions.
> > > > 
> > > > xfs_inactive_symlink_rmt() makes changes to the inode, invals/unmaps the
> > > > remote bufs, joins the inode to the dfops and finishes the dfops. We
> > > > return from xfs_defer_finish() having committed the (still locked) inode
> > > > modifications and have a new/rolled transaction that covers the free of
> > > > the associated blocks (EFDs). I could certainly be missing something,
> > > > but from that point what difference does it make whether the final
> > > > transaction relogs the inode before it commits?
> > 
> > It ensures the inode changes are sanely ordered. i.e. we don't
> > write the inode to disk before all the other changes made in the
> > rolling transaction are written to disk. And the same goes for
> > recovery.
> > 
> 
> But what exactly does that accomplish? The inode changes, block unmap
> and and EFIs are all logged in the same transaction. Given the inode
> remains locked, what difference does it make whether it is relogged in
> the transaction that processes the EFIs? IOW, what can go wrong here
> without the additional inode relog?
> 
> Also, what do you mean by "sanely ordered?" AFAICT, there is no such
> writeback ordering guarantee even if the log items are part of the same
> transaction.

The rolling tranactions can be committed can be in different
checkpoints. If the journal is commited after the last roll but
before the final commit, then the inode is unpinned before it is
unlocked, while everything in the current transaction is still
pinned in memory. When the last transaction commits, the inode gets
unlocked and can be written back before the remaining operations in
the rolling transaction are committed to stable storage.

i.e. we end up with an inode on disk with a younger LSN in it than a
bunch of it's dependent changes have. Strictly speaking, that's an
on-disk ordering violation and potentially an on-disk transactional
change atomicity violation. We don't get a violation in memory
because of the inode locking being held across the transaction
commit, but we do get one on disk because the inode is unpinned in
memory before all it's dependent changes are in stable journal
storage....

Hence by logging the inode in the final transaction, we ensure it
stays pinned in memory until the entire transaction is stable in the
journal and we've guaranteed the on disk ordering and atomicity
matches what is provided by the in-memory locking....

> Suppose we return from xfs_inactive_symlink_rmt(),
> everything is committed/unlocked and an AIL push occurs.

All the objects are still pinned in memory, so they can't be written
back by the AIL until the journal commits. :P

> Nothing
> prevents a completely unrelated transaction from locking those same
> allocation btree buffers that were in the same (rolled) transaction as
> the EFD (plus relogged inode) before xfsaild gets to them, which means
> the associated items could be written back in arbitrary order anyways.

Sure, but the combination of locking and journal ordering via
relogging in the CIL handles reuse via independent atomic
transaction cases just fine. That's different to ordering within a
a single atomic transaction chain....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
