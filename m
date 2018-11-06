Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45596 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388314AbeKGGpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 01:45:15 -0500
Date: Wed, 7 Nov 2018 08:18:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181106211802.GN19305@dastard>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
 <20181106142310.GA2773@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106142310.GA2773@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Nov 06, 2018 at 09:23:11AM -0500, Brian Foster wrote:
> On Mon, Nov 05, 2018 at 01:51:39PM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 05, 2018 at 01:10:21PM -0500, Brian Foster wrote:
> > > When online discard is enabled, discards of busy extents are
> > > submitted asynchronously as a bio chain. bio completion and
> > > resulting busy extent cleanup is deferred to a workqueue. Async
> > > discard submission is intended to avoid blocking log forces on a
> > > full discard sequence which can take a noticeable amount of time in
> > > some cases.
> > > 
> > > We've had reports of this still producing log force stalls with XFS
> > > on VDO,
> > 
> > Please fix this in VDO instead.  We should not work around out of
> > tree code making stupid decisions.
> 
> I assume the "stupid decision" refers to sync discard execution. I'm not
> familiar with the internals of VDO, this is just what I was told.

IMO, what VDO does is irrelevant - any call to submit_bio() can
block if the request queue is full. Hence if we've drowned the queue
in discards and the device is slow at discards, then we are going to
block submitting discards.

> My
> understanding is that these discards can stack up and take enough time
> that a limit on outstanding discards is required, which now that I think
> of it makes me somewhat skeptical of the whole serial execution thing.
> Hitting that outstanding discard request limit is what bubbles up the
> stack and affects XFS by holding up log forces, since new discard
> submissions are presumably blocked on completion of the oldest
> outstanding request.

Exactly.

> I'm not quite sure what happens in the block layer if that limit were
> lifted. Perhaps it assumes throttling responsibility directly via
> queues/plugs? I'd guess that at minimum we'd end up blocking indirectly
> somewhere (via memory allocation pressure?) anyways, so ISTM that some
> kind of throttling is inevitable in this situation. What am I missing?

We still need to throttle discards - they have to play nice with all
the other IO we need to dispatch concurrently.

I have two issues with the proposed patch:

1. it puts both discard dispatch and completion processing on the
one work qeueue, so if the queue is filled with dispatch requests,
IO completion queuing gets blocked. That's not the best thing to be
doing.

2. log forces no longer wait for discards to be dispatched - they
just queue them. This means the mechanism xfs_extent_busy_flush()
uses to dispatch pending discards (synchrnous log force) can return
before discards have even been dispatched to disk. Hence we can
expect to see longer wait and tail latencies when busy extents are
encountered by the allocator. Whether this is a problem or not needs
further investigation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
