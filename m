Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58380 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750883AbeEBFvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 01:51:50 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fDkg6-0002O4-91
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 15:51:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fDkg6-0007Ww-7j
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 15:51:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: simplify xfs_file_iomap_begin() logic
Date: Wed,  2 May 2018 15:51:43 +1000
Message-Id: <20180502055144.28851-2-david@fromorbit.com>
In-Reply-To: <20180502055144.28851-1-david@fromorbit.com>
References: <20180502055144.28851-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The current logic that determines whether allocation should be done
has grown somewhat spaghetti like with the addition of IOMAP_NOWAIT
functionality. Separate out each of the different cases into single,
obvious checks to get rid most of the nested IOMAP_NOWAIT checks
in the allocation logic.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 82 ++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 046469fcc1b8..16565da67bb6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1040,6 +1040,10 @@ xfs_file_iomap_begin(
 			goto out_unlock;
 	}
 
+	/* Non-modifying mapping requested, so we are done */
+	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
+		goto out_found;
+
 	if (xfs_is_reflink_inode(ip) &&
 	    ((flags & IOMAP_WRITE) ||
 	     ((flags & IOMAP_ZERO) && needs_cow_for_zeroing(&imap, nimaps)))) {
@@ -1068,46 +1072,45 @@ xfs_file_iomap_begin(
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
 	}
 
-	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
-		/*
-		 * If nowait is set bail since we are going to make
-		 * allocations.
-		 */
-		if (flags & IOMAP_NOWAIT) {
-			error = -EAGAIN;
-			goto out_unlock;
-		}
-		/*
-		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
-		 * pages to keep the chunks of work done where somewhat symmetric
-		 * with the work writeback does. This is a completely arbitrary
-		 * number pulled out of thin air as a best guess for initial
-		 * testing.
-		 *
-		 * Note that the values needs to be less than 32-bits wide until
-		 * the lower level functions are updated.
-		 */
-		length = min_t(loff_t, length, 1024 * PAGE_SIZE);
-		/*
-		 * xfs_iomap_write_direct() expects the shared lock. It
-		 * is unlocked on return.
-		 */
-		if (lockmode == XFS_ILOCK_EXCL)
-			xfs_ilock_demote(ip, lockmode);
-		error = xfs_iomap_write_direct(ip, offset, length, &imap,
-				nimaps);
-		if (error)
-			return error;
+	/* Don't need to allocate over holes when doing zeroing operations. */
+	if (flags & IOMAP_ZERO)
+		goto out_found;
 
-		iomap->flags = IOMAP_F_NEW;
-		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
-	} else {
-		ASSERT(nimaps);
+	if (!imap_needs_alloc(inode, &imap, nimaps))
+		goto out_found;
 
-		xfs_iunlock(ip, lockmode);
-		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
+	/* If nowait is set bail since we are going to make allocations. */
+	if (flags & IOMAP_NOWAIT) {
+		error = -EAGAIN;
+		goto out_unlock;
 	}
 
+	/*
+	 * We cap the maximum length we map to a sane size  to keep the chunks
+	 * of work done where somewhat symmetric with the work writeback does.
+	 * This is a completely arbitrary number pulled out of thin air as a
+	 * best guess for initial testing.
+	 *
+	 * Note that the values needs to be less than 32-bits wide until the
+	 * lower level functions are updated.
+	 */
+	length = min_t(loff_t, length, 1024 * PAGE_SIZE);
+
+	/*
+	 * xfs_iomap_write_direct() expects the shared lock. It is unlocked on
+	 * return.
+	 */
+	if (lockmode == XFS_ILOCK_EXCL)
+		xfs_ilock_demote(ip, lockmode);
+	error = xfs_iomap_write_direct(ip, offset, length, &imap,
+			nimaps);
+	if (error)
+		return error;
+
+	iomap->flags = IOMAP_F_NEW;
+	trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
+
+out_finish:
 	if (xfs_ipincount(ip) && (ip->i_itemp->ili_fsync_fields
 				& ~XFS_ILOG_TIMESTAMP))
 		iomap->flags |= IOMAP_F_DIRTY;
@@ -1117,6 +1120,13 @@ xfs_file_iomap_begin(
 	if (shared)
 		iomap->flags |= IOMAP_F_SHARED;
 	return 0;
+
+out_found:
+	ASSERT(nimaps);
+	xfs_iunlock(ip, lockmode);
+	trace_xfs_iomap_found(ip, offset, length, 0, &imap);
+	goto out_finish;
+
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 	return error;
-- 
2.17.0

