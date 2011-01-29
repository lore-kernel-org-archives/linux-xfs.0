Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0T0EcFH181004 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 18:14:38 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16CED126E041
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 16:17:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bt0VQTL6rfbHkkpO for <xfs@oss.sgi.com>;
	Fri, 28 Jan 2011 16:17:02 -0800 (PST)
Date: Sat, 29 Jan 2011 11:17:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Preallocation
Message-ID: <20110129001700.GZ21311@dastard>
References: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
	<20110128045205.GR21311@dastard>
	<155CAEA5D902E7429569DD197567724A01534D60@mail1.ad.kinetx.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155CAEA5D902E7429569DD197567724A01534D60@mail1.ad.kinetx.com>
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
To: Jef Fox <jef.fox@kinetx.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 28, 2011 at 10:33:03AM -0700, Jef Fox wrote:
> I guess, disregard my previous message.  After some further testing of
> examining the hard disk blocks, we see what you are saying - the file is
> presented at 0s to the user even if the blocks are changed on the hard
> disk.  So, we will always see 0s until we write to the extent.
> 
> So, I think our only question now is if there is a way to force the
> extents to be marked as allocated without writing all of the data?  That
> is, is there a fast way to lay down a file(s) of 1G size without
> actually writing 1G of info.

Preallocation is the only option. Allowing preallocation without
marking extents as unwritten opens a massive security hole (i.e.
exposes stale data) so I say no to any request for addition of such
functionality (and have for years).

You've already demonstrated the workaround you can apply to the
problem for your very specialised application - when you put the
disk back into the original machine you can read the disk blocks
directly to get the data. i.e. use fiemap to map the location of the
file on disk and then read the data directly from the block device
underneath the filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
