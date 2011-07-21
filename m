Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6L6mhS2012056 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 01:48:44 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D486E1D89BA7
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 23:48:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GHQjmGW4lGqqsq76 for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2011 23:48:41 -0700 (PDT)
Date: Thu, 21 Jul 2011 16:48:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Message-ID: <20110721064838.GA13963@dastard>
References: <4E24907F.6020903@johnbokma.com> <201107201604.33419@zmi.at>
	<20110720230126.GH9359@dastard> <201107210820.01019@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107210820.01019@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: John Bokma <contact@johnbokma.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Thu, Jul 21, 2011 at 08:19:54AM +0200, Michael Monnerie wrote:
> On Donnerstag, 21. Juli 2011 Dave Chinner wrote:
> > No, they'll get sunit aligned but default, which would be on 64k
> > boundaries.
> 
> OK, so only when <quote Dave> "swalloc mount option set and the 
> allocation is for more than a swidth of space it will align to swidth 
> rather than sunit" </quote Dave>.
> 
> So even when I specify swalloc but a file is generated with only 4KB, it 
> will very probably be sunit aligned on disk.
>  
> > > That way, all stripes of a 1GB partition would be full when 
> > > there are roughly 1170 files (1170*896KiB ~ 1GB). What would happen
> > > when  I create other files - is XFS "full" then, or would it start
> > > using sub- stripes? If sub-stripes, would they start at su
> > > (=64KiB) distances, or at single block (e.g. 4KiB) distances?
> > 
> > It starts packing files tightly into remaining free space when no
> > free aligned extents are availble for allocation in the AG.
> 
> That means for above example, that 16384 x 2KiB files could be created, 
> and each be sunit aligned on disk. Then all sunit start blocks are full, 
> so additional files will be sub-sunit "packed", is it this?

Effectively.

> That would mean fragmentation is likely to occur from that moment, if 
> there are files that grow.

If you are writing files that grow like this, then you are doing
something wrong. If the app can't do it's IO differently, then this
is exactly the reason we have userspace-controlled preallocation
interfaces.

Filesystems cannot prevent user stupidity from screwing something
up....

> And files >64KiB are immediately fragmented 
> then. At this time, there are only 16384 * 2KiB = 32MiB used, which is 
> 3,125% of the disk. I can't believe my numbers, are they true?

No, because most filesystems have a 4k block size. Not to mention
that fragmentation is likely to be limited to the single AG the files
in the directory belong to. i.e. even if we can't allocation a sunit
aligned chunk in an AG, we won't switch to another AG just to do
sunit aligned allocation.

> OK, this is a worst case scenario, and as you've said before, any 
> filesystem can be considered full at 85% fill grade. But it's incredible 
> how quickly you could fuck up a filesystem when using su/sw and writing 
> small files.

Well, don't use a filesystem that is optimised for storing large
sizes, large files and high bandwidth for storing lots of small
files, then.  Indeed, the point of not packing the files is so they
-don't fragemnt as they grow-. XFS is not designed to be optimal
for small filesystems or small files. In most cases it will deal
with them just fine, so in reality your concerns are mostly
unfounded...

BTW, ext3/ext4 do exactly the same thing with spreading files out
over block groups before packing them tightly when there are not
more empty block groups left....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
