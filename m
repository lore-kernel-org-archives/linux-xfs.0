Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q471Z5u0144893 for <xfs@oss.sgi.com>; Sun, 6 May 2012 20:35:05 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EAWo6udasvlTJdqu for <xfs@oss.sgi.com>;
	Sun, 06 May 2012 18:35:04 -0700 (PDT)
Date: Mon, 7 May 2012 11:34:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: suddenly slow writes on XFS Filesystem
Message-ID: <20120507013456.GW5091@dastard>
References: <4FA63DDA.9070707@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA63DDA.9070707@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, May 06, 2012 at 11:01:14AM +0200, Stefan Priebe wrote:
> Hi,
> 
> since a few days i've experienced a really slow fs on one of our
> backup systems.
> 
> I'm not sure whether this is XFS related or related to the
> Controller / Disks.
> 
> It is a raid 10 of 20 SATA Disks and i can only write to them with
> about 700kb/s while doing random i/o.

What sort of random IO? size, read, write, direct or buffered, data
or metadata, etc? iostat -x -d -m 5 and vmstat 5 traces would be
useful to see if it is your array that is slow.....

> I tried vanilla Kernel 3.0.30
> and 3.3.4 - no difference. Writing to another partition on another
> xfs array works fine.
> 
> Details:
> #~ df -h
> /dev/sdb1             4,6T  4,4T  207G  96% /mnt

Your filesystem is near full - the allocation algorithms definitely
slow down as you approach ENOSPC, and IO efficiency goes to hell
because of a lack of contiguous free space to allocate from.

> #~ df -i
> /dev/sdb1            4875737052 4659318044 216419008  96% /mnt

You have 4.6 *billion* inodes in your filesystem?

> Any ideas?

None until I understand your workload....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
