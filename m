Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BGEmwA161171 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 11:14:48 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFD84126E62D
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 09:22:25 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 2gJGDTzzD24GCW7R for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 09:22:25 -0700 (PDT)
Date: Thu, 11 Jun 2009 12:15:07 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
Message-ID: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

Hello,

I have a daily cron that backs up my root filesystem using xfsdump, it has 
remain unchanged for at least 7-10 kernel versions.  When I migrated to 
2.6.30, when the xfsdump ran at its scheduled time, nearly all of my 
processes were killed due to an OOM situation, I can reproduce the 
situation.

Kernel: 2.6.30
Dist: Debian Testing
xfsdump: 2.2.48-1

Full dmesg:
http://home.comcast.net/~jpiszcz/20090611/dmesg.txt

Regular boot messages:
[   12.641483] DVB: registering adapter 0 frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
[   12.647108] tda829x 1-0042: type set to tda8295
[   12.685552] tda18271 1-0060: attaching existing instance

Then I ran xfsdump:
xfsdump -e -L title -M title -f /nfs/path/root.img

Soon after:
[   94.950729] xfsdump invoked oom-killer: gfp_mask=0x2d0, order=3, oomkilladj=0
[   94.954690] Pid: 2736, comm: xfsdump Not tainted 2.6.30 #1
[   94.958662] Call Trace:
[   94.962581]  [<c0178a6c>] ? oom_kill_process+0xac/0x240
[   94.966544]  [<c017900d>] ? badness+0x17d/0x2b0
[   94.970454]  [<c0179284>] ? __out_of_memory+0x144/0x170
[   94.974351]  [<c0179304>] ? out_of_memory+0x54/0xb0
[   94.978196]  [<c017c142>] ? __alloc_pages_internal+0x442/0x480
[   94.982076]  [<c019b032>] ? cache_alloc_refill+0x2b2/0x500
[   94.985966]  [<c019b349>] ? __kmalloc+0xc9/0xd0
[   94.989846]  [<c02d6e39>] ? kmem_alloc+0x59/0xf0
[   94.993727]  [<c02d6f51>] ? kmem_zalloc+0x11/0x40
[   94.997575]  [<c029b56a>] ? xfs_getbmap+0x19a/0x7a0
[   95.001398]  [<c02928ab>] ? xfs_bmap_search_multi_extents+0x7b/0x100
[   95.005251]  [<c0292997>] ? xfs_bmap_search_extents+0x67/0x120
[   95.009075]  [<c04b3789>] ? io_schedule+0x29/0x40
[   95.012884]  [<c02dbfd0>] ? xfs_getbmapx_format+0x0/0x30
[   95.016690]  [<c04b3b0b>] ? __wait_on_bit_lock+0x5b/0x80
[   95.020502]  [<c01a01bc>] ? file_move+0x1c/0x60
[   95.024342]  [<c019d651>] ? __dentry_open+0xf1/0x2c0
[   95.028200]  [<c02dca7e>] ? xfs_ioc_getbmapx+0x6e/0x90
[   95.032076]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.035954]  [<c02ddce2>] ? xfs_file_ioctl+0x6c2/0x7d0
[   95.039835]  [<c02e0111>] ? xfs_read+0x171/0x290
[   95.043707]  [<c02b50f0>] ? xfs_iunlock+0x70/0xb0
[   95.047550]  [<c02d4192>] ? xfs_free_eofblocks+0x122/0x310
[   95.051383]  [<c02dd620>] ? xfs_file_ioctl+0x0/0x7d0
[   95.055209]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.059049]  [<c01abf8b>] ? vfs_ioctl+0x2b/0x90
[   95.062866]  [<c01ac06b>] ? do_vfs_ioctl+0x7b/0x590
[   95.066668]  [<c02f6f67>] ? _atomic_dec_and_lock+0x47/0x70
[   95.070487]  [<c01af415>] ? dput+0xd5/0x120
[   95.074231]  [<c01b54a8>] ? mntput_no_expire+0x18/0x110
[   95.077912]  [<c01ac5bd>] ? sys_ioctl+0x3d/0x70
[   95.081589]  [<c01220a1>] ? syscall_call+0x7/0xb
[   95.085252]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.088922]  [<c0120000>] ? vmx_create_vcpu+0x100/0x800
[   95.092534] Mem-Info:
[   95.096071] DMA per-cpu:
[   95.099563] CPU    0: hi:    0, btch:   1 usd:   0
[   95.103056] CPU    1: hi:    0, btch:   1 usd:   0
[   95.106458] Normal per-cpu:
[   95.109747] CPU    0: hi:  186, btch:  31 usd:   0
[   95.113018] CPU    1: hi:  186, btch:  31 usd:  24
[   95.116248] HighMem per-cpu:
[   95.119387] CPU    0: hi:  186, btch:  31 usd:   0
[   95.122488] CPU    1: hi:  186, btch:  31 usd:  29
[   95.125561] Active_anon:4735 active_file:1703 inactive_anon:972
[   95.125562]  inactive_file:376179 unevictable:0 dirty:370 writeback:0 unstable:272
[   95.125563]  free:445875 slab:202789 mapped:3133 pagetables:302 bounce:0
[   95.135127] DMA free:3764kB min:284kB low:352kB high:424kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[   95.142051] lowmem_reserve[]: 0 867 4038 4038
[   95.145533] Normal free:35440kB min:16096kB low:20120kB high:24144kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:12kB unevictable:0kB present:887976kB pages_scanned:0 all_unreclaimable? no
[   95.152926] lowmem_reserve[]: 0 0 25374 25374
[   95.156652] HighMem free:1744296kB min:512kB low:15228kB high:29948kB active_anon:18940kB inactive_anon:3888kB active_file:6812kB inactive_file:1504704kB unevictable:0kB present:3247956kB pages_scanned:0 all_unreclaimable? no
[   95.164621] lowmem_reserve[]: 0 0 0 0
[   95.168632] DMA: 7*4kB 5*8kB 7*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3764kB
[   95.172797] Normal: 1948*4kB 1448*8kB 861*16kB 12*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 35456kB
[   95.177043] HighMem: 349*4kB 3582*8kB 5821*16kB 7689*32kB 5889*64kB 3020*128kB 113*256kB 2*512kB 2*1024kB 3*2048kB 140*4096kB = 1744276kB
[   95.181388] 377922 total pagecache pages
[   95.185665] 0 pages in swap cache
[   95.189858] Swap cache stats: add 0, delete 0, find 0/0
[   95.194006] Free swap  = 2056280kB
[   95.198125] Total swap = 2056280kB
[   95.211202] 1310720 pages RAM
[   95.215282] 1082882 pages HighMem
[   95.219354] 274370 pages reserved
[   95.223398] 13360 pages shared
[   95.227421] 412265 pages non-shared
[   95.231430] Out of memory: kill process 2623 (sshd) score 2840 or a child
[   95.235525] Killed process 2624 (bash)
[   95.246873] xfsdump invoked oom-killer: gfp_mask=0x2d0, order=3, oomkilladj=0
[   95.251069] Pid: 2736, comm: xfsdump Not tainted 2.6.30 #1
[   95.255273] Call Trace:
[   95.259430]  [<c0178a6c>] ? oom_kill_process+0xac/0x240
[   95.263650]  [<c017900d>] ? badness+0x17d/0x2b0
[   95.267849]  [<c0179284>] ? __out_of_memory+0x144/0x170
[   95.272052]  [<c0179304>] ? out_of_memory+0x54/0xb0
[   95.276249]  [<c017c142>] ? __alloc_pages_internal+0x442/0x480
[   95.280467]  [<c019b032>] ? cache_alloc_refill+0x2b2/0x500
[   95.284699]  [<c019b349>] ? __kmalloc+0xc9/0xd0
[   95.288900]  [<c02d6e39>] ? kmem_alloc+0x59/0xf0
[   95.293096]  [<c02d6f51>] ? kmem_zalloc+0x11/0x40
[   95.297278]  [<c029b56a>] ? xfs_getbmap+0x19a/0x7a0
[   95.301462]  [<c02928ab>] ? xfs_bmap_search_multi_extents+0x7b/0x100
[   95.305690]  [<c0292997>] ? xfs_bmap_search_extents+0x67/0x120
[   95.309907]  [<c04b3789>] ? io_schedule+0x29/0x40
[   95.314124]  [<c02dbfd0>] ? xfs_getbmapx_format+0x0/0x30
[   95.318354]  [<c04b3b0b>] ? __wait_on_bit_lock+0x5b/0x80
[   95.322580]  [<c01a01bc>] ? file_move+0x1c/0x60
[   95.326805]  [<c019d651>] ? __dentry_open+0xf1/0x2c0
[   95.331029]  [<c02dca7e>] ? xfs_ioc_getbmapx+0x6e/0x90
[   95.335252]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.339471]  [<c02ddce2>] ? xfs_file_ioctl+0x6c2/0x7d0
[   95.343688]  [<c02e0111>] ? xfs_read+0x171/0x290
[   95.347902]  [<c02b50f0>] ? xfs_iunlock+0x70/0xb0
[   95.352106]  [<c02d4192>] ? xfs_free_eofblocks+0x122/0x310
[   95.356329]  [<c02dd620>] ? xfs_file_ioctl+0x0/0x7d0
[   95.360523]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.364744]  [<c01abf8b>] ? vfs_ioctl+0x2b/0x90
[   95.368964]  [<c01ac06b>] ? do_vfs_ioctl+0x7b/0x590
[   95.373215]  [<c02f6f67>] ? _atomic_dec_and_lock+0x47/0x70
[   95.377486]  [<c01af415>] ? dput+0xd5/0x120
[   95.381746]  [<c01b54a8>] ? mntput_no_expire+0x18/0x110
[   95.386050]  [<c01ac5bd>] ? sys_ioctl+0x3d/0x70
[   95.390346]  [<c01220a1>] ? syscall_call+0x7/0xb
[   95.394632]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.398961]  [<c0120000>] ? vmx_create_vcpu+0x100/0x800
[   95.403256] Mem-Info:
[   95.407483] DMA per-cpu:
[   95.411649] CPU    0: hi:    0, btch:   1 usd:   0
[   95.415715] CPU    1: hi:    0, btch:   1 usd:   0
[   95.419606] Normal per-cpu:
[   95.423454] CPU    0: hi:  186, btch:  31 usd:  11
[   95.427208] CPU    1: hi:  186, btch:  31 usd:  13
[   95.430786] HighMem per-cpu:
[   95.434324] CPU    0: hi:  186, btch:  31 usd: 158
[   95.437762] CPU    1: hi:  186, btch:  31 usd:   0
[   95.441028] Active_anon:3884 active_file:1703 inactive_anon:972
[   95.441029]  inactive_file:376429 unevictable:0 dirty:518 writeback:0 unstable:272
[   95.441030]  free:446299 slab:202878 mapped:3133 pagetables:302 bounce:0
[   95.450772] DMA free:3764kB min:284kB low:352kB high:424kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[   95.457350] lowmem_reserve[]: 0 867 4038 4038
[   95.460630] Normal free:35236kB min:16096kB low:20120kB high:24144kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:887976kB pages_scanned:0 all_unreclaimable? no
[   95.467655] lowmem_reserve[]: 0 0 25374 25374
[   95.471228] HighMem free:1746196kB min:512kB low:15228kB high:29948kB active_anon:15536kB inactive_anon:3888kB active_file:6812kB inactive_file:1505740kB unevictable:0kB present:3247956kB pages_scanned:0 all_unreclaimable? no
[   95.478934] lowmem_reserve[]: 0 0 0 0
[   95.482849] DMA: 7*4kB 5*8kB 7*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3764kB
[   95.486958] Normal: 1957*4kB 1449*8kB 863*16kB 2*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 35212kB
[   95.491174] HighMem: 409*4kB 3632*8kB 5839*16kB 7713*32kB 5891*64kB 3021*128kB 113*256kB 2*512kB 2*1024kB 3*2048kB 140*4096kB = 1746228kB
[   95.495476] 378156 total pagecache pages
[   95.499695] 0 pages in swap cache
[   95.503863] Swap cache stats: add 0, delete 0, find 0/0
[   95.508025] Free swap  = 2056280kB
[   95.512156] Total swap = 2056280kB
[   95.525018] 1310720 pages RAM
[   95.529107] 1082882 pages HighMem
[   95.533174] 274370 pages reserved
[   95.537230] 12393 pages shared
[   95.541262] 411399 pages non-shared
[   95.545282] Out of memory: kill process 2506 (sshd) score 2839 or a child
[   95.549384] Killed process 2508 (bash)
[   95.554123] xfsdump invoked oom-killer: gfp_mask=0x2d0, order=3, oomkilladj=0
[   95.558391] Pid: 2736, comm: xfsdump Not tainted 2.6.30 #1
[   95.562595] Call Trace:
[   95.566756]  [<c0178a6c>] ? oom_kill_process+0xac/0x240
[   95.570971]  [<c017900d>] ? badness+0x17d/0x2b0
[   95.575168]  [<c0179284>] ? __out_of_memory+0x144/0x170
[   95.579370]  [<c0179304>] ? out_of_memory+0x54/0xb0
[   95.583564]  [<c017c142>] ? __alloc_pages_internal+0x442/0x480
[   95.587778]  [<c019b032>] ? cache_alloc_refill+0x2b2/0x500
[   95.591997]  [<c019b349>] ? __kmalloc+0xc9/0xd0
[   95.596205]  [<c02d6e39>] ? kmem_alloc+0x59/0xf0
[   95.600408]  [<c02d6f51>] ? kmem_zalloc+0x11/0x40
[   95.604600]  [<c029b56a>] ? xfs_getbmap+0x19a/0x7a0
[   95.608790]  [<c02928ab>] ? xfs_bmap_search_multi_extents+0x7b/0x100
[   95.613022]  [<c0292997>] ? xfs_bmap_search_extents+0x67/0x120
[   95.617243]  [<c04b3789>] ? io_schedule+0x29/0x40
[   95.621467]  [<c02dbfd0>] ? xfs_getbmapx_format+0x0/0x30
[   95.625702]  [<c04b3b0b>] ? __wait_on_bit_lock+0x5b/0x80
[   95.629936]  [<c01a01bc>] ? file_move+0x1c/0x60
[   95.634169]  [<c019d651>] ? __dentry_open+0xf1/0x2c0
[   95.638400]  [<c02dca7e>] ? xfs_ioc_getbmapx+0x6e/0x90
[   95.642628]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.646853]  [<c02ddce2>] ? xfs_file_ioctl+0x6c2/0x7d0
[   95.651078]  [<c02e0111>] ? xfs_read+0x171/0x290
[   95.655300]  [<c02b50f0>] ? xfs_iunlock+0x70/0xb0
[   95.659511]  [<c02d4192>] ? xfs_free_eofblocks+0x122/0x310
[   95.663741]  [<c02dd620>] ? xfs_file_ioctl+0x0/0x7d0
[   95.667939]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.672165]  [<c01abf8b>] ? vfs_ioctl+0x2b/0x90
[   95.676390]  [<c01ac06b>] ? do_vfs_ioctl+0x7b/0x590
[   95.680651]  [<c02f6f67>] ? _atomic_dec_and_lock+0x47/0x70
[   95.684929]  [<c01af415>] ? dput+0xd5/0x120
[   95.689194]  [<c01b54a8>] ? mntput_no_expire+0x18/0x110
[   95.693505]  [<c01ac5bd>] ? sys_ioctl+0x3d/0x70
[   95.697806]  [<c01220a1>] ? syscall_call+0x7/0xb
[   95.702093]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.706426]  [<c0120000>] ? vmx_create_vcpu+0x100/0x800
[   95.710722] Mem-Info:
[   95.714947] DMA per-cpu:
[   95.719110] CPU    0: hi:    0, btch:   1 usd:   0
[   95.723172] CPU    1: hi:    0, btch:   1 usd:   0
[   95.727058] Normal per-cpu:
[   95.730902] CPU    0: hi:  186, btch:  31 usd:   0
[   95.734648] CPU    1: hi:  186, btch:  31 usd:   7
[   95.738221] HighMem per-cpu:
[   95.741750] CPU    0: hi:  186, btch:  31 usd:   0
[   95.745178] CPU    1: hi:  186, btch:  31 usd: 109
[   95.748434] Active_anon:3070 active_file:1777 inactive_anon:972
[   95.748435]  inactive_file:376392 unevictable:0 dirty:518 writeback:0 unstable:272
[   95.748436]  free:447166 slab:202878 mapped:3133 pagetables:277 bounce:0
[   95.758139] DMA free:3764kB min:284kB low:352kB high:424kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[   95.764686] lowmem_reserve[]: 0 867 4038 4038
[   95.767953] Normal free:35304kB min:16096kB low:20120kB high:24144kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:887976kB pages_scanned:0 all_unreclaimable? no
[   95.774949] lowmem_reserve[]: 0 0 25374 25374
[   95.778505] HighMem free:1749596kB min:512kB low:15228kB high:29948kB active_anon:12280kB inactive_anon:3888kB active_file:7108kB inactive_file:1505592kB unevictable:0kB present:3247956kB pages_scanned:0 all_unreclaimable? no
[   95.786177] lowmem_reserve[]: 0 0 0 0
[   95.790072] DMA: 7*4kB 5*8kB 7*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3764kB
[   95.794159] Normal: 1961*4kB 1445*8kB 866*16kB 6*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 35372kB
[   95.798354] HighMem: 740*4kB 3815*8kB 5877*16kB 7713*32kB 5891*64kB 3021*128kB 113*256kB 2*512kB 2*1024kB 3*2048kB 140*4096kB = 1749624kB
[   95.802636] 378181 total pagecache pages
[   95.806838] 0 pages in swap cache
[   95.810988] Swap cache stats: add 0, delete 0, find 0/0
[   95.815132] Free swap  = 2056280kB
[   95.819246] Total swap = 2056280kB
[   95.831982] 1310720 pages RAM
[   95.836054] 1082882 pages HighMem
[   95.840099] 274370 pages reserved
[   95.844136] 11446 pages shared
[   95.848146] 410690 pages non-shared
[   95.852142] ------------[ cut here ]------------
[   95.856153] WARNING: at mm/oom_kill.c:327 __oom_kill_task+0x73/0xa0()
[   95.860229] Hardware name: 
[   95.864297] Modules linked in: s5h1411 tda18271 tda8290 tuner cx25840 snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi snd_hwdep pvrusb2 dvb_core cx2341x v4l2_common pwc videodev tveeprom v4l1_compat
[   95.873044] Pid: 2736, comm: xfsdump Not tainted 2.6.30 #1
[   95.877428] Call Trace:
[   95.881772]  [<c01788c3>] ? __oom_kill_task+0x73/0xa0
[   95.886159]  [<c01788c3>] ? __oom_kill_task+0x73/0xa0
[   95.890511]  [<c01479f6>] ? warn_slowpath_common+0x76/0xd0
[   95.894866]  [<c01788c3>] ? __oom_kill_task+0x73/0xa0
[   95.899220]  [<c0147a63>] ? warn_slowpath_null+0x13/0x20
[   95.903575]  [<c01788c3>] ? __oom_kill_task+0x73/0xa0
[   95.907932]  [<c0178a01>] ? oom_kill_process+0x41/0x240
[   95.912290]  [<c017900d>] ? badness+0x17d/0x2b0
[   95.916643]  [<c0179284>] ? __out_of_memory+0x144/0x170
[   95.921017]  [<c0179304>] ? out_of_memory+0x54/0xb0
[   95.925383]  [<c017c142>] ? __alloc_pages_internal+0x442/0x480
[   95.929781]  [<c019b032>] ? cache_alloc_refill+0x2b2/0x500
[   95.934179]  [<c019b349>] ? __kmalloc+0xc9/0xd0
[   95.938564]  [<c02d6e39>] ? kmem_alloc+0x59/0xf0
[   95.942949]  [<c02d6f51>] ? kmem_zalloc+0x11/0x40
[   95.947314]  [<c029b56a>] ? xfs_getbmap+0x19a/0x7a0
[   95.951668]  [<c02928ab>] ? xfs_bmap_search_multi_extents+0x7b/0x100
[   95.956056]  [<c0292997>] ? xfs_bmap_search_extents+0x67/0x120
[   95.960430]  [<c04b3789>] ? io_schedule+0x29/0x40
[   95.964810]  [<c02dbfd0>] ? xfs_getbmapx_format+0x0/0x30
[   95.969197]  [<c04b3b0b>] ? __wait_on_bit_lock+0x5b/0x80
[   95.973593]  [<c01a01bc>] ? file_move+0x1c/0x60
[   95.977969]  [<c019d651>] ? __dentry_open+0xf1/0x2c0
[   95.982370]  [<c02dca7e>] ? xfs_ioc_getbmapx+0x6e/0x90
[   95.986782]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   95.991225]  [<c02ddce2>] ? xfs_file_ioctl+0x6c2/0x7d0
[   95.995674]  [<c02e0111>] ? xfs_read+0x171/0x290
[   96.000107]  [<c02b50f0>] ? xfs_iunlock+0x70/0xb0
[   96.004569]  [<c02d4192>] ? xfs_free_eofblocks+0x122/0x310
[   96.009042]  [<c02dd620>] ? xfs_file_ioctl+0x0/0x7d0
[   96.013496]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   96.017988]  [<c01abf8b>] ? vfs_ioctl+0x2b/0x90
[   96.022449]  [<c01ac06b>] ? do_vfs_ioctl+0x7b/0x590
[   96.026867]  [<c02f6f67>] ? _atomic_dec_and_lock+0x47/0x70
[   96.031257]  [<c01af415>] ? dput+0xd5/0x120
[   96.035513]  [<c01b54a8>] ? mntput_no_expire+0x18/0x110
[   96.039642]  [<c01ac5bd>] ? sys_ioctl+0x3d/0x70
[   96.043751]  [<c01220a1>] ? syscall_call+0x7/0xb
[   96.047727]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[   96.051573]  [<c0120000>] ? vmx_create_vcpu+0x100/0x800
[   96.055393] ---[ end trace 05f373a7e53c7489 ]---
[   96.059088] tried to kill an mm-less task!

--

I re-ran the xfsdump without having any modules loaded:

Then I ran xfsdump (again):
xfsdump -e -L title -M title -f /nfs/path/root.img

http://home.comcast.net/~jpiszcz/20090611/dmesg2.txt

dmesg:
[    1.388253] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
[    1.392302] sd 1:0:0:0: [sdb] Write Protect is off
[    1.396317] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.396329] scsi 2:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S183L SB02 PQ: 0 ANSI: 5
[    1.396331] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.396373]  sdb: sdb1
[    1.408771] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.418982] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.423106] Uniform CD-ROM driver Revision: 3.20
[    1.427232] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.610651] UDF-fs: No partition found (1)
[    1.616011] XFS mounting filesystem sda2
[    1.629087] usb 2-1: configuration #1 chosen from 1 choice
[    1.677313] Ending clean XFS mount for filesystem: sda2
[    1.677344] VFS: Mounted root (xfs filesystem) readonly on device 8:2.
[    1.681438] Freeing unused kernel memory: 316k freed
[    1.843013] usb 2-2: new low speed USB device using uhci_hcd and address 3
[    2.017021] usb 2-2: configuration #1 chosen from 1 choice
[    2.039154] input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as /class/input/input4
[    2.043605] generic-usb 0003:045E:0039.0001: input: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.0-2/input0
[    2.255013] usb 3-2: new low speed USB device using uhci_hcd and address 2
[    2.425812] usb 3-2: configuration #1 chosen from 1 choice
[    2.705758] generic-usb 0003:050D:1100.0002: hiddev96: USB HID v1.11 Device [Belkin  Belkin UPS] on usb-0000:00:1d.1-2/input0
[    2.959805] Adding 2056280k swap on /dev/sda1.  Priority:-1 extents:1 across:2056280k SS
[    4.053399] XFS mounting filesystem sdb1
[    4.173486] Ending clean XFS mount for filesystem: sdb1
[    4.472295] e1000e 0000:03:00.0: irq 30 for MSI/MSI-X
[    4.524118] e1000e 0000:03:00.0: irq 30 for MSI/MSI-X
[    7.468987] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[  123.857734] xfsdump invoked oom-killer: gfp_mask=0x2d0, order=3, oomkilladj=0
[  123.861449] Pid: 2491, comm: xfsdump Not tainted 2.6.30 #1
[  123.865191] Call Trace:
[  123.868812]  [<c0178a6c>] ? oom_kill_process+0xac/0x240
[  123.872490]  [<c017900d>] ? badness+0x17d/0x2b0
[  123.875995]  [<c0179284>] ? __out_of_memory+0x144/0x170
[  123.879524]  [<c0179304>] ? out_of_memory+0x54/0xb0
[  123.883047]  [<c017c142>] ? __alloc_pages_internal+0x442/0x480
[  123.886622]  [<c019b032>] ? cache_alloc_refill+0x2b2/0x500
[  123.890202]  [<c019b349>] ? __kmalloc+0xc9/0xd0
[  123.893771]  [<c02d6e39>] ? kmem_alloc+0x59/0xf0
[  123.897252]  [<c02d6f51>] ? kmem_zalloc+0x11/0x40
[  123.900643]  [<c029b56a>] ? xfs_getbmap+0x19a/0x7a0
[  123.904044]  [<c02928ab>] ? xfs_bmap_search_multi_extents+0x7b/0x100
[  123.907483]  [<c0292997>] ? xfs_bmap_search_extents+0x67/0x120
[  123.910914]  [<c04b3789>] ? io_schedule+0x29/0x40
[  123.914354]  [<c02dbfd0>] ? xfs_getbmapx_format+0x0/0x30
[  123.917778]  [<c04b3b0b>] ? __wait_on_bit_lock+0x5b/0x80
[  123.921182]  [<c01a01bc>] ? file_move+0x1c/0x60
[  123.924574]  [<c019d651>] ? __dentry_open+0xf1/0x2c0
[  123.927952]  [<c02dca7e>] ? xfs_ioc_getbmapx+0x6e/0x90
[  123.931325]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[  123.934679]  [<c02ddce2>] ? xfs_file_ioctl+0x6c2/0x7d0
[  123.938040]  [<c02e0111>] ? xfs_read+0x171/0x290
[  123.941421]  [<c02b50f0>] ? xfs_iunlock+0x70/0xb0
[  123.944810]  [<c02d4192>] ? xfs_free_eofblocks+0x122/0x310
[  123.948223]  [<c02dd620>] ? xfs_file_ioctl+0x0/0x7d0
[  123.951624]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[  123.955045]  [<c01abf8b>] ? vfs_ioctl+0x2b/0x90
[  123.958454]  [<c01ac06b>] ? do_vfs_ioctl+0x7b/0x590
[  123.961841]  [<c02f6f67>] ? _atomic_dec_and_lock+0x47/0x70
[  123.965221]  [<c01af415>] ? dput+0xd5/0x120
[  123.968596]  [<c01b54a8>] ? mntput_no_expire+0x18/0x110
[  123.971995]  [<c01ac5bd>] ? sys_ioctl+0x3d/0x70
[  123.975370]  [<c01220a1>] ? syscall_call+0x7/0xb
[  123.978721]  [<c0205838>] ? journal_destroy+0x148/0x1e0
[  123.982087]  [<c0120000>] ? vmx_create_vcpu+0x100/0x800
[  123.985442] Mem-Info:
[  123.988765] DMA per-cpu:
[  123.992064] CPU    0: hi:    0, btch:   1 usd:   0
[  123.995385] CPU    1: hi:    0, btch:   1 usd:   0
[  123.998622] Normal per-cpu:
[  124.001779] CPU    0: hi:  186, btch:  31 usd:   0
[  124.004945] CPU    1: hi:  186, btch:  31 usd:  25
[  124.008051] HighMem per-cpu:
[  124.011138] CPU    0: hi:  186, btch:  31 usd:   0
[  124.014257] CPU    1: hi:  186, btch:  31 usd:  58
[  124.017336] Active_anon:3977 active_file:1686 inactive_anon:822
[  124.017337]  inactive_file:367773 unevictable:0 dirty:444 writeback:0 unstable:1283
[  124.017338]  free:458376 slab:200088 mapped:3121 pagetables:272 bounce:0
[  124.026921] DMA free:3780kB min:284kB low:352kB high:424kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[  124.033860] lowmem_reserve[]: 0 867 4038 4038
[  124.037351] Normal free:46460kB min:16096kB low:20120kB high:24144kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:887976kB pages_scanned:0 all_unreclaimable? no
[  124.044760] lowmem_reserve[]: 0 0 25374 25374
[  124.048491] HighMem free:1783264kB min:512kB low:15228kB high:29948kB active_anon:15908kB inactive_anon:3288kB active_file:6744kB inactive_file:1471092kB unevictable:0kB present:3247956kB pages_scanned:0 all_unreclaimable? no
[  124.056476] lowmem_reserve[]: 0 0 0 0
[  124.060497] DMA: 9*4kB 12*8kB 12*16kB 4*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3780kB
[  124.064676] Normal: 3898*4kB 1834*8kB 885*16kB 2*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 46472kB
[  124.068914] HighMem: 872*4kB 3147*8kB 7562*16kB 8323*32kB 5774*64kB 2973*128kB 107*256kB 2*512kB 1*1024kB 3*2048kB 142*4096kB = 1783288kB
[  124.073250] 369489 total pagecache pages
[  124.077516] 0 pages in swap cache
[  124.081697] Swap cache stats: add 0, delete 0, find 0/0
[  124.085833] Free swap  = 2056280kB
[  124.089939] Total swap = 2056280kB
[  124.102973] 1310720 pages RAM
[  124.107035] 1082882 pages HighMem
[  124.111095] 274370 pages reserved
[  124.115123] 13146 pages shared
[  124.119127] 407410 pages non-shared
[  124.123114] Out of memory: kill process 2393 (sshd) score 2839 or a child
[  124.127189] Killed process 2395 (bash)

Any clues?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
