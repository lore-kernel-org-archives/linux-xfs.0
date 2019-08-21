Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87511C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 21:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 606F72332A
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 21:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbfHUVZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 17:25:56 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:32900 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbfHUVZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 17:25:55 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 98DE236155B;
        Thu, 22 Aug 2019 07:25:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0Y61-0003D0-KQ; Thu, 22 Aug 2019 07:24:45 +1000
Date:   Thu, 22 Aug 2019 07:24:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190821212445.GO1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
 <20190821133533.GB19646@bfoster>
 <20190821150801.GF1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821150801.GF1037350@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=hh2uJfWZBeGf63x9iakA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 08:08:01AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 21, 2019 at 09:35:33AM -0400, Brian Foster wrote:
> > On Wed, Aug 21, 2019 at 06:38:19PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Memory we use to submit for IO needs strict alignment to the
> > > underlying driver contraints. Worst case, this is 512 bytes. Given
> > > that all allocations for IO are always a power of 2 multiple of 512
> > > bytes, the kernel heap provides natural alignment for objects of
> > > these sizes and that suffices.
> > > 
> > > Until, of course, memory debugging of some kind is turned on (e.g.
> > > red zones, poisoning, KASAN) and then the alignment of the heap
> > > objects is thrown out the window. Then we get weird IO errors and
> > > data corruption problems because drivers don't validate alignment
> > > and do the wrong thing when passed unaligned memory buffers in bios.
> > > 
> > > TO fix this, introduce kmem_alloc_io(), which will guaranteeat least
> > 
> > s/TO/To/
> > 
> > > 512 byte alignment of buffers for IO, even if memory debugging
> > > options are turned on. It is assumed that the minimum allocation
> > > size will be 512 bytes, and that sizes will be power of 2 mulitples
> > > of 512 bytes.
> > > 
> > > Use this everywhere we allocate buffers for IO.
> > > 
> > > This no longer fails with log recovery errors when KASAN is enabled
> > > due to the brd driver not handling unaligned memory buffers:
> > > 
> > > # mkfs.xfs -f /dev/ram0 ; mount /dev/ram0 /mnt/test
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/kmem.c            | 61 +++++++++++++++++++++++++++++-----------
> > >  fs/xfs/kmem.h            |  1 +
> > >  fs/xfs/xfs_buf.c         |  4 +--
> > >  fs/xfs/xfs_log.c         |  2 +-
> > >  fs/xfs/xfs_log_recover.c |  2 +-
> > >  fs/xfs/xfs_trace.h       |  1 +
> > >  6 files changed, 50 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > > index edcf393c8fd9..ec693c0fdcff 100644
> > > --- a/fs/xfs/kmem.c
> > > +++ b/fs/xfs/kmem.c
> > ...
> > > @@ -62,6 +56,39 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> > >  	return ptr;
> > >  }
> > >  
> > > +/*
> > > + * Same as kmem_alloc_large, except we guarantee a 512 byte aligned buffer is
> > > + * returned. vmalloc always returns an aligned region.
> > > + */
> > > +void *
> > > +kmem_alloc_io(size_t size, xfs_km_flags_t flags)
> > > +{
> > > +	void	*ptr;
> > > +
> > > +	trace_kmem_alloc_io(size, flags, _RET_IP_);
> > > +
> > > +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> > > +	if (ptr) {
> > > +		if (!((long)ptr & 511))
> 
> Er... didn't you say "it needs to grab the alignment from
> [blk_]queue_dma_alignment(), not use a hard coded value of 511"?

That's fine for the bio, which has a direct pointer to the request
queue. Here the allocation may be a long way away from the IO
itself, and we migh actually be slicing and dicing an allocated
region into a bio and not just the whole region itself.

So I've just taken the worst case - queue_dma_alignment() returns
511 if no queue is supplied, so this is the worst case alignment
that the block device will require. We don't need any more to fix
the problem right now, and getting alignment into this function in
all cases makes it a bit more complicated...

> How is this different?  If this buffer is really for IO then shouldn't
> we pass in the buftarg or something so that we find the real alignment?
> Or check it down in the xfs_buf code that associates a page to a buffer?

No, at worst we should in the alignment - there is no good reason to
be passing buftargs, block devices or request queues into memory
allocation APIs. I'll have a look at this.

> Even if all that logic is hidden behind CONFIG_XFS_DEBUG?

That's no good because memory debugging can be turned on without
CONFIG_XFS_DEBUG (how we tripped over the xenblk case).

> 
> > > +			return ptr;
> > > +		kfree(ptr);
> > > +	}
> > > +	return __kmem_vmalloc(size, flags);
> 
> How about checking the vmalloc alignment too?  If we're going to be this
> paranoid we might as well go all the way. :)

if vmalloc is returning unaligned regions, lots of stuff is going to
break everywhere. It has to be page aligned because of the pte
mappings it requires. Memory debugging puts guard pages around
vmalloc, it doesn't change the alignment.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
