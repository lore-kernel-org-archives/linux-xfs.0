Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 174377F51
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 22:53:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05F898F804C
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 20:53:24 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id PrzVhiPUsdsFGo6t (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Feb 2013 20:53:20 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	r134rHm5013636 for <xfs@oss.sgi.com>; Sat, 2 Feb 2013 20:53:19 -0800
Message-ID: <510DED3D.702@tlinx.org>
Date: Sat, 02 Feb 2013 20:53:17 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsdump -OOM triggering 'soft' kernel panic...
References: <510DDE61.6060005@tlinx.org>
In-Reply-To: <510DDE61.6060005@tlinx.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

I guess this makes sense... .. kerndump in log as well...
So here's some more... is something I should be directing to the kernel list?

I haven't seen it with any other applications...




Feb  2 06:18:28 Ishtar kernel: [990738.011852] xfsdump: page allocation failure: 
order:4, mode:0xc0d0
Feb  2 06:18:28 Ishtar kernel: [990738.011856] Pid: 14882, comm: xfsdump 
Tainted: G           O 3.7.1-Isht-Van #1
Feb  2 06:18:28 Ishtar kernel: [990738.011857] Call Trace:
Feb  2 06:18:28 Ishtar kernel: [990738.011866]  [<ffffffff810f1b1b>] 
warn_alloc_failed+0xeb/0x130
Feb  2 06:18:28 Ishtar kernel: [990738.011870]  [<ffffffff810f57d6>] 
__alloc_pages_nodemask+0x756/0x960
Feb  2 06:18:28 Ishtar kernel: [990738.011875]  [<ffffffff8115ad83>] ? 
iput+0x43/0x190
Feb  2 06:18:28 Ishtar kernel: [990738.011880]  [<ffffffff8112d37e>] 
alloc_pages_current+0xae/0x110
Feb  2 06:18:28 Ishtar kernel: [990738.011882]  [<ffffffff810f0ec9>] 
__get_free_pages+0x9/0x40
Feb  2 06:18:28 Ishtar kernel: [990738.011886]  [<ffffffff811342fa>] 
kmalloc_order_trace+0x3a/0xd0
Feb  2 06:18:28 Ishtar kernel: [990738.011889]  [<ffffffff810751e5>] ? 
sched_clock_cpu+0xc5/0x120
Feb  2 06:18:28 Ishtar kernel: [990738.011892]  [<ffffffff8113508a>] 
__kmalloc+0x17a/0x190
Feb  2 06:18:28 Ishtar kernel: [990738.011896]  [<ffffffff812851d8>] 
xfs_attrlist_by_handle+0xa8/0x130
Feb  2 06:18:28 Ishtar kernel: [990738.011899]  [<ffffffff812862ba>] 
xfs_file_ioctl+0x7fa/0xa00
Feb  2 06:18:28 Ishtar kernel: [990738.011901]  [<ffffffff810751e5>] ? 
sched_clock_cpu+0xc5/0x120
Feb  2 06:18:28 Ishtar kernel: [990738.011903]  [<ffffffff8107528f>] ? 
local_clock+0x4f/0x60
Feb  2 06:18:28 Ishtar kernel: [990738.011908]  [<ffffffff8108d19c>] ? 
lock_release_holdtime.part.21+0x1c/0x190
Feb  2 06:18:28 Ishtar kernel: [990738.011912]  [<ffffffff8117f9d5>] ? 
fsnotify+0x85/0x2f0
Feb  2 06:18:28 Ishtar kernel: [990738.011915]  [<ffffffff8117fb28>] ? 
fsnotify+0x1d8/0x2f0
Feb  2 06:18:28 Ishtar kernel: [990738.011917]  [<ffffffff8117fb52>] ? 
fsnotify+0x202/0x2f0
Feb  2 06:18:28 Ishtar kernel: [990738.011919]  [<ffffffff8117f9d5>] ? 
fsnotify+0x85/0x2f0
Feb  2 06:18:28 Ishtar kernel: [990738.011922]  [<ffffffff81151ed6>] 
do_vfs_ioctl+0x96/0x560
Feb  2 06:18:28 Ishtar kernel: [990738.011925]  [<ffffffff81152431>] 
sys_ioctl+0x91/0xb0
Feb  2 06:18:28 Ishtar kernel: [990738.011929]  [<ffffffff8133b68e>] ? 
trace_hardirqs_on_thunk+0x3a/0x3f
Feb  2 06:18:28 Ishtar kernel: [990738.011935]  [<ffffffff816a9e12>] 
system_call_fastpath+0x16/0x1b
Feb  2 06:18:28 Ishtar kernel: [990738.011937] Mem-Info:
Feb  2 06:18:28 Ishtar kernel: [990738.011938] Node 0 Normal per-cpu:
Feb  2 06:18:28 Ishtar kernel: [990738.011940] CPU    0: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011942] CPU    1: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011943] CPU    2: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011944] CPU    3: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011946] CPU    4: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011947] CPU    5: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011948] CPU    6: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011950] CPU    7: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011951] CPU    8: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011952] CPU    9: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011954] CPU   10: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011955] CPU   11: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011956] Node 1 DMA per-cpu:
Feb  2 06:18:28 Ishtar kernel: [990738.011958] CPU    0: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011959] CPU    1: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011961] CPU    2: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011962] CPU    3: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011963] CPU    4: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011965] CPU    5: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011966] CPU    6: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011967] CPU    7: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011968] CPU    8: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011970] CPU    9: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011971] CPU   10: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011972] CPU   11: hi:    0, btch:   1 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011973] Node 1 DMA32 per-cpu:
Feb  2 06:18:28 Ishtar kernel: [990738.011975] CPU    0: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011977] CPU    1: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011978] CPU    2: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011980] CPU    3: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011981] CPU    4: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011982] CPU    5: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011983] CPU    6: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011985] CPU    7: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011986] CPU    8: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011987] CPU    9: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011989] CPU   10: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011990] CPU   11: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011991] Node 1 Normal per-cpu:
Feb  2 06:18:28 Ishtar kernel: [990738.011993] CPU    0: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011994] CPU    1: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011995] CPU    2: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011997] CPU    3: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011998] CPU    4: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.011999] CPU    5: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.012001] CPU    6: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.012002] CPU    7: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.012003] CPU    8: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.012005] CPU    9: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.012006] CPU   10: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.012007] CPU   11: hi:  186, btch:  31 
usd:   0
Feb  2 06:18:28 Ishtar kernel: [990738.012010] active_anon:2130771 
inactive_anon:336859 isolated_anon:0
Feb  2 06:18:28 Ishtar kernel: [990738.012010]  active_file:100057 
inactive_file:8076638 isolated_file:0
Feb  2 06:18:28 Ishtar kernel: [990738.012010]  unevictable:4119 dirty:459152 
writeback:0 unstable:0
Feb  2 06:18:28 Ishtar kernel: [990738.012010]  free:69090 
slab_reclaimable:1184788 slab_unreclaimable:85544
Feb  2 06:18:28 Ishtar kernel: [990738.012010]  mapped:17204 shmem:6140 
pagetables:8183 bounce:0
Feb  2 06:18:28 Ishtar kernel: [990738.012010]  free_cma:0
Feb  2 06:18:28 Ishtar kernel: [990738.012013] Node 0 Normal free:82968kB 
min:45076kB low:56344kB high:67612kB active_anon:3892252kB 
inactive_anon:546760kB active_file:243676kB inactive_file:16829348kB 
unevictable:9648kB isolated(anon):0kB isolated(file):0kB present:24772608kB 
mlocked:9648kB dirty:1357160kB writeback:0kB mapped:41152kB shmem:24072kB 
slab_reclaimable:1912936kB slab_unreclaimable:224784kB kernel_stack:3328kB 
pagetables:18560kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
Feb  2 06:18:28 Ishtar kernel: [990738.012018] lowmem_reserve[]: 0 0 0 0
Feb  2 06:18:28 Ishtar kernel: [990738.012022] Node 1 DMA free:15948kB min:28kB 
low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB 
inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:15708kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB 
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Feb  2 06:18:28 Ishtar kernel: [990738.012026] lowmem_reserve[]: 0 3235 24151 24151
Feb  2 06:18:28 Ishtar kernel: [990738.012029] Node 1 DMA32 free:97280kB 
min:6028kB low:7532kB high:9040kB active_anon:545180kB inactive_anon:192576kB 
active_file:6740kB inactive_file:2048200kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:3313380kB mlocked:0kB dirty:48076kB writeback:0kB 
mapped:12kB shmem:0kB slab_reclaimable:366088kB slab_unreclaimable:7092kB 
kernel_stack:48kB pagetables:896kB unstable:0kB bounce:0kB free_cma:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb  2 06:18:28 Ishtar kernel: [990738.012034] lowmem_reserve[]: 0 0 20916 20916
Feb  2 06:18:28 Ishtar kernel: [990738.012037] Node 1 Normal free:80164kB 
min:38972kB low:48712kB high:58456kB active_anon:4085652kB 
inactive_anon:608100kB active_file:149812kB inactive_file:13429004kB 
unevictable:6828kB isolated(anon):0kB isolated(file):0kB present:21417984kB 
mlocked:6828kB dirty:431372kB writeback:0kB mapped:27652kB shmem:488kB 
slab_reclaimable:2460128kB slab_unreclaimable:110284kB kernel_stack:1312kB 
pagetables:13276kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
Feb  2 06:18:28 Ishtar kernel: [990738.012042] lowmem_reserve[]: 0 0 0 0
Feb  2 06:18:28 Ishtar kernel: [990738.012045] Node 0 Normal: 15190*4kB 674*8kB 
222*16kB 231*32kB 77*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
83176kB
Feb  2 06:18:28 Ishtar kernel: [990738.012054] Node 1 DMA: 1*4kB 1*8kB 0*16kB 
2*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15948kB
Feb  2 06:18:28 Ishtar kernel: [990738.012062] Node 1 DMA32: 12976*4kB 3609*8kB 
289*16kB 373*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
97336kB
Feb  2 06:18:28 Ishtar kernel: [990738.012071] Node 1 Normal: 8924*4kB 3469*8kB 
988*16kB 31*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 80312kB
Feb  2 06:18:28 Ishtar kernel: [990738.012079] 8184927 total pagecache pages
Feb  2 06:18:28 Ishtar kernel: [990738.012081] 800 pages in swap cache
Feb  2 06:18:28 Ishtar kernel: [990738.012082] Swap cache stats: add 10047, 
delete 9247, find 558706/558825
Feb  2 06:18:28 Ishtar kernel: [990738.012083] Free swap  = 8358172kB
Feb  2 06:18:28 Ishtar kernel: [990738.012084] Total swap = 8393924kB
Feb  2 06:18:28 Ishtar kernel: [990738.146080] 12582911 pages RAM
Feb  2 06:18:28 Ishtar kernel: [990738.146083] 227333 pages reserved
Feb  2 06:18:28 Ishtar kernel: [990738.146084] 4260752 pages shared
Feb  2 06:18:28 Ishtar kernel: [990738.146085] 8281368 pages non-shared

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
