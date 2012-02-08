Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q185BUwX036498 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 23:11:30 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EYgYaPQ4K2hfFYD8 for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 21:11:28 -0800 (PST)
Date: Wed, 8 Feb 2012 16:11:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: stop caching inode structures
Message-ID: <20120208051126.GF20305@dastard>
References: <20120207182228.GA18801@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120207182228.GA18801@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 07, 2012 at 01:22:28PM -0500, Christoph Hellwig wrote:
> Currently libxfs has a cache for xfs_inode structures.  Unlike in kernelspace
> where the inode cache, and the associated page cache for file data is used
> for all filesystem operations the libxfs inode cache is only used in few
> places:
> 
>  - the libxfs init code reads the root and realtime inodes when called from
>    xfs_db using a special flag, but these inode structure are never referenced
>    again
>  - mkfs uses namespace and bmap routines that take the xfs_inode structure
>    to create the root and realtime inodes, as well as any additional files
>    specified in the proto file
>  - the xfs_db attr code uses xfs_inode-based attr routines in the attrset
>    and attrget commands
>  - phase6 of xfs_repair uses xfs_inode-based routines for rebuilding
>    directories and moving files to the lost+found directory.
>  - phase7 of xfs_repair uses struct xfs_inode to modify the nlink count
>    of inodes.
> 
> So except in repair we never ever reuse a cached inode, and in repair we can
> easily read the information from the more compact cached buffers (or even
> better rewrite phase7 to operate on the raw on-disk inodes).  Given these
> facts stop caching the inodes to reduce memory usage especially in xfs_repair.

Ok, so what does it do to the speed of phase6 and phase7 of repair?
How much CPU overhead does this add to every inode lookup done in
these phases?

Indeed, there are cases where individual inode caching is much more
memory efficient than keeping the buffers around (think sparse inode
chunks on disk where only a few of the 64 inodes are actually
allocated). Tracking them in buffers (esp. if the inode size is
large) could use a lot more memory than just caching the active
inodes in a struct xfs_inode. Hence I'm not so sure this is clear
cut win for memory usage.

Do you have any numbers for memory usage or performance?

The code changes are simple enough, so if it is actually a win then
I see no problems with doing this. But that's what I need more
information about to be convinced on....

> With this we probably could increase the memory available to the buffer
> cache in xfs_repair, but trying to do so I got a bit lost - the current
> formula seems to magic to me to make any sense, and simply doubling the
> buffer cache size causes us to run out of memory given that the data cached

IIRC, that's because the current formula sets the buffer cache size
to 75% of physical RAM on the machine. Doubling it will definitely
cause problems ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
