Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43854 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388491AbeGXXoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 19:44:03 -0400
Date: Tue, 24 Jul 2018 15:35:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
 the fork didn't change
Message-ID: <20180724223523.GO4813@magnolia>
References: <20180717232405.18511-1-hch@lst.de>
 <20180717232405.18511-7-hch@lst.de>
 <20180721232311.GA1691@dastard>
 <20180723074940.GA18816@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723074940.GA18816@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:49:41AM +0200, Christoph Hellwig wrote:
> On Sun, Jul 22, 2018 at 09:23:11AM +1000, Dave Chinner wrote:
> > On Tue, Jul 17, 2018 at 04:24:05PM -0700, Christoph Hellwig wrote:
> > > @@ -333,12 +335,15 @@ xfs_map_blocks(
> > >  	 * COW fork blocks can overlap data fork blocks even if the blocks
> > >  	 * aren't shared.  COW I/O always takes precedent, so we must always
> > >  	 * check for overlap on reflink inodes unless the mapping is already a
> > > -	 * COW one.
> > > +	 * COW one, or the COW fork hasn't changed from the last time we looked
> > > +	 * at it.
> > >  	 */
> > >  	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
> > >  		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
> > >  	if (imap_valid &&
> > > -	    (!xfs_inode_has_cow_data(ip) || wpc->io_type == XFS_IO_COW))
> > > +	    (!xfs_inode_has_cow_data(ip) ||
> > > +	     wpc->io_type == XFS_IO_COW ||
> > > +	     wpc->cow_seq == ip->i_cowfp->if_seq))
> > >  		return 0;
> > 
> > This seqno check is still racy against concurrent extent tree
> > modification. We aren't holding the ILOCK here at all, the sequence
> > numbers aren't atomic and there are no memory barriers to serialise
> > cross-cpu load/store operations...
> 
> mutex_unlock contains a barrier, and the sequence is a single register
> read.  There is nothing holding a lock here would help us with.

Which mutex_unlock is that?  I took a second look at the i_cowfp access
and realized that we don't take ILOCK_SHARED until after the comparison.
Writeback doesn't take any of the other inode locks AFAIK... so either
there's some locking subtlety here that ought to be explained in a
comment, or is this a bug waiting to happen?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
