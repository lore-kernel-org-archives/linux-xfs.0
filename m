Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D1CE7F81
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C4898F8059
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qWCfGhMG9yznd2ay for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xx-VT
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007Md-UU
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 14/17] xfs: separate inode freeing
	from inactivation
Date: Mon, 12 Aug 2013 23:20:04 +1000
Message-Id: <1376313607-28133-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-1-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Inode freeing and unlinked list processing is done as part of the
inactivation transaction when the last reference goes away from the
VFS inode. While it is advantageous to truncate away all the extents
allocated to the inode at this point, it is not necesarily in our
best interests to free the inode immediately.

While the inode is on the unlinked list and there are no more VFS
references to the inode, it is effectively a free inode - the
unlinked list reference tells us this rather than the inode btree
marking the inode free.

If we separate the actual freeing of the inode from the VFS
references, we have an inode that we can reallocate for use without
needing to pass it through the inode allocation btree. That is, we
can allocate directly from the unlinked list in the AG. We already
have the ability to do this for the O_TMPFILE/linkat(2) case where
we allocate directly to the unlinked list and then later link the
referenced inode to a directory and remove it from the unlinked
list.

In this case, if we have an unreferenced inode on the unlinked list,
we can allocate it directly simply by removing it from the unlinked
list. Further, O_TMPFILE allocations can be made effectively without
any transactions being issued at all if there are already free,
unreferenced inodes on the unlinked list.

Hence we need a method of finding inodes that are unreferenced but
on the unlinked list availble for allocation. A simple method for
doing this is using a inode cache radix tree tag on the inodes that
are unlinked and unreferenced but still on the unlinked list. A
simple tag check can tell us if there are any available for this
method of allocation, so there's no overhead to determine what
method to use.

Further, by using a radix tree tag we can use an inode cache
iterator function to run a periodic worker to remove inodes from the
unlinked list and mark them free in the inode btree. This the
advantage of doing the inode freeing in the background is that we do
not have to worry about how quickly we can remove inodes from the
unlinked list as it is not longer in the fast path. This enables us
to use trylock semantics for freeing the inodes and so we can skip
inodes we'd otherwise block on.

Alternatively, we can use the presence of the radix tree tag to
indicate that we need to walk the unlinked inode lists freeing
inodes from them. This may seem appealing until we realise that each
inode on a unlinked list belongs to a different inode chunk due
to the hashing function used. Hence every inode we free will modify
different btree record and so there is no locality of modification
in the inode btree structures and inode backing buffers.

If we use a radix tree walk, we will process all the free inodes in
a chunk and hence keep good CPU cache locality for all the data
structures that we need to modify for freeing those inodes. This
will be more CPU efficient as the data cache footprint of the walk
will be much smaller and hence we'll stall the CPU a lot less
waiting for cache lines to be loaded from memory.

This background freeing process allows us to make further changes to
the unlinked lists that avoid unsolvable deadlocks. For example, if
we cannot lock inodes on the unlinked list, we can simply have the
freeing of the inode retried again at some point in the future
automatically.

Finally, we need an inode flag to indicate that the inode is in this
special unlinked, unreferenced state when lockless cache lookups are
done. This ensures that we can safely avoid these inodes as lookup
circumstances allow and work correctly with the inode reclaim state
machine. e.g. for allocaiton optimisations, we want to be able to
find these inodes, but for all other lookups we want an ENOENT to be
returned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_vnodeops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index dc730ac..db712fb 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -374,6 +374,8 @@ xfs_inactive(
 
 	ASSERT(ip->i_d.di_anextents == 0);
 
+	/* this is where we need to split inactivation and inode freeing */
+
 	/*
 	 * Free the inode.
 	 */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
