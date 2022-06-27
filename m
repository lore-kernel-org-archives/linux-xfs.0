Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5407C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiF0Ann (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiF0Anm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:43:42 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4965A2BE5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:43:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8ACA810E760F
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:43:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-00BTzn-Ei
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:43:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-000uaK-DV
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:43:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: introduce xfs_iunlink_lookup
Date:   Mon, 27 Jun 2022 10:43:31 +1000
Message-Id: <20220627004336.217366-5-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627004336.217366-1-david@fromorbit.com>
References: <20220627004336.217366-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b8fd3b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=-iDJaXCwHzwlg7T1OYgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When an inode is on an unlinked list during normal operation, it is
guaranteed to be pinned in memory as it is either referenced by the
current unlink operation or it has a open file descriptor that
references it and has it pinned in memory. Hence to look up an inode
on the unlinked list, we can do a direct inode cache lookup and
always expect the lookup to succeed.

Add a function to do this lookup based on the agino that we use to
link the chain of unlinked inodes together so we can begin the
conversion the unlinked list manipulations to use in-memory inodes
rather than inode cluster buffers and remove the backref cache.

Use this lookup function to replace the on-disk inode buffer walk
when removing inodes from the unlinked list with an in-core inode
unlinked list walk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 165 +++++++++++++++++++--------------------------
 1 file changed, 71 insertions(+), 94 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c507370bd885..e6ac13174062 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2006,6 +2006,39 @@ xfs_iunlink_destroy(
 	ASSERT(freed_anything == false || xfs_is_shutdown(pag->pag_mount));
 }
 
+/*
+ * Find an inode on the unlinked list. This does not take references to the
+ * inode, we have existence guarantees by holding the AGI buffer lock and that
+ * only unlinked, referenced inodes can be on the unlinked inode list.  If we
+ * don't find the inode in cache, then let the caller handle the situation.
+ */
+static struct xfs_inode *
+xfs_iunlink_lookup(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode	*ip;
+
+	rcu_read_lock();
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+
+	/* Inode not in memory, nothing to do */
+	if (!ip) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	spin_lock(&ip->i_flags_lock);
+	if (ip->i_ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino) ||
+	    (ip->i_flags & (XFS_IRECLAIMABLE | XFS_IRECLAIM))) {
+		/* Uh-oh! */
+		ip = NULL;
+	}
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
+	return ip;
+}
+
 /*
  * Point the AGI unlinked bucket at an inode and log the results.  The caller
  * is responsible for validating the old value.
@@ -2111,7 +2144,8 @@ xfs_iunlink_update_inode(
 	 * current pointer is the same as the new value, unless we're
 	 * terminating the list.
 	 */
-	*old_next_agino = old_value;
+	if (old_next_agino)
+		*old_next_agino = old_value;
 	if (old_value == next_agino) {
 		if (next_agino != NULLAGINO) {
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
@@ -2217,38 +2251,6 @@ xfs_iunlink(
 	return error;
 }
 
-/* Return the imap, dinode pointer, and buffer for an inode. */
-STATIC int
-xfs_iunlink_map_ino(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		agino,
-	struct xfs_imap		*imap,
-	struct xfs_dinode	**dipp,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	int			error;
-
-	imap->im_blkno = 0;
-	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
-	if (error) {
-		xfs_warn(mp, "%s: xfs_imap returned error %d.",
-				__func__, error);
-		return error;
-	}
-
-	error = xfs_imap_to_bp(mp, tp, imap, bpp);
-	if (error) {
-		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
-				__func__, error);
-		return error;
-	}
-
-	*dipp = xfs_buf_offset(*bpp, imap->im_boffset);
-	return 0;
-}
-
 /*
  * Walk the unlinked chain from @head_agino until we find the inode that
  * points to @target_agino.  Return the inode number, map, dinode pointer,
@@ -2259,77 +2261,51 @@ xfs_iunlink_map_ino(
  *
  * Do not call this function if @target_agino is the head of the list.
  */
-STATIC int
-xfs_iunlink_map_prev(
-	struct xfs_trans	*tp,
+static int
+xfs_iunlink_lookup_prev(
 	struct xfs_perag	*pag,
 	xfs_agino_t		head_agino,
 	xfs_agino_t		target_agino,
-	xfs_agino_t		*agino,
-	struct xfs_imap		*imap,
-	struct xfs_dinode	**dipp,
-	struct xfs_buf		**bpp)
+	struct xfs_inode	**ipp)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode	*ip;
 	xfs_agino_t		next_agino;
-	int			error;
 
-	ASSERT(head_agino != target_agino);
-	*bpp = NULL;
+	*ipp = NULL;
 
 	/* See if our backref cache can find it faster. */
-	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
-	if (*agino != NULLAGINO) {
-		error = xfs_iunlink_map_ino(tp, pag->pag_agno, *agino, imap,
-				dipp, bpp);
-		if (error)
-			return error;
-
-		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
+	next_agino = xfs_iunlink_lookup_backref(pag, target_agino);
+	if (next_agino != NULLAGINO) {
+		ip = xfs_iunlink_lookup(pag, next_agino);
+		if (ip && ip->i_next_unlinked == target_agino) {
+			*ipp = ip;
 			return 0;
-
-		/*
-		 * If we get here the cache contents were corrupt, so drop the
-		 * buffer and fall back to walking the bucket list.
-		 */
-		xfs_trans_brelse(tp, *bpp);
-		*bpp = NULL;
-		WARN_ON_ONCE(1);
+		}
 	}
 
-	trace_xfs_iunlink_map_prev_fallback(mp, pag->pag_agno);
-
 	/* Otherwise, walk the entire bucket until we find it. */
 	next_agino = head_agino;
-	while (next_agino != target_agino) {
-		xfs_agino_t	unlinked_agino;
+	while (next_agino != NULLAGINO) {
+		ip = xfs_iunlink_lookup(pag, next_agino);
+		if (!ip)
+			return -EFSCORRUPTED;
 
-		if (*bpp)
-			xfs_trans_brelse(tp, *bpp);
-
-		*agino = next_agino;
-		error = xfs_iunlink_map_ino(tp, pag->pag_agno, next_agino, imap,
-				dipp, bpp);
-		if (error)
-			return error;
-
-		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
 		/*
 		 * Make sure this pointer is valid and isn't an obvious
 		 * infinite loop.
 		 */
-		if (!xfs_verify_agino(mp, pag->pag_agno, unlinked_agino) ||
-		    next_agino == unlinked_agino) {
-			XFS_CORRUPTION_ERROR(__func__,
-					XFS_ERRLEVEL_LOW, mp,
-					*dipp, sizeof(**dipp));
-			error = -EFSCORRUPTED;
-			return error;
+		if (!xfs_verify_agino(mp, pag->pag_agno, ip->i_next_unlinked) ||
+		    next_agino == ip->i_next_unlinked)
+			return -EFSCORRUPTED;
+
+		if (ip->i_next_unlinked == target_agino) {
+			*ipp = ip;
+			return 0;
 		}
-		next_agino = unlinked_agino;
+		next_agino = ip->i_next_unlinked;
 	}
-
-	return 0;
+	return -EFSCORRUPTED;
 }
 
 static int
@@ -2341,8 +2317,6 @@ xfs_iunlink_remove_inode(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
-	struct xfs_buf		*last_ibp;
-	struct xfs_dinode	*last_dip = NULL;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
 	xfs_agino_t		head_agino;
@@ -2368,7 +2342,6 @@ xfs_iunlink_remove_inode(
 	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO, &next_agino);
 	if (error)
 		return error;
-	ip->i_next_unlinked = NULLAGINO;
 
 	/*
 	 * If there was a backref pointing from the next inode back to this
@@ -2384,18 +2357,21 @@ xfs_iunlink_remove_inode(
 	}
 
 	if (head_agino != agino) {
-		struct xfs_imap	imap;
-		xfs_agino_t	prev_agino;
+		struct xfs_inode	*prev_ip;
 
-		/* We need to search the list for the inode being freed. */
-		error = xfs_iunlink_map_prev(tp, pag, head_agino, agino,
-				&prev_agino, &imap, &last_dip, &last_ibp);
+		error = xfs_iunlink_lookup_prev(pag, head_agino, agino,
+				&prev_ip);
 		if (error)
 			return error;
 
 		/* Point the previous inode on the list to the next inode. */
-		xfs_iunlink_update_dinode(tp, pag, prev_agino, last_ibp,
-				last_dip, &imap, next_agino);
+		error = xfs_iunlink_update_inode(tp, prev_ip, pag, next_agino,
+				NULL);
+		if (error)
+			return error;
+
+		prev_ip->i_next_unlinked = ip->i_next_unlinked;
+		ip->i_next_unlinked = NULLAGINO;
 
 		/*
 		 * Now we deal with the backref for this inode.  If this inode
@@ -2410,6 +2386,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	/* Point the head of the list to the next unlinked inode. */
+	ip->i_next_unlinked = NULLAGINO;
 	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
 			next_agino);
 }
-- 
2.36.1

