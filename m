Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35707 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbeK2LkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 06:40:06 -0500
Received: by mail-qk1-f196.google.com with SMTP id w204so112920qka.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 16:36:37 -0800 (PST)
MIME-Version: 1.0
From: Ivan Babrou <ivan@cloudflare.com>
Date: Wed, 28 Nov 2018 16:36:25 -0800
Message-ID: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
Subject: Non-blocking socket stuck for multiple seconds on xfs_reclaim_inodes_ag()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Shawn Bohrer <sbohrer@cloudflare.com>

Hello,

We're experiencing some interesting issues with memory reclaim, both
kswapd and direct reclaim.

A typical machine is 2 x NUMA with 128GB of RAM and 6 XFS filesystems.
Page cache is around 95GB and dirty pages hover around 50MB, rarely
jumping up to 1GB.

The catalyst of our issue is terrible disks. It's not uncommon to see
the following stack in hung task detector:

Nov 15 21:55:13 21m21 kernel: INFO: task some-task:156314 blocked for
more than 10 seconds.
Nov 15 21:55:13 21m21 kernel:       Tainted: G           O
4.14.59-cloudflare-2018.7.5 #1
Nov 15 21:55:13 21m21 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 15 21:55:13 21m21 kernel: some-task     D11792 156314 156183 0x00000080
Nov 15 21:55:13 21m21 kernel: Call Trace:
Nov 15 21:55:13 21m21 kernel:  ? __schedule+0x21a/0x820
Nov 15 21:55:13 21m21 kernel:  schedule+0x28/0x80
Nov 15 21:55:13 21m21 kernel:  schedule_preempt_disabled+0xa/0x10
Nov 15 21:55:13 21m21 kernel:  __mutex_lock.isra.2+0x16a/0x490
Nov 15 21:55:13 21m21 kernel:  ? xfs_reclaim_inodes_ag+0x265/0x2d0
Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_ag+0x265/0x2d0
Nov 15 21:55:13 21m21 kernel:  ? kmem_cache_alloc+0x14d/0x1b0
Nov 15 21:55:13 21m21 kernel:  ? radix_tree_gang_lookup_tag+0xc4/0x130
Nov 15 21:55:13 21m21 kernel:  ? __list_lru_walk_one.isra.5+0x33/0x130
Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_nr+0x31/0x40
Nov 15 21:55:13 21m21 kernel:  super_cache_scan+0x156/0x1a0
Nov 15 21:55:13 21m21 kernel:  shrink_slab.part.51+0x1d2/0x3a0
Nov 15 21:55:13 21m21 kernel:  shrink_node+0x113/0x2e0
Nov 15 21:55:13 21m21 kernel:  do_try_to_free_pages+0xb3/0x310
Nov 15 21:55:13 21m21 kernel:  try_to_free_pages+0xd2/0x190
Nov 15 21:55:13 21m21 kernel:  __alloc_pages_slowpath+0x3a3/0xdc0
Nov 15 21:55:13 21m21 kernel:  ? ip_output+0x5c/0xc0
Nov 15 21:55:13 21m21 kernel:  ? update_curr+0x141/0x1a0
Nov 15 21:55:13 21m21 kernel:  __alloc_pages_nodemask+0x223/0x240
Nov 15 21:55:13 21m21 kernel:  skb_page_frag_refill+0x93/0xb0
Nov 15 21:55:13 21m21 kernel:  sk_page_frag_refill+0x19/0x80
Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg_locked+0x247/0xdc0
Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg+0x27/0x40
Nov 15 21:55:13 21m21 kernel:  sock_sendmsg+0x36/0x40
Nov 15 21:55:13 21m21 kernel:  sock_write_iter+0x84/0xd0
Nov 15 21:55:13 21m21 kernel:  __vfs_write+0xdd/0x140
Nov 15 21:55:13 21m21 kernel:  vfs_write+0xad/0x1a0
Nov 15 21:55:13 21m21 kernel:  SyS_write+0x42/0x90
Nov 15 21:55:13 21m21 kernel:  do_syscall_64+0x60/0x110
Nov 15 21:55:13 21m21 kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Here "some-task" is trying to send some bytes over network and it's
stuck in direct reclaim. Naturally, kswapd is not keeping up with its
duties.

It seems to me that our terrible disks sometimes take a pause to think
about the meaning of life for a few seconds. During that time XFS
shrinker is stuck, which drives the whole system out of free memory
and in turns triggers direct reclaim.

One solution to this is to not go into direct reclaim by keeping more
free pages with vm.watermark_scale_factor,  but I'd like to discard
this and argue that we're going to hit direct reclaim at some point
anyway.

The solution I have in mind for this is not to try to write anything
to (disastrously terrible) storage in shrinkers. We have 95GB of page
cache readily available for reclaim and it seems a lot cheaper to grab
that.

That brings me to the first question around memory subsystem: are
shrinkers supposed to flush any dirty data? My gut feeling is that
they should not do that, because there's already writeback mechanism
with own tunables for limits to take care of that. If a system runs
out of memory reclaimable without IO and dirty pages are under limit,
it's totally fair to OOM somebody.

It's totally possible that I'm wrong about this feeling, but either
way I think docs need an update on this matter:

* https://elixir.bootlin.com/linux/v4.14.55/source/Documentation/filesystems/vfs.txt

  nr_cached_objects: called by the sb cache shrinking function for the
  filesystem to return the number of freeable cached objects it contains.

My second question is conditional on the first one: if filesystems are
supposed to flush dirty data in response to shrinkers, then how can I
stop this, given my knowledge about combination of lots of available
page cache and terrible disks?

I've tried two things to address this problem ad-hoc.

1. Run the following systemtap script to trick shrinkers into thinking
that XFS has nothing to free:

probe kernel.function("xfs_fs_nr_cached_objects").return {
  $return = 0
}

That did the job and shrink_node latency dropped considerably, while
calls to xfs_fs_free_cached_objects disappeared.

2. Use vm.vfs_cache_pressure to do the same thing. This failed
miserably, because of the following code in super_cache_count:

  if (sb->s_op && sb->s_op->nr_cached_objects)
    total_objects = sb->s_op->nr_cached_objects(sb, sc);

  total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
  total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);

  total_objects = vfs_pressure_ratio(total_objects);
  return total_objects;

XFS was doing its job cleaning up inodes with the background mechanims
it has (m_reclaim_workqueue), but kernel also stopped cleaning up
readily available inodes after XFS.

I'm not a kernel hacker and to be honest with you I don't even
understand all the nuances here. All I know is:

1. I have lots of page cache and terrible disks.
2. I want to reclaim page cache and never touch disks in response to
memory reclaim.
3. Direct reclaim will happen at some point, somebody will want a big
chunk of memory all at once.
4. I'm probably ok with reclaiming clean xfs inodes synchronously in
reclaim path.

This brings me to my final question: what should I do to avoid latency
in reclaim (direct or kswapd)?

To reiterate the importance of this issue: we see interactive
applications with zero IO stall for multiple seconds in writes to
non-blocking sockets and page faults on newly allocated memory, while
95GB of memory is in page cache.
