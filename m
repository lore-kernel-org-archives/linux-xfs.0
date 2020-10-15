Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC30C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 22:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E47F320776
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 22:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgJOWfv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 18:35:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38176 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731745AbgJOWfv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 18:35:51 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6466558C8B5;
        Fri, 16 Oct 2020 09:35:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kTBqe-000w2N-Nf; Fri, 16 Oct 2020 09:35:48 +1100
Date:   Fri, 16 Oct 2020 09:35:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/27] [RFC, WIP] xfsprogs: xfs_buf unification and AIO
Message-ID: <20201015223548.GL7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015183756.GE9837@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015183756.GE9837@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=z1m98DuUVFg4FMCVZDYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 11:37:56AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 06:21:28PM +1100, Dave Chinner wrote:
> > - AIO engine does not support discontiguous buffers.
> > 
> > - work out best way to handle IOCBs for AIO - is embedding them in
> >   the xfs_buf the only way to do this efficiently?
> 
> The only other way I can think of is to embed MAX_AIO_EVENTS iocbs in
> the buftarg and (I guess) track which ones are free with a bitmap.

I originally had an array embedded in the buftarg, and when I
realised that I had to rtack exactly which ones were still in use I
trashed it and moved the iocb to the struct xfs_buf so no tracking
is necessary. All I need to do is change the buffer allocation code
to allocate an iocb array when it allocates the map array so we have
a direct b_maps -> b_iocbs relationship at all times.

> That
> would cut down the iocb memory overhead to the IOs that we're actually
> running at a cost of more bookkeepping and potential starvation issues
> for the yuuuge buffer that takes a long time to collect all NR iocbs.

We've already got a huge amount of per-buffer state, so adding iocbs
to that isn't a huge deal...

> > - rationalise the xfs_buf/xfs_buftarg split. Work out where to define
> >   the stuff that is different between kernel and userspace (e.g. the
> >   struct xfs_buf) vs the stuff that remains the same (e.g. the XBF
> >   buffer flags)
> 
> Ow my brain.

Yeah. :(

> > - lots of code cleanup
> > 
> > - xfs_repair does not cache between phases right now - it
> >   unconditionally purges the AG cache at the end of AG processing.
> >   This keeps memory usage way down, and for filesystems that have
> >   too much metadata to cache entirely in RAM, it's *much* faster
> 
> Why is it faster to blow out the cache?  Is it the internal overhead of
> digging through a huge buftarg hash table to find the buffer that the
> caller wants and/or whacking enough of the other stale buffers to free
> up memory to avoid the buffer cache limits?

Lots of reasons. The size of the hash table/chain length is largely
irrelevant. The biggest issue seems to be memory allocation for the
buffers - when we allocate the buffer, malloc does a mprotect() call
on the new heap space for some reason and that takes the mmap_sem in
write mode. Which serialises all the page faults being done while
reading those buffers as they take the mmap_sem shared. Hence while
we are allocating new heap space, there's massive numbers of context
switches on the mmap_sem contention. COntext switch profile while
running at ~150,000 context switches a second:

   64.45%    64.45%  xfs_repair       [kernel.kallsyms]         [k] schedule
            |          
            |--41.02%--__memmove_sse2_unaligned_erms
            |          |          
            |           --40.95%--asm_exc_page_fault
            |                     exc_page_fault
            |                     |          
            |                      --40.95%--down_read
            |                                rwsem_down_read_slowpath
            |                                schedule
            |                                schedule
            |          
            |--7.88%--sysmalloc
            |          |          
            |           --7.87%--asm_exc_page_fault
            |                     exc_page_fault
            |                     |          
            |                      --7.86%--down_read
            |                                rwsem_down_read_slowpath
            |                                schedule
            |                                schedule
....
            |          
             --1.68%--__mprotect
                       |          
                        --1.68%--entry_SYSCALL_64_after_hwframe
                                  do_syscall_64
                                  |          
                                   --1.68%--__x64_sys_mprotect
                                             do_mprotect_pkey
                                             |          
                                              --1.68%--down_write_killable
                                                        rwsem_down_write_slowpath
                                                        schedule
                                                        schedule

The __memmove_sse2_unaligned_erms() function is from the memcpy()
loop in repair/prefetch.c where it is copying metadata from the
large IO buffer into the individual xfs_bufs (i.e. read TLB faults)
and AFAICT the mprotect() syscalls are coming from malloc heap
expansion. About 7% of the context switches are from pthread_mutex
locks, and only 2.5% of the context switches are from the pread() IO
that is being done.

IOWs, while memory footprint is growing/changing, repair performance
is largely limited by mmap_sem concurrency issues.

So my reading of this is that by bounding the memory footprint of
repair by freeing the buffers back to the heap regularly, we largely
stay out of the heap grow mprotect path and avoid this mmap_sem
contention. That allows the CPU intensive parts of prefetch and
metadata verification to run more efficiently....

> >   than xfs_repair v5.6.0. On smaller filesystems, however, hitting
> >   RAM caches is much more desirable. Hence there is work to be done
> >   here determining how to manage the caches effectively.
> > 
> > - async buffer readahead works in userspace now, but unless you have
> >   a very high IOP device (think in multiples of 100kiops) the
> >   xfs_repair prefetch mechanism that trades off bandwidth for iops is
> >   still faster. More investigative work is needed here.
> 
> (No idea what this means.)

The SSD I've been testing on peaks at about 70,000kiops for reads.
If I drive prefetch by xfs_buf_readahead() only (got patches that do
that) then, compared to 5.6.0, prefetch bandwidth drops to ~400MB/s
but the device is iops bound and so prefetch is slower than when
5.6.0 uses 2MB IOs, does ~5-10kiops and consumes 900MB/s of bandwidth.

This patchset runs the existing prefetch code at 15-20kiops and
1.8-2.1GB/s using 2MB IOs - we still get better throughput on these
SSDs by trading off iops for bandwidth.

The original patchset I wrote (but never published) had similar
performance on the above hardware, but I also ran it on faster SSDs.
On those, repair could push them to around 200-250kiops with
prefetch by xfs_buf_readahead() and that was much faster than the
2-2.5GB/s that the existing prefetch could get before being limited
by the pcie 3.0 4x bus the SSD is on. I'll have some numbers from
this patchset on my faster hardware next week, but I don't expect
them to be much different...

So, essentially, if you've got more small read IOPS capacity than
you have "sparse metadata population optimised" large IO bandwidth
(or metadata too sparse to trigger the large IO optimisations) then
using xfs_buf_readahead() appears to more efficient than using the
existing prefetch code.

That said, there's a lot of testing, observation and analysis needed
to determine what will be the best general approach here. Signs
are pointing towards "existing prefetch for rotational storage and
low iops ssds" and miminal caching and on-demand prefetch for high
end SSDs, but we'll see how that stands up...

> > - xfs_db could likely use readahead for btree traversals and other
> >   things.
> > 
> > - More memory pressure trigger testing needs to be done to determine
> >   if the trigger settings are sufficient to prevent OOM kills on
> >   different hardware and filesystem configurations.
> > 
> > - Replace AIO engine with io_uring engine?
> 
> Hm, is Al actually going to review io_uring as he's been threatening to
> do?  I'd hold off until that happens, or one of us goes and tests it in
> anger to watch all the smoke leak out, etc...

Yeah, I'm in no hurry to do this. Just making sure people understand
that it's a potential future direction.

> > - start working on splitting the kernel xfs_buf.[ch] code the same
> >   way as the userspace code and moving xfs_buf.[ch] to fs/xfs/libxfs
> >   so that they can be updated in sync.
> 
> Aha, so yes that answers my question in ... whichever patch that was
> somewhere around #17.

Right. I had to start somewhere, and given that userspace
requirements largely define how the split needs to occur, I decided
to start by making userspace work and then, once that is done,
change the kernel to match the same structure that userspace
needed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
