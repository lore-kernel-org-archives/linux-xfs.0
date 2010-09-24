Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OCUqOi181033 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:30:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2026499EB2
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:31:46 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	3U0LIHi7GgFxvuqR for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 05:31:46 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40083809-1927428
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:01:45 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Oz7RI-0007VK-QS
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:44 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Oz7R4-00060X-JZ
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/18] xfs: batch inode reclaim lookup
Date: Fri, 24 Sep 2010 22:31:13 +1000
Message-Id: <1285331476-23015-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1285331476-23015-1-git-send-email-david@fromorbit.com>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Batch and optimise the per-ag inode lookup for reclaim to minimise
scanning overhead. This involves gang lookups on the radix trees to
get multiple inodes during each tree walk, and tighter validation of
what inodes can be reclaimed without blocking befor we take any
locks.

This is based on ideas suggested in a proof-of-concept patch
posted by Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |  110 ++++++++++++++++++++++++++++++-------------
 1 files changed, 77 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 2a46a80..c0c09e9 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -623,6 +623,43 @@ __xfs_inode_clear_reclaim_tag(
 }
 
 /*
+ * Grab the inode for reclaim exclusively.
+ * Return 0 if we grabbed it, non-zero otherwise.
+ */
+STATIC int
+xfs_reclaim_inode_grab(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+
+	/*
+	 * do some unlocked checks first to avoid unnecceary lock traffic.
+	 * The first is a flush lock check, the second is a already in reclaim
+	 * check. Only do these checks if we are not going to block on locks.
+	 */
+	if ((flags & SYNC_TRYLOCK) &&
+	    (!ip->i_flush.done || __xfs_iflags_test(ip, XFS_IRECLAIM))) {
+		return 1;
+	}
+
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.  Once we have the
+	 * XFS_IRECLAIM flag set it will not touch us.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
+		/* ignore as it is already under reclaim */
+		spin_unlock(&ip->i_flags_lock);
+		return 1;
+	}
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
+	spin_unlock(&ip->i_flags_lock);
+	return 0;
+}
+
+/*
  * Inodes in different states need to be treated differently, and the return
  * value of xfs_iflush is not sufficient to get this right. The following table
  * lists the inode states and the reclaim actions necessary for non-blocking
@@ -680,23 +717,6 @@ xfs_reclaim_inode(
 {
 	int	error = 0;
 
-	/*
-	 * The radix tree lock here protects a thread in xfs_iget from racing
-	 * with us starting reclaim on the inode.  Once we have the
-	 * XFS_IRECLAIM flag set it will not touch us.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		/* ignore as it is already under reclaim */
-		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
-		return 0;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iflock_nowait(ip)) {
 		if (!(sync_mode & SYNC_WAIT))
@@ -813,16 +833,19 @@ xfs_reclaim_inodes_ag(
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
 		int		done = 0;
+		int		nr_found = 0;
 
 		ag = pag->pag_agno + 1;
 
 		do {
-			struct xfs_inode *ip;
-			int	nr_found;
+			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+			int	i;
 
 			write_lock(&pag->pag_ici_lock);
-			nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
-					(void **)&ip, first_index, 1,
+			nr_found = radix_tree_gang_lookup_tag(
+					&pag->pag_ici_root,
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH,
 					XFS_ICI_RECLAIM_TAG);
 			if (!nr_found) {
 				write_unlock(&pag->pag_ici_lock);
@@ -830,20 +853,41 @@ xfs_reclaim_inodes_ag(
 			}
 
 			/*
-			 * Update the index for the next lookup. Catch overflows
-			 * into the next AG range which can occur if we have inodes
-			 * in the last block of the AG and we are currently
-			 * pointing to the last inode.
+			 * Grab the inodes before we drop the lock. if we found
+			 * nothing, nr == 0 and the loop will be skipped.
 			 */
-			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-				done = 1;
+			for (i = 0; i < nr_found; i++) {
+				struct xfs_inode *ip = batch[i];
+
+				if (done || xfs_reclaim_inode_grab(ip, flags))
+					batch[i] = NULL;
+
+				/*
+				 * Update the index for the next lookup. Catch
+				 * overflows into the next AG range which can
+				 * occur if we have inodes in the last block of
+				 * the AG and we are currently pointing to the
+				 * last inode.
+				 */
+				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+					done = 1;
+			}
 
-			error = xfs_reclaim_inode(ip, pag, flags);
-			if (error && last_error != EFSCORRUPTED)
-				last_error = error;
+			/* unlock now we've grabbed the inodes. */
+			write_unlock(&pag->pag_ici_lock);
+
+			for (i = 0; i < nr_found; i++) {
+				if (!batch[i])
+					continue;
+				error = xfs_reclaim_inode(batch[i], pag, flags);
+				if (error && last_error != EFSCORRUPTED)
+					last_error = error;
+			}
+
+			*nr_to_scan -= XFS_LOOKUP_BATCH;
 
-		} while (!done && (*nr_to_scan)--);
+		} while (nr_found && !done && *nr_to_scan > 0);
 
 		xfs_perag_put(pag);
 	}
@@ -879,7 +923,7 @@ xfs_reclaim_inode_shrink(
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
 
-		xfs_reclaim_inodes_ag(mp, 0, &nr_to_scan);
+		xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
 		/* terminate if we don't exhaust the scan */
 		if (nr_to_scan > 0)
 			return -1;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
