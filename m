Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33018 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfCLQPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Mar 2019 12:15:15 -0400
MIME-Version: 1.0
References: <20190215191953.GB17897@amd> <20190217084458.GY12500@redhat.com>
 <20190217231514.GA10675@amd> <20190217235151.GZ12500@redhat.com> <CAM1OiDOKJ3SGHABNooQPFfx3KMYepYmSPxwyZZjZERc_y9v1WA@mail.gmail.com>
In-Reply-To: <CAM1OiDOKJ3SGHABNooQPFfx3KMYepYmSPxwyZZjZERc_y9v1WA@mail.gmail.com>
From: Shaun McDowell <smcdowell@cloudbd.io>
Date: Tue, 12 Mar 2019 12:14:59 -0400
Message-ID: <CAM1OiDPxh0B1sXkyGCSTEpdgDd196-ftzLE-ocnM8Jd2F9w7AA@mail.gmail.com>
Subject: Re: nbd, nbdkit, loopback mounts and memory management
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, linux-xfs@vger.kernel.org

We have a good example of deadlock when using an XFS filesystem on an
nbd loopback device regardless of mlockall and MCL_FUTURE. Below I'll
paste the hung task traces but I'll try to summarize the steps that
caused the problem.

The setup is an nbd loopback device with an XFS filesystem that is
then mounted on the local server (ubuntu 18.04 bionic, kernel 4.15).
Heavy load on the server is putting the kernel in a state where it has
exhausted its free pages list and new page allocation requests will
attempt to first free allocated pages -- mm/vmscan.c
try_to_free_pages(). XFS registers a pair of functions in the
super_operations struct (nr_cached_objects and free_cached_objects)
that causes the try_to_free_pages() to perform a synchronous write of
dirty inodes to the block device -- fs/xfs/xfs_icache.c
xfs_reclaim_inodes_nr().

A resource loop deadlock can occur if the nbd userland process needs
to allocate memory to make forward progress and the allocation causes
the kernel to call try_to_free_pages() which then leads to XFS issuing
a blocking synchronous write of a dirty inode page destined back to
the nbd loopback device. A more common deadlock we see (traces below)
is when another process on the system is blocked in
try_to_free_pages() waiting for the nbd device to perform the
synchronous write and then the nbd userland process also triggers
try_to_free_pages() and blocks on a mutex waiting for the first
process to complete its synchronous write.

>From a kernel implemented device driver, which pages should not be
freed during a page allocation can be controlled using the GFP_ flags.
(GFP_NOIO, GFP_NOFS). From userland (as far as I can tell) we do not
have a way to control which pages the kernel is allowed to free in
try_to_free_pages().

Below are some traces where we have hit this deadlock. 0) A process on
the server needs to allocate a page and triggers the kernel to attempt
to free pages and XFS issues a synchronous write to the nbd loopback
device; 1) within the nbd loopback userland process, a memory
allocation request triggers a malloc arena pool to expand its heap and
call mprotect which causes the kernel to try to allocate pages and
call try_to_free_pages(), and proceed down the XFS reclaim inodes path
where it blocks trying to acquire the mutex that is held by that
process from trace 0 waiting for us to make progress; 2) an example of
another thread within the nbd userland process hitting the same
problem when attempting to write to a tcp socket and also blocking on
the XFS reclaim inodes mutex.

So far the problem has been avoided by using ext4 instead of XFS as
ext4 does not provide the super_operations struct functions
(nr_cached_objects, free_cached_objects) and does not issue writes in
the try_to_free_pages() code path.

Ideally, the nbd userland process could set a process flag to tell the
kernel to use GFP_NOIO or GFP_NOFS for its allocations to avoid this
resource deadlock.

Kernel hung tasks
0) A process somewhere on the server has triggered a syscall that
causes the kernel to attempt to free pages and eventually call
xfs_reclaim_inodes, acquire xfs inode reclaim mutex, and wait for a
write to the nbd loopback device
Mar 06 04:54:14 ip-172-16-9-203 kernel: INFO: task glfs_epoll000:4535
blocked for more than 30 seconds.
Mar 06 04:54:14 ip-172-16-9-203 kernel:       Not tainted
4.15.0-1032-aws #34-Ubuntu
Mar 06 04:54:14 ip-172-16-9-203 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 06 04:54:14 ip-172-16-9-203 kernel: glfs_epoll000   D    0  4535
   1 0x00000000
Mar 06 04:54:14 ip-172-16-9-203 kernel: Call Trace:
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __schedule+0x291/0x8a0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  schedule+0x2c/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  schedule_timeout+0x1cf/0x350
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? _xfs_buf_ioapply+0x396/0x4e0 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? radix_tree_gang_lookup+0xc6/0x110
Mar 06 04:54:14 ip-172-16-9-203 kernel:  wait_for_completion+0xba/0x140
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? wake_up_q+0x80/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? xfs_bwrite+0x24/0x60 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_buf_submit_wait+0x81/0x210 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_bwrite+0x24/0x60 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_reclaim_inode+0x31d/0x350 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_reclaim_inodes_ag+0x1e6/0x350 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? radix_tree_gang_lookup_tag+0xd9/0x160
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __list_lru_walk_one.isra.5+0x37/0x140
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? iput+0x220/0x220
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:
xfs_fs_free_cached_objects+0x19/0x20 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  super_cache_scan+0x165/0x1b0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_slab.part.51+0x1e7/0x3e0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_slab+0x29/0x30
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_node+0x11e/0x300
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_try_to_free_pages+0xc9/0x330
Mar 06 04:54:14 ip-172-16-9-203 kernel:  try_to_free_pages+0xee/0x1b0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __alloc_pages_slowpath+0x3fc/0xe20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? ena_com_prepare_tx+0x811/0xa70 [ena]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __alloc_pages_nodemask+0x263/0x280
Mar 06 04:54:14 ip-172-16-9-203 kernel:  alloc_pages_vma+0x88/0x1f0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  handle_pte_fault+0x3bf/0xd30
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __handle_mm_fault+0x478/0x5c0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  handle_mm_fault+0xb1/0x1f0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __do_page_fault+0x250/0x4d0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_page_fault+0x2e/0xe0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_async_page_fault+0x51/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  async_page_fault+0x25/0x50

The nbd loopback process attempts to allocate memory and triggers a
malloc heap to grow which in turn calls mprotect, alloc pages, try to
free, and blocks trying to acquire the xfs reclaim inodes mutex that
is held waiting on our device
Mar 06 04:54:14 ip-172-16-9-203 kernel:       Not tainted
4.15.0-1032-aws #34-Ubuntu
Mar 06 04:54:14 ip-172-16-9-203 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 06 04:54:14 ip-172-16-9-203 kernel: cbdkit          D    0  4405
4399 0x00000000
Mar 06 04:54:14 ip-172-16-9-203 kernel: Call Trace:
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __schedule+0x291/0x8a0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  schedule+0x2c/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  schedule_preempt_disabled+0xe/0x10
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __mutex_lock.isra.2+0x18c/0x4d0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __mutex_lock_slowpath+0x13/0x20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __mutex_lock_slowpath+0x13/0x20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  mutex_lock+0x2f/0x40
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_reclaim_inodes_ag+0x2ca/0x350 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? radix_tree_gang_lookup_tag+0xd9/0x160
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __list_lru_walk_one.isra.5+0x37/0x140
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? iput+0x220/0x220
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:
xfs_fs_free_cached_objects+0x19/0x20 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  super_cache_scan+0x165/0x1b0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_slab.part.51+0x1e7/0x3e0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_slab+0x29/0x30
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_node+0x11e/0x300
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_try_to_free_pages+0xc9/0x330
Mar 06 04:54:14 ip-172-16-9-203 kernel:  try_to_free_pages+0xee/0x1b0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __alloc_pages_slowpath+0x3fc/0xe20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __slab_free+0x14d/0x2c0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __slab_free+0x14d/0x2c0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __switch_to_asm+0x40/0x70
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __alloc_pages_nodemask+0x263/0x280
Mar 06 04:54:14 ip-172-16-9-203 kernel:  alloc_pages_vma+0x88/0x1f0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  handle_pte_fault+0x3bf/0xd30
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? unix_stream_read_generic+0x703/0x900
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __handle_mm_fault+0x478/0x5c0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  handle_mm_fault+0xb1/0x1f0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __get_user_pages+0x1ee/0x720
Mar 06 04:54:14 ip-172-16-9-203 kernel:  populate_vma_page_range+0x71/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  mprotect_fixup+0x29d/0x380
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_mprotect_pkey+0x1e6/0x300
Mar 06 04:54:14 ip-172-16-9-203 kernel:  SyS_mprotect+0x13/0x20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_syscall_64+0x73/0x130
Mar 06 04:54:14 ip-172-16-9-203 kernel:
entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Another thread within the nbd loopback process attempting to write to
a socket and also being blocked by the xfs reclaim inodes
Mar 06 04:54:14 ip-172-16-9-203 kernel: INFO: task cbdkit:4413 blocked
for more than 30 seconds.
Mar 06 04:54:14 ip-172-16-9-203 kernel:       Not tainted
4.15.0-1032-aws #34-Ubuntu
Mar 06 04:54:14 ip-172-16-9-203 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 06 04:54:14 ip-172-16-9-203 kernel: cbdkit          D    0  4413
4399 0x00000000
Mar 06 04:54:14 ip-172-16-9-203 kernel: Call Trace:
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __schedule+0x291/0x8a0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  schedule+0x2c/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  schedule_preempt_disabled+0xe/0x10
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __mutex_lock.isra.2+0x18c/0x4d0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __mutex_lock_slowpath+0x13/0x20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __mutex_lock_slowpath+0x13/0x20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  mutex_lock+0x2f/0x40
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_reclaim_inodes_ag+0x2ca/0x350 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? radix_tree_gang_lookup_tag+0xd9/0x160
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __list_lru_walk_one.isra.5+0x37/0x140
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? iput+0x220/0x220
Mar 06 04:54:14 ip-172-16-9-203 kernel:  xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:
xfs_fs_free_cached_objects+0x19/0x20 [xfs]
Mar 06 04:54:14 ip-172-16-9-203 kernel:  super_cache_scan+0x165/0x1b0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_slab.part.51+0x1e7/0x3e0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_slab+0x29/0x30
Mar 06 04:54:14 ip-172-16-9-203 kernel:  shrink_node+0x11e/0x300
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_try_to_free_pages+0xc9/0x330
Mar 06 04:54:14 ip-172-16-9-203 kernel:  try_to_free_pages+0xee/0x1b0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __alloc_pages_slowpath+0x3fc/0xe20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ?
__kmalloc_node_track_caller+0x227/0x2d0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __alloc_pages_nodemask+0x263/0x280
Mar 06 04:54:14 ip-172-16-9-203 kernel:  alloc_pages_current+0x6a/0xe0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  skb_page_frag_refill+0xcc/0xf0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  sk_page_frag_refill+0x1d/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  tcp_sendmsg_locked+0x24d/0xe70
Mar 06 04:54:14 ip-172-16-9-203 kernel:  tcp_sendmsg+0x2c/0x50
Mar 06 04:54:14 ip-172-16-9-203 kernel:  inet_sendmsg+0x2e/0xb0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  sock_sendmsg+0x3e/0x50
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ___sys_sendmsg+0x2a0/0x2f0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? aa_sk_perm+0x48/0x1a0
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? wake_up_q+0x44/0x80
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? futex_wake+0x8f/0x180
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? do_futex+0x300/0x500
Mar 06 04:54:14 ip-172-16-9-203 kernel:  __sys_sendmsg+0x54/0x90
Mar 06 04:54:14 ip-172-16-9-203 kernel:  ? __sys_sendmsg+0x54/0x90
Mar 06 04:54:14 ip-172-16-9-203 kernel:  SyS_sendmsg+0x12/0x20
Mar 06 04:54:14 ip-172-16-9-203 kernel:  do_syscall_64+0x73/0x130
Mar 06 04:54:14 ip-172-16-9-203 kernel:
entry_SYSCALL_64_after_hwframe+0x3d/0xa2


On Sun, Feb 17, 2019 at 8:02 PM Shaun McDowell <smcdowell@cloudbd.io> wrote:
>
> Severs we have experienced deadlocks on with nbd loopback are AWS EC2 instances that do NOT have swap (latest ubuntu trusty, xenial, bionic, and amzn1/2 images). It could be that with swap space available this is a non issue.
>
> On Sun, Feb 17, 2019 at 6:51 PM Richard W.M. Jones <rjones@redhat.com> wrote:
>>
>> On Mon, Feb 18, 2019 at 12:15:14AM +0100, Pavel Machek wrote:
>> > But Shaun reported it happened somehow often for them, so he might
>> > have a practical test case... better than my theories :-).
>>
>> Yes, certainly not saying this isn't a problem.
>>
>> I think the good news is the fix seems quite easy, ie. to add mlockall
>> and adjust the OOM killer score, as is done currently in the client:
>>
>> https://github.com/NetworkBlockDevice/nbd/blob/3969c3f81a11a483f267a55ed6665d260dc9e1d2/nbd-client.c#L867-L885
>> https://github.com/NetworkBlockDevice/nbd/blob/3969c3f81a11a483f267a55ed6665d260dc9e1d2/nbd-client.c#L1219
>>
>> For now I have added a note in the TODO file to follow up in case we
>> get a test case or reports of a problem:
>>
>> https://github.com/libguestfs/nbdkit/commit/72e0afe2e280d895f68941677fafa559ddc3bb0d
>>
>> Thanks,
>>
>> Rich.
>>
>> --
>> Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
>> Read my programming and virtualization blog: http://rwmj.wordpress.com
>> libguestfs lets you edit virtual machines.  Supports shell scripting,
>> bindings from many languages.  http://libguestfs.org
