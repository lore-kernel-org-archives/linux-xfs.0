Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA2EC3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 12:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC91F21897
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 12:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733296AbfHWMKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 08:10:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbfHWMKF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Aug 2019 08:10:05 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5EB03086228;
        Fri, 23 Aug 2019 12:10:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EBC86313A;
        Fri, 23 Aug 2019 12:10:04 +0000 (UTC)
Date:   Fri, 23 Aug 2019 08:10:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190823121002.GA53137@bfoster>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
 <20190821133533.GB19646@bfoster>
 <20190821211452.GN1119@dread.disaster.area>
 <20190822134017.GA24151@bfoster>
 <20190822223959.GC1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822223959.GC1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 23 Aug 2019 12:10:04 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:39:59AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 09:40:17AM -0400, Brian Foster wrote:
> > On Thu, Aug 22, 2019 at 07:14:52AM +1000, Dave Chinner wrote:
> > > On Wed, Aug 21, 2019 at 09:35:33AM -0400, Brian Foster wrote:
> > > > On Wed, Aug 21, 2019 at 06:38:19PM +1000, Dave Chinner wrote:
> > > > kmem_alloc_io() interface) to skip further kmem_alloc() calls from this
> > > > path once we see one unaligned allocation. That assumes this behavior is
> > > > tied to functionality that isn't dynamically configured at runtime, of
> > > > course.
> > > 
> > > vmalloc() has a _lot_ more overhead than kmalloc (especially when
> > > vmalloc has to do multiple allocations itself to set up page table
> > > entries) so there is still an overall gain to be had by trying
> > > kmalloc even if 50% of allocations are unaligned.
> > > 
> > 
> > I had the impression that this unaligned allocation behavior is tied to
> > enablement of debug options that otherwise aren't enabled/disabled
> > dynamically. Hence, the unaligned allocation behavior is persistent for
> > a particular mount and repeated attempts are pointless once we see at
> > least one such result. Is that not the case?
> 
> The alignment for a given slab is likely to be persistent, but it
> will be different for different sized slabs. e.g. I saw 128 offsets
> for 512 slabs, and 1024 byte offsets for 4k slabs. The 1024 byte
> offsets worked just fine (because multiple of 512 bytes!) but the
> 128 byte ones didn't.
> 

Interesting. I wasn't aware offsets could be large enough to maintain
alignment requirements.

> Hence it's not a black and white "everythign is unaligned and
> unsupportable" situation, nor is the alignment necessarily an issue
> for the underlying driver. e.g. most scsi and nvme handle 8
> byte alignment of buffers, and if the buffer is not aligned they
> bounce it (detected via the same blk_rq_alignment() check I added)
> and can still do the IO anyway. So a large amount of the IO stack
> just doesn't care about user buffers being unaligned....
> 
> > Again, I don't think performance is a huge deal so long as testing shows
> > that an fs is still usable with XFS running this kind of allocation
> > pattern.
> 
> It's added 10 minutes to the runtime of a full auto run with KASAN
> enabled on pmem. To put that in context, the entire run took:
> 
> real    461m36.831s
> user    44m31.779s
> sys     708m37.467s
> 
> More than 7.5 hours to complete, so ten minutes here or there is
> noise.
> 

Agreed. Thanks for the data.

> > In thinking further about it, aren't we essentially bypassing
> > these tools for associated allocations if they don't offer similar
> > functionality for vmalloc allocations?
> 
> kasan uses guard pages around vmalloc allocations to detect out of
> bound accesses. It still tracks the page allocations, etc, so we
> still get use after free tracking, etc. i.e. AFAICT we don't
> actually lose any debugging functonality by using vmalloc here.
> 

Ok.

> > It might be worth 1.) noting that
> > as a consequence of this change in the commit log and 2.) having a
> > oneshot warning somewhere when we initially hit this problem so somebody
> > actually using one of these tools realizes that enabling it actually
> > changes allocation behavior. For example:
> > 
> > XFS ...: WARNING: Unaligned I/O memory allocation. VM debug enabled?
> > Disabling slab allocations for I/O.
> > 
> > ... or alternatively just add a WARN_ON_ONCE() or something with a
> > similar comment in the code.
> 
> Well, the WARN_ON_ONCE is in xfs_bio_add_page() when it detects an
> invalid alignment. So we'll get this warning on production systems
> as well as debug/test systems. I think that's the important case to
> catch, because misalignment will result in silent data corruption...
> 

That's in the subsequent patch that I thought was being dropped (or more
accurately, deferred until Christoph has a chance to try and get it
fixed in the block layer..)..?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
