Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85F927F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 05:21:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00B46AC007
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 03:21:22 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id wVCN5uk81QjfPn4n (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 03:21:21 -0700 (PDT)
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 1FE0A3DCDF
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 12:21:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 016A43DB00
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 12:21:17 +0200 (CEST)
Date: Fri, 25 Apr 2014 03:21:16 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 3.15.0-rc2: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected
Message-ID: <alpine.DEB.2.19.4.1404250316560.6018@trent.utfs.org>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

I haven't run vanilla for a while, so this is pretty much a copy of
what I reported[0] back with 3.14-rc2, but now with 3.15-rc2. Full
dmesg & .config can be found here:

   http://nerdbynature.de/bits/3.15-rc2/


======================================================
[ INFO: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected ]
3.15.0-rc2 #1 Not tainted
------------------------------------------------------
rm/8288 [HC0[0]:SC0[0]:HE1:SE1] is trying to acquire:
 (&mm->mmap_sem){++++++}, at: [<c00b16ac>] might_fault+0x58/0xa0

and this task is already holding:
 (&xfs_dir_ilock_class){++++-.}, at: [<c020f790>] 
xfs_ilock_data_map_shared+0x28/0x70
which would create a new lock dependency:
 (&xfs_dir_ilock_class){++++-.} -> (&mm->mmap_sem){++++++}

but this new dependency connects a RECLAIM_FS-irq-safe lock:
 (&xfs_dir_ilock_class){++++-.}
... which became RECLAIM_FS-irq-safe at:
  [<c00658a4>] lock_acquire+0x54/0x70
  [<c00600f0>] down_write_nested+0x50/0xa0
  [<c01cef9c>] xfs_reclaim_inode+0x108/0x318
  [<c01cf360>] xfs_reclaim_inodes_ag+0x1b4/0x360
  [<c01cfea4>] xfs_reclaim_inodes_nr+0x38/0x4c
  [<c00d2d00>] super_cache_scan+0x150/0x158
  [<c00a2110>] shrink_slab_node+0x138/0x228
  [<c00a2874>] shrink_slab+0x124/0x13c
  [<c00a53f4>] kswapd+0x3f8/0x884
  [<c004e654>] kthread+0xbc/0xd0
  [<c0010b7c>] ret_from_kernel_thread+0x5c/0x64
to a RECLAIM_FS-irq-unsafe lock:
 (&mm->mmap_sem){++++++}
... which became RECLAIM_FS-irq-unsafe at:
...  [<c0065f94>] lockdep_trace_alloc+0x84/0x104
  [<c00cb630>] kmem_cache_alloc+0x30/0x148
  [<c00ba038>] mmap_region+0x2fc/0x578
  [<c00ba5a0>] do_mmap_pgoff+0x2ec/0x378
  [<c00aacf8>] vm_mmap_pgoff+0x58/0x94
  [<c012124c>] load_elf_binary+0x488/0x11f4
  [<c00d5b48>] search_binary_handler+0x98/0x1f4
  [<c00d6abc>] do_execve+0x484/0x580
  [<c000425c>] try_to_run_init_process+0x18/0x58
  [<c0004a5c>] kernel_init+0xac/0x110
  [<c0010b7c>] ret_from_kernel_thread+0x5c/0x64

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&mm->mmap_sem);
                               local_irq_disable();
                               lock(&xfs_dir_ilock_class);
                               lock(&mm->mmap_sem);
  <Interrupt>
    lock(&xfs_dir_ilock_class);

 *** DEADLOCK ***
2 locks held by rm/8288:
 #0:  (&type->i_mutex_dir_key#5){+.+.+.}, at: [<c00e230c>] iterate_dir+0x3c/0xd0
 #1:  (&xfs_dir_ilock_class){++++-.}, at: [<c020f790>] xfs_ilock_data_map_shared+0x28/0x70

[....]


Christian.

[0] http://oss.sgi.com/archives/xfs/2014-02/msg00362.html
-- 
BOFH excuse #354:

Chewing gum on /dev/sd3c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
