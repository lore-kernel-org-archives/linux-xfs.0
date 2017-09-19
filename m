Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:50906 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdISQ3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 12:29:22 -0400
Received: by mail-wm0-f45.google.com with SMTP id v142so365426wmv.5
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 09:29:22 -0700 (PDT)
Subject: Re: io_submit() blocks for writes for substantial amount of time
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <22a2db70-50e2-7a37-97f5-1751eafc3f7c@scylladb.com>
Date: Tue, 19 Sep 2017 19:29:18 +0300
MIME-Version: 1.0
In-Reply-To: <20170919122704.GA3487@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Tomasz Grabiec <tgrabiec@scylladb.com>
Cc: linux-xfs@vger.kernel.org



On 09/19/2017 03:27 PM, Brian Foster wrote:
> On Tue, Sep 19, 2017 at 10:50:51AM +0200, Tomasz Grabiec wrote:
>> Hi,
>>
>> On some systems we are seeing one of our tests to trigger io_submit()
>> calls to block when submitting writes for an order of 100ms [1]. This
>> is problematic, because we heavily rely on io_submit() being async.
>>
>> Workload: open, (ftruncate, append*)*, close.
>>
>> Kernel version: 4.12.9-300.fc26.x86_64
>> mount: /dev/nvme0n1p3 on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
>>
>> The blocking happens in the following places:
>>
>> (1)
>>
>>              7fff9287472f __schedule ([kernel.kallsyms])
>>              7fff92874d16 schedule ([kernel.kallsyms])
>>              7fff92878d42 schedule_timeout ([kernel.kallsyms])
>>              7fff92876478 wait_for_completion ([kernel.kallsyms])
>>              7fffc05bf231 xfs_buf_submit_wait ([kernel.kallsyms])
>>              7fffc05bf3d3 _xfs_buf_read ([kernel.kallsyms])
>>              7fffc05bf4e4 xfs_buf_read_map ([kernel.kallsyms])
>>              7fffc05f53ca xfs_trans_read_buf_map ([kernel.kallsyms])
>>              7fffc058b432 xfs_btree_read_buf_block.constprop.34
>> ([kernel.kallsyms])
>>              7fffc058b504 xfs_btree_lookup_get_block ([kernel.kallsyms])
>>              7fffc058f6ad xfs_btree_lookup ([kernel.kallsyms])
>>              7fffc0570919 xfs_alloc_lookup_eq ([kernel.kallsyms])
>>              7fffc0570c59 xfs_alloc_fixup_trees ([kernel.kallsyms])
>>              7fffc0573a2d xfs_alloc_ag_vextent_near ([kernel.kallsyms])
>>              7fffc0573db1 xfs_alloc_ag_vextent ([kernel.kallsyms])
>>              7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
>>              7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
>>              7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
>>              7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
>>              7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
>>              7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
>>              7fff922d46ca iomap_apply ([kernel.kallsyms])
>>              7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
>>              7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
>>              7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
>>              7fff922bc5d3 aio_write ([kernel.kallsyms])
>>              7fff922bcec1 do_io_submit ([kernel.kallsyms])
>>              7fff922bdd40 sys_io_submit ([kernel.kallsyms])
>>              7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
>>                       687 io_submit (/usr/lib64/libaio.so.1.0.1)
>>                    112373 seastar::reactor::flush_pending_aio
>> (/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)
> So you have a direct I/O write that requires block allocation. Block
> allocation requires reading free space btree blocks to identify and fix
> up remaining free extent records based on the allocation.

Will an fallocate() call before the write in another thread help?

Will a write to a previously fallocate()d extent get blocked while 
fallocate()ing a new extent?

>
>> (2)
>>
>>    7fff9287472f __schedule ([kernel.kallsyms])
>>              7fff92874d16 schedule ([kernel.kallsyms])
>>              7fffc05e6265 _xfs_log_force ([kernel.kallsyms])
>>              7fffc05c2518 xfs_extent_busy_flush ([kernel.kallsyms])
>>              7fffc0572ccd xfs_alloc_ag_vextent_size ([kernel.kallsyms])
>>              7fffc0573d91 xfs_alloc_ag_vextent ([kernel.kallsyms])
>>              7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
>>              7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
>>              7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
>>              7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
>>              7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
>>              7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
>>              7fff922d46ca iomap_apply ([kernel.kallsyms])
>>              7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
>>              7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
>>              7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
>>              7fff922bc5d3 aio_write ([kernel.kallsyms])
>>              7fff922bcec1 do_io_submit ([kernel.kallsyms])
>>              7fff922bdd40 sys_io_submit ([kernel.kallsyms])
>>              7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
>>                       687 io_submit (/usr/lib64/libaio.so.1.0.1)
>>                    112373 seastar::reactor::flush_pending_aio
>> (/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)
>>
> Another dio write that requires allocation. The allocation finds a busy
> extent, which means the extent was recently freed but the associated
> freeing transaction has not yet made it to the on-disk log. As such it
> cannot be safely reused, so the allocator flushes the log and retries to
> try and clear the busy state and find an extent.

Is that because the disk is nearly full and there are no known flushed 
extents, or because the allocator doesn't prioritize known-flushed 
extents? From your comments below I gather you may not know for sure.

>
>> Please advise, is this a known bug? When can it happen? Is there a way
>> to work it around to avoid blocking?
>>
> I'm not sure how either could be considered a bug based on the stack
> trace information alone. Allocations may require reading metadata and
> reads are synchronous. This all seems like pretty basic filesystem
> behavior.

Synchronous behavior in an asynchronous system call can be considered a 
bug, although of course this has been the case in Linux since forever. 
If there are ways we can get the filesystem to behave more 
asynchronously (like nowait aio) we'll use them.

>
> I suppose performance may be a separate question. For the latter issue,
> I'd be curious whether leaving more free space available in the
> filesystem would help avoid running into busy extents. Perhaps having
> more memory and thus a larger buffer cache for btree blocks could help
> mitigate the former issue..? The deterministic workaround for both is to
> preallocate the associated file. If the file would be too large, another
> option may be to set an extent size hint to allocate the file in larger
> chunks and amortize the cost of the allocations over multiple writes.

We do set the allocation size hint. We don't really know the file size 
in advance though. If fallocate() and io_submit() can run in parallel 
without fallocate() blocking io_submit(), we can have another thread run 
ahead of the writer and issue fallocate()s. I guess we can double the 
fallocate() size each time to amortize the effort.

Is ftruncate() sufficient to release extents past-the-end, or do we need 
an extra FALLOC_FL_PUNCH_HOLE?

