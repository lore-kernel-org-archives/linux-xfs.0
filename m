Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAR16nUU151457 for <xfs@oss.sgi.com>; Sat, 26 Nov 2011 19:06:50 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B17B919D1B66
	for <xfs@oss.sgi.com>; Sat, 26 Nov 2011 17:06:47 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xjq77MrS6xA4vLkH for <xfs@oss.sgi.com>;
	Sat, 26 Nov 2011 17:06:47 -0800 (PST)
Date: Sun, 27 Nov 2011 12:06:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
Message-ID: <20111127010643.GU2386@dastard>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111124195042.GA3671@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 24, 2011 at 05:50:42PM -0200, Carlos Maiolino wrote:
> On Thu, Nov 24, 2011 at 05:20:51PM -0200, Carlos Maiolino wrote:
> > xfsprogs (mainly mkfs) is using the logical sector size of a volume to initialize
> > the filesystem, which, even in devices using Advanced Format, it can get a 512
> > bytes sector size if it is set as the logical sector size.
> > This patch changes the ioctl to get the physical sector size, independent of the
> > logical size.
> > 
> 
> Just as information, this patch proposal does not change the behaviour of mkfs in case the 
> user is using libblkid, which in case, mkfs will take advantage of libblkid to retrieve disk
> topology and information.
> I'm not sure if libblkid is the best way to retrieve the device sector's size here, since 
> this does not provide a way to retrive the physical sector size, only the logical size, but 
> I can be very wrong.

If libblkid exports the PBS (physical block size) as exposed in
/sys/block/<dev>/queue/physical_block_size, then we should be able
to get it.

However, the issue in my mind is not whether it is supported, but
what is the effect of making this change? The filesystem relies on
the fact that the minimum guaranteed unit of atomic IO is a sector,
not the PBS of the underlying disk. What guarantees do we have when
do a PBS sized IO is doesn't get torn into sector sized IOs by the
drive and hence only partitially completed on failure?  Indeed, if
the filesystem is sector unaligned, it is -guaranteed- to have PBS
sized IOs torn apart by the hardware....

i.e. do we have any guarantee at all that a PBS sized IO will either
wholly complete or wholly fail when PBS != sector size? And if not,
why is this a change we should make given it appears to me to
violate a fundamental assumption of the filesystem design?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
