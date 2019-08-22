Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA360C3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 22:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84BD721655
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 22:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731863AbfHVWlL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 18:41:11 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34559 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731357AbfHVWlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 18:41:10 -0400
Received: from dread.disaster.area (pa49-181-142-13.pa.nsw.optusnet.com.au [49.181.142.13])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 23225361093;
        Fri, 23 Aug 2019 08:41:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0vkN-0006TR-Mk; Fri, 23 Aug 2019 08:39:59 +1000
Date:   Fri, 23 Aug 2019 08:39:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190822223959.GC1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
 <20190821133533.GB19646@bfoster>
 <20190821211452.GN1119@dread.disaster.area>
 <20190822134017.GA24151@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822134017.GA24151@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=pdRIKMFd4+xhzJrg6WzXNA==:117 a=pdRIKMFd4+xhzJrg6WzXNA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=ki5DeA7u2y6F-YruhzIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 09:40:17AM -0400, Brian Foster wrote:
> On Thu, Aug 22, 2019 at 07:14:52AM +1000, Dave Chinner wrote:
> > On Wed, Aug 21, 2019 at 09:35:33AM -0400, Brian Foster wrote:
> > > On Wed, Aug 21, 2019 at 06:38:19PM +1000, Dave Chinner wrote:
> > > kmem_alloc_io() interface) to skip further kmem_alloc() calls from this
> > > path once we see one unaligned allocation. That assumes this behavior is
> > > tied to functionality that isn't dynamically configured at runtime, of
> > > course.
> > 
> > vmalloc() has a _lot_ more overhead than kmalloc (especially when
> > vmalloc has to do multiple allocations itself to set up page table
> > entries) so there is still an overall gain to be had by trying
> > kmalloc even if 50% of allocations are unaligned.
> > 
> 
> I had the impression that this unaligned allocation behavior is tied to
> enablement of debug options that otherwise aren't enabled/disabled
> dynamically. Hence, the unaligned allocation behavior is persistent for
> a particular mount and repeated attempts are pointless once we see at
> least one such result. Is that not the case?

The alignment for a given slab is likely to be persistent, but it
will be different for different sized slabs. e.g. I saw 128 offsets
for 512 slabs, and 1024 byte offsets for 4k slabs. The 1024 byte
offsets worked just fine (because multiple of 512 bytes!) but the
128 byte ones didn't.

Hence it's not a black and white "everythign is unaligned and
unsupportable" situation, nor is the alignment necessarily an issue
for the underlying driver. e.g. most scsi and nvme handle 8
byte alignment of buffers, and if the buffer is not aligned they
bounce it (detected via the same blk_rq_alignment() check I added)
and can still do the IO anyway. So a large amount of the IO stack
just doesn't care about user buffers being unaligned....

> Again, I don't think performance is a huge deal so long as testing shows
> that an fs is still usable with XFS running this kind of allocation
> pattern.

It's added 10 minutes to the runtime of a full auto run with KASAN
enabled on pmem. To put that in context, the entire run took:

real    461m36.831s
user    44m31.779s
sys     708m37.467s

More than 7.5 hours to complete, so ten minutes here or there is
noise.

> In thinking further about it, aren't we essentially bypassing
> these tools for associated allocations if they don't offer similar
> functionality for vmalloc allocations?

kasan uses guard pages around vmalloc allocations to detect out of
bound accesses. It still tracks the page allocations, etc, so we
still get use after free tracking, etc. i.e. AFAICT we don't
actually lose any debugging functonality by using vmalloc here.

> It might be worth 1.) noting that
> as a consequence of this change in the commit log and 2.) having a
> oneshot warning somewhere when we initially hit this problem so somebody
> actually using one of these tools realizes that enabling it actually
> changes allocation behavior. For example:
> 
> XFS ...: WARNING: Unaligned I/O memory allocation. VM debug enabled?
> Disabling slab allocations for I/O.
> 
> ... or alternatively just add a WARN_ON_ONCE() or something with a
> similar comment in the code.

Well, the WARN_ON_ONCE is in xfs_bio_add_page() when it detects an
invalid alignment. So we'll get this warning on production systems
as well as debug/test systems. I think that's the important case to
catch, because misalignment will result in silent data corruption...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
