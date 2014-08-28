Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C66F17F3F
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 18:29:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52517AC001
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 16:29:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	752iW49yFYcS868T for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 16:29:17 -0700 (PDT)
Date: Fri, 29 Aug 2014 09:29:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Find hardlinks to a file
Message-ID: <20140828232915.GV20518@dastard>
References: <CAGdUFVa3e7VPcmkn3OvcVenXTCedffXov_YSg427aVvURDRUSg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdUFVa3e7VPcmkn3OvcVenXTCedffXov_YSg427aVvURDRUSg@mail.gmail.com>
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
To: Chris Holcombe <xfactor973@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 04:14:25PM -0700, Chris Holcombe wrote:
> My apologies if this has already been asked.  I feel that I've done a
> sufficient amount of Google search homework.  I'm working with Gluster
> (http://www.gluster.org/) and they have a directory called xattrop
> where they store links to files that need to be healed.  When I stat
> the file I can see that there's 2 or 3 hard links to the file.  I
> can't seem to find a way in code or with an xfs_* utility to find the
> path of those hard links.  Does anyone know how to do this or if it's
> even possible?  From looking through the XFS documentation I don't
> really see a way to do it without a find /mount_point -num <number>
> brute force method.  btrfs has a utility called:
> 
> btrfs inspect-internal inode-resolve [-v] <inode> <path>
>               Resolves an <inode> in subvolume <path> to all filesystem
>               paths.
> 
> I'd like to build an equivalent tool in C for XFS if it's possible.

You need help from the filesystem, both in terms of the on-disk
format and the kernel code needed to push that information back out
to userspace. Indeed, this is the functionality we need for reverse
inode->path lookups:

http://thread.gmane.org/gmane.comp.file-systems.xfs.general/27772

(parent pointers, for those that don't want to follow the link)

Right now it's state is in limbo. We have a more recent design,
but since SGI has dropped off the edge of the world, nobody is
working on it.

It's on my radar along with reverse mapping btrees for filesystem
block to inode lookups so that we can do all of this sort of stuff
easily without needing to walk the entire filesystem to find the
forward pointers to objects....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
