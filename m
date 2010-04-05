Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35BY4P0244133 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 06:34:05 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1395B12035DA
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 04:35:51 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id DWm62abyZs8a6EWg for
	<xfs@oss.sgi.com>; Mon, 05 Apr 2010 04:35:51 -0700 (PDT)
From: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
Date: Mon, 5 Apr 2010 13:35:41 +0200
References: <201004050049.17952.hpj@urpla.net> <20100405004906.GY3335@dastard>
In-Reply-To: <20100405004906.GY3335@dastard>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201004051335.41857.hpj@urpla.net>
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
To: linux-kernel@vger.kernel.org
Cc: opensuse-kernel@opensuse.org, xfs@oss.sgi.com

On Monday 05 April 2010, 02:49:06 Dave Chinner wrote:
> On Mon, Apr 05, 2010 at 12:49:17AM +0200, Hans-Peter Jansen wrote:
> > [Sorry for the cross post, but I don't know where to start to tackle this 
> >  issue]
> > 
> > Hi,
> > 
> > on an attempt to get to a current kernel, I suffer from an issue, where a 
> > simple du on a reasonably big xfs tree leads to invoking the oom killer: 
> 
> How big is the directory tree (how many inodes, etc)?

It's 1.1 TB system backup tree, let's say: many..

> > Apr  4 23:26:02 tyrex kernel: [  488.161105] lowmem_reserve[]: 0 0 0 0
> > Apr  4 23:26:02 tyrex kernel: [  488.161107] DMA: 18*4kB 53*8kB 31*16kB 20*32kB 14*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3552kB
> > Apr  4 23:26:02 tyrex kernel: [  488.161112] Normal: 32*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3704kB
> > Apr  4 23:26:02 tyrex kernel: [  488.161117] HighMem: 17*4kB 29*8kB 47*16kB 16*32kB 6*64kB 30*128kB 53*256kB 27*512kB 14*1024kB 7*2048kB 377*4096kB = 1606044kB
> > Apr  4 23:26:02 tyrex kernel: [  488.161122] 29947 total pagecache pages
> > Apr  4 23:26:02 tyrex kernel: [  488.161123] 0 pages in swap cache
> > Apr  4 23:26:02 tyrex kernel: [  488.161124] Swap cache stats: add 0, delete 0, find 0/0
> > Apr  4 23:26:02 tyrex kernel: [  488.161125] Free swap  = 2104476kB
> > Apr  4 23:26:02 tyrex kernel: [  488.161126] Total swap = 2104476kB
> > Apr  4 23:26:02 tyrex kernel: [  488.165523] 784224 pages RAM
> > Apr  4 23:26:02 tyrex kernel: [  488.165524] 556914 pages HighMem
> > Apr  4 23:26:02 tyrex kernel: [  488.165525] 12060 pages reserved
> > Apr  4 23:26:02 tyrex kernel: [  488.165526] 82604 pages shared
> > Apr  4 23:26:02 tyrex kernel: [  488.165527] 328045 pages non-shared
> > Apr  4 23:26:02 tyrex kernel: [  488.165529] Out of memory: kill process 4788 (mysqld-max) score 326208 or a child
> > Apr  4 23:26:02 tyrex kernel: [  488.165531] Killed process 4788 (mysqld-max) vsz:1304832kB, anon-rss:121428kB, file-rss:4336kB
> > [...]
> 
> Oh, this is a highmem box. You ran out of low memory, I think, which
> is where all the inodes are cached. Seems like a VM problem or a
> highmem/lowmem split config problem to me, not anything to do with
> XFS...

Might be, I don't have a chance to test this on a different FS. Thanks
for the answer anyway, Dave. I hope, you don't mind, that I keep you 
copied on this thread.. 

This matter is, I cannot locate the problem from the syslog output. Might
be a "can't see the forest because all the trees" syndrome.

Today I repeated that thing with 2.6.24-rc3 as a pae build with openSUSE
patches applied and vm.swappiness, vm.dirty_ratio and vm.dirty_background_ratio 
reset to kernel defaults.

It behaves exactly the same, thus it looks like a generic problem. du -sh 
on the huge tree, this time gkrellmd triggered the oom killer, while the
du process kept going.

Apr  5 13:09:20 tyrex kernel: [ 1747.524375] XFS mounting filesystem sdd1
Apr  5 13:09:21 tyrex kernel: [ 1747.942048] Ending clean XFS mount for filesystem: sdd1
Apr  5 13:10:27 tyrex kernel: [ 1814.288944] oom_kill_process: 3 callbacks suppressed
Apr  5 13:10:27 tyrex kernel: [ 1814.288946] gkrellmd invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0
Apr  5 13:10:27 tyrex kernel: [ 1814.288948] gkrellmd cpuset=/ mems_allowed=0
Apr  5 13:10:27 tyrex kernel: [ 1814.288950] Pid: 4019, comm: gkrellmd Not tainted 2.6.34-rc3-13-pae #1
Apr  5 13:10:27 tyrex kernel: [ 1814.288951] Call Trace:
Apr  5 13:10:27 tyrex kernel: [ 1814.288959]  [<c0206181>] try_stack_unwind+0x1b1/0x200
Apr  5 13:10:27 tyrex kernel: [ 1814.288962]  [<c020507f>] dump_trace+0x3f/0xe0
Apr  5 13:10:27 tyrex kernel: [ 1814.288965]  [<c0205cfb>] show_trace_log_lvl+0x4b/0x60
Apr  5 13:10:27 tyrex kernel: [ 1814.288967]  [<c0205d28>] show_trace+0x18/0x20
Apr  5 13:10:27 tyrex kernel: [ 1814.288970]  [<c05ec570>] dump_stack+0x6d/0x7d
Apr  5 13:10:27 tyrex kernel: [ 1814.288974]  [<c02c758a>] dump_header+0x6a/0x1b0
Apr  5 13:10:27 tyrex kernel: [ 1814.288976]  [<c02c772a>] oom_kill_process+0x5a/0x160
Apr  5 13:10:27 tyrex kernel: [ 1814.288979]  [<c02c7bc6>] __out_of_memory+0x56/0xc0
Apr  5 13:10:27 tyrex kernel: [ 1814.288981]  [<c02c7ca7>] out_of_memory+0x77/0x1b0
Apr  5 13:10:27 tyrex kernel: [ 1814.288984]  [<c02cb07c>] __alloc_pages_slowpath+0x47c/0x4c0
Apr  5 13:10:27 tyrex kernel: [ 1814.288986]  [<c02cb214>] __alloc_pages_nodemask+0x154/0x160
Apr  5 13:10:27 tyrex kernel: [ 1814.288989]  [<c02f67a5>] alloc_pages_current+0x65/0xc0
Apr  5 13:10:27 tyrex kernel: [ 1814.288993]  [<c055ca73>] tcp_sendmsg+0x893/0x990
Apr  5 13:10:27 tyrex kernel: [ 1814.288997]  [<c05175f6>] sock_sendmsg+0xc6/0x100
Apr  5 13:10:27 tyrex kernel: [ 1814.289000]  [<c0517794>] sys_sendto+0x114/0x160
Apr  5 13:10:27 tyrex kernel: [ 1814.289002]  [<c0517817>] sys_send+0x37/0x40
Apr  5 13:10:27 tyrex kernel: [ 1814.289005]  [<c05187de>] sys_socketcall+0x22e/0x2f0
Apr  5 13:10:27 tyrex kernel: [ 1814.289007]  [<c0202e4c>] sysenter_do_call+0x12/0x22
Apr  5 13:10:27 tyrex kernel: [ 1814.289022]  [<ffffe424>] 0xffffe424
Apr  5 13:10:27 tyrex kernel: [ 1814.289023] Mem-Info:
Apr  5 13:10:27 tyrex kernel: [ 1814.289024] Node 0 DMA per-cpu:
Apr  5 13:10:27 tyrex kernel: [ 1814.289025] CPU    0: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289026] CPU    1: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289027] CPU    2: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289028] CPU    3: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289030] CPU    4: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289031] CPU    5: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289032] CPU    6: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289033] CPU    7: hi:    0, btch:   1 usd:   0
Apr  5 13:10:27 tyrex kernel: [ 1814.289033] Node 0 Normal per-cpu:
Apr  5 13:10:27 tyrex kernel: [ 1814.289035] CPU    0: hi:  186, btch:  31 usd: 183
Apr  5 13:10:27 tyrex kernel: [ 1814.289036] CPU    1: hi:  186, btch:  31 usd: 126
Apr  5 13:10:27 tyrex kernel: [ 1814.289037] CPU    2: hi:  186, btch:  31 usd:  50
Apr  5 13:10:27 tyrex kernel: [ 1814.289038] CPU    3: hi:  186, btch:  31 usd: 178
Apr  5 13:10:27 tyrex kernel: [ 1814.289039] CPU    4: hi:  186, btch:  31 usd: 158
Apr  5 13:10:27 tyrex kernel: [ 1814.289040] CPU    5: hi:  186, btch:  31 usd: 181
Apr  5 13:10:27 tyrex kernel: [ 1814.289041] CPU    6: hi:  186, btch:  31 usd:  32
Apr  5 13:10:27 tyrex kernel: [ 1814.289042] CPU    7: hi:  186, btch:  31 usd: 164
Apr  5 13:10:27 tyrex kernel: [ 1814.289043] Node 0 HighMem per-cpu:
Apr  5 13:10:27 tyrex kernel: [ 1814.289044] CPU    0: hi:  186, btch:  31 usd: 153
Apr  5 13:10:27 tyrex kernel: [ 1814.289045] CPU    1: hi:  186, btch:  31 usd: 148
Apr  5 13:10:27 tyrex kernel: [ 1814.289046] CPU    2: hi:  186, btch:  31 usd: 119
Apr  5 13:10:27 tyrex kernel: [ 1814.289047] CPU    3: hi:  186, btch:  31 usd: 173
Apr  5 13:10:27 tyrex kernel: [ 1814.289048] CPU    4: hi:  186, btch:  31 usd:  46
Apr  5 13:10:27 tyrex kernel: [ 1814.289049] CPU    5: hi:  186, btch:  31 usd: 167
Apr  5 13:10:27 tyrex kernel: [ 1814.289050] CPU    6: hi:  186, btch:  31 usd:  57
Apr  5 13:10:27 tyrex kernel: [ 1814.289051] CPU    7: hi:  186, btch:  31 usd:  52
Apr  5 13:10:27 tyrex kernel: [ 1814.289054] active_anon:145037 inactive_anon:14560 isolated_anon:0
Apr  5 13:10:27 tyrex kernel: [ 1814.289055]  active_file:4510 inactive_file:30778 isolated_file:0
Apr  5 13:10:27 tyrex kernel: [ 1814.289055]  unevictable:0 dirty:3 writeback:0 unstable:0
Apr  5 13:10:27 tyrex kernel: [ 1814.289056]  free:2694178 slab_reclaimable:183482 slab_unreclaimable:4574
Apr  5 13:10:27 tyrex kernel: [ 1814.289057]  mapped:9362 shmem:137 pagetables:994 bounce:0
Apr  5 13:10:27 tyrex kernel: [ 1814.289058] Node 0 DMA free:3488kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:20kB inactive_file:36
kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:4416kB slab_unre
claimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Apr  5 13:10:27 tyrex kernel: [ 1814.289064] lowmem_reserve[]: 0 859 12054 12054
Apr  5 13:10:27 tyrex kernel: [ 1814.289066] Node 0 Normal free:3644kB min:3716kB low:4644kB high:5572kB active_anon:0kB inactive_anon:0kB active_file:848kB inacti
ve_file:928kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:879848kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:7295
12kB slab_unreclaimable:18280kB kernel_stack:3320kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr  5 13:10:27 tyrex kernel: [ 1814.289072] lowmem_reserve[]: 0 0 89561 89561
Apr  5 13:10:27 tyrex kernel: [ 1814.289074] Node 0 HighMem free:10769580kB min:512kB low:12620kB high:24728kB active_anon:580148kB inactive_anon:58240kB active_fi
le:17172kB inactive_file:122148kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:11463844kB mlocked:0kB dirty:12kB writeback:0kB mapped:37448kB shme
m:548kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:3976kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:96 all_unreclaimable
? no
Apr  5 13:10:27 tyrex kernel: [ 1814.289080] lowmem_reserve[]: 0 0 0 0
Apr  5 13:10:27 tyrex kernel: [ 1814.289081] Node 0 DMA: 0*4kB 2*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3488kB
Apr  5 13:10:27 tyrex kernel: [ 1814.289087] Node 0 Normal: 430*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3768kB
Apr  5 13:10:27 tyrex kernel: [ 1814.289092] Node 0 HighMem: 213*4kB 619*8kB 374*16kB 15*32kB 357*64kB 413*128kB 277*256kB 80*512kB 46*1024kB 22*2048kB 2558*4096kB
 = 10769580kB
Apr  5 13:10:27 tyrex kernel: [ 1814.289097] 35438 total pagecache pages
Apr  5 13:10:27 tyrex kernel: [ 1814.289098] 0 pages in swap cache
Apr  5 13:10:27 tyrex kernel: [ 1814.289099] Swap cache stats: add 0, delete 0, find 0/0
Apr  5 13:10:27 tyrex kernel: [ 1814.289100] Free swap  = 2104476kB
Apr  5 13:10:27 tyrex kernel: [ 1814.289101] Total swap = 2104476kB
Apr  5 13:10:27 tyrex kernel: [ 1814.317335] 3380720 pages RAM
Apr  5 13:10:27 tyrex kernel: [ 1814.317337] 3154946 pages HighMem
Apr  5 13:10:27 tyrex kernel: [ 1814.317338] 293990 pages reserved
Apr  5 13:10:27 tyrex kernel: [ 1814.317338] 65372 pages shared
Apr  5 13:10:27 tyrex kernel: [ 1814.317339] 359255 pages non-shared

 0  0      0 10942040      4 776696    0    0 17512     4 2897 5178  1  7 92  0
 0  0      0 10878436      4 833952    0    0 13396     0 2330 4329  1  5 94  0
 0  0      0 10834376      4 872328    0    0 15072    32 2703 5578  0  7 92  0
 2  0      0 10834000      4 874896    0    0 11228     0 2331 5601  0  4 95  0
 0  0      0 10818628      4 875192    0    0  3172    10  773 1588  0  2 98  0
 1  0      0 10819240      4 874452    0    0  5428    69 1395 3091  0  4 96  0
 0  0      0 10818608      4 873360    0    0 17728     0 3056 10587  1 12 82  5
 1  0      0 10831032      4 873860    0    0  7732     0 1954 5411  0  4 93  3
 0  0      0 10825456      4 874208    0    0  2884     0  844 1907  1  2 98  0
 0  0      0 10831656      4 873720    0    0 11968     0 2228 6897  0  5 95  0
 0  0      0 10830760      4 873744    0    0  6424     8 1549 4021  0  3 94  3
 2  0      0 10829524      4 873944    0    0 10160    81 2129 5325  0  4 96  0
 0  0      0 10798644      4 874248    0    0  8112    16 2161 4348  1  3 96  0
 0  0      0 10781788      4 874688    0    0  5340     0 1823 2924  1  2 97  0
 0  2      0 10776580      4 875980    0    0  5964     0 1754 2722  1  4 93  1
 0  1      0 10776848      4 875440    0    0  5152     8 1543 2313  0  3 87 11
 1  1      0 10776704      4 875596    0    0  2416     0 1011 1632  0  5 79 16
 3  3      0 10776712      4 875676    0    0     0     4  749  867  0 11 75 14
 2  1      0 10879116      4 867544    0    0  7608  2138 3043 154270  7 13 77  3
 2  1      0 10874356      4 870636    0    0  2476     0 1204 711732  0 14 79  7
 3  1      0 10874248      4 870668    0    0     4     0 1078 1066604  0 14 71 14
 2  1      0 10874040      4 870668    0    0     0     0 1055 1067483  0 11 79 11
 2  1      0 10873792      4 870660    0    0   104     0 1137 1063509  0 13 73 13
 2  1      0 10873608      4 870444    0    0   324     0 1335 1055994  0 12 76 12
 3  0      0 11323756      4 421084    0    0  1768     0 1709 424405  0 16 76  7
 1  0      0 11558484      4 186672    0    0 10936   121 2212 3308  1  6 93  0
 1  0      0 11501320      4 243908    0    0 13020     0 2281 4205  0  6 93  0
 1  0      0 11413776      4 330896    0    0 19872     0 3492 6304  1  6 93  0
 0  0      0 11328588      4 415920    0    0 19568     0 3482 6139  1  8 91  0
 1  0      0 11299456      4 475428    0    0 15056     0 3054 5242  1  5 94  0

oom killer invoked around the lines with > 1000000 cs.

It's hard to believe, that a current kernel on a current system with 12 GB, 
even if using the insane pae on i586 is not able to cope with an du on a 
1.1 TB file tree. Since du is invokable by users, this creates a pretty 
ugly DOS attack for local users.

Updated boot log: ftp://urpla.net/boot-pae.msg

Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
