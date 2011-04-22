Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3MIhWr3227974 for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 13:43:32 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68330404214
	for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 11:46:59 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id PcgBJt89udNUGiSz for
	<xfs@oss.sgi.com>; Fri, 22 Apr 2011 11:46:59 -0700 (PDT)
Date: Fri, 22 Apr 2011 11:46:57 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1104221033220.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1104221142150.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
	<alpine.DEB.2.01.1104221033220.18728@trent.utfs.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Minchan Kim <minchan.kim@gmail.com>
Cc: rientjes@google.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, 22 Apr 2011 at 10:41, Christian Kujau wrote:
> It happened again, and again it's du(1) invoking the OOM killer (I'm 
> running du(1) accross a few directories every 6hrs).

Btw, xfs* showed up again in the first backtrace. This might be just 
because du(1) came across an XFS filesystem (~1TB) or it's something else:

[20546.774480] du invoked oom-killer: gfp_mask=0x842d0, order=0, oom_adj=0, oom_score_adj=0
[20546.776130] Call Trace:
[20546.777754] [ed53f9e0] [c0009ce4] show_stack+0x70/0x1bc (unreliable)
[20546.779363] [ed53fa20] [c008f508] T.528+0x74/0x1cc
[20546.780945] [ed53fa70] [c008f734] T.526+0xd4/0x2a0
[20546.782484] [ed53fab0] [c008fb7c] out_of_memory+0x27c/0x360
[20546.784028] [ed53fb00] [c0093b3c] __alloc_pages_nodemask+0x6f8/0x708
[20546.785594] [ed53fba0] [c00c00b4] new_slab+0x244/0x27c
[20546.787143] [ed53fbd0] [c00c0620] T.879+0x1cc/0x37c
[20546.788687] [ed53fbf0] [c00c08d0] kmem_cache_alloc+0x100/0x108
[20546.790244] [ed53fc10] [c01cb2b8] kmem_zone_alloc+0xa4/0x114
[20546.791780] [ed53fc40] [c01a7d58] xfs_inode_alloc+0x40/0x13c
[20546.793273] [ed53fc60] [c01a8218] xfs_iget+0x258/0x5a0
[20546.794701] [ed53fcc0] [c01c922c] xfs_lookup+0xf8/0x114
[20546.796115] [ed53fd00] [c01d70b0] xfs_vn_lookup+0x5c/0xb0
[20546.797531] [ed53fd20] [c00d14c8] d_alloc_and_lookup+0x54/0x90
[20546.798914] [ed53fd40] [c00d1d4c] do_lookup+0x248/0x2bc
[20546.800281] [ed53fd90] [c00d33cc] path_lookupat+0xfc/0x8f4
[20546.801656] [ed53fe10] [c00d3bf8] do_path_lookup+0x34/0xac
[20546.803004] [ed53fe30] [c00d53e0] user_path_at+0x64/0xb4
[20546.804336] [ed53feb0] [c00ca638] vfs_fstatat+0x58/0xbc
[20546.805682] [ed53fee0] [c00ca6c0] sys_fstatat64+0x24/0x50
[20546.807026] [ed53ff40] [c00124f4] ret_from_syscall+0x0/0x38
[20546.808380] --- Exception: c01 at 0xff4b050
[20546.808384]     LR = 0x10008cf8
[20546.811051] Mem-Info:
[20546.812324] DMA per-cpu:
[20546.813567] CPU    0: hi:  186, btch:  31 usd: 107
[20546.814819] HighMem per-cpu:
[20546.816065] CPU    0: hi:  186, btch:  31 usd:  30
[20546.817328] active_anon:8813 inactive_anon:9740 isolated_anon:0
[20546.817332]  active_file:22597 inactive_file:20784 isolated_file:0
[20546.817336]  unevictable:0 dirty:0 writeback:0 unstable:0
[20546.817340]  free:69629 slab_reclaimable:181633 slab_unreclaimable:4393
[20546.817345]  mapped:3810 shmem:169 pagetables:395 bounce:0
[20546.823525] DMA free:3536kB min:3532kB low:4412kB high:5296kB active_anon:0kB inactive_anon:0kB active_file:32kB inactive_file:256kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:780288kB mlocked:0kB dirty:0kB writeback:0kB mapped:8kB shmem:0kB slab_reclaimable:726532kB slab_unreclaimable:17572kB kernel_stack:1064kB pagetables:1580kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:449 all_unreclaimable? yes
[20546.828690] lowmem_reserve[]: 0 0 508 508
[20546.830057] HighMem free:274980kB min:508kB low:1096kB high:1684kB active_anon:35252kB inactive_anon:38960kB active_file:90356kB inactive_file:82880kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:520192kB mlocked:0kB dirty:0kB writeback:0kB mapped:15232kB shmem:676kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[20546.835656] lowmem_reserve[]: 0 0 0 0
[20546.837081] DMA: 70*4kB 295*8kB 0*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 3536kB
[20546.838629] HighMem: 4245*4kB 3604*8kB 2151*16kB 1238*32kB 736*64kB 296*128kB 96*256kB 47*512kB 17*1024kB 2*2048kB 0*4096kB = 274980kB
[20546.841678] 44154 total pagecache pages
[20546.843160] 604 pages in swap cache
[20546.844631] Swap cache stats: add 2932, delete 2328, find 417/545
[20546.846145] Free swap  = 1164320kB
[20546.847647] Total swap = 1171868kB
[20546.882384] 327680 pages RAM
[20546.883921] 131072 pages HighMem
[20546.885438] 6467 pages reserved
[20546.886903] 17653 pages shared
[20546.888362] 246912 pages non-shared

Again, full dmesg & config on: http://nerdbynature.de/bits/2.6.39-rc4/oom/

Thanks,
Christian.
-- 
BOFH excuse #158:

Defunct processes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
