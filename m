Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A8537F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 09:35:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 861708F8068
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 07:35:02 -0700 (PDT)
Received: from mail-ea0-f178.google.com (mail-ea0-f178.google.com
	[209.85.215.178]) by cuda.sgi.com with ESMTP id
	ITMaq5yGxhkI2UcR (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 07:35:01 -0700 (PDT)
Received: by mail-ea0-f178.google.com with SMTP id q16so1901295ead.37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 07:35:00 -0700 (PDT)
Date: Thu, 23 May 2013 16:34:56 +0200
From: Paolo Pisati <p.pisati@gmail.com>
Subject: Re: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130523143456.GB19815@luxor.wired.org>
References: <20130517104529.GA12490@luxor.wired.org>
	<20130519011354.GE6495@dastard>
	<20130520170710.GA2591@luxor.wired.org>
	<20130521000208.GF24543@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130521000208.GF24543@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Paolo Pisati <p.pisati@gmail.com>

On Tue, May 21, 2013 at 10:02:09AM +1000, Dave Chinner wrote:
> 
> And that fix I mentioned will be useless if you don't apply the
> patch that avoids the vmap allocation problem....


ok, so i recompiled a kernel+aforementioend fix, i repartitioned my disk and i
ran the swift-bench for 2 days in a row until i got this:

dmesg:
...
[163596.605253] updatedb.mlocat: page allocation failure: order:0, mode:0x20
[163596.605299] [<c00164cc>] (unwind_backtrace+0x0/0x104) from [<c04edb20>] (dump_stack+0x20/0x24)
[163596.605320] [<c04edb20>] (dump_stack+0x20/0x24) from [<c00e7780>] (warn_alloc_failed+0xd8/0x118)
[163596.605335] [<c00e7780>] (warn_alloc_failed+0xd8/0x118) from [<c00e9b88>] (__alloc_pages_nodemask+0x524/0x708)
[163596.605354] [<c00e9b88>] (__alloc_pages_nodemask+0x524/0x708) from [<c011b798>] (new_slab+0x22c/0x248)
[163596.605370] [<c011b798>] (new_slab+0x22c/0x248) from [<c04f04f8>] (__slab_alloc.constprop.46+0x1a4/0x4c8)
[163596.605383] [<c04f04f8>] (__slab_alloc.constprop.46+0x1a4/0x4c8) from [<c011ced4>] (kmem_cache_alloc+0x158/0x190)
[163596.605402] [<c011ced4>] (kmem_cache_alloc+0x158/0x190) from [<c0332be0>] (scsi_pool_alloc_command+0x30/0x74)
[163596.605417] [<c0332be0>] (scsi_pool_alloc_command+0x30/0x74) from [<c0332c80>] (scsi_host_alloc_command+0x24/0x78)
[163596.605428] [<c0332c80>] (scsi_host_alloc_command+0x24/0x78) from [<c0332cf0>] (__scsi_get_command+0x1c/0xa0)
[163596.605439] [<c0332cf0>] (__scsi_get_command+0x1c/0xa0) from [<c0332db0>] (scsi_get_command+0x3c/0xb0)
[163596.605453] [<c0332db0>] (scsi_get_command+0x3c/0xb0) from [<c0338d44>] (scsi_get_cmd_from_req+0x50/0x60)
[163596.605466] [<c0338d44>] (scsi_get_cmd_from_req+0x50/0x60) from [<c0339fd8>] (scsi_setup_fs_cmnd+0x4c/0xac)
[163596.605482] [<c0339fd8>] (scsi_setup_fs_cmnd+0x4c/0xac) from [<c0343568>] (sd_prep_fn+0x114/0xaf4)
[163596.605501] [<c0343568>] (sd_prep_fn+0x114/0xaf4) from [<c0299af4>] (blk_peek_request+0xc8/0x214)
[163596.605514] [<c0299af4>] (blk_peek_request+0xc8/0x214) from [<c033a1b0>] (scsi_request_fn+0x40/0x504)
[163596.605524] [<c033a1b0>] (scsi_request_fn+0x40/0x504) from [<c029a38c>] (blk_queue_bio+0x300/0x384)
[163596.605536] [<c029a38c>] (blk_queue_bio+0x300/0x384) from [<c0298450>] (generic_make_request+0xb8/0xd8)
[163596.605548] [<c0298450>] (generic_make_request+0xb8/0xd8) from [<c0298534>] (submit_bio+0xc4/0x17c)
[163596.605756] [<c0298534>] (submit_bio+0xc4/0x17c) from [<bf00f1c4>] (_xfs_buf_ioapply+0x1bc/0x224 [xfs])
[163596.606002] [<bf00f1c4>] (_xfs_buf_ioapply+0x1bc/0x224 [xfs]) from [<bf00f314>] (xfs_buf_iorequest+0x4c/0x98 [xfs])
[163596.606241] [<bf00f314>] (xfs_buf_iorequest+0x4c/0x98 [xfs]) from [<bf00f868>] (_xfs_buf_read+0x34/0x50 [xfs])
[163596.606481] [<bf00f868>] (_xfs_buf_read+0x34/0x50 [xfs]) from [<bf00f964>] (xfs_buf_read+0xe0/0x108 [xfs])
[163596.606781] [<bf00f964>] (xfs_buf_read+0xe0/0x108 [xfs]) from [<bf06ba78>] (xfs_trans_read_buf+0x1e4/0x3e8 [xfs])
[163596.607115] [<bf06ba78>] (xfs_trans_read_buf+0x1e4/0x3e8 [xfs]) from [<bf053a9c>] (xfs_imap_to_bp+0x54/0x128 [xfs])
[163596.607432] [<bf053a9c>] (xfs_imap_to_bp+0x54/0x128 [xfs]) from [<bf057bc4>] (xfs_iread+0x6c/0x150 [xfs])
[163596.607719] [<bf057bc4>] (xfs_iread+0x6c/0x150 [xfs]) from [<bf015bfc>] (xfs_iget+0x210/0x72c [xfs])
[163596.607982] [<bf015bfc>] (xfs_iget+0x210/0x72c [xfs]) from [<bf0233b4>] (xfs_lookup+0xf4/0x114 [xfs])
[163596.608247] [<bf0233b4>] (xfs_lookup+0xf4/0x114 [xfs]) from [<bf01a5e8>] (xfs_vn_lookup+0x54/0x98 [xfs])
[163596.608387] [<bf01a5e8>] (xfs_vn_lookup+0x54/0x98 [xfs]) from [<c0134198>] (__lookup_hash+0x64/0xec)
[163596.608402] [<c0134198>] (__lookup_hash+0x64/0xec) from [<c04f0d68>] (lookup_slow+0x50/0xac)
[163596.608415] [<c04f0d68>] (lookup_slow+0x50/0xac) from [<c0136724>] (path_lookupat+0x730/0x794)
[163596.608428] [<c0136724>] (path_lookupat+0x730/0x794) from [<c01367b4>] (do_path_lookup+0x2c/0xd0)
[163596.608439] [<c01367b4>] (do_path_lookup+0x2c/0xd0) from [<c01385e0>] (user_path_at_empty+0x64/0x8c)
[163596.608451] [<c01385e0>] (user_path_at_empty+0x64/0x8c) from [<c013862c>] (user_path_at+0x24/0x2c)
[163596.608462] [<c013862c>] (user_path_at+0x24/0x2c) from [<c012dd3c>] (vfs_fstatat+0x40/0x78)
[163596.608473] [<c012dd3c>] (vfs_fstatat+0x40/0x78) from [<c012dd9c>] (vfs_lstat+0x28/0x2c)
[163596.608482] [<c012dd9c>] (vfs_lstat+0x28/0x2c) from [<c012e048>] (sys_lstat64+0x24/0x40)
[163596.608495] [<c012e048>] (sys_lstat64+0x24/0x40) from [<c000e320>] (ret_fast_syscall+0x0/0x30)
[163596.608503] Mem-info:
[163596.608509] Normal per-cpu:
[163596.608515] CPU    0: hi:  186, btch:  31 usd:  38
[163596.608521] CPU    1: hi:  186, btch:  31 usd: 218
[163596.608528] CPU    2: hi:  186, btch:  31 usd: 152
[163596.608533] CPU    3: hi:  186, btch:  31 usd: 171
[163596.608538] HighMem per-cpu:
[163596.608544] CPU    0: hi:  186, btch:  31 usd:  46
[163596.608549] CPU    1: hi:  186, btch:  31 usd: 171
[163596.608555] CPU    2: hi:  186, btch:  31 usd: 168
[163596.608561] CPU    3: hi:  186, btch:  31 usd: 177
[163596.608574] active_anon:26367 inactive_anon:29153 isolated_anon:0
[163596.608574]  active_file:396338 inactive_file:397959 isolated_file:0
[163596.608574]  unevictable:0 dirty:0 writeback:5 unstable:0
[163596.608574]  free:5145 slab_reclaimable:57625 slab_unreclaimable:7729
[163596.608574]  mapped:1703 shmem:10 pagetables:581 bounce:0
[163596.608602] Normal free:15256kB min:3508kB low:4384kB high:5260kB active_anon:0kB inactive_anon:8kB active_file:848kB inactive_file:1560kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:772160kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:230500kB slab_unreclaimable:30916kB kernel_stack:2208kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[163596.608607] lowmem_reserve[]: 0 26423 26423
[163596.608628] HighMem free:5324kB min:512kB low:4352kB high:8192kB active_anon:105468kB inactive_anon:116604kB active_file:1584504kB inactive_file:1590276kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3382264kB mlocked:0kB dirty:0kB writeback:20kB mapped:6812kB shmem:40kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:2324kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[163596.608634] lowmem_reserve[]: 0 0 0
[163596.608643] Normal: 216*4kB 215*8kB 216*16kB 216*32kB 36*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15256kB
[163596.608668] HighMem: 233*4kB 67*8kB 141*16kB 22*32kB 8*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5324kB
[163596.608692] 794329 total pagecache pages
[163596.608697] 12 pages in swap cache
[163596.608703] Swap cache stats: add 79, delete 67, find 9/11
[163596.608708] Free swap  = 8378092kB
[163596.608712] Total swap = 8378364kB
[163596.670667] 1046784 pages of RAM
[163596.670674] 6801 free pages
[163596.670679] 12533 reserved pages
[163596.670683] 36489 slab pages
[163596.670687] 631668 pages shared
[163596.670692] 12 pages swap cached
[163596.670701] SLUB: Unable to allocate memory on node -1 (gfp=0x8020)
[163596.670710]   cache: kmalloc-192, object size: 192, buffer size: 192, default order: 0, min order: 0
[163596.670718]   node 0: slabs: 2733, objs: 57393, free: 0

df -h:
...
/dev/sda6       216G   53G  163G  25% /mnt/sdb1

df -i:
...
/dev/sda6      56451072 19721920 36729152   35% /mnt/sdb1

flag@c13:~$ cat /proc/meminfo 
MemTotal:        4137004 kB
MemFree:         1191096 kB
Buffers:           23172 kB
Cached:          2074116 kB
SwapCached:           48 kB
Active:          1301568 kB
Inactive:        1016024 kB
Active(anon):     103748 kB
Inactive(anon):   116600 kB
Active(file):    1197820 kB
Inactive(file):   899424 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       3408896 kB
HighFree:        1108444 kB
LowTotal:         728108 kB
LowFree:           82652 kB
SwapTotal:       8378364 kB
SwapFree:        8378092 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        220284 kB
Mapped:             7068 kB
Shmem:                44 kB
Slab:             263216 kB
SReclaimable:     232212 kB
SUnreclaim:        31004 kB
KernelStack:        2192 kB
PageTables:         2312 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    10446864 kB
Committed_AS:    1051868 kB
VmallocTotal:     245760 kB
VmallocUsed:        2360 kB
VmallocChunk:     241428 kB

flag@c13:~$ sudo xfs_db -r "-c freesp -s" /dev/sda6
   from      to extents  blocks    pct
      1       1   27058   27058   0.06
      2       3  124367  358831   0.84
      4       7   17656  121693   0.29
      8      15 2856900 42122381  98.81
total free extents 3025981
total free blocks 42629963
average free extent size 14.088

-- 
bye,
p.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
