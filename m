Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48152 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbeKUHcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 02:32:22 -0500
Date: Wed, 21 Nov 2018 08:00:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: don't ENOSPC on writeback when punching holes
Message-ID: <20181120210054.GP19305@dastard>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-7-david@fromorbit.com>
 <20181120082040.GF30481@infradead.org>
 <20181120095042.GO19305@dastard>
 <20181120162833.GA2470@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120162833.GA2470@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 08:28:33AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 20, 2018 at 08:50:42PM +1100, Dave Chinner wrote:
> > > > because the writeback error of ENOSPC was being reported. We're
> > > > going to free that space, so we don't care if there was a ENOSPC
> > > > writeback error. So ignore ENOSPC errors and punch anyway.
> > > 
> > > How do even get -ENOSPC back from writeback?  It seems like we have
> > > a much worse root cause lingering here.
> > 
> > It hammered ENOSPC pretty hard - I think it had consumed the entire
> > reserve pool and that can causes allocation transaction reservations
> > in xfs_iomap_write_allocate() to return ENOSPC even if we've got a
> > reservation for the data extents being allocated.
> 
> Well, that means we do have a problem somewhere in our accounting,
> as writeback should not run into ENOSPC.

Unwritten extent conversion consumes unreserved space when it splits
the BMBT and does all the other btree updates. If we do enough of
them at ENOSPC, we can consume the entire reservation pool.

In this case, I was creating a 25 million extent file using extent
size hints to try to get the number of extents down. It actually
resulted in the number of extents going up, because most of the
extents weren't fully written. IOWs, there was a /lot/ of partial
unwritten extent conversion going on in a very big extent tree.

> > This doesn't happen very often in the real world, but if it does we
> > need operations like punch to work to be able to free space and
> > get us out of that hole...
> 
> I'm ok(-ish) with the patch, but I wish we could also sort out the
> root cause..

Yeah, it's not great, but it did mean I didn't have to mkfs the
filesystem to get out of trouble. mount/unmount doesn't fix a
depleted reserve pool, only freeing space will do that, and we
should be able to punch space out of a file when at ENOSPC...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
