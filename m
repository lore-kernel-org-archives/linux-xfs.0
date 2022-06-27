Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C25CCA480
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 06:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiF0GIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 02:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiF0GIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 02:08:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F32A226EB
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 23:08:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E811210E7873
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 16:08:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-00BZVx-4D
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 16:08:44 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-0011gO-2h
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 16:08:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: break up xfs_buf_find() into individual pieces
Date:   Mon, 27 Jun 2022 16:08:37 +1000
Message-Id: <20220627060841.244226-3-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627060841.244226-1-david@fromorbit.com>
References: <20220627060841.244226-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b9496e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=KcGp5gGIAr9zcBnkXQcA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_buf_find() is made up of three main parts: lookup, insert and
locking. The interactions with xfs_buf_get_map() require it to be
called twice - once for a pure lookup, and again on lookup failure
so the insert path can be run. We want to simplify this down a lot,
so split it into a fast path lookup, a slow path insert and a "lock
the found buffer" helper. This will then let use integrate these
operations more effectively into xfs_buf_get_map() in future
patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 159 +++++++++++++++++++++++++++++++----------------
 1 file changed, 105 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 143e1c70df5d..95d4b428aec0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -503,77 +503,60 @@ xfs_buf_hash_destroy(
 	rhashtable_destroy(&pag->pag_buf_hash);
 }
 
-/*
- * Look up a buffer in the buffer cache and return it referenced and locked
- * in @found_bp.
- *
- * If @new_bp is supplied and we have a lookup miss, insert @new_bp into the
- * cache.
- *
- * If XBF_TRYLOCK is set in @flags, only try to lock the buffer and return
- * -EAGAIN if we fail to lock it.
- *
- * Return values are:
- *	-EFSCORRUPTED if have been supplied with an invalid address
- *	-EAGAIN on trylock failure
- *	-ENOENT if we fail to find a match and @new_bp was NULL
- *	0, with @found_bp:
- *		- @new_bp if we inserted it into the cache
- *		- the buffer we found and locked.
- */
 static int
-xfs_buf_find(
+xfs_buf_find_verify(
 	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	xfs_buf_flags_t		flags,
-	struct xfs_buf		*new_bp,
-	struct xfs_buf		**found_bp)
+	struct xfs_buf_map	*map)
 {
-	struct xfs_perag	*pag;
-	struct xfs_buf		*bp;
-	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	xfs_daddr_t		eofs;
-	int			i;
-
-	*found_bp = NULL;
-
-	for (i = 0; i < nmaps; i++)
-		cmap.bm_len += map[i].bm_len;
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(BBTOB(cmap.bm_len) < btp->bt_meta_sectorsize));
-	ASSERT(!(BBTOB(cmap.bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
+	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
+	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
 
 	/*
 	 * Corrupted block numbers can get through to here, unfortunately, so we
 	 * have to check that the buffer falls within the filesystem bounds.
 	 */
 	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
-	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
+	if (map->bm_bn < 0 || map->bm_bn >= eofs) {
 		xfs_alert(btp->bt_mount,
 			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
-			  __func__, cmap.bm_bn, eofs);
+			  __func__, map->bm_bn, eofs);
 		WARN_ON(1);
 		return -EFSCORRUPTED;
 	}
+	return 0;
+}
 
-	pag = xfs_perag_get(btp->bt_mount,
-			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
+static inline struct xfs_buf *
+xfs_buf_find_fast(
+	struct xfs_perag	*pag,
+	struct xfs_buf_map	*map)
+{
+	struct xfs_buf          *bp;
 
-	spin_lock(&pag->pag_buf_lock);
-	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
-				    xfs_buf_hash_params);
-	if (bp) {
-		atomic_inc(&bp->b_hold);
-		goto found;
-	}
+	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
+	if (!bp)
+		return NULL;
+	atomic_inc(&bp->b_hold);
+	return bp;
+}
 
+/*
+ * Insert the new_bp into the hash table. This consumes the perag reference
+ * taken for the lookup.
+ */
+static int
+xfs_buf_find_insert(
+	struct xfs_buftarg	*btp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*new_bp)
+{
 	/* No match found */
 	if (!new_bp) {
-		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
-		spin_unlock(&pag->pag_buf_lock);
 		xfs_perag_put(pag);
+		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
 		return -ENOENT;
 	}
 
@@ -581,14 +564,15 @@ xfs_buf_find(
 	new_bp->b_pag = pag;
 	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
 			       xfs_buf_hash_params);
-	spin_unlock(&pag->pag_buf_lock);
-	*found_bp = new_bp;
 	return 0;
+}
 
-found:
-	spin_unlock(&pag->pag_buf_lock);
-	xfs_perag_put(pag);
-
+static int
+xfs_buf_find_lock(
+	struct xfs_buftarg	*btp,
+	struct xfs_buf          *bp,
+	xfs_buf_flags_t		flags)
+{
 	if (!xfs_buf_trylock(bp)) {
 		if (flags & XBF_TRYLOCK) {
 			xfs_buf_rele(bp);
@@ -609,6 +593,73 @@ xfs_buf_find(
 		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
 		bp->b_ops = NULL;
 	}
+	return 0;
+}
+
+/*
+ * Look up a buffer in the buffer cache and return it referenced and locked
+ * in @found_bp.
+ *
+ * If @new_bp is supplied and we have a lookup miss, insert @new_bp into the
+ * cache.
+ *
+ * If XBF_TRYLOCK is set in @flags, only try to lock the buffer and return
+ * -EAGAIN if we fail to lock it.
+ *
+ * Return values are:
+ *	-EFSCORRUPTED if have been supplied with an invalid address
+ *	-EAGAIN on trylock failure
+ *	-ENOENT if we fail to find a match and @new_bp was NULL
+ *	0, with @found_bp:
+ *		- @new_bp if we inserted it into the cache
+ *		- the buffer we found and locked.
+ */
+static int
+xfs_buf_find(
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		*new_bp,
+	struct xfs_buf		**found_bp)
+{
+	struct xfs_perag	*pag;
+	struct xfs_buf		*bp;
+	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
+	int			error;
+	int			i;
+
+	*found_bp = NULL;
+
+	for (i = 0; i < nmaps; i++)
+		cmap.bm_len += map[i].bm_len;
+
+	error = xfs_buf_find_verify(btp, &cmap);
+	if (error)
+		return error;
+
+	pag = xfs_perag_get(btp->bt_mount,
+			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
+
+	spin_lock(&pag->pag_buf_lock);
+	bp = xfs_buf_find_fast(pag, &cmap);
+	if (bp)
+		goto found;
+
+	error = xfs_buf_find_insert(btp, pag, new_bp);
+	spin_unlock(&pag->pag_buf_lock);
+	if (error)
+		return error;
+	*found_bp = new_bp;
+	return 0;
+
+found:
+	spin_unlock(&pag->pag_buf_lock);
+	xfs_perag_put(pag);
+
+	error = xfs_buf_find_lock(btp, bp, flags);
+	if (error)
+		return error;
 
 	trace_xfs_buf_find(bp, flags, _RET_IP_);
 	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
-- 
2.36.1

