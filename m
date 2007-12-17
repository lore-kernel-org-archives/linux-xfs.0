Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 14:04:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBHM3ovr018708
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 14:03:53 -0800
Date: Tue, 18 Dec 2007 09:03:54 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Issue with 2.6.23 and drbd 8.0.7
Message-ID: <20071217220354.GU4396912@sgi.com>
References: <20071217143655.chiehahh@trusted.lncsa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217143655.chiehahh@trusted.lncsa.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Laurent Caron <lcaron@lncsa.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 17, 2007 at 02:39:07PM +0100, Laurent Caron wrote:
> 
> Hi,
> 
> I'm still experiencing a strange behavior on one of my DRBD setup.
> 
> It basically consists in:
> 
> 2 servers with XFS filesystems on top of DRBD, itself on top of MD (aka
> soft raid).
> 
> The two servers exhibit the same behavior. This strange behavior might
> appear between 1 day and 3 weeks after having started the machines.
> 
> Slab debugging is turned on.
> CONFIG_SLAB=y
> CONFIG_DEBUG_SLAB=y
> CONFIG_DEBUG_SLAB_LEAK=y
> 
> Do anyone have a clue about that problem?

The symptoms you see are the machine running out of memory and the OOM
killer being invoked. There's nothing XFS here - you'd do better to post
to lkml about this.

> I already posted about it some time ago, and was asked to turn slab debugging on.

What you posted recently appeared to be the result of memory corruption,
hence the request for debugging to be turned on. This appears to be a
different problem.

> Dec 16 01:12:27 mailserver-1 kernel: DMA: 5*4kB 11*8kB 7*16kB 2*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
> Dec 16 01:12:27 mailserver-1 kernel: Normal: 195*4kB 82*8kB 5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 3788kB
> Dec 16 01:12:27 mailserver-1 kernel: HighMem: 37376*4kB 104969*8kB 97167*16kB 61944*32kB 34197*64kB 13138*128kB 3479*256kB 502*512kB 24*1024kB 2*2048kB 2*4096kB = 9580920kB

Hmmm - you appear to have a highmem based box and have run out of
low memory for the kernel. So while having ~9.5GB of free high
memory (that the kernel can't directly use), you're out of low
memory that the kernel can use and hence it is going OOM.  The
output of /proc/slabinfo or watching slabtop will tell you where
most of this memory is going.

FWIW, I suggest upgrading to a 64 bit machine ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
