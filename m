Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32208 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755499AbcI2UYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 16:24:18 -0400
Date: Thu, 29 Sep 2016 13:23:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 37/63] xfs: cancel CoW reservations and clear inode
 reflink flag when freeing blocks
Message-ID: <20160929202349.GD14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503145516.30303.8096168526472457811.stgit@birch.djwong.org>
 <20160929170109.GF4546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929170109.GF4546@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 10:01:09AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 07:57:35PM -0700, Darrick J. Wong wrote:
> > +	/* Remove all pending CoW reservations. */
> > +	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
> > +			last_block);
> > +	if (error)
> > +		goto out;
> > +
> > +	/*
> > +	 * Clear the reflink flag if we truncated everything.
> > +	 */
> > +	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
> > +		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> 
> Shouldn't this (and the later added clearing of the cowblocks tag)
> be moved into xfs_reflink_cancel_cow_blocks?

Truncate is the only caller of _reflink_cancel_cow_blocks where we
actually free blocks from the data fork.  The other callers (IO error,
CoW fork GC, inode reclaim) don't remove extents from the data fork. 
Therefore, I think it's fine to leave this where it is.

(I guess we could move it there on the off chance we do somehow end
up with zero blocks, but this seems unlikely.)

--D
