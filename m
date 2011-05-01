Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p418kFAf165366 for <xfs@oss.sgi.com>; Sun, 1 May 2011 03:46:16 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8231B1573E2C
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 01:49:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	zyBv1IGrb8QID72S for <xfs@oss.sgi.com>;
	Sun, 01 May 2011 01:49:36 -0700 (PDT)
Date: Sun, 1 May 2011 18:49:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs performance problem
Message-ID: <20110501084919.GE13542@dastard>
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB75C6D.1080901@inf.ethz.ch>
	<19898.53907.842827.480883@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19898.53907.842827.480883@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Fri, Apr 29, 2011 at 04:00:35PM +0100, Peter Grandi wrote:
> 
> [ ... ]
> 
> > On my raid-1 ext3, extracting a kernel archive:
> [ ... ]
> > real    0m21.769s
> [ ... ]
> > real    2m20.522s
> 
> > This is of course with delaylog enabled. I don't think a
> > difference of a factor 7 is normal, given that writing to a
> > raid-0 (xfs numbers) is supposed to be faster than writing to
> > raid-1 (ext3 numbers)
> 
> Indeed, and as some other commenters have tried to explain, in
> most cases the wrong number is the one for 'ext3' on RAID1 (way
> too small). Even the number for XFS and RAID0 'delaylog' is a
> wrong number (somewhat small) in many cases.
> 
> There are 38000 files in 440MB in 'linux-2.6.38.tar', ~40% of
> them are smaller than 4KiB and ~60% smaller than 8KiB. Also you
> didn't flush caches, and you don't say whether the filesystems
> are empty or full or at the same position on the disk.
> 
> Can 'ext3' really commit 1900 small files per second (including
> directory updates) to a filesystem on a RAID1 that probably can
> do around 100 IOPS? That would be amazing news.

Of course it can.  Why? Because the allocator is optimised to pack
small files written at the same time together on disk, and the
elevator will merge them into one large IO when they are finally
written to disk. With a typical 512k max IO size, that's 128 <=4k
files packed into each IO, In a perfect world, we're talking about
~13000 4k files a second being written to disk @ 100 IOPS. In the
real world, writing an order of magnitude less files per second is
quite obtainable.

Even XFS enables that same optimisation by truncating away
speculative allocation when the file is closed so that when
writeback comes along delayed allocation packs the data blocks
belonging to different files tightly within the AG.

Such optimisations are not new - they've been used in some form
for as long as spinning media has been around....

> Despite decades of seeing it happen, I keep being astonished by
> how many people (some with decades of "experience") just don't
> understand IOPS and metadata and commits and caching and who

Oh, the irony.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
