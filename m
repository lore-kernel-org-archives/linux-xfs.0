Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D15597CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 16:20:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3FDE1AC003
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:20:48 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vB9uMwfuxGrHxasd for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 14:20:45 -0700 (PDT)
Date: Thu, 14 Apr 2016 07:20:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfs: we don't need no steekin ->evict_inode
Message-ID: <20160413212041.GQ567@dastard>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-2-git-send-email-david@fromorbit.com>
	<20160413164110.GA8475@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160413164110.GA8475@infradead.org>
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
Cc: viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Wed, Apr 13, 2016 at 09:41:10AM -0700, Christoph Hellwig wrote:
> Al has been very unhappy about our destroy_inode abuse, and I'd
> reluctant to make it worse.

I don't have any problems with it at all. The VFS doesn't care
how we manage inode allocation or destruction, so I don't see
any problem with what we do outside the visibility of the VFS inode
life cycle.

> Why do we need to play games with i_mode when freeing?

Because the inode cache lookup XFS code uses i_mode == 0 to detect a
freed inode. i.e.  in xfs_iget_cache_miss/xfs_iget_cache_hit this is
used to allow XFS_IGET_CREATE to return a freed inodes still in the
cache during inode allocation. This is the only case where we are
allowed to find a freed inode in the cache lookup, so we have to be
able to detect it somehow.

Similarly, I'm pretty sure there are assumptions all through the XFS
code (both kernel and userspace) that i_mode = 0 means the inode is
free/unallocated. xfs_repair, for example, makes this assumption,
and so we have to zero the mode when freeing the inode...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
