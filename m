Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:53626 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756858AbcJXLrT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Oct 2016 07:47:19 -0400
Message-ID: <1477309633.25282.5.camel@lynxeye.de>
Subject: Re: [PATCH 1/2] xfs: use rhashtable to track buffer cache
From: Lucas Stach <dev@lynxeye.de>
Date: Mon, 24 Oct 2016 13:47:13 +0200
In-Reply-To: <20161024021515.GV14023@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
         <1476821653-2595-2-git-send-email-dev@lynxeye.de>
         <20161018221849.GD23194@dastard> <1477159309.2070.14.camel@lynxeye.de>
         <20161024021515.GV14023@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Am Montag, den 24.10.2016, 13:15 +1100 schrieb Dave Chinner:
> On Sat, Oct 22, 2016 at 08:01:49PM +0200, Lucas Stach wrote:
> > 
> > Am Mittwoch, den 19.10.2016, 09:18 +1100 schrieb Dave Chinner:
> > > 
> > > On Tue, Oct 18, 2016 at 10:14:12PM +0200, Lucas Stach wrote:
> > > > 
> > > > +	.key_len = sizeof(xfs_daddr_t),
> > > > +	.key_offset = offsetof(struct xfs_buf, b_bn),
> > > > +	.head_offset = offsetof(struct xfs_buf, b_rhash_head),
> > > > +	.automatic_shrinking = true,
> > > 
> > > Hmmm - so memory pressure is going to cause this hash to be
> > > resized
> > > as the shrinker frees buffers. That, in turn, will cause the
> > > rhashtable code to run GFP_KERNEL allocations, which could result
> > > in
> > > it re-entering the shrinker and trying to free buffers which will
> > > modify the hash table.
> > > 
> > > That doesn't seem like a smart thing to do to me - it seems to me
> > > like it introduces a whole new avenue for memory reclaim
> > > deadlocks
> > > (or, at minimum, lockdep false positives) to occur....
> > > 
> > Shrinking of the hash table is done in a worker, so I don't see the
> > direct chain you are describing above.
> 
> We've had deadlocks where workqueue work has been stalled on memory
> allocation trying to allocation a new worker thread to run the work.
> The rhashtable code appears to use unbound system work queues which
> means there are no rescuer threads, and they are being called to do
> work in memory reclaim context. Rescuer threads come along with the
> WQ_MEM_RECLAIM initialisation flag for workqueues, but the
> rhashtable code is most definitely not doing that...
> 
> i.e. if memory reclaim requires that workqueue to make progress to
> continue freeing memory or resolve a blocking situation in the
> shrinker (e.g. waiting for IO completion) then a) it needs to have a
> rescuer thread, and b) it must avoid re-entering the shrinker that
> is already blocking waiting for the work to be run. i.e. it can't
> do GFP_KERNEL allocations because that will result in re-entering
> the blocked shrinker...
> 
> Now, this /might/ be ok for the rhashtable code as it may not block
> future operations if a grow/shrink gets held up on memory
> allocation, but I'm not intimately familiar with that code. It is,
> however, a red flag that needs to be checked out and verified.

Right, this is exactly what I meant. Insertion/deletion of entries in
rhashtables will not be held up by the grow/shrink worker. The bucket
locks will only be taken once the worker succeeded in allocating the
required memory.

If the shrink worker isn't able to make progress due to memory pressure
we only end up with a sparsely populated hash table for a longer period
of time. It does not affect insertion/deletion of the objects into the
hash.

Same goes for growing the table. If the expand worker is blocked on
anything the only adverse effect is that we end up with longer hash
chains than we would like until the expand worker has a chance to do
its work.

Regards,
Lucas
