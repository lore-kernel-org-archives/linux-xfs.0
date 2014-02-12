Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 723BD7F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 02:12:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52D17304070
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 00:12:01 -0800 (PST)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id pbemzRG0oyl44Pde for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 00:11:59 -0800 (PST)
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 982363DB33
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 09:11:56 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 704893DAF9
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 09:11:56 +0100 (CET)
Date: Wed, 12 Feb 2014 00:11:56 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 3.14-rc2: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected
Message-ID: <alpine.DEB.2.19.4.1402120008320.6233@trent.utfs.org>
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

After upgrading from 3.13-rc8 to 3.14-rc2 on this PowerPC G4 machine, this 
happened:

======================================================
[ INFO: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected ]
3.14.0-rc2 #1 Not tainted
------------------------------------------------------
rm/9206 [HC0[0]:SC0[0]:HE1:SE1] is trying to acquire:
 (&mm->mmap_sem){++++++}, at: [<c00b3654>] might_fault+0x58/0xa0

and this task is already holding:
 (&(&ip->i_lock)->mr_lock){++++-.}, at: [<c020d3ec>] 
xfs_ilock_data_map_shared+0x28/0x74
which would create a new lock dependency:
 (&(&ip->i_lock)->mr_lock){++++-.} -> (&mm->mmap_sem){++++++}

but this new dependency connects a RECLAIM_FS-irq-safe lock:
 (&(&ip->i_lock)->mr_lock){++++-.}
... which became RECLAIM_FS-irq-safe at:
  [<c0066b38>] lock_acquire+0x4c/0x68
  [<c00615fc>] down_write_nested+0x50/0x9c
  [<c01ccf50>] xfs_reclaim_inode+0x108/0x31c
  [<c01cd318>] xfs_reclaim_inodes_ag+0x1b4/0x35c
  [<c01cde40>] xfs_reclaim_inodes_nr+0x38/0x4c
  [<c00d4aec>] super_cache_scan+0x148/0x150
  [<c00a4c08>] shrink_slab_node+0x134/0x224
  [<c00a52fc>] shrink_slab+0x124/0x13c
  [<c00a7900>] kswapd+0x460/0x77c
  [<c004f8fc>] kthread+0xbc/0xd0
  [<c0010ae4>] ret_from_kernel_thread+0x5c/0x64

to a RECLAIM_FS-irq-unsafe lock:
 (&mm->mmap_sem){++++++}
... which became RECLAIM_FS-irq-unsafe at:
...  [<c00679fc>] lockdep_trace_alloc+0x84/0x104
  [<c009d86c>] __alloc_pages_nodemask+0x88/0x6b4
  [<c00161fc>] pte_alloc_one+0x30/0x90
  [<c00b3b6c>] __pte_alloc+0x20/0xf4
  [<c00bd1d4>] move_page_tables+0x2a0/0x2c4
  [<c00d7ff8>] setup_arg_pages+0x20c/0x2c8
  [<c0122804>] load_elf_binary+0x378/0x1234
  [<c00d73a0>] search_binary_handler+0x98/0x1c8
  [<c00d8aa4>] do_execve+0x484/0x574
  [<c000425c>] try_to_run_init_process+0x18/0x58
  [<c0004a48>] kernel_init+0xac/0x104
  [<c0010ae4>] ret_from_kernel_thread+0x5c/0x64
[...]

Full dmesg & .config: http://nerdbynature.de/bits/3.14-rc2/

Thanks,
Christian.
-- 
BOFH excuse #17:

fat electrons in the lines

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
