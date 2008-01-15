Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 13:34:13 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0FLY1x1002663
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 13:34:05 -0800
Date: Wed, 16 Jan 2008 08:34:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Proper swidth and sunit for RAID 5 (does it matter)?
Message-ID: <20080115213410.GM155407@sgi.com>
References: <alpine.DEB.0.999999.0801151227001.25921@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.999999.0801151227001.25921@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 15, 2008 at 12:29:14PM -0500, Justin Piszcz wrote:
> Dave,
> 
> What is the proper sunit and swidth for a 64, 256, and 1024 kilobyte chunk 
> size with a 10-disk raid 5?
> 
> Also, in the majority of benchmarks it does not seem to matter whether the 
> FS is stripe-aligned or not (with SW raid)- does it mainly/only affect HW 
> raid?

Affects both. If you are doing large I/O, both SW and HW raid will
avoid RMW cycles if you can do full stripe writes and that means
they go faster. The faster the RAID array, the bigger the difference
it will make.

If your tests are with small I/O or with a config that can't
do I/O large enough for full stripe writes, then you won't see
any difference as you're not avoiding RMW cycles.

> Current settings (10 disks):
> 
> # xfs_info /dev/md3
> meta-data=/dev/md3               isize=256    agcount=4, agsize=82417536 

Why 4 ags?

The low number of AGs is an optimisation for single disks,
not multi-disk arrays that have much more parallelism and
seek capacity available.

> blks
>          =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=329670144, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1

And you don't even have su/sw set here, so XFS won't be doing
any alignment optimisation at all.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
