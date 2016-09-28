Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16684 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756059AbcI1Cyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:54:44 -0400
Subject: [PATCH 11/63] xfs: log refcount intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:54:40 -0700
Message-ID: <147503128015.30303.2237183364098745952.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Provide a mechanism for higher levels to create CUI/CUD items, submit
them to the log, and a stub function to deal with recovered CUI items.
These parts will be connected to the refcountbt in a later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_log_format.h |    3 +
 fs/xfs/libxfs/xfs_refcount.h   |   15 ++++
 fs/xfs/xfs_log_recover.c       |  152 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_refcount_item.c     |   58 +++++++++++++++
 fs/xfs/xfs_refcount_item.h     |    1 
 fs/xfs/xfs_trace.h             |   30 ++++++++
 fs/xfs/xfs_trans.h             |   11 +++
 fs/xfs/xfs_trans_refcount.c    |   99 ++++++++++++++++++++++++++
 9 files changed, 370 insertions(+)
 create mode 100644 fs/xfs/xfs_trans_refcount.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d6429fd..6a9ea9e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -113,6 +113,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
+				   xfs_trans_refcount.o \
 				   xfs_trans_rmap.o \
 
 # optional features
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 03e8fea..2428944 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -686,12 +686,15 @@ struct xfs_phys_extent {
 };
 
 /* refcount pe_flags: upper bits are flags, lower byte is type code */
+/* Type codes must correspond to enum xfs_refcount_intent_type. */
 #define XFS_REFCOUNT_EXTENT_INCREASE	1
 #define XFS_REFCOUNT_EXTENT_DECREASE	2
 #define XFS_REFCOUNT_EXTENT_ALLOC_COW	3
 #define XFS_REFCOUNT_EXTENT_FREE_COW	4
 #define XFS_REFCOUNT_EXTENT_TYPE_MASK	0xFF
 
+#define XFS_REFCOUNT_EXTENT_FLAGS	(XFS_REFCOUNT_EXTENT_TYPE_MASK)
+
 /*
  * This is the structure used to lay out a cui log item in the
  * log.  The cui_extents field is a variable size array whose
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 4dc335a..d362f0b 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -27,4 +27,19 @@ extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
+/* The XFS_REFCOUNT_EXTENT_* in xfs_log_format.h must match these. */
+enum xfs_refcount_intent_type {
+	XFS_REFCOUNT_INCREASE = 1,
+	XFS_REFCOUNT_DECREASE,
+	XFS_REFCOUNT_ALLOC_COW,
+	XFS_REFCOUNT_FREE_COW,
+};
+
+struct xfs_refcount_intent {
+	struct list_head			ri_list;
+	enum xfs_refcount_intent_type		ri_type;
+	xfs_fsblock_t				ri_startblock;
+	xfs_extlen_t				ri_blockcount;
+};
+
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 846483d..f6abc60 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -45,6 +45,7 @@
 #include "xfs_dir2.h"
 #include "xfs_rmap_item.h"
 #include "xfs_buf_item.h"
+#include "xfs_refcount_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -1924,6 +1925,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_EFI:
 		case XFS_LI_RUI:
 		case XFS_LI_RUD:
+		case XFS_LI_CUI:
+		case XFS_LI_CUD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
@@ -3547,6 +3550,100 @@ xlog_recover_rud_pass2(
 }
 
 /*
+ * This routine is called to create an in-core extent refcount update
+ * item from the cui format structure which was logged on disk.
+ * It allocates an in-core cui, copies the extents from the format
+ * structure into it, and adds the cui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_cui_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_cui_log_format	*cui_formatp;
+
+	cui_formatp = item->ri_buf[0].i_addr;
+
+	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
+	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
+	if (error) {
+		xfs_cui_item_free(cuip);
+		return error;
+	}
+	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+
+	spin_lock(&log->l_ailp->xa_lock);
+	/*
+	 * The CUI has two references. One for the CUD and one for CUI to ensure
+	 * it makes it into the AIL. Insert the CUI into the AIL directly and
+	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
+	xfs_cui_release(cuip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an CUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding CUI if it
+ * was still in the log. To do this it searches the AIL for the CUI with an id
+ * equal to that in the CUD format structure. If we find it we drop the CUD
+ * reference, which removes the CUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_cud_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_cud_log_format	*cud_formatp;
+	struct xfs_cui_log_item		*cuip = NULL;
+	struct xfs_log_item		*lip;
+	__uint64_t			cui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	cud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format))
+		return -EFSCORRUPTED;
+	cui_id = cud_formatp->cud_cui_id;
+
+	/*
+	 * Search for the CUI with the id in the CUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_CUI) {
+			cuip = (struct xfs_cui_log_item *)lip;
+			if (cuip->cui_format.cui_id == cui_id) {
+				/*
+				 * Drop the CUD reference to the CUI. This
+				 * removes the CUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->xa_lock);
+				xfs_cui_release(cuip);
+				spin_lock(&ailp->xa_lock);
+				break;
+			}
+		}
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->xa_lock);
+
+	return 0;
+}
+
+/*
  * This routine is called when an inode create format structure is found in a
  * committed transaction in the log.  It's purpose is to initialise the inodes
  * being allocated on disk. This requires us to get inode cluster buffers that
@@ -3773,6 +3870,8 @@ xlog_recover_ra_pass2(
 	case XFS_LI_QUOTAOFF:
 	case XFS_LI_RUI:
 	case XFS_LI_RUD:
+	case XFS_LI_CUI:
+	case XFS_LI_CUD:
 	default:
 		break;
 	}
@@ -3798,6 +3897,8 @@ xlog_recover_commit_pass1(
 	case XFS_LI_ICREATE:
 	case XFS_LI_RUI:
 	case XFS_LI_RUD:
+	case XFS_LI_CUI:
+	case XFS_LI_CUD:
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
@@ -3832,6 +3933,10 @@ xlog_recover_commit_pass2(
 		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_RUD:
 		return xlog_recover_rud_pass2(log, item);
+	case XFS_LI_CUI:
+		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
+	case XFS_LI_CUD:
+		return xlog_recover_cud_pass2(log, item);
 	case XFS_LI_DQUOT:
 		return xlog_recover_dquot_pass2(log, buffer_list, item,
 						trans->r_lsn);
@@ -4419,12 +4524,53 @@ xlog_recover_cancel_rui(
 	spin_lock(&ailp->xa_lock);
 }
 
+/* Recover the CUI if necessary. */
+STATIC int
+xlog_recover_process_cui(
+	struct xfs_mount		*mp,
+	struct xfs_ail			*ailp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_cui_log_item		*cuip;
+	int				error;
+
+	/*
+	 * Skip CUIs that we've already processed.
+	 */
+	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
+	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
+		return 0;
+
+	spin_unlock(&ailp->xa_lock);
+	error = xfs_cui_recover(mp, cuip);
+	spin_lock(&ailp->xa_lock);
+
+	return error;
+}
+
+/* Release the CUI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_cui(
+	struct xfs_mount		*mp,
+	struct xfs_ail			*ailp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_cui_log_item		*cuip;
+
+	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
+
+	spin_unlock(&ailp->xa_lock);
+	xfs_cui_release(cuip);
+	spin_lock(&ailp->xa_lock);
+}
+
 /* Is this log item a deferred action intent? */
 static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 {
 	switch (lip->li_type) {
 	case XFS_LI_EFI:
 	case XFS_LI_RUI:
+	case XFS_LI_CUI:
 		return true;
 	default:
 		return false;
@@ -4488,6 +4634,9 @@ xlog_recover_process_intents(
 		case XFS_LI_RUI:
 			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_CUI:
+			error = xlog_recover_process_cui(log->l_mp, ailp, lip);
+			break;
 		}
 		if (error)
 			goto out;
@@ -4535,6 +4684,9 @@ xlog_recover_cancel_intents(
 		case XFS_LI_RUI:
 			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_CUI:
+			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
+			break;
 		}
 
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ac52b02..480fb5f 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -22,6 +22,7 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
@@ -404,3 +405,60 @@ xfs_cud_init(
 
 	return cudp;
 }
+
+/*
+ * Process a refcount update intent item that was recovered from the log.
+ * We need to update the refcountbt.
+ */
+int
+xfs_cui_recover(
+	struct xfs_mount		*mp,
+	struct xfs_cui_log_item		*cuip)
+{
+	int				i;
+	int				error = 0;
+	struct xfs_phys_extent		*refc;
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
+
+	/*
+	 * First check the validity of the extents described by the
+	 * CUI.  If any are bad, then assume that all are bad and
+	 * just toss the CUI.
+	 */
+	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
+		refc = &cuip->cui_format.cui_extents[i];
+		startblock_fsb = XFS_BB_TO_FSB(mp,
+				   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
+		switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+		case XFS_REFCOUNT_EXTENT_INCREASE:
+		case XFS_REFCOUNT_EXTENT_DECREASE:
+		case XFS_REFCOUNT_EXTENT_ALLOC_COW:
+		case XFS_REFCOUNT_EXTENT_FREE_COW:
+			op_ok = true;
+			break;
+		default:
+			op_ok = false;
+			break;
+		}
+		if (!op_ok || startblock_fsb == 0 ||
+		    refc->pe_len == 0 ||
+		    startblock_fsb >= mp->m_sb.sb_dblocks ||
+		    refc->pe_len >= mp->m_sb.sb_agblocks ||
+		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)) {
+			/*
+			 * This will pull the CUI from the AIL and
+			 * free the memory associated with it.
+			 */
+			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+			xfs_cui_release(cuip);
+			return -EIO;
+		}
+	}
+
+	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+	xfs_cui_release(cuip);
+	return error;
+}
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index 7b8f56b..6e6f5fd 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -98,5 +98,6 @@ int xfs_cui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_cui_log_format *dst_cui_fmt);
 void xfs_cui_item_free(struct xfs_cui_log_item *);
 void xfs_cui_release(struct xfs_cui_log_item *);
+int xfs_cui_recover(struct xfs_mount *mp, struct xfs_cui_log_item *cuip);
 
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 631c114..84078df 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2933,6 +2933,36 @@ DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
 
+TRACE_EVENT(xfs_refcount_finish_one_leftover,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int type, xfs_agblock_t agbno,
+		 xfs_extlen_t len, xfs_extlen_t adjusted),
+	TP_ARGS(mp, agno, type, agbno, len, adjusted),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, type)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(xfs_extlen_t, adjusted)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->type = type;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->adjusted = adjusted;
+	),
+	TP_printk("dev %d:%d type %d agno %u agbno %u len %u adjusted %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->adjusted)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index e2bf86a..fe69e20 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -36,6 +36,7 @@ struct xfs_busy_extent;
 struct xfs_rud_log_item;
 struct xfs_rui_log_item;
 struct xfs_btree_cur;
+struct xfs_cui_log_item;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -248,4 +249,14 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
+/* refcount updates */
+enum xfs_refcount_intent_type;
+
+struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
+		struct xfs_cui_log_item *cuip);
+int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
+		struct xfs_cud_log_item *cudp,
+		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
+		xfs_extlen_t blockcount, struct xfs_btree_cur **pcur);
+
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
new file mode 100644
index 0000000..9c05c18
--- /dev/null
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_refcount_item.h"
+#include "xfs_alloc.h"
+#include "xfs_refcount.h"
+
+/* Set the phys extent flags for this reverse mapping. */
+static void
+xfs_trans_set_refcount_flags(
+	struct xfs_phys_extent		*refc,
+	enum xfs_refcount_intent_type	type)
+{
+	refc->pe_flags = 0;
+	switch (type) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		refc->pe_flags |= type;
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+/*
+ * This routine is called to allocate a "refcount update done"
+ * log item.
+ */
+struct xfs_cud_log_item *
+xfs_trans_get_cud(
+	struct xfs_trans		*tp,
+	struct xfs_cui_log_item		*cuip)
+{
+	struct xfs_cud_log_item		*cudp;
+
+	cudp = xfs_cud_init(tp->t_mountp, cuip);
+	xfs_trans_add_item(tp, &cudp->cud_item);
+	return cudp;
+}
+
+/*
+ * Finish an refcount update and log it to the CUD. Note that the
+ * transaction is marked dirty regardless of whether the refcount
+ * update succeeds or fails to support the CUI/CUD lifecycle rules.
+ */
+int
+xfs_trans_log_finish_refcount_update(
+	struct xfs_trans		*tp,
+	struct xfs_cud_log_item		*cudp,
+	enum xfs_refcount_intent_type	type,
+	xfs_fsblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	struct xfs_btree_cur		**pcur)
+{
+	int				error;
+
+	/* XXX: leave this empty for now */
+	error = -EFSCORRUPTED;
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the CUI and frees the CUD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	cudp->cud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	return error;
+}

