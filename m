Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0CCE29DF8
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 20:00:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4F94304043
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 18:00:01 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id Tr1gpCD7hHWRh9CY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 17:59:58 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	r530xoi0036921 for <xfs@oss.sgi.com>; Sun, 2 Jun 2013 17:59:53 -0700
Message-ID: <51ABEA86.9060008@tlinx.org>
Date: Sun, 02 Jun 2013 17:59:50 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: latest xfsdump page allocation failure order:4 in 3.9.2
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
To: xfs-oss <xfs@oss.sgi.com>

[123342.934683] xfsdump: page allocation failure: order:4, mode:0x10c0d0
[123342.934689] Pid: 70466, comm: xfsdump Not tainted 3.9.2-Isht-Van #4
[123342.934691] Call Trace:
[123342.934701]  [<ffffffff810fdc3f>] warn_alloc_failed+0xdf/0x130
[123342.934707]  [<ffffffff815f3f90>] ? __alloc_pages_direct_compact+0x1b9/0x1ca
[123342.934711]  [<ffffffff81101a6f>] __alloc_pages_nodemask+0x81f/0xad0
[123342.934716]  [<ffffffff814dd600>] ? __dm_destroy+0x210/0x250
[123342.934720]  [<ffffffff8113c704>] alloc_pages_current+0xa4/0x160
[123342.934723]  [<ffffffff810fcf79>] __get_free_pages+0x9/0x40
[123342.934728]  [<ffffffff81143df9>] kmalloc_order_trace+0x29/0xe0
[123342.934732]  [<ffffffff811468d6>] __kmalloc+0x146/0x1a0
[123342.934737]  [<ffffffff8123e89c>] xfs_attrlist_by_handle+0x8c/0x110
[123342.934740]  [<ffffffff8123fb2d>] xfs_file_ioctl+0x8ad/0xb70
[123342.934745]  [<ffffffff810907de>] ? put_lock_stats.isra.22+0xe/0x40
[123342.934748]  [<ffffffff8109094e>] ? lock_release_holdtime.part.23+0x13e/0x180
[123342.934753]  [<ffffffff810716ed>] ? get_parent_ip+0xd/0x50
[123342.934757]  [<ffffffff81602269>] ? sub_preempt_count+0x49/0x50
[123342.934762]  [<ffffffff8106a293>] ? lg_local_unlock+0x33/0x60
[123342.934768]  [<ffffffff81173dea>] ? mntput_no_expire+0x3a/0x150
[123342.934771]  [<ffffffff811671b1>] do_vfs_ioctl+0x2d1/0x510
[123342.934774]  [<ffffffff81167471>] sys_ioctl+0x81/0xa0
[123342.934778]  [<ffffffff81605a52>] system_call_fastpath+0x16/0x1b
[123342.934780] Mem-Info:
[123342.934782] Node 0 Normal per-cpu:
[123342.934785] CPU    0: hi:  186, btch:  31 usd:   0
[123342.934787] CPU    1: hi:  186, btch:  31 usd:   0
[123342.934788] CPU    2: hi:  186, btch:  31 usd:   0
[123342.934790] CPU    3: hi:  186, btch:  31 usd:   0
[123342.934792] CPU    4: hi:  186, btch:  31 usd: 170
[123342.934793] CPU    5: hi:  186, btch:  31 usd:   0
[123342.934795] CPU    6: hi:  186, btch:  31 usd:   0
[123342.934796] CPU    7: hi:  186, btch:  31 usd:   0
[123342.934798] CPU    8: hi:  186, btch:  31 usd:   0
[123342.934799] CPU    9: hi:  186, btch:  31 usd:   0
[123342.934801] CPU   10: hi:  186, btch:  31 usd:   0
[123342.934803] CPU   11: hi:  186, btch:  31 usd:   0
[123342.934804] Node 1 DMA per-cpu:
[123342.934806] CPU    0: hi:    0, btch:   1 usd:   0
[123342.934808] CPU    1: hi:    0, btch:   1 usd:   0
[123342.934809] CPU    2: hi:    0, btch:   1 usd:   0
[123342.934811] CPU    3: hi:    0, btch:   1 usd:   0
[123342.934813] CPU    4: hi:    0, btch:   1 usd:   0
[123342.934814] CPU    5: hi:    0, btch:   1 usd:   0
[123342.934816] CPU    6: hi:    0, btch:   1 usd:   0
[123342.934817] CPU    7: hi:    0, btch:   1 usd:   0
[123342.934819] CPU    8: hi:    0, btch:   1 usd:   0
[123342.934820] CPU    9: hi:    0, btch:   1 usd:   0
[123342.934822] CPU   10: hi:    0, btch:   1 usd:   0
[123342.934823] CPU   11: hi:    0, btch:   1 usd:   0
[123342.934825] Node 1 DMA32 per-cpu:
[123342.934827] CPU    0: hi:  186, btch:  31 usd:   0
[123342.934828] CPU    1: hi:  186, btch:  31 usd:   0
[123342.934830] CPU    2: hi:  186, btch:  31 usd:   0
[123342.934832] CPU    3: hi:  186, btch:  31 usd:   0
[123342.934833] CPU    4: hi:  186, btch:  31 usd: 117
[123342.934835] CPU    5: hi:  186, btch:  31 usd:   0
[123342.934836] CPU    6: hi:  186, btch:  31 usd:   0
[123342.934838] CPU    7: hi:  186, btch:  31 usd:   0
[123342.934840] CPU    8: hi:  186, btch:  31 usd:   0
[123342.934841] CPU    9: hi:  186, btch:  31 usd:   0
[123342.934843] CPU   10: hi:  186, btch:  31 usd:   0
[123342.934844] CPU   11: hi:  186, btch:  31 usd:   0
[123342.934846] Node 1 Normal per-cpu:
[123342.934848] CPU    0: hi:  186, btch:  31 usd:   0
[123342.934850] CPU    1: hi:  186, btch:  31 usd:   0
[123342.934851] CPU    2: hi:  186, btch:  31 usd:   0
[123342.934853] CPU    3: hi:  186, btch:  31 usd:   0
[123342.934855] CPU    4: hi:  186, btch:  31 usd: 157
[123342.934856] CPU    5: hi:  186, btch:  31 usd:   0
[123342.934858] CPU    6: hi:  186, btch:  31 usd:   0
[123342.934860] CPU    7: hi:  186, btch:  31 usd:   0
[123342.934861] CPU    8: hi:  186, btch:  31 usd:   0
[123342.934863] CPU    9: hi:  186, btch:  31 usd:   0
[123342.934865] CPU   10: hi:  186, btch:  31 usd:   0
[123342.934866] CPU   11: hi:  186, btch:  31 usd:   0
[123342.934870] active_anon:1884132 inactive_anon:188556 isolated_anon:0
[123342.934870]  active_file:661673 inactive_file:8176303 isolated_file:0
[123342.934870]  unevictable:3947 dirty:102409 writeback:0 unstable:0
[123342.934870]  free:95453 slab_reclaimable:681210 slab_unreclaimable:67402
[123342.934870]  mapped:17731 shmem:57 pagetables:8826 bounce:0
[123342.934870]  free_cma:0
[123342.934874] Node 0 Normal free:139936kB min:45088kB low:56360kB high:67632kB
active_anon:3706108kB inactive_anon:305584kB active_file:2091380kB
inactive_file:15502032kB unevictable:10436kB isolated(anon):0kB
isolated(file):0kB present:25165824kB managed:24760756kB mlocked:10436kB
dirty:150208kB writeback:0kB mapped:51260kB shmem:84kB
slab_reclaimable:1533660kB slab_unreclaimable:155624kB kernel_stack:3512kB
pagetables:17236kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[123342.934879] lowmem_reserve[]: 0 0 0 0
[123342.934884] Node 1 DMA free:15964kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15996kB
managed:15964kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
[123342.934888] lowmem_reserve[]: 0 3275 24127 24127
[123342.934892] Node 1 DMA32 free:104476kB min:6104kB low:7628kB high:9156kB
active_anon:746188kB inactive_anon:149544kB active_file:74848kB
inactive_file:1922440kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
present:3378660kB managed:3354024kB mlocked:0kB dirty:28008kB writeback:0kB
mapped:740kB shmem:12kB slab_reclaimable:251092kB slab_unreclaimable:9612kB
kernel_stack:104kB pagetables:1948kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:117 all_unreclaimable? no
[123342.934897] lowmem_reserve[]: 0 0 20852 20852
[123342.934901] Node 1 Normal free:121436kB min:38884kB low:48604kB high:58324kB
active_anon:3084232kB inactive_anon:299096kB active_file:480464kB
inactive_file:15280740kB unevictable:5352kB isolated(anon):0kB
isolated(file):0kB present:21757952kB managed:21352576kB mlocked:5352kB
dirty:231420kB writeback:0kB mapped:18924kB shmem:132kB
slab_reclaimable:940088kB slab_unreclaimable:104372kB kernel_stack:1264kB
pagetables:16120kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[123342.934906] lowmem_reserve[]: 0 0 0 0
[123342.934910] Node 0 Normal: 24970*4kB (UEM) 3572*8kB (UEM) 392*16kB (UEM)
3*32kB (UEM) 5*64kB (EM) 9*128kB (UE) 3*256kB (E) 0*512kB 0*1024kB 0*2048kB
1*4096kB (R) = 141160kB
[123342.934927] Node 1 DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 2*32kB (U) 2*64kB (U)
1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15964kB
[123342.934944] Node 1 DMA32: 6157*4kB (UEM) 3857*8kB (UEM) 3021*16kB (UEM)
1*32kB (R) 1*64kB (R) 0*128kB 2*256kB (R) 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB
= 104940kB
[123342.934959] Node 1 Normal: 5182*4kB (UEM) 8042*8kB (UEM) 2039*16kB (UEM)
63*32kB (UMR) 5*64kB (UMR) 2*128kB (R) 0*256kB 1*512kB (R) 1*1024kB (R) 1*2048kB
(R) 0*4096kB = 123864kB
[123342.934976] 8838767 total pagecache pages
[123342.934978] 0 pages in swap cache
[123342.934979] Swap cache stats: add 0, delete 0, find 0/0
[123342.934981] Free swap  = 8393924kB
[123342.934982] Total swap = 8393924kB
[123343.077199] 12582911 pages RAM
[123343.077203] 210597 pages reserved
[123343.077204] 5179364 pages shared
[123343.077205] 8018638 pages non-shared
----
and 19 more in 2days+22:44 uptime

Trying to get clear about this....this is an error in the driver, not in xfsdump, or
does xfsdump have a problem?  If that's the case, does it only have problems
because it is
run w/root privs?   I.e. -- an unpriviledged user wouldn't see these?

Thanks, sorry to keep coming up w/these... but assume you'd rather know than not...





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
