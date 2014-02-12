Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF5647F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 02:35:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA772304070
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 00:35:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IIk8BTBwniRyLkBJ for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 00:35:50 -0800 (PST)
Date: Wed, 12 Feb 2014 19:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212083513.GF13997@dastard>
References: <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard> <20140212063150.GD13997@dastard>
	<CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>

On Tue, Feb 11, 2014 at 10:59:58PM -0800, Linus Torvalds wrote:
> On Tue, Feb 11, 2014 at 10:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > FYI, just creating lots of files with open(O_CREAT):
> >
> > [  348.718357] fs_mark (4828) used greatest stack depth: 2968 bytes left
> > [  348.769846] fs_mark (4814) used greatest stack depth: 2312 bytes left
> > [  349.777717] fs_mark (4826) used greatest stack depth: 2280 bytes left
> > [  418.139415] fs_mark (4928) used greatest stack depth: 1936 bytes left
> > [  460.492282] fs_mark (4993) used greatest stack depth: 1336 bytes left
> > [  544.825418] fs_mark (5104) used greatest stack depth: 1112 bytes left
> > [  689.503970] fs_mark (5265) used greatest stack depth: 1000 bytes left
> >
> > We've got absolutely no spare stack space anymore in the IO path.
> > And the IO path can't get much simpler than filesystem -> virtio
> > block device.
> 
> Ugh, that's bad. A thousand bytes of stack space is much too close to
> any limits.
> 
> Do you have the stack traces for these things so that we can look at
> worst offenders?

Sure. It's almost through the XFS block allocation path where we do
metadata reads or log writes. That's always been the worst case
stack usage path for XFS. The worst path is about 4800 bytes - it
was a double btree split (inode extent map tree split, followed by a
freespace btree split when allocating a block for the extent map
btree split), triggering a reallocation of a btree block that was
pinned and STALE, which triggered a log force, which then made it's
way into the block layer.

I don't have a stack trace of that because I can't create the
initial conditions required to trigger it on demand. I've only ever
seen it in the wild once. More common, though, is the situation we
see here - somewhere around 3-4k of stack usage from a single extent
btree update operation.

We've already got a stack switch in the data allocation path - we
had to add it to stop the bdi-flusher from busting the stack with
alarming regularity in production systems. I initially made the
metadata allocation paths use it as well, but that part got reverted
(aa29284 xfs: don't defer metadata allocation to the workqueue)
because Mel Gorman demonstrated several workloads that regressed
significantly as a result of making that change.

So now we are stuck betweeen a rock and a hard place - those
metadata block allocation paths are triggering the stack overflows,
but switching stacks in the allocation path to avoid stack overflows
causes massive performance regressions....

The thing is, the XFS stack usage has not changed significantly over
the past 5 years - we keep a pretty close eye on it. The issue is
that everything around XFS has slowly been growing and I can't
point you at one stack trace that demonstrates the worst case. What
I can point you to function calls that consume a lot of stack space
and hence limit what is available to callers.

So here's a few stack fragements I've generated in teh past few
minutes on a couple of XFS filesystems inside a 16p/16GB VM by
running:

$ dd if=/dev/zero of=/mnt/test/foo bs=1024k &

which writes at about 600MB/s to a 18TB RAID array. That runs in
parallel with a multithreaded inode creation/walk/remove workload on
a different filesystem (creates 50 million inodes ~250k inode
creates/s, walks them removes them at around 170k removes/s) which
is hosted on a dm RAID0 stripe of 2 samsung 840 EVO SSDs.

mutex_lock() requires at least 1.2k of stack because of the
scheduler overhead.:

$ sudo cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (39 entries)
        -----    ----   --------
  0)     4368      64   update_group_power+0x2c/0x270
  1)     4304     384   find_busiest_group+0x10a/0x8b0
  2)     3920     288   load_balance+0x165/0x870
  3)     3632      96   idle_balance+0x106/0x1b0
  4)     3536     112   __schedule+0x7b6/0x7e0
  5)     3424      16   schedule+0x29/0x70
  6)     3408      16   schedule_preempt_disabled+0xe/0x10
  7)     3392     112   __mutex_lock_slowpath+0x11a/0x400
  8)     3280      32   mutex_lock+0x1e/0x32

i.e. any function that is going to schedule needs at least 1k of
stack, and some of the lead in  infrastructure (like
wait_for_completion) can require a total of up to 1.5k...

Basic memory allocation can easily >1k of stack without
entering reclaim:

        -----    ----   --------
  0)     4920      40   zone_statistics+0xbd/0xc0
  1)     4880     256   get_page_from_freelist+0x3a8/0x8a0
  2)     4624     256   __alloc_pages_nodemask+0x143/0x8e0
  3)     4368      80   alloc_pages_current+0xb2/0x170
  4)     4288      64   new_slab+0x265/0x2e0
  5)     4224     240   __slab_alloc+0x2fb/0x4c4
  6)     3984      80   kmem_cache_alloc+0x10b/0x140
  7)     3904      48   kmem_zone_alloc+0x77/0x100

If it enters reclaim and we are allowed to IO? Well, you saw the
stack I posted in the other thread - 4700 bytes from
kmem_cache_alloc() to the top of the stack. Another bad case is
the swap path (using a scsi device rather than virtio for the
root/swap devices):

        Depth    Size   Location    (44 entries)
        -----    ----   --------
  0)     4496      16   mempool_alloc_slab+0x15/0x20
  1)     4480     128   mempool_alloc+0x66/0x170
  2)     4352      16   scsi_sg_alloc+0x4e/0x60
  3)     4336     112   __sg_alloc_table+0x68/0x130
  4)     4224      32   scsi_init_sgtable+0x34/0x90
  5)     4192      48   scsi_init_io+0x34/0xd0
  6)     4144      32   scsi_setup_fs_cmnd+0x66/0xa0
  7)     4112     112   sd_prep_fn+0x2a0/0xce0
  8)     4000      48   blk_peek_request+0x13c/0x260
  9)     3952     112   scsi_request_fn+0x4b/0x490
 10)     3840      32   __blk_run_queue+0x37/0x50
 11)     3808      64   queue_unplugged+0x39/0xb0
 12)     3744     112   blk_flush_plug_list+0x20b/0x240
 13)     3632      80   blk_queue_bio+0x1ca/0x310
 14)     3552      48   generic_make_request+0xc0/0x110
 15)     3504      96   submit_bio+0x71/0x120
 16)     3408     160   __swap_writepage+0x184/0x220
 17)     3248      32   swap_writepage+0x42/0x90
 18)     3216     304   shrink_page_list+0x6fd/0xa20
 19)     2912     208   shrink_inactive_list+0x243/0x480
 20)     2704     288   shrink_lruvec+0x371/0x670
 21)     2416     112   do_try_to_free_pages+0x11a/0x360
 22)     2304     192   try_to_free_pages+0x110/0x190
 23)     2112     256   __alloc_pages_nodemask+0x5a2/0x8e0
 24)     1856      80   alloc_pages_current+0xb2/0x170
 25)     1776      64   new_slab+0x265/0x2e0
 26)     1712     240   __slab_alloc+0x2fb/0x4c4
 27)     1472      80   kmem_cache_alloc+0x10b/0x140
 28)     1392      48   kmem_zone_alloc+0x77/0x100

There's over 3k in the stack from kmem_zone_alloc(GFP_KERNEL) and
that's got nothing XFS in it at all - it's just memory allocation,
reclaim and Io path. And it also demonstrates that the scsi layer
has significant stack usage.

here's 2.5k from submit_bio() on virtio block device:

        Depth    Size   Location    (44 entries)
        -----    ----   --------
  0)     4512      64   update_curr+0x8b/0x160
  1)     4448      96   enqueue_task_fair+0x39d/0xd50
  2)     4352      48   enqueue_task+0x50/0x60
  3)     4304      16   activate_task+0x23/0x30
  4)     4288      32   ttwu_do_activate.constprop.84+0x3c/0x70
  5)     4256      96   try_to_wake_up+0x1b4/0x2c0
  6)     4160      16   default_wake_function+0x12/0x20
  7)     4144      32   autoremove_wake_function+0x16/0x40
  8)     4112      80   __wake_up_common+0x55/0x90
  9)     4032      64   __wake_up+0x48/0x70
 10)     3968      80   wakeup_kswapd+0xe7/0x130
 11)     3888     256   __alloc_pages_nodemask+0x371/0x8e0
 12)     3632      80   alloc_pages_current+0xb2/0x170
 13)     3552      64   new_slab+0x265/0x2e0
 14)     3488     240   __slab_alloc+0x2fb/0x4c4
 15)     3248      80   __kmalloc+0x133/0x180
 16)     3168     112   virtqueue_add_sgs+0x2fe/0x520
 17)     3056     288   __virtblk_add_req+0xd5/0x180
 18)     2768      96   virtio_queue_rq+0xdd/0x1d0
 19)     2672     112   __blk_mq_run_hw_queue+0x1c3/0x3c0
 20)     2560      16   blk_mq_run_hw_queue+0x35/0x40
 21)     2544      80   blk_mq_insert_requests+0xc5/0x120
 22)     2464      96   blk_mq_flush_plug_list+0x129/0x140
 23)     2368     112   blk_flush_plug_list+0xe7/0x240
 24)     2256     128   blk_mq_make_request+0x3ca/0x510
 25)     2128      48   generic_make_request+0xc0/0x110
 26)     2080      96   submit_bio+0x71/0x120

You can also see the difference in stack usage that the blk_mq layer
adds compared to the previous trace that went through the old
code to get to the SCSI stack.

And you saw the memory reclaim via shrinker path taht I posted in
another email - that was 4700 bytes from kmem_cache_alloc() to teh
top of the stack (can be reduced to about 2000 bytes by having XFS
chop it in half).

> If the new block-mq code is to blame, it needs to be fixed.

It's a symptom of the pattern of gradual growth in just about every
core subsystem. Each individual change is not significant, but when
you put the whole stack together the canary is well and truly dead.

> __virtblk_add_req() has a 300-byte stack frame, it seems. Looking
> elsewhere, blkdev_issue_discard() has 350 bytes of stack frame, but is
> hopefully not in any normal path - online discard is moronic, and I'm
> assuming XFS doesn't do that.

We *support* it, but we don't *recommend* it. So, no, that's not the
problem path. ;)

> There's a lot of 200+ byte stack frames in block/blk-core.s, and they
> all seem to be of the type perf_trace_block_buffer() - things created
> with DECLARE_EVENT_CLASS(), afaik. Why they all have 200+ bytes of
> frame, I have no idea. That sounds like a potential disaster too,
> although hopefully it's mostly leaf functions - but leaf functions
> *deep* in the callchain. Tejun? Steven, why _do_ they end up with such
> huge frames?

And it's leaf functions that the CONFIG_STACK_TRACER doesn't catch
on x86-64 (at least, according to the documentation).
CONFIG_DEBUG_STACK_USAGE output is showing up to 800 bytes more
stack usage than the tracer. As such, I also think that
CONFIG_DEBUG_STACK_USAGE output is a more reliable iindication of
stack usage because it is canary based and so captures the very
worst case usage of the process's stack...

It really seems to me that we have got to the point where it is not
safe to do anything like submit IO or try to do memory allocation
with any more than half the stack space consumed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
