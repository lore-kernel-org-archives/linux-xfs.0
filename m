Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33619 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933746AbdC3Nso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 09:48:44 -0400
MIME-Version: 1.0
In-Reply-To: <20170330112126.GE1972@dhcp22.suse.cz>
References: <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz> <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz> <20170329105536.GH27994@dhcp22.suse.cz>
 <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
 <20170329111650.GI27994@dhcp22.suse.cz> <CAOi1vP_6HvHAGo4Neu=q_LY_m_NRmSRkkGsW=95xYctLUdag6A@mail.gmail.com>
 <20170330062500.GB1972@dhcp22.suse.cz> <CAOi1vP8z4hngZecp6MoOOhKsLadZ5eJbQ92MvAGBbqdN03CfPw@mail.gmail.com>
 <20170330112126.GE1972@dhcp22.suse.cz>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 30 Mar 2017 15:48:42 +0200
Message-ID: <CAOi1vP9Mdk+meGj39+wccBa6HN07y-pDxMLJj_xmAYBsRSoy1g@mail.gmail.com>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 30, 2017 at 1:21 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Thu 30-03-17 12:02:03, Ilya Dryomov wrote:
>> On Thu, Mar 30, 2017 at 8:25 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> > On Wed 29-03-17 16:25:18, Ilya Dryomov wrote:
> [...]
>> >> We got rid of osdc->request_mutex in 4.7, so these workers are almost
>> >> independent in newer kernels and should be able to free up memory for
>> >> those blocked on GFP_NOIO retries with their respective con->mutex
>> >> held.  Using GFP_KERNEL and thus allowing the recursion is just asking
>> >> for an AA deadlock on con->mutex OTOH, so it does make a difference.
>> >
>> > You keep saying this but so far I haven't heard how the AA deadlock is
>> > possible. Both GFP_KERNEL and GFP_NOIO can stall for an unbounded amount
>> > of time and that would cause you problems AFAIU.
>>
>> Suppose we have an I/O for OSD X, which means it's got to go through
>> ceph_connection X:
>>
>> ceph_con_workfn
>>   mutex_lock(&con->mutex)
>>     try_write
>>       ceph_tcp_connect
>>         sock_create_kern
>>           GFP_KERNEL allocation
>>
>> Suppose that generates another I/O for OSD X and blocks on it.
>
> Yeah, I have understand that but I am asking _who_ is going to generate
> that IO. We do not do writeback from the direct reclaim path. I am not

It doesn't have to be a newly issued I/O, it could also be a wait on
something that depends on another I/O to OSD X, but I can't back this
up with any actual stack traces because the ones we have are too old.

That's just one scenario though.  With such recursion allowed, we can
just as easily deadlock in the filesystem.  Here is a couple of traces
circa 4.8, where it's the mutex in xfs_reclaim_inodes_ag():

cc1             D ffff92243fad8180     0  6772   6770 0x00000080
ffff9224d107b200 ffff922438de2f40 ffff922e8304fed8 ffff9224d107b200
ffff922ea7554000 ffff923034fb0618 0000000000000000 ffff9224d107b200
ffff9230368e5400 ffff92303788b000 ffffffff951eb4e1 0000003e00095bc0
Nov 28 18:21:23 dude kernel: Call Trace:
[<ffffffff951eb4e1>] ? schedule+0x31/0x80
[<ffffffffc0ab0570>] ? _xfs_log_force_lsn+0x1b0/0x340 [xfs]
[<ffffffff94ca5790>] ? wake_up_q+0x60/0x60
[<ffffffffc0a9f7ff>] ? __xfs_iunpin_wait+0x9f/0x160 [xfs]
[<ffffffffc0ab0730>] ? xfs_log_force_lsn+0x30/0xb0 [xfs]
[<ffffffffc0a97041>] ? xfs_reclaim_inode+0x131/0x370 [xfs]
[<ffffffffc0a9f7ff>] ? __xfs_iunpin_wait+0x9f/0x160 [xfs]
[<ffffffff94cbcf80>] ? autoremove_wake_function+0x40/0x40
[<ffffffffc0a97041>] ? xfs_reclaim_inode+0x131/0x370 [xfs]
[<ffffffffc0a97442>] ? xfs_reclaim_inodes_ag+0x1c2/0x2d0 [xfs]
[<ffffffff94cb197c>] ? enqueue_task_fair+0x5c/0x920
[<ffffffff94c35895>] ? sched_clock+0x5/0x10
[<ffffffff94ca47e0>] ? check_preempt_curr+0x50/0x90
[<ffffffff94ca4834>] ? ttwu_do_wakeup+0x14/0xe0
[<ffffffff94ca53c3>] ? try_to_wake_up+0x53/0x3a0
[<ffffffffc0a98331>] ? xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[<ffffffff94e05bfe>] ? super_cache_scan+0x17e/0x190
[<ffffffff94d919f3>] ? shrink_slab.part.38+0x1e3/0x3d0
[<ffffffff94d9616a>] ? shrink_node+0x10a/0x320
[<ffffffff94d96474>] ? do_try_to_free_pages+0xf4/0x350
[<ffffffff94d967ba>] ? try_to_free_pages+0xea/0x1b0
[<ffffffff94d863bd>] ? __alloc_pages_nodemask+0x61d/0xe60
[<ffffffff94dd918a>] ? alloc_pages_vma+0xba/0x280
[<ffffffff94db0f8b>] ? wp_page_copy+0x45b/0x6c0
[<ffffffff94db3e12>] ? alloc_set_pte+0x2e2/0x5f0
[<ffffffff94db2169>] ? do_wp_page+0x4a9/0x7e0
[<ffffffff94db4bd2>] ? handle_mm_fault+0x872/0x1250
[<ffffffff94c65a53>] ? __do_page_fault+0x1e3/0x500
[<ffffffff951f0cd8>] ? page_fault+0x28/0x30

kworker/9:3     D ffff92303f318180     0 20732      2 0x00000080
Workqueue: ceph-msgr ceph_con_workfn [libceph]
 ffff923035dd4480 ffff923038f8a0c0 0000000000000001 000000009eb27318
 ffff92269eb28000 ffff92269eb27338 ffff923036b145ac ffff923035dd4480
 00000000ffffffff ffff923036b145b0 ffffffff951eb4e1 ffff923036b145a8
Call Trace:
 [<ffffffff951eb4e1>] ? schedule+0x31/0x80
 [<ffffffff951eb77a>] ? schedule_preempt_disabled+0xa/0x10
 [<ffffffff951ed1f4>] ? __mutex_lock_slowpath+0xb4/0x130
 [<ffffffff951ed28b>] ? mutex_lock+0x1b/0x30
 [<ffffffffc0a974b3>] ? xfs_reclaim_inodes_ag+0x233/0x2d0 [xfs]
 [<ffffffff94d92ba5>] ? move_active_pages_to_lru+0x125/0x270
 [<ffffffff94f2b985>] ? radix_tree_gang_lookup_tag+0xc5/0x1c0
 [<ffffffff94dad0f3>] ? __list_lru_walk_one.isra.3+0x33/0x120
 [<ffffffffc0a98331>] ? xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
 [<ffffffff94e05bfe>] ? super_cache_scan+0x17e/0x190
 [<ffffffff94d919f3>] ? shrink_slab.part.38+0x1e3/0x3d0
 [<ffffffff94d9616a>] ? shrink_node+0x10a/0x320
 [<ffffffff94d96474>] ? do_try_to_free_pages+0xf4/0x350
 [<ffffffff94d967ba>] ? try_to_free_pages+0xea/0x1b0
 [<ffffffff94d863bd>] ? __alloc_pages_nodemask+0x61d/0xe60
 [<ffffffff94ddf42d>] ? cache_grow_begin+0x9d/0x560
 [<ffffffff94ddfb88>] ? fallback_alloc+0x148/0x1c0
 [<ffffffff94de09db>] ? __kmalloc+0x1eb/0x580
# a buggy ceph_connection worker doing a GFP_KERNEL allocation

xz              D ffff92303f358180     0  5932   5928 0x00000084
 ffff921a56201180 ffff923038f8ae00 ffff92303788b2c8 0000000000000001
 ffff921e90234000 ffff921e90233820 ffff923036b14eac ffff921a56201180
 00000000ffffffff ffff923036b14eb0 ffffffff951eb4e1 ffff923036b14ea8
Call Trace:
 [<ffffffff951eb4e1>] ? schedule+0x31/0x80
 [<ffffffff951eb77a>] ? schedule_preempt_disabled+0xa/0x10
 [<ffffffff951ed1f4>] ? __mutex_lock_slowpath+0xb4/0x130
 [<ffffffff951ed28b>] ? mutex_lock+0x1b/0x30
 [<ffffffffc0a974b3>] ? xfs_reclaim_inodes_ag+0x233/0x2d0 [xfs]
 [<ffffffff94f2b985>] ? radix_tree_gang_lookup_tag+0xc5/0x1c0
 [<ffffffff94dad0f3>] ? __list_lru_walk_one.isra.3+0x33/0x120
 [<ffffffffc0a98331>] ? xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
 [<ffffffff94e05bfe>] ? super_cache_scan+0x17e/0x190
 [<ffffffff94d919f3>] ? shrink_slab.part.38+0x1e3/0x3d0
 [<ffffffff94d9616a>] ? shrink_node+0x10a/0x320
 [<ffffffff94d96474>] ? do_try_to_free_pages+0xf4/0x350
 [<ffffffff94d967ba>] ? try_to_free_pages+0xea/0x1b0
 [<ffffffff94d863bd>] ? __alloc_pages_nodemask+0x61d/0xe60
 [<ffffffff94dd73b1>] ? alloc_pages_current+0x91/0x140
 [<ffffffff94e0ab98>] ? pipe_write+0x208/0x3f0
 [<ffffffff94e01b08>] ? new_sync_write+0xd8/0x130
 [<ffffffff94e02293>] ? vfs_write+0xb3/0x1a0
 [<ffffffff94e03672>] ? SyS_write+0x52/0xc0
 [<ffffffff94c03b8a>] ? do_syscall_64+0x7a/0xd0
 [<ffffffff951ef9a5>] ? entry_SYSCALL64_slow_path+0x25/0x25

We have since fixed that allocation site, but the point is it was
a combination of direct reclaim and GFP_KERNEL recursion.

> familiar with Ceph at all but does any of its (slab) shrinkers generate
> IO to recurse back?

We don't register any custom shrinkers.  This is XFS on top of rbd,
a ceph-backed block device.

>
>> Well,
>> it's got to go through the same ceph_connection:
>>
>> rbd_queue_workfn
>>   ceph_osdc_start_request
>>     ceph_con_send
>>       mutex_lock(&con->mutex)  # deadlock, OSD X worker is knocked out
>>
>> Now if that was a GFP_NOIO allocation, we would simply block in the
>> allocator.  The placement algorithm distributes objects across the OSDs
>> in a pseudo-random fashion, so even if we had a whole bunch of I/Os for
>> that OSD, some other I/Os for other OSDs would complete in the meantime
>> and free up memory.  If we are under the kind of memory pressure that
>> makes GFP_NOIO allocations block for an extended period of time, we are
>> bound to have a lot of pre-open sockets, as we would have done at least
>> some flushing by then.
>
> How is this any different from xfs waiting for its IO to be done?

I feel like we are talking past each other here.  If the worker in
question isn't deadlocked, it will eventually get its socket and start
flushing I/O.  If it has deadlocked, it won't...

Thanks,

                Ilya
