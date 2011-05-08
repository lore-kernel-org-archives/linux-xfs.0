Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p480Tk60001858 for <xfs@oss.sgi.com>; Sat, 7 May 2011 19:29:46 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BC611D66CD7
	for <xfs@oss.sgi.com>; Sat,  7 May 2011 17:33:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MpCP3LTH1tifoq1y for <xfs@oss.sgi.com>;
	Sat, 07 May 2011 17:33:25 -0700 (PDT)
Date: Sun, 8 May 2011 10:33:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.38.4: xfs speed problem?
Message-ID: <20110508003321.GI26837@dastard>
References: <alpine.DEB.2.02.1105071042210.20162@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1105071042210.20162@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, May 07, 2011 at 12:09:46PM -0400, Justin Piszcz wrote:
> Hello,
> 
> Using 2.6.38.4 on two hosts:
> 
> Host 1:
> $ /usr/bin/time find geocities.data 1> /dev/null
> 80.92user 417.93system 2:19:07elapsed 5%CPU (0avgtext+0avgdata 105520maxresident)k
> 0inputs+0outputs (0major+73373minor)pagefaults 0swaps
> 
> # xfs_db -c frag -f /dev/sda1
> actual 40203982, ideal 40088075, fragmentation factor 0.29%
> 
> meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=11718704640, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> --
> 
> Host 2:
> $ /usr/bin/time find geocities.data 1>/dev/null
> 54.60user 337.20system 48:42.71elapsed 13%CPU (0avgtext+0avgdata 105632maxresident)k
> 0inputs+0outputs (1major+72981minor)pagefaults 0swaps
> 
> # xfs_db -c frag -f /dev/sdb1
> actual 37998306, ideal 37939331, fragmentation factor 0.16%
> 
> meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=2441379328, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> --
> 
> Host 1: RAID-6 (7200 RPM Drives, 18+1 hot spare)

Those will be 3TB drives

> Host 2: RAID-6 (7200 RPM Drives, 12)

and those are 1TB drives.

Different hardware is guaranteed to give you different performance,
especially from a seek capability perspective.

> Each system uses a 3ware 9750-24i4e controller, same settings.
> 
> Any thoughts why one is > 2x faster than the other?

Different filesystem sizes mean different directory, inode and data
layouts, especially if you are using inode64.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
