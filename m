Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272F714B081
	for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 09:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719048767; cv=none; b=ei+xIUOHCY37gaLBwjOH61EQimCDvzj/SFKfGJNC3Pqu022z4UxGCUgzZ2OU5J/RGNKKvZfew3GLuNP0sS69EQ1unar0HWPtgawAmADBUpaGdKm0qMlAw72o3tDeL31xF41o3PjD1IeuV3s3TTprF4IXJXgQh8JB7U1xoD/fVVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719048767; c=relaxed/simple;
	bh=h1WdBbLOnkXXozjJM02rpc211oa/ecSpN3jB40xaF6k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXZaIF2ElXrwdj/bYFDXheYxBoZbIQu2ioWEmerGb3I0oDNVxVStTTNTdg15Dgn7Rn8PVzK1vR25A5YidcS+7+hcixcWfWYpHybplHnZi6jqbk6lQmoF6lJGb8u1ChNAqg3dgLjtWyzoJTkGZQDgIDLrhRUgBE8JfzXb5QRH4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W5prD1y7vzdd1R;
	Sat, 22 Jun 2024 17:31:08 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 42A4418007E;
	Sat, 22 Jun 2024 17:32:40 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Sat, 22 Jun
 2024 17:32:39 +0800
Date: Sat, 22 Jun 2024 17:44:11 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>
CC: <willy@infradead.org>, <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 07/12] xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS
Message-ID: <20240622094411.GA830005@ceph-admin>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-8-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-8-david@fromorbit.com>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Tue, Jan 16, 2024 at 09:59:45AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In the past we've had problems with lockdep false positives stemming
> from inode locking occurring in memory reclaim contexts (e.g. from
> superblock shrinkers). Lockdep doesn't know that inodes access from
> above memory reclaim cannot be accessed from below memory reclaim
> (and vice versa) but there has never been a good solution to solving
> this problem with lockdep annotations.
> 
> This situation isn't unique to inode locks - buffers are also locked
> above and below memory reclaim, and we have to maintain lock
> ordering for them - and against inodes - appropriately. IOWs, the
> same code paths and locks are taken both above and below memory
> reclaim and so we always need to make sure the lock orders are
> consistent. We are spared the lockdep problems this might cause
> by the fact that semaphores and bit locks aren't covered by lockdep.
> 
> In general, this sort of lockdep false positive detection is cause
> by code that runs GFP_KERNEL memory allocation with an actively
> referenced inode locked. When it is run from a transaction, memory
> allocation is automatically GFP_NOFS, so we don't have reclaim
> recursion issues. So in the places where we do memory allocation
> with inodes locked outside of a transaction, we have explicitly set
> them to use GFP_NOFS allocations to prevent lockdep false positives
> from being reported if the allocation dips into direct memory
> reclaim.
> 
> More recently, __GFP_NOLOCKDEP was added to the memory allocation
> flags to tell lockdep not to track that particular allocation for
> the purposes of reclaim recursion detection. This is a much better
> way of preventing false positives - it allows us to use GFP_KERNEL
> context outside of transactions, and allows direct memory reclaim to
> proceed normally without throwing out false positive deadlock
> warnings.

Hi Dave,

I recently encountered the following AA deadlock lockdep warning
in Linux-6.9.0. This version of the kernel has currently merged
your patch set. I believe this is a lockdep false positive warning.

The xfs_dir_lookup_args() function is in a non-transactional context
and allocates memory with the __GFP_NOLOCKDEP flag in xfs_buf_alloc_pages().
Even though __GFP_NOLOCKDEP can tell lockdep not to track that particular
allocation for the purposes of reclaim recursion detection, it cannot
completely replace __GFP_NOFS. Getting trapped in direct memory reclaim
maybe trigger the AA deadlock warning as shown below.

Or am I mistaken somewhere? I look forward to your reply.

Thanks,
Long Li

[12051.255974][ T6480] ============================================
[12051.256590][ T6480] WARNING: possible recursive locking detected
[12051.257207][ T6480] 6.9.0-xfstests-12131-gb902367d6fde-dirty #747 Not tainted
[12051.257919][ T6480] --------------------------------------------
[12051.258513][ T6480] cc1/6480 is trying to acquire lock:
[12051.259017][ T6480] ffff88804f40a018 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_icwalk_ag+0x7c0/0x1690
[12051.259926][ T6480]
[12051.259926][ T6480] but task is already holding lock:
[12051.260599][ T6480] ffff8881004b5658 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x52/0x70
[12051.261546][ T6480]
[12051.261546][ T6480] other info that might help us debug this:
[12051.262288][ T6480]  Possible unsafe locking scenario:
[12051.262288][ T6480]
[12051.262972][ T6480]        CPU0
[12051.263283][ T6480]        ----
[12051.263587][ T6480]   lock(&xfs_dir_ilock_class);
[12051.264048][ T6480]   lock(&xfs_dir_ilock_class);
[12051.264502][ T6480]
[12051.264502][ T6480]  *** DEADLOCK ***
[12051.264502][ T6480]
[12051.265267][ T6480]  May be due to missing lock nesting notation
[12051.265267][ T6480]
[12051.266052][ T6480] 3 locks held by cc1/6480:
[12051.266477][ T6480]  #0: ffff8881004b5878 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: path_openat+0xaa4/0x1090
[12051.267526][ T6480]  #1: ffff8881004b5658 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x52/0x70
[12051.268528][ T6480]  #2: ffff888107fda0e0 (&type->s_umount_key#42){.+.+}-{3:3}, at: super_trylock_shared+0x1c/0xb0
[12051.269511][ T6480]
[12051.269511][ T6480] stack backtrace:
[12051.270092][ T6480] CPU: 2 PID: 6480 Comm: cc1 Not tainted 6.9.0-xfstests-12131-gb902367d6fde-dirty #747
[12051.271012][ T6480] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
[12051.272321][ T6480] Call Trace:
[12051.272640][ T6480]  <TASK>
[12051.272913][ T6480]  dump_stack_lvl+0x82/0xd0
[12051.273347][ T6480]  validate_chain+0xe70/0x1d30
[12051.274765][ T6480]  __lock_acquire+0xd9a/0x1e90
[12051.275208][ T6480]  lock_acquire+0x1a9/0x4f0
[12051.277032][ T6480]  down_write_nested+0x9b/0x200
[12051.279413][ T6480]  xfs_icwalk_ag+0x7c0/0x1690
[12051.284326][ T6480]  xfs_icwalk+0x4f/0xe0
[12051.284735][ T6480]  xfs_reclaim_inodes_nr+0x148/0x1f0
[12051.285792][ T6480]  super_cache_scan+0x30c/0x440
[12051.286247][ T6480]  do_shrink_slab+0x340/0xce0
[12051.286701][ T6480]  shrink_slab_memcg+0x231/0x8f0
[12051.289127][ T6480]  shrink_slab+0x4ad/0x4f0
[12051.290620][ T6480]  shrink_node+0x86b/0x1de0
[12051.291055][ T6480]  do_try_to_free_pages+0x2c4/0x1490
[12051.293643][ T6480]  try_to_free_pages+0x20d/0x540
[12051.294641][ T6480]  __alloc_pages_slowpath.constprop.0+0x754/0x2050
[12051.299337][ T6480]  __alloc_pages_noprof+0x54f/0x660
[12051.301344][ T6480]  alloc_pages_bulk_noprof+0x6fb/0xe00
[12051.302404][ T6480]  xfs_buf_alloc_pages+0x1b9/0x850
[12051.302889][ T6480]  xfs_buf_get_map+0xe86/0x1590
[12051.303847][ T6480]  xfs_buf_read_map+0xb6/0x7f0
[12051.306234][ T6480]  xfs_trans_read_buf_map+0x474/0xd30
[12051.307753][ T6480]  xfs_da_read_buf+0x1c8/0x2c0
[12051.310298][ T6480]  xfs_dir3_data_read+0x36/0x2e0
[12051.310783][ T6480]  xfs_dir2_leafn_lookup_for_entry+0x3d6/0x14b0
[12051.313039][ T6480]  xfs_da3_node_lookup_int+0xef1/0x1810
[12051.315658][ T6480]  xfs_dir2_node_lookup+0xc5/0x580
[12051.317156][ T6480]  xfs_dir_lookup_args+0xbf/0xe0
[12075.149236][ T5555]  new_slab+0x2c4/0x320
[12075.149602][ T5555]  ___slab_alloc+0xcdd/0x1640
[12075.152775][ T5555]  __slab_alloc.isra.0+0x1f/0x40
[12075.153238][ T5555]  kmem_cache_alloc_noprof+0x34f/0x3a0
[12075.154130][ T5555]  vm_area_dup+0x51/0x160
[12075.154772][ T5555]  __split_vma+0x135/0x1930
[12075.158003][ T5555]  vma_modify+0x228/0x300
[12075.158380][ T5555]  mprotect_fixup+0x1a0/0x950
[12075.159252][ T5555]  do_mprotect_pkey+0x79c/0xa40
[12075.161063][ T5555]  __x64_sys_mprotect+0x78/0xc0
[12075.161492][ T5555]  do_syscall_64+0x66/0x140
[12075.161891][ T5555]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[12075.162409][ T5555] RIP: 0033:0x7ff736f2bc5b
[12075.162811][ T5555] Code: 73 01 c3 48 8d 0d a5 15 01 00 f7 d8 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa b8 0a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 83
[12075.164490][ T5555] RSP: 002b:00007ffc9c420998 EFLAGS: 00000206 ORIG_RAX: 000000000000000a
[12075.165229][ T5555] RAX: ffffffffffffffda RBX: 00007ff736f3ca30 RCX: 00007ff736f2bc5b
[12075.165937][ T5555] RDX: 0000000000000001 RSI: 0000000000002000 RDI: 00007ff736f3a000
[12075.166644][ T5555] RBP: 00007ffc9c420ab0 R08: 0000000000000000 R09: 0000000000000000
[12075.167349][ T5555] R10: 00007ff736f09000 R11: 0000000000000206 R12: 0000000000000000
[12075.168061][ T5555] R13: 00007ff736f3b9e0 R14: 00007ff736f3ca30 R15: 00007ff736f09000
[12075.168773][ T5555]  </TASK>
[12075.169090][ T5555] Mem-Info:
[12075.169378][ T5555] active_anon:6735 inactive_anon:1469067 isolated_anon:0
[12075.169378][ T5555]  active_file:24 inactive_file:508 isolated_file:424
[12075.169378][ T5555]  unevictable:0 dirty:1 writeback:0
[12075.169378][ T5555]  slab_reclaimable:56327 slab_unreclaimable:112381
[12075.169378][ T5555]  mapped:718 shmem:275 pagetables:53700
[12075.169378][ T5555]  sec_pagetables:0 bounce:0
[12075.169378][ T5555]  kernel_misc_reclaimable:0
[12075.169378][ T5555]  free:11595 free_pcp:554 free_cma:0
[12075.173320][ T5555] Node 0 active_anon:26940kB inactive_anon:5876268kB active_file:96kB inactive_file:2032kB unevictable:0kB isolated(anon):0kB isolated(file):1696kB mapped:2872kB dirtyo
[12075.175767][ T5555] Node 0 DMA free:20kB boost:0kB min:20kB low:32kB high:44kB reserved_highatomic:0KB active_anon:68kB inactive_anon:15272kB active_file:0kB inactive_file:0kB unevictabB
[12075.178094][ T5555] lowmem_reserve[]: 0 2895 6821 0 0
[12075.178559][ T5555] Node 0 DMA32 free:19760kB boost:15612kB min:20092kB low:23056kB high:26020kB reserved_highatomic:0KB active_anon:12592kB inactive_anon:2416704kB active_file:0kB inacB
[12075.181075][ T5555] lowmem_reserve[]: 0 0 3925 0 0
[12075.181517][ T5555] Node 0 Normal free:26600kB boost:21156kB min:27228kB low:31244kB high:35260kB reserved_highatomic:0KB active_anon:14280kB inactive_anon:3444292kB active_file:120kB iB
[12075.184140][ T5555] lowmem_reserve[]: 0 0 0 0 0
[12075.184554][ T5555] Node 0 DMA: 1*4kB (U) 2*8kB (UM) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 20kB
[12075.185606][ T5555] Node 0 DMA32: 85*4kB (UME) 45*8kB (UME) 12*16kB (UME) 6*32kB (UE) 300*64kB (UE) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 20284kB
[12075.186882][ T5555] Node 0 Normal: 0*4kB 1*8kB (U) 0*16kB 299*32kB (U) 247*64kB (UE) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 25384kB
[12075.188047][ T5555] 1152 total pagecache pages
[12075.188450][ T5555] 0 pages in swap cache
[12075.188821][ T5555] Free swap  = 0kB
[12075.189201][ T5555] Total swap = 0kB
[12075.189768][ T5555] 2097018 pages RAM
[12075.190103][ T5555] 0 pages HighMem/MovableOnly
[12075.190509][ T5555] 345037 pages reserved


> 
> The obvious places that lock inodes and do memory allocation are the
> lookup paths and inode extent list initialisation. These occur in
> non-transactional GFP_KERNEL contexts, and so can run direct reclaim
> and lock inodes.
> 
> This patch makes a first path through all the explicit GFP_NOFS
> allocations in XFS and converts the obvious ones to GFP_KERNEL |
> __GFP_NOLOCKDEP as a first step towards removing explicit GFP_NOFS
> allocations from the XFS code.
> 
 
