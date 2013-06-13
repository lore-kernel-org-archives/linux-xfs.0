Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B42F87F83
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 03:00:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 615B58F8049
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 01:00:19 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sCmzxGHN7pcDiUGW for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 01:00:17 -0700 (PDT)
Date: Thu, 13 Jun 2013 18:00:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/27] xfs: split out xfs inode operations into separate
	file
Message-ID: <20130613080009.GL29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-19-git-send-email-david@fromorbit.com>
	<20130612140519.GB28988@infradead.org>
	<20130613011414.GB29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130613011414.GB29338@dastard>
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

On Thu, Jun 13, 2013 at 11:14:14AM +1000, Dave Chinner wrote:
> On Wed, Jun 12, 2013 at 07:05:19AM -0700, Christoph Hellwig wrote:
> > On Wed, Jun 12, 2013 at 08:22:38PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The core xfs inode operations such as locking, allocation, reading
> > > and writing are not shared with userspace. However, much of the
> > > remaining internal inode code such as the incore extent tracking and
> > > formatting is. Split the XFS inode operations out into a new
> > > xfs_inode_iops.c file to minimise the differences between the files
> > > shred with userspace.
> > 
> > Having struct xfs_inode in an xfs_inode_ops.h file while xfs_inode.h
> > is still around strikes me as extremely odd.
> 
> Consider it a first step in a longer process....
> 
> > It seems like icdinode
> > should be in xfs_inode_item.h as is part of the log format primarily.
> 
> Yes, I've definitely been looking at that, because xfs_inode_item.h is
> shared with userspace and there are some issues with cyclic
> inclusion and definitions in userspace based around the fact that
> the icdinode is defined in xfs_inode.h and so needs to be included
> before the struct xfs_inode is defined in include/libxfs.h. Yet
> there is static inline code in xfs_inode.h that needs to know the
> structure of the struct xfs_inode....

And this is where it gets sticky. The xfs_inode_ops.h header has a
dependency on struct xfs_icdinode. Moving that to xfs_inode_item.h
means that we now have a dependencies of:

	xfs_inode_ops.h requires
		xfs_inode_item.h requires:
			xfs_trans.h requires:
				xfs_log.h

which are new. And it also introduces a circular dependency as
xfs_inode_item.h has a dependency on the struct xfs_inode already
being defined, so it can't be included before struct xfs_inode is
defined.....

As it is, xfs_inode_item.h still has a section under #ifdef
__KERNEL__. It's the section dealing with the struct inode_log_item,
and all the other logitem header files have similar kernel only
sections.  libxfs has it's own definitions for these structures, so
what we've got here is the shared on-disk log format definitions and
kernel-only log item definitions sharing the same files in the
kernel tree.

So what I really think needs to happen here first is similar to the
dir2 header file re-org. That is, a header file to define the
format, and a header file to define the in-kernel structures and
APIs....

The header files in XFS have never been properly sorted out - it's
about time we cleaned up this mess ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
