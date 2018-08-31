Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47936 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbeHaI3d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 04:29:33 -0400
Date: Thu, 30 Aug 2018 21:23:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/18] xfs: support storing records in the inode core root
Message-ID: <20180831042355.GB4359@magnolia>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
 <153565390854.32612.15669075123760228429.stgit@magnolia>
 <20180831022812.GJ5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831022812.GJ5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 31, 2018 at 12:28:13PM +1000, Dave Chinner wrote:
> On Thu, Aug 30, 2018 at 11:31:48AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make it so that we can actually store btree records in the inode
> > core (i.e. enable bb_level == 0) so that the rtrmapbt can do this.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> So this is so you don't need XFS_DINODE_FMT_RMAP_EXTENTS/BTREE 
> inode fork types, right? i.e. there just XFS_DINODE_FMT_RMAP to
> indicate it's an rmap tree in the fork?

Yep.

> Could this code be used by the data fork, too? Sure, we need to
> keep the on-disk fork format info the same, but we could use this to
> kill the special BMDR formatting code it currently uses, right?

Hmm.  FMT_EXTENTS uses di_nextents to count the number of records in the
data fork area, whereas FMT_BTREE stores the number of records in the
bmbt root in the data fork area, followed by bmbt keys/ptrs.  I imagine
you could make the formats share code, but you'd have to special case
how much btree header gets written into the data fork area.

The maximum number of bmbt records that can fit in the data fork area
(factoring in alignment requirements) actually does depend on whether or
not we have to allocate space for the root block record count.

Might be worth deeper investigation...

(FWIW, FMT_RMAP always stores the number of root block records in the
data fork area, since it doesn't affect the max record count.)

--D

> (just trying to get an idea of whether we'll have to maintain two
> bits of code that do essentially the same thing forever)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
