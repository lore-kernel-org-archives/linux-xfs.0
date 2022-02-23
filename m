Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AD3C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Feb 2022 07:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiBWHB3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Feb 2022 02:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbiBWHB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Feb 2022 02:01:28 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 478B06E2BC
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 23:01:01 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5B51152ED24;
        Wed, 23 Feb 2022 18:01:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nMldy-00FNIh-UQ; Wed, 23 Feb 2022 18:00:58 +1100
Date:   Wed, 23 Feb 2022 18:00:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <20220223070058.GK59715@dread.disaster.area>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
 <20220217232033.GD59715@dread.disaster.area>
 <Yg+rdFRpvra8U25D@bfoster>
 <20220218225440.GE59715@dread.disaster.area>
 <YhKM6u3yuF1Ek4/w@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhKM6u3yuF1Ek4/w@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6215dbac
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=Nzppoe_MrsEVaxlPlfkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 20, 2022 at 01:48:10PM -0500, Brian Foster wrote:
> On Sat, Feb 19, 2022 at 09:54:40AM +1100, Dave Chinner wrote:
> > On Fri, Feb 18, 2022 at 09:21:40AM -0500, Brian Foster wrote:
> > > The point of background freeing inode chunks was that it makes this
> > > problem go away because then we ensure that inode chunks aren't freed
> > > until all associated busy inodes are cleared, and so we preserve the
> > > historical behavior that an inode chunk allocation guarantees immediate
> > > ability to allocate an inode. I thought we agreed in the previous
> > > discussion that this was the right approach since it seemed to be in the
> > > long term direction for XFS anyways.. hm?
> > 
> > Long term, yes, but we need something that works effectively and
> > efficiently now, with minimal additional overhead, because we're
> > going to have to live with this code in the allocation fast path for
> > some time yet.
> > 
> 
> Right, but I thought this is why we were only going to do the background
> freeing part of the whole "background inode management" thing?
> 
> Short of that, I'm not aware of a really great option atm. IMO, pushing
> explicit busy inode state/checking down into the block allocator is kind
> of a gross layering violation. The approach this series currently uses
> is simple and effective, but it's an unbound retry mechanism that just
> continues to allocate chunks until we get one we can use, which is too
> crude for production.

*nod*

Right, that's why I want to get this whole mechanism completely
detached from the VFS inode RCU life cycle rules and instead
synchronised by internal IO operations such as log forces.

The code I currently have is based on your changes, just without the
fallback chunk allocation. I'm not really even scanning the irecs;
I just look at the number of free inodes and count the number of
busy inodes over the range of the record. If they aren't the same,
we've got inodes in that record we can allocate from. I only do a
free inode-by-free inode busy check once the irec we are going to
allocate from has been selected.

Essentially, I'm just scanning records in the finobt to find the
first with a non-busy inode. If we fall off the end of the finobt,
it issues a log force and kicks the AIL and then retries the
allocation from the finobt. There isn't any attempt to allocate new
inode chunks in the case, but it may end up being necessary and can
be done without falling back to the outer loops.

i.e. as long as we track whether we've allocated a new inode chunk
or not, we can bound the finobt search to a single retry. If we
allocated a new chunk before entering the finobt search, then all we
need is a log force because the busy inodes, by definition, are
XFS_ISTALE at this point and waiting for a CIL push before they can
be reclaimed. At this point an retry of the finobt scan will find
those inodes that were busy now available for allocation.

If we haven't allocated a new chunk, then we can do so immediately
and retry the allocation. If we still find them all busy, we force
the log...

IOWs, once we isolate this busy inode tracking from the VFS inode
RCU requirements, we can bound the allocation behaviour because
chunk allocation and log forces provide us with a guarantee that the
newly allocated inode chunks contain inodes that can be immediately
reallocated without having to care about where the new inode chunk
is located....

> Perhaps a simple enough short term option is to use the existing block
> alloc min/max range mechanisms (as mentioned on IRC). For example:
> 
> - Use the existing min/max_agbno allocation arg input values to attempt
>   one or two chunk allocs outside of the known range of busy inodes for
>   the AG (i.e., allocate blocks higher than the max busy agino or lower
>   than the min busy agino).
> - If success, then we know we've got a chunk w/o busy inodes.
> - If failure, fall back to the existing chunk alloc calls, take whatever
>   we get and retry the finobt scan (perhaps more aggressively checking
>   each record) hoping we got a usable new record.
> - If that still fails, then fall back to synchronize_rcu() as a last
>   resort and grab one of the previously busy inodes.
> 
> I couldn't say for sure if that would be effective enough without
> playing with it a bit, but that would sort of emulate an algorithm that
> filtered chunk block allocations with at least one busy inode without
> having to modify block allocation code. If it avoids an RCU sync in the
> majority of cases it might be effective enough as a stopgap until
> background freeing exists. Thoughts?

It might work, but I'm not a fan of how many hoops we are considering
jumping through to avoid getting tangled up in the RCU requirements
for VFS inode life cycles. I'd much prefer just being able to say
"all inodes busy, log force, try again" like we do with busy extent
limited block allocation...

That said, the complexity gets moved elsewhere (the VFS inode
lifecycle management) rather than into the inode allocator, but I
think that's a valid trade-off because the RCU requirements for
inode reallocation come from the VFS inode lifecycle constraints.

> > Really, I want foreground inode allocation to know nothing about
> > inode chunk allocation. If there are no inodes available for
> > allocation, it kicks background inode chunk management and sleeps
> > waiting for to be given an allocated inode it can use. It shouldn't
> > even have to know about busy inodes - just work from an in-memory
> > per-ag free list of inode numbers that can be immediately allocated.
> > 
> > In this situation, inodes that have been recently unlinked don't
> > show up on that list until they can be reallocated safely. This
> > is all managed asynchronously in the background by the inodegc state
> > machine (what I'm currently working on) and when the inode is
> > finally reclaimed it is moved into the free list and allowed to be
> > reallocated.
> > 
> 
> I think that makes a lot of sense. That's quite similar to another
> experiment I was playing with that essentially populated a capped size
> pool of background inactivated inodes that the allocation side could
> pull directly from (i.e., so allocation actually becomes a radix tree
> lookup instead of a filtered btree scan), but so far I was kind of
> fighting with the existing mechanisms, trying not to peturb sustained
> remove performance, etc., and hadn't been able to produce a performance
> benefit yet. Perhaps this will work out better with the bigger picture
> changes to inode lifecycle and background inode management in place..

*nod*

The "don't have a perf impact" side of thigns is generally why I
test all my new code with fsmark and other scalability tests before
I go anywhere near fstests. If it doesn't perform, it's not worth
trying to make work correctly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
