Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 17:13:31 -0800 (PST)
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.24])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0N1DKqw019330
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 17:13:21 -0800
Date: Mon, 22 Jan 2007 17:12:06 -0800
From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
Message-Id: <20070122171206.fc2faf5f.akpm@osdl.org>
In-Reply-To: <45B558B5.6080403@sgi.com>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
	<20070122115703.97ed54f3.akpm@osdl.org>
	<45B558B5.6080403@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Tue, 23 Jan 2007 11:37:09 +1100
Donald Douwsma <donaldd@sgi.com> wrote:

> Andrew Morton wrote:
> >> On Sun, 21 Jan 2007 14:27:34 -0500 (EST) Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >> Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
> >> the OOM killer and kill all of my processes?
> > 
> > What's that?   Software raid or hardware raid?  If the latter, which driver?
> 
> I've hit this using local disk while testing xfs built against 2.6.20-rc4 (SMP x86_64)
> 
> dmesg follows, I'm not sure if anything in this is useful after the first event as our automated tests continued on
> after the failure.

This looks different.

> ...
>
> Mem-info:
> Node 0 DMA per-cpu:
> CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Node 0 DMA32 per-cpu:
> CPU    0: Hot: hi:  186, btch:  31 usd:  31   Cold: hi:   62, btch:  15 usd:  53
> CPU    1: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  60
> CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:  47
> CPU    3: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:  56
> Active:76 inactive:495856 dirty:0 writeback:0 unstable:0 free:3680 slab:9119 mapped:32 pagetables:637

No dirty pages, no pages under writeback.

> Node 0 DMA free:8036kB min:24kB low:28kB high:36kB active:0kB inactive:1856kB present:9376kB pages_scanned:3296
> all_unreclaimable? yes
> lowmem_reserve[]: 0 2003 2003
> Node 0 DMA32 free:6684kB min:5712kB low:7140kB high:8568kB active:304kB inactive:1981624kB present:2052068kB

Inactive list is filled.

> pages_scanned:4343329 all_unreclaimable? yes

We scanned our guts out and decided that nothing was reclaimable.

> No available memory (MPOL_BIND): kill process 3492 (hald) score 0 or a child
> No available memory (MPOL_BIND): kill process 7914 (top) score 0 or a child
> No available memory (MPOL_BIND): kill process 4166 (nscd) score 0 or a child
> No available memory (MPOL_BIND): kill process 17869 (xfs_repair) score 0 or a child

But in all cases a constrained memory policy was in use.
