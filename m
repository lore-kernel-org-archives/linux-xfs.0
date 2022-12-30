Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABED5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbiLaAUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbiLaAUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:20:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B921E3F3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:20:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 124D961D11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7ECC433EF;
        Sat, 31 Dec 2022 00:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446000;
        bh=cLPKgaPvV10AZTqzcoAN+YVI+Gy7GUwBLR8b5zYsL1c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t2Q3SeHK7vjRuoT0mcm4s8sB0M5mb28bcNe2bJpsTEcvrfUMtEp38qe9VEy+3Qm6T
         6wwmc0eQADt31KA47Xh2whWYAhbH7fGmJAE98bcRDZROJXlLiGuXWHjcg1DMC5HZg+
         8C7vgNJ8s1nJYdtwtvBw0llmA0tGjdJHYLUR1DmYFhNrBFffra2S3/r/140W3WdpX/
         qNIlAjsDp5MYfgCoO8yQR6lYf2bihoXvcZshnPfTGgLecTolZU/o0cSNvv58P7QzBV
         0yZVMuGzbAe1p5E1RYW6aSyYhgd//NIC8y+ybXQCAf4ZVaW/tfqTNk80YJFAYnO7NL
         swx/PnTyFbOkQ==
Subject: [PATCH 05/19] xfs: create deferred log items for extent swapping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868004.713817.8480273095356838992.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've created the skeleton of a log intent item to track and
restart extent swap operations, add the upper level logic to commit
intent items and turn them into concrete work recorded in the log.  We
use the deferred item "multihop" feature that was introduced a few
patches ago to constrain the number of active swap operations to one per
thread.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h      |   13 +
 libxfs/Makefile          |    2 
 libxfs/defer_item.c      |   79 ++++
 libxfs/libxfs_priv.h     |   30 +
 libxfs/xfs_bmap.h        |    4 
 libxfs/xfs_defer.c       |    7 
 libxfs/xfs_defer.h       |    3 
 libxfs/xfs_format.h      |    6 
 libxfs/xfs_log_format.h  |   28 +
 libxfs/xfs_swapext.c     | 1018 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_swapext.h     |  142 ++++++
 libxfs/xfs_trans_space.h |    4 
 12 files changed, 1331 insertions(+), 5 deletions(-)
 create mode 100644 libxfs/xfs_swapext.c


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 3c6bd32d4ca..a6ba6fc93bf 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -316,6 +316,9 @@
 #define trace_xfs_refcount_cow_decrease(...)	((void) 0)
 #define trace_xfs_refcount_recover_extent(...)	((void) 0)
 
+#define trace_xfs_reflink_set_inode_flag(...)	((void) 0)
+#define trace_xfs_reflink_unset_inode_flag(...)	((void) 0)
+
 #define trace_xfs_rmap_find_left_neighbor_candidate(...)	((void) 0)
 #define trace_xfs_rmap_find_left_neighbor_query(...)	((void) 0)
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
@@ -329,6 +332,16 @@
 #define trace_xfs_rmap_map_error(...)		((void) 0)
 #define trace_xfs_rmap_delete_error(...)	((void) 0)
 
+#define trace_xfs_swapext_defer(...)		((void) 0)
+#define trace_xfs_swapext_delta_nextents(...)	((void) 0)
+#define trace_xfs_swapext_delta_nextents_step(...)	((void) 0)
+#define trace_xfs_swapext_extent1(...)		((void) 0)
+#define trace_xfs_swapext_extent2(...)		((void) 0)
+#define trace_xfs_swapext_final_estimate(...)	((void) 0)
+#define trace_xfs_swapext_initial_estimate(...)	((void) 0)
+#define trace_xfs_swapext_overhead(...)		((void) 0)
+#define trace_xfs_swapext_update_inode_size(...) ((void) 0)
+
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
 /* set c = c to avoid unused var warnings */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index b4aa9706aaa..0e43941948d 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -55,6 +55,7 @@ HFILES = \
 	xfs_rmap_btree.h \
 	xfs_sb.h \
 	xfs_shared.h \
+	xfs_swapext.h \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
 	xfs_dir2_priv.h
@@ -103,6 +104,7 @@ CFILES = cache.c \
 	xfs_rmap_btree.c \
 	xfs_rtbitmap.c \
 	xfs_sb.c \
+	xfs_swapext.c \
 	xfs_symlink_remote.c \
 	xfs_trans_inode.c \
 	xfs_trans_resv.c \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index ab61e0fe572..316cc87a802 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -24,6 +24,8 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "libxfs.h"
+#include "xfs_ag.h"
+#include "xfs_swapext.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -651,3 +653,80 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.finish_item	= xfs_attr_finish_item,
 	.cancel_item	= xfs_attr_cancel_item,
 };
+
+/* Atomic Swapping of File Ranges */
+
+STATIC struct xfs_log_item *
+xfs_swapext_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return NULL;
+}
+STATIC struct xfs_log_item *
+xfs_swapext_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Process a deferred swapext update. */
+STATIC int
+xfs_swapext_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_swapext_intent	*sxi;
+	int				error;
+
+	sxi = container_of(item, struct xfs_swapext_intent, sxi_list);
+
+	/*
+	 * Swap one more extent between the two files.  If there's still more
+	 * work to do, we want to requeue ourselves after all other pending
+	 * deferred operations have finished.  This includes all of the dfops
+	 * that we queued directly as well as any new ones created in the
+	 * process of finishing the others.  Doing so prevents us from queuing
+	 * a large number of SXI log items in kernel memory, which in turn
+	 * prevents us from pinning the tail of the log (while logging those
+	 * new SXI items) until the first SXI items can be processed.
+	 */
+	error = xfs_swapext_finish_one(tp, sxi);
+	if (error == -EAGAIN)
+		return error;
+
+	kmem_cache_free(xfs_swapext_intent_cache, sxi);
+	return error;
+}
+
+/* Abort all pending SXIs. */
+STATIC void
+xfs_swapext_abort_intent(
+	struct xfs_log_item		*intent)
+{
+}
+
+/* Cancel a deferred swapext update. */
+STATIC void
+xfs_swapext_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_swapext_intent	*sxi;
+
+	sxi = container_of(item, struct xfs_swapext_intent, sxi_list);
+	kmem_cache_free(xfs_swapext_intent_cache, sxi);
+}
+
+const struct xfs_defer_op_type xfs_swapext_defer_type = {
+	.create_intent	= xfs_swapext_create_intent,
+	.abort_intent	= xfs_swapext_abort_intent,
+	.create_done	= xfs_swapext_create_done,
+	.finish_item	= xfs_swapext_finish_item,
+	.cancel_item	= xfs_swapext_cancel_item,
+};
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2c5208f907d..63bc6ea7c2b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -219,6 +219,35 @@ static inline bool WARN_ON(bool expr) {
 	(inode)->i_version = (version);	\
 } while (0)
 
+#define __must_check                    __attribute__((__warn_unused_result__))
+
+/*
+ * Allows for effectively applying __must_check to a macro so we can have
+ * both the type-agnostic benefits of the macros while also being able to
+ * enforce that the return value is, in fact, checked.
+ */
+static inline bool __must_check __must_check_overflow(bool overflow)
+{
+	return unlikely(overflow);
+}
+
+/*
+ * For simplicity and code hygiene, the fallback code below insists on
+ * a, b and *d having the same type (similar to the min() and max()
+ * macros), whereas gcc's type-generic overflow checkers accept
+ * different types. Hence we don't just make check_add_overflow an
+ * alias for __builtin_add_overflow, but add type checks similar to
+ * below.
+ */
+#define check_add_overflow(a, b, d) __must_check_overflow(({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_add_overflow(__a, __b, __d);	\
+}))
+
 static inline int __do_div(unsigned long long *n, unsigned base)
 {
 	int __res;
@@ -601,6 +630,7 @@ void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
 #define xfs_log_in_recovery(mp)		(false)
 
 /* xfs_icache.c */
+#define xfs_inode_clear_cowblocks_tag(ip)	do { } while (0)
 #define xfs_inode_set_cowblocks_tag(ip)	do { } while (0)
 #define xfs_inode_set_eofblocks_tag(ip)	do { } while (0)
 
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index cb09a43a287..413ec27f2f2 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -144,7 +144,7 @@ static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
 	{ BMAP_COWFORK,		"COW" }
 
 /* Return true if the extent is an allocated extent, written or not. */
-static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_real_extent(const struct xfs_bmbt_irec *irec)
 {
 	return irec->br_startblock != HOLESTARTBLOCK &&
 		irec->br_startblock != DELAYSTARTBLOCK &&
@@ -155,7 +155,7 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(const struct xfs_bmbt_irec *irec)
 {
 	return xfs_bmap_is_real_extent(irec) &&
 	       irec->br_state != XFS_EXT_UNWRITTEN;
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 77a94f58f41..47a7c5ed1f5 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -21,6 +21,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
+#include "xfs_swapext.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -184,6 +185,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
+	[XFS_DEFER_OPS_TYPE_SWAPEXT]	= &xfs_swapext_defer_type,
 };
 
 /*
@@ -908,6 +910,10 @@ xfs_defer_init_item_caches(void)
 	error = xfs_attr_intent_init_cache();
 	if (error)
 		goto err;
+	error = xfs_swapext_intent_init_cache();
+	if (error)
+		goto err;
+
 	return 0;
 err:
 	xfs_defer_destroy_item_caches();
@@ -918,6 +924,7 @@ xfs_defer_init_item_caches(void)
 void
 xfs_defer_destroy_item_caches(void)
 {
+	xfs_swapext_intent_destroy_cache();
 	xfs_attr_intent_destroy_cache();
 	xfs_extfree_intent_destroy_cache();
 	xfs_bmap_intent_destroy_cache();
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 114a3a4930a..bcc48b0c75c 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -20,6 +20,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	XFS_DEFER_OPS_TYPE_ATTR,
+	XFS_DEFER_OPS_TYPE_SWAPEXT,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
@@ -65,7 +66,7 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 extern const struct xfs_defer_op_type xfs_attr_defer_type;
-
+extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 
 /*
  * Deferred operation item relogging limits.
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 1424976ec95..bb8bff48801 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -425,6 +425,12 @@ static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
 		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
 }
 
+static inline bool xfs_sb_version_haslogswapext(struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
+		 XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT);
+}
+
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index b105a5ef664..65a84fdefe5 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -891,9 +891,33 @@ struct xfs_swap_extent {
 	int64_t			sx_isize2;
 };
 
-#define XFS_SWAP_EXT_FLAGS		(0)
+/* Swap extents between extended attribute forks. */
+#define XFS_SWAP_EXT_ATTR_FORK		(1ULL << 0)
 
-#define XFS_SWAP_EXT_STRINGS
+/* Set the file sizes when finished. */
+#define XFS_SWAP_EXT_SET_SIZES		(1ULL << 1)
+
+/* Do not swap any part of the range where inode1's mapping is a hole. */
+#define XFS_SWAP_EXT_SKIP_INO1_HOLES	(1ULL << 2)
+
+/* Clear the reflink flag from inode1 after the operation. */
+#define XFS_SWAP_EXT_CLEAR_INO1_REFLINK	(1ULL << 3)
+
+/* Clear the reflink flag from inode2 after the operation. */
+#define XFS_SWAP_EXT_CLEAR_INO2_REFLINK	(1ULL << 4)
+
+#define XFS_SWAP_EXT_FLAGS		(XFS_SWAP_EXT_ATTR_FORK | \
+					 XFS_SWAP_EXT_SET_SIZES | \
+					 XFS_SWAP_EXT_SKIP_INO1_HOLES | \
+					 XFS_SWAP_EXT_CLEAR_INO1_REFLINK | \
+					 XFS_SWAP_EXT_CLEAR_INO2_REFLINK)
+
+#define XFS_SWAP_EXT_STRINGS \
+	{ XFS_SWAP_EXT_ATTR_FORK,		"ATTRFORK" }, \
+	{ XFS_SWAP_EXT_SET_SIZES,		"SETSIZES" }, \
+	{ XFS_SWAP_EXT_SKIP_INO1_HOLES,		"SKIP_INO1_HOLES" }, \
+	{ XFS_SWAP_EXT_CLEAR_INO1_REFLINK,	"CLEAR_INO1_REFLINK" }, \
+	{ XFS_SWAP_EXT_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }
 
 /* This is the structure used to lay out an sxi log item in the log. */
 struct xfs_sxi_log_format {
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
new file mode 100644
index 00000000000..4c3dd4f7c7f
--- /dev/null
+++ b/libxfs/xfs_swapext.c
@@ -0,0 +1,1018 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_bmap.h"
+#include "xfs_swapext.h"
+#include "xfs_trace.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_quota_defs.h"
+#include "xfs_health.h"
+
+struct kmem_cache	*xfs_swapext_intent_cache;
+
+/* bmbt mappings adjacent to a pair of records. */
+struct xfs_swapext_adjacent {
+	struct xfs_bmbt_irec		left1;
+	struct xfs_bmbt_irec		right1;
+	struct xfs_bmbt_irec		left2;
+	struct xfs_bmbt_irec		right2;
+};
+
+#define ADJACENT_INIT { \
+	.left1  = { .br_startblock = HOLESTARTBLOCK }, \
+	.right1 = { .br_startblock = HOLESTARTBLOCK }, \
+	.left2  = { .br_startblock = HOLESTARTBLOCK }, \
+	.right2 = { .br_startblock = HOLESTARTBLOCK }, \
+}
+
+/* Information to help us reset reflink flag / CoW fork state after a swap. */
+
+/* Previous state of the two inodes' reflink flags. */
+#define XFS_REFLINK_STATE_IP1		(1U << 0)
+#define XFS_REFLINK_STATE_IP2		(1U << 1)
+
+/*
+ * If the reflink flag is set on either inode, make sure it has an incore CoW
+ * fork, since all reflink inodes must have them.  If there's a CoW fork and it
+ * has extents in it, make sure the inodes are tagged appropriately so that
+ * speculative preallocations can be GC'd if we run low of space.
+ */
+static inline void
+xfs_swapext_ensure_cowfork(
+	struct xfs_inode	*ip)
+{
+	struct xfs_ifork	*cfork;
+
+	if (xfs_is_reflink_inode(ip))
+		xfs_ifork_init_cow(ip);
+
+	cfork = xfs_ifork_ptr(ip, XFS_COW_FORK);
+	if (!cfork)
+		return;
+	if (cfork->if_bytes > 0)
+		xfs_inode_set_cowblocks_tag(ip);
+	else
+		xfs_inode_clear_cowblocks_tag(ip);
+}
+
+/* Schedule an atomic extent swap. */
+void
+xfs_swapext_schedule(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	trace_xfs_swapext_defer(tp->t_mountp, sxi);
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_SWAPEXT, &sxi->sxi_list);
+}
+
+/*
+ * Adjust the on-disk inode size upwards if needed so that we never map extents
+ * into the file past EOF.  This is crucial so that log recovery won't get
+ * confused by the sudden appearance of post-eof extents.
+ */
+STATIC void
+xfs_swapext_update_size(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	xfs_fsize_t		new_isize)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_fsize_t		len;
+
+	if (new_isize < 0)
+		return;
+
+	len = min(XFS_FSB_TO_B(mp, imap->br_startoff + imap->br_blockcount),
+		  new_isize);
+
+	if (len <= ip->i_disk_size)
+		return;
+
+	trace_xfs_swapext_update_inode_size(ip, len);
+
+	ip->i_disk_size = len;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+static inline bool
+sxi_has_more_swap_work(const struct xfs_swapext_intent *sxi)
+{
+	return sxi->sxi_blockcount > 0;
+}
+
+static inline bool
+sxi_has_postop_work(const struct xfs_swapext_intent *sxi)
+{
+	return sxi->sxi_flags & (XFS_SWAP_EXT_CLEAR_INO1_REFLINK |
+				 XFS_SWAP_EXT_CLEAR_INO2_REFLINK);
+}
+
+static inline void
+sxi_advance(
+	struct xfs_swapext_intent	*sxi,
+	const struct xfs_bmbt_irec	*irec)
+{
+	sxi->sxi_startoff1 += irec->br_blockcount;
+	sxi->sxi_startoff2 += irec->br_blockcount;
+	sxi->sxi_blockcount -= irec->br_blockcount;
+}
+
+/* Check all extents to make sure we can actually swap them. */
+int
+xfs_swapext_check_extents(
+	struct xfs_mount		*mp,
+	const struct xfs_swapext_req	*req)
+{
+	struct xfs_ifork		*ifp1, *ifp2;
+
+	/* No fork? */
+	ifp1 = xfs_ifork_ptr(req->ip1, req->whichfork);
+	ifp2 = xfs_ifork_ptr(req->ip2, req->whichfork);
+	if (!ifp1 || !ifp2)
+		return -EINVAL;
+
+	/* We don't know how to swap local format forks. */
+	if (ifp1->if_format == XFS_DINODE_FMT_LOCAL ||
+	    ifp2->if_format == XFS_DINODE_FMT_LOCAL)
+		return -EINVAL;
+
+	/* We don't support realtime data forks yet. */
+	if (!XFS_IS_REALTIME_INODE(req->ip1))
+		return 0;
+	if (req->whichfork == XFS_ATTR_FORK)
+		return 0;
+	return -EINVAL;
+}
+
+#ifdef CONFIG_XFS_QUOTA
+/* Log the actual updates to the quota accounting. */
+static inline void
+xfs_swapext_update_quota(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi,
+	struct xfs_bmbt_irec		*irec1,
+	struct xfs_bmbt_irec		*irec2)
+{
+	int64_t				ip1_delta = 0, ip2_delta = 0;
+	unsigned int			qflag;
+
+	qflag = XFS_IS_REALTIME_INODE(sxi->sxi_ip1) ? XFS_TRANS_DQ_RTBCOUNT :
+						      XFS_TRANS_DQ_BCOUNT;
+
+	if (xfs_bmap_is_real_extent(irec1)) {
+		ip1_delta -= irec1->br_blockcount;
+		ip2_delta += irec1->br_blockcount;
+	}
+
+	if (xfs_bmap_is_real_extent(irec2)) {
+		ip1_delta += irec2->br_blockcount;
+		ip2_delta -= irec2->br_blockcount;
+	}
+
+	xfs_trans_mod_dquot_byino(tp, sxi->sxi_ip1, qflag, ip1_delta);
+	xfs_trans_mod_dquot_byino(tp, sxi->sxi_ip2, qflag, ip2_delta);
+}
+#else
+# define xfs_swapext_update_quota(tp, sxi, irec1, irec2)	((void)0)
+#endif
+
+/*
+ * Walk forward through the file ranges in @sxi until we find two different
+ * mappings to exchange.  If there is work to do, return the mappings;
+ * otherwise we've reached the end of the range and sxi_blockcount will be
+ * zero.
+ *
+ * If the walk skips over a pair of mappings to the same storage, save them as
+ * the left records in @adj (if provided) so that the simulation phase can
+ * avoid an extra lookup.
+  */
+static int
+xfs_swapext_find_mappings(
+	struct xfs_swapext_intent	*sxi,
+	struct xfs_bmbt_irec		*irec1,
+	struct xfs_bmbt_irec		*irec2,
+	struct xfs_swapext_adjacent	*adj)
+{
+	int				nimaps;
+	int				bmap_flags;
+	int				error;
+
+	bmap_flags = xfs_bmapi_aflag(xfs_swapext_whichfork(sxi));
+
+	for (; sxi_has_more_swap_work(sxi); sxi_advance(sxi, irec1)) {
+		/* Read extent from the first file */
+		nimaps = 1;
+		error = xfs_bmapi_read(sxi->sxi_ip1, sxi->sxi_startoff1,
+				sxi->sxi_blockcount, irec1, &nimaps,
+				bmap_flags);
+		if (error)
+			return error;
+		if (nimaps != 1 ||
+		    irec1->br_startblock == DELAYSTARTBLOCK ||
+		    irec1->br_startoff != sxi->sxi_startoff1) {
+			/*
+			 * We should never get no mapping or a delalloc extent
+			 * or something that doesn't match what we asked for,
+			 * since the caller flushed both inodes and we hold the
+			 * ILOCKs for both inodes.
+			 */
+			ASSERT(0);
+			return -EINVAL;
+		}
+
+		/*
+		 * If the caller told us to ignore sparse areas of file1, jump
+		 * ahead to the next region.
+		 */
+		if ((sxi->sxi_flags & XFS_SWAP_EXT_SKIP_INO1_HOLES) &&
+		    irec1->br_startblock == HOLESTARTBLOCK) {
+			trace_xfs_swapext_extent1(sxi->sxi_ip1, irec1);
+			continue;
+		}
+
+		/* Read extent from the second file */
+		nimaps = 1;
+		error = xfs_bmapi_read(sxi->sxi_ip2, sxi->sxi_startoff2,
+				irec1->br_blockcount, irec2, &nimaps,
+				bmap_flags);
+		if (error)
+			return error;
+		if (nimaps != 1 ||
+		    irec2->br_startblock == DELAYSTARTBLOCK ||
+		    irec2->br_startoff != sxi->sxi_startoff2) {
+			/*
+			 * We should never get no mapping or a delalloc extent
+			 * or something that doesn't match what we asked for,
+			 * since the caller flushed both inodes and we hold the
+			 * ILOCKs for both inodes.
+			 */
+			ASSERT(0);
+			return -EINVAL;
+		}
+
+		/*
+		 * We can only swap as many blocks as the smaller of the two
+		 * extent maps.
+		 */
+		irec1->br_blockcount = min(irec1->br_blockcount,
+					   irec2->br_blockcount);
+
+		trace_xfs_swapext_extent1(sxi->sxi_ip1, irec1);
+		trace_xfs_swapext_extent2(sxi->sxi_ip2, irec2);
+
+		/* We found something to swap, so return it. */
+		if (irec1->br_startblock != irec2->br_startblock)
+			return 0;
+
+		/*
+		 * Two extents mapped to the same physical block must not have
+		 * different states; that's filesystem corruption.  Move on to
+		 * the next extent if they're both holes or both the same
+		 * physical extent.
+		 */
+		if (irec1->br_state != irec2->br_state) {
+			xfs_bmap_mark_sick(sxi->sxi_ip1,
+					xfs_swapext_whichfork(sxi));
+			xfs_bmap_mark_sick(sxi->sxi_ip2,
+					xfs_swapext_whichfork(sxi));
+			return -EFSCORRUPTED;
+		}
+
+		/*
+		 * Save the mappings if we're estimating work and skipping
+		 * these identical mappings.
+		 */
+		if (adj) {
+			memcpy(&adj->left1, irec1, sizeof(*irec1));
+			memcpy(&adj->left2, irec2, sizeof(*irec2));
+		}
+	}
+
+	return 0;
+}
+
+/* Exchange these two mappings. */
+static void
+xfs_swapext_exchange_mappings(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi,
+	struct xfs_bmbt_irec		*irec1,
+	struct xfs_bmbt_irec		*irec2)
+{
+	int				whichfork = xfs_swapext_whichfork(sxi);
+
+	xfs_swapext_update_quota(tp, sxi, irec1, irec2);
+
+	/* Remove both mappings. */
+	xfs_bmap_unmap_extent(tp, sxi->sxi_ip1, whichfork, irec1);
+	xfs_bmap_unmap_extent(tp, sxi->sxi_ip2, whichfork, irec2);
+
+	/*
+	 * Re-add both mappings.  We swap the file offsets between the two maps
+	 * and add the opposite map, which has the effect of filling the
+	 * logical offsets we just unmapped, but with with the physical mapping
+	 * information swapped.
+	 */
+	swap(irec1->br_startoff, irec2->br_startoff);
+	xfs_bmap_map_extent(tp, sxi->sxi_ip1, whichfork, irec2);
+	xfs_bmap_map_extent(tp, sxi->sxi_ip2, whichfork, irec1);
+
+	/* Make sure we're not mapping extents past EOF. */
+	if (whichfork == XFS_DATA_FORK) {
+		xfs_swapext_update_size(tp, sxi->sxi_ip1, irec2,
+				sxi->sxi_isize1);
+		xfs_swapext_update_size(tp, sxi->sxi_ip2, irec1,
+				sxi->sxi_isize2);
+	}
+
+	/*
+	 * Advance our cursor and exit.   The caller (either defer ops or log
+	 * recovery) will log the SXD item, and if *blockcount is nonzero, it
+	 * will log a new SXI item for the remainder and call us back.
+	 */
+	sxi_advance(sxi, irec1);
+}
+
+static inline void
+xfs_swapext_clear_reflink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	trace_xfs_reflink_unset_inode_flag(ip);
+
+	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/* Finish whatever work might come after a swap operation. */
+static int
+xfs_swapext_do_postop_work(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	if (sxi->sxi_flags & XFS_SWAP_EXT_CLEAR_INO1_REFLINK) {
+		xfs_swapext_clear_reflink(tp, sxi->sxi_ip1);
+		sxi->sxi_flags &= ~XFS_SWAP_EXT_CLEAR_INO1_REFLINK;
+	}
+
+	if (sxi->sxi_flags & XFS_SWAP_EXT_CLEAR_INO2_REFLINK) {
+		xfs_swapext_clear_reflink(tp, sxi->sxi_ip2);
+		sxi->sxi_flags &= ~XFS_SWAP_EXT_CLEAR_INO2_REFLINK;
+	}
+
+	return 0;
+}
+
+/* Finish one extent swap, possibly log more. */
+int
+xfs_swapext_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_bmbt_irec		irec1, irec2;
+	int				error;
+
+	if (sxi_has_more_swap_work(sxi)) {
+		/*
+		 * If the operation state says that some range of the files
+		 * have not yet been swapped, look for extents in that range to
+		 * swap.  If we find some extents, swap them.
+		 */
+		error = xfs_swapext_find_mappings(sxi, &irec1, &irec2, NULL);
+		if (error)
+			return error;
+
+		if (sxi_has_more_swap_work(sxi))
+			xfs_swapext_exchange_mappings(tp, sxi, &irec1, &irec2);
+
+		/*
+		 * If the caller asked us to exchange the file sizes after the
+		 * swap and either we just swapped the last extents in the
+		 * range or we didn't find anything to swap, update the ondisk
+		 * file sizes.
+		 */
+		if ((sxi->sxi_flags & XFS_SWAP_EXT_SET_SIZES) &&
+		    !sxi_has_more_swap_work(sxi)) {
+			sxi->sxi_ip1->i_disk_size = sxi->sxi_isize1;
+			sxi->sxi_ip2->i_disk_size = sxi->sxi_isize2;
+
+			xfs_trans_log_inode(tp, sxi->sxi_ip1, XFS_ILOG_CORE);
+			xfs_trans_log_inode(tp, sxi->sxi_ip2, XFS_ILOG_CORE);
+		}
+	} else if (sxi_has_postop_work(sxi)) {
+		/*
+		 * Now that we're finished with the swap operation, complete
+		 * the post-op cleanup work.
+		 */
+		error = xfs_swapext_do_postop_work(tp, sxi);
+		if (error)
+			return error;
+	}
+
+	/* If we still have work to do, ask for a new transaction. */
+	if (sxi_has_more_swap_work(sxi) || sxi_has_postop_work(sxi)) {
+		trace_xfs_swapext_defer(tp->t_mountp, sxi);
+		return -EAGAIN;
+	}
+
+	/*
+	 * If we reach here, we've finished all the swapping work and the post
+	 * operation work.  The last thing we need to do before returning to
+	 * the caller is to make sure that COW forks are set up correctly.
+	 */
+	if (!(sxi->sxi_flags & XFS_SWAP_EXT_ATTR_FORK)) {
+		xfs_swapext_ensure_cowfork(sxi->sxi_ip1);
+		xfs_swapext_ensure_cowfork(sxi->sxi_ip2);
+	}
+
+	return 0;
+}
+
+/*
+ * Compute the amount of bmbt blocks we should reserve for each file.  In the
+ * worst case, each exchange will fill a hole with a new mapping, which could
+ * result in a btree split every time we add a new leaf block.
+ */
+static inline uint64_t
+xfs_swapext_bmbt_blocks(
+	struct xfs_mount		*mp,
+	const struct xfs_swapext_req	*req)
+{
+	return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_BMAPS_PER_BLOCK(mp)) *
+			XFS_EXTENTADD_SPACE_RES(mp, req->whichfork);
+}
+
+static inline uint64_t
+xfs_swapext_rmapbt_blocks(
+	struct xfs_mount		*mp,
+	const struct xfs_swapext_req	*req)
+{
+	if (!xfs_has_rmapbt(mp))
+		return 0;
+	if (XFS_IS_REALTIME_INODE(req->ip1))
+		return 0;
+
+	return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) *
+			XFS_RMAPADD_SPACE_RES(mp);
+}
+
+/* Estimate the bmbt and rmapbt overhead required to exchange extents. */
+static int
+xfs_swapext_estimate_overhead(
+	struct xfs_swapext_req	*req)
+{
+	struct xfs_mount	*mp = req->ip1->i_mount;
+	xfs_filblks_t		bmbt_blocks;
+	xfs_filblks_t		rmapbt_blocks;
+	xfs_filblks_t		resblks = req->resblks;
+
+	/*
+	 * Compute the number of bmbt and rmapbt blocks we might need to handle
+	 * the estimated number of exchanges.
+	 */
+	bmbt_blocks = xfs_swapext_bmbt_blocks(mp, req);
+	rmapbt_blocks = xfs_swapext_rmapbt_blocks(mp, req);
+
+	trace_xfs_swapext_overhead(mp, bmbt_blocks, rmapbt_blocks);
+
+	/* Make sure the change in file block count doesn't overflow. */
+	if (check_add_overflow(req->ip1_bcount, bmbt_blocks, &req->ip1_bcount))
+		return -EFBIG;
+	if (check_add_overflow(req->ip2_bcount, bmbt_blocks, &req->ip2_bcount))
+		return -EFBIG;
+
+	/*
+	 * Add together the number of blocks we need to handle btree growth,
+	 * then add it to the number of blocks we need to reserve to this
+	 * transaction.
+	 */
+	if (check_add_overflow(resblks, bmbt_blocks, &resblks))
+		return -ENOSPC;
+	if (check_add_overflow(resblks, bmbt_blocks, &resblks))
+		return -ENOSPC;
+	if (check_add_overflow(resblks, rmapbt_blocks, &resblks))
+		return -ENOSPC;
+	if (check_add_overflow(resblks, rmapbt_blocks, &resblks))
+		return -ENOSPC;
+
+	/* Can't actually reserve more than UINT_MAX blocks. */
+	if (req->resblks > UINT_MAX)
+		return -ENOSPC;
+
+	req->resblks = resblks;
+	trace_xfs_swapext_final_estimate(req);
+	return 0;
+}
+
+/* Decide if we can merge two real extents. */
+static inline bool
+can_merge(
+	const struct xfs_bmbt_irec	*b1,
+	const struct xfs_bmbt_irec	*b2)
+{
+	/* Don't merge holes. */
+	if (b1->br_startblock == HOLESTARTBLOCK ||
+	    b2->br_startblock == HOLESTARTBLOCK)
+		return false;
+
+	/* We don't merge holes. */
+	if (!xfs_bmap_is_real_extent(b1) || !xfs_bmap_is_real_extent(b2))
+		return false;
+
+	if (b1->br_startoff   + b1->br_blockcount == b2->br_startoff &&
+	    b1->br_startblock + b1->br_blockcount == b2->br_startblock &&
+	    b1->br_state			  == b2->br_state &&
+	    b1->br_blockcount + b2->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+		return true;
+
+	return false;
+}
+
+#define CLEFT_CONTIG	0x01
+#define CRIGHT_CONTIG	0x02
+#define CHOLE		0x04
+#define CBOTH_CONTIG	(CLEFT_CONTIG | CRIGHT_CONTIG)
+
+#define NLEFT_CONTIG	0x10
+#define NRIGHT_CONTIG	0x20
+#define NHOLE		0x40
+#define NBOTH_CONTIG	(NLEFT_CONTIG | NRIGHT_CONTIG)
+
+/* Estimate the effect of a single swap on extent count. */
+static inline int
+delta_nextents_step(
+	struct xfs_mount		*mp,
+	const struct xfs_bmbt_irec	*left,
+	const struct xfs_bmbt_irec	*curr,
+	const struct xfs_bmbt_irec	*new,
+	const struct xfs_bmbt_irec	*right)
+{
+	bool				lhole, rhole, chole, nhole;
+	unsigned int			state = 0;
+	int				ret = 0;
+
+	lhole = left->br_startblock == HOLESTARTBLOCK;
+	rhole = right->br_startblock == HOLESTARTBLOCK;
+	chole = curr->br_startblock == HOLESTARTBLOCK;
+	nhole = new->br_startblock == HOLESTARTBLOCK;
+
+	if (chole)
+		state |= CHOLE;
+	if (!lhole && !chole && can_merge(left, curr))
+		state |= CLEFT_CONTIG;
+	if (!rhole && !chole && can_merge(curr, right))
+		state |= CRIGHT_CONTIG;
+	if ((state & CBOTH_CONTIG) == CBOTH_CONTIG &&
+	    left->br_startblock + curr->br_startblock +
+					right->br_startblock > XFS_MAX_BMBT_EXTLEN)
+		state &= ~CRIGHT_CONTIG;
+
+	if (nhole)
+		state |= NHOLE;
+	if (!lhole && !nhole && can_merge(left, new))
+		state |= NLEFT_CONTIG;
+	if (!rhole && !nhole && can_merge(new, right))
+		state |= NRIGHT_CONTIG;
+	if ((state & NBOTH_CONTIG) == NBOTH_CONTIG &&
+	    left->br_startblock + new->br_startblock +
+					right->br_startblock > XFS_MAX_BMBT_EXTLEN)
+		state &= ~NRIGHT_CONTIG;
+
+	switch (state & (CLEFT_CONTIG | CRIGHT_CONTIG | CHOLE)) {
+	case CLEFT_CONTIG | CRIGHT_CONTIG:
+		/*
+		 * left/curr/right are the same extent, so deleting curr causes
+		 * 2 new extents to be created.
+		 */
+		ret += 2;
+		break;
+	case 0:
+		/*
+		 * curr is not contiguous with any extent, so we remove curr
+		 * completely
+		 */
+		ret--;
+		break;
+	case CHOLE:
+		/* hole, do nothing */
+		break;
+	case CLEFT_CONTIG:
+	case CRIGHT_CONTIG:
+		/* trim either left or right, no change */
+		break;
+	}
+
+	switch (state & (NLEFT_CONTIG | NRIGHT_CONTIG | NHOLE)) {
+	case NLEFT_CONTIG | NRIGHT_CONTIG:
+		/*
+		 * left/curr/right will become the same extent, so adding
+		 * curr causes the deletion of right.
+		 */
+		ret--;
+		break;
+	case 0:
+		/* new is not contiguous with any extent */
+		ret++;
+		break;
+	case NHOLE:
+		/* hole, do nothing. */
+		break;
+	case NLEFT_CONTIG:
+	case NRIGHT_CONTIG:
+		/* new is absorbed into left or right, no change */
+		break;
+	}
+
+	trace_xfs_swapext_delta_nextents_step(mp, left, curr, new, right, ret,
+			state);
+	return ret;
+}
+
+/* Make sure we don't overflow the extent counters. */
+static inline int
+ensure_delta_nextents(
+	struct xfs_swapext_req	*req,
+	struct xfs_inode	*ip,
+	int64_t			delta)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, req->whichfork);
+	xfs_extnum_t		max_extents;
+	bool			large_extcount;
+
+	if (delta < 0)
+		return 0;
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS)) {
+		if (ifp->if_nextents + delta > 10)
+			return -EFBIG;
+	}
+
+	if (req->req_flags & XFS_SWAP_REQ_NREXT64)
+		large_extcount = true;
+	else
+		large_extcount = xfs_inode_has_large_extent_counts(ip);
+
+	max_extents = xfs_iext_max_nextents(large_extcount, req->whichfork);
+	if (ifp->if_nextents + delta <= max_extents)
+		return 0;
+	if (large_extcount)
+		return -EFBIG;
+	if (!xfs_has_large_extent_counts(mp))
+		return -EFBIG;
+
+	max_extents = xfs_iext_max_nextents(true, req->whichfork);
+	if (ifp->if_nextents + delta > max_extents)
+		return -EFBIG;
+
+	req->req_flags |= XFS_SWAP_REQ_NREXT64;
+	return 0;
+}
+
+/* Find the next extent after irec. */
+static inline int
+get_next_ext(
+	struct xfs_inode		*ip,
+	int				bmap_flags,
+	const struct xfs_bmbt_irec	*irec,
+	struct xfs_bmbt_irec		*nrec)
+{
+	xfs_fileoff_t			off;
+	xfs_filblks_t			blockcount;
+	int				nimaps = 1;
+	int				error;
+
+	off = irec->br_startoff + irec->br_blockcount;
+	blockcount = XFS_MAX_FILEOFF - off;
+	error = xfs_bmapi_read(ip, off, blockcount, nrec, &nimaps, bmap_flags);
+	if (error)
+		return error;
+	if (nrec->br_startblock == DELAYSTARTBLOCK ||
+	    nrec->br_startoff != off) {
+		/*
+		 * If we don't get the extent we want, return a zero-length
+		 * mapping, which our estimator function will pretend is a hole.
+		 * We shouldn't get delalloc reservations.
+		 */
+		nrec->br_startblock = HOLESTARTBLOCK;
+	}
+
+	return 0;
+}
+
+int __init
+xfs_swapext_intent_init_cache(void)
+{
+	xfs_swapext_intent_cache = kmem_cache_create("xfs_swapext_intent",
+			sizeof(struct xfs_swapext_intent),
+			0, 0, NULL);
+
+	return xfs_swapext_intent_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_swapext_intent_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_swapext_intent_cache);
+	xfs_swapext_intent_cache = NULL;
+}
+
+/*
+ * Decide if we will swap the reflink flags between the two files after the
+ * swap.  The only time we want to do this is if we're exchanging all extents
+ * under EOF and the inode reflink flags have different states.
+ */
+static inline bool
+sxi_can_exchange_reflink_flags(
+	const struct xfs_swapext_req	*req,
+	unsigned int			reflink_state)
+{
+	struct xfs_mount		*mp = req->ip1->i_mount;
+
+	if (hweight32(reflink_state) != 1)
+		return false;
+	if (req->startoff1 != 0 || req->startoff2 != 0)
+		return false;
+	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip1->i_disk_size))
+		return false;
+	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip2->i_disk_size))
+		return false;
+	return true;
+}
+
+
+/* Allocate and initialize a new incore intent item from a request. */
+struct xfs_swapext_intent *
+xfs_swapext_init_intent(
+	const struct xfs_swapext_req	*req,
+	unsigned int			*reflink_state)
+{
+	struct xfs_swapext_intent	*sxi;
+	unsigned int			rs = 0;
+
+	sxi = kmem_cache_zalloc(xfs_swapext_intent_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	INIT_LIST_HEAD(&sxi->sxi_list);
+	sxi->sxi_ip1 = req->ip1;
+	sxi->sxi_ip2 = req->ip2;
+	sxi->sxi_startoff1 = req->startoff1;
+	sxi->sxi_startoff2 = req->startoff2;
+	sxi->sxi_blockcount = req->blockcount;
+	sxi->sxi_isize1 = sxi->sxi_isize2 = -1;
+
+	if (req->whichfork == XFS_ATTR_FORK)
+		sxi->sxi_flags |= XFS_SWAP_EXT_ATTR_FORK;
+
+	if (req->whichfork == XFS_DATA_FORK &&
+	    (req->req_flags & XFS_SWAP_REQ_SET_SIZES)) {
+		sxi->sxi_flags |= XFS_SWAP_EXT_SET_SIZES;
+		sxi->sxi_isize1 = req->ip2->i_disk_size;
+		sxi->sxi_isize2 = req->ip1->i_disk_size;
+	}
+
+	if (req->req_flags & XFS_SWAP_REQ_SKIP_INO1_HOLES)
+		sxi->sxi_flags |= XFS_SWAP_EXT_SKIP_INO1_HOLES;
+
+	if (req->req_flags & XFS_SWAP_REQ_LOGGED)
+		sxi->sxi_op_flags |= XFS_SWAP_EXT_OP_LOGGED;
+	if (req->req_flags & XFS_SWAP_REQ_NREXT64)
+		sxi->sxi_op_flags |= XFS_SWAP_EXT_OP_NREXT64;
+
+	if (req->whichfork == XFS_DATA_FORK) {
+		/*
+		 * Record the state of each inode's reflink flag before the
+		 * operation.
+		 */
+		if (xfs_is_reflink_inode(req->ip1))
+			rs |= XFS_REFLINK_STATE_IP1;
+		if (xfs_is_reflink_inode(req->ip2))
+			rs |= XFS_REFLINK_STATE_IP2;
+
+		/*
+		 * Figure out if we're clearing the reflink flags (which
+		 * effectively swaps them) after the operation.
+		 */
+		if (sxi_can_exchange_reflink_flags(req, rs)) {
+			if (rs & XFS_REFLINK_STATE_IP1)
+				sxi->sxi_flags |=
+						XFS_SWAP_EXT_CLEAR_INO1_REFLINK;
+			if (rs & XFS_REFLINK_STATE_IP2)
+				sxi->sxi_flags |=
+						XFS_SWAP_EXT_CLEAR_INO2_REFLINK;
+		}
+	}
+
+	if (reflink_state)
+		*reflink_state = rs;
+	return sxi;
+}
+
+/*
+ * Estimate the number of exchange operations and the number of file blocks
+ * in each file that will be affected by the exchange operation.
+ */
+int
+xfs_swapext_estimate(
+	struct xfs_swapext_req		*req)
+{
+	struct xfs_swapext_intent	*sxi;
+	struct xfs_bmbt_irec		irec1, irec2;
+	struct xfs_swapext_adjacent	adj = ADJACENT_INIT;
+	xfs_filblks_t			ip1_blocks = 0, ip2_blocks = 0;
+	int64_t				d_nexts1, d_nexts2;
+	int				bmap_flags;
+	int				error;
+
+	ASSERT(!(req->req_flags & ~XFS_SWAP_REQ_FLAGS));
+
+	bmap_flags = xfs_bmapi_aflag(req->whichfork);
+	sxi = xfs_swapext_init_intent(req, NULL);
+
+	/*
+	 * To guard against the possibility of overflowing the extent counters,
+	 * we have to estimate an upper bound on the potential increase in that
+	 * counter.  We can split the extent at each end of the range, and for
+	 * each step of the swap we can split the extent that we're working on
+	 * if the extents do not align.
+	 */
+	d_nexts1 = d_nexts2 = 3;
+
+	while (sxi_has_more_swap_work(sxi)) {
+		/*
+		 * Walk through the file ranges until we find something to
+		 * swap.  Because we're simulating the swap, pass in adj to
+		 * capture skipped mappings for correct estimation of bmbt
+		 * record merges.
+		 */
+		error = xfs_swapext_find_mappings(sxi, &irec1, &irec2, &adj);
+		if (error)
+			goto out_free;
+		if (!sxi_has_more_swap_work(sxi))
+			break;
+
+		/* Update accounting. */
+		if (xfs_bmap_is_real_extent(&irec1))
+			ip1_blocks += irec1.br_blockcount;
+		if (xfs_bmap_is_real_extent(&irec2))
+			ip2_blocks += irec2.br_blockcount;
+		req->nr_exchanges++;
+
+		/* Read the next extents from both files. */
+		error = get_next_ext(req->ip1, bmap_flags, &irec1, &adj.right1);
+		if (error)
+			goto out_free;
+
+		error = get_next_ext(req->ip2, bmap_flags, &irec2, &adj.right2);
+		if (error)
+			goto out_free;
+
+		/* Update extent count deltas. */
+		d_nexts1 += delta_nextents_step(req->ip1->i_mount,
+				&adj.left1, &irec1, &irec2, &adj.right1);
+
+		d_nexts2 += delta_nextents_step(req->ip1->i_mount,
+				&adj.left2, &irec2, &irec1, &adj.right2);
+
+		/* Now pretend we swapped the extents. */
+		if (can_merge(&adj.left2, &irec1))
+			adj.left2.br_blockcount += irec1.br_blockcount;
+		else
+			memcpy(&adj.left2, &irec1, sizeof(irec1));
+
+		if (can_merge(&adj.left1, &irec2))
+			adj.left1.br_blockcount += irec2.br_blockcount;
+		else
+			memcpy(&adj.left1, &irec2, sizeof(irec2));
+
+		sxi_advance(sxi, &irec1);
+	}
+
+	/* Account for the blocks that are being exchanged. */
+	if (XFS_IS_REALTIME_INODE(req->ip1) &&
+	    req->whichfork == XFS_DATA_FORK) {
+		req->ip1_rtbcount = ip1_blocks;
+		req->ip2_rtbcount = ip2_blocks;
+	} else {
+		req->ip1_bcount = ip1_blocks;
+		req->ip2_bcount = ip2_blocks;
+	}
+
+	/*
+	 * Make sure that both forks have enough slack left in their extent
+	 * counters that the swap operation will not overflow.
+	 */
+	trace_xfs_swapext_delta_nextents(req, d_nexts1, d_nexts2);
+	if (req->ip1 == req->ip2) {
+		error = ensure_delta_nextents(req, req->ip1,
+				d_nexts1 + d_nexts2);
+	} else {
+		error = ensure_delta_nextents(req, req->ip1, d_nexts1);
+		if (error)
+			goto out_free;
+		error = ensure_delta_nextents(req, req->ip2, d_nexts2);
+	}
+	if (error)
+		goto out_free;
+
+	trace_xfs_swapext_initial_estimate(req);
+	error = xfs_swapext_estimate_overhead(req);
+out_free:
+	kmem_cache_free(xfs_swapext_intent_cache, sxi);
+	return error;
+}
+
+static inline void
+xfs_swapext_set_reflink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	trace_xfs_reflink_set_inode_flag(ip);
+
+	ip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/*
+ * If either file has shared blocks and we're swapping data forks, we must flag
+ * the other file as having shared blocks so that we get the shared-block rmap
+ * functions if we need to fix up the rmaps.
+ */
+void
+xfs_swapext_ensure_reflink(
+	struct xfs_trans		*tp,
+	const struct xfs_swapext_intent	*sxi,
+	unsigned int			reflink_state)
+{
+	if ((reflink_state & XFS_REFLINK_STATE_IP1) &&
+	    !xfs_is_reflink_inode(sxi->sxi_ip2))
+		xfs_swapext_set_reflink(tp, sxi->sxi_ip2);
+
+	if ((reflink_state & XFS_REFLINK_STATE_IP2) &&
+	    !xfs_is_reflink_inode(sxi->sxi_ip1))
+		xfs_swapext_set_reflink(tp, sxi->sxi_ip1);
+}
+
+/* Widen the extent counts of both inodes if necessary. */
+static inline void
+xfs_swapext_upgrade_extent_counts(
+	struct xfs_trans		*tp,
+	const struct xfs_swapext_intent	*sxi)
+{
+	if (!(sxi->sxi_op_flags & XFS_SWAP_EXT_OP_NREXT64))
+		return;
+
+	sxi->sxi_ip1->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(tp, sxi->sxi_ip1, XFS_ILOG_CORE);
+
+	sxi->sxi_ip2->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(tp, sxi->sxi_ip2, XFS_ILOG_CORE);
+}
+
+/*
+ * Schedule a swap a range of extents from one inode to another.  If the atomic
+ * swap feature is enabled, then the operation progress can be resumed even if
+ * the system goes down.  The caller must commit the transaction to start the
+ * work.
+ *
+ * The caller must ensure the inodes must be joined to the transaction and
+ * ILOCKd; they will still be joined to the transaction at exit.
+ */
+void
+xfs_swapext(
+	struct xfs_trans		*tp,
+	const struct xfs_swapext_req	*req)
+{
+	struct xfs_swapext_intent	*sxi;
+	unsigned int			reflink_state;
+
+	ASSERT(xfs_isilocked(req->ip1, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(req->ip2, XFS_ILOCK_EXCL));
+	ASSERT(req->whichfork != XFS_COW_FORK);
+	ASSERT(!(req->req_flags & ~XFS_SWAP_REQ_FLAGS));
+	if (req->req_flags & XFS_SWAP_REQ_SET_SIZES)
+		ASSERT(req->whichfork == XFS_DATA_FORK);
+
+	if (req->blockcount == 0)
+		return;
+
+	sxi = xfs_swapext_init_intent(req, &reflink_state);
+	xfs_swapext_schedule(tp, sxi);
+	xfs_swapext_ensure_reflink(tp, sxi, reflink_state);
+	xfs_swapext_upgrade_extent_counts(tp, sxi);
+}
diff --git a/libxfs/xfs_swapext.h b/libxfs/xfs_swapext.h
index 316323339d7..1987897ddc2 100644
--- a/libxfs/xfs_swapext.h
+++ b/libxfs/xfs_swapext.h
@@ -21,4 +21,146 @@ static inline bool xfs_swapext_supported(struct xfs_mount *mp)
 	       !xfs_has_realtime(mp);
 }
 
+/*
+ * In-core information about an extent swap request between ranges of two
+ * inodes.
+ */
+struct xfs_swapext_intent {
+	/* List of other incore deferred work. */
+	struct list_head	sxi_list;
+
+	/* Inodes participating in the operation. */
+	struct xfs_inode	*sxi_ip1;
+	struct xfs_inode	*sxi_ip2;
+
+	/* File offset range information. */
+	xfs_fileoff_t		sxi_startoff1;
+	xfs_fileoff_t		sxi_startoff2;
+	xfs_filblks_t		sxi_blockcount;
+
+	/* Set these file sizes after the operation, unless negative. */
+	xfs_fsize_t		sxi_isize1;
+	xfs_fsize_t		sxi_isize2;
+
+	/* XFS_SWAP_EXT_* log operation flags */
+	unsigned int		sxi_flags;
+
+	/* XFS_SWAP_EXT_OP_* flags */
+	unsigned int		sxi_op_flags;
+};
+
+/* Use log intent items to track and restart the entire operation. */
+#define XFS_SWAP_EXT_OP_LOGGED	(1U << 0)
+
+/* Upgrade files to have large extent counts before proceeding. */
+#define XFS_SWAP_EXT_OP_NREXT64	(1U << 1)
+
+#define XFS_SWAP_EXT_OP_STRINGS \
+	{ XFS_SWAP_EXT_OP_LOGGED,		"LOGGED" }, \
+	{ XFS_SWAP_EXT_OP_NREXT64,		"NREXT64" }
+
+static inline int
+xfs_swapext_whichfork(const struct xfs_swapext_intent *sxi)
+{
+	if (sxi->sxi_flags & XFS_SWAP_EXT_ATTR_FORK)
+		return XFS_ATTR_FORK;
+	return XFS_DATA_FORK;
+}
+
+/* Parameters for a swapext request. */
+struct xfs_swapext_req {
+	/* Inodes participating in the operation. */
+	struct xfs_inode	*ip1;
+	struct xfs_inode	*ip2;
+
+	/* File offset range information. */
+	xfs_fileoff_t		startoff1;
+	xfs_fileoff_t		startoff2;
+	xfs_filblks_t		blockcount;
+
+	/* Data or attr fork? */
+	int			whichfork;
+
+	/* XFS_SWAP_REQ_* operation flags */
+	unsigned int		req_flags;
+
+	/*
+	 * Fields below this line are filled out by xfs_swapext_estimate;
+	 * callers should initialize this part of the struct to zero.
+	 */
+
+	/*
+	 * Data device blocks to be moved out of ip1, and free space needed to
+	 * handle the bmbt changes.
+	 */
+	xfs_filblks_t		ip1_bcount;
+
+	/*
+	 * Data device blocks to be moved out of ip2, and free space needed to
+	 * handle the bmbt changes.
+	 */
+	xfs_filblks_t		ip2_bcount;
+
+	/* rt blocks to be moved out of ip1. */
+	xfs_filblks_t		ip1_rtbcount;
+
+	/* rt blocks to be moved out of ip2. */
+	xfs_filblks_t		ip2_rtbcount;
+
+	/* Free space needed to handle the bmbt changes */
+	unsigned long long	resblks;
+
+	/* Number of extent swaps needed to complete the operation */
+	unsigned long long	nr_exchanges;
+};
+
+/* Caller has permission to use log intent items for the swapext operation. */
+#define XFS_SWAP_REQ_LOGGED		(1U << 0)
+
+/* Set the file sizes when finished. */
+#define XFS_SWAP_REQ_SET_SIZES		(1U << 1)
+
+/* Do not swap any part of the range where ip1's mapping is a hole. */
+#define XFS_SWAP_REQ_SKIP_INO1_HOLES	(1U << 2)
+
+/* Files need to be upgraded to have large extent counts. */
+#define XFS_SWAP_REQ_NREXT64		(1U << 3)
+
+#define XFS_SWAP_REQ_FLAGS		(XFS_SWAP_REQ_LOGGED | \
+					 XFS_SWAP_REQ_SET_SIZES | \
+					 XFS_SWAP_REQ_SKIP_INO1_HOLES | \
+					 XFS_SWAP_REQ_NREXT64)
+
+#define XFS_SWAP_REQ_STRINGS \
+	{ XFS_SWAP_REQ_LOGGED,			"LOGGED" }, \
+	{ XFS_SWAP_REQ_SET_SIZES,		"SETSIZES" }, \
+	{ XFS_SWAP_REQ_SKIP_INO1_HOLES,		"SKIP_INO1_HOLES" }, \
+	{ XFS_SWAP_REQ_NREXT64,			"NREXT64" }
+
+unsigned int xfs_swapext_reflink_prep(const struct xfs_swapext_req *req);
+void xfs_swapext_reflink_finish(struct xfs_trans *tp,
+		const struct xfs_swapext_req *req, unsigned int reflink_state);
+
+int xfs_swapext_estimate(struct xfs_swapext_req *req);
+
+extern struct kmem_cache	*xfs_swapext_intent_cache;
+
+int __init xfs_swapext_intent_init_cache(void);
+void xfs_swapext_intent_destroy_cache(void);
+
+struct xfs_swapext_intent *xfs_swapext_init_intent(
+		const struct xfs_swapext_req *req, unsigned int *reflink_state);
+void xfs_swapext_ensure_reflink(struct xfs_trans *tp,
+		const struct xfs_swapext_intent *sxi, unsigned int reflink_state);
+
+void xfs_swapext_schedule(struct xfs_trans *tp,
+		struct xfs_swapext_intent *sxi);
+int xfs_swapext_finish_one(struct xfs_trans *tp,
+		struct xfs_swapext_intent *sxi);
+
+int xfs_swapext_check_extents(struct xfs_mount *mp,
+		const struct xfs_swapext_req *req);
+
+void xfs_swapext(struct xfs_trans *tp, const struct xfs_swapext_req *req);
+
 #endif /* __XFS_SWAPEXT_H_ */
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 87b31c69a77..9640fc232c1 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -10,6 +10,10 @@
  * Components of space reservations.
  */
 
+/* Worst case number of bmaps that can be held in a block. */
+#define XFS_MAX_CONTIG_BMAPS_PER_BLOCK(mp)    \
+		(((mp)->m_bmap_dmxr[0]) - ((mp)->m_bmap_dmnr[0]))
+
 /* Worst case number of rmaps that can be held in a block. */
 #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))

