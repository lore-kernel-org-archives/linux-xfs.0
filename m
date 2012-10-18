Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I59lxn151017 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 00:09:47 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yerUUs7GtLOrBtVk for <xfs@oss.sgi.com>;
	Wed, 17 Oct 2012 22:11:25 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/2] fiemap: filesystem free space mapping
Date: Thu, 18 Oct 2012 16:11:17 +1100
Message-Id: <1350537079-16246-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

So, I was bored a few days ago, and I was sick of having to run
xfs_db incorrectly report free space extents when the filesytem is
mounted, so I decided to extend fiemap to export freespace mappings
to userspace so I could get the information coherently through the
mounted filesystem.

Yes, this could probably be considered interface abuse but, well, it
was simple to do because extent mapping is exactly what fiemap is
designed to do. Hence I didn't have to write new walkers/formatters
and I was using code I knew worked correctly.

There are two methods of mapping - one is reporting free space in
ascending extent start offset order, then other in ascending extent
length order. Both a useful to have (e.g. defragmenter might want to
know about the nearest free block to given offset or the largest
free extent in a given region). Either way, XFS keeps indexes
ordered in both ways, so they can be exported directly with minimal
overhead.

The only "interesting" abuse of the interface is really the use of
FIEMAP_EXTENT_LAST. This means that the last extent in a freespace
index is being returned, rather than the last freespace extent. This
is done because filesystems often have multiple free space indexes,
and it may be difficult to sort/scan over multiple indexes in a
single map.

This means an application needs to keep track of what freespace has
been returned to it and adjust it's fiemap ranges apprpritately, or
be aware of the underlying filesystem structure to for requests that
don't span free space indexes. I don't see this a bug problem,
because any application that is digging in freespace maps needs to
know how the filesystem is structured to make any sense of the
infomration returned. As such, I see this interface purely for
filesystem diagnostics or utilities tightly bound to the filesystem
(e.g. xfs_fsr).

I'll attach a patch for a small utility that uses this interace to
replicate the xfs_db freespace command in a short while so people
can see how it is used. that shoul dmake it easier to comment on. :)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
