Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19199 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756059AbcI1Czh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:55:37 -0400
Subject: [PATCH 19/63] xfs: log bmap intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:55:33 -0700
Message-ID: <147503133314.30303.13272175276424709028.stgit@birch.djwong.org>
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

Provide a mechanism for higher levels to create BUI/BUD items, submit
them to the log, and a stub function to deal with recovered BUI items.
These parts will be connected to the rmapbt in a later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Only support one item per BUI.
---
 fs/xfs/Makefile          |    1 
 fs/xfs/libxfs/xfs_bmap.h |   14 ++++
 fs/xfs/xfs_bmap_item.c   |   64 +++++++++++++++++++
 fs/xfs/xfs_bmap_item.h   |    1 
 fs/xfs/xfs_log_recover.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |   13 ++++
 fs/xfs/xfs_trans_bmap.c  |  107 ++++++++++++++++++++++++++++++++
 7 files changed, 354 insertions(+)
 create mode 100644 fs/xfs/xfs_trans_bmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b850961..6afb228 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -111,6 +111,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
+				   xfs_trans_bmap.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 8395f6e..fcdb094 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -207,4 +207,18 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, xfs_fileoff_t aoff,
 		xfs_filblks_t len, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *prev, xfs_extnum_t *lastx, int eof);
 
+/* The XFS_BMAP_EXTENT_* in xfs_log_format.h must match these. */
+enum xfs_bmap_intent_type {
+	XFS_BMAP_MAP = 1,
+	XFS_BMAP_UNMAP,
+};
+
+struct xfs_bmap_intent {
+	struct list_head			bi_list;
+	enum xfs_bmap_intent_type		bi_type;
+	struct xfs_inode			*bi_owner;
+	int					bi_whichfork;
+	struct xfs_bmbt_irec			bi_bmap;
+};
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index c93ff6f..4d8b03c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
@@ -395,3 +396,66 @@ xfs_bud_init(
 
 	return budp;
 }
+
+/*
+ * Process a bmap update intent item that was recovered from the log.
+ * We need to update some inode's bmbt.
+ */
+int
+xfs_bui_recover(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip)
+{
+	int				error = 0;
+	struct xfs_map_extent		*bmap;
+	xfs_fsblock_t			startblock_fsb;
+	xfs_fsblock_t			inode_fsb;
+	bool				op_ok;
+
+	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
+
+	/* Only one mapping operation per BUI... */
+	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
+		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+		xfs_bui_release(buip);
+		return -EIO;
+	}
+
+	/*
+	 * First check the validity of the extent described by the
+	 * BUI.  If anything is bad, then toss the BUI.
+	 */
+	bmap = &buip->bui_format.bui_extents[0];
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
+	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
+			XFS_INO_TO_FSB(mp, bmap->me_owner)));
+	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	case XFS_BMAP_EXTENT_MAP:
+	case XFS_BMAP_EXTENT_UNMAP:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    bmap->me_len == 0 ||
+	    inode_fsb == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    bmap->me_len >= mp->m_sb.sb_agblocks ||
+	    inode_fsb >= mp->m_sb.sb_agblocks ||
+	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)) {
+		/*
+		 * This will pull the BUI from the AIL and
+		 * free the memory associated with it.
+		 */
+		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+		xfs_bui_release(buip);
+		return -EIO;
+	}
+
+	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	xfs_bui_release(buip);
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index f7e2fa2..8607b28 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -95,5 +95,6 @@ int xfs_bui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_bui_log_format *dst_bui_fmt);
 void xfs_bui_item_free(struct xfs_bui_log_item *);
 void xfs_bui_release(struct xfs_bui_log_item *);
+int xfs_bui_recover(struct xfs_mount *mp, struct xfs_bui_log_item *buip);
 
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0f01127..62bae9f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -46,6 +46,7 @@
 #include "xfs_rmap_item.h"
 #include "xfs_buf_item.h"
 #include "xfs_refcount_item.h"
+#include "xfs_bmap_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -1927,6 +1928,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_RUD:
 		case XFS_LI_CUI:
 		case XFS_LI_CUD:
+		case XFS_LI_BUI:
+		case XFS_LI_BUD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
@@ -3648,6 +3651,102 @@ xlog_recover_cud_pass2(
 }
 
 /*
+ * This routine is called to create an in-core extent bmap update
+ * item from the bui format structure which was logged on disk.
+ * It allocates an in-core bui, copies the extents from the format
+ * structure into it, and adds the bui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_bui_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_bui_log_format	*bui_formatp;
+
+	bui_formatp = item->ri_buf[0].i_addr;
+
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+		return -EFSCORRUPTED;
+	buip = xfs_bui_init(mp);
+	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
+	if (error) {
+		xfs_bui_item_free(buip);
+		return error;
+	}
+	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
+
+	spin_lock(&log->l_ailp->xa_lock);
+	/*
+	 * The RUI has two references. One for the RUD and one for RUI to ensure
+	 * it makes it into the AIL. Insert the RUI into the AIL directly and
+	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
+	xfs_bui_release(buip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an BUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding BUI if it
+ * was still in the log. To do this it searches the AIL for the BUI with an id
+ * equal to that in the BUD format structure. If we find it we drop the BUD
+ * reference, which removes the BUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_bud_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_bud_log_format	*bud_formatp;
+	struct xfs_bui_log_item		*buip = NULL;
+	struct xfs_log_item		*lip;
+	__uint64_t			bui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	bud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format))
+		return -EFSCORRUPTED;
+	bui_id = bud_formatp->bud_bui_id;
+
+	/*
+	 * Search for the BUI with the id in the BUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_BUI) {
+			buip = (struct xfs_bui_log_item *)lip;
+			if (buip->bui_format.bui_id == bui_id) {
+				/*
+				 * Drop the BUD reference to the BUI. This
+				 * removes the BUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->xa_lock);
+				xfs_bui_release(buip);
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
@@ -3876,6 +3975,8 @@ xlog_recover_ra_pass2(
 	case XFS_LI_RUD:
 	case XFS_LI_CUI:
 	case XFS_LI_CUD:
+	case XFS_LI_BUI:
+	case XFS_LI_BUD:
 	default:
 		break;
 	}
@@ -3903,6 +4004,8 @@ xlog_recover_commit_pass1(
 	case XFS_LI_RUD:
 	case XFS_LI_CUI:
 	case XFS_LI_CUD:
+	case XFS_LI_BUI:
+	case XFS_LI_BUD:
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
@@ -3941,6 +4044,10 @@ xlog_recover_commit_pass2(
 		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_CUD:
 		return xlog_recover_cud_pass2(log, item);
+	case XFS_LI_BUI:
+		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
+	case XFS_LI_BUD:
+		return xlog_recover_bud_pass2(log, item);
 	case XFS_LI_DQUOT:
 		return xlog_recover_dquot_pass2(log, buffer_list, item,
 						trans->r_lsn);
@@ -4568,6 +4675,46 @@ xlog_recover_cancel_cui(
 	spin_lock(&ailp->xa_lock);
 }
 
+/* Recover the BUI if necessary. */
+STATIC int
+xlog_recover_process_bui(
+	struct xfs_mount		*mp,
+	struct xfs_ail			*ailp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_bui_log_item		*buip;
+	int				error;
+
+	/*
+	 * Skip BUIs that we've already processed.
+	 */
+	buip = container_of(lip, struct xfs_bui_log_item, bui_item);
+	if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags))
+		return 0;
+
+	spin_unlock(&ailp->xa_lock);
+	error = xfs_bui_recover(mp, buip);
+	spin_lock(&ailp->xa_lock);
+
+	return error;
+}
+
+/* Release the BUI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_bui(
+	struct xfs_mount		*mp,
+	struct xfs_ail			*ailp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_bui_log_item		*buip;
+
+	buip = container_of(lip, struct xfs_bui_log_item, bui_item);
+
+	spin_unlock(&ailp->xa_lock);
+	xfs_bui_release(buip);
+	spin_lock(&ailp->xa_lock);
+}
+
 /* Is this log item a deferred action intent? */
 static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 {
@@ -4575,6 +4722,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	case XFS_LI_EFI:
 	case XFS_LI_RUI:
 	case XFS_LI_CUI:
+	case XFS_LI_BUI:
 		return true;
 	default:
 		return false;
@@ -4641,6 +4789,9 @@ xlog_recover_process_intents(
 		case XFS_LI_CUI:
 			error = xlog_recover_process_cui(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_BUI:
+			error = xlog_recover_process_bui(log->l_mp, ailp, lip);
+			break;
 		}
 		if (error)
 			goto out;
@@ -4691,6 +4842,9 @@ xlog_recover_cancel_intents(
 		case XFS_LI_CUI:
 			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_BUI:
+			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
+			break;
 		}
 
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a7a87d2..7cf02d3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -39,6 +39,7 @@ struct xfs_btree_cur;
 struct xfs_cui_log_item;
 struct xfs_cud_log_item;
 struct xfs_defer_ops;
+struct xfs_bui_log_item;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -263,4 +264,16 @@ int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
 		xfs_extlen_t blockcount, xfs_extlen_t *adjusted,
 		struct xfs_btree_cur **pcur);
 
+/* mapping updates */
+enum xfs_bmap_intent_type;
+
+void xfs_bmap_update_init_defer_op(void);
+struct xfs_bud_log_item *xfs_trans_get_bud(struct xfs_trans *tp,
+		struct xfs_bui_log_item *buip);
+int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
+		struct xfs_bud_log_item *rudp, struct xfs_defer_ops *dfops,
+		enum xfs_bmap_intent_type type, struct xfs_inode *ip,
+		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state);
+
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
new file mode 100644
index 0000000..8b8744c
--- /dev/null
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -0,0 +1,107 @@
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
+#include "xfs_bmap_item.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_inode.h"
+
+/* Set the map extent flags for this mapping. */
+static void
+xfs_trans_set_bmap_flags(
+	struct xfs_map_extent		*bmap,
+	enum xfs_bmap_intent_type	type,
+	int				whichfork,
+	xfs_exntst_t			state)
+{
+	bmap->me_flags = 0;
+	switch (type) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		bmap->me_flags = type;
+		break;
+	default:
+		ASSERT(0);
+	}
+	if (state == XFS_EXT_UNWRITTEN)
+		bmap->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
+	if (whichfork == XFS_ATTR_FORK)
+		bmap->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+}
+
+/*
+ * This routine is called to allocate a "bmap update done"
+ * log item.
+ */
+struct xfs_bud_log_item *
+xfs_trans_get_bud(
+	struct xfs_trans		*tp,
+	struct xfs_bui_log_item		*buip)
+{
+	struct xfs_bud_log_item		*budp;
+
+	budp = xfs_bud_init(tp->t_mountp, buip);
+	xfs_trans_add_item(tp, &budp->bud_item);
+	return budp;
+}
+
+/*
+ * Finish an bmap update and log it to the BUD. Note that the
+ * transaction is marked dirty regardless of whether the bmap update
+ * succeeds or fails to support the BUI/BUD lifecycle rules.
+ */
+int
+xfs_trans_log_finish_bmap_update(
+	struct xfs_trans		*tp,
+	struct xfs_bud_log_item		*budp,
+	struct xfs_defer_ops		*dop,
+	enum xfs_bmap_intent_type	type,
+	struct xfs_inode		*ip,
+	int				whichfork,
+	xfs_fileoff_t			startoff,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			blockcount,
+	xfs_exntst_t			state)
+{
+	int				error;
+
+	error = -EFSCORRUPTED;
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the BUI and frees the BUD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	budp->bud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	return error;
+}

