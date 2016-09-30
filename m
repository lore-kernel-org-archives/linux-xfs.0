Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42439 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbcI3VIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 17:08:37 -0400
Date: Fri, 30 Sep 2016 14:08:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/63] xfs: implement deferred bmbt map/unmap operations
Message-ID: <20160930210801.GY14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520489048.29434.18226996933853750466.stgit@birch.djwong.org>
 <20160930073404.GD13587@infradead.org>
 <20160930173800.GN14092@birch.djwong.org>
 <1475267688.23804.125.camel@filmlight.ltd.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475267688.23804.125.camel@filmlight.ltd.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 09:34:48PM +0100, Roger Willcocks wrote:
> On Fri, 2016-09-30 at 10:38 -0700, Darrick J. Wong wrote:
> > On Fri, Sep 30, 2016 at 12:34:04AM -0700, Christoph Hellwig wrote:
> > > > +/* Deferred mapping is only for real extents in the data fork. */
> > > > +static bool
> > > > +xfs_bmap_is_update_needed(
> > > > +	int			whichfork,
> > > > +	struct xfs_bmbt_irec	*bmap)
> > > > +{
> > > > +	ASSERT(whichfork == XFS_DATA_FORK);
> > > > +
> > > > +	return  bmap->br_startblock != HOLESTARTBLOCK &&
> > > > +		bmap->br_startblock != DELAYSTARTBLOCK;
> > > > +}
> > > 
> > > Passing in an argument just to assert on it seems weird.
> > > And except for that a better name might be xfs_bmbt_is_real or similar,
> > > and I bet we'd have other users for it as well.
> > 
> > xfs_bmap_*map_extent are the only callers, and the only whichfork
> > values are XFS_DATA_FORK.  I might as well just tear out all those
> > asserts since they're never going to trigger anyway.
> > 
> 
> Um, isn't that the point of an assertion ?

There's no point in checking whichfork since all callers pass
XFS_DATA_FORK, making the function argument unnecessary.

--D

> 
> --
> Roger
> 
> 
> 
