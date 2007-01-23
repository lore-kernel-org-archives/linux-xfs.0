Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 16:39:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0N0dDqw010904
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 16:39:15 -0800
Message-ID: <45B558B5.6080403@sgi.com>
Date: Tue, 23 Jan 2007 11:37:09 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122115703.97ed54f3.akpm@osdl.org>
In-Reply-To: <20070122115703.97ed54f3.akpm@osdl.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Andrew Morton wrote:
>> On Sun, 21 Jan 2007 14:27:34 -0500 (EST) Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
>> the OOM killer and kill all of my processes?
> 
> What's that?   Software raid or hardware raid?  If the latter, which driver?

I've hit this using local disk while testing xfs built against 2.6.20-rc4 (SMP x86_64)

dmesg follows, I'm not sure if anything in this is useful after the first event as our automated tests continued on
after the failure.

> Please include /proc/meminfo from after the oom-killing.
>
> Please work out what is using all that slab memory, via /proc/slabinfo.

Sorry I didnt pick this up ether.
I'll try to reproduce this and gather some more detailed info for a single event.

Donald


...
XFS mounting filesystem sdb5
Ending clean XFS mount for filesystem: sdb5
XFS mounting filesystem sdb5
Ending clean XFS mount for filesystem: sdb5
hald invoked oom-killer: gfp_mask=0x200d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff80257367>] out_of_memory+0x70/0x25d
 [<ffffffff80258f6b>] __alloc_pages+0x22c/0x2b5
 [<ffffffff8026d889>] alloc_page_vma+0x71/0x76
 [<ffffffff8026937b>] read_swap_cache_async+0x45/0xd8
 [<ffffffff8025f2e0>] swapin_readahead+0x60/0xd3
 [<ffffffff80260ece>] __handle_mm_fault+0x703/0x9d8
 [<ffffffff80532bf7>] do_page_fault+0x42b/0x7b3
 [<ffffffff80278adf>] do_readv_writev+0x176/0x18b
 [<ffffffff8052efde>] thread_return+0x0/0xed
 [<ffffffff8034d7f5>] __const_udelay+0x2c/0x2d
 [<ffffffff803f4e0b>] scsi_done+0x0/0x17
 [<ffffffff8053109d>] error_exit+0x0/0x84

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  31   Cold: hi:   62, btch:  15 usd:  53
CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  60
CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  47
CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  56
Active:76 inactive:495856 dirty:0 writeback:0 unstable:0 free:3680 slab:9119 mapped:32 pagetables:637
Node 0 DMA free:8036kB min:24kB low:28kB high:36kB active:0kB inactive:1856kB present:9376kB pages_scanned:3296
all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003
Node 0 DMA32 free:6684kB min:5712kB low:7140kB high:8568kB active:304kB inactive:1981624kB present:2052068kB
pages_scanned:4343329 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0
Node 0 DMA: 1*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8036kB
Node 0 DMA32: 273*4kB 29*8kB 1*16kB 1*32kB 1*64kB 1*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 6684kB
Swap cache: add 741048, delete 244661, find 84826/143198, race 680+239
Free swap  = 1088524kB
Total swap = 3140668kB
Free swap:       1088524kB
524224 pages of RAM
9619 reserved pages
259 pages shared
496388 pages swap cached
No available memory (MPOL_BIND): kill process 3492 (hald) score 0 or a child
Killed process 3626 (hald-addon-acpi)
top invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff80257367>] out_of_memory+0x70/0x25d
 [<ffffffff80258f6b>] __alloc_pages+0x22c/0x2b5
 [<ffffffff8026e6a3>] alloc_pages_current+0x74/0x79
 [<ffffffff802548c8>] __page_cache_alloc+0xb/0xe
 [<ffffffff8025a65f>] __do_page_cache_readahead+0xa1/0x217
 [<ffffffff8052f776>] io_schedule+0x28/0x33
 [<ffffffff8052f9e7>] __wait_on_bit_lock+0x5b/0x66
 [<ffffffff802546de>] __lock_page+0x72/0x78
 [<ffffffff8025ab22>] do_page_cache_readahead+0x4e/0x5a
 [<ffffffff80256714>] filemap_nopage+0x140/0x30c
 [<ffffffff802609c6>] __handle_mm_fault+0x1fb/0x9d8
 [<ffffffff80532bf7>] do_page_fault+0x42b/0x7b3
 [<ffffffff80228273>] __wake_up+0x43/0x50
 [<ffffffff80380bd5>] tty_ldisc_deref+0x71/0x76
 [<ffffffff8053109d>] error_exit+0x0/0x84

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  31   Cold: hi:   62, btch:  15 usd:  53
CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  60
CPU    2: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:  10
CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  26
Active:90 inactive:496233 dirty:0 writeback:0 unstable:0 free:3485 slab:9119 mapped:32 pagetables:637
Node 0 DMA free:8036kB min:24kB low:28kB high:36kB active:0kB inactive:1856kB present:9376kB pages_scanned:3328
all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003
Node 0 DMA32 free:5904kB min:5712kB low:7140kB high:8568kB active:360kB inactive:1983092kB present:2052068kB
pages_scanned:4587649 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0
Node 0 DMA: 1*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8036kB
Node 0 DMA32: 78*4kB 29*8kB 1*16kB 1*32kB 1*64kB 1*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 5904kB
Swap cache: add 741067, delete 244673, find 84826/143210, race 680+239
Free swap  = 1088572kB
Total swap = 3140668kB
Free swap:       1088572kB
524224 pages of RAM
9619 reserved pages
290 pages shared
496396 pages swap cached
No available memory (MPOL_BIND): kill process 7914 (top) score 0 or a child
Killed process 7914 (top)
nscd invoked oom-killer: gfp_mask=0x200d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff80257367>] out_of_memory+0x70/0x25d
 [<ffffffff80258f6b>] __alloc_pages+0x22c/0x2b5
 [<ffffffff8026d889>] alloc_page_vma+0x71/0x76
 [<ffffffff8026937b>] read_swap_cache_async+0x45/0xd8
 [<ffffffff80260ede>] __handle_mm_fault+0x713/0x9d8
 [<ffffffff80532bf7>] do_page_fault+0x42b/0x7b3
 [<ffffffff80238e16>] try_to_del_timer_sync+0x51/0x5a
 [<ffffffff80238e2b>] del_timer_sync+0xc/0x16
 [<ffffffff8052f939>] schedule_timeout+0x92/0xad
 [<ffffffff80238a40>] process_timeout+0x0/0xb
 [<ffffffff8029e563>] sys_epoll_wait+0x3e0/0x421
 [<ffffffff8022a96b>] default_wake_function+0x0/0xf
 [<ffffffff8053109d>] error_exit+0x0/0x84

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  53
CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  60
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:  14
CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  26
Active:91 inactive:496325 dirty:0 writeback:0 unstable:0 free:3425 slab:9119 mapped:32 pagetables:637
Node 0 DMA free:8036kB min:24kB low:28kB high:36kB active:0kB inactive:1856kB present:9376kB pages_scanned:3328
all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003
Node 0 DMA32 free:5664kB min:5712kB low:7140kB high:8568kB active:364kB inactive:1983372kB present:2052068kB
pages_scanned:4610273 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0
Node 0 DMA: 1*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8036kB
Node 0 DMA32: 18*4kB 29*8kB 1*16kB 1*32kB 1*64kB 1*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 5664kB
Swap cache: add 741069, delete 244674, find 84826/143212, race 680+239
Free swap  = 1088576kB
Total swap = 3140668kB
Free swap:       1088576kB
524224 pages of RAM
9619 reserved pages
293 pages shared
496396 pages swap cached
No available memory (MPOL_BIND): kill process 4166 (nscd) score 0 or a child
Killed process 4166 (nscd)
xfs_repair invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff80257367>] out_of_memory+0x70/0x25d
 [<ffffffff80258f6b>] __alloc_pages+0x22c/0x2b5
 [<ffffffff8026e6a3>] alloc_pages_current+0x74/0x79
 [<ffffffff802548c8>] __page_cache_alloc+0xb/0xe
 [<ffffffff8025a65f>] __do_page_cache_readahead+0xa1/0x217
 [<ffffffff8025ab22>] do_page_cache_readahead+0x4e/0x5a
 [<ffffffff80256714>] filemap_nopage+0x140/0x30c
 [<ffffffff802609c6>] __handle_mm_fault+0x1fb/0x9d8
 [<ffffffff80532bf7>] do_page_fault+0x42b/0x7b3
 [<ffffffff802426eb>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80244ea4>] up_write+0x9/0xb
 [<ffffffff8026602d>] sys_mprotect+0x645/0x764
 [<ffffffff8053109d>] error_exit+0x0/0x84

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  53
CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  60
CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  14
CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  26
Active:91 inactive:496247 dirty:0 writeback:0 unstable:0 free:3394 slab:9119 mapped:32 pagetables:637
Node 0 DMA free:8036kB min:24kB low:28kB high:36kB active:0kB inactive:1856kB present:9376kB pages_scanned:3328
all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003
Node 0 DMA32 free:5540kB min:5712kB low:7140kB high:8568kB active:364kB inactive:1983300kB present:2052068kB
pages_scanned:4631841 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0
Node 0 DMA: 1*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8036kB
Node 0 DMA32: 1*4kB 22*8kB 1*16kB 1*32kB 1*64kB 1*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 5540kB
Swap cache: add 741070, delete 244674, find 84826/143212, race 680+239
Free swap  = 1088576kB
Total swap = 3140668kB
Free swap:       1088576kB
524224 pages of RAM
9619 reserved pages
293 pages shared
496397 pages swap cached
No available memory (MPOL_BIND): kill process 17869 (xfs_repair) score 0 or a child
Killed process 17869 (xfs_repair)
klogd invoked oom-killer: gfp_mask=0x200d2, order=0, oomkilladj=0

Call Trace:
 [<ffffffff80257367>] out_of_memory+0x70/0x25d
 [<ffffffff80258f6b>] __alloc_pages+0x22c/0x2b5
 [<ffffffff8025afc2>] __pagevec_lru_add_active+0xce/0xde
 [<ffffffff8026d889>] alloc_page_vma+0x71/0x76
 [<ffffffff8026937b>] read_swap_cache_async+0x45/0xd8
 [<ffffffff80260ede>] __handle_mm_fault+0x713/0x9d8
 [<ffffffff80532bf7>] do_page_fault+0x42b/0x7b3
 [<ffffffff802426eb>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8053109d>] error_exit+0x0/0x84
...
