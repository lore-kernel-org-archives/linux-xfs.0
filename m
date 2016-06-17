Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 534377E2D
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:24:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12A2A304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:24:40 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iurqtOh1qHSPWp75 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:24:36 -0700 (PDT)
Subject: [PATCH 062/119] xfs: log refcount intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:24:29 -0700
Message-ID: <146612666945.12839.17831346063394478114.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Provide a mechanism for higher levels to create CUI/CUD items, submit
them to the log, and a stub function to deal with recovered CUI items.
These parts will be connected to the refcountbt in a later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_log_format.h |    2 
 fs/xfs/libxfs/xfs_refcount.h   |   14 ++
 fs/xfs/xfs_log_recover.c       |  299 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h             |   30 ++++
 fs/xfs/xfs_trans.h             |   15 ++
 fs/xfs/xfs_trans_refcount.c    |  192 ++++++++++++++++++++++++++
 7 files changed, 552 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_trans_refcount.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 322c386..2945270 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -114,6 +114,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
+				   xfs_trans_refcount.o \
 				   xfs_trans_rmap.o \
 
 # optional features
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 1dfa02c..923b08f 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -688,6 +688,8 @@ struct xfs_phys_extent {
 #define XFS_REFCOUNT_EXTENT_FREE_COW	4
 #define XFS_REFCOUNT_EXTENT_TYPE_MASK	0xFF
 
+#define XFS_REFCOUNT_EXTENT_FLAGS	(XFS_REFCOUNT_EXTENT_TYPE_MASK)
+
 /*
  * This is the structure used to lay out a cui log item in the
  * log.  The cui_extents field is a variable size array whose
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 8ea65c6..0b36c1d 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -27,4 +27,18 @@ extern int xfs_refcountbt_lookup_ge(struct xfs_btree_cur *cur,
 extern int xfs_refcountbt_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
+enum xfs_refcount_intent_type {
+	XFS_REFCOUNT_INCREASE,
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
index dbfbc26..e0a470a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -46,6 +46,7 @@
 #include "xfs_dir2.h"
 #include "xfs_rmap_item.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -1916,6 +1917,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_EFI:
 		case XFS_LI_RUI:
 		case XFS_LI_RUD:
+		case XFS_LI_CUI:
+		case XFS_LI_CUD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
@@ -3519,6 +3522,101 @@ xlog_recover_rud_pass2(
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
+	ASSERT(item->ri_buf[0].i_len == (sizeof(struct xfs_cud_log_format) +
+			((cud_formatp->cud_nextents - 1) *
+			sizeof(struct xfs_phys_extent))));
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
@@ -3745,6 +3843,8 @@ xlog_recover_ra_pass2(
 	case XFS_LI_QUOTAOFF:
 	case XFS_LI_RUI:
 	case XFS_LI_RUD:
+	case XFS_LI_CUI:
+	case XFS_LI_CUD:
 	default:
 		break;
 	}
@@ -3770,6 +3870,8 @@ xlog_recover_commit_pass1(
 	case XFS_LI_ICREATE:
 	case XFS_LI_RUI:
 	case XFS_LI_RUD:
+	case XFS_LI_CUI:
+	case XFS_LI_CUD:
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
@@ -3804,6 +3906,10 @@ xlog_recover_commit_pass2(
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
@@ -4282,6 +4388,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	switch (lip->li_type) {
 	case XFS_LI_EFI:
 	case XFS_LI_RUI:
+	case XFS_LI_CUI:
 		return true;
 	default:
 		return false;
@@ -4713,6 +4820,186 @@ xlog_recover_cancel_ruis(
 }
 
 /*
+ * Process a refcount update intent item that was recovered from the log.
+ * We need to update the refcountbt.
+ */
+STATIC int
+xlog_recover_process_cui(
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
+		refc = &(cuip->cui_format.cui_extents[i]);
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
+		if (!op_ok || (startblock_fsb == 0) ||
+		    (refc->pe_len == 0) ||
+		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
+		    (refc->pe_len >= mp->m_sb.sb_agblocks) ||
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
+	/* XXX: do nothing for now */
+	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
+	xfs_cui_release(cuip);
+	return error;
+}
+
+/*
+ * When this is called, all of the CUIs which did not have
+ * corresponding CUDs should be in the AIL.  What we do now
+ * is update the rmaps associated with each one.
+ *
+ * Since we process the CUIs in normal transactions, they
+ * will be removed at some point after the commit.  This prevents
+ * us from just walking down the list processing each one.
+ * We'll use a flag in the CUI to skip those that we've already
+ * processed and use the AIL iteration mechanism's generation
+ * count to try to speed this up at least a bit.
+ *
+ * When we start, we know that the CUIs are the only things in
+ * the AIL.  As we process them, however, other items are added
+ * to the AIL.  Since everything added to the AIL must come after
+ * everything already in the AIL, we stop processing as soon as
+ * we see something other than an CUI in the AIL.
+ */
+STATIC int
+xlog_recover_process_cuis(
+	struct xlog		*log)
+{
+	struct xfs_log_item	*lip;
+	struct xfs_cui_log_item	*cuip;
+	int			error = 0;
+	struct xfs_ail_cursor	cur;
+	struct xfs_ail		*ailp;
+
+	ailp = log->l_ailp;
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		/*
+		 * We're done when we see something other than an intent.
+		 * There should be no intents left in the AIL now.
+		 */
+		if (!xlog_item_is_intent(lip)) {
+#ifdef DEBUG
+			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
+				ASSERT(!xlog_item_is_intent(lip));
+#endif
+			break;
+		}
+
+		/* Skip anything that isn't an CUI */
+		if (lip->li_type != XFS_LI_CUI) {
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			continue;
+		}
+
+		/*
+		 * Skip CUIs that we've already processed.
+		 */
+		cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
+		if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags)) {
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			continue;
+		}
+
+		spin_unlock(&ailp->xa_lock);
+		error = xlog_recover_process_cui(log->l_mp, cuip);
+		spin_lock(&ailp->xa_lock);
+		if (error)
+			goto out;
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+out:
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->xa_lock);
+	return error;
+}
+
+/*
+ * A cancel occurs when the mount has failed and we're bailing out. Release all
+ * pending CUIs so they don't pin the AIL.
+ */
+STATIC int
+xlog_recover_cancel_cuis(
+	struct xlog		*log)
+{
+	struct xfs_log_item	*lip;
+	struct xfs_cui_log_item	*cuip;
+	int			error = 0;
+	struct xfs_ail_cursor	cur;
+	struct xfs_ail		*ailp;
+
+	ailp = log->l_ailp;
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		/*
+		 * We're done when we see something other than an CUI.
+		 * There should be no CUIs left in the AIL now.
+		 */
+		if (!xlog_item_is_intent(lip)) {
+#ifdef DEBUG
+			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
+				ASSERT(!xlog_item_is_intent(lip));
+#endif
+			break;
+		}
+
+		/* Skip anything that isn't an CUI */
+		if (lip->li_type != XFS_LI_CUI) {
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			continue;
+		}
+
+		cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
+
+		spin_unlock(&ailp->xa_lock);
+		xfs_cui_release(cuip);
+		spin_lock(&ailp->xa_lock);
+
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->xa_lock);
+	return error;
+}
+
+/*
  * This routine performs a transaction to null out a bad inode pointer
  * in an agi unlinked inode hash bucket.
  */
@@ -5515,6 +5802,12 @@ xlog_recover_finish(
 	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
 		int	error;
 
+		error = xlog_recover_process_cuis(log);
+		if (error) {
+			xfs_alert(log->l_mp, "Failed to recover CUIs");
+			return error;
+		}
+
 		error = xlog_recover_process_ruis(log);
 		if (error) {
 			xfs_alert(log->l_mp, "Failed to recover RUIs");
@@ -5557,7 +5850,11 @@ xlog_recover_cancel(
 	int		err2;
 
 	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
-		error = xlog_recover_cancel_ruis(log);
+		error = xlog_recover_cancel_cuis(log);
+
+		err2 = xlog_recover_cancel_ruis(log);
+		if (err2 && !error)
+			error = err2;
 
 		err2 = xlog_recover_cancel_efis(log);
 		if (err2 && !error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 67ce2d8..1f6cee0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2906,6 +2906,36 @@ DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
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
index f59d934..2b197fd 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -253,4 +253,19 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
+enum xfs_refcount_intent_type;
+
+struct xfs_cui_log_item *xfs_trans_get_cui(struct xfs_trans *tp, uint nextents);
+void xfs_trans_log_start_refcount_update(struct xfs_trans *tp,
+		struct xfs_cui_log_item *cuip,
+		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount);
+
+struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
+		struct xfs_cui_log_item *cuip, uint nextents);
+int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
+		struct xfs_cud_log_item *cudp,
+		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
+		xfs_extlen_t blockcount, struct xfs_btree_cur **pcur);
+
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
new file mode 100644
index 0000000..32701e4
--- /dev/null
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -0,0 +1,192 @@
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
+/*
+ * This routine is called to allocate an "refcount update intent"
+ * log item that will hold nextents worth of extents.  The
+ * caller must use all nextents extents, because we are not
+ * flexible about this at all.
+ */
+struct xfs_cui_log_item *
+xfs_trans_get_cui(
+	struct xfs_trans		*tp,
+	uint				nextents)
+{
+	struct xfs_cui_log_item		*cuip;
+
+	ASSERT(tp != NULL);
+	ASSERT(nextents > 0);
+
+	cuip = xfs_cui_init(tp->t_mountp, nextents);
+	ASSERT(cuip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	return cuip;
+}
+
+/*
+ * This routine is called to indicate that the described
+ * extent is to be logged as needing to be freed.  It should
+ * be called once for each extent to be freed.
+ */
+void
+xfs_trans_log_start_refcount_update(
+	struct xfs_trans		*tp,
+	struct xfs_cui_log_item		*cuip,
+	enum xfs_refcount_intent_type	type,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			blockcount)
+{
+	uint				next_extent;
+	struct xfs_phys_extent		*refc;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	cuip->cui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
+	ASSERT(next_extent < cuip->cui_format.cui_nextents);
+	refc = &(cuip->cui_format.cui_extents[next_extent]);
+	refc->pe_startblock = startblock;
+	refc->pe_len = blockcount;
+	refc->pe_flags = 0;
+	switch (type) {
+	case XFS_REFCOUNT_INCREASE:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_INCREASE;
+		break;
+	case XFS_REFCOUNT_DECREASE:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_DECREASE;
+		break;
+	case XFS_REFCOUNT_ALLOC_COW:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_ALLOC_COW;
+		break;
+	case XFS_REFCOUNT_FREE_COW:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_FREE_COW;
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+
+/*
+ * This routine is called to allocate an "extent free done"
+ * log item that will hold nextents worth of extents.  The
+ * caller must use all nextents extents, because we are not
+ * flexible about this at all.
+ */
+struct xfs_cud_log_item *
+xfs_trans_get_cud(
+	struct xfs_trans		*tp,
+	struct xfs_cui_log_item		*cuip,
+	uint				nextents)
+{
+	struct xfs_cud_log_item		*cudp;
+
+	ASSERT(tp != NULL);
+	ASSERT(nextents > 0);
+
+	cudp = xfs_cud_init(tp->t_mountp, cuip, nextents);
+	ASSERT(cudp != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &cudp->cud_item);
+	return cudp;
+}
+
+/*
+ * Finish an refcount update and log it to the CUD. Note that the transaction is
+ * marked dirty regardless of whether the refcount update succeeds or fails to
+ * support the CUI/CUD lifecycle rules.
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
+	uint				next_extent;
+	struct xfs_phys_extent		*refc;
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
+	next_extent = cudp->cud_next_extent;
+	ASSERT(next_extent < cudp->cud_format.cud_nextents);
+	refc = &(cudp->cud_format.cud_extents[next_extent]);
+	refc->pe_startblock = startblock;
+	refc->pe_len = blockcount;
+	refc->pe_flags = 0;
+	switch (type) {
+	case XFS_REFCOUNT_INCREASE:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_INCREASE;
+		break;
+	case XFS_REFCOUNT_DECREASE:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_DECREASE;
+		break;
+	case XFS_REFCOUNT_ALLOC_COW:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_ALLOC_COW;
+		break;
+	case XFS_REFCOUNT_FREE_COW:
+		refc->pe_flags |= XFS_REFCOUNT_EXTENT_FREE_COW;
+		break;
+	default:
+		ASSERT(0);
+	}
+	cudp->cud_next_extent++;
+
+	return error;
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
