Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3DA0B7F37
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:46:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FC2C8F8052
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:46:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zYMz3KPzGJfE6r2l for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:46:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkpUn-0004Ya-C1
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkpUT-0003kc-80
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/17] xfs: don't use speculative prealloc for small files
Date: Fri,  7 Jun 2013 15:45:16 +1000
Message-Id: <1370583929-14276-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370583929-14276-1-git-send-email-david@fromorbit.com>
References: <1370583929-14276-1-git-send-email-david@fromorbit.com>
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

Dedicated small file workloads have been seeing significant free
space fragmentation causing premature inode allocation failure
when large inode sizes are in use. A particular test case showed
that a workload that runs to a real ENOSPC on 256 byte inodes would
fail inode allocation with ENOSPC about about 80% full with 512 byte
inodes, and at about 50% full with 1024 byte inodes.

The same workload, when run with -o allocsize=4096 on 1024 byte
inodes would run to being 100% full before giving ENOSPC. That is,
no freespace fragmentation at all.

The issue was caused by the specific IO pattern the application had
- the framework it was using did not support direct IO, and so it
was emulating it by using fadvise(DONT_NEED). The result was that
the data was getting written back before the speculative prealloc
had been trimmed from memory by the close(), and so small single
block files were being allocated with 2 blocks, and then having one
truncated away. The result was lots of small 4k free space extents,
and hence each new 8k allocation would take another 8k from
contiguous free space and turn it into 4k of allocated space and 4k
of free space.

Hence inode allocation, which requires contiguous, aligned
allocation of 16k (256 byte inodes), 32k (512 byte inodes) or 64k
(1024 byte inodes) can fail to find sufficiently large freespace and
hence fail while there is still lots of free space available.

There's a simple fix for this, and one that has precendence in the
allocator code already - don't do speculative allocation unless the
size of the file is larger than a certain size. In this case, that
size is the minimum default preallocation size:
mp->m_writeio_blocks. And to keep with the concept of being nice to
people when the files are still relatively small, cap the prealloc
to mp->m_writeio_blocks until the file goes over a stripe unit is
size, at which point we'll fall back to the current behaviour based
on the last extent size.

This will effectively turn off speculative prealloc for very small
files, keep preallocation low for small files, and behave as it
currently does for any file larger than a stripe unit. This
completely avoids the freespace fragmentation problem this
particular IO pattern was causing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8f8aaee..14be676 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -284,6 +284,15 @@ xfs_iomap_eof_want_preallocate(
 		return 0;
 
 	/*
+	 * If the file is smaller than the minimum prealloc and we are using
+	 * dynamic preallocation, don't do any preallocation at all as it is
+	 * likely this is the only write to the file that is going to be done.
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
+	    XFS_ISIZE(ip) < mp->m_writeio_blocks)
+		return 0;
+
+	/*
 	 * If there are any real blocks past eof, then don't
 	 * do any speculative allocation.
 	 */
@@ -345,6 +354,10 @@ xfs_iomap_eof_prealloc_initial_size(
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		return 0;
 
+	/* If the file is small, then use the minimum prealloc */
+	if (XFS_ISIZE(ip) < mp->m_dalign)
+		return 0;
+
 	/*
 	 * As we write multiple pages, the offset will always align to the
 	 * start of a page and hence point to a hole at EOF. i.e. if the size is
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
