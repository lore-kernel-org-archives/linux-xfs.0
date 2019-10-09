Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F19EC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 636D021848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z2rQC5jR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbfJIQtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:49:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJIQtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:49:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjdhx039810
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Nqnjdd+lMa1GuFkbqNWsZYakFMHMckTKLayoxE4kIAs=;
 b=Z2rQC5jRITbzwd+x3VRClp+cb7KXYpYVv62QalKmJP1XScoMlryhFQh1ZbxWsUbHummo
 QdXryQfgB6FHpEb4AmvkzOJoijRPpsWKdJ9gU6i/5cTydd9SgWzwFM50QMJnvhGotQEp
 GbDlHhIoyZl4/+My1g/qbVXUH66CbXQ7uJc7BIogU3yvKPQTNbg0zBSUXGk4gAc1bg5s
 SYuU3y2uyNesKgGZh2taRAsWpRRzKJCelkrtwdUQzw9onG0D0aiea+YuMs127t4lSNNK
 HWVBbBBC/3+J2JAOeQOxJ374XiQ4r+kkb0fdp73S4QoyxHxh7B6OtUWODQrxmkKV7W9D 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vejkup11y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiZkX174372
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vhhsmx14u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99GnVL4027694
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:49:31 -0700
Subject: [PATCH 4/4] xfs: convert xbitmap to interval tree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:49:30 -0700
Message-ID: <157063977028.2913318.2884583474654943260.stgit@magnolia>
In-Reply-To: <157063973592.2913318.8246472567175058111.stgit@magnolia>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the xbitmap code to use interval trees instead of linked lists.
This reduces the amount of coding required to handle the disunion
operation and in the future will make it easier to set bits in arbitrary
order yet later be able to extract maximally sized extents, which we'll
need for rebuilding certain structures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Kconfig                 |    1 
 fs/xfs/scrub/agheader_repair.c |    4 -
 fs/xfs/scrub/bitmap.c          |  292 +++++++++++++++++-----------------------
 fs/xfs/scrub/bitmap.h          |   13 +-
 4 files changed, 135 insertions(+), 175 deletions(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index e685299eb3d2..ba939d258fa5 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -89,6 +89,7 @@ config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
 	default n
 	depends on XFS_FS && XFS_ONLINE_SCRUB
+	select INTERVAL_TREE
 	help
 	  If you say Y here you will be able to repair metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 145e9d359d2f..f0cf205d3e73 100644
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
index 1041f17f6bb6..e1da103bce78 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -12,30 +12,105 @@
 #include "xfs_btree.h"
 #include "scrub/bitmap.h"
 
-#define for_each_xbitmap_extent(bex, n, bitmap) \
-	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
+#define for_each_xbitmap_extent(itn, n, bitmap) \
+	rbtree_postorder_for_each_entry_safe((itn), (n), \
+			&(bitmap)->root.rb_root, rb)
 
-/*
- * Set a range of this bitmap.  Caller must ensure the range is not set.
- *
- * This is the logical equivalent of bitmap |= mask(start, len).
- */
+/* Clear a range of this bitmap. */
+static void
+__xbitmap_clear(
+	struct xbitmap			*bitmap,
+	uint64_t			start,
+	uint64_t			last)
+{
+	struct interval_tree_node	*itn;
+
+	while ((itn = interval_tree_iter_first(&bitmap->root, start, last))) {
+		if (itn->start < start) {
+			/* overlaps with the left side of the clearing range */
+			interval_tree_remove(itn, &bitmap->root);
+			itn->last = start - 1;
+			interval_tree_insert(itn, &bitmap->root);
+		} else if (itn->last > last) {
+			/* overlaps with the right side of the clearing range */
+			interval_tree_remove(itn, &bitmap->root);
+			itn->start = last + 1;
+			interval_tree_insert(itn, &bitmap->root);
+			break;
+		} else {
+			/* in the middle of the clearing range */
+			interval_tree_remove(itn, &bitmap->root);
+			kmem_free(itn);
+		}
+	}
+}
+
+/* Clear a range of this bitmap. */
+void
+xbitmap_clear(
+	struct xbitmap			*bitmap,
+	uint64_t			start,
+	uint64_t			len)
+{
+	__xbitmap_clear(bitmap, start, start + len - 1);
+}
+
+/* Set a range of this bitmap. */
 int
 xbitmap_set(
-	struct xbitmap		*bitmap,
-	uint64_t		start,
-	uint64_t		len)
+	struct xbitmap			*bitmap,
+	uint64_t			start,
+	uint64_t			len)
 {
-	struct xbitmap_range	*bmr;
+	struct interval_tree_node	*left;
+	struct interval_tree_node	*right;
+	uint64_t			last = start + len - 1;
 
-	bmr = kmem_alloc(sizeof(struct xbitmap_range), KM_MAYFAIL);
-	if (!bmr)
-		return -ENOMEM;
+	/* Is this whole range already set? */
+	left = interval_tree_iter_first(&bitmap->root, start, last);
+	if (left && left->start <= start && left->last >= last)
+		return 0;
 
-	INIT_LIST_HEAD(&bmr->list);
-	bmr->start = start;
-	bmr->len = len;
-	list_add_tail(&bmr->list, &bitmap->list);
+	/* Clear out everything in the range we want to set. */
+	xbitmap_clear(bitmap, start, len);
+
+	/* Do we have a left-adjacent extent? */
+	left = interval_tree_iter_first(&bitmap->root, start - 1, start - 1);
+	if (left && left->last + 1 != start)
+		left = NULL;
+
+	/* Do we have a right-adjacent extent? */
+	right = interval_tree_iter_first(&bitmap->root, last + 1, last + 1);
+	if (right && right->start != last + 1)
+		right = NULL;
+
+	if (left && right) {
+		/* combine left and right adjacent extent */
+		interval_tree_remove(left, &bitmap->root);
+		interval_tree_remove(right, &bitmap->root);
+		left->last = right->last;
+		interval_tree_insert(left, &bitmap->root);
+		kmem_free(right);
+	} else if (left) {
+		/* combine with left extent */
+		interval_tree_remove(left, &bitmap->root);
+		left->last = last;
+		interval_tree_insert(left, &bitmap->root);
+	} else if (right) {
+		/* combine with right extent */
+		interval_tree_remove(right, &bitmap->root);
+		right->start = start;
+		interval_tree_insert(right, &bitmap->root);
+	} else {
+		/* add an extent */
+		left = kmem_alloc(sizeof(struct interval_tree_node),
+				KM_MAYFAIL);
+		if (!left)
+			return -ENOMEM;
+		left->start = start;
+		left->last = last;
+		interval_tree_insert(left, &bitmap->root);
+	}
 
 	return 0;
 }
@@ -43,14 +118,13 @@ xbitmap_set(
 /* Free everything related to this bitmap. */
 void
 xbitmap_destroy(
-	struct xbitmap		*bitmap)
+	struct xbitmap			*bitmap)
 {
-	struct xbitmap_range	*bmr;
-	struct xbitmap_range	*n;
+	struct interval_tree_node	*itn, *p;
 
-	for_each_xbitmap_extent(bmr, n, bitmap) {
-		list_del(&bmr->list);
-		kmem_free(bmr);
+	for_each_xbitmap_extent(itn, p, bitmap) {
+		interval_tree_remove(itn, &bitmap->root);
+		kfree(itn);
 	}
 }
 
@@ -59,27 +133,7 @@ void
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
+	bitmap->root = RB_ROOT_CACHED;
 }
 
 /*
@@ -96,118 +150,19 @@ xbitmap_range_cmp(
  *
  * This is the logical equivalent of bitmap &= ~sub.
  */
-#define LEFT_ALIGNED	(1 << 0)
-#define RIGHT_ALIGNED	(1 << 1)
-int
+void
 xbitmap_disunion(
-	struct xbitmap		*bitmap,
-	struct xbitmap		*sub)
+	struct xbitmap			*bitmap,
+	struct xbitmap			*sub)
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
+	struct interval_tree_node	*itn, *n;
 
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
+	for_each_xbitmap_extent(itn, n, sub)
+		__xbitmap_clear(bitmap, itn->start, itn->last);
 }
-#undef LEFT_ALIGNED
-#undef RIGHT_ALIGNED
 
 /*
  * Record all btree blocks seen while iterating all records of a btree.
@@ -303,14 +258,13 @@ xbitmap_set_btblocks(
 /* How many bits are set in this bitmap? */
 uint64_t
 xbitmap_hweight(
-	struct xbitmap		*bitmap)
+	struct xbitmap			*bitmap)
 {
-	struct xbitmap_range	*bmr;
-	struct xbitmap_range	*n;
-	uint64_t		ret = 0;
+	struct interval_tree_node	*itn, *n;
+	uint64_t			ret = 0;
 
-	for_each_xbitmap_extent(bmr, n, bitmap)
-		ret += bmr->len;
+	for_each_xbitmap_extent(itn, n, bitmap)
+		ret += itn->last - itn->start + 1;
 
 	return ret;
 }
@@ -318,15 +272,15 @@ xbitmap_hweight(
 /* Call a function for every run of set bits in this bitmap. */
 int
 xbitmap_iter_set(
-	struct xbitmap		*bitmap,
-	xbitmap_walk_run_fn	fn,
-	void			*priv)
+	struct xbitmap			*bitmap,
+	xbitmap_walk_run_fn		fn,
+	void				*priv)
 {
-	struct xbitmap_range	*bex, *n;
-	int			error;
+	struct interval_tree_node	*itn, *n;
+	int				error;
 
-	for_each_xbitmap_extent(bex, n, bitmap) {
-		error = fn(bex->start, bex->len, priv);
+	for_each_xbitmap_extent(itn, n, bitmap) {
+		error = fn(itn->start, itn->last - itn->start + 1, priv);
 		if (error)
 			break;
 	}
@@ -370,3 +324,11 @@ xbitmap_iter_set_bits(
 
 	return xbitmap_iter_set(bitmap, xbitmap_walk_bits_in_run, &wb);
 }
+
+/* Does this bitmap have no bits set at all? */
+bool
+xbitmap_empty(
+	struct xbitmap		*bitmap)
+{
+	return bitmap->root.rb_root.rb_node == NULL;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 27fde5b4a753..6be596e60ac8 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -6,21 +6,18 @@
 #ifndef __XFS_SCRUB_BITMAP_H__
 #define __XFS_SCRUB_BITMAP_H__
 
-struct xbitmap_range {
-	struct list_head	list;
-	uint64_t		start;
-	uint64_t		len;
-};
+#include <linux/interval_tree.h>
 
 struct xbitmap {
-	struct list_head	list;
+	struct rb_root_cached	root;
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
@@ -42,4 +39,6 @@ typedef int (*xbitmap_walk_bit_fn)(uint64_t bit, void *priv);
 int xbitmap_iter_set_bits(struct xbitmap *bitmap, xbitmap_walk_bit_fn fn,
 		void *priv);
 
+bool xbitmap_empty(struct xbitmap *bitmap);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */

