Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 15:06:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5SM5qtL027473
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 15:05:54 -0700
Date: Fri, 29 Jun 2007 08:05:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Message-ID: <20070628220537.GC31489@sgi.com>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan> <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan> <46837056.4050306@rabbit.us> <Pine.LNX.4.64.0706280426500.1406@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706280426500.1406@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Peter Rabbitson <rabbit@rabbit.us>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

On Thu, Jun 28, 2007 at 04:27:15AM -0400, Justin Piszcz wrote:
> 
> 
> On Thu, 28 Jun 2007, Peter Rabbitson wrote:
> 
> >Justin Piszcz wrote:
> >>mdadm --create \
> >>      --verbose /dev/md3 \
> >>      --level=5 \
> >>      --raid-devices=10 \
> >>      --chunk=1024 \
> >>      --force \
> >>      --run
> >>      /dev/sd[cdefghijkl]1
> >>
> >>Justin.
> >
> >Interesting, I came up with the same results (1M chunk being superior) 
> >with a completely different raid set with XFS on top:
> >
> >mdadm	--create \
> >	--level=10 \
> >	--chunk=1024 \
> >	--raid-devices=4 \
> >	--layout=f3 \
> >	...
> >
> >Could it be attributed to XFS itself?

More likely it's related to the I/O size being sent to the disks. The larger
the chunk size, the larger the I/o hitting each disk. I think the maximum I/O
size is 512k ATM on x86(_64), so a chunk of 1MB will guarantee that there are
maximally sized I/Os being sent to the disk....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
