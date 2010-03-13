Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2D0EucX038641 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 18:14:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F4F32387B9
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 16:16:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	9EoFyZHgTjGgCsKm for <xfs@oss.sgi.com>;
	Fri, 12 Mar 2010 16:16:29 -0800 (PST)
Date: Sat, 13 Mar 2010 11:16:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS buffered sequential read performance low after kernel upgrade
Message-ID: <20100313001626.GE4732@dastard>
References: <4B9A2A00.1050304@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B9A2A00.1050304@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 12, 2010 at 05:48:16AM -0600, Stan Hoeppner wrote:
> Hello,
> 
> I'm uncertain whether this is the best place to bring this up.  I've been
> lurking a short while and it seems almost all posts here deal with dev
> issues.  On the off chance this is an appropriate forum, here goes.
....
> hdparm test results for the filesystems:
> 
> /dev/sda2:
>  Timing O_DIRECT disk reads:  236 MB in  3.01 seconds =  78.48 MB/sec
> /dev/sda2:
>  Timing buffered disk reads:  172 MB in  3.03 seconds =  56.68 MB/sec
> 
> /dev/sda6:
>  Timing O_DIRECT disk reads:  238 MB in  3.00 seconds =  79.21 MB/sec
> /dev/sda6:
>  Timing buffered disk reads:  116 MB in  3.03 seconds =  38.27 MB/sec
> 
> /dev/sda7:
>  Timing O_DIRECT disk reads:  238 MB in  3.01 seconds =  79.10 MB/sec
> /dev/sda7:
>  Timing buffered disk reads:  114 MB in  3.00 seconds =  37.99 MB/sec

Those tests don't go through the filesystem - they go directly to the
block device. Hence if these are different to your old kernel, the
problem is outside XFS. I'd suggest the most likely cause is the
elevator - if you are using CFQ try turning off the new low-latency
mode, or changing to deadline or noop and see if the problem goes
away.

Also, the XFS partitions are on the inner edge of the disk, so they
are always going to be slower (can be as low as half the speed) than
partitions on the outer edge of the disk for sequential access...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
