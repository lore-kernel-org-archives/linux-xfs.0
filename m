Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B7E57F8E
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 16:26:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 794438F8033
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 14:26:08 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dFyjWlVFzU6PrGWy for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 14:26:06 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 6/6] xfs: lock out page faults from extent swap operations
Date: Thu,  8 Jan 2015 09:25:43 +1100
Message-Id: <1420669543-8093-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1420669543-8093-1-git-send-email-david@fromorbit.com>
References: <1420669543-8093-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

From: Dave Chinner <dchinner@redhat.com>

Extent swap operations are another extent manipulation operation
that we need to ensure does not race against mmap page faults. The
current code returns if the file is mapped prior to the swap being
done, but it could potentially race against new page faults while
the swap is in progress. Hence we should use the XFS_MMAPLOCK_EXCL
for this operation, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 22a5dcb..1420caf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1599,13 +1599,6 @@ xfs_swap_extent_flush(
 	/* Verify O_DIRECT for ftmp */
 	if (VFS_I(ip)->i_mapping->nrpages)
 		return -EINVAL;
-
-	/*
-	 * Don't try to swap extents on mmap()d files because we can't lock
-	 * out races against page faults safely.
-	 */
-	if (mapping_mapped(VFS_I(ip)->i_mapping))
-		return -EBUSY;
 	return 0;
 }
 
@@ -1633,13 +1626,14 @@ xfs_swap_extents(
 	}
 
 	/*
-	 * Lock up the inodes against other IO and truncate to begin with.
-	 * Then we can ensure the inodes are flushed and have no page cache
-	 * safely. Once we have done this we can take the ilocks and do the rest
-	 * of the checks.
+	 * Lock the inodes against other IO, page faults and truncate to
+	 * begin with.  Then we can ensure the inodes are flushed and have no
+	 * page cache safely. Once we have done this we can take the ilocks and
+	 * do the rest of the checks.
 	 */
-	lock_flags = XFS_IOLOCK_EXCL;
+	lock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
+	xfs_lock_two_inodes(ip, tip, XFS_MMAPLOCK_EXCL);
 
 	/* Verify that both files have the same format */
 	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
