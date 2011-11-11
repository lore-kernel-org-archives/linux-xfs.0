Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAB1Tunx152706 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 19:29:56 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E25BC1D01CEC
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 17:29:54 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CCDxPjQIkWMGrUu6 for <xfs@oss.sgi.com>;
	Thu, 10 Nov 2011 17:29:54 -0800 (PST)
Date: Fri, 11 Nov 2011 12:29:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfsprogs: xfs_db: add new "resvsp" command
Message-ID: <20111111012950.GC2386@dastard>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
	<122161c271ee994b758daafe4e0756cae784950b.1320955676.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <122161c271ee994b758daafe4e0756cae784950b.1320955676.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Kevan Rehm <kfr@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 02:35:18PM -0600, Alex Elder wrote:
> From: Kevan Rehm <kfr@sgi.com>
> 
> This patch adds a new "resvsp" command to xfs_db.  The command
> provides access to the xfsctl(3) XFS_IOC_RESVSP64 operation, which
> allocates space in an ordinary file.  Blocks are allocated but not
> zeroed, and the file size does not change.

The commit message fails to answer the most important question of
all: what is the use case that requires adding offline preallocation
of extents to arbitrary inodes?

Conceptually, I don't think high level functionality like extent
allocation belongs in xfs_db:

	- extent allocation is effectively an open-ended, multi-step
	  modification that can touch large amounts of metadata
	  across all AGs in the filesystem,

	- userspace extent allocation code is rarely used and as
	  such nowhere near as well tested as the kernel code.

	- userspace extent allocation does not support real time
	  device allocation at all:

	  #define xfs_bmap_rtalloc(a)                     (ENOSYS)

	- modifications made by xfs_db are not transactional and
	  therefore not recoverable if the system dies during such
	  an operation. Such a failure means you have to run a
	  xfs_reapir pass on your filesystem to clean up the mess
	  that was left behind....

	- we already have tools to do space reservation online
	  (i.e. xfs_io -c "resvsp off len" testfile) in a safe
	  manner that also supports realtime device allocation. Why
	  duplicate this functionality in a different tool?


.....

> +static void
> +resvsp_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +"The resvsp function is essentially an implementation of the xfsctl(3)\n"
> +"file operation XFS_IOC_RESVSP64 which allocates space in an ordinary\n"
> +"file.

Probably no need to mention the ioctl here - preallocation is a well
enough known function now that simply calling it "an extent
preallocation operation" is sufficient to explain what it is for.

> Blocks are allocated but not zeroed, and the file size does not\n"
> +"change.  The -o option is the starting offset for the allocation (default 0)\n"
> +"and the -l option gives the length of the allocation in bytes (default to\n"
> +"end of file).  Both offset and length values will be rounded to a filesystem\n"
> +"block boundary.  'inode#' is the inode number of the file in which to\n"
> +"perform the allocation.  If none is specified, the current inode is used.\n"
> +"If the -w option is specified, the allocated extents will not be flagged as\n"
> +"unwritten.  Use this option with care, as someone with read permission\n"
> +"to the file can then read whatever is written in those blocks.\n"

I'm on record as being totally against making it easy for -anyone-
to preallocate _written_ extents via -any method- because it's just
a whopping great big security hole. "Use care" is not a good enough
protection against the potential of exposing large amount of stale
data to any user that can read the file, even though only root can
do that preallocation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
