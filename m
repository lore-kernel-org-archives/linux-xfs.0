Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 May 2008 01:47:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m478lYZW026899
	for <xfs@oss.sgi.com>; Wed, 7 May 2008 01:47:38 -0700
Received: from bay0-omc2-s24.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 045EBB262D1
	for <xfs@oss.sgi.com>; Wed,  7 May 2008 01:48:15 -0700 (PDT)
Received: from bay0-omc2-s24.bay0.hotmail.com (bay0-omc2-s24.bay0.hotmail.com [65.54.246.160]) by cuda.sgi.com with ESMTP id oj8GmTt2kspOQsxJ for <xfs@oss.sgi.com>; Wed, 07 May 2008 01:48:15 -0700 (PDT)
Message-ID: <BAY103-DAV123AC09B128545C82CF809B2D10@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com>
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Date: Wed, 7 May 2008 10:45:44 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

just few minutes ago another error. However this
time no xfs crash (I have taken an xfs_metadump and
then I have run xfs_repair no errors detected), but
squid was unable to clean cache:

2008/05/07 09:21:05| diskHandleWrite: FD 120: disk write error: (28) No
space left on device
2008/05/07 09:21:05| storeUfsWriteDone: got failure (-6)
2008/05/07 09:21:05| storeSwapOutFileClosed: dirno 0, swapfile 00012D2D,
errflag=-6
 (28) No space left on device
2008/05/07 09:21:05| WARNING: Shrinking cache_dir #0 to 1183828 KB
2008/05/07 09:21:06| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=125: (1) Operation not permitted
2008/05/07 09:21:06| diskHandleWrite: FD 120: disk write error: (28) No
space left on device
2008/05/07 09:21:06| storeUfsWriteDone: got failure (-6)
2008/05/07 09:21:06| storeSwapOutFileClosed: dirno 0, swapfile 00012D2E,
errflag=-6
 (28) No space left on device
2008/05/07 09:21:06| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=117: (1) Operation not permitted
2008/05/07 09:21:06| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=108: (1) Operation not permitted
2008/05/07 09:44:28| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=155: (1) Operation not permitted
2008/05/07 09:44:48| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=89: (1) Operation not permitted
2008/05/07 09:44:56| diskHandleWrite: FD 73: disk write error: (28) No
space left on device
2008/05/07 09:44:56| storeUfsWriteDone: got failure (-6)
2008/05/07 09:44:56| storeSwapOutFileClosed: dirno 0, swapfile 0001377E,
errflag=-6
 (28) No space left on device
2008/05/07 09:44:56| WARNING: Shrinking cache_dir #0 to 1065440 KB
2008/05/07 09:44:56| diskHandleWrite: FD 73: disk write error: (28) No
space left on device
2008/05/07 09:44:56| storeUfsWriteDone: got failure (-6)
2008/05/07 09:44:56| storeSwapOutFileClosed: dirno 0, swapfile 0001377F,
errflag=-6
 (28) No space left on device
2008/05/07 09:44:56| diskHandleWrite: FD 73: disk write error: (28) No
space left on device
2008/05/07 09:44:56| storeUfsWriteDone: got failure (-6)
2008/05/07 09:44:56| storeSwapOutFileClosed: dirno 0, swapfile 00013780,
errflag=-6
 (28) No space left on device
2008/05/07 09:44:56| diskHandleWrite: FD 73: disk write error: (28) No
space left on device
2008/05/07 09:44:56| storeUfsWriteDone: got failure (-6)
2008/05/07 09:44:56| storeSwapOutFileClosed: dirno 0, swapfile 00013781,
errflag=-6
 (28) No space left on device

2008/05/07 10:36:49| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=162: (1) Operation not permitted
2008/05/07 10:37:00| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=123: (1) Operation not permitted
2008/05/07 10:37:00| commSetEvents: epoll_ctl(EPOLL_CTL_ADD): failed on
fd=104: (1) Operation not permitted
2008/05/07 10:37:10| diskHandleWrite: FD 189: disk write error: (28) No
space left on device
2008/05/07 10:37:10| storeUfsWriteDone: got failure (-6)
2008/05/07 10:37:10| storeSwapOutFileClosed: dirno 0, swapfile 00000C53,
errflag=-6
 (28) No space left on device
2008/05/07 10:37:10| WARNING: Shrinking cache_dir #0 to 1017288 KB
2008/05/07 10:37:10| diskHandleWrite: FD 189: disk write error: (28) No
space left on device
2008/05/07 10:37:10| storeUfsWriteDone: got failure (-6)
2008/05/07 10:37:10| storeSwapOutFileClosed: dirno 0, swapfile 00000C54,
errflag=-6
 (28) No space left on device
2008/05/07 10:37:10| diskHandleWrite: FD 88: disk write error: (28) No
space left on device
2008/05/07 10:37:10| storeUfsWriteDone: got failure (-6)
2008/05/07 10:37:10| storeSwapOutFileClosed: dirno 0, swapfile 00000C55,
errflag=-6
 (28) No space left on device

May  7 09:44:57 Pleiadi kernel: printk: 103 messages suppressed.
May  7 09:44:57 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:44:57 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:44:57 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:44:57 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:57 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:44:57 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  7 09:44:57 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0296400>]
neigh_periodic_timer+0x0/0x120
May  7 09:44:57 Pleiadi kernel:  [<c011f253>]
run_timer_softirq+0x93/0x150
May  7 09:44:57 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:57 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:57 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:57 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:57 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:44:57 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:44:57 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:44:57 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:44:57 Pleiadi kernel:  =======================
May  7 09:44:57 Pleiadi kernel: Mem-info:
May  7 09:44:57 Pleiadi kernel: DMA per-cpu:
May  7 09:44:57 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:57 Pleiadi kernel: Normal per-cpu:
May  7 09:44:57 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  20
May  7 09:44:57 Pleiadi kernel: Active:28761 inactive:6843 dirty:46
writeback:0 unstable:0
May  7 09:44:57 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:57 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:57 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:57 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
high:2172kB active:109116kB inactive:22384kB present:146304kB
pages_scanned:43 all_unreclaimable? no
May  7 09:44:57 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:57 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
May  7 09:44:57 Pleiadi kernel: Normal: 441*4kB 17*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2156kB
May  7 09:44:57 Pleiadi kernel: 7028 total pagecache pages
May  7 09:44:57 Pleiadi kernel: Swap cache: add 3187137, delete 3181047,
find 266145/761335
May  7 09:44:57 Pleiadi kernel: Free swap  = 109020kB
May  7 09:44:57 Pleiadi kernel: Total swap = 151160kB
May  7 09:44:57 Pleiadi kernel: Free swap:       109020kB
May  7 09:44:57 Pleiadi kernel: 40960 pages of RAM
May  7 09:44:57 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:44:57 Pleiadi kernel: 1202 reserved pages
May  7 09:44:57 Pleiadi kernel: 3469 pages shared
May  7 09:44:57 Pleiadi kernel: 6090 pages swap cached
May  7 09:44:57 Pleiadi kernel: 46 pages dirty
May  7 09:44:57 Pleiadi kernel: 0 pages writeback
May  7 09:44:57 Pleiadi kernel: 384 pages mapped
May  7 09:44:57 Pleiadi kernel: 2275 pages slab
May  7 09:44:57 Pleiadi kernel: 300 pages pagetables
May  7 09:44:57 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:44:57 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:44:57 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:44:57 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  7 09:44:57 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0296400>]
neigh_periodic_timer+0x0/0x120
May  7 09:44:57 Pleiadi kernel:  [<c011f253>]
run_timer_softirq+0x93/0x150
May  7 09:44:57 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:57 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:57 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:57 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:57 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:44:57 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:44:57 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:44:57 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:44:57 Pleiadi kernel:  =======================
May  7 09:44:57 Pleiadi kernel: Mem-info:
May  7 09:44:57 Pleiadi kernel: DMA per-cpu:
May  7 09:44:57 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:57 Pleiadi kernel: Normal per-cpu:
May  7 09:44:57 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  19
May  7 09:44:57 Pleiadi kernel: Active:28761 inactive:6843 dirty:46
writeback:0 unstable:0
May  7 09:44:57 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:57 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:57 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:57 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
 high:2172kB active:109116kB inactive:22384kB present:146304kB
pages_scanned:43 all_unreclaimable? no
May  7 09:44:57 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:57 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*10240/0x430 [3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c01438fc>]
shrink_page_list+0x34c/0x430
May  7 09:44:57 Pleiadi kernel:  [<c01123fa>] __dequeue_entity+0x5a/0xb0
May  7 09:44:57 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:57 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:57 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:57 Pleiadi kernel:  [<c030ab2f>] schedule_timeout+0x4f/0x90
May  7 09:44:57 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:57 Pleiadi kernel:  [<c014324d>] shrink_slab+0x14d/0x1b0
May  7 09:44:57 Pleiadi kernel:  [<c0144971>] balance_pgdat+0x211/0x360
May  7 09:44:57 Pleiadi kernel:  [<c01135a5>] dequeue_task+0x15/0x30
May  7 09:44:57 Pleiadi kernel:  [<c0143c00>]
isolate_pages_global+0x0/0x80
May  7 09:44:57 Pleiadi kernel:  [<c0128263>] finish_wait+0x3/0x50
May  7 09:44:57 Pleiadi kernel:  [<c0144b49>] kswapd+0x89/0xc0
May  7 09:44:57 Pleiadi kernel:  [<c01282b0>]
autoremove_wake_function+0x0/0x50
May  7 09:44:57 Pleiadi kernel:  [<c01282b0>]
autoremove_wake_function+0x0/0x50
May  7 09:44:57 Pleiadi kernel:  [<c0144ac0>] kswapd+0x0/0xc0
May  7 09:44:57 Pleiadi kernel:  [<c0127e48>] kthread+0x58/0xa0
May  7 09:44:57 Pleiadi kernel:  [<c0127df0>] kthread+0x0/0xa0
May  7 09:44:57 Pleiadi kernel:  [<c01038c3>]
kernel_thread_helper+0x7/0x14
May  7 09:44:57 Pleiadi kernel:  =======================
May  7 09:44:57 Pleiadi kernel: Mem-info:
May  7 09:44:57 Pleiadi kernel: DMA per-cpu:
May  7 09:44:57 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:57 Pleiadi kernel: Normal per-cpu:
May  7 09:44:57 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  15
May  7 09:44:57 Pleiadi kernel: Active:28761 inactive:6844 dirty:46
writeback:0 unstable:0
May  7 09:44:57 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:57 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:57 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:57 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
high:2172kB active:109116kB inactive:22388kB present:146304kB
pages_scanned:43 all_unreclaimable? no
May  7 09:44:57 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:57 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
May  7 09:44:57 Pleiadi kernel: Normal: 441*4kB 17*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2156kB
May  7 09:44:57 Pleiadi kernel: 7029 total pagecache pages
May  7 09:44:57 Pleiadi kernel: Swap cache: add 3187138, delete 3181047,
find 266145/761336
May  7 09:44:57 Pleiadi kernel: Free swap  = 109020kB
May  7 09:44:57 Pleiadi kernel: Total swap = 151160kB
May  7 09:44:57 Pleiadi kernel: Free swap:       109020kB
May  7 09:44:57 Pleiadi kernel: 40960 pages of RAM
May  7 09:44:57 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:44:57 Pleiadi kernel: 1202 reserved pages
May  7 09:44:57 Pleiadi kernel: 3468 pages shared
May  7 09:44:57 Pleiadi kernel: 6091 pages swap cached
May  7 09:44:57 Pleiadi kernel: 46 pages dirty
May  7 09:44:57 Pleiadi kernel: 0 pages writeback
May  7 09:44:57 Pleiadi kernel: 384 pages mapped
May  7 09:44:57 Pleiadi kernel: 2275 pages slab
May  7 09:44:57 Pleiadi kernel: 300 pages pagetables
May  7 09:44:57 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:44:57 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:44:57 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:44:57 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:57 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:44:57 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:44:57 Pleiadi kernel:  [<c02b6ed9>]
ip_forward_finish+0x19/0x30
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:57 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  7 09:44:57 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:57 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  7 09:44:57 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:57 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:44:58 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:44:58 Pleiadi kernel:  =======================
May  7 09:44:58 Pleiadi kernel: Mem-info:
May  7 09:44:58 Pleiadi kernel: DMA per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:58 Pleiadi kernel: Normal per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  22
May  7 09:44:58 Pleiadi kernel: Active:28813 inactive:6785 dirty:46
writeback:0 unstable:0
May  7 09:44:58 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:58 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:58 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
high:2172kB active:109324kB inactive:22152kB present:146304kB
pages_scanned:345 all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:58 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
May  7 09:44:58 Pleiadi kernel: Normal: 441*4kB 17*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2156kB
May  7 09:44:58 Pleiadi kernel: 7021 total pagecache pages
May  7 09:44:58 Pleiadi kernel: Swap cache: add 3187147, delete 3181064,
find 266145/761338
May  7 09:44:58 Pleiadi kernel: Free swap  = 109020kB
May  7 09:44:58 Pleiadi kernel: Total swap = 151160kB
May  7 09:44:58 Pleiadi kernel: Free swap:       109020kB
May  7 09:44:58 Pleiadi kernel: 40960 pages of RAM
May  7 09:44:58 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:44:58 Pleiadi kernel: 1202 reserved pages
May  7 09:44:58 Pleiadi kernel: 3468 pages shared
May  7 09:44:58 Pleiadi kernel: 6083 pages swap cached
May  7 09:44:58 Pleiadi kernel: 46 pages dirty
May  7 09:44:58 Pleiadi kernel: 0 pages writeback
May  7 09:44:58 Pleiadi kernel: 384 pages mapped
May  7 09:44:58 Pleiadi kernel: 2275 pages slab
May  7 09:44:58 Pleiadi kernel: 300 pages pagetables
May  7 09:44:58 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:44:58 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:44:58 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:44:58 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:44:58 Pleiadi kernel:  [<c02f1d4b>] xfrm_lookup+0x1b/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0156a60>] __kmalloc+0xf0/0x100
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c02b7176>] ip_forward+0x286/0x350
May  7 09:44:58 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  7 09:44:58 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  7 09:44:58 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  7 09:44:58 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  7 09:44:58 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:44:58 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:44:58 Pleiadi kernel:  =======================
May  7 09:44:58 Pleiadi kernel: Mem-info:
May  7 09:44:58 Pleiadi kernel: DMA per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:58 Pleiadi kernel: Normal per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  21
May  7 09:44:58 Pleiadi kernel: Active:28813 inactive:6785 dirty:46
writeback:0 unstable:0
May  7 09:44:58 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:58 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:58 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
high:2172kB active:109324kB inactive:22152kB present:146304kB
pages_scanned:345 all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:58 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
May  7 09:44:58 Pleiadi kernel: Normal: 441*4kB 17*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2156kB
May  7 09:44:58 Pleiadi kernel: 7021 total pagecache pages
May  7 09:44:58 Pleiadi kernel: Swap cache: add 3187147, delete 3181064,
find 266145/761338
May  7 09:44:58 Pleiadi kernel: Free swap  = 109020kB
May  7 09:44:58 Pleiadi kernel: Total swap = 151160kB
May  7 09:44:58 Pleiadi kernel: Free swap:       109020kB
May  7 09:44:58 Pleiadi kernel: 40960 pages of RAM
May  7 09:44:58 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:44:58 Pleiadi kernel: 1202 reserved pages
May  7 09:44:58 Pleiadi kernel: 3468 pages shared
May  7 09:44:58 Pleiadi kernel: 6083 pages swap cached
May  7 09:44:58 Pleiadi kernel: 46 pages dirty
May  7 09:44:58 Pleiadi kernel: 0 pages writeback
May  7 09:44:58 Pleiadi kernel: 384 pages mapped
May  7 09:44:58 Pleiadi kernel: 2275 pages slab
May  7 09:44:58 Pleiadi kernel: 300 pages pagetables
May  7 09:44:58 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:44:58 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:44:58 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c02f007b>] xfrm_spd_getinfo+0xb/0x50
May  7 09:44:58 Pleiadi kernel:  [<c01569cc>] __kmalloc+0x5c/0x100
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c02b7176>] ip_forward+0x286/0x350
May  7 09:44:58 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  7 09:44:58 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  7 09:44:58 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  7 09:44:58 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  7 09:44:58 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:44:58 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:44:58 Pleiadi kernel:  =======================
May  7 09:44:58 Pleiadi kernel: Mem-info:
May  7 09:44:58 Pleiadi kernel: DMA per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:58 Pleiadi kernel: Normal per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  20
May  7 09:44:58 Pleiadi kernel: Active:28813 inactive:6785 dirty:46
writeback:0 unstable:0
May  7 09:44:58 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:58 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:58 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
high:2172kB active:109324kB inactive:22152kB present:146304kB
pages_scanned:345 all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:58 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
May  7 09:44:58 Pleiadi kernel: Normal: 441*4kB 17*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2156kB
May  7 09:44:58 Pleiadi kernel: 7021 total pagecache pages
May  7 09:44:58 Pleiadi kernel: Swap cache: add 3187147, delete 3181064,
 find 266145/761338
May  7 09:44:58 Pleiadi kernel: Free swap  = 109020kB
May  7 09:44:58 Pleiadi kernel: Total swap = 151160kB
May  7 09:44:58 Pleiadi kernel: Free swap:       109020kB
May  7 09:44:58 Pleiadi kernel: 40960 pages of RAM
May  7 09:44:58 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:44:58 Pleiadi kernel: 1202 reserved pages
May  7 09:44:58 Pleiadi kernel: 3468 pages shared
May  7 09:44:58 Pleiadi kernel: 6083 pages swap cached
May  7 09:44:58 Pleiadi kernel: 46 pages dirty
May  7 09:44:58 Pleiadi kernel: 0 pages writeback
May  7 09:44:58 Pleiadi kernel: 384 pages mapped
May  7 09:44:58 Pleiadi kernel: 2275 pages slab
May  7 09:44:58 Pleiadi kernel: 300 pages pagetables
May  7 09:44:58 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:44:58 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:44:58 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  7 09:44:58 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c01185ad>] profile_tick+0x4d/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c015709a>]
__kmalloc_track_caller+0x5a/0x100
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c02f007b>] xfrm_spd_getinfo+0xb/0x50
May  7 09:44:58 Pleiadi kernel:  [<c01569cc>] __kmalloc+0x5c/0x100
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c02b7176>] ip_forward+0x286/0x350
May  7 09:44:58 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  7 09:44:58 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  7 09:44:58 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  7 09:44:58 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  7 09:44:58 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:44:58 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:44:58 Pleiadi kernel:  =======================
May  7 09:44:58 Pleiadi kernel: Mem-info:
May  7 09:44:58 Pleiadi kernel: DMA per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:58 Pleiadi kernel: Normal per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  19
May  7 09:44:58 Pleiadi kernel: Active:28813 inactive:6785 dirty:46
writeback:0 unstable:0
May  7 09:44:58 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:58 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:58 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
high:2172kB active:109324kB inactive:22152kB present:146304kB
pages_scanned:345 all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:58 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
May  7 09:44:58 Pleiadi kernel: Normal: 441*4kB 17*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2156kB
May  7 09:44:58 Pleiadi kernel: 7021 total pagecache pages
May  7 09:44:58 Pleiadi kernel: Swap cache: add 3187147, delete 3181064,
find 266145/761338
May  7 09:44:58 Pleiadi kernel: Free swap  = 109020kB
May  7 09:44:58 Pleiadi kernel: Total swap = 151160kB
May  7 09:44:58 Pleiadi kernel: Free swap:       109020kB
May  7 09:44:58 Pleiadi kernel: 40960 pages of RAM
May  7 09:44:58 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:44:58 Pleiadi kernel: 1202 reserved pages
May  7 09:44:58 Pleiadi kernel: 3468 pages shared
May  7 09:44:58 Pleiadi kernel: 6083 pages swap cached
May  7 09:44:58 Pleiadi kernel: 46 pages dirty
May  7 09:44:58 Pleiadi kernel: 0 pages writeback
May  7 09:44:58 Pleiadi kernel: 384 pages mapped
May  7 09:44:58 Pleiadi kernel: 2275 pages slab
May  7 09:44:58 Pleiadi kernel: 300 pages pagetables
May  7 09:44:58 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:44:58 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:44:58 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:44:58 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:44:58 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:44:58 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:44:58 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c02f007b>] xfrm_spd_getinfo+0xb/0x50
May  7 09:44:58 Pleiadi kernel:  [<c01569cc>] __kmalloc+0x5c/0x100
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c028a700>]
pskb_expand_head+0x50/0x170
May  7 09:44:58 Pleiadi kernel:  [<c02b7176>] ip_forward+0x286/0x350
May  7 09:44:58 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  7 09:44:58 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  7 09:44:58 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  7 09:44:58 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  7 09:44:58 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  7 09:44:58 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  7 09:44:58 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  7 09:44:58 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:44:58 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:44:58 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:44:58 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:44:58 Pleiadi kernel:  =======================
May  7 09:44:58 Pleiadi kernel: Mem-info:
May  7 09:44:58 Pleiadi kernel: DMA per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:44:58 Pleiadi kernel: Normal per-cpu:
May  7 09:44:58 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  18
May  7 09:44:58 Pleiadi kernel: Active:28813 inactive:6785 dirty:46
writeback:0 unstable:0
May  7 09:44:58 Pleiadi kernel:  free:734 slab:2275 mapped:384
pagetables:300 bounce:0
May  7 09:44:58 Pleiadi kernel: DMA free:780kB min:160kB low:200kB
high:240kB active:5928kB inactive:4988kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:44:58 Pleiadi kernel: Normal free:2156kB min:1448kB low:1808kB
high:2172kB active:109324kB inactive:22152kB present:146304kB
pages_scanned:345 all_unreclaimable? no
May  7 09:44:58 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:44:58 Pleiadi kernel: DMA: 165*4kB 9*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
May  7 09:44:58 Pleiadi kernel: Normal: 441*4kB 17*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2156kB
May  7 09:44:58 Pleiadi kernel: 7021 total pagecache pages
May  7 09:44:58 Pleiadi kernel: Swap cache: add 3187147, delete 3181064,
find 266145/761338
May  7 09:44:58 Pleiadi kernel: Free swap  = 109020kB
May  7 09:44:58 Pleiadi kernel: Total swap = 151160kB
May  7 09:44:58 Pleiadi kernel: Free swap:       109020kB
May  7 09:44:58 Pleiadi kernel: 40960 pages of RAM
May  7 09:44:58 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:44:58 Pleiadi kernel: 1202 reserved pages
May  7 09:44:58 Pleiadi kernel: 3468 pages shared
May  7 09:44:58 Pleiadi kernel: 6083 pages swap cached
May  7 09:44:58 Pleiadi kernel: 46 pages dirty
May  7 09:44:58 Pleiadi kernel: 0 pages writeback
May  7 09:44:58 Pleiadi kernel: 384 pages mapped
May  7 09:44:58 Pleiadi kernel: 2275 pages slab
May  7 09:44:58 Pleiadi kernel: 300 pages pagetables
May  7 09:48:55 Pleiadi kernel: 1daa>] xfs_trans_log_buf+0x5a/0x90
May  7 09:49:01 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:49:01 Pleiadi kernel:  [<c01d3b9f>] xlog_write+0x1af/0x4d0
May  7 09:49:01 Pleiadi kernel:  [<c01d294d>] xfs_log_write+0x3d/0x70
May  7 09:49:01 Pleiadi kernel:  [<c01e0768>]
_xfs_trans_commit+0xe8/0x340
May  7 09:49:01 Pleiadi kernel:  [<c01a92fb>]
xfs_bmap_finish+0x11b/0x170
May  7 09:49:01 Pleiadi kernel:  [<c01eb466>] kmem_zone_zalloc+0x26/0x50
May  7 09:49:01 Pleiadi kernel:  [<c01ca0b0>]
xfs_itruncate_finish+0x180/0x420
May  7 09:49:01 Pleiadi kernel:  [<c01e2358>] xfs_trans_ijoin+0x28/0x70
May  7 09:49:01 Pleiadi kernel:  [<c01e6f88>] xfs_inactive+0x438/0x4b0
May  7 09:49:01 Pleiadi kernel:  [<c0181d38>]
inotify_inode_is_dead+0x18/0x80
May  7 09:49:01 Pleiadi kernel:  [<c01f4f26>]
xfs_fs_clear_inode+0x36/0x80
May  7 09:49:01 Pleiadi kernel:  [<c01798fa>]
invalidate_inode_buffers+0xa/0x80
May  7 09:49:02 Pleiadi kernel:  [<c016c654>] clear_inode+0xa4/0xf0
May  7 09:49:02 Pleiadi kernel:  [<c016d1a2>]
generic_delete_inode+0xa2/0xb0
May  7 09:49:02 Pleiadi kernel:  [<c016d343>] iput+0x53/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0163e86>] do_unlinkat+0xc6/0x120
May  7 09:49:02 Pleiadi kernel:  [<c015a7d0>] vfs_read+0xe0/0x140
May  7 09:49:02 Pleiadi kernel:  [<c015aac1>] sys_read+0x41/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0102daa>] syscall_call+0x7/0xb
May  7 09:49:02 Pleiadi kernel:  =======================
May  7 09:49:02 Pleiadi kernel: Mem-info:
May  7 09:49:02 Pleiadi kernel: DMA per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:49:02 Pleiadi kernel: Normal per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  20
May  7 09:49:02 Pleiadi kernel: Active:34425 inactive:1103 dirty:40
writeback:0 unstable:0
May  7 09:49:02 Pleiadi kernel:  free:730 slab:2351 mapped:323
pagetables:301 bounce:0
May  7 09:49:02 Pleiadi kernel: DMA free:936kB min:160kB low:200kB
high:240kB active:10072kB inactive:380kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:49:02 Pleiadi kernel: Normal free:1984kB min:1448kB low:1808kB
high:2172kB active:127628kB inactive:4032kB present:146304kB
pages_scanned:1897 all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:49:02 Pleiadi kernel: DMA: 110*4kB 34*8kB 12*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 936kB
May  7 09:49:02 Pleiadi kernel: Normal: 408*4kB 12*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1984kB
May  7 09:49:02 Pleiadi kernel: 12198 total pagecache pages
May  7 09:49:02 Pleiadi kernel: Swap cache: add 3219731, delete 3208124,
find 277400/779926
May  7 09:49:02 Pleiadi kernel: Free swap  = 82100kB
May  7 09:49:02 Pleiadi kernel: Total swap = 151160kB
May  7 09:49:02 Pleiadi kernel: Free swap:        82100kB
May  7 09:49:02 Pleiadi kernel: 40960 pages of RAM
May  7 09:49:02 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:49:02 Pleiadi kernel: 1202 reserved pages
May  7 09:49:02 Pleiadi kernel: 4626 pages shared
May  7 09:49:02 Pleiadi kernel: 11607 pages swap cached
May  7 09:49:02 Pleiadi kernel: 40 pages dirty
May  7 09:49:02 Pleiadi kernel: 0 pages writeback
May  7 09:49:02 Pleiadi kernel: 323 pages mapped
May  7 09:49:02 Pleiadi kernel: 2351 pages slab
May  7 09:49:02 Pleiadi kernel: 301 pages pagetables
May  7 09:49:02 Pleiadi kernel: unlinkd: page allocation failure.
order:3, mode:0x4020
May  7 09:49:02 Pleiadi kernel: Pid: 3333, comm: unlinkd Not tainted
2.6.25 #1
May  7 09:49:02 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:49:02 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:49:02 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e1daa>]
xfs_trans_log_buf+0x5a/0x90
May  7 09:49:02 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:49:02 Pleiadi kernel:  [<c01d3b9f>] xlog_write+0x1af/0x4d0
May  7 09:49:02 Pleiadi kernel:  [<c01d294d>] xfs_log_write+0x3d/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e0768>]
_xfs_trans_commit+0xe8/0x340
May  7 09:49:02 Pleiadi kernel:  [<c01a92fb>]
xfs_bmap_finish+0x11b/0x170
May  7 09:49:02 Pleiadi kernel:  [<c01eb466>] kmem_zone_zalloc+0x26/0x50
May  7 09:49:02 Pleiadi kernel:  [<c01ca0b0>]
xfs_itruncate_finish+0x180/0x420
May  7 09:49:02 Pleiadi kernel:  [<c01e2358>] xfs_trans_ijoin+0x28/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e6f88>] xfs_inactive+0x438/0x4b0
May  7 09:49:02 Pleiadi kernel:  [<c0181d38>]
inotify_inode_is_dead+0x18/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01f4f26>]
xfs_fs_clear_inode+0x36/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01798fa>]
invalidate_inode_buffers+0xa/0x80
May  7 09:49:02 Pleiadi kernel:  [<c016c654>] clear_inode+0xa4/0xf0
May  7 09:49:02 Pleiadi kernel:  [<c016d1a2>]
generic_delete_inode+0xa2/0xb0
May  7 09:49:02 Pleiadi kernel:  [<c016d343>] iput+0x53/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0163e86>] do_unlinkat+0xc6/0x120
May  7 09:49:02 Pleiadi kernel:  [<c015a7d0>] vfs_read+0xe0/0x140
May  7 09:49:02 Pleiadi kernel:  [<c015aac1>] sys_read+0x41/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0102daa>] syscall_call+0x7/0xb
May  7 09:49:02 Pleiadi kernel:  =======================
May  7 09:49:02 Pleiadi kernel: Mem-info:
May  7 09:49:02 Pleiadi kernel: DMA per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:49:02 Pleiadi kernel: Normal per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  19
May  7 09:49:02 Pleiadi kernel: Active:34425 inactive:1103 dirty:40
writeback:0 unstable:0
May  7 09:49:02 Pleiadi kernel:  free:730 slab:2351 mapped:323
pagetables:301 bounce:0
May  7 09:49:02 Pleiadi kernel: DMA free:936kB min:160kB low:200kB
high:240kB active:10072kB inactive:380kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:49:02 Pleiadi kernel: Normal free:1984kB min:1448kB low:1808kB
high:2172kB active:127628kB inactive:4032kB present:146304kB
pages_scanned:1897 all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:49:02 Pleiadi kernel: DMA: 110*4kB 34*8kB 12*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 936kB
May  7 09:49:02 Pleiadi kernel: Normal: 408*4kB 12*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1984kB
May  7 09:49:02 Pleiadi kernel: 12198 total pagecache pages
May  7 09:49:02 Pleiadi kernel: Swap cache: add 3219731, delete 3208124,
find 277400/779926
May  7 09:49:02 Pleiadi kernel: Free swap  = 82100kB
May  7 09:49:02 Pleiadi kernel: Total swap = 151160kB
May  7 09:49:02 Pleiadi kernel: Free swap:        82100kB
May  7 09:49:02 Pleiadi kernel: 40960 pages of RAM
May  7 09:49:02 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:49:02 Pleiadi kernel: 1202 reserved pages
May  7 09:49:02 Pleiadi kernel: 4626 pages shared
May  7 09:49:02 Pleiadi kernel: 11607 pages swap cached
May  7 09:49:02 Pleiadi kernel: 40 pages dirty
May  7 09:49:02 Pleiadi kernel: 0 pages writeback
May  7 09:49:02 Pleiadi kernel: 323 pages mapped
May  7 09:49:02 Pleiadi kernel: 2351 pages slab
May  7 09:49:02 Pleiadi kernel: 301 pages pagetables
May  7 09:49:02 Pleiadi kernel: unlinkd: page allocation failure.
order:3, mode:0x4020
May  7 09:49:02 Pleiadi kernel: Pid: 3333, comm: unlinkd Not tainted
2.6.25 #1
May  7 09:49:02 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:49:02 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:49:02 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e1daa>]
xfs_trans_log_buf+0x5a/0x90
May  7 09:49:02 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:49:02 Pleiadi kernel:  [<c01d3b9f>] xlog_write+0x1af/0x4d0
May  7 09:49:02 Pleiadi kernel:  [<c01d294d>] xfs_log_write+0x3d/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e0768>]
_xfs_trans_commit+0xe8/0x340
May  7 09:49:02 Pleiadi kernel:  [<c01a92fb>]
xfs_bmap_finish+0x11b/0x170
May  7 09:49:02 Pleiadi kernel:  [<c01eb466>] kmem_zone_zalloc+0x26/0x50
May  7 09:49:02 Pleiadi kernel:  [<c01ca0b0>]
xfs_itruncate_finish+0x180/0x420
May  7 09:49:02 Pleiadi kernel:  [<c01e2358>] xfs_trans_ijoin+0x28/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e6f88>] xfs_inactive+0x438/0x4b0
May  7 09:49:02 Pleiadi kernel:  [<c0181d38>]
inotify_inode_is_dead+0x18/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01f4f26>]
xfs_fs_clear_inode+0x36/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01798fa>]
invalidate_inode_buffers+0xa/0x80
May  7 09:49:02 Pleiadi kernel:  [<c016c654>] clear_inode+0xa4/0xf0
May  7 09:49:02 Pleiadi kernel:  [<c016d1a2>]
generic_delete_inode+0xa2/0xb0
May  7 09:49:02 Pleiadi kernel:  [<c016d343>] iput+0x53/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0163e86>] do_unlinkat+0xc6/0x120
May  7 09:49:02 Pleiadi kernel:  [<c015a7d0>] vfs_read+0xe0/0x140
May  7 09:49:02 Pleiadi kernel:  [<c015aac1>] sys_read+0x41/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0102daa>] syscall_call+0x7/0xb
May  7 09:49:02 Pleiadi kernel:  =======================
May  7 09:49:02 Pleiadi kernel: Mem-info:
May  7 09:49:02 Pleiadi kernel: DMA per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:49:02 Pleiadi kernel: Normal per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  18
May  7 09:49:02 Pleiadi kernel: Active:34425 inactive:1103 dirty:40
writeback:0 unstable:0
May  7 09:49:02 Pleiadi kernel:  free:730 slab:2351 mapped:323
pagetables:301 bounce:0
May  7 09:49:02 Pleiadi kernel: DMA free:936kB min:160kB low:200kB
high:240kB active:10072kB inactive:380kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:49:02 Pleiadi kernel: Normal free:1984kB min:1448kB low:1808kB
high:2172kB active:127628kB inactive:4032kB present:146304kB
pages_scanned:1897 all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:49:02 Pleiadi kernel: DMA: 110*4kB 34*8kB 12*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 936kB
May  7 09:49:02 Pleiadi kernel: Normal: 408*4kB 12*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1984kB
May  7 09:49:02 Pleiadi kernel: 12198 total pagecache pages
May  7 09:49:02 Pleiadi kernel: Swap cache: add 3219731, delete 3208124,
find 277400/779926
May  7 09:49:02 Pleiadi kernel: Free swap  = 82100kB
May  7 09:49:02 Pleiadi kernel: Total swap = 151160kB
May  7 09:49:02 Pleiadi kernel: Free swap:        82100kB
May  7 09:49:02 Pleiadi kernel: 40960 pages of RAM
May  7 09:49:02 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:49:02 Pleiadi kernel: 1202 reserved pages
May  7 09:49:02 Pleiadi kernel: 4626 pages shared
May  7 09:49:02 Pleiadi kernel: 11607 pages swap cached
May  7 09:49:02 Pleiadi kernel: 40 pages dirty
May  7 09:49:02 Pleiadi kernel: 0 pages writeback
May  7 09:49:02 Pleiadi kernel: 323 pages mapped
May  7 09:49:02 Pleiadi kernel: 2351 pages slab
May  7 09:49:02 Pleiadi kernel: 301 pages pagetables
May  7 09:49:02 Pleiadi kernel: unlinkd: page allocation failure.
order:3, mode:0x4020
May  7 09:49:02 Pleiadi kernel: Pid: 3333, comm: unlinkd Not tainted
2.6.25 #1
May  7 09:49:02 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:49:02 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:49:02 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e1daa>]
xfs_trans_log_buf+0x5a/0x90
May  7 09:49:02 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:49:02 Pleiadi kernel:  [<c01d3b9f>] xlog_write+0x1af/0x4d0
May  7 09:49:02 Pleiadi kernel:  [<c01d294d>] xfs_log_write+0x3d/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e0768>]
_xfs_trans_commit+0xe8/0x340
May  7 09:49:02 Pleiadi kernel:  [<c01a92fb>]
xfs_bmap_finish+0x11b/0x170
May  7 09:49:02 Pleiadi kernel:  [<c01eb466>] kmem_zone_zalloc+0x26/0x50
May  7 09:49:02 Pleiadi kernel:  [<c01ca0b0>]
xfs_itruncate_finish+0x180/0x420
May  7 09:49:02 Pleiadi kernel:  [<c01e2358>] xfs_trans_ijoin+0x28/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e6f88>] xfs_inactive+0x438/0x4b0
May  7 09:49:02 Pleiadi kernel:  [<c0181d38>]
inotify_inode_is_dead+0x18/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01f4f26>]
xfs_fs_clear_inode+0x36/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01798fa>]
invalidate_inode_buffers+0xa/0x80
May  7 09:49:02 Pleiadi kernel:  [<c016c654>] clear_inode+0xa4/0xf0
May  7 09:49:02 Pleiadi kernel:  [<c016d1a2>]
generic_delete_inode+0xa2/0xb0
May  7 09:49:02 Pleiadi kernel:  [<c016d343>] iput+0x53/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0163e86>] do_unlinkat+0xc6/0x120
May  7 09:49:02 Pleiadi kernel:  [<c015a7d0>] vfs_read+0xe0/0x140
May  7 09:49:02 Pleiadi kernel:  [<c015aac1>] sys_read+0x41/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0102daa>] syscall_call+0x7/0xb
May  7 09:49:02 Pleiadi kernel:  =======================
May  7 09:49:02 Pleiadi kernel: Mem-info:
May  7 09:49:02 Pleiadi kernel: DMA per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:49:02 Pleiadi kernel: Normal per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  23
May  7 09:49:02 Pleiadi kernel: Active:34425 inactive:1103 dirty:40
writeback:0 unstable:0
May  7 09:49:02 Pleiadi kernel:  free:723 slab:2352 mapped:323
pagetables:301 bounce:0
May  7 09:49:02 Pleiadi kernel: DMA free:936kB min:160kB low:200kB
high:240kB active:10072kB inactive:380kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:49:02 Pleiadi kernel: Normal free:1956kB min:1448kB low:1808kB
high:2172kB active:127628kB inactive:4032kB present:146304kB
pages_scanned:1897 all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:49:02 Pleiadi kernel: DMA: 110*4kB 34*8kB 12*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 936kB
May  7 09:49:02 Pleiadi kernel: Normal: 401*4kB 12*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1956kB
May  7 09:49:02 Pleiadi kernel: 12198 total pagecache pages
May  7 09:49:02 Pleiadi kernel: Swap cache: add 3219731, delete 3208124,
find 277400/779926
May  7 09:49:02 Pleiadi kernel: Free swap  = 82100kB
May  7 09:49:02 Pleiadi kernel: Total swap = 151160kB
May  7 09:49:02 Pleiadi kernel: Free swap:        82100kB
May  7 09:49:02 Pleiadi kernel: 40960 pages of RAM
May  7 09:49:02 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:49:02 Pleiadi kernel: 1202 reserved pages
May  7 09:49:02 Pleiadi kernel: 4626 pages shared
May  7 09:49:02 Pleiadi kernel: 11607 pages swap cached
May  7 09:49:02 Pleiadi kernel: 40 pages dirty
May  7 09:49:02 Pleiadi kernel: 0 pages writeback
May  7 09:49:02 Pleiadi kernel: 323 pages mapped
May  7 09:49:02 Pleiadi kernel: 2352 pages slab
May  7 09:49:02 Pleiadi kernel: 301 pages pagetables
May  7 09:49:02 Pleiadi kernel: unlinkd: page allocation failure.
order:3, mode:0x4020
May  7 09:49:02 Pleiadi kernel: Pid: 3333, comm: unlinkd Not tainted
2.6.25 #1
May  7 09:49:02 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:49:02 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:49:02 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e1daa>]
xfs_trans_log_buf+0x5a/0x90
May  7 09:49:02 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:49:02 Pleiadi kernel:  [<c01d3b9f>] xlog_write+0x1af/0x4d0
May  7 09:49:02 Pleiadi kernel:  [<c01d294d>] xfs_log_write+0x3d/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e0768>]
_xfs_trans_commit+0xe8/0x340
May  7 09:49:02 Pleiadi kernel:  [<c01a92fb>]
xfs_bmap_finish+0x11b/0x170
May  7 09:49:02 Pleiadi kernel:  [<c01eb466>] kmem_zone_zalloc+0x26/0x50
May  7 09:49:02 Pleiadi kernel:  [<c01ca0b0>]
xfs_itruncate_finish+0x180/0x420
May  7 09:49:02 Pleiadi kernel:  [<c01e2358>] xfs_trans_ijoin+0x28/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e6f88>] xfs_inactive+0x438/0x4b0
May  7 09:49:02 Pleiadi kernel:  [<c0181d38>]
inotify_inode_is_dead+0x18/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01f4f26>]
xfs_fs_clear_inode+0x36/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01798fa>]
invalidate_inode_buffers+0xa/0x80
May  7 09:49:02 Pleiadi kernel:  [<c016c654>] clear_inode+0xa4/0xf0
May  7 09:49:02 Pleiadi kernel:  [<c016d1a2>]
generic_delete_inode+0xa2/0xb0
May  7 09:49:02 Pleiadi kernel:  [<c016d343>] iput+0x53/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0163e86>] do_unlinkat+0xc6/0x120
May  7 09:49:02 Pleiadi kernel:  [<c015a7d0>] vfs_read+0xe0/0x140
May  7 09:49:02 Pleiadi kernel:  [<c015aac1>] sys_read+0x41/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0102daa>] syscall_call+0x7/0xb
May  7 09:49:02 Pleiadi kernel:  =======================
May  7 09:49:02 Pleiadi kernel: Mem-info:
May  7 09:49:02 Pleiadi kernel: DMA per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:49:02 Pleiadi kernel: Normal per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  22
May  7 09:49:02 Pleiadi kernel: Active:34425 inactive:1103 dirty:40
writeback:0 unstable:0
May  7 09:49:02 Pleiadi kernel:  free:723 slab:2352 mapped:323
pagetables:301 bounce:0
May  7 09:49:02 Pleiadi kernel: DMA free:936kB min:160kB low:200kB
high:240kB active:10072kB inactive:380kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:49:02 Pleiadi kernel: Normal free:1956kB min:1448kB low:1808kB
high:2172kB active:127628kB inactive:4032kB present:146304kB
pages_scanned:1897 all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:49:02 Pleiadi kernel: DMA: 110*4kB 34*8kB 12*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 936kB
May  7 09:49:02 Pleiadi kernel: Normal: 401*4kB 12*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1956kB
May  7 09:49:02 Pleiadi kernel: 12198 total pagecache pages
May  7 09:49:02 Pleiadi kernel: Swap cache: add 3219731, delete 3208124,
find 277400/779926
May  7 09:49:02 Pleiadi kernel: Free swap  = 82100kB
May  7 09:49:02 Pleiadi kernel: Total swap = 151160kB
May  7 09:49:02 Pleiadi kernel: Free swap:        82100kB
May  7 09:49:02 Pleiadi kernel: 40960 pages of RAM
May  7 09:49:02 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:49:02 Pleiadi kernel: 1202 reserved pages
May  7 09:49:02 Pleiadi kernel: 4626 pages shared
May  7 09:49:02 Pleiadi kernel: 11607 pages swap cached
May  7 09:49:02 Pleiadi kernel: 40 pages dirty
May  7 09:49:02 Pleiadi kernel: 0 pages writeback
May  7 09:49:02 Pleiadi kernel: 323 pages mapped
May  7 09:49:02 Pleiadi kernel: 2352 pages slab
May  7 09:49:02 Pleiadi kernel: 301 pages pagetables
May  7 09:49:02 Pleiadi kernel: unlinkd: page allocation failure.
order:3, mode:0x4020
May  7 09:49:02 Pleiadi kernel: Pid: 3333, comm: unlinkd Not tainted
2.6.25 #1
May  7 09:49:02 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:49:02 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:49:02 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e1daa>]
xfs_trans_log_buf+0x5a/0x90
May  7 09:49:02 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:49:02 Pleiadi kernel:  [<c01d3b9f>] xlog_write+0x1af/0x4d0
May  7 09:49:02 Pleiadi kernel:  [<c01d294d>] xfs_log_write+0x3d/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e0768>]
_xfs_trans_commit+0xe8/0x340
May  7 09:49:02 Pleiadi kernel:  [<c01a92fb>]
xfs_bmap_finish+0x11b/0x170
May  7 09:49:02 Pleiadi kernel:  [<c01eb466>] kmem_zone_zalloc+0x26/0x50
May  7 09:49:02 Pleiadi kernel:  [<c01ca0b0>]
xfs_itruncate_finish+0x180/0x420
May  7 09:49:02 Pleiadi kernel:  [<c01e2358>] xfs_trans_ijoin+0x28/0x70
May  7 09:49:02 Pleiadi kernel:  [<c01e6f88>] xfs_inactive+0x438/0x4b0
May  7 09:49:02 Pleiadi kernel:  [<c0181d38>]
inotify_inode_is_dead+0x18/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01f4f26>]
xfs_fs_clear_inode+0x36/0x80
May  7 09:49:02 Pleiadi kernel:  [<c01798fa>]
invalidate_inode_buffers+0xa/0x80
May  7 09:49:02 Pleiadi kernel:  [<c016c654>] clear_inode+0xa4/0xf0
May  7 09:49:02 Pleiadi kernel:  [<c016d1a2>]
generic_delete_inode+0xa2/0xb0
May  7 09:49:02 Pleiadi kernel:  [<c016d343>] iput+0x53/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0163e86>] do_unlinkat+0xc6/0x120
May  7 09:49:02 Pleiadi kernel:  [<c015a7d0>] vfs_read+0xe0/0x140
May  7 09:49:02 Pleiadi kernel:  [<c015aac1>] sys_read+0x41/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0102daa>] syscall_call+0x7/0xb
May  7 09:49:02 Pleiadi kernel:  =======================
May  7 09:49:02 Pleiadi kernel: Mem-info:
May  7 09:49:02 Pleiadi kernel: DMA per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:49:02 Pleiadi kernel: Normal per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  21
May  7 09:49:02 Pleiadi kernel: Active:34425 inactive:1103 dirty:40
writeback:0 unstable:0
May  7 09:49:02 Pleiadi kernel:  free:723 slab:2352 mapped:323
pagetables:301 bounce:0
May  7 09:49:02 Pleiadi kernel: DMA free:936kB min:160kB low:200kB
high:240kB active:10072kB inactive:380kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:49:02 Pleiadi kernel: Normal free:1956kB min:1448kB low:1808kB
high:2172kB active:127628kB inactive:4032kB present:146304kB
pages_scanned:1897 all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:49:02 Pleiadi kernel: DMA: 110*4kB 34*8kB 12*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 936kB
May  7 09:49:02 Pleiadi kernel: Normal: 401*4kB 12*8kB 10*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1956kB
May  7 09:49:02 Pleiadi kernel: 12198 total pagecache pages
May  7 09:49:02 Pleiadi kernel: Swap cache: add 3219731, delete 3208124,
find 277400/779926
May  7 09:49:02 Pleiadi kernel: Free swap  = 82100kB
May  7 09:49:02 Pleiadi kernel: Total swap = 151160kB
May  7 09:49:02 Pleiadi kernel: Free swap:        82100kB
May  7 09:49:02 Pleiadi kernel: 40960 pages of RAM
May  7 09:49:02 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:49:02 Pleiadi kernel: 1202 reserved pages
May  7 09:49:02 Pleiadi kernel: 4626 pages shared
May  7 09:49:02 Pleiadi kernel: 11607 pages swap cached
May  7 09:49:02 Pleiadi kernel: 40 pages dirty
May  7 09:49:02 Pleiadi kernel: 0 pages writeback
May  7 09:49:02 Pleiadi kernel: 323 pages mapped
May  7 09:49:02 Pleiadi kernel: 2352 pages slab
May  7 09:49:02 Pleiadi kernel: 301 pages pagetables
May  7 09:49:02 Pleiadi kernel: printk: 446 messages suppressed.
May  7 09:49:02 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  7 09:49:02 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  7 09:49:02 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  7 09:49:02 Pleiadi kernel:  [<c0276fbf>] ide_build_sglist+0x6f/0xa0
May  7 09:49:02 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  7 09:49:02 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  7 09:49:02 Pleiadi kernel:  [<c02771b0>] dma_timer_expiry+0x0/0x80
May  7 09:49:02 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  7 09:49:02 Pleiadi kernel:  [<c0277471>] ide_dma_start+0x21/0x40
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  7 09:49:02 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c011279e>] enqueue_entity+0x2e/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0112adb>]
enqueue_task_fair+0x1b/0x20
May  7 09:49:02 Pleiadi kernel:  [<c0113575>] enqueue_task+0x15/0x30
May  7 09:49:02 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  7 09:49:02 Pleiadi kernel:  [<c011f4b0>] process_timeout+0x0/0x10
May  7 09:49:02 Pleiadi kernel:  [<c011f253>]
run_timer_softirq+0x93/0x150
May  7 09:49:02 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  7 09:49:02 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  7 09:49:02 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  7 09:49:02 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  7 09:49:02 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  7 09:49:02 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  7 09:49:02 Pleiadi kernel:  =======================
May  7 09:49:02 Pleiadi kernel: Mem-info:
May  7 09:49:02 Pleiadi kernel: DMA per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  7 09:49:02 Pleiadi kernel: Normal per-cpu:
May  7 09:49:02 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  37
May  7 09:49:02 Pleiadi kernel: Active:30366 inactive:3481 dirty:7
writeback:340 unstable:0
May  7 09:49:02 Pleiadi kernel:  free:2290 slab:2369 mapped:300
pagetables:301 bounce:0
May  7 09:49:02 Pleiadi kernel: DMA free:2024kB min:160kB low:200kB
high:240kB active:8400kB inactive:932kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  7 09:49:02 Pleiadi kernel: Normal free:7136kB min:1448kB low:1808kB
high:2172kB active:113064kB inactive:12992kB present:146304kB
pages_scanned:176 all_unreclaimable? no
May  7 09:49:02 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  7 09:49:02 Pleiadi kernel: DMA: 244*4kB 95*8kB 16*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2024kB
May  7 09:49:02 Pleiadi kernel: Normal: 1240*4kB 190*8kB 35*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7136kB
May  7 09:49:02 Pleiadi kernel: 10866 total pagecache pages
May  7 09:49:02 Pleiadi kernel: Swap cache: add 3220104, delete 3209653,
find 277405/779939
May  7 09:49:02 Pleiadi kernel: Free swap  = 80704kB
May  7 09:49:02 Pleiadi kernel: Total swap = 151160kB
May  7 09:49:02 Pleiadi kernel: Free swap:        80704kB
May  7 09:49:02 Pleiadi kernel: 40960 pages of RAM
May  7 09:49:02 Pleiadi kernel: 0 pages of HIGHMEM
May  7 09:49:02 Pleiadi kernel: 1202 reserved pages
May  7 09:49:02 Pleiadi kernel: 4542 pages shared
May  7 09:49:02 Pleiadi kernel: 10451 pages swap cached
May  7 09:49:02 Pleiadi kernel: 7 pages dirty
May  7 09:49:02 Pleiadi kernel: 340 pages writeback
May  7 09:49:02 Pleiadi kernel: 300 pages mapped
May  7 09:49:02 Pleiadi kernel: 2369 pages slab
May  7 09:49:02 Pleiadi kernel: 301 pages pagetables
