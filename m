Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58380 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750925AbeEBFvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 01:51:49 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fDkg6-0002O5-9k
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 15:51:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fDkg6-0007X0-8e
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 15:51:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: clean up locking in xfs_file_iomap_begin
Date: Wed,  2 May 2018 15:51:44 +1000
Message-Id: <20180502055144.28851-3-david@fromorbit.com>
In-Reply-To: <20180502055144.28851-1-david@fromorbit.com>
References: <20180502055144.28851-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than checking what kind of locking is needed in a helper
function and then jumping through hoops to do the locking in line,
move the locking to the helper function that does all the checks
and rename it to xfs_ilock_for_iomap().

This also allows us to hoist all the nonblocking checks up into the
locking helper, further simplifier the code flow in
xfs_file_iomap_begin() and making it easier to understand.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 98 +++++++++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 16565da67bb6..d03e65f01c89 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -946,8 +946,11 @@ xfs_iomap_write_unwritten(
 	return error;
 }
 
-static inline bool imap_needs_alloc(struct inode *inode,
-		struct xfs_bmbt_irec *imap, int nimaps)
+static inline bool
+imap_needs_alloc(
+	struct inode		*inode,
+	struct xfs_bmbt_irec	*imap,
+	int			nimaps)
 {
 	return !nimaps ||
 		imap->br_startblock == HOLESTARTBLOCK ||
@@ -955,31 +958,58 @@ static inline bool imap_needs_alloc(struct inode *inode,
 		(IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN);
 }
 
-static inline bool needs_cow_for_zeroing(struct xfs_bmbt_irec *imap, int nimaps)
+static inline bool
+needs_cow_for_zeroing(
+	struct xfs_bmbt_irec	*imap,
+	int			nimaps)
 {
 	return nimaps &&
 		imap->br_startblock != HOLESTARTBLOCK &&
 		imap->br_state != XFS_EXT_UNWRITTEN;
 }
 
-static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
+static int
+xfs_ilock_for_iomap(
+	struct xfs_inode	*ip,
+	unsigned		flags,
+	unsigned		*lockmode)
 {
+	unsigned		mode = XFS_ILOCK_SHARED;
+
 	/*
 	 * COW writes may allocate delalloc space or convert unwritten COW
 	 * extents, so we need to make sure to take the lock exclusively here.
 	 */
-	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
-		return true;
+	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO))) {
+		/*
+		 * FIXME: It could still overwrite on unshared extents and not
+		 * need allocation.
+		 */
+		if (flags & IOMAP_NOWAIT)
+			return -EAGAIN;
+		mode = XFS_ILOCK_EXCL;
+	}
 
 	/*
-	 * Extents not yet cached requires exclusive access, don't block.
-	 * This is an opencoded xfs_ilock_data_map_shared() to cater for the
+	 * Extents not yet cached requires exclusive access, don't block.  This
+	 * is an opencoded xfs_ilock_data_map_shared() call but with
 	 * non-blocking behaviour.
 	 */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
-	    !(ip->i_df.if_flags & XFS_IFEXTENTS))
-		return true;
-	return false;
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+		if (flags & IOMAP_NOWAIT)
+			return -EAGAIN;
+		mode = XFS_ILOCK_EXCL;
+	}
+
+	if (flags & IOMAP_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, mode))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, mode);
+	}
+
+	*lockmode = mode;
+	return 0;
 }
 
 static int
@@ -1007,19 +1037,15 @@ xfs_file_iomap_begin(
 		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
 	}
 
-	if (need_excl_ilock(ip, flags))
-		lockmode = XFS_ILOCK_EXCL;
-	else
-		lockmode = XFS_ILOCK_SHARED;
-
-	if (flags & IOMAP_NOWAIT) {
-		if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
-			return -EAGAIN;
-		if (!xfs_ilock_nowait(ip, lockmode))
-			return -EAGAIN;
-	} else {
-		xfs_ilock(ip, lockmode);
-	}
+	/*
+	 * Lock the inode in the manner required for the specified operation and
+	 * check for as many conditions that would result in blocking as
+	 * possible. This removes most of the non-blocking checks from the
+	 * mapping code below.
+	 */
+	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
+	if (error)
+		return error;
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 	if (offset > mp->m_super->s_maxbytes - length)
@@ -1044,19 +1070,17 @@ xfs_file_iomap_begin(
 	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
 		goto out_found;
 
-	if (xfs_is_reflink_inode(ip) &&
-	    ((flags & IOMAP_WRITE) ||
-	     ((flags & IOMAP_ZERO) && needs_cow_for_zeroing(&imap, nimaps)))) {
+	/*
+	 * Break shared extents if necessary. Checks for non-blocking IO have
+	 * been done up front, so we don't need to do them here.
+	 */
+	if (xfs_is_reflink_inode(ip)) {
+		/* if zeroing doesn't need COW allocation, then we are done. */
+		if ((flags & IOMAP_ZERO) &&
+		    !needs_cow_for_zeroing(&imap, nimaps))
+			goto out_found;
+
 		if (flags & IOMAP_DIRECT) {
-			/*
-			 * A reflinked inode will result in CoW alloc.
-			 * FIXME: It could still overwrite on unshared extents
-			 * and not need allocation.
-			 */
-			if (flags & IOMAP_NOWAIT) {
-				error = -EAGAIN;
-				goto out_unlock;
-			}
 			/* may drop and re-acquire the ilock */
 			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
 					&lockmode);
-- 
2.17.0

