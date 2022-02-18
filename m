Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7EBC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Feb 2022 22:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbiBRWzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Feb 2022 17:55:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238963AbiBRWzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Feb 2022 17:55:00 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DD8C274CAF
        for <linux-xfs@vger.kernel.org>; Fri, 18 Feb 2022 14:54:43 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2B6A710C799C;
        Sat, 19 Feb 2022 09:54:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nLC9A-00DfNi-BZ; Sat, 19 Feb 2022 09:54:40 +1100
Date:   Sat, 19 Feb 2022 09:54:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <20220218225440.GE59715@dread.disaster.area>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
 <20220217232033.GD59715@dread.disaster.area>
 <Yg+rdFRpvra8U25D@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg+rdFRpvra8U25D@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=621023b2
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=cPmQaLihXzZB1QTk6A0A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 18, 2022 at 09:21:40AM -0500, Brian Foster wrote:
> On Fri, Feb 18, 2022 at 10:20:33AM +1100, Dave Chinner wrote:
> > On Thu, Feb 17, 2022 at 12:25:17PM -0500, Brian Foster wrote:
> > > The free inode btree currently tracks all inode chunk records with
> > > at least one free inode. This simplifies the chunk and allocation
> > > selection algorithms as free inode availability can be guaranteed
> > > after a few simple checks. This is no longer the case with busy
> > > inode avoidance, however, because busy inode state is tracked in the
> > > radix tree independent from physical allocation status.
> > > 
> > > A busy inode avoidance algorithm relies on the ability to fall back
> > > to an inode chunk allocation one way or another in the event that
> > > all current free inodes are busy. Hack in a crude allocation
> > > fallback mechanism for experimental purposes. If the inode selection
> > > algorithm is unable to locate a usable inode, allow it to return
> > > -EAGAIN to perform another physical chunk allocation in the AG and
> > > retry the inode allocation.
> > > 
> > > The current prototype can perform this allocation and retry sequence
> > > repeatedly because a newly allocated chunk may still be covered by
> > > busy in-core inodes in the radix tree (if it were recently freed,
> > > for example). This is inefficient and temporary. It will be properly
> > > mitigated by background chunk removal. This defers freeing of inode
> > > chunk blocks from the free of the last used inode in the chunk to a
> > > background task that only frees chunks once completely idle, thereby
> > > providing a guarantee that a new chunk allocation always adds
> > > non-busy inodes to the AG.
> > 
> > I think you can get rid of this simply by checking the radix tree
> > tags for busy inodes at the location of the new inode chunk before
> > we do the cluster allocation. If there are busy inodes in the range
> > of the chunk (pure gang tag lookup, don't need to dereference any of
> > the inodes), just skip to the next chunk offset and try that. Hence
> > we only ever end up allocating a chunk that we know there are no
> > busy inodes in and this retry mechanism is unnecessary.
> > 
> 
> The retry mechanism exists in this series due to the factoring of the
> inode allocation code moreso than whether the fallback is guaranteed to
> provide a fully non-busy chunk or not. As the prototype is written, the
> inode scan still needs to fall back at least once even with such a
> guarantee (see my reply on the previous patch around cleaning up that
> particular wart).
> 
> With regard to checking busy inode state, that is pretty much what I was
> referring to by filtering or hinting the block allocation when we
> discussed this on IRC. I'm explicitly trying to avoid that because for
> one it unnecessarily spreads concern about busy inodes across layers. On
> top of that, it assumes that there will always be some usable physical
> block range available without busy inodes, which is not the case. That
> means we now need to consider the fact that chunk allocation might fail
> for reasons other than -ENOSPC and factor that into the inode allocation
> algorithm. IOW, ISTM this just unnecessarily complicates things for
> minimal benefit.

For the moment, if inode allocation fails because we have busy
inodes after chunk allocation has already been done, then we are
hitting a corner case that isn't typical fast path operation. I
think that we should not complicate things by trying to optimise
this case unnecessarily.

I'd just expedite reclaim using synchronize_rcu() and re-run the
finobt scan as it will always succeed the second time because we
haven't dropped the AGI log and all freed inodes have now passed
through a grace period. Indeed, we need this expedited reclaim path
anyway because if we fail to allocate a new chunk and there are busy
inodes, we need to wait for busy inodes to become unbusy to avoid
premature ENOSPC while there are still avaialbe free inodes.

In the case of the updated inode lifecycle stuff I'm working on, a
log force will replace the synchronise_rcu() call because the inodes
will be XFS_ISTALE and journal IO completion of the cluster buffers
will trigger the inodes to be reclaimed immediately as writeback is
elided for XFS_ISTALE inodes. We may need an AIL push in other
cases, but I'll cross that river when I get to it.

> The point of background freeing inode chunks was that it makes this
> problem go away because then we ensure that inode chunks aren't freed
> until all associated busy inodes are cleared, and so we preserve the
> historical behavior that an inode chunk allocation guarantees immediate
> ability to allocate an inode. I thought we agreed in the previous
> discussion that this was the right approach since it seemed to be in the
> long term direction for XFS anyways.. hm?

Long term, yes, but we need something that works effectively and
efficiently now, with minimal additional overhead, because we're
going to have to live with this code in the allocation fast path for
some time yet.

Really, I want foreground inode allocation to know nothing about
inode chunk allocation. If there are no inodes available for
allocation, it kicks background inode chunk management and sleeps
waiting for to be given an allocated inode it can use. It shouldn't
even have to know about busy inodes - just work from an in-memory
per-ag free list of inode numbers that can be immediately allocated.

In this situation, inodes that have been recently unlinked don't
show up on that list until they can be reallocated safely. This
is all managed asynchronously in the background by the inodegc state
machine (what I'm currently working on) and when the inode is
finally reclaimed it is moved into the free list and allowed to be
reallocated.

IOWs, the long term direction is to make sure that the
foreground inode allocator doesn't even know about the existence of
busy inodes and it gets faster and simpler as we push all the mess
into the background that runs all the slow path allocation and
freeing algorithms.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
