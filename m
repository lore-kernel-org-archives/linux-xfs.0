Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q953Rlld257895 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 22:27:47 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id p7Bo0J8O2pxfIuHp for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 20:29:12 -0700 (PDT)
Message-ID: <506E5408.5090707@sandeen.net>
Date: Thu, 04 Oct 2012 22:29:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel traceback from xfsdump...
References: <506D3257.1070207@tlinx.org>
In-Reply-To: <506D3257.1070207@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/4/12 1:53 AM, Linda Walsh wrote:
> These things happen once in a while...
> 
> xfsdump = v 3.0.1, kern=3.2.29
> 
> Not particularly worried -- most the time I don't notice them... just happened to be
> doing some leisure log reading...
> 
> Though I should mention it in case it's indicating the world is ending or something...
> ;-/.
> 

commit ad650f5b27bc9858360b42aaa0d9204d16115316
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Mar 7 04:50:21 2012 +0000

    xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get


It went into v3.4 upstream.

-eric

> 
> Oct  3 05:07:35 Ishtar kernel: [868029.181590] Pid: 10418, comm: xfsdump Not tainted 3.2.29-Isht-Van #1
> Oct  3 05:07:35 Ishtar kernel: [868029.181594] Call Trace:
> Oct  3 05:07:35 Ishtar kernel: [868029.181604]  [<ffffffff8111bc2d>] warn_alloc_failed+0xbd/0x150
> Oct  3 05:07:35 Ishtar kernel: [868029.181609]  [<ffffffff8111e0c0>] ? page_alloc_cpu_notify+0x50/0x50
> Oct  3 05:07:35 Ishtar kernel: [868029.181614]  [<ffffffff8111f7f8>] __alloc_pages_nodemask+0x668/0x870
> Oct  3 05:07:35 Ishtar kernel: [868029.181621]  [<ffffffff81182ae3>] ? d_obtain_alias+0x73/0x260
> Oct  3 05:07:35 Ishtar kernel: [868029.181630]  [<ffffffff81154dd1>] alloc_pages_current+0xb1/0x120
> Oct  3 05:07:35 Ishtar kernel: [868029.181635]  [<ffffffff8111b539>] __get_free_pages+0x9/0x40
> Oct  3 05:07:35 Ishtar kernel: [868029.181641]  [<ffffffff8115e1ea>] kmalloc_order_trace+0x3a/0x100
> Oct  3 05:07:35 Ishtar kernel: [868029.181647]  [<ffffffff8115e81d>] __kmalloc+0x19d/0x1b0
> Oct  3 05:07:35 Ishtar kernel: [868029.181656]  [<ffffffff812a9c4e>] xfs_attrlist_by_handle+0x8e/0x110
> Oct  3 05:07:35 Ishtar kernel: [868029.181662]  [<ffffffff812aabd5>] xfs_file_ioctl+0x715/0x990
> Oct  3 05:07:35 Ishtar kernel: [868029.181671]  [<ffffffff810abd55>] ? sched_clock_cpu+0xc5/0x120
> Oct  3 05:07:35 Ishtar kernel: [868029.181676]  [<ffffffff810abd55>] ? sched_clock_cpu+0xc5/0x120
> Oct  3 05:07:35 Ishtar kernel: [868029.181683]  [<ffffffff810b7a4e>] ? put_lock_stats.isra.21+0xe/0x40
> Oct  3 05:07:35 Ishtar kernel: [868029.181690]  [<ffffffff810b7c9c>] ? lock_release_holdtime.part.22+0xdc/0x160
> Oct  3 05:07:35 Ishtar kernel: [868029.181697]  [<ffffffff81189550>] ? clone_mnt+0x230/0x230
> Oct  3 05:07:35 Ishtar kernel: [868029.181705]  [<ffffffff81077171>] ? sub_preempt_count+0x51/0x60
> Oct  3 05:07:35 Ishtar kernel: [868029.181711]  [<ffffffff8117cc7e>] do_vfs_ioctl+0x8e/0x500
> Oct  3 05:07:35 Ishtar kernel: [868029.181716]  [<ffffffff81189bda>] ? mntput+0x1a/0x30
> Oct  3 05:07:35 Ishtar kernel: [868029.181721]  [<ffffffff8116ca43>] ? fput+0x173/0x220
> Oct  3 05:07:35 Ishtar kernel: [868029.181727]  [<ffffffff8117d181>] sys_ioctl+0x91/0xa0
> Oct  3 05:07:35 Ishtar kernel: [868029.181734]  [<ffffffff816aaebb>] system_call_fastpath+0x16/0x1b
> Oct  3 05:07:35 Ishtar kernel: [868029.181738] Mem-Info:
> Oct  3 05:07:35 Ishtar kernel: [868029.181741] Node 0 Normal per-cpu:
> Oct  3 05:07:35 Ishtar kernel: [868029.181746] CPU    0: hi:  186, btch:  31 usd: 168
> Oct  3 05:07:35 Ishtar kernel: [868029.181750] CPU    1: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181755] CPU    2: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181760] CPU    3: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181764] CPU    4: hi:  186, btch:  31 usd:  30
> Oct  3 05:07:35 Ishtar kernel: [868029.181769] CPU    5: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181772] CPU    6: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181776] CPU    7: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181779] CPU    8: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181783] CPU    9: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181787] CPU   10: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181791] CPU   11: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181795] Node 1 DMA per-cpu:
> Oct  3 05:07:35 Ishtar kernel: [868029.181799] CPU    0: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181802] CPU    1: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181806] CPU    2: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181810] CPU    3: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181814] CPU    4: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181818] CPU    5: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181820] CPU    6: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181825] CPU    7: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181829] CPU    8: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181832] CPU    9: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181836] CPU   10: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181840] CPU   11: hi:    0, btch:   1 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181844] Node 1 DMA32 per-cpu:
> Oct  3 05:07:35 Ishtar kernel: [868029.181848] CPU    0: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181852] CPU    1: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181857] CPU    2: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181861] CPU    3: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181864] CPU    4: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181868] CPU    5: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181873] CPU    6: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181877] CPU    7: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181881] CPU    8: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181885] CPU    9: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181888] CPU   10: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181892] CPU   11: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181896] Node 1 Normal per-cpu:
> Oct  3 05:07:35 Ishtar kernel: [868029.181900] CPU    0: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181904] CPU    1: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181907] CPU    2: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181911] CPU    3: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181915] CPU    4: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181919] CPU    5: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181921] CPU    6: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181925] CPU    7: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181930] CPU    8: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181933] CPU    9: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181936] CPU   10: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181940] CPU   11: hi:  186, btch:  31 usd:   0
> Oct  3 05:07:35 Ishtar kernel: [868029.181946] active_anon:1798575 inactive_anon:180175 isolated_anon:0
> Oct  3 05:07:35 Ishtar kernel: [868029.181950]  active_file:937817 inactive_file:8067246 isolated_file:0
> Oct  3 05:07:35 Ishtar kernel: [868029.181953]  unevictable:3558 dirty:546666 writeback:0 unstable:0
> Oct  3 05:07:35 Ishtar kernel: [868029.181956]  free:68778 slab_reclaimable:1019188 slab_unreclaimable:65696
> Oct  3 05:07:35 Ishtar kernel: [868029.181959]  mapped:24472 shmem:13240 pagetables:12423 bounce:0
> Oct  3 05:07:35 Ishtar kernel: [868029.181964] Node 0 Normal free:72104kB min:45076kB low:56344kB high:67612kB active_anon:3020820kB inactive_anon:329484kB active_file:1607032kB inactive_file:17308528kB unevictable:10532kB isolated(anon):0kB isolated(file):0kB present:24772608kB mlocked:10532kB dirty:300756kB writeback:0kB mapped:49252kB shmem:29916kB slab_reclaimable:1828156kB slab_unreclaimable:133364kB kernel_stack:5104kB pagetables:23828kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:34 all_unreclaimable? no
> Oct  3 05:07:35 Ishtar kernel: [868029.181986] lowmem_reserve[]: 0 0 0 0
> Oct  3 05:07:35 Ishtar kernel: [868029.181993] Node 1 DMA free:15952kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15712kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> Oct  3 05:07:35 Ishtar kernel: [868029.182012] lowmem_reserve[]: 0 3235 24151 24151
> Oct  3 05:07:35 Ishtar kernel: [868029.182020] Node 1 DMA32 free:103008kB min:6028kB low:7532kB high:9040kB active_anon:272264kB inactive_anon:66844kB active_file:246276kB inactive_file:1552524kB unevictable:552kB isolated(anon):0kB isolated(file):0kB present:3313380kB mlocked:552kB dirty:82244kB writeback:0kB mapped:1584kB shmem:120kB slab_reclaimable:1075216kB slab_unreclaimable:25644kB kernel_stack:2432kB pagetables:1212kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> Oct  3 05:07:35 Ishtar kernel: [868029.182041] lowmem_reserve[]: 0 0 20916 20916
> Oct  3 05:07:35 Ishtar kernel: [868029.182048] Node 1 Normal free:84420kB min:38972kB low:48712kB high:58456kB active_anon:3901216kB inactive_anon:324372kB active_file:1897960kB inactive_file:13407932kB unevictable:3148kB isolated(anon):0kB isolated(file):0kB present:21417984kB mlocked:3148kB dirty:1803664kB writeback:0kB mapped:47052kB shmem:22924kB slab_reclaimable:1173380kB slab_unreclaimable:103760kB kernel_stack:2312kB pagetables:24652kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> Oct  3 05:07:35 Ishtar kernel: [868029.182070] lowmem_reserve[]: 0 0 0 0
> Oct  3 05:07:35 Ishtar kernel: [868029.182077] Node 0 Normal: 15178*4kB 81*8kB 59*16kB 90*32kB 124*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 73120kB
> Oct  3 05:07:35 Ishtar kernel: [868029.182098] Node 1 DMA: 2*4kB 1*8kB 0*16kB 2*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15952kB
> Oct  3 05:07:35 Ishtar kernel: [868029.182117] Node 1 DMA32: 23550*4kB 219*8kB 147*16kB 138*32kB 9*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 103424kB
> Oct  3 05:07:35 Ishtar kernel: [868029.182136] Node 1 Normal: 14238*4kB 845*8kB 1090*16kB 82*32kB 24*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 85312kB
> Oct  3 05:07:35 Ishtar kernel: [868029.182155] 9025559 total pagecache pages
> Oct  3 05:07:35 Ishtar kernel: [868029.182158] 6729 pages in swap cache
> Oct  3 05:07:35 Ishtar kernel: [868029.182162] Swap cache stats: add 3182931, delete 3176202, find 24716112/24876063
> Oct  3 05:07:35 Ishtar kernel: [868029.182165] Free swap  = 8118348kB
> Oct  3 05:07:35 Ishtar kernel: [868029.182168] Total swap = 8393924kB
> Oct  3 05:07:35 Ishtar kernel: [868029.316121] 12582911 pages RAM
> Oct  3 05:07:35 Ishtar kernel: [868029.316125] 212769 pages reserved
> Oct  3 05:07:35 Ishtar kernel: [868029.316127] 2941502 pages shared
> Oct  3 05:07:35 Ishtar kernel: [868029.316129] 9548191 pages non-shared:0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
