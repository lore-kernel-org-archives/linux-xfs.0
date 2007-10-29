Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 02:28:07 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9T9S21W021204
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 02:28:03 -0700
Date: Mon, 29 Oct 2007 10:14:19 +0100
From: Laurent Caron <lcaron@lncsa.fr>
Subject: Crash with XFS on top of DRBD (DRBD 8.0.6 svn / Kernel 2.6.22)
Message-ID: <20071029101329.ietaisee@trusted.lncsa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: drbd-user@linbit.com, xfs@oss.sgi.com

Hi,

I'm back with my crash, oomkiller..... problems on my DRBD cluster of 2
servers.

I compiled a 2.6.22 kernel with slab/slab debugging turned on.

Here is the last oom-killer message I got on that server.

I couldn't wait until a crash since a lot of users are working on it:

-----------------------------------------------
kernel: procmail invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
kernel: [<c0147dbe>] out_of_memory+0x69/0x197
kernel: [<c01492e1>] __alloc_pages+0x20a/0x294
kernel: [<c0149397>] __get_free_pages+0x2c/0x3a
kernel: [<c011ba87>] copy_process+0xa4/0x102d
kernel: [<c012aff2>] alloc_pid+0x16/0x240
kernel: [<c016048d>] kmem_cache_alloc+0x80/0x8a
kernel: [<c012aff2>] alloc_pid+0x16/0x240
kernel: [<c011cc57>] do_fork+0x9a/0x1c2
kernel: [<c01021d1>] sys_clone+0x36/0x3b
kernel: [<c0103cb2>] sysenter_past_esp+0x6b/0xa1
kernel: =======================
kernel: Mem-info:
kernel: DMA per-cpu:
kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0  
kernel: Normal per-cpu:
kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  63   Cold: hi:   62, btch:  15 usd:  51 
kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  97   Cold: hi:   62, btch:  15 usd:  54 
kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  47 
kernel: CPU    3: Hot: hi:  186, btch:  31 usd:   8   Cold: hi:   62, btch:  15 usd:  61 
kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:  53 
kernel: CPU    5: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:  60 
kernel: CPU    6: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:   62, btch:  15 usd:  57 
kernel: CPU    7: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:   62, btch:  15 usd:  59 
kernel: HighMem per-cpu:
kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  98   Cold: hi:   62, btch:  15 usd:   8 
kernel: CPU    1: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:   62, btch:  15 usd:  12 
kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  85   Cold: hi:   62, btch:  15 usd:   4 
kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  72   Cold: hi:   62, btch:  15 usd:   0 
kernel: CPU    4: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:   6 
kernel: CPU    5: Hot: hi:  186, btch:  31 usd:  19   Cold: hi:   62, btch:  15 usd:  12 
kernel: CPU    6: Hot: hi:  186, btch:  31 usd: 175   Cold: hi:   62, btch:  15 usd:  12 
kernel: CPU    7: Hot: hi:  186, btch:  31 usd: 137   Cold: hi:   62, btch:  15 usd:   2 
kernel: Active:381850 inactive:9157 dirty:256 writeback:97 unstable:0
kernel: free:2519061 slab:22044 mapped:7487 pagetables:2163 bounce:0
kernel: DMA free:3564kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes 
kernel: lowmem_reserve[]: 0 873 12938
kernel: Normal free:7756kB min:3744kB low:4680kB high:5616kB active:116kB inactive:0kB present:894080kB pages_scanned:192 all_unreclaimable? yes 
kernel: lowmem_reserve[]: 0 0 96520
kernel: HighMem free:10064924kB min:512kB low:13456kB high:26404kB active:1527284kB inactive:36804kB present:12354560kB pages_scanned:0 all_unreclaimable? no
kernel: lowmem_reserve[]: 0 0 0
kernel: DMA: 9*4kB 15*8kB 3*16kB 1*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3564kB
kernel: Normal: 1495*4kB 10*8kB 1*16kB 0*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 7804kB
kernel: HighMem: 39234*4kB 109305*8kB 80630*16kB 52420*32kB 27267*64kB 9904*128kB 2822*256kB 871*512kB 377*1024kB 218*2048kB 257*4096kB = 10065264kB
kernel: Swap cache: add 43, delete 42, find 0/0, race 0+0 
kernel: Free swap  = 393204kB
kernel: Total swap = 393208kB
kernel: Free swap:       393204kB
kernel: 3342335 pages of RAM
kernel: 3112959 pages of HIGHMEM
kernel: 224356 reserved pages
kernel: 221558 pages shared
kernel: 1 pages swap cached
kernel: 256 pages dirty
kernel: 97 pages writeback
kernel: 7487 pages mapped
kernel: 22044 pages slab
kernel: 2163 pages pagetables
kernel: Out of memory: kill process 12069 (slapd) score 62386 or a child 
kernel: Killed process 12069 (slapd)
---------------------------------------------

Do anyone have any clue about what's happening ?

Thanks

Laurent
