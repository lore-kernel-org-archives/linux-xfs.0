Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbcI3JOk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 05:14:40 -0400
Date: Fri, 30 Sep 2016 11:14:36 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [RFC] Release buffer locks in case of IO error
Message-ID: <20160930091436.ohsrxhzewcqe6zdq@redhat.com>
References: <1475154199-28880-1-git-send-email-cmaiolino@redhat.com>
 <20160930000147.GH27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930000147.GH27872@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 30, 2016 at 10:01:47AM +1000, Dave Chinner wrote:
> On Thu, Sep 29, 2016 at 03:03:19PM +0200, Carlos Maiolino wrote:
> > I have been working in a bug still regarding xfs fail_at_unmount configuration,
> > where, even though the configuration is enable, an unmount attempt will still
> > hang if the AIL buf items are locked as a result of a previous failed attempt to
> > flush these items.
> > 
> > Currently, if there is a failure while trying to flush inode buffers to disk,
> > these items are kept in AIL with FLUSHING status and with the locks held, making
> > them unable to be retried. Either during unmount, where they will be retried and
> > 'failed', or if using a thin provisioned device, the pool is actually extended, to
> > accomodate these not-yet-flushed items, instead of retrying to flush such items,
> > xfs is unable to retry them, once they are already locked.
> 
> [....]
> 
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 892c2ac..cce0373 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -517,7 +517,26 @@ xfs_inode_item_push(
> >  	 * the AIL.
> >  	 */
> >  	if (!xfs_iflock_nowait(ip)) {
> > -		rval = XFS_ITEM_FLUSHING;
> > +		int error;
> > +		struct xfs_dinode *dip;
> > +
> > +		error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap, &dip,
> > +				       &bp, XBF_TRYLOCK, 0);
> 
> So now, when we have tens of thousands of inodes in flushing state,
> we'll hammer the buffer cache doing lookups to determine the state
> of the buffer. That's a large amount of additional runtime overhead
> that is unnecessary - this is only needed at unmount, according to
> the problem description.
> 
> > +		if (error) {
> > +			rval = XFS_ITEM_FLUSHING;
> > +			goto out_unlock;
> > +		}
> 
> If we are stuck in a shutdown situation, then xfs_imap_to_bp() will
> detect a shutdown and return -EIO here. So this doesn't for an
> unmount with a stuck inode in a shutdown situation.
> 
> > +
> > +		if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> > +			rval = XFS_ITEM_FLUSHING;
> > +			xfs_buf_relse(bp);
> > +			goto out_unlock;
> > +		}
> 
> So if the last write of the buffer was OK, do nothing? How does
> that get the inode unlocked if we've failed to flush at unmount?
> 
> > +
> > +		if (!xfs_buf_delwri_queue(bp, buffer_list))
> > +			rval = XFS_ITEM_FLUSHING;
> > +
> > +		xfs_buf_relse(bp);
> >  		goto out_unlock;
> 
> 
> Ok, I'm pretty sure that this just addresses a symptom of the
> underlying problem, not solve the root cause. e.g. dquot flushing
> has exactly the same problem.
> 
> The underlying problem is that when the buffer was failed, the
> callbacks attached to the buffer were not run. Hence the inodes
> locked and attached to the buffer were not aborted and unlocked
> when the buffer IO was failed. That's the underlying problem that
> needs fixing - this cannot be solved sanely by trying to guess why
> an inode is flush locked when walking the AIL....
> 

Thanks for the comments, I shall work in that direction now

Cheers

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Carlos
