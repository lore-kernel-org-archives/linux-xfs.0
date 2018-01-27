Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5695 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751638AbeA0Dwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 22:52:47 -0500
Date: Sat, 27 Jan 2018 14:32:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfs: only grab shared inode locks for source file
 during reflink
Message-ID: <20180127033249.ej3uwvtcoksug3l5@destitution>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676028976.12349.5695190502888561177.stgit@magnolia>
 <20180126120741.GA30851@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126120741.GA30851@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Jan 26, 2018 at 04:07:41AM -0800, Christoph Hellwig wrote:
> > +xfs_lock_two_inodes_separately(
> > +	struct xfs_inode	*ip0,
> > +	uint			ip0_mode,
> > +	struct xfs_inode	*ip1,
> > +	uint			ip1_mode)
> 
> We only have 6 calls to xfs_lock_two_inodes in total, so just update
> the signature to take two modes and be done with it.
> 
> Also how about mode1 and mode2 for the argument names?
> 
> >  	lp = (xfs_log_item_t *)ip0->i_itemp;
> >  	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
> > -		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
> > -			xfs_iunlock(ip0, lock_mode);
> > +		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
> > +			xfs_iunlock(ip0, ip0_mode);
> >  			if ((++attempts % 5) == 0)
> >  				delay(1); /* Don't just spin the CPU */
> >  			goto again;
> >  		}
> >  	} else {
> > -		xfs_ilock(ip1, xfs_lock_inumorder(lock_mode, 1));
> > +		xfs_ilock(ip1, xfs_lock_inumorder(ip1_mode, 1));
> >  	}
> >  }
> 
> Not directly related to your patch, but the the nowait + retry
> mess must go away.
> 
> I think we need to move to the VFS locking conventions, that is
> based on ancestors for directories (see lock_rename) and otherwise
> based on the struct inode address as in lock_two_nondirectories.

I'm pretty sure this has nothing to do with directory lock order.
It's preventing deadlocks with xfs_iflush_cluster() where we lock
other inodes in the cluster and flush them to the backing buffer
while we still hold the ILOCK for the original inode we are pushing.

That's why this is all conditional on the XFS_LI_IN_AIL flag - the
inode writeback code won't be holding or attmpeting to lock the
inode if it is not in the AIL (i.e. it is clean).

Hence I don't think this trylock+backoff can ever go away here,
because there's no guaranteed lock ordering relationship between
directory structure and location in the inode cluster....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
