Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC36BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McFZukIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463C5C433C9;
	Sun, 31 Dec 2023 20:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054411;
	bh=NaxEBZTdpNw20Bvwlo1D95722mzs7rhGiSUPpsCOoXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=McFZukISn19QcUxUHysHIDJwU/UT6uXBKwZYeXKc0fI1Ay4gDdnuZIzF6UjrqBHf4
	 yJiawJJ0n6S15NWPzIV1S+SafcZBTr/7eJZRamwDSDWifqalkZXJQirPu60VklrT9v
	 c/EzX/OfTxoW1/bRNFkTXXtHPekTjhEriM01Z2cm9019rk1n2up9IcmSfkoSz8lr1x
	 4YcU7omWP5IZiEanoSKDlDd4ZcERh3aBDqJJ1piTHY5vssFgHLQobO+xXbk95Aj6eB
	 KnQcBji37SHJ/CzUfRZ3Y3SEpDpkxFeKwwApibaFRQ4Dlu+SFbA7r94OkOirv+pQpO
	 r3i8AWTIFvQSQ==
Date: Sun, 31 Dec 2023 12:26:50 -0800
Subject: [PATCH 10/25] xfs: introduce a swap-extent log intent item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833299.1750288.783956917631042006.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

Introduce a new intent log item to handle swapping extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_log_format.h  |   51 ++++++++
 fs/xfs/libxfs/xfs_log_recover.h |    2 
 fs/xfs/xfs_log_recover.c        |    2 
 fs/xfs/xfs_super.c              |   19 +++
 fs/xfs/xfs_swapext_item.c       |  236 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_swapext_item.h       |   56 +++++++++
 7 files changed, 364 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_swapext_item.c
 create mode 100644 fs/xfs/xfs_swapext_item.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d0b538c11faaf..95f9b32d947c4 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -111,6 +111,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_iunlink_item.o \
 				   xfs_refcount_item.o \
 				   xfs_rmap_item.o \
+				   xfs_swapext_item.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
 				   xfs_trans_buf.o
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 16872972e1e97..24c3d5dc36182 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,8 +117,9 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
-
+#define XLOG_REG_TYPE_SXI_FORMAT	31
+#define XLOG_REG_TYPE_SXD_FORMAT	32
+#define XLOG_REG_TYPE_MAX		32
 
 /*
  * Flags to log operation header
@@ -243,6 +244,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_BUD		0x1245
 #define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
 #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
+#define	XFS_LI_SXI		0x1248  /* extent swap intent */
+#define	XFS_LI_SXD		0x1249  /* extent swap done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -260,7 +263,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
 	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
 	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
-	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
+	{ XFS_LI_SXI,		"XFS_LI_SXI" }, \
+	{ XFS_LI_SXD,		"XFS_LI_SXD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -878,6 +883,46 @@ struct xfs_bud_log_format {
 	uint64_t		bud_bui_id;	/* id of corresponding bui */
 };
 
+/*
+ * SXI/SXD (extent swapping) log format definitions
+ */
+
+struct xfs_swap_extent {
+	uint64_t		sx_inode1;
+	uint64_t		sx_inode2;
+	uint64_t		sx_startoff1;
+	uint64_t		sx_startoff2;
+	uint64_t		sx_blockcount;
+	uint64_t		sx_flags;
+	int64_t			sx_isize1;
+	int64_t			sx_isize2;
+};
+
+#define XFS_SWAP_EXT_FLAGS		(0)
+
+#define XFS_SWAP_EXT_STRINGS
+
+/* This is the structure used to lay out an sxi log item in the log. */
+struct xfs_sxi_log_format {
+	uint16_t		sxi_type;	/* sxi log item type */
+	uint16_t		sxi_size;	/* size of this item */
+	uint32_t		__pad;		/* must be zero */
+	uint64_t		sxi_id;		/* sxi identifier */
+	struct xfs_swap_extent	sxi_extent;	/* extent to swap */
+};
+
+/*
+ * This is the structure used to lay out an sxd log item in the
+ * log.  The sxd_extents array is a variable size array whose
+ * size is given by sxd_nextents;
+ */
+struct xfs_sxd_log_format {
+	uint16_t		sxd_type;	/* sxd log item type */
+	uint16_t		sxd_size;	/* size of this item */
+	uint32_t		__pad;
+	uint64_t		sxd_sxi_id;	/* id of corresponding bui */
+};
+
 /*
  * Dquot Log format definitions.
  *
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 9fe7a9564bca9..891221b0b83aa 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -75,6 +75,8 @@ extern const struct xlog_recover_item_ops xlog_cui_item_ops;
 extern const struct xlog_recover_item_ops xlog_cud_item_ops;
 extern const struct xlog_recover_item_ops xlog_attri_item_ops;
 extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
+extern const struct xlog_recover_item_ops xlog_sxi_item_ops;
+extern const struct xlog_recover_item_ops xlog_sxd_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6048f1b08acc0..628d7915120b0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1790,6 +1790,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_bud_item_ops,
 	&xlog_attri_item_ops,
 	&xlog_attrd_item_ops,
+	&xlog_sxi_item_ops,
+	&xlog_sxd_item_ops,
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d535445129752..e6e8e8fb17a19 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -43,6 +43,7 @@
 #include "xfs_iunlink_item.h"
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_swapext_item.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -2196,8 +2197,24 @@ xfs_init_caches(void)
 	if (!xfs_iunlink_cache)
 		goto out_destroy_attri_cache;
 
+	xfs_sxd_cache = kmem_cache_create("xfs_sxd_item",
+					 sizeof(struct xfs_sxd_log_item),
+					 0, 0, NULL);
+	if (!xfs_sxd_cache)
+		goto out_destroy_iul_cache;
+
+	xfs_sxi_cache = kmem_cache_create("xfs_sxi_item",
+					 sizeof(struct xfs_sxi_log_item),
+					 0, 0, NULL);
+	if (!xfs_sxi_cache)
+		goto out_destroy_sxd_cache;
+
 	return 0;
 
+ out_destroy_sxd_cache:
+	kmem_cache_destroy(xfs_sxd_cache);
+ out_destroy_iul_cache:
+	kmem_cache_destroy(xfs_iunlink_cache);
  out_destroy_attri_cache:
 	kmem_cache_destroy(xfs_attri_cache);
  out_destroy_attrd_cache:
@@ -2254,6 +2271,8 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_sxd_cache);
+	kmem_cache_destroy(xfs_sxi_cache);
 	kmem_cache_destroy(xfs_iunlink_cache);
 	kmem_cache_destroy(xfs_attri_cache);
 	kmem_cache_destroy(xfs_attrd_cache);
diff --git a/fs/xfs/xfs_swapext_item.c b/fs/xfs/xfs_swapext_item.c
new file mode 100644
index 0000000000000..0117735913cf1
--- /dev/null
+++ b/fs/xfs/xfs_swapext_item.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_swapext_item.h"
+#include "xfs_log.h"
+#include "xfs_bmap.h"
+#include "xfs_icache.h"
+#include "xfs_trans_space.h"
+#include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+
+struct kmem_cache	*xfs_sxi_cache;
+struct kmem_cache	*xfs_sxd_cache;
+
+static const struct xfs_item_ops xfs_sxi_item_ops;
+
+static inline struct xfs_sxi_log_item *SXI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_sxi_log_item, sxi_item);
+}
+
+STATIC void
+xfs_sxi_item_free(
+	struct xfs_sxi_log_item	*sxi_lip)
+{
+	kmem_free(sxi_lip->sxi_item.li_lv_shadow);
+	kmem_cache_free(xfs_sxi_cache, sxi_lip);
+}
+
+/*
+ * Freeing the SXI requires that we remove it from the AIL if it has already
+ * been placed there. However, the SXI may not yet have been placed in the AIL
+ * when called by xfs_sxi_release() from SXD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the SXI.
+ */
+STATIC void
+xfs_sxi_release(
+	struct xfs_sxi_log_item	*sxi_lip)
+{
+	ASSERT(atomic_read(&sxi_lip->sxi_refcount) > 0);
+	if (atomic_dec_and_test(&sxi_lip->sxi_refcount)) {
+		xfs_trans_ail_delete(&sxi_lip->sxi_item, 0);
+		xfs_sxi_item_free(sxi_lip);
+	}
+}
+
+
+STATIC void
+xfs_sxi_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_sxi_log_format);
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the given sxi log
+ * item. We use only 1 iovec, and we point that at the sxi_log_format structure
+ * embedded in the sxi item.
+ */
+STATIC void
+xfs_sxi_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_sxi_log_item	*sxi_lip = SXI_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	sxi_lip->sxi_format.sxi_type = XFS_LI_SXI;
+	sxi_lip->sxi_format.sxi_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_SXI_FORMAT,
+			&sxi_lip->sxi_format,
+			sizeof(struct xfs_sxi_log_format));
+}
+
+/*
+ * The unpin operation is the last place an SXI is manipulated in the log. It
+ * is either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the SXI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the SXI to either construct
+ * and commit the SXD or drop the SXD's reference in the event of error. Simply
+ * drop the log's SXI reference now that the log is done with it.
+ */
+STATIC void
+xfs_sxi_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_sxi_log_item	*sxi_lip = SXI_ITEM(lip);
+
+	xfs_sxi_release(sxi_lip);
+}
+
+/*
+ * The SXI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an SXD isn't going to be
+ * constructed and thus we free the SXI here directly.
+ */
+STATIC void
+xfs_sxi_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_sxi_release(SXI_ITEM(lip));
+}
+
+/* Allocate and initialize an sxi item with the given number of extents. */
+STATIC struct xfs_sxi_log_item *
+xfs_sxi_init(
+	struct xfs_mount	*mp)
+
+{
+	struct xfs_sxi_log_item	*sxi_lip;
+
+	sxi_lip = kmem_cache_zalloc(xfs_sxi_cache, GFP_KERNEL | __GFP_NOFAIL);
+
+	xfs_log_item_init(mp, &sxi_lip->sxi_item, XFS_LI_SXI, &xfs_sxi_item_ops);
+	sxi_lip->sxi_format.sxi_id = (uintptr_t)(void *)sxi_lip;
+	atomic_set(&sxi_lip->sxi_refcount, 2);
+
+	return sxi_lip;
+}
+
+static inline struct xfs_sxd_log_item *SXD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_sxd_log_item, sxd_item);
+}
+
+STATIC bool
+xfs_sxi_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return SXI_ITEM(lip)->sxi_format.sxi_id == intent_id;
+}
+
+static const struct xfs_item_ops xfs_sxi_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
+	.iop_size	= xfs_sxi_item_size,
+	.iop_format	= xfs_sxi_item_format,
+	.iop_unpin	= xfs_sxi_item_unpin,
+	.iop_release	= xfs_sxi_item_release,
+	.iop_match	= xfs_sxi_item_match,
+};
+
+/*
+ * This routine is called to create an in-core extent swapext update item from
+ * the sxi format structure which was logged on disk.  It allocates an in-core
+ * sxi, copies the extents from the format structure into it, and adds the sxi
+ * to the AIL with the given LSN.
+ */
+STATIC int
+xlog_recover_sxi_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_sxi_log_item		*sxi_lip;
+	struct xfs_sxi_log_format	*sxi_formatp;
+	size_t				len;
+
+	sxi_formatp = item->ri_buf[0].i_addr;
+
+	if (sxi_formatp->__pad != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	len = sizeof(struct xfs_sxi_log_format);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	sxi_lip = xfs_sxi_init(mp);
+	memcpy(&sxi_lip->sxi_format, sxi_formatp, len);
+
+	/* not implemented yet */
+	return -EIO;
+}
+
+const struct xlog_recover_item_ops xlog_sxi_item_ops = {
+	.item_type		= XFS_LI_SXI,
+	.commit_pass2		= xlog_recover_sxi_commit_pass2,
+};
+
+/*
+ * This routine is called when an SXD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding SXI if it
+ * was still in the log. To do this it searches the AIL for the SXI with an id
+ * equal to that in the SXD format structure. If we find it we drop the SXD
+ * reference, which removes the SXI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_sxd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_sxd_log_format	*sxd_formatp;
+
+	sxd_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_sxd_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_SXI, sxd_formatp->sxd_sxi_id);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_sxd_item_ops = {
+	.item_type		= XFS_LI_SXD,
+	.commit_pass2		= xlog_recover_sxd_commit_pass2,
+};
diff --git a/fs/xfs/xfs_swapext_item.h b/fs/xfs/xfs_swapext_item.h
new file mode 100644
index 0000000000000..d816ab842a603
--- /dev/null
+++ b/fs/xfs/xfs_swapext_item.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef	__XFS_SWAPEXT_ITEM_H__
+#define	__XFS_SWAPEXT_ITEM_H__
+
+/*
+ * The extent swapping intent item help us perform atomic extent swaps between
+ * two inode forks.  It does this by tracking the range of logical offsets that
+ * still need to be swapped, and relogs as progress happens.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated bmbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * rest of the extent swaps.
+ */
+
+/* kernel only SXI/SXD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * This is the "swapext update intent" log item.  It is used to log the fact
+ * that we are swapping extents between two files.  It is used in conjunction
+ * with the "swapext update done" log item described below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_sxi_log_item {
+	struct xfs_log_item		sxi_item;
+	atomic_t			sxi_refcount;
+	struct xfs_sxi_log_format	sxi_format;
+};
+
+/*
+ * This is the "swapext update done" log item.  It is used to log the fact that
+ * some extent swapping mentioned in an earlier sxi item have been performed.
+ */
+struct xfs_sxd_log_item {
+	struct xfs_log_item		sxd_item;
+	struct xfs_sxi_log_item		*sxd_intent_log_item;
+	struct xfs_sxd_log_format	sxd_format;
+};
+
+extern struct kmem_cache	*xfs_sxi_cache;
+extern struct kmem_cache	*xfs_sxd_cache;
+
+#endif	/* __XFS_SWAPEXT_ITEM_H__ */

