Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q74MhfbH087858 for <xfs@oss.sgi.com>; Sat, 4 Aug 2012 17:43:41 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7X60LU8MCsUk8Rt9 for <xfs@oss.sgi.com>;
	Sat, 04 Aug 2012 15:43:40 -0700 (PDT)
Date: Sun, 5 Aug 2012 08:43:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs / planned resize / performance impact
Message-ID: <20120804224336.GS2877@dastard>
References: <5017E426.2040709@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5017E426.2040709@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 31, 2012 at 03:56:54PM +0200, Stefan Priebe - Profihost AG wrote:
> Hello list,
> 
> i'm planning to create a couple of VMs with just 30GB of space while
> using xfs as the main filesystem.
> 
> Now i alreay know that some of the VMs will grow up to 250GB while
> resizing the block device and using xfs_growfs.

Just use thin provisioning and make it 250GB to begin with. Thin
provisioning mades filsystem grow/shrink pretty much redundant....

> Should i take care of that and format these disks with special parameters?
> 
> I've discovered that a 500GB volume has agcount=4 and 64000 blocks
> of internal log - while a 300GB volume resized to 500GB has agcount
> 7 ad only 40960 blocks of internal log.

I doubt you'll ever notice the difference.

> Is it a problem if this grow will happen in small portions (30GB =>
> 50GB => 75GB => 100GB => ... 300GB)?

Growing a filesystem by an order of magnitude is the limit of what
I'd suggest is sane. Growing it by two orders of magnitude
(espcially if you start with a 16 AG filesystem because of stripe
alignment) is going to cause problems with the number of AGs and
the subsequent freespace management scale issue....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
