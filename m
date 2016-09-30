Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932088AbcI3Jhw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 05:37:52 -0400
Date: Fri, 30 Sep 2016 11:37:47 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [RFC] Release buffer locks in case of IO error
Message-ID: <20160930093747.nvflglv6d4ajaz6i@redhat.com>
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

Ah, btw, this is not only needed at unmount time, if we have such buffer IO
failures, and the sysadmin extends the underlying thin pool, the buffers will
still be hanging around without progress, never being retried.

But anyway, I'll work in the directions you pointed.

cheers

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

-- 
Carlos
