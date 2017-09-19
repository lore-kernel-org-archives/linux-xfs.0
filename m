Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdISRix (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 13:38:53 -0400
Date: Tue, 19 Sep 2017 13:38:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: io_submit() blocks for writes for substantial amount of time
Message-ID: <20170919173850.GA8139@dhcp-41-131.bos.redhat.com>
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <22a2db70-50e2-7a37-97f5-1751eafc3f7c@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22a2db70-50e2-7a37-97f5-1751eafc3f7c@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 07:29:18PM +0300, Avi Kivity wrote:
> 
> 
> On 09/19/2017 03:27 PM, Brian Foster wrote:
> > On Tue, Sep 19, 2017 at 10:50:51AM +0200, Tomasz Grabiec wrote:
> > > Hi,
> > > 
> > > On some systems we are seeing one of our tests to trigger io_submit()
> > > calls to block when submitting writes for an order of 100ms [1]. This
> > > is problematic, because we heavily rely on io_submit() being async.
> > > 
> > > Workload: open, (ftruncate, append*)*, close.
> > > 
> > > Kernel version: 4.12.9-300.fc26.x86_64
> > > mount: /dev/nvme0n1p3 on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
> > > 
> > > The blocking happens in the following places:
> > > 
> > > (1)
> > > 
> > >              7fff9287472f __schedule ([kernel.kallsyms])
> > >              7fff92874d16 schedule ([kernel.kallsyms])
> > >              7fff92878d42 schedule_timeout ([kernel.kallsyms])
> > >              7fff92876478 wait_for_completion ([kernel.kallsyms])
> > >              7fffc05bf231 xfs_buf_submit_wait ([kernel.kallsyms])
> > >              7fffc05bf3d3 _xfs_buf_read ([kernel.kallsyms])
> > >              7fffc05bf4e4 xfs_buf_read_map ([kernel.kallsyms])
> > >              7fffc05f53ca xfs_trans_read_buf_map ([kernel.kallsyms])
> > >              7fffc058b432 xfs_btree_read_buf_block.constprop.34
> > > ([kernel.kallsyms])
> > >              7fffc058b504 xfs_btree_lookup_get_block ([kernel.kallsyms])
> > >              7fffc058f6ad xfs_btree_lookup ([kernel.kallsyms])
> > >              7fffc0570919 xfs_alloc_lookup_eq ([kernel.kallsyms])
> > >              7fffc0570c59 xfs_alloc_fixup_trees ([kernel.kallsyms])
> > >              7fffc0573a2d xfs_alloc_ag_vextent_near ([kernel.kallsyms])
> > >              7fffc0573db1 xfs_alloc_ag_vextent ([kernel.kallsyms])
> > >              7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
> > >              7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
> > >              7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
> > >              7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
> > >              7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
> > >              7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
> > >              7fff922d46ca iomap_apply ([kernel.kallsyms])
> > >              7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
> > >              7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
> > >              7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
> > >              7fff922bc5d3 aio_write ([kernel.kallsyms])
> > >              7fff922bcec1 do_io_submit ([kernel.kallsyms])
> > >              7fff922bdd40 sys_io_submit ([kernel.kallsyms])
> > >              7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
> > >                       687 io_submit (/usr/lib64/libaio.so.1.0.1)
> > >                    112373 seastar::reactor::flush_pending_aio
> > > (/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)
> > So you have a direct I/O write that requires block allocation. Block
> > allocation requires reading free space btree blocks to identify and fix
> > up remaining free extent records based on the allocation.
> 
> Will an fallocate() call before the write in another thread help?
> 

Preallocating the file (or largish ranges) should help. I'm not sure
preallocating the range of each and every write will have the behavior
you want.

> Will a write to a previously fallocate()d extent get blocked while
> fallocate()ing a new extent?
> 

Any dio can most likely block behind an fallocate call due to locking
(just like any write that requires allocation can block behind another
such write).

> > 
> > > (2)
> > > 
> > >    7fff9287472f __schedule ([kernel.kallsyms])
> > >              7fff92874d16 schedule ([kernel.kallsyms])
> > >              7fffc05e6265 _xfs_log_force ([kernel.kallsyms])
> > >              7fffc05c2518 xfs_extent_busy_flush ([kernel.kallsyms])
> > >              7fffc0572ccd xfs_alloc_ag_vextent_size ([kernel.kallsyms])
> > >              7fffc0573d91 xfs_alloc_ag_vextent ([kernel.kallsyms])
> > >              7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
> > >              7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
> > >              7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
> > >              7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
> > >              7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
> > >              7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
> > >              7fff922d46ca iomap_apply ([kernel.kallsyms])
> > >              7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
> > >              7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
> > >              7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
> > >              7fff922bc5d3 aio_write ([kernel.kallsyms])
> > >              7fff922bcec1 do_io_submit ([kernel.kallsyms])
> > >              7fff922bdd40 sys_io_submit ([kernel.kallsyms])
> > >              7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
> > >                       687 io_submit (/usr/lib64/libaio.so.1.0.1)
> > >                    112373 seastar::reactor::flush_pending_aio
> > > (/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)
> > > 
> > Another dio write that requires allocation. The allocation finds a busy
> > extent, which means the extent was recently freed but the associated
> > freeing transaction has not yet made it to the on-disk log. As such it
> > cannot be safely reused, so the allocator flushes the log and retries to
> > try and clear the busy state and find an extent.
> 
> Is that because the disk is nearly full and there are no known flushed
> extents, or because the allocator doesn't prioritize known-flushed extents?
> From your comments below I gather you may not know for sure.
> 

I'm not sure without digging further into it. Hence the question around
free space availability.

> > 
> > > Please advise, is this a known bug? When can it happen? Is there a way
> > > to work it around to avoid blocking?
> > > 
> > I'm not sure how either could be considered a bug based on the stack
> > trace information alone. Allocations may require reading metadata and
> > reads are synchronous. This all seems like pretty basic filesystem
> > behavior.
> 
> Synchronous behavior in an asynchronous system call can be considered a bug,
> although of course this has been the case in Linux since forever. If there
> are ways we can get the filesystem to behave more asynchronously (like
> nowait aio) we'll use them.
> 

I think the RWF_NOWAIT thing that hch pointed out is intended to cover
this (i.e., if you must be absolutely sure that nothing will block the
current thread). It looks like it will skip calls that require
allocations, fail to acquire locks, etc. so they can be deferred.

> > 
> > I suppose performance may be a separate question. For the latter issue,
> > I'd be curious whether leaving more free space available in the
> > filesystem would help avoid running into busy extents. Perhaps having
> > more memory and thus a larger buffer cache for btree blocks could help
> > mitigate the former issue..? The deterministic workaround for both is to
> > preallocate the associated file. If the file would be too large, another
> > option may be to set an extent size hint to allocate the file in larger
> > chunks and amortize the cost of the allocations over multiple writes.
> 
> We do set the allocation size hint. We don't really know the file size in
> advance though. If fallocate() and io_submit() can run in parallel without
> fallocate() blocking io_submit(), we can have another thread run ahead of
> the writer and issue fallocate()s. I guess we can double the fallocate()
> size each time to amortize the effort.
> 

What size hint? I'm not familiar with your workload/requirements, but it
sounds like RWF_NOWAIT might be what you want. You can defer any write
that requires allocation outright and any subsequent write that ends up
blocked due to locking would also return -EAGAIN.

If you did end up deferring those calls in favor of an fallocate, you
could certainly amortize the cost by doing aggressive post-eof
allocations. XFS does something similar internally to preserve
contiguity of delayed allocations. 

> Is ftruncate() sufficient to release extents past-the-end, or do we need an
> extra FALLOC_FL_PUNCH_HOLE?

Yes, a truncate trims post-eof blocks.

Brian

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
