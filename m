Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FAB17F63
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 20:39:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9FF5304051
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 18:39:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LtSigWxoV0ppmoLW for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 18:39:08 -0700 (PDT)
Date: Thu, 13 Jun 2013 11:39:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/27] xfs: consolidate xfs_vnodeops.c into xfs_inode_ops.c
Message-ID: <20130613013907.GC29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-20-git-send-email-david@fromorbit.com>
	<20130612135916.GA28988@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130612135916.GA28988@infradead.org>
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

On Wed, Jun 12, 2013 at 06:59:16AM -0700, Christoph Hellwig wrote:
> I can't say I really like the _ops naming, but so far I can't really
> can't come up with a much better name.

Neither could I :(

> I also think that most of
> xfs_vnodeops.c really should go into xfs_iops.c as it's fairly Linux
> specific and should just be merged with the actual entry points.

Yes, that's definitely a good end goal (merging with entry points),
but what I'm trying to do now is create a solid obvious demarcation
line between kernel-only and shared source files. The current code
goes:

	xfs_iops.c ->  xfs_inode.c		(shared with libxfs)
		   ->  xfs_vnodeops.c		(kernel only)
		   ->  xfs_rename.c		(kernel only)
		   ->  xfs_util.c		(kernel only)

And there's a tricky maze of paths through those files for different
locking operations, inode allocation, and so on. The real issue is
that the code paths hop between shared and kernel only files, so
what I'm wanting to end up with for 3.11 is a linear progression
through the source files like this:

	xfs_iops.c -> xfs_inode_ops.c -> xfs_inode.c
				      -> xfs_ialloc.c

i.e:

	kernel only -> kernel only -> shared with libxfs

Once there's a clear boundary in the kernel code,
merging/simplifying stuff on either side of the boundary is easy to
do, but it's a secondary step. I'd consider this something for the
3.12 cycle, not the upcoming 3.11 cycle.

FWIW, I seriously considering introducing a fs/xfs/libxfs/ subdir
for the kernel build to make this a very obvious boundary and place
all the shared headers in include/linux/uapi/xfs. This would make is
extremely obvious what code is shared with userspace, and make
future kernel/user srouce code syncs quite simple....

> Also once the big code move around starts xfs_rename.c really should
> die and rename should be treated the same as the other namespace
> operations.

Yup, I haven't got to xfs_rename.c and xfs_utils.c yet - I want them
to go away, too. :) I'm just going to pull them directly into
xfs_inode_ops.c to give a consistent structure for 3.11.

FWIW, now that I have the shared files in almost perfect sync, it
makes it much easier to make the change in the kernel tree, take the
patch, apply a couple of sed filters to it and then apply it
directly to the xfsprogs tree. I only have to do the work once now,
and so it's much faster to restructure the code now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
