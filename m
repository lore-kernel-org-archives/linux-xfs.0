Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41903 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942645AbcJSOge (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:36:34 -0400
Date: Wed, 19 Oct 2016 12:58:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: don't block the log commit handler for
        discards
Message-ID: <20161019105825.GA2279@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de> <1476735753-5861-3-git-send-email-hch@lst.de> <20161017232908.GY23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017232908.GY23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Tue, Oct 18, 2016 at 10:29:08AM +1100, Dave Chinner wrote:
> > +	if (args.fsbno == NULLFSBLOCK && trydiscard) {
> > +		trydiscard = false;
> > +		flush_workqueue(xfs_discard_wq);
> > +		goto retry;
> > +	}
> 
> So this is the new behaviour that triggers flushing of the discard
> list rather than having it occur from a log force inside
> xfs_extent_busy_update_extent().
> 
> However, xfs_extent_busy_update_extent() also has backoff when it
> finds an extent on the busy list being discarded, which means it
> could spin waiting for the discard work to complete.
> 
> Wouldn't it be better to trigger this workqueue flush in
> xfs_extent_busy_update_extent() in both these cases so that the
> behaviour remains the same for userdata allocations hitting
> uncommitted busy extents, but also allow us to remove the spinning
> for allocations where the busy extent is currently being discarded?

So the current xfs_extent_busy_update_extent busy wait is something we
actually never hit at all - it's only hit when an extent under discard
is reused by an AGFL allocation, which basically does not happen.

I'm not feeling very eager to touch that corner case code, and would
rather leave it as-is.

The new flush deals with the case where we weren't able to find any space
due to the discard list.  To honest I almost don't manage to trigger it
anymore once I found the issue fixed in patch 1.  It might be possible
to even drop this retry entirely now.

> This creates one long bio chain with all the regions to discard on
> it, and then when all it completes we call xlog_discard_endio() to
> release all the busy extents.
> 
> Why not pull the busy extent from the list and attach it to each
> bio returned and submit them individually and run per-busy extent
> completions? That will substantially reduce the latency of discard
> completions when there are long lists of extents to discard....

Because that would defeat the merging I currently do, which is
very effectice.  It would also increase the size of the busy extent
structure as it would grow a work_struct, and increase lock contention
in the completion handler.  All in all not that pretty, especially
as the most common number of discards are one digit or small two
digit.  And this is just going to further decrease once I finish
up my block layer patches to allow multi-range discards by merging
multiple discard bios into a single request.  With that even double
digit numbers of discards are fairly rare.

Now if we eventually want to split the completions I think we'll
need to start merging the extent_busy structures once they are added
to the CIL.  That's quite a bit of effort and I'd like to avoid it
for now.
