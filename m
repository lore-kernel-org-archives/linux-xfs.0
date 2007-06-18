Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 12:47:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5IJkve2002574
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 12:47:24 -0700
Date: Mon, 18 Jun 2007 10:05:02 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS Tunables for High Speed Linux SW RAID5 Systems?
Message-ID: <20070618000502.GU86004887@sgi.com>
References: <Pine.LNX.4.64.0706151634130.26033@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706151634130.26033@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org

On Fri, Jun 15, 2007 at 04:36:07PM -0400, Justin Piszcz wrote:
> Hi,
> 
> I was wondering if the XFS folks can recommend any optimizations for high 
> speed disk arrays using RAID5?

[sysctls snipped]

None of those options will make much difference to performance.
mkfs parameters are the big ticket item here....


> There is also vm/dirty tunable in /proc.

That changes benchmark times by starting writeback earlier, but
doesn't affect actual writeback speed.

> I was wondering what are some things to tune for speed?  I've already 
> tuned the MD layer but is there anything with XFS I can also tune?
> 
> echo "Setting read-ahead to 64MB for /dev/md3"
> blockdev --setra 65536 /dev/md3

Why so large? That's likely to cause readahead thrashing problems
under low memory....

> echo "Setting stripe_cache_size to 16MB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
> 
> (also set max_sectors_kb) to 128K (chunk size) and disable NCQ

Why do that? You want XFS to issue large I/Os and the block layer
to split them across all the disks. i.e. you are preventing full
stripe writes from occurring by doing that.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
