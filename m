Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45932 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbeK3Ojs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 09:39:48 -0500
Received: by mail-qt1-f193.google.com with SMTP id e5so4491449qtr.12
        for <linux-xfs@vger.kernel.org>; Thu, 29 Nov 2018 19:31:57 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard> <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard>
In-Reply-To: <20181130021840.GV6311@dastard>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Thu, 29 Nov 2018 19:31:44 -0800
Message-ID: <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on xfs_reclaim_inodes_ag()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Thu, Nov 29, 2018 at 6:18 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Nov 29, 2018 at 02:22:53PM -0800, Ivan Babrou wrote:
> > On Wed, Nov 28, 2018 at 6:18 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Wed, Nov 28, 2018 at 04:36:25PM -0800, Ivan Babrou wrote:
> > > > Hello,
> > > >
> > > > We're experiencing some interesting issues with memory reclaim, both
> > > > kswapd and direct reclaim.
> > > >
> > > > A typical machine is 2 x NUMA with 128GB of RAM and 6 XFS filesystems.
> > > > Page cache is around 95GB and dirty pages hover around 50MB, rarely
> > > > jumping up to 1GB.
> > >
> > > What is your workload?
> >
> > My test setup is an empty machine with 256GB of RAM booted from
> > network into memory with just systemd essentials running.
>
> What is your root filesystem?

It's whatever initramfs unpacks into, there is no storage involved:

rootfs / rootfs rw,size=131930052k,nr_inodes=32982513 0 0

> > I create XFS on a 10TB drive (via LUKS), mount the drive and write
> > 300GiB of randomness:
> >
> > $ sudo mkfs.xfs /dev/mapper/luks-sda
> > $ sudo mount /dev/mapper/luks-sda /mnt
> > $ sudo dd if=/dev/urandom of=/mnt/300g.random bs=1M count=300K status=progress
> >
> > Then I reboot and just mount the drive again to run my test workload:
> >
> > $ dd if=/mnt/300g.random of=/dev/null bs=1M status=progress
> >
> > After running it once and populating page cache I restart it to collect traces.
>
> This isn't your production workload that is demonstrating problems -
> it's your interpretation of the problem based on how you think
> everything should work.

This is the simplest workload that exhibits the issue. My production
workload is similar: serve most of the data from page cache,
occasionally write some data on disk.

To make it more real in terms of how I think things work, let's add a
bit more fun with the following systemtap script:

$ cat derp.stap
%{
/* guru */
#undef STP_OVERLOAD
#include <linux/delay.h>
%}

function mdelay(ms:long) %{
  /* guru */
  mdelay(STAP_ARG_ms);
%}

probe kernel.function("xfs_bwrite").return {
  mdelay(30000)
}

This simulates very slow disk writes by making xfs_bwrite 30s longer.
We only ever write to one empty file, so there's no need to be very
selective.

I load the script above, fire up dd to fill up page cache and run my
touch command. This is what happens in dmesg:

Nov 30 03:15:31 myhost kernel: INFO: task kswapd1:1863 blocked for
more than 2 seconds.
Nov 30 03:15:31 myhost kernel:       Tainted: G           O
4.14.74-cloudflare-2018.10.1 #1
Nov 30 03:15:31 myhost kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 30 03:15:31 myhost kernel: kswapd1         D13856  1863      2 0x80000000
Nov 30 03:15:31 myhost kernel: Call Trace:
Nov 30 03:15:31 myhost kernel:  ? __schedule+0x21e/0x7f0
Nov 30 03:15:31 myhost kernel:  schedule+0x28/0x80
Nov 30 03:15:31 myhost kernel:  schedule_preempt_disabled+0xa/0x10
Nov 30 03:15:31 myhost kernel:  __mutex_lock.isra.3+0x2a8/0x490
Nov 30 03:15:31 myhost kernel:  ? xfs_perag_get_tag+0x2d/0xc0
Nov 30 03:15:31 myhost kernel:  xfs_reclaim_inodes_ag+0x27d/0x2c0
Nov 30 03:15:31 myhost kernel:  ? free_hot_cold_page_list+0x3e/0xa0
Nov 30 03:15:31 myhost kernel:  ? shrink_page_list+0x42c/0xb30
Nov 30 03:15:31 myhost kernel:  ? radix_tree_gang_lookup_tag+0xc3/0x140
Nov 30 03:15:31 myhost kernel:  ? __list_lru_walk_one.isra.7+0x33/0x140
Nov 30 03:15:31 myhost kernel:  xfs_reclaim_inodes_nr+0x31/0x40
Nov 30 03:15:31 myhost kernel:  super_cache_scan+0x152/0x1a0
Nov 30 03:15:31 myhost kernel:  shrink_slab.part.45+0x1d3/0x380
Nov 30 03:15:31 myhost kernel:  shrink_node+0x116/0x300
Nov 30 03:15:31 myhost kernel:  kswapd+0x3af/0x6b0
Nov 30 03:15:31 myhost kernel:  ? mem_cgroup_shrink_node+0x150/0x150
Nov 30 03:15:31 myhost kernel:  kthread+0x119/0x130
Nov 30 03:15:31 myhost kernel:  ? kthread_create_on_node+0x40/0x40
Nov 30 03:15:31 myhost kernel:  ret_from_fork+0x35/0x40
Nov 30 03:15:31 myhost kernel: INFO: task dd:15663 blocked for more
than 2 seconds.
Nov 30 03:15:31 myhost kernel:       Tainted: G           O
4.14.74-cloudflare-2018.10.1 #1
Nov 30 03:15:31 myhost kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 30 03:15:31 myhost kernel: dd              D13952 15663  13243 0x00000000
Nov 30 03:15:31 myhost kernel: Call Trace:
Nov 30 03:15:31 myhost kernel:  ? __schedule+0x21e/0x7f0
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x34/0x70
Nov 30 03:15:31 myhost kernel:  schedule+0x28/0x80
Nov 30 03:15:31 myhost kernel:  schedule_timeout+0x268/0x340
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x34/0x70
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x40/0x70
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x40/0x70
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x34/0x70
Nov 30 03:15:31 myhost kernel:  wait_for_completion+0x97/0x100
Nov 30 03:15:31 myhost kernel:  ? wake_up_q+0x70/0x70
Nov 30 03:15:31 myhost kernel:  flush_work+0xfc/0x190
Nov 30 03:15:31 myhost kernel:  ? flush_workqueue_prep_pwqs+0x130/0x130
Nov 30 03:15:31 myhost kernel:  drain_all_pages+0x140/0x190
Nov 30 03:15:31 myhost kernel:  __alloc_pages_slowpath+0x41b/0xd50
Nov 30 03:15:31 myhost kernel:  ? blk_peek_request+0x62/0x280
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x40/0x70
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x34/0x70
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x40/0x70
Nov 30 03:15:31 myhost kernel:  __alloc_pages_nodemask+0x235/0x250
Nov 30 03:15:31 myhost kernel:  __do_page_cache_readahead+0xcd/0x210
Nov 30 03:15:31 myhost kernel:  ? __switch_to_asm+0x34/0x70
Nov 30 03:15:31 myhost kernel:  ondemand_readahead+0x1f9/0x2c0
Nov 30 03:15:31 myhost kernel:  generic_file_read_iter+0x6c1/0x9c0
Nov 30 03:15:31 myhost kernel:  ? page_cache_tree_insert+0x90/0x90
Nov 30 03:15:31 myhost kernel:  xfs_file_buffered_aio_read+0x47/0xe0
Nov 30 03:15:31 myhost kernel:  xfs_file_read_iter+0x5e/0xb0
Nov 30 03:15:31 myhost kernel:  __vfs_read+0xee/0x130
Nov 30 03:15:31 myhost kernel:  vfs_read+0x8a/0x140
Nov 30 03:15:31 myhost kernel:  SyS_read+0x3f/0xa0
Nov 30 03:15:31 myhost kernel:  do_syscall_64+0x60/0xf0
Nov 30 03:15:31 myhost kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
Nov 30 03:15:31 myhost kernel: RIP: 0033:0x7f8d9264e6d0
Nov 30 03:15:31 myhost kernel: RSP: 002b:00007ffdf8842998 EFLAGS:
00000246 ORIG_RAX: 0000000000000000
Nov 30 03:15:31 myhost kernel: RAX: ffffffffffffffda RBX:
0000562ac05b2400 RCX: 00007f8d9264e6d0
Nov 30 03:15:31 myhost kernel: RDX: 0000000000100000 RSI:
00007f8d92a2a000 RDI: 0000000000000000
Nov 30 03:15:31 myhost kernel: RBP: 0000000000100000 R08:
0035153337c601da R09: 00007ffdf8888080
Nov 30 03:15:31 myhost kernel: R10: 0000000000a7aa68 R11:
0000000000000246 R12: 00007f8d92a2a000
Nov 30 03:15:31 myhost kernel: R13: 0000000000000000 R14:
0000000000000000 R15: 0000000000000000

The way I read this: kswapd got stuck behind one stalled io, that
triggered later direct reclaim from dd, which also got stuck.

250GB of page cache to reclaim and yet one unlucky write made
everything sad. Stack trace is somewhat different, but it illustrates
the idea of one write blocking reclaim.

> I need to know what the workload is so I can reproduce and observe a
> the latency problems myself. I do have some clue abou thow this is
> all supposed to work, and I have abunch of workloads that are known
> to trigger severe memory-reclaim based IO breakdowns if memory
> reclaim doesn't balance and throttle appropriately.

I believe that you do have a clue and workloads. The problem is: those
workloads are not mine.

> > Here's xfs_info:
> >
> > $ sudo xfs_info /mnt
> > meta-data=/dev/mapper/luks-sda   isize=512    agcount=10, agsize=268435455 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=2441608704, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=521728, version=2
>
> You've got a maximally sized log (2GB), so there's basically no bound on
> dirty metadata in the filesystem.

I didn't do anything special, mkfs,xfs picked all the values for me.

> > $ sudo cat /proc/slabinfo
> ....
> > slabinfo - version: 2.1
> > # name            <active_objs> <num_objs> <objsize> <objperslab>
> > xfs_ili              144    144    168   48    2 : tunables    0    0
> > xfs_inode            170    170    960   34    8 : tunables    0    0
> > xfs_efd_item           0      0    416   39    4 : tunables    0    0
> > xfs_buf_item         132    132    248   33    2 : tunables    0    0
> > xfs_da_state           0      0    480   34    4 : tunables    0    0
> > xfs_btree_cur        420    420    232   35    2 : tunables    0    0
> > xfs_log_ticket       308    308    184   44    2 : tunables    0    0
>
> That doesn't add up to a single XFS filesystem with 2 inodes in it.
> where are the other 168 cached XFS inodes coming from? And I note
> that 144 of them are currently or have been previously dirtied, too.

I don't know about this, my only guess that some of my previous tests
with touch created those.

> > The following can easily happen (correct me if it can't for some reason):
> >
> > 1. kswapd gets stuck because of slow storage and memory is not getting reclaimed
> > 2. memory allocation doesn't have any free pages and kicks in direct reclaim
> > 3. direct reclaim is stuck behind kswapd
> >
> > I'm not sure why you say direct reclaim happens first, allocstall is zero.
>
> Because I thought we were talking about your production workload
> that you pasted stack traces from showing direct reclaim blocking.
> When you have a highly concurrent workload which has tens to
> hundreds of processes all producing memory pressure, dirtying files
> and page cache, etc, direct reclaim is almost always occurring.
>
> i.e. your artificial test workload doesn't tell me anything about
> the problems you are seeing on your production systems....
>
> > > > My gut feeling is that
> > > > they should not do that, because there's already writeback mechanism
> > > > with own tunables for limits to take care of that. If a system runs
> > > > out of memory reclaimable without IO and dirty pages are under limit,
> > > > it's totally fair to OOM somebody.
> > > >
> > > > It's totally possible that I'm wrong about this feeling, but either
> > > > way I think docs need an update on this matter:
> > > >
> > > > * https://elixir.bootlin.com/linux/v4.14.55/source/Documentation/filesystems/vfs.txt
> > > >
> > > >   nr_cached_objects: called by the sb cache shrinking function for the
> > > >   filesystem to return the number of freeable cached objects it contains.
> > >
> > > You are assuming that "freeable" means "instantly freeable object",
> > > not "unreferenced object that can be freed in the near future". We
> > > use the latter definition in the shrinkers, not the former.
> >
> > I'm only assuming things because documentation leaves room for
> > interpretation. I would love to this worded in a way that's crystal
> > clear and mentions possibility of IO.
>
> Send a patch. I wrote that years ago when all the people reviewing
> the changes understood what "freeable" meant in the shrinker context.

Would you be happy with this patch?

diff --git a/Documentation/filesystems/vfs.txt
b/Documentation/filesystems/vfs.txt
index 5fd325df59e2..297400842152 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -301,6 +301,7 @@ or bottom half).

   nr_cached_objects: called by the sb cache shrinking function for the
        filesystem to return the number of freeable cached objects it contains.
+       Freeable objects may include dirty ones requiring write IO to be freed.
        Optional.

   free_cache_objects: called by the sb cache shrinking function for the
@@ -319,6 +320,8 @@ or bottom half).
        implementations will cause holdoff problems due to large scan batch
        sizes.

+       Implementations may issue write IO to free objects.
+
 Whoever sets up the inode is responsible for filling in the "i_op" field. This
 is a pointer to a "struct inode_operations" which describes the methods that
 can be performed on individual inodes.


> > > > My second question is conditional on the first one: if filesystems are
> > > > supposed to flush dirty data in response to shrinkers, then how can I
> > > > stop this, given my knowledge about combination of lots of available
> > > > page cache and terrible disks?
> > >
> > > Filesystems have more caches that just the page cache.
> > >
> > > > I've tried two things to address this problem ad-hoc.
> > > >
> > > > 1. Run the following systemtap script to trick shrinkers into thinking
> > > > that XFS has nothing to free:
> > > >
> > > > probe kernel.function("xfs_fs_nr_cached_objects").return {
> > > >   $return = 0
> > > > }
> > > >
> > > > That did the job and shrink_node latency dropped considerably, while
> > > > calls to xfs_fs_free_cached_objects disappeared.
> > >
> > > Which effectively turned off direct reclaim for XFS inodes. See
> > > above - this just means that when you have no easily reclaimable
> > > page cache the system will OOM kill rather than wait for inodes to
> > > be reclaimed. i.e. it looks good until everything suddenly goes
> > > wrong and then everything dies a horrible death.
> >
> > We have hundreds of gigabytes of page cache, dirty pages are not
> > allowed to go near that mark. There's a separate limit for dirty data.
>
> Well, yes, but we're not talking about dirty data here - I'm
> talking about what happens when we turn off reclaim for a cache
> that can grow without bound.  I can only say "this is a bad idea in
> general because...." as I have to make the code work for lots of
> different workloads.
>
> So while it might be a solution work for your specific workload -
> which I know nothing about because you haven't described it to me -
> it's not a solution we can use for the general case.

Facebook is still running with their patch that does async reclaim, so
my workload is not that special.

> > What I want to have is a way to tell the kernel to not try to flush
> > data to disk in response to reclaim, because that's choosing a very
> > real horrible life over imaginary horrible death.  I can't possibly
> > create enough dirty inodes to cause the horrible death you describe.
>
> Sure you can. Just keep filling memory with dirty inodes until the
> log runs out of space. With disks that are as slow as you say, the
> system will take hours to recover log space and return to decent
> steady state performance, if it ever manages to catch up at all.

Slow is a broad definition. Disks may sometimes get stuck for some IO,
but overall they are very much capable of keeping up with background
writes.

I mentioned that we typically have ~50MB of dirty pages and very low
write demand.

Shouldn't dirty inodes also be accounted as dirty pages?

> And this deomnstrates the fact that there can be many causes of the
> symptoms you are describing.  But without a description of the
> production workload that is demonstrating problems, I cannot
> reproduce it, do any root cause analysis, or even validate that your
> analysis is correct.
>
> So, please, rather than tell me what you think the problem is and
> how it should be fixed, frist describe the workload that is causing
> problems in enough detail that I can reproduce it myself.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
