Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbeAZStO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 13:49:14 -0500
Date: Fri, 26 Jan 2018 10:48:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/11] xfs: only grab shared inode locks for source file
 during reflink
Message-ID: <20180126184845.GY9068@magnolia>
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
Cc: linux-xfs@vger.kernel.org

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

Agree with the yuckiness; how often do we encounter that situation?

> I think we need to move to the VFS locking conventions, that is
> based on ancestors for directories (see lock_rename) and otherwise
> based on the struct inode address as in lock_two_nondirectories.

I'd been wondering if the difference in locking conventions would ever
come to bite us...

> >       if (src_last)
> > -             inode_lock_nested(src, I_MUTEX_NONDIR2);
> > +             down_read_nested(&src->i_rwsem, I_MUTEX_NONDIR2);
> 
> Why is this not using inode_lock_nested any more?

Because inode_lock_nested calls down_write_nested, but I suppose I could
have simply added an inode_lock_shared_nested helper to make it more
consistent.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
