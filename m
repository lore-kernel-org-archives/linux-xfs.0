Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CD947F51
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 21:19:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0A9F8F8033
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 19:19:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fYBMG1oRmWikjpEy for <xfs@oss.sgi.com>;
	Sun, 24 Aug 2014 19:19:41 -0700 (PDT)
Date: Mon, 25 Aug 2014 12:19:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inode64 directory placement determinism
Message-ID: <20140825021911.GX26465@dastard>
References: <e1eeba7b0fb97c63e41f40ed9ac162d7@localhost>
	<20140818070153.GL20518@dastard>
	<bc34a576d2b3e8c431633574deaa37cc@localhost>
	<20140818224853.GD26465@dastard>
	<ed7598d015f5a1d3576e6b03f3ef3116@localhost>
	<53FA47B4.6020103@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53FA47B4.6020103@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Sun, Aug 24, 2014 at 03:14:44PM -0500, stan hoeppner wrote:
> >The test harness app writes to thousands of preallocated files in hundreds
> >of directories.  The target is ~250MB/s at the application per array, more
> >if achievable, writing a combination of fast and slow streams from up to
> >~1000 threads, to different files, circularly.  The mix of stream rates and
> >the files they write will depend on the end customers' needs.  Currently
> >they have 1 FS per array with 3 top level dirs each w/3 subdirs, 2 of these
> >with ~100 subdirs each, and hundreds files in each of those.  Simply doing
> >a concat, growing and just running with it might work fine.  The concern is
> >ending up with too many fast stream writers hitting AGs on a single array
> >which won't be able to keep up.  Currently they simply duplicate the layout
> >on each new filesystem they mount.  The application duplicates the same
> >layout on each filesystem and does its own load balancing among the group
> >of them.
> >
> >Ideally they'd obviously like to simply add files to existing directories
> >after growing, but that won't achieve scalable bandwidth.
> 
> 
> My apologies Dave.  The above isn't really a description of a
> requirement, but simply how they do things currently.  So let me
> take another stab at this.  I think the generic requirement is best
> described as:
> 
> 	Create a directory in the first AG in a range of specified
> 	AGs.  Create all child directories and files in AGs within the
> 	range of AGs, starting with the first AG.  In other words, we
> 	take the default behavior of the inode64 allocator and we apply
> 	it to a subset of AGs within the filesystem.  Something like...
> 
> agr = allocation group range
> 
> 1.  mkdir $directory agr=0,47
> 
> 2.  create $directory in AG0 and set flag in metadata to have inode64
>     allocator rotor new child directories of this parent across only
>     the AGs in the range specified
> 
> 3.  file allocation policy need not be altered, files go in parent
>     directory, parent AG.  If we spill due to AG free space do what
>     we already do and allow writing outside of the AGs in agr
> 
> 
> So when we expand the concat and grow XFS we simply do
> 
> ~$ mkdir $directory agr=48,95
> 
> All child directories and files created in $directory will be
> allocated in AGs 48-95, only on the new LUN.  Rinse and repeat.

So you want a persistent, configurable AG rotor for a specific
directory and all it's children?  That's not all that simple to do,
because there's no direct connection between the top level directory
and indirect children.

What you are really asking for is a specific instance of the more
generic concept of specifying per-file allocation policy. That's
been on the radar for a long time, but it's not as simple as it
first sounds.  This is something i started prototyping years ago
when I was back at SGI:

http://oss.sgi.com/archives/xfs/2009-02/msg00250.html

but that patch series is *extremely* experimental. There are parts
we should pull from it to start putting generic allocation policy
frameworks in place, but the really difficult part of per-file
allocation policy is the bit that I never got to:

	1. persistence and what to do with kernels that don't
	understand specific policies
	2. how to do the policies generically so that we don't make
	a huge mess of the code.
	3. user interface for managing policies is has not been
	really thought through.

SO, if someone wants a project that will keep them busy for many,
many months...

> Due to the timetable and other restrictions I wouldn't be able to
> use patches that might come from fleshing out our ideas here, but I
> think it would be very useful functionality for others.

Yes, such things have long been considered useful. The problem is
finding enough people to implement all the stuff we consider
useful...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
