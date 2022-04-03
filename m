Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1095EC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 12:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349340AbiDCMD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 08:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiDCMDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 08:03:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF11D2E9D2
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 05:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FgMxoR1d+CZADER7W5bzGH90tel/fpt7LnR3WTfIajY=; b=Xz0D8zyvUmRFf1dy7UZuhShyEL
        KxOYguvJtwPwrsiqgFrh9cpPgTgtOcUZ9rYUscNSOod2Zs8UVT/WYrfKA7xmQ+FlmcVTGGl7ev2uU
        PQ8SsEB12AmVSd0AP7gmSsDsoDhKhHU0jxPVCbc3FQTLFofL84ikhh9MDAZNckWrveGjKIpjFcWqc
        Wz9Jwy5bR99VZNTBd6vGdK9GBTm5Uj8IqlmpwqAkkcgP66Q2IPV0fKWPreR4f3WA2IrbGudRkPaS/
        Nde09TFzgBkZ6N9a3ZltxjtRQ/T0MY2qAb2tozHqijnVKf3dzEVaB3EcG1p8EnxQE0WfnH0JAv+D6
        02Muxrsg==;
Received: from [2001:4bb8:184:7553:31f9:976f:c3b1:7920] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nayvC-00BK3H-Ve; Sun, 03 Apr 2022 12:01:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: remove a superflous hash lookup when inserting new buffers
Date:   Sun,  3 Apr 2022 14:01:17 +0200
Message-Id: <20220403120119.235457-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220403120119.235457-1-hch@lst.de>
References: <20220403120119.235457-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_buf_get_map has a bit of a strange structure where the xfs_buf_find
helper is called twice before we actually insert a new buffer on a cache
miss.  Given that the rhashtable has an interface to insert a new entry
and return the found one on a conflict we can easily get rid of the
double lookup by using that.  To get a straight code path this requires
folding the xfs_buf_find helper into xfs_buf_get_map, but the counter
side we can now easily move the logic for the slow path cache insert
into a new helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 207 +++++++++++++++++++++++------------------------
 1 file changed, 99 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0951b7cbd79675..ef645e15935369 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -504,12 +504,66 @@ xfs_buf_hash_destroy(
 	rhashtable_destroy(&pag->pag_buf_hash);
 }
 
+static int
+xfs_buf_insert(
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags,
+	struct xfs_perag	*pag,
+	struct xfs_buf		**bpp)
+{
+	int			error;
+	struct xfs_buf		*bp;
+
+	error = _xfs_buf_alloc(btp, map, nmaps, flags, &bp);
+	if (error)
+		return error;
+
+	/*
+	 * For buffers that fit entirely within a single page, first attempt to
+	 * allocate the memory from the heap to minimise memory usage. If we
+	 * can't get heap memory for these small buffers, we fall back to using
+	 * the page allocator.
+	 */
+	if (BBTOB(bp->b_length) >= PAGE_SIZE ||
+	    xfs_buf_alloc_kmem(bp, flags) < 0) {
+		error = xfs_buf_alloc_pages(bp, flags);
+		if (error)
+			goto out_free_buf;
+	}
+
+	/* the buffer keeps the perag reference until it is freed */
+	bp->b_pag = pag;
+
+	spin_lock(&pag->pag_buf_lock);
+	*bpp = rhashtable_lookup_get_insert_fast(&pag->pag_buf_hash,
+			&bp->b_rhash_head, xfs_buf_hash_params);
+	if (IS_ERR(*bpp)) {
+		error = PTR_ERR(*bpp);
+		goto out_unlock;
+	}
+	if (*bpp) {
+		/* found an existing buffer */
+		atomic_inc(&(*bpp)->b_hold);
+		error = -EEXIST;
+		goto out_unlock;
+	}
+	spin_unlock(&pag->pag_buf_lock);
+	*bpp = bp;
+	return 0;
+
+out_unlock:
+	spin_unlock(&pag->pag_buf_lock);
+out_free_buf:
+	xfs_buf_free(bp);
+	return error;
+}
+
 /*
- * Look up a buffer in the buffer cache and return it referenced and locked
- * in @found_bp.
- *
- * If @new_bp is supplied and we have a lookup miss, insert @new_bp into the
- * cache.
+ * Assemble a buffer covering the specified range. The code is optimised for
+ * cache hits, as metadata intensive workloads will see 3 orders of magnitude
+ * more hits than misses.
  *
  * If XBF_TRYLOCK is set in @flags, only try to lock the buffer and return
  * -EAGAIN if we fail to lock it.
@@ -517,27 +571,26 @@ xfs_buf_hash_destroy(
  * Return values are:
  *	-EFSCORRUPTED if have been supplied with an invalid address
  *	-EAGAIN on trylock failure
- *	-ENOENT if we fail to find a match and @new_bp was NULL
- *	0, with @found_bp:
- *		- @new_bp if we inserted it into the cache
- *		- the buffer we found and locked.
+ *	-ENOENT if we fail to find a match and alloc was %false
+ *	0 if a buffer was found or newly created
  */
-static int
-xfs_buf_find(
+int
+xfs_buf_get_map(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
-	struct xfs_buf		*new_bp,
-	struct xfs_buf		**found_bp)
+	struct xfs_buf		**bpp)
 {
+	struct xfs_mount	*mp = btp->bt_mount;
 	struct xfs_perag	*pag;
 	struct xfs_buf		*bp;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
+	int			error = 0;
 	xfs_daddr_t		eofs;
 	int			i;
 
-	*found_bp = NULL;
+	*bpp = NULL;
 
 	for (i = 0; i < nmaps; i++)
 		cmap.bm_len += map[i].bm_len;
@@ -550,54 +603,47 @@ xfs_buf_find(
 	 * Corrupted block numbers can get through to here, unfortunately, so we
 	 * have to check that the buffer falls within the filesystem bounds.
 	 */
-	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
-	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
-		xfs_alert(btp->bt_mount,
-			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (WARN_ON_ONCE(cmap.bm_bn < 0) || WARN_ON_ONCE(cmap.bm_bn >= eofs)) {
+		xfs_alert(mp, "%s: daddr 0x%llx out of range, EOFS 0x%llx",
 			  __func__, cmap.bm_bn, eofs);
-		WARN_ON(1);
 		return -EFSCORRUPTED;
 	}
 
-	pag = xfs_perag_get(btp->bt_mount,
-			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
+	pag = xfs_perag_get(mp, xfs_daddr_to_agno(mp, cmap.bm_bn));
 
 	spin_lock(&pag->pag_buf_lock);
 	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
 				    xfs_buf_hash_params);
-	if (bp) {
+	if (bp)
 		atomic_inc(&bp->b_hold);
-		goto found;
-	}
-
-	/* No match found */
-	if (!new_bp) {
-		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
-		spin_unlock(&pag->pag_buf_lock);
-		xfs_perag_put(pag);
-		return -ENOENT;
-	}
-
-	/* the buffer keeps the perag reference until it is freed */
-	new_bp->b_pag = pag;
-	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
-			       xfs_buf_hash_params);
 	spin_unlock(&pag->pag_buf_lock);
-	*found_bp = new_bp;
-	return 0;
 
-found:
-	spin_unlock(&pag->pag_buf_lock);
+	if (unlikely(!bp)) {
+		if (flags & XBF_NOALLOC) {
+			XFS_STATS_INC(mp, xb_miss_locked);
+			xfs_perag_put(pag);
+			return -ENOENT;
+		}
+
+		error = xfs_buf_insert(btp, map, nmaps, flags, pag, &bp);
+		if (!error)
+			goto finish;
+		if (error != -EEXIST) {
+			xfs_perag_put(pag);
+			return error;
+		}
+	}
 	xfs_perag_put(pag);
 
 	if (!xfs_buf_trylock(bp)) {
 		if (flags & XBF_TRYLOCK) {
 			xfs_buf_rele(bp);
-			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
+			XFS_STATS_INC(mp, xb_busy_locked);
 			return -EAGAIN;
 		}
 		xfs_buf_lock(bp);
-		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
+		XFS_STATS_INC(mp, xb_get_locked_waited);
 	}
 
 	/*
@@ -612,64 +658,12 @@ xfs_buf_find(
 	}
 
 	trace_xfs_buf_find(bp, flags, _RET_IP_);
-	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
-	*found_bp = bp;
-	return 0;
-}
-
-/*
- * Assembles a buffer covering the specified range. The code is optimised for
- * cache hits, as metadata intensive workloads will see 3 orders of magnitude
- * more hits than misses.
- */
-int
-xfs_buf_get_map(
-	struct xfs_buftarg	*target,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	xfs_buf_flags_t		flags,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_buf		*bp;
-	struct xfs_buf		*new_bp;
-	int			error;
-
-	*bpp = NULL;
-	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
-	if (!error)
-		goto found;
-	if (error != -ENOENT || (flags & XBF_NOALLOC))
-		return error;
-
-	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
-	if (error)
-		return error;
-
-	/*
-	 * For buffers that fit entirely within a single page, first attempt to
-	 * allocate the memory from the heap to minimise memory usage. If we
-	 * can't get heap memory for these small buffers, we fall back to using
-	 * the page allocator.
-	 */
-	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
-	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
-		error = xfs_buf_alloc_pages(new_bp, flags);
-		if (error)
-			goto out_free_buf;
-	}
-
-	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
-	if (error)
-		goto out_free_buf;
-
-	if (bp != new_bp)
-		xfs_buf_free(new_bp);
-
-found:
+	XFS_STATS_INC(mp, xb_get_locked);
+finish:
 	if (!bp->b_addr) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
-			xfs_warn_ratelimited(target->bt_mount,
+			xfs_warn_ratelimited(mp,
 				"%s: failed to map %u pages", __func__,
 				bp->b_page_count);
 			xfs_buf_relse(bp);
@@ -684,13 +678,10 @@ xfs_buf_get_map(
 	if (!(flags & XBF_READ))
 		xfs_buf_ioerror(bp, 0);
 
-	XFS_STATS_INC(target->bt_mount, xb_get);
+	XFS_STATS_INC(mp, xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	*bpp = bp;
 	return 0;
-out_free_buf:
-	xfs_buf_free(new_bp);
-	return error;
 }
 
 int
@@ -962,12 +953,12 @@ xfs_buf_rele(
 	/*
 	 * We grab the b_lock here first to serialise racing xfs_buf_rele()
 	 * calls. The pag_buf_lock being taken on the last reference only
-	 * serialises against racing lookups in xfs_buf_find(). IOWs, the second
-	 * to last reference we drop here is not serialised against the last
-	 * reference until we take bp->b_lock. Hence if we don't grab b_lock
-	 * first, the last "release" reference can win the race to the lock and
-	 * free the buffer before the second-to-last reference is processed,
-	 * leading to a use-after-free scenario.
+	 * serialises against racing lookups in xfs_buf_get_map(). IOWs, the
+	 * second to last reference we drop here is not serialised against the
+	 * last reference until we take bp->b_lock. Hence if we don't grab
+	 * b_lock first, the last "release" reference can win the race to the
+	 * lock and free the buffer before the second-to-last reference is
+	 * processed, leading to a use-after-free scenario.
 	 */
 	spin_lock(&bp->b_lock);
 	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
-- 
2.30.2

