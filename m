Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0772FCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B548E20659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HiK2+buO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfJ2Xb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:31:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51856 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfJ2Xb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:31:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSfr7017049
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BE5adu379aCrpLqdBXGYEM0ShcwB3BwvOmoPjVh36n4=;
 b=HiK2+buOTxsUIqU9tU/csRBIRnqgQMB9KsWYGE3not/6fjwCZzBTkNEPwP1yc9maZFxl
 ZLvvvDCqyAJ80+38l/UboksY87YiMCsLIe0jH+TYmlJ2M3FnH2+h8kEXDPFElQfbmdtQ
 s1hCi3DYULnoM03KtILboohp+X5JB0kFDkfvKyh5IvA3Ar9Io78JgUvW6OSHzjJQ4wEn
 vgunc9NKuYkMf/AWSCXrrlNgiA4pPkJXk+oTDy0cLvKl6+aV7iKWYXuaCNpcg7WYhvg2
 Ht3g2EcxfX9yMWKDFhXFIxjmXpOlAWYwlB6r7hK3eL+rCfWQYteegmMGW9OV5tKe+Oec zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vxwhf8b3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSFwK039126
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vxwj8v0u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TNVOCN011833
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:31:24 -0700
Subject: [PATCH 5/5] xfs: convert xbitmap to interval tree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:31:23 -0700
Message-ID: <157239188356.1267044.17369935108140007851.stgit@magnolia>
In-Reply-To: <157239185264.1267044.16039786238721573306.stgit@magnolia>
References: <157239185264.1267044.16039786238721573306.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the xbitmap code to use interval trees instead of linked lists.
This reduces the amount of coding required to handle the disunion
operation and in the future will make it easier to set bits in arbitrary
order yet later be able to extract maximally sized extents, which we'll
need for rebuilding certain structures.  We define our own interval tree
type so that it can deal with 64-bit indices even on 32-bit machines.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c |    4 -
 fs/xfs/scrub/bitmap.c          |  300 ++++++++++++++++++++--------------------
 fs/xfs/scrub/bitmap.h          |   13 +-
 3 files changed, 155 insertions(+), 162 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index b618a87b8dcf..4ddae4ecece6 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -516,10 +516,8 @@ xrep_agfl_collect_blocks(
 	 * Drop the freesp meta blocks that are in use by btrees.
 	 * The remaining blocks /should/ be AGFL blocks.
 	 */
-	error = xbitmap_disunion(agfl_extents, &ra.agmetablocks);
+	xbitmap_disunion(agfl_extents, &ra.agmetablocks);
 	xbitmap_destroy(&ra.agmetablocks);
-	if (error)
-		return error;
 
 	/*
 	 * Calculate the new AGFL size.  If we found more blocks than fit in
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 7a7554fb2793..4fad962a360b 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -12,31 +12,139 @@
 #include "xfs_btree.h"
 #include "scrub/bitmap.h"
 
-/* Iterate each interval of a bitmap.  Do not change the bitmap. */
-#define for_each_xbitmap_extent(bex, bitmap) \
-	list_for_each_entry((bex), &(bitmap)->list, list)
+#include <linux/interval_tree_generic.h>
+
+struct xbitmap_node {
+	struct rb_node	bn_rbnode;
+
+	/* First set bit of this interval and subtree. */
+	uint64_t	bn_start;
+
+	/* Last set bit of this interval. */
+	uint64_t	bn_last;
+
+	/* Last set bit of this subtree.  Do not touch this. */
+	uint64_t	__bn_subtree_last;
+};
+
+/* Define our own interval tree type with uint64_t parameters. */
+
+#define START(node) ((node)->bn_start)
+#define LAST(node)  ((node)->bn_last)
 
 /*
- * Set a range of this bitmap.  Caller must ensure the range is not set.
- *
- * This is the logical equivalent of bitmap |= mask(start, len).
+ * These functions are defined by the INTERVAL_TREE_DEFINE macro, but we'll
+ * forward-declare them anyway for clarity.
  */
+static inline void
+xbitmap_tree_insert(struct xbitmap_node *node, struct rb_root_cached *root);
+
+static inline void
+xbitmap_tree_remove(struct xbitmap_node *node, struct rb_root_cached *root);
+
+static inline struct xbitmap_node *
+xbitmap_tree_iter_first(struct rb_root_cached *root, uint64_t start,
+			uint64_t last);
+
+static inline struct xbitmap_node *
+xbitmap_tree_iter_next(struct xbitmap_node *node, uint64_t start,
+		       uint64_t last);
+
+INTERVAL_TREE_DEFINE(struct xbitmap_node, bn_rbnode, uint64_t,
+		__bn_subtree_last, START, LAST, static inline, xbitmap_tree)
+
+/* Iterate each interval of a bitmap.  Do not change the bitmap. */
+#define for_each_xbitmap_extent(bn, bitmap) \
+	for ((bn) = rb_entry_safe(rb_first(&(bitmap)->xb_root.rb_root), \
+				   struct xbitmap_node, bn_rbnode); \
+	     (bn) != NULL; \
+	     (bn) = rb_entry_safe(rb_next(&(bn)->bn_rbnode), \
+				   struct xbitmap_node, bn_rbnode))
+
+/* Clear a range of this bitmap. */
+void
+xbitmap_clear(
+	struct xbitmap		*bitmap,
+	uint64_t		start,
+	uint64_t		len)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		last = start + len - 1;
+
+	while ((bn = xbitmap_tree_iter_first(&bitmap->xb_root, start, last))) {
+		if (bn->bn_start < start) {
+			/* overlaps with the left side of the clearing range */
+			xbitmap_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_last = start - 1;
+			xbitmap_tree_insert(bn, &bitmap->xb_root);
+		} else if (bn->bn_last > last) {
+			/* overlaps with the right side of the clearing range */
+			xbitmap_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_start = last + 1;
+			xbitmap_tree_insert(bn, &bitmap->xb_root);
+			break;
+		} else {
+			/* in the middle of the clearing range */
+			xbitmap_tree_remove(bn, &bitmap->xb_root);
+			kmem_free(bn);
+		}
+	}
+}
+
+/* Set a range of this bitmap. */
 int
 xbitmap_set(
 	struct xbitmap		*bitmap,
 	uint64_t		start,
 	uint64_t		len)
 {
-	struct xbitmap_range	*bmr;
+	struct xbitmap_node	*left;
+	struct xbitmap_node	*right;
+	uint64_t		last = start + len - 1;
 
-	bmr = kmem_alloc(sizeof(struct xbitmap_range), KM_MAYFAIL);
-	if (!bmr)
-		return -ENOMEM;
+	/* Is this whole range already set? */
+	left = xbitmap_tree_iter_first(&bitmap->xb_root, start, last);
+	if (left && left->bn_start <= start && left->bn_last >= last)
+		return 0;
 
-	INIT_LIST_HEAD(&bmr->list);
-	bmr->start = start;
-	bmr->len = len;
-	list_add_tail(&bmr->list, &bitmap->list);
+	/* Clear out everything in the range we want to set. */
+	xbitmap_clear(bitmap, start, len);
+
+	/* Do we have a left-adjacent extent? */
+	left = xbitmap_tree_iter_first(&bitmap->xb_root, start - 1, start - 1);
+	ASSERT(!left || left->bn_last + 1 == start);
+
+	/* Do we have a right-adjacent extent? */
+	right = xbitmap_tree_iter_first(&bitmap->xb_root, last + 1, last + 1);
+	ASSERT(!right || right->bn_start == last + 1);
+
+	if (left && right) {
+		/* combine left and right adjacent extent */
+		xbitmap_tree_remove(left, &bitmap->xb_root);
+		xbitmap_tree_remove(right, &bitmap->xb_root);
+		left->bn_last = right->bn_last;
+		xbitmap_tree_insert(left, &bitmap->xb_root);
+		kmem_free(right);
+	} else if (left) {
+		/* combine with left extent */
+		xbitmap_tree_remove(left, &bitmap->xb_root);
+		left->bn_last = last;
+		xbitmap_tree_insert(left, &bitmap->xb_root);
+	} else if (right) {
+		/* combine with right extent */
+		xbitmap_tree_remove(right, &bitmap->xb_root);
+		right->bn_start = start;
+		xbitmap_tree_insert(right, &bitmap->xb_root);
+	} else {
+		/* add an extent */
+		left = kmem_alloc(sizeof(struct xbitmap_node),
+				KM_MAYFAIL);
+		if (!left)
+			return -ENOMEM;
+		left->bn_start = start;
+		left->bn_last = last;
+		xbitmap_tree_insert(left, &bitmap->xb_root);
+	}
 
 	return 0;
 }
@@ -46,11 +154,11 @@ void
 xbitmap_destroy(
 	struct xbitmap		*bitmap)
 {
-	struct xbitmap_range	*bmr, *n;
+	struct xbitmap_node	*bn;
 
-	list_for_each_entry_safe(bmr, n, &bitmap->list, list) {
-		list_del(&bmr->list);
-		kmem_free(bmr);
+	while ((bn = xbitmap_tree_iter_first(&bitmap->xb_root, 0, -1ULL))) {
+		xbitmap_tree_remove(bn, &bitmap->xb_root);
+		kfree(bn);
 	}
 }
 
@@ -59,27 +167,7 @@ void
 xbitmap_init(
 	struct xbitmap		*bitmap)
 {
-	INIT_LIST_HEAD(&bitmap->list);
-}
-
-/* Compare two btree extents. */
-static int
-xbitmap_range_cmp(
-	void			*priv,
-	struct list_head	*a,
-	struct list_head	*b)
-{
-	struct xbitmap_range	*ap;
-	struct xbitmap_range	*bp;
-
-	ap = container_of(a, struct xbitmap_range, list);
-	bp = container_of(b, struct xbitmap_range, list);
-
-	if (ap->start > bp->start)
-		return 1;
-	if (ap->start < bp->start)
-		return -1;
-	return 0;
+	bitmap->xb_root = RB_ROOT_CACHED;
 }
 
 /*
@@ -96,118 +184,20 @@ xbitmap_range_cmp(
  *
  * This is the logical equivalent of bitmap &= ~sub.
  */
-#define LEFT_ALIGNED	(1 << 0)
-#define RIGHT_ALIGNED	(1 << 1)
-int
+void
 xbitmap_disunion(
 	struct xbitmap		*bitmap,
 	struct xbitmap		*sub)
 {
-	struct list_head	*lp;
-	struct xbitmap_range	*br;
-	struct xbitmap_range	*new_br;
-	struct xbitmap_range	*sub_br;
-	uint64_t		sub_start;
-	uint64_t		sub_len;
-	int			state;
-	int			error = 0;
-
-	if (list_empty(&bitmap->list) || list_empty(&sub->list))
-		return 0;
-	ASSERT(!list_empty(&sub->list));
-
-	list_sort(NULL, &bitmap->list, xbitmap_range_cmp);
-	list_sort(NULL, &sub->list, xbitmap_range_cmp);
-
-	/*
-	 * Now that we've sorted both lists, we iterate bitmap once, rolling
-	 * forward through sub and/or bitmap as necessary until we find an
-	 * overlap or reach the end of either list.  We do not reset lp to the
-	 * head of bitmap nor do we reset sub_br to the head of sub.  The
-	 * list traversal is similar to merge sort, but we're deleting
-	 * instead.  In this manner we avoid O(n^2) operations.
-	 */
-	sub_br = list_first_entry(&sub->list, struct xbitmap_range,
-			list);
-	lp = bitmap->list.next;
-	while (lp != &bitmap->list) {
-		br = list_entry(lp, struct xbitmap_range, list);
-
-		/*
-		 * Advance sub_br and/or br until we find a pair that
-		 * intersect or we run out of extents.
-		 */
-		while (sub_br->start + sub_br->len <= br->start) {
-			if (list_is_last(&sub_br->list, &sub->list))
-				goto out;
-			sub_br = list_next_entry(sub_br, list);
-		}
-		if (sub_br->start >= br->start + br->len) {
-			lp = lp->next;
-			continue;
-		}
+	struct xbitmap_node	*bn;
 
-		/* trim sub_br to fit the extent we have */
-		sub_start = sub_br->start;
-		sub_len = sub_br->len;
-		if (sub_br->start < br->start) {
-			sub_len -= br->start - sub_br->start;
-			sub_start = br->start;
-		}
-		if (sub_len > br->len)
-			sub_len = br->len;
-
-		state = 0;
-		if (sub_start == br->start)
-			state |= LEFT_ALIGNED;
-		if (sub_start + sub_len == br->start + br->len)
-			state |= RIGHT_ALIGNED;
-		switch (state) {
-		case LEFT_ALIGNED:
-			/* Coincides with only the left. */
-			br->start += sub_len;
-			br->len -= sub_len;
-			break;
-		case RIGHT_ALIGNED:
-			/* Coincides with only the right. */
-			br->len -= sub_len;
-			lp = lp->next;
-			break;
-		case LEFT_ALIGNED | RIGHT_ALIGNED:
-			/* Total overlap, just delete ex. */
-			lp = lp->next;
-			list_del(&br->list);
-			kmem_free(br);
-			break;
-		case 0:
-			/*
-			 * Deleting from the middle: add the new right extent
-			 * and then shrink the left extent.
-			 */
-			new_br = kmem_alloc(sizeof(struct xbitmap_range),
-					KM_MAYFAIL);
-			if (!new_br) {
-				error = -ENOMEM;
-				goto out;
-			}
-			INIT_LIST_HEAD(&new_br->list);
-			new_br->start = sub_start + sub_len;
-			new_br->len = br->start + br->len - new_br->start;
-			list_add(&new_br->list, &br->list);
-			br->len = sub_start - br->start;
-			lp = lp->next;
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
-	}
+	if (xbitmap_empty(bitmap) || xbitmap_empty(sub))
+		return;
 
-out:
-	return error;
+	for_each_xbitmap_extent(bn, sub)
+		xbitmap_clear(bitmap, bn->bn_start,
+				bn->bn_last - bn->bn_start + 1);
 }
-#undef LEFT_ALIGNED
-#undef RIGHT_ALIGNED
 
 /*
  * Record all btree blocks seen while iterating all records of a btree.
@@ -306,11 +296,11 @@ uint64_t
 xbitmap_hweight(
 	struct xbitmap		*bitmap)
 {
-	struct xbitmap_range	*bmr;
+	struct xbitmap_node	*bn;
 	uint64_t		ret = 0;
 
-	for_each_xbitmap_extent(bmr, bitmap)
-		ret += bmr->len;
+	for_each_xbitmap_extent(bn, bitmap)
+		ret += bn->bn_last - bn->bn_start + 1;
 
 	return ret;
 }
@@ -319,14 +309,14 @@ xbitmap_hweight(
 int
 xbitmap_walk(
 	struct xbitmap		*bitmap,
-	xbitmap_walk_fn	fn,
+	xbitmap_walk_fn		fn,
 	void			*priv)
 {
-	struct xbitmap_range	*bex;
+	struct xbitmap_node	*bn;
 	int			error;
 
-	for_each_xbitmap_extent(bex, bitmap) {
-		error = fn(bex->start, bex->len, priv);
+	for_each_xbitmap_extent(bn, bitmap) {
+		error = fn(bn->bn_start, bn->bn_last - bn->bn_start + 1, priv);
 		if (error)
 			break;
 	}
@@ -370,3 +360,11 @@ xbitmap_walk_bits(
 
 	return xbitmap_walk(bitmap, xbitmap_walk_bits_in_run, &wb);
 }
+
+/* Does this bitmap have no bits set at all? */
+bool
+xbitmap_empty(
+	struct xbitmap		*bitmap)
+{
+	return bitmap->xb_root.rb_root.rb_node == NULL;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 53601d281ffb..102ab5c89012 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -6,21 +6,16 @@
 #ifndef __XFS_SCRUB_BITMAP_H__
 #define __XFS_SCRUB_BITMAP_H__
 
-struct xbitmap_range {
-	struct list_head	list;
-	uint64_t		start;
-	uint64_t		len;
-};
-
 struct xbitmap {
-	struct list_head	list;
+	struct rb_root_cached	xb_root;
 };
 
 void xbitmap_init(struct xbitmap *bitmap);
 void xbitmap_destroy(struct xbitmap *bitmap);
 
+void xbitmap_clear(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
-int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
+void xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
 int xbitmap_set_btcur_path(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
 int xbitmap_set_btblocks(struct xbitmap *bitmap,
@@ -42,4 +37,6 @@ typedef int (*xbitmap_walk_bits_fn)(uint64_t bit, void *priv);
 int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 		void *priv);
 
+bool xbitmap_empty(struct xbitmap *bitmap);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */

