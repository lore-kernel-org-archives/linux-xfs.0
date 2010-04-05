Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o350lNaE184870 for <xfs@oss.sgi.com>; Sun, 4 Apr 2010 19:47:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6BBB29A29D
	for <xfs@oss.sgi.com>; Sun,  4 Apr 2010 17:49:10 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	jyKTHkf78WHQYYjm for <xfs@oss.sgi.com>;
	Sun, 04 Apr 2010 17:49:10 -0700 (PDT)
Date: Mon, 5 Apr 2010 10:49:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
Message-ID: <20100405004906.GY3335@dastard>
References: <201004050049.17952.hpj@urpla.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004050049.17952.hpj@urpla.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 05, 2010 at 12:49:17AM +0200, Hans-Peter Jansen wrote:
> [Sorry for the cross post, but I don't know where to start to tackle this 
>  issue]
> 
> Hi,
> 
> on an attempt to get to a current kernel, I suffer from an issue, where a 
> simple du on a reasonably big xfs tree leads to invoking the oom killer: 

How big is the directory tree (how many inodes, etc)?

> Apr  4 23:24:53 tyrex kernel: [  418.913223] XFS mounting filesystem sdd1
> Apr  4 23:24:54 tyrex kernel: [  419.774606] Ending clean XFS mount for filesystem: sdd1
> Apr  4 23:26:02 tyrex kernel: [  488.160795] du invoked oom-killer: gfp_mask=0x802d0, order=0, oom_adj=0
> Apr  4 23:26:02 tyrex kernel: [  488.160798] du cpuset=/ mems_allowed=0
> Apr  4 23:26:02 tyrex kernel: [  488.160800] Pid: 6397, comm: du Tainted: G        W  2.6.34-rc3-13-vanilla #1
> Apr  4 23:26:02 tyrex kernel: [  488.160802] Call Trace:
> Apr  4 23:26:02 tyrex kernel: [  488.160808]  [<c02becc7>] dump_header+0x67/0x1a0
> Apr  4 23:26:02 tyrex kernel: [  488.160811]  [<c03cf1a7>] ? ___ratelimit+0x77/0xe0
> Apr  4 23:26:02 tyrex kernel: [  488.160813]  [<c02bee59>] oom_kill_process+0x59/0x160
> Apr  4 23:26:02 tyrex kernel: [  488.160815]  [<c02bf43e>] __out_of_memory+0x4e/0xc0
> Apr  4 23:26:02 tyrex kernel: [  488.160817]  [<c02bf502>] out_of_memory+0x52/0xc0
> Apr  4 23:26:02 tyrex kernel: [  488.160819]  [<c02c20f4>] __alloc_pages_slowpath+0x444/0x4c0
> Apr  4 23:26:02 tyrex kernel: [  488.160822]  [<c02c22c2>] __alloc_pages_nodemask+0x152/0x160
> Apr  4 23:26:02 tyrex kernel: [  488.160825]  [<c02ea4a9>] cache_grow+0x249/0x2e0
> Apr  4 23:26:02 tyrex kernel: [  488.160838]  [<c02ea748>] cache_alloc_refill+0x208/0x240
> Apr  4 23:26:02 tyrex kernel: [  488.160840]  [<c02eab19>] kmem_cache_alloc+0xb9/0xc0
> Apr  4 23:26:02 tyrex kernel: [  488.160868]  [<f86375dd>] ? xfs_trans_brelse+0xfd/0x150 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.160888]  [<f863d547>] kmem_zone_alloc+0x77/0xb0 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.160905]  [<f860a043>] ? xfs_da_state_free+0x53/0x60 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.160923]  [<f861c796>] xfs_inode_alloc+0x26/0x110 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.160941]  [<f861c8b2>] xfs_iget_cache_miss+0x32/0x200 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.160960]  [<f8630fd9>] ? xfs_perag_get+0x29/0xa0 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.160977]  [<f861cbac>] xfs_iget+0x12c/0x1b0 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.160997]  [<f863c9c5>] xfs_lookup+0xc5/0x110 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.161017]  [<f86467d1>] xfs_vn_lookup+0x51/0xa0 [xfs]
> Apr  4 23:26:02 tyrex kernel: [  488.161021]  [<c02ffef7>] do_lookup+0xa7/0x1c0
> Apr  4 23:26:02 tyrex kernel: [  488.161023]  [<c030089b>] link_path_walk+0x1db/0x850
> Apr  4 23:26:02 tyrex kernel: [  488.161026]  [<c024a870>] ? capable+0x10/0x40
> Apr  4 23:26:02 tyrex kernel: [  488.161028]  [<c038969e>] ? security_inode_permission+0x1e/0x20
> Apr  4 23:26:02 tyrex kernel: [  488.161030]  [<c0301294>] path_walk+0x54/0xc0
> Apr  4 23:26:02 tyrex kernel: [  488.161032]  [<c0301431>] do_path_lookup+0x51/0x90
> Apr  4 23:26:02 tyrex kernel: [  488.161034]  [<c0301f8a>] user_path_at+0x4a/0x80
> Apr  4 23:26:02 tyrex kernel: [  488.161037]  [<c02f9748>] ? cp_new_stat64+0xe8/0x100
> Apr  4 23:26:02 tyrex kernel: [  488.161039]  [<c02f9bb5>] vfs_fstatat+0x35/0x70
> Apr  4 23:26:02 tyrex kernel: [  488.161041]  [<c02f9c0d>] sys_fstatat64+0x1d/0x40
> Apr  4 23:26:02 tyrex kernel: [  488.161044]  [<c0202d8c>] sysenter_do_call+0x12/0x22
> Apr  4 23:26:02 tyrex kernel: [  488.161045] Mem-Info:
> Apr  4 23:26:02 tyrex kernel: [  488.161046] DMA per-cpu:
> Apr  4 23:26:02 tyrex kernel: [  488.161047] CPU    0: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161048] CPU    1: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161050] CPU    2: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161051] CPU    3: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161052] CPU    4: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161053] CPU    5: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161054] CPU    6: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161056] CPU    7: hi:    0, btch:   1 usd:   0
> Apr  4 23:26:02 tyrex kernel: [  488.161057] Normal per-cpu:
> Apr  4 23:26:02 tyrex kernel: [  488.161058] CPU    0: hi:  186, btch:  31 usd: 173
> Apr  4 23:26:02 tyrex kernel: [  488.161059] CPU    1: hi:  186, btch:  31 usd:  18
> Apr  4 23:26:02 tyrex kernel: [  488.161060] CPU    2: hi:  186, btch:  31 usd:  41
> Apr  4 23:26:02 tyrex kernel: [  488.161061] CPU    3: hi:  186, btch:  31 usd: 197
> Apr  4 23:26:02 tyrex kernel: [  488.161062] CPU    4: hi:  186, btch:  31 usd: 175
> Apr  4 23:26:02 tyrex kernel: [  488.161063] CPU    5: hi:  186, btch:  31 usd: 157
> Apr  4 23:26:02 tyrex kernel: [  488.161065] CPU    6: hi:  186, btch:  31 usd: 182
> Apr  4 23:26:02 tyrex kernel: [  488.161066] CPU    7: hi:  186, btch:  31 usd: 173
> Apr  4 23:26:02 tyrex kernel: [  488.161067] HighMem per-cpu:
> Apr  4 23:26:02 tyrex kernel: [  488.161068] CPU    0: hi:  186, btch:  31 usd:  24
> Apr  4 23:26:02 tyrex kernel: [  488.161069] CPU    1: hi:  186, btch:  31 usd:  33
> Apr  4 23:26:02 tyrex kernel: [  488.161070] CPU    2: hi:  186, btch:  31 usd:  55
> Apr  4 23:26:02 tyrex kernel: [  488.161071] CPU    3: hi:  186, btch:  31 usd: 172
> Apr  4 23:26:02 tyrex kernel: [  488.161072] CPU    4: hi:  186, btch:  31 usd: 177
> Apr  4 23:26:02 tyrex kernel: [  488.161073] CPU    5: hi:  186, btch:  31 usd: 100
> Apr  4 23:26:02 tyrex kernel: [  488.161075] CPU    6: hi:  186, btch:  31 usd:  38
> Apr  4 23:26:02 tyrex kernel: [  488.161076] CPU    7: hi:  186, btch:  31 usd: 115
> Apr  4 23:26:02 tyrex kernel: [  488.161078] active_anon:98428 inactive_anon:24627 isolated_anon:0
> Apr  4 23:26:02 tyrex kernel: [  488.161079]  active_file:4141 inactive_file:25571 isolated_file:0
> Apr  4 23:26:02 tyrex kernel: [  488.161080]  unevictable:0 dirty:2 writeback:0 unstable:0
> Apr  4 23:26:02 tyrex kernel: [  488.161080]  free:403317 slab_reclaimable:203863 slab_unreclaimable:4837
> Apr  4 23:26:02 tyrex kernel: [  488.161081]  mapped:7418 shmem:137 pagetables:625 bounce:0
> Apr  4 23:26:02 tyrex kernel: [  488.161085] 
> DMA free:3520kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB 
> active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
> present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:6032kB 
> slab_unreclaimable:36kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
> pages_scanned:0 all_unreclaimable? yes
> Apr  4 23:26:02 tyrex kernel: [  488.161089] lowmem_reserve[]: 0 865 3023 3023
> Apr  4 23:26:02 tyrex kernel: [  488.161093] 
> Normal free:3580kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB 
> active_file:360kB inactive_file:264kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
> present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:809420kB 
> slab_unreclaimable:19312kB kernel_stack:3304kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
> pages_scanned:24 all_unreclaimable? no
> Apr  4 23:26:02 tyrex kernel: [  488.161097] lowmem_reserve[]: 0 0 17267 17267
> Apr  4 23:26:02 tyrex kernel: [  488.161101] 
> HighMem free:1606168kB min:512kB low:2836kB high:5164kB active_anon:393712kB inactive_anon:98508kB 
> active_file:16228kB inactive_file:102020kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
> present:2210252kB mlocked:0kB dirty:8kB writeback:0kB mapped:29672kB shmem:548kB slab_reclaimable:0kB 
> slab_unreclaimable:0kB kernel_stack:0kB pagetables:2500kB unstable:0kB bounce:0kB writeback_tmp:0kB 
> pages_scanned:0 all_unreclaimable? no
> Apr  4 23:26:02 tyrex kernel: [  488.161105] lowmem_reserve[]: 0 0 0 0
> Apr  4 23:26:02 tyrex kernel: [  488.161107] DMA: 18*4kB 53*8kB 31*16kB 20*32kB 14*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3552kB
> Apr  4 23:26:02 tyrex kernel: [  488.161112] Normal: 32*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3704kB
> Apr  4 23:26:02 tyrex kernel: [  488.161117] HighMem: 17*4kB 29*8kB 47*16kB 16*32kB 6*64kB 30*128kB 53*256kB 27*512kB 14*1024kB 7*2048kB 377*4096kB = 1606044kB
> Apr  4 23:26:02 tyrex kernel: [  488.161122] 29947 total pagecache pages
> Apr  4 23:26:02 tyrex kernel: [  488.161123] 0 pages in swap cache
> Apr  4 23:26:02 tyrex kernel: [  488.161124] Swap cache stats: add 0, delete 0, find 0/0
> Apr  4 23:26:02 tyrex kernel: [  488.161125] Free swap  = 2104476kB
> Apr  4 23:26:02 tyrex kernel: [  488.161126] Total swap = 2104476kB
> Apr  4 23:26:02 tyrex kernel: [  488.165523] 784224 pages RAM
> Apr  4 23:26:02 tyrex kernel: [  488.165524] 556914 pages HighMem
> Apr  4 23:26:02 tyrex kernel: [  488.165525] 12060 pages reserved
> Apr  4 23:26:02 tyrex kernel: [  488.165526] 82604 pages shared
> Apr  4 23:26:02 tyrex kernel: [  488.165527] 328045 pages non-shared
> Apr  4 23:26:02 tyrex kernel: [  488.165529] Out of memory: kill process 4788 (mysqld-max) score 326208 or a child
> Apr  4 23:26:02 tyrex kernel: [  488.165531] Killed process 4788 (mysqld-max) vsz:1304832kB, anon-rss:121428kB, file-rss:4336kB
> [...]

Oh, this is a highmem box. You ran out of low memory, I think, which
is where all the inodes are cached. Seems like a VM problem or a
highmem/lowmem split config problem to me, not anything to do with
XFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
