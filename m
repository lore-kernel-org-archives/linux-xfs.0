Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E159BC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGHtX/XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A772C433C7;
	Sun, 31 Dec 2023 22:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061717;
	bh=OXyEpz0e6IodfgWQq1TpeCc0K2jQ0X9BfftbGtSikMQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FGHtX/XEJgOD1xPUOr5pDhBm84ehGql9PEHoPzfdOq/sVp150T9K5nWCn5yU+YFqS
	 i6KhbqB/b5AQ1F3sV4KajOusuXik330488Jnhb+cfJz6KPA96ZrCNPro3q7n46mMVl
	 91Xvcz04yevvh0ay+0dTl3XWKWO7ZR5Zrjv9oy0kFJlGmB4o4kNUgFpfOdbC+AVmEJ
	 EiFiLKIT3ppXWAKnaff8xJAugWj/b+0ozNm0tbLDsRkTN+rgiEIUe7QtdngvEeR8Id
	 j7CbrmRZKLDmR06CXs7FrjWMzZcTXUtBRlYaxrNJCJzrJiilL6hPjWP/YjaHItF9FO
	 QYeO2CXlfu6bw==
Date: Sun, 31 Dec 2023 14:28:36 -0800
Subject: [PATCH 06/20] xfs: create deferred log items for extent swapping
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996354.1796128.1659527344636167484.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've created the skeleton of a log intent item to track and
restart extent swap operations, add the upper level logic to commit
intent items and turn them into concrete work recorded in the log.  We
use the deferred item "multihop" feature that was introduced a few
patches ago to constrain the number of active swap operations to one per
thread.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h      |   14 +
 libxfs/Makefile          |    2 
 libxfs/defer_item.c      |   91 ++++
 libxfs/defer_item.h      |    4 
 libxfs/libxfs_priv.h     |   30 +
 libxfs/xfs_bmap.h        |    2 
 libxfs/xfs_defer.c       |    6 
 libxfs/xfs_defer.h       |    2 
 libxfs/xfs_format.h      |    6 
 libxfs/xfs_log_format.h  |   31 +
 libxfs/xfs_swapext.c     | 1028 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_swapext.h     |  143 ++++++
 libxfs/xfs_trans_space.h |    4 
 13 files changed, 1359 insertions(+), 4 deletions(-)
 create mode 100644 libxfs/xfs_swapext.c


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 57661f36d7c..a8f3ecac7f6 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -329,6 +329,9 @@
 #define trace_xfs_refcount_cow_decrease(...)	((void) 0)
 #define trace_xfs_refcount_recover_extent(...)	((void) 0)
 
+#define trace_xfs_reflink_set_inode_flag(...)	((void) 0)
+#define trace_xfs_reflink_unset_inode_flag(...)	((void) 0)
+
 #define trace_xfs_rmap_find_left_neighbor_candidate(...)	((void) 0)
 #define trace_xfs_rmap_find_left_neighbor_query(...)	((void) 0)
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
@@ -342,6 +345,17 @@
 #define trace_xfs_rmap_map_error(...)		((void) 0)
 #define trace_xfs_rmap_delete_error(...)	((void) 0)
 
+#define trace_xfs_swapext_defer(...)		((void) 0)
+#define trace_xfs_swapext_delta_nextents(...)	((void) 0)
+#define trace_xfs_swapext_delta_nextents_step(...)	((void) 0)
+#define trace_xfs_swapext_extent1_skip(...)	((void) 0)
+#define trace_xfs_swapext_extent1(...)		((void) 0)
+#define trace_xfs_swapext_extent2(...)		((void) 0)
+#define trace_xfs_swapext_final_estimate(...)	((void) 0)
+#define trace_xfs_swapext_initial_estimate(...)	((void) 0)
+#define trace_xfs_swapext_overhead(...)		((void) 0)
+#define trace_xfs_swapext_update_inode_size(...) ((void) 0)
+
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
 #define trace_xlog_intent_recovery_failed(...)	((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index ed22f5c873e..0fb8f7b39bc 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -58,6 +58,7 @@ HFILES = \
 	xfs_rtbitmap.h \
 	xfs_sb.h \
 	xfs_shared.h \
+	xfs_swapext.h \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
 	xfs_dir2_priv.h
@@ -106,6 +107,7 @@ CFILES = cache.c \
 	xfs_rmap_btree.c \
 	xfs_rtbitmap.c \
 	xfs_sb.c \
+	xfs_swapext.c \
 	xfs_symlink_remote.c \
 	xfs_trans_inode.c \
 	xfs_trans_resv.c \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index e7d64be014d..49e6cf02dc8 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -25,6 +25,8 @@
 #include "xfs_attr.h"
 #include "libxfs.h"
 #include "defer_item.h"
+#include "xfs_ag.h"
+#include "xfs_swapext.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -677,3 +679,92 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
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
+/* Add this deferred SXI to the transaction. */
+void
+xfs_swapext_defer_add(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	trace_xfs_swapext_defer(tp->t_mountp, sxi);
+
+	xfs_defer_add(tp, &sxi->sxi_list, &xfs_swapext_defer_type);
+}
+
+static inline struct xfs_swapext_intent *sxi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_swapext_intent, sxi_list);
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
+	struct xfs_swapext_intent	*sxi = sxi_entry(item);
+	int				error;
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
+	if (error != -EAGAIN)
+		kmem_cache_free(xfs_swapext_intent_cache, sxi);
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
+	struct xfs_swapext_intent	*sxi = sxi_entry(item);
+
+	kmem_cache_free(xfs_swapext_intent_cache, sxi);
+}
+
+const struct xfs_defer_op_type xfs_swapext_defer_type = {
+	.name		= "swapext",
+	.create_intent	= xfs_swapext_create_intent,
+	.abort_intent	= xfs_swapext_abort_intent,
+	.create_done	= xfs_swapext_create_done,
+	.finish_item	= xfs_swapext_finish_item,
+	.cancel_item	= xfs_swapext_cancel_item,
+};
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index 6d3abf1589c..a3ef9e079d0 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -10,4 +10,8 @@ struct xfs_bmap_intent;
 
 void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 
+struct xfs_swapext_intent;
+
+void xfs_swapext_defer_add(struct xfs_trans *tp, struct xfs_swapext_intent *sxi);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4d9c49091bc..ef29d7e5eb7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -220,6 +220,35 @@ static inline bool WARN_ON(bool expr) {
 	(inode)->i_version = (version);	\
 } while (0)
 
+#define __must_check	__attribute__((__warn_unused_result__))
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
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #define max_t(type,x,y) \
@@ -535,6 +564,7 @@ void xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *lip, int type,
 #define xfs_log_in_recovery(mp)		(false)
 
 /* xfs_icache.c */
+#define xfs_inode_clear_cowblocks_tag(ip)	do { } while (0)
 #define xfs_inode_set_cowblocks_tag(ip)	do { } while (0)
 #define xfs_inode_set_eofblocks_tag(ip)	do { } while (0)
 
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 1eee606f392..ccd1ddcd785 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -156,7 +156,7 @@ static inline bool xfs_bmap_is_real_extent(const struct xfs_bmbt_irec *irec)
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(const struct xfs_bmbt_irec *irec)
 {
 	return xfs_bmap_is_real_extent(irec) &&
 	       irec->br_state != XFS_EXT_UNWRITTEN;
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 077e9929807..7782eea458e 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -21,6 +21,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
+#include "xfs_swapext.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -1174,6 +1175,10 @@ xfs_defer_init_item_caches(void)
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
@@ -1184,6 +1189,7 @@ xfs_defer_init_item_caches(void)
 void
 xfs_defer_destroy_item_caches(void)
 {
+	xfs_swapext_intent_destroy_cache();
 	xfs_attr_intent_destroy_cache();
 	xfs_extfree_intent_destroy_cache();
 	xfs_bmap_intent_destroy_cache();
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 18a9fb92dde..e3cf81bafca 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -72,7 +72,7 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 extern const struct xfs_defer_op_type xfs_attr_defer_type;
-
+extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 
 /*
  * Deferred operation item relogging limits.
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index c0209bd21db..8b34754a579 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -430,6 +430,12 @@ static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
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
index 24c3d5dc361..3341792cf43 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -898,9 +898,36 @@ struct xfs_swap_extent {
 	int64_t			sx_isize2;
 };
 
-#define XFS_SWAP_EXT_FLAGS		(0)
+/* Swap extents between extended attribute forks. */
+#define XFS_SWAP_EXT_ATTR_FORK		(1ULL << 0)
 
-#define XFS_SWAP_EXT_STRINGS
+/* Set the file sizes when finished. */
+#define XFS_SWAP_EXT_SET_SIZES		(1ULL << 1)
+
+/*
+ * Swap only the extents of the two files where the file allocation units
+ * mapped to file1's range have been written to.
+ */
+#define XFS_SWAP_EXT_INO1_WRITTEN	(1ULL << 2)
+
+/* Clear the reflink flag from inode1 after the operation. */
+#define XFS_SWAP_EXT_CLEAR_INO1_REFLINK	(1ULL << 3)
+
+/* Clear the reflink flag from inode2 after the operation. */
+#define XFS_SWAP_EXT_CLEAR_INO2_REFLINK	(1ULL << 4)
+
+#define XFS_SWAP_EXT_FLAGS		(XFS_SWAP_EXT_ATTR_FORK | \
+					 XFS_SWAP_EXT_SET_SIZES | \
+					 XFS_SWAP_EXT_INO1_WRITTEN | \
+					 XFS_SWAP_EXT_CLEAR_INO1_REFLINK | \
+					 XFS_SWAP_EXT_CLEAR_INO2_REFLINK)
+
+#define XFS_SWAP_EXT_STRINGS \
+	{ XFS_SWAP_EXT_ATTR_FORK,		"ATTRFORK" }, \
+	{ XFS_SWAP_EXT_SET_SIZES,		"SETSIZES" }, \
+	{ XFS_SWAP_EXT_INO1_WRITTEN,		"INO1_WRITTEN" }, \
+	{ XFS_SWAP_EXT_CLEAR_INO1_REFLINK,	"CLEAR_INO1_REFLINK" }, \
+	{ XFS_SWAP_EXT_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }
 
 /* This is the structure used to lay out an sxi log item in the log. */
 struct xfs_sxi_log_format {
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
new file mode 100644
index 00000000000..2462657c1f4
--- /dev/null
+++ b/libxfs/xfs_swapext.c
@@ -0,0 +1,1028 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
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
+#include "defer_item.h"
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
+/* Decide if we want to skip this mapping from file1. */
+static inline bool
+xfs_swapext_can_skip_mapping(
+	struct xfs_swapext_intent	*sxi,
+	struct xfs_bmbt_irec		*irec)
+{
+	/* Do not skip this mapping if the caller did not tell us to. */
+	if (!(sxi->sxi_flags & XFS_SWAP_EXT_INO1_WRITTEN))
+		return false;
+
+	/* Do not skip mapped, written extents. */
+	if (xfs_bmap_is_written_extent(irec))
+		return false;
+
+	/*
+	 * The mapping is unwritten or a hole.  It cannot be a delalloc
+	 * reservation because we already excluded those.  It cannot be an
+	 * unwritten extent with dirty page cache because we flushed the page
+	 * cache.  We don't support realtime files yet, so we needn't (yet)
+	 * deal with them.
+	 */
+	return true;
+}
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
+		if (xfs_swapext_can_skip_mapping(sxi, irec1)) {
+			trace_xfs_swapext_extent1_skip(sxi->sxi_ip1, irec1);
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
+	if (req->req_flags & XFS_SWAP_REQ_INO1_WRITTEN)
+		sxi->sxi_flags |= XFS_SWAP_EXT_INO1_WRITTEN;
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
+	xfs_swapext_defer_add(tp, sxi);
+	xfs_swapext_ensure_reflink(tp, sxi, reflink_state);
+	xfs_swapext_upgrade_extent_counts(tp, sxi);
+}
diff --git a/libxfs/xfs_swapext.h b/libxfs/xfs_swapext.h
index 01bb3271f64..fa786bc9352 100644
--- a/libxfs/xfs_swapext.h
+++ b/libxfs/xfs_swapext.h
@@ -72,4 +72,147 @@ xfs_atomic_swap_supported(
 	return false;
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
+/*
+ * Swap only the parts of the two files where the file allocation units
+ * mapped to file1's range have been written to.
+ */
+#define XFS_SWAP_REQ_INO1_WRITTEN	(1U << 2)
+
+/* Files need to be upgraded to have large extent counts. */
+#define XFS_SWAP_REQ_NREXT64		(1U << 3)
+
+#define XFS_SWAP_REQ_FLAGS		(XFS_SWAP_REQ_LOGGED | \
+					 XFS_SWAP_REQ_SET_SIZES | \
+					 XFS_SWAP_REQ_INO1_WRITTEN | \
+					 XFS_SWAP_REQ_NREXT64)
+
+#define XFS_SWAP_REQ_STRINGS \
+	{ XFS_SWAP_REQ_LOGGED,		"LOGGED" }, \
+	{ XFS_SWAP_REQ_SET_SIZES,	"SETSIZES" }, \
+	{ XFS_SWAP_REQ_INO1_WRITTEN,	"INO1_WRITTEN" }, \
+	{ XFS_SWAP_REQ_NREXT64,		"NREXT64" }
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

