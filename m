Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 950797F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:17:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8340F304039
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 13:17:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vDi5yGREq3pm8Wsi for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 13:17:01 -0700 (PDT)
Date: Tue, 15 Oct 2013 07:16:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: stop caching inode structures
Message-ID: <20131014201659.GN4446@dastard>
References: <20131009130241.GA8754@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131009130241.GA8754@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 09, 2013 at 06:02:41AM -0700, Christoph Hellwig wrote:
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
> So except in repair we never ever reuse a cached inode, and even in repair
> the logical inode caching doesn't help:
> 
>  - in phase 6a we iterate over each inode in the incore inode tree,
>    and if it's a directory check/rebuild it
>  - phase6b then updates the "." and ".." entries for directories
>    that need, which means we require the backing buffers.
>  - phase6c moves disconnected inodes to lost_found, which again needs
>    the backing buffer to actually do anything.
>  - phase7 then only touches inodes for which we need to reset i_nlink,
>    which always involves reading, modifying and writing the physical
>    inode.
>    which always involves modifying the . and .. entries.
> 
> Given these facts stop caching the inodes to reduce memory usage
> especially in xfs_repair, where this makes a different for large inode
> count inodes.  On the upper end this allows repair to complete for
> filesystem / amount of memory combinations that previously wouldn't.

This all sounds good and the code looks fine, but there's one
lingering question I have - what's the impact on performance for
repair? Does it slow down phase 6/7 at all?

> With this we probably could increase the memory available to the buffer
> cache in xfs_repair, but trying to do so I got a bit lost - the current
> formula seems to magic to me to make any sense, and simply doubling the
> buffer cache size causes us to run out of memory given that the data cached
> in the buffer cache (typically lots of 8k inode buffers and few 4k other
> metadata buffers) are much bigger than the inodes cached in the inode
> cache.  We probably need a sizing scheme that takes the actual amount
> of memory allocated to the buffer cache into account to solve this better.

IIRC, the size of the buffer cache is currently set at 75% of RAM
so doubling it would cause OOM issues regardless of the presence of
the inode cache....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
