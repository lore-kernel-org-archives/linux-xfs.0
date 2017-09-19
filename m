Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:48594 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdISRxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 13:53:53 -0400
Received: by mail-it0-f45.google.com with SMTP id d123so352811ith.3
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 10:53:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170919173850.GA8139@dhcp-41-131.bos.redhat.com>
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster> <22a2db70-50e2-7a37-97f5-1751eafc3f7c@scylladb.com>
 <20170919173850.GA8139@dhcp-41-131.bos.redhat.com>
From: Tomasz Grabiec <tgrabiec@scylladb.com>
Date: Tue, 19 Sep 2017 19:53:52 +0200
Message-ID: <CAO2XSW5st7MpEAm=XEWHr_e0JHsn0yRk_q+qnj14N=GuTR0hJg@mail.gmail.com>
Subject: Re: io_submit() blocks for writes for substantial amount of time
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 7:38 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Tue, Sep 19, 2017 at 07:29:18PM +0300, Avi Kivity wrote:
>>
>>
>> On 09/19/2017 03:27 PM, Brian Foster wrote:
>> > On Tue, Sep 19, 2017 at 10:50:51AM +0200, Tomasz Grabiec wrote:
>> > > Hi,
>> > >
>> > > On some systems we are seeing one of our tests to trigger io_submit()
>> > > calls to block when submitting writes for an order of 100ms [1]. This
>> > > is problematic, because we heavily rely on io_submit() being async.
>> > >
>> > > Workload: open, (ftruncate, append*)*, close.
>> > >
>> > > Kernel version: 4.12.9-300.fc26.x86_64
>> > > mount: /dev/nvme0n1p3 on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
>> > >
>> > > The blocking happens in the following places:
>> > >
>> > > (1)
>> > >
>> > >              7fff9287472f __schedule ([kernel.kallsyms])
>> > >              7fff92874d16 schedule ([kernel.kallsyms])
>> > >              7fff92878d42 schedule_timeout ([kernel.kallsyms])
>> > >              7fff92876478 wait_for_completion ([kernel.kallsyms])
>> > >              7fffc05bf231 xfs_buf_submit_wait ([kernel.kallsyms])
>> > >              7fffc05bf3d3 _xfs_buf_read ([kernel.kallsyms])
>> > >              7fffc05bf4e4 xfs_buf_read_map ([kernel.kallsyms])
>> > >              7fffc05f53ca xfs_trans_read_buf_map ([kernel.kallsyms])
>> > >              7fffc058b432 xfs_btree_read_buf_block.constprop.34
>> > > ([kernel.kallsyms])
>> > >              7fffc058b504 xfs_btree_lookup_get_block ([kernel.kallsyms])
>> > >              7fffc058f6ad xfs_btree_lookup ([kernel.kallsyms])
>> > >              7fffc0570919 xfs_alloc_lookup_eq ([kernel.kallsyms])
>> > >              7fffc0570c59 xfs_alloc_fixup_trees ([kernel.kallsyms])
>> > >              7fffc0573a2d xfs_alloc_ag_vextent_near ([kernel.kallsyms])
>> > >              7fffc0573db1 xfs_alloc_ag_vextent ([kernel.kallsyms])
>> > >              7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
>> > >              7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
>> > >              7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
>> > >              7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
>> > >              7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
>> > >              7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
>> > >              7fff922d46ca iomap_apply ([kernel.kallsyms])
>> > >              7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
>> > >              7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
>> > >              7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
>> > >              7fff922bc5d3 aio_write ([kernel.kallsyms])
>> > >              7fff922bcec1 do_io_submit ([kernel.kallsyms])
>> > >              7fff922bdd40 sys_io_submit ([kernel.kallsyms])
>> > >              7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
>> > >                       687 io_submit (/usr/lib64/libaio.so.1.0.1)
>> > >                    112373 seastar::reactor::flush_pending_aio
>> > > (/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)
>> > So you have a direct I/O write that requires block allocation. Block
>> > allocation requires reading free space btree blocks to identify and fix
>> > up remaining free extent records based on the allocation.
>>
>> Will an fallocate() call before the write in another thread help?
>>
>
> Preallocating the file (or largish ranges) should help. I'm not sure
> preallocating the range of each and every write will have the behavior
> you want.
>
>> Will a write to a previously fallocate()d extent get blocked while
>> fallocate()ing a new extent?
>>
>
> Any dio can most likely block behind an fallocate call due to locking
> (just like any write that requires allocation can block behind another
> such write).
>
>> >
>> > > (2)
>> > >
>> > >    7fff9287472f __schedule ([kernel.kallsyms])
>> > >              7fff92874d16 schedule ([kernel.kallsyms])
>> > >              7fffc05e6265 _xfs_log_force ([kernel.kallsyms])
>> > >              7fffc05c2518 xfs_extent_busy_flush ([kernel.kallsyms])
>> > >              7fffc0572ccd xfs_alloc_ag_vextent_size ([kernel.kallsyms])
>> > >              7fffc0573d91 xfs_alloc_ag_vextent ([kernel.kallsyms])
>> > >              7fffc05749cb xfs_alloc_vextent ([kernel.kallsyms])
>> > >              7fffc0585ba8 xfs_bmap_btalloc ([kernel.kallsyms])
>> > >              7fffc058605e xfs_bmap_alloc ([kernel.kallsyms])
>> > >              7fffc0586d6d xfs_bmapi_write ([kernel.kallsyms])
>> > >              7fffc05cedd1 xfs_iomap_write_direct ([kernel.kallsyms])
>> > >              7fffc05cf0ec xfs_file_iomap_begin ([kernel.kallsyms])
>> > >              7fff922d46ca iomap_apply ([kernel.kallsyms])
>> > >              7fff922d4dfb iomap_dio_rw ([kernel.kallsyms])
>> > >              7fffc05c4091 xfs_file_dio_aio_write ([kernel.kallsyms])
>> > >              7fffc05c456d xfs_file_write_iter ([kernel.kallsyms])
>> > >              7fff922bc5d3 aio_write ([kernel.kallsyms])
>> > >              7fff922bcec1 do_io_submit ([kernel.kallsyms])
>> > >              7fff922bdd40 sys_io_submit ([kernel.kallsyms])
>> > >              7fff9287a6b7 entry_SYSCALL_64_fastpath ([kernel.kallsyms])
>> > >                       687 io_submit (/usr/lib64/libaio.so.1.0.1)
>> > >                    112373 seastar::reactor::flush_pending_aio
>> > > (/home/tgrabiec/src/scylla/build/release/tests/perf/perf_fast_forward_g)
>> > >
>> > Another dio write that requires allocation. The allocation finds a busy
>> > extent, which means the extent was recently freed but the associated
>> > freeing transaction has not yet made it to the on-disk log. As such it
>> > cannot be safely reused, so the allocator flushes the log and retries to
>> > try and clear the busy state and find an extent.
>>
>> Is that because the disk is nearly full and there are no known flushed
>> extents, or because the allocator doesn't prioritize known-flushed extents?
>> From your comments below I gather you may not know for sure.
>>
>
> I'm not sure without digging further into it. Hence the question around
> free space availability.

The file system was utilized between 90% and 95% out of 165GB during the test.
