Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34322 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754921AbcJRFFx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 01:05:53 -0400
Date: Tue, 18 Oct 2016 07:05:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: don't block the log commit handler for
        discards
Message-ID: <20161018050550.GA2082@lst.de>
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

I've actually tried that, but I never managed to actually hit that
case.  For some reason we mostly hit busy extents, but not those
actually beeing discarded in my tests - I suspect it's just
the better log throughput we get.  But for completeness we should
probably forc it from xfs_extent_busy_update_extent as well.  I'll
see if I can hit it with setups that have slow discard (e.g. old
SATA SSDs without queued trim).

> This creates one long bio chain with all the regions to discard on
> it, and then when all it completes we call xlog_discard_endio() to
> release all the busy extents.
> 
> Why not pull the busy extent from the list and attach it to each
> bio returned and submit them individually and run per-busy extent
> completions? That will substantially reduce the latency of discard
> completions when there are long lists of extents to discard....

I'll look into that.
