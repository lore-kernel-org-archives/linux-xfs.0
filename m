Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 15:41:10 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0ONf1qw014548
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 15:41:02 -0800
Date: Wed, 24 Jan 2007 18:40:07 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <20070122115703.97ed54f3.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701241840040.2930@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122115703.97ed54f3.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Mon, 22 Jan 2007, Andrew Morton wrote:

> > On Sun, 21 Jan 2007 14:27:34 -0500 (EST) Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
> > the OOM killer and kill all of my processes?
> 
> What's that?   Software raid or hardware raid?  If the latter, which driver?
> 
> > Doing this on a single disk 2.6.19.2 is OK, no issues.  However, this 
> > happens every time!
> > 
> > Anything to try?  Any other output needed?  Can someone shed some light on 
> > this situation?
> > 
> > Thanks.
> > 
> > 
> > The last lines of vmstat 1 (right before it kill -9'd my shell/ssh)
> > 
> > procs -----------memory---------- ---swap-- -----io---- -system-- 
> > ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id 
> > wa
> >  0  7    764  50348     12 1269988    0    0 53632   172 1902 4600  1  8 
> > 29 62
> >  0  7    764  49420     12 1260004    0    0 53632 34368 1871 6357  2 11 
> > 48 40
> 
> The wordwrapping is painful :(
> 
> > 
> > The last lines of dmesg:
> > [ 5947.199985] lowmem_reserve[]: 0 0 0
> > [ 5947.199992] DMA: 0*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 
> > 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3544kB
> > [ 5947.200010] Normal: 1*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 
> > 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2740kB
> > [ 5947.200035] HighMem: 98*4kB 35*8kB 9*16kB 69*32kB 4*64kB 1*128kB 
> > 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3664kB
> > [ 5947.200052] Swap cache: add 789, delete 189, find 16/17, race 0+0
> > [ 5947.200055] Free swap  = 2197628kB
> > [ 5947.200058] Total swap = 2200760kB
> > [ 5947.200060] Free swap:       2197628kB
> > [ 5947.205664] 517888 pages of RAM 
> > [ 5947.205671] 288512 pages of HIGHMEM
> > [ 5947.205673] 5666 reserved pages 
> > [ 5947.205675] 257163 pages shared
> > [ 5947.205678] 600 pages swap cached 
> > [ 5947.205680] 88876 pages dirty
> > [ 5947.205682] 115111 pages writeback
> > [ 5947.205684] 5608 pages mapped
> > [ 5947.205686] 49367 pages slab
> > [ 5947.205688] 541 pages pagetables
> > [ 5947.205795] Out of memory: kill process 1853 (named) score 9937 or a 
> > child
> > [ 5947.205801] Killed process 1853 (named)
> > [ 5947.206616] bash invoked oom-killer: gfp_mask=0x84d0, order=0, 
> > oomkilladj=0
> > [ 5947.206621]  [<c013e33b>] out_of_memory+0x17b/0x1b0
> > [ 5947.206631]  [<c013fcac>] __alloc_pages+0x29c/0x2f0
> > [ 5947.206636]  [<c01479ad>] __pte_alloc+0x1d/0x90
> > [ 5947.206643]  [<c0148bf7>] copy_page_range+0x357/0x380
> > [ 5947.206649]  [<c0119d75>] copy_process+0x765/0xfc0
> > [ 5947.206655]  [<c012c3f9>] alloc_pid+0x1b9/0x280
> > [ 5947.206662]  [<c011a839>] do_fork+0x79/0x1e0
> > [ 5947.206674]  [<c015f91f>] do_pipe+0x5f/0xc0
> > [ 5947.206680]  [<c0101176>] sys_clone+0x36/0x40
> > [ 5947.206686]  [<c0103138>] syscall_call+0x7/0xb
> > [ 5947.206691]  [<c0420033>] __sched_text_start+0x853/0x950
> > [ 5947.206698]  ======================= 
> 
> Important information from the oom-killing event is missing.  Please send
> it all.
> 
> >From your earlier reports we have several hundred MB of ZONE_NORMAL memory
> which has gone awol.
> 
> Please include /proc/meminfo from after the oom-killing.
> 
> Please work out what is using all that slab memory, via /proc/slabinfo.
> 
> After the oom-killing, please see if you can free up the ZONE_NORMAL memory
> via a few `echo 3 > /proc/sys/vm/drop_caches' commands.  See if you can
> work out what happened to the missing couple-of-hundred MB from
> ZONE_NORMAL.
> 
> 

Trying this now.
