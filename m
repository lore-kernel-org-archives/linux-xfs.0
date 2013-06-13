Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D6E077F61
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 20:14:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A75748F8049
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 18:14:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XkBwgBUvds95rCyT for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 18:14:19 -0700 (PDT)
Date: Thu, 13 Jun 2013 11:14:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/27] xfs: split out xfs inode operations into separate
	file
Message-ID: <20130613011414.GB29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-19-git-send-email-david@fromorbit.com>
	<20130612140519.GB28988@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130612140519.GB28988@infradead.org>
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

On Wed, Jun 12, 2013 at 07:05:19AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 12, 2013 at 08:22:38PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The core xfs inode operations such as locking, allocation, reading
> > and writing are not shared with userspace. However, much of the
> > remaining internal inode code such as the incore extent tracking and
> > formatting is. Split the XFS inode operations out into a new
> > xfs_inode_iops.c file to minimise the differences between the files
> > shred with userspace.
> 
> Having struct xfs_inode in an xfs_inode_ops.h file while xfs_inode.h
> is still around strikes me as extremely odd.

Consider it a first step in a longer process....

> It seems like icdinode
> should be in xfs_inode_item.h as is part of the log format primarily.

Yes, I've definitely been looking at that, because xfs_inode_item.h is
shared with userspace and there are some issues with cyclic
inclusion and definitions in userspace based around the fact that
the icdinode is defined in xfs_inode.h and so needs to be included
before the struct xfs_inode is defined in include/libxfs.h. Yet
there is static inline code in xfs_inode.h that needs to know the
structure of the struct xfs_inode....

So there's a bunch of issues around xfs_inode.h, and this really is
the first step to cleaning it all up. What currently remains in
xfs_inode.h can be moved to different files - most of what is there
deals with inode forks or the xfs_icdinode, and so if I move them to
specific header files we ned up with an empty xfs_inode.h header.

At taht point, we can stop sharing xfs_inode.h with userspace, and
we can move all the kernel-only inode defintions back into
xfs_inode.h, and #include all the other header files with the shared
definitions directly. Userspace can do the same thing through
libxfs.h....

Indeed, the underlying reason for all this separation is that in the
medium term, __KERNEL__ is going to be removed from the kernel
build. That's the direction being set by all the UAPI work that
David Howells has been doing, and XFS is really a special snowflake
when it comes to headers and userspace code sharing. Hence I'm
trying to restructure the code now while we are doing lots of
userspace work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
