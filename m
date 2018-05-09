Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:35673 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932475AbeEIAYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 20:24:31 -0400
Date: Wed, 9 May 2018 10:24:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: fix double ijoin in xfs_inactive_symlink_rmt()
Message-ID: <20180509002428.GN23861@dastard>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-6-david@fromorbit.com>
 <20180508141810.GF4764@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508141810.GF4764@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 10:18:11AM -0400, Brian Foster wrote:
> On Tue, May 08, 2018 at 01:41:58PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_inactive_symlink_rmt() does something nasty - it joins an inode
> > into a transaction it is already joined to. This means the inode can
> > have multiple log item descriptors attached to the transaction for
> > it. This breaks teh 1:1 mapping that is supposed to exist
> > between the log item and log item descriptor.
> > 
> > This results in the log item being processed twice during
> > transaction commit and CIL formatting, and there are lots of other
> > potential issues tha arise from double processing of log items in
> > the transaction commit state machine.
> > 
> > In this case, the inode is already held by the rolling transaction
> > returned from xfs_defer_finish(), so there's no need to join it
> > again.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_symlink.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > index 5b66ac12913c..27870e5cd259 100644
> > --- a/fs/xfs/xfs_symlink.c
> > +++ b/fs/xfs/xfs_symlink.c
> > @@ -488,16 +488,11 @@ xfs_inactive_symlink_rmt(
> >  	error = xfs_defer_finish(&tp, &dfops);
> >  	if (error)
> >  		goto error_bmap_cancel;
> > -	/*
> > -	 * The first xact was committed, so add the inode to the new one.
> > -	 * Mark it dirty so it will be logged and moved forward in the log as
> > -	 * part of every commit.
> > -	 */
> > -	xfs_trans_ijoin(tp, ip, 0);
> > -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +
> >  	/*
> >  	 * Commit the transaction containing extent freeing and EFDs.
> >  	 */
> > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
> Seems fine.. but do we even need this call? We're about to commit the
> transaction and unlock the inode...

Yes, I think we do. We need it to be committed in each of the
rolling transactions so that the inode doesn't get written/replayed
before any of the other dependent metadata changes in this final
transaction.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
