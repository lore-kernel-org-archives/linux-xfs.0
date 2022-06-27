Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81701CCA482
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiF0Anp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiF0Ann (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:43:43 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99F4A2DE5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:43:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DEAA810E75A2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:43:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-00BTzf-C4
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:43:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-000ua8-AW
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:43:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: factor the xfs_iunlink functions
Date:   Mon, 27 Jun 2022 10:43:28 +1000
Message-Id: <20220627004336.217366-2-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627004336.217366-1-david@fromorbit.com>
References: <20220627004336.217366-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b8fd3b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=cM0QFjsFstjT-tzj_kwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Prep work that separates the locking that protects the unlinked list
from the actual operations being performed. This also helps document
the fact they are performing list insert  and remove operations. No
functional code change.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 113 +++++++++++++++++++++++++++------------------
 1 file changed, 68 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52d6f2c7d58b..2a371c3431c9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2129,39 +2129,20 @@ xfs_iunlink_update_inode(
 	return error;
 }
 
-/*
- * This is called when the inode's link count has gone to 0 or we are creating
- * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
- *
- * We place the on-disk inode on a list in the AGI.  It will be pulled from this
- * list when the inode is freed.
- */
-STATIC int
-xfs_iunlink(
+static int
+xfs_iunlink_insert_inode(
 	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
-{
+ {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
-	struct xfs_agi		*agi;
-	struct xfs_buf		*agibp;
+	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		next_agino;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
-	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(VFS_I(ip)->i_mode != 0);
-	trace_xfs_iunlink(ip);
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
-	if (error)
-		goto out;
-	agi = agibp->b_addr;
-
 	/*
 	 * Get the index into the agi hash table for the list this inode will
 	 * go on.  Make sure the pointer isn't garbage and that this inode
@@ -2171,8 +2152,7 @@ xfs_iunlink(
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
-		error = -EFSCORRUPTED;
-		goto out;
+		return -EFSCORRUPTED;
 	}
 
 	if (next_agino != NULLAGINO) {
@@ -2185,7 +2165,7 @@ xfs_iunlink(
 		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino,
 				&old_agino);
 		if (error)
-			goto out;
+			return error;
 		ASSERT(old_agino == NULLAGINO);
 
 		/*
@@ -2194,11 +2174,42 @@ xfs_iunlink(
 		 */
 		error = xfs_iunlink_add_backref(pag, agino, next_agino);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	/* Point the head of the list to point to this inode. */
-	error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
+	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
+}
+
+/*
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
+ */
+STATIC int
+xfs_iunlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*agibp;
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
+	if (error)
+		goto out;
+
+	error = xfs_iunlink_insert_inode(tp, pag, agibp, ip);
 out:
 	xfs_perag_put(pag);
 	return error;
@@ -2319,18 +2330,15 @@ xfs_iunlink_map_prev(
 	return 0;
 }
 
-/*
- * Pull the on-disk inode from the AGI unlinked list.
- */
-STATIC int
-xfs_iunlink_remove(
+static int
+xfs_iunlink_remove_inode(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi;
-	struct xfs_buf		*agibp;
+	struct xfs_agi		*agi = agibp->b_addr;
 	struct xfs_buf		*last_ibp;
 	struct xfs_dinode	*last_dip = NULL;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
@@ -2339,14 +2347,6 @@ xfs_iunlink_remove(
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
-	trace_xfs_iunlink_remove(ip);
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
-	if (error)
-		return error;
-	agi = agibp->b_addr;
-
 	/*
 	 * Get the index into the agi hash table for the list this inode will
 	 * go on.  Make sure the head pointer isn't garbage.
@@ -2411,6 +2411,29 @@ xfs_iunlink_remove(
 			next_agino);
 }
 
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+STATIC int
+xfs_iunlink_remove(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agibp;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
+	if (error)
+		return error;
+
+	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
+}
+
 /*
  * Look up the inode number specified and if it is not already marked XFS_ISTALE
  * mark it stale. We should only find clean inodes in this lookup that aren't
-- 
2.36.1

