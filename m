Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAPAE48d254908 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 04:14:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A47C013EC3BD
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 02:15:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	9LVNxtyblP2KR7O4 for <xfs@oss.sgi.com>;
	Thu, 25 Nov 2010 02:15:41 -0800 (PST)
Date: Thu, 25 Nov 2010 21:15:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Verify filesystem is aligned to stripes
Message-ID: <20101125101537.GD12187@dastard>
References: <4CED5BFC.8000906@shiftmail.org> <20101125054607.GM13830@dastard>
	<4CEE0995.9030900@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEE0995.9030900@hardwarefreak.com>
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

On Thu, Nov 25, 2010 at 01:00:37AM -0600, Stan Hoeppner wrote:
> Dave Chinner put forth on 11/24/2010 11:46 PM:
> 
> > Because writes for workloads like this are never full stripe writes.
> > Hence reads must be done to pullin the rest of the stripe before the
> > new parity can be calculated. This RMW cycle for small IOs has
> > always been the pain point for stripe based parity protection. If
> > you are doing lots of small IOs, RAID1 is your friend.
> 
> Do you really mean RAID1 here Dave, or RAID10?  If RAID1, please
> elaborate a bit.

RAID10 is just a convenient way of saying "striped mirrors" or
"mirrored stripes". Fundamentally they are still using RAID1 for
redundancy - a mirror of two devices. A device could be a single
drive or a stripe of drives.

> RAID1 traditionally has equal read performance to a
> single device, and half the write performance of a single device.

A good RAID1 implementation typically has the read performance of
two devices (i.e. it can read from both legs simultaneously) and the
write performance of a single device.

Parity based RAID is only fast for large write IOs or small IOs that
are close enough together that a stripe cache can coalesce them into
large writes. If this can't be acheived, parity based raid will be
no faster than a _single drive_ for writes because all drives will
be involved in RMW cycles. Indeed, I've seen RAID5 luns be saturated
at only 50 iops because every IO required a RMW cycle, while an
equivalent number of drives using RAID1 of RAID0 stripes did 1,000
iops...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
