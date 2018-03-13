Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35618 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932608AbeCMQ5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 12:57:23 -0400
MIME-Version: 1.0
In-Reply-To: <20180313042126.GB18129@dastard>
References: <CA+EzBbCtp9wKC=KeN+N1iZDa2+TsWxVho3aUkeXJXguVswkChA@mail.gmail.com>
 <20180313042126.GB18129@dastard>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Tue, 13 Mar 2018 11:57:21 -0500
Message-ID: <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

Hi Dave,

Thanks for the response. CrashMonkey assumes the following behavior of
disk cache. Let me know if any of this sounds unreasonable.

Whenever the underlying storage device has an associated cache, the IO
is marked completed the moment it reaches the disk cache. This does
not guarantee that the disk cache would persist them in the same
order, unless there is a Flush/FUA. The order of completed writes as
seen by the user could be A, B, C, *Flush* D, E. However the disk
cache could write these back to the persistent storage in the order
say B, A, C, E, D. The only invariant it ensures is that writing in an
order like  A, C, E, B, D is
not possible because, writes A,B,C have to strictly happen before D
and E. However you cannot ensure that (A, B, C) is written to the
persistent storage in the same order.

CrashMonkey reorders bios in conformance to the guarantees provided by
disk cache; we do not make any extra assumptions and we respect the
barrier operations.

On Mon, Mar 12, 2018 at 11:21 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Mar 12, 2018 at 09:15:25PM -0500, Jayashree Mohan wrote:
>> Hi,
>>
>> We've encountered what seems to be a crash consistency bug in
>> xfs(kernel 4.15) due to the interaction between delayed allocated
>> write and an unaligned fallocate(zero range) : Fallocate_zero_range is
>> not persisted even when followed by a fsync - thereby leading to a
>> loss of fsynced metadata operation on a file.
>>
>> Say we create a disk image with known data and quick format it.
>> 1. Now write 65K of data to a new file
>> 2. Zero out a part of the above file using falloc_zero_range (60K+128)
>> - (60K+128+4096) - an unaligned block
>> 3. fsync the above file
>> 4. Crash
>
> So, effectively:
>
> $ xfs_io -xft -c "pwrite 0 65k" \
>         -c "fzero $((60 * 1024 + 128)) 4k" \
>         -c fsync \
>         -c "shutdown"
>         /mnt/scratch/testfile
> $

Yes, this is the right translation of our workload.

>>
>> If we crash after the fsync, and allow reordering of the block IOs
>> between two flush/fua commands using Crashmonkey[1], then we can end
>> up not persisting the zero_range command in step 2 above, even if we
>> crashed after a fsync.
>
> Sorry, but what do you mean by "reordering of the block IOs"?

CrashMonkey reorders IOs between two barrier operations just like the
disk cache would do, while respecting the guarantees provided by disk
cache; CrashMonkey will never re order bios across barriers.

>> This workload was inspired from xfstest/generic_042, which tests for
>> stale data exposure using aligned fallocate commands. It's worth
>> noting that f2fs and btrfs passes our test clean - irrespective of the
>> order of bios, user data is intact and fzero operation is correctly persisted.
>>
>> To reproduce this bug using CrashMonkey, simply run :
>> ./c_harness -f /dev/sda -d /dev/cow_ram0 -t xfs -e 102400 -s 1000 -v
>> tests/generic_042/generic_042_fzero_unaligned.so
>>
>> and take a look at the <timestamp>-generic_042_fzero_unaligned.log
>> created in the build directory. This file has the list of block IOs
>> issued during the workload and the permutation of bios that lead to
>> this bug. You can also verify using blktrace that CrashMonkey only
>> reorders bios between two barrier operations(thereby such a crash
>> state could be encountered due to reordering blocks at the storage
>> stack). Note that tools like dm-log-writes cannot capture this bug
>> because this arises due to reordering blocks between barrier
>> operations.
>>
>> Possible reason for this bug :
>> On closely inspecting the reason for this bug, we discovered that the
>> problem lies in updating a data block twice, without a barrier
>> operation between the two updates.
>
> There's nothing wrong with doing that if the filesystem has waited
> for completion of the first IOs before doing subsequent operations
> on the block.
>
>> The blktrace for the above
>> mentioned workload shows that sector 280 is updated twice - probably
>> first due to the write and later due to the fzero operation.
>
> WHy is that happening? The trace I have from the above xfs_io
> command is this:
>
>   8,96   2      613     0.081499295  3635  Q  WS 280 + 16 [xfs_io]
>   8,96   2      617     0.081982168     0  C  WS 280 + 16 [0]
>   8,96   2      618     0.082033206  3635  Q   R 280 + 8 [xfs_io]
>   8,96   2      622     0.082420539     0  C   R 280 + 8 [0]
>   8,96   2      623     0.082475920  3635  Q   R 288 + 8 [xfs_io]
>   8,96   2      627     0.082988642     0  C   R 288 + 8 [0]
>   8,96   2      628     0.083050032  3635  Q  WS 160 + 136 [xfs_io]
>   8,96   2      632     0.084414651     0  C  WS 160 + 136 [0]
>   8,96   2      633     0.084469733  3635  Q FWFSM 20971632 + 8 [xfs_io]
>   8,96   2      636     0.107483279     0  C WFSM 20971632 + 8 [0]
>   8,96   2      637     0.107485345     0  C WFSM 20971632 [0]


1. 8,96   2      617     0.081982168     0  C  WS 280 + 16 [0]
2. 8,96   2      632     0.084414651     0  C  WS 160 + 136 [0]
3. 8,96   2      636     0.107483279     0  C WFSM 20971632 + 8 [0]

Again, though (2) is a single bio in your case, we notice that this
sequential IO updates sector 280 too. By the previous discussion about
disk cache, it is very well possible that (2) is ordered before (1),
which gives rise to the bug we mentioned.


> Which shows serialised IO dispatch and completion of the IO, and no
> double write. You've only shown queueing of writes, which doesn't
> tell me about completion order which is what really matters.
>
> In more detail.
>
> 1. zero-range forces a data flush to occur and then waits for it
> to complete.
>
> ....
>   xfs_file_fallocate
>     xfs_zero_file_space(60-68k)
>       xfs_free_file_space
>         xfs_flush_unmap_range()
>           filemap_write_and_wait_range()
> xfs_writepage:        pgoff 0xf000 size 0x10400
> xfs_writepage:        pgoff 0x10000 size 0x10400
>   8,96   2      613     0.081499295  3635  Q  WS 280 + 16 [xfs_io]
>   8,96   2      617     0.081982168     0  C  WS 280 + 16 [0]
>           truncate_pagecache_range()
> xfs_invalidatepage:   pgoff 0xf000 size 0x10400
> xfs_releasepage:      pgoff 0xf000 size 0x10400
> xfs_invalidatepage:   pgoff 0x10000 size 0x10400
> xfs_releasepage:      pgoff 0x10000 size 0x10400
>         xfs_zero_range()
>   8,96   2      618     0.082033206  3635  Q   R 280 + 8 [xfs_io]
>   8,96   2      622     0.082420539     0  C   R 280 + 8 [0]
>   8,96   2      623     0.082475920  3635  Q   R 288 + 8 [xfs_io]
>   8,96   2      627     0.082988642     0  C   R 288 + 8 [0]
>     xfs_alloc_file_space()
> xfs_map_blocks_found:   startoff 0x0 startblock 68 blockcount 0x30
>         <nothing to allocate!>
> .....
>
> After the fzero command, we then run fsync:
>
> xfs_file_fsync()
>   filemap_write_and_wait_range()
> xfs_writepage:        pgoff 0x0 size 0x10400
> ....
> xfs_writepage:        pgoff 0x10000 size 0x10400
>   8,96   2      628     0.083050032  3635  Q  WS 160 + 136 [xfs_io]
>   8,96   2      632     0.084414651     0  C  WS 160 + 136 [0]
> <data writeback complete>
>   xfs_log_force_lsn()
> xfs_buf_submit:       flags WRITE|NO_IOACCT|ASYNC|SYNCIO|FUA|FLUSH|PAGES
>   8,96   2      633     0.084469733  3635  Q FWFSM 20971632 + 8 [xfs_io]
>   8,96   2      636     0.107483279     0  C WFSM 20971632 + 8 [0]
>   8,96   2      637     0.107485345     0  C WFSM 20971632 [0]
>
> And that's the log force. That's all correct and expected behaviour
> for pwrite, fzero and fsync. And when I dump the data in the file
> after unmount/mount (because the shutdown stops all IO from the
> filesytem), I get:
>
> 000000 146715 146715 146715 146715 146715 146715 146715 146715
>
> 00f080 000000 000000 000000 000000 000000 000000 000000 000000
> *
> 010080 146715 146715 146715 146715 146715 146715 146715 146715
> *
> 010400
>
> exactly the right data in the file.
>
>> However
>> notice that there is no barrier between the two updates, and using
>> Crashmonkey we see the above mentioned bug when these two updates to
>> the same block are reordered. Essentially, a reordering here means
>> fzero goes through first, and is later overwritten by the delayed
>> allocated write.
>
>>  0.000179069  7104  Q  WS 280 + 16 [c_harness]
>>  0.000594994  7104  Q   R 280 + 8 [c_harness]
>>  0.000598216  7104  Q   R 288 + 8 [c_harness]
>>  0.000620552  7104  Q  WS 160 + 120 [c_harness]
>>  0.000653742  7104  Q  WS 280 + 16 [c_harness]
>
> So this is where there's a difference. Note the write in my case:
>
> 0.083050032  3635  Q  WS 160 + 136 [xfs_io]
>
> It's a single IO - for some reason the kernel you are running has
> split it into two IOs, but that doesn't make it wrong or invalid -
> it's not indicative of a bug in any way.
>
> What's wrong here is your assumption that you can reorder it around
> the previous IO to those blocks.  That's *simply not possible*
> because the filesystem has waited for completion of each IO before
> issuing the next. The IO serialisation is being done at the
> filesystem level, not the IO level, and so CrashMonkey is
> effectively breaking the completion ordering guarantees storage
> hardware provides us with.
>
>>  0.000733154  7104  Q FWFSM 102466 + 3 [c_harness]
>
> IOWs, once this pre-flush is completed, the data on disk is supposed
> to be that of the latter write because that one was received by the
> storage well after the first one was completed. Reordering a later
> IO in front of an already completed dependent IO (read or write!) is
> simply not allowed.

*Received by the storage* means, received at the disk cache. I agree
the fzero write went to disk cache after pwrite was marked completed.
But this does not ensure pwrite data goes to the dpersistent storage
from the disk cache before fzero.

>> This seems to be a bug, as it is not persisting the metadata operation
>> even in the presence of fsync.
>>
>> Let me know if I am missing some detail here.
>
> Filesystem IO ordering in the linux stack is not based on
> block/request level flush barriers. i.e. there's no such thing as
> "IO barriers" anymore. Filesystem IO ordering is based on a
> completion-to-dispatch serialisation model at the filesystem level,
> and that cannot be observed by looking at block layer traces....
>
> This really looks like a crashmonkey bug, not a filesystem problem...


CrashMonkey therefore respects the guarantees provided by the disk
cache, and assumes nothing more than that. I hope this provides more
clarity on what
CrashMonkey is trying to do, and why we think it is reasonable to do so.


Thanks,
Jayashree
