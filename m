Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from c.mx.filmlight.ltd.uk ([54.76.112.217]:39009 "EHLO
        c.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932133AbcI3Umq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 16:42:46 -0400
Message-ID: <1475267688.23804.125.camel@filmlight.ltd.uk>
Subject: Re: [PATCH 23/63] xfs: implement deferred bmbt map/unmap operations
From: Roger Willcocks <roger@filmlight.ltd.uk>
Date: Fri, 30 Sep 2016 21:34:48 +0100
In-Reply-To: <20160930173800.GN14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
         <147520489048.29434.18226996933853750466.stgit@birch.djwong.org>
         <20160930073404.GD13587@infradead.org>
         <20160930173800.GN14092@birch.djwong.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, 2016-09-30 at 10:38 -0700, Darrick J. Wong wrote:
> On Fri, Sep 30, 2016 at 12:34:04AM -0700, Christoph Hellwig wrote:
> > > +/* Deferred mapping is only for real extents in the data fork. */
> > > +static bool
> > > +xfs_bmap_is_update_needed(
> > > +	int			whichfork,
> > > +	struct xfs_bmbt_irec	*bmap)
> > > +{
> > > +	ASSERT(whichfork == XFS_DATA_FORK);
> > > +
> > > +	return  bmap->br_startblock != HOLESTARTBLOCK &&
> > > +		bmap->br_startblock != DELAYSTARTBLOCK;
> > > +}
> > 
> > Passing in an argument just to assert on it seems weird.
> > And except for that a better name might be xfs_bmbt_is_real or similar,
> > and I bet we'd have other users for it as well.
> 
> xfs_bmap_*map_extent are the only callers, and the only whichfork
> values are XFS_DATA_FORK.  I might as well just tear out all those
> asserts since they're never going to trigger anyway.
> 

Um, isn't that the point of an assertion ?

--
Roger



