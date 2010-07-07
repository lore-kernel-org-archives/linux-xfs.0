Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o679RtH5230031 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 04:27:55 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5071642F51C
	for <xfs@oss.sgi.com>; Wed,  7 Jul 2010 02:30:45 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id BU32mFMoynNotq3O for
	<xfs@oss.sgi.com>; Wed, 07 Jul 2010 02:30:45 -0700 (PDT)
Message-ID: <4C34492E.1080109@tlinx.org>
Date: Wed, 07 Jul 2010 02:30:22 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs file system in process of becoming corrupt;
	though	xfs_repair	thinks it's fine! ; -/ (was xfs_dump problem...)
References: <20100628022744.GX6590@dastard> <4C2A749E.4060006@tlinx.org>
	<20100629232532.GA24712@dastard>
	<4C2A87FF.7090804@dermichi.com> <4C2A92DA.1020202@tlinx.org>
	<20100630011647.GD24712@dastard> <4C2AAFC1.9080708@tlinx.org>
	<20100701235802.GW24712@dastard> <4C33F20F.4040905@tlinx.org>
	<4C341712.5030202@tlinx.org> <20100707063634.GI25018@dastard>
In-Reply-To: <20100707063634.GI25018@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>


Dave Chinner wrote:
> Can you send me a link to a metadump image of the filesystem so I can
> look at the broken directories in detail?


----
	I'll have to work on that -- right now I'm taking a copy and trying to
delete everything off of it, so the meta copy, hopefully will have just the
stuff that won't delete... (at least that's the theory)...

BTW -- reviewing log files...there some stuff there that corresponds to not
begin able to read files and metadata, though I don't know the exact runtime messages
I was getting at the time:


Jul  6 08:15:54 Ishtar kernel: [33919.157874] xfsdump: page allocation failure. order:4, mode:0x40d0
Jul  6 08:17:12 Ishtar kernel: [33997.243321] xfsdump: page allocation failure. order:4, mode:0x40d0
Jul  6 08:17:51 Ishtar kernel: [34036.405012] xfsdump: page allocation failure. order:4, mode:0x40d0
....
....
Jul  6 08:17:12 Ishtar kernel: [33997.243326] Pid: 5047, comm: xfsdump Not tainted 2.6.34T610-Vanilla #1
Jul  6 08:17:12 Ishtar kernel: [33997.243329] Call Trace:
Jul  6 08:17:12 Ishtar kernel: [33997.243338]  [<ffffffff810c24d6>] __alloc_pages_nodemask+0x5b6/0x6a0
Jul  6 08:17:12 Ishtar kernel: [33997.243343]  [<ffffffff810c25d2>] __get_free_pages+0x12/0x50
Jul  6 08:17:12 Ishtar kernel: [33997.243349]  [<ffffffff810f26d9>] __kmalloc+0x189/0x1e0
Jul  6 08:17:12 Ishtar kernel: [33997.243353]  [<ffffffff8125b82e>] xfs_attrlist_by_handle+0xbe/0x130
Jul  6 08:17:12 Ishtar kernel: [33997.243358]  [<ffffffff8125c6c9>] xfs_file_ioctl+0x5f9/0x980
Jul  6 08:17:12 Ishtar kernel: [33997.243364]  [<ffffffff8158f4e1>] ? down_read+0x11/0x30
Jul  6 08:17:12 Ishtar kernel: [33997.243370]  [<ffffffff8123276d>] ? xfs_iunlock+0xdd/0x130
Jul  6 08:17:12 Ishtar kernel: [33997.243374]  [<ffffffff81250d05>] ? xfs_free_eofblocks+0xd5/0x260
Jul  6 08:17:12 Ishtar kernel: [33997.243379]  [<ffffffff81107ca8>] vfs_ioctl+0x38/0xd0
Jul  6 08:17:12 Ishtar kernel: [33997.243382]  [<ffffffff81107e7a>] do_vfs_ioctl+0x8a/0x5a0
Jul  6 08:17:12 Ishtar kernel: [33997.243387]  [<ffffffff810fa40c>] ? __fput+0x19c/0x210
Jul  6 08:17:12 Ishtar kernel: [33997.243391]  [<ffffffff81108411>] sys_ioctl+0x81/0xa0
Jul  6 08:17:12 Ishtar kernel: [33997.243396]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
Jul  6 08:17:12 Ishtar kernel: [33997.243398] Mem-Info:
Jul  6 08:17:12 Ishtar kernel: [33997.243400] DMA per-cpu:
Jul  6 08:17:12 Ishtar kernel: [33997.243402] CPU    0: hi:    0, btch:   1 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243405] CPU    1: hi:    0, btch:   1 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243407] CPU    2: hi:    0, btch:   1 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243409] CPU    3: hi:    0, btch:   1 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243411] DMA32 per-cpu:
Jul  6 08:17:12 Ishtar kernel: [33997.243413] CPU    0: hi:  186, btch:  31 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243416] CPU    1: hi:  186, btch:  31 usd:  10
Jul  6 08:17:12 Ishtar kernel: [33997.243418] CPU    2: hi:  186, btch:  31 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243425] CPU    3: hi:  186, btch:  31 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243427] Normal per-cpu:
Jul  6 08:17:12 Ishtar kernel: [33997.243431] CPU    0: hi:  186, btch:  31 usd:  12
Jul  6 08:17:12 Ishtar kernel: [33997.243435] CPU    1: hi:  186, btch:  31 usd:  36
Jul  6 08:17:12 Ishtar kernel: [33997.243439] CPU    2: hi:  186, btch:  31 usd:  15
Jul  6 08:17:12 Ishtar kernel: [33997.243443] CPU    3: hi:  186, btch:  31 usd:   0
Jul  6 08:17:12 Ishtar kernel: [33997.243451] active_anon:39844 inactive_anon:31818 isolated_anon:0
Jul  6 08:17:12 Ishtar kernel: [33997.243454]  active_file:854853 inactive_file:4597578 isolated_file:44
Jul  6 08:17:12 Ishtar kernel: [33997.243457]  unevictable:262348 dirty:348876 writeback:2 unstable:0
Jul  6 08:17:12 Ishtar kernel: [33997.243460]  free:59942 slab_reclaimable:294751 slab_unreclaimable:26479
Jul  6 08:17:12 Ishtar kernel: [33997.243463]  mapped:18561 shmem:6 pagetables:2966 bounce:0
Jul  6 08:17:12 Ishtar kernel: [33997.243473] DMA free:15868kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15772kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jul  6 08:17:12 Ishtar kernel: [33997.243491] lowmem_reserve[]: 0 2990 24200 24200
Jul  6 08:17:12 Ishtar kernel: [33997.243504] DMA32 free:199276kB min:2456kB low:3068kB high:3684kB active_anon:48kB inactive_anon:2672kB active_file:195724kB inactive_file:1726428kB unevictable:55768kB isolated(anon):0kB isolated(file):0kB present:3062596kB mlocked:55768kB dirty:107612kB writeback:0kB mapped:6352kB shmem:0kB slab_reclaimable:509064kB slab_unreclaimable:22184kB kernel_stack:64kB pagetables:444kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jul  6 08:17:12 Ishtar kernel: [33997.243524] lowmem_reserve[]: 0 0 21210 21210
Jul  6 08:17:12 Ishtar kernel: [33997.243537] Normal free:24624kB min:17440kB low:21800kB high:26160kB active_anon:159328kB inactive_anon:124600kB active_file:3223688kB inactive_file:16663884kB unevictable:993624kB isolated(anon):0kB isolated(file):176kB present:21719040kB mlocked:993624kB dirty:1287892kB writeback:8kB mapped:67892kB shmem:24kB slab_reclaimable:669940kB slab_unreclaimable:83732kB kernel_stack:3320kB pagetables:11420kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jul  6 08:17:12 Ishtar kernel: [33997.243557] lowmem_reserve[]: 0 0 0 0
Jul  6 08:17:12 Ishtar kernel: [33997.243565] DMA: 1*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15868kB
Jul  6 08:17:12 Ishtar kernel: [33997.243583] DMA32: 26095*4kB 10064*8kB 798*16kB 52*32kB 3*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 199516kB
Jul  6 08:17:12 Ishtar kernel: [33997.243602] Normal: 5486*4kB 0*8kB 0*16kB 4*32kB 2*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 24376kB
Jul  6 08:17:12 Ishtar kernel: [33997.243621] 5462983 total pagecache pages
Jul  6 08:17:12 Ishtar kernel: [33997.243625] 10294 pages in swap cache
Jul  6 08:17:12 Ishtar kernel: [33997.243629] Swap cache stats: add 455795, delete 445501, find 338025/357649
Jul  6 08:17:12 Ishtar kernel: [33997.243633] Free swap  = 8151268kB
Jul  6 08:17:12 Ishtar kernel: [33997.243637] Total swap = 8393924kB
Jul  6 08:17:12 Ishtar kernel: [33997.345120] 6291455 pages RAM
Jul  6 08:17:12 Ishtar kernel: [33997.345122] 104293 pages reserved
Jul  6 08:17:12 Ishtar kernel: [33997.345124] 3464575 pages shared
Jul  6 08:17:12 Ishtar kernel: [33997.345125] 2682993 pages non-shared
Jul  6 08:17:51 Ishtar kernel: [34036.405017] Pid: 5047, comm: xfsdump Not tainted 2.6.34T610-Vanilla #1
Jul  6 08:17:51 Ishtar kernel: [34036.405020] Call Trace:
Jul  6 08:17:51 Ishtar kernel: [34036.405029]  [<ffffffff810c24d6>] __alloc_pages_nodemask+0x5b6/0x6a0
Jul  6 08:17:51 Ishtar kernel: [34036.405034]  [<ffffffff810c25d2>] __get_free_pages+0x12/0x50
Jul  6 08:17:51 Ishtar kernel: [34036.405040]  [<ffffffff810f26d9>] __kmalloc+0x189/0x1e0
Jul  6 08:17:51 Ishtar kernel: [34036.405044]  [<ffffffff8125b82e>] xfs_attrlist_by_handle+0xbe/0x130
Jul  6 08:17:51 Ishtar kernel: [34036.405048]  [<ffffffff8125c6c9>] xfs_file_ioctl+0x5f9/0x980
Jul  6 08:17:51 Ishtar kernel: [34036.405055]  [<ffffffff8158f4e1>] ? down_read+0x11/0x30
Jul  6 08:17:51 Ishtar kernel: [34036.405060]  [<ffffffff8123276d>] ? xfs_iunlock+0xdd/0x130
Jul  6 08:17:51 Ishtar kernel: [34036.405065]  [<ffffffff81250d05>] ? xfs_free_eofblocks+0xd5/0x260
Jul  6 08:17:51 Ishtar kernel: [34036.405070]  [<ffffffff81107ca8>] vfs_ioctl+0x38/0xd0
Jul  6 08:17:51 Ishtar kernel: [34036.405073]  [<ffffffff81107e7a>] do_vfs_ioctl+0x8a/0x5a0
Jul  6 08:17:51 Ishtar kernel: [34036.405084]  [<ffffffff810fa40c>] ? __fput+0x19c/0x210
Jul  6 08:17:51 Ishtar kernel: [34036.405087]  [<ffffffff81108411>] sys_ioctl+0x81/0xa0
Jul  6 08:17:51 Ishtar kernel: [34036.405093]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
Jul  6 08:17:51 Ishtar kernel: [34036.405095] Mem-Info:
Jul  6 08:17:51 Ishtar kernel: [34036.405097] DMA per-cpu:
Jul  6 08:17:51 Ishtar kernel: [34036.405099] CPU    0: hi:    0, btch:   1 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405101] CPU    1: hi:    0, btch:   1 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405104] CPU    2: hi:    0, btch:   1 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405106] CPU    3: hi:    0, btch:   1 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405108] DMA32 per-cpu:
Jul  6 08:17:51 Ishtar kernel: [34036.405110] CPU    0: hi:  186, btch:  31 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405112] CPU    1: hi:  186, btch:  31 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405114] CPU    2: hi:  186, btch:  31 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405117] CPU    3: hi:  186, btch:  31 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405118] Normal per-cpu:
Jul  6 08:17:51 Ishtar kernel: [34036.405120] CPU    0: hi:  186, btch:  31 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405123] CPU    1: hi:  186, btch:  31 usd:   0
Jul  6 08:17:51 Ishtar kernel: [34036.405125] CPU    2: hi:  186, btch:  31 usd:  30
Jul  6 08:17:51 Ishtar kernel: [34036.405127] CPU    3: hi:  186, btch:  31 usd:  15
Jul  6 08:17:51 Ishtar kernel: [34036.405133] active_anon:39844 inactive_anon:31812 isolated_anon:0
Jul  6 08:17:51 Ishtar kernel: [34036.405134]  active_file:865726 inactive_file:4534161 isolated_file:35
Jul  6 08:17:51 Ishtar kernel: [34036.405135]  unevictable:262348 dirty:195473 writeback:0 unstable:0
Jul  6 08:17:51 Ishtar kernel: [34036.405136]  free:57638 slab_reclaimable:344326 slab_unreclaimable:32158
Jul  6 08:17:51 Ishtar kernel: [34036.405137]  mapped:26657 shmem:6 pagetables:2971 bounce:0
Jul  6 08:17:51 Ishtar kernel: [34036.405144] DMA free:15868kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15772kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jul  6 08:17:51 Ishtar kernel: [34036.405150] lowmem_reserve[]: 0 2990 24200 24200
Jul  6 08:17:51 Ishtar kernel: [34036.405159] DMA32 free:179088kB min:2456kB low:3068kB high:3684kB active_anon:48kB inactive_anon:2648kB active_file:196548kB inactive_file:1548864kB unevictable:55768kB isolated(anon):0kB isolated(file):0kB present:3062596kB mlocked:55768kB dirty:52076kB writeback:0kB mapped:10560kB shmem:0kB slab_reclaimable:701508kB slab_unreclaimable:27664kB kernel_stack:64kB pagetables:444kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jul  6 08:17:51 Ishtar kernel: [34036.405166] lowmem_reserve[]: 0 0 21210 21210
Jul  6 08:17:51 Ishtar kernel: [34036.405175] Normal free:35596kB min:17440kB low:21800kB high:26160kB active_anon:159328kB inactive_anon:124600kB active_file:3266356kB inactive_file:16587780kB unevictable:993624kB isolated(anon):0kB isolated(file):140kB present:21719040kB mlocked:993624kB dirty:729816kB writeback:0kB mapped:96068kB shmem:24kB slab_reclaimable:675796kB slab_unreclaimable:100968kB kernel_stack:3320kB pagetables:11440kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jul  6 08:17:51 Ishtar kernel: [34036.405181] lowmem_reserve[]: 0 0 0 0
Jul  6 08:17:51 Ishtar kernel: [34036.405185] DMA: 1*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15868kB
Jul  6 08:17:51 Ishtar kernel: [34036.405194] DMA32: 26498*4kB 8649*8kB 150*16kB 41*32kB 3*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 179088kB
Jul  6 08:17:51 Ishtar kernel: [34036.405204] Normal: 7071*4kB 557*8kB 20*16kB 2*32kB 2*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 35428kB
Jul  6 08:17:51 Ishtar kernel: [34036.405214] 5410107 total pagecache pages
Jul  6 08:17:51 Ishtar kernel: [34036.405216] 10290 pages in swap cache
Jul  6 08:17:51 Ishtar kernel: [34036.405218] Swap cache stats: add 455867, delete 445577, find 338111/357759
Jul  6 08:17:51 Ishtar kernel: [34036.405221] Free swap  = 8151272kB
Jul  6 08:17:51 Ishtar kernel: [34036.405222] Total swap = 8393924kB
Jul  6 08:17:52 Ishtar kernel: [34036.530592] 6291455 pages RAM
Jul  6 08:17:52 Ishtar kernel: [34036.530595] 104293 pages reserved
Jul  6 08:17:52 Ishtar kernel: [34036.530597] 3301623 pages shared
Jul  6 08:17:52 Ishtar kernel: [34036.530598] 2859224 pages non-shared

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
