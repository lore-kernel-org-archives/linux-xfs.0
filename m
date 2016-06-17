Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47E227E2D
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:25:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19422304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id a4xEtXDsr76JSgVg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:31 -0700 (PDT)
Subject: [PATCH 070/119] xfs: log bmap intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:25:20 -0700
Message-ID: <146612672092.12839.1498624909455170579.stgit@birch.djwong.org>
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

Provide a mechanism for higher levels to create BUI/BUD items, submit
them to the log, and a stub function to deal with recovered BUI items.
These parts will be connected to the rmapbt in a later patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile          |    1 
 fs/xfs/libxfs/xfs_bmap.h |   13 ++
 fs/xfs/xfs_log_recover.c |  301 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |   18 +++
 fs/xfs/xfs_trans_bmap.c  |  201 +++++++++++++++++++++++++++++++
 5 files changed, 533 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_trans_bmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d2ce5db..941afe6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -112,6 +112,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
+				   xfs_trans_bmap.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 862ea464..62a66d0 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -209,4 +209,17 @@ struct xfs_bmbt_rec_host *
 				struct xfs_bmbt_irec *gotp,
 				struct xfs_bmbt_irec *prevp);
 
+enum xfs_bmap_intent_type {
+	XFS_BMAP_MAP,
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
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2235d94..42000f4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -48,6 +48,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_item.h"
 #include "xfs_refcount.h"
+#include "xfs_bmap_item.h"
+#include "xfs_bmap.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -1920,6 +1922,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_RUD:
 		case XFS_LI_CUI:
 		case XFS_LI_CUD:
+		case XFS_LI_BUI:
+		case XFS_LI_BUD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
@@ -3622,6 +3626,101 @@ xlog_recover_cud_pass2(
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
+	buip = xfs_bui_init(mp, bui_formatp->bui_nextents);
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
+	ASSERT(item->ri_buf[0].i_len == (sizeof(struct xfs_bud_log_format) +
+			((bud_formatp->bud_nextents - 1) *
+			sizeof(struct xfs_map_extent))));
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
@@ -3850,6 +3949,8 @@ xlog_recover_ra_pass2(
 	case XFS_LI_RUD:
 	case XFS_LI_CUI:
 	case XFS_LI_CUD:
+	case XFS_LI_BUI:
+	case XFS_LI_BUD:
 	default:
 		break;
 	}
@@ -3877,6 +3978,8 @@ xlog_recover_commit_pass1(
 	case XFS_LI_RUD:
 	case XFS_LI_CUI:
 	case XFS_LI_CUD:
+	case XFS_LI_BUI:
+	case XFS_LI_BUD:
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
@@ -3915,6 +4018,10 @@ xlog_recover_commit_pass2(
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
@@ -4394,6 +4501,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	case XFS_LI_EFI:
 	case XFS_LI_RUI:
 	case XFS_LI_CUI:
+	case XFS_LI_BUI:
 		return true;
 	default:
 		return false;
@@ -5079,6 +5187,187 @@ xlog_recover_cancel_cuis(
 }
 
 /*
+ * Process a bmap update intent item that was recovered from the log.
+ * We need to update some inode's bmbt.
+ */
+STATIC int
+xlog_recover_process_bui(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip)
+{
+	int				i;
+	int				error = 0;
+	struct xfs_map_extent		*bmap;
+	xfs_fsblock_t			startblock_fsb;
+	xfs_fsblock_t			inode_fsb;
+	bool				op_ok;
+
+	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
+
+	/*
+	 * First check the validity of the extents described by the
+	 * BUI.  If any are bad, then assume that all are bad and
+	 * just toss the BUI.
+	 */
+	for (i = 0; i < buip->bui_format.bui_nextents; i++) {
+		bmap = &(buip->bui_format.bui_extents[i]);
+		startblock_fsb = XFS_BB_TO_FSB(mp,
+				   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
+		inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
+				XFS_INO_TO_FSB(mp, bmap->me_owner)));
+		switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+		case XFS_BMAP_EXTENT_MAP:
+		case XFS_BMAP_EXTENT_UNMAP:
+			op_ok = true;
+			break;
+		default:
+			op_ok = false;
+			break;
+		}
+		if (!op_ok || (startblock_fsb == 0) ||
+		    (bmap->me_len == 0) ||
+		    (inode_fsb == 0) ||
+		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
+		    (bmap->me_len >= mp->m_sb.sb_agblocks) ||
+		    (inode_fsb >= mp->m_sb.sb_agblocks) ||
+		    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)) {
+			/*
+			 * This will pull the BUI from the AIL and
+			 * free the memory associated with it.
+			 */
+			set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+			xfs_bui_release(buip);
+			return -EIO;
+		}
+	}
+
+	/* XXX: do nothing for now */
+	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	xfs_bui_release(buip);
+	return error;
+}
+
+/*
+ * When this is called, all of the BUIs which did not have
+ * corresponding BUDs should be in the AIL.  What we do now
+ * is update the bmbts associated with each one.
+ *
+ * Since we process the BUIs in normal transactions, they
+ * will be removed at some point after the commit.  This prevents
+ * us from just walking down the list processing each one.
+ * We'll use a flag in the BUI to skip those that we've already
+ * processed and use the AIL iteration mechanism's generation
+ * count to try to speed this up at least a bit.
+ *
+ * When we start, we know that the BUIs are the only things in
+ * the AIL.  As we process them, however, other items are added
+ * to the AIL.
+ */
+STATIC int
+xlog_recover_process_buis(
+	struct xlog		*log)
+{
+	struct xfs_log_item	*lip;
+	struct xfs_bui_log_item	*buip;
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
+		/* Skip anything that isn't a BUI */
+		if (lip->li_type != XFS_LI_BUI) {
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			continue;
+		}
+
+		/*
+		 * Skip BUIs that we've already processed.
+		 */
+		buip = container_of(lip, struct xfs_bui_log_item, bui_item);
+		if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags)) {
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			continue;
+		}
+
+		spin_unlock(&ailp->xa_lock);
+		error = xlog_recover_process_bui(log->l_mp, buip);
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
+ * pending BUIs so they don't pin the AIL.
+ */
+STATIC int
+xlog_recover_cancel_buis(
+	struct xlog		*log)
+{
+	struct xfs_log_item	*lip;
+	struct xfs_bui_log_item	*buip;
+	int			error = 0;
+	struct xfs_ail_cursor	cur;
+	struct xfs_ail		*ailp;
+
+	ailp = log->l_ailp;
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		/*
+		 * We're done when we see something other than an RUI.
+		 * There should be no RUIs left in the AIL now.
+		 */
+		if (!xlog_item_is_intent(lip)) {
+#ifdef DEBUG
+			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
+				ASSERT(!xlog_item_is_intent(lip));
+#endif
+			break;
+		}
+
+		/* Skip anything that isn't a BUI */
+		if (lip->li_type != XFS_LI_BUI) {
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			continue;
+		}
+
+		buip = container_of(lip, struct xfs_bui_log_item, bui_item);
+
+		spin_unlock(&ailp->xa_lock);
+		xfs_bui_release(buip);
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
@@ -5881,6 +6170,12 @@ xlog_recover_finish(
 	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
 		int	error;
 
+		error = xlog_recover_process_buis(log);
+		if (error) {
+			xfs_alert(log->l_mp, "Failed to recover BUIs");
+			return error;
+		}
+
 		error = xlog_recover_process_cuis(log);
 		if (error) {
 			xfs_alert(log->l_mp, "Failed to recover CUIs");
@@ -5929,7 +6224,11 @@ xlog_recover_cancel(
 	int		err2;
 
 	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
-		error = xlog_recover_cancel_cuis(log);
+		error = xlog_recover_cancel_buis(log);
+
+		err2 = xlog_recover_cancel_cuis(log);
+		if (err2 && !error)
+			error = err2;
 
 		err2 = xlog_recover_cancel_ruis(log);
 		if (err2 && !error)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6b6cb4a..cda7d92 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -270,4 +270,22 @@ int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
 		xfs_extlen_t blockcount, xfs_extlen_t *adjusted,
 		struct xfs_btree_cur **pcur);
 
+enum xfs_bmap_intent_type;
+
+struct xfs_bui_log_item *xfs_trans_get_bui(struct xfs_trans *tp, uint nextents);
+void xfs_trans_log_start_bmap_update(struct xfs_trans *tp,
+		struct xfs_bui_log_item *buip, enum xfs_bmap_intent_type type,
+		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
+		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
+		xfs_exntst_t state);
+
+struct xfs_bud_log_item *xfs_trans_get_bud(struct xfs_trans *tp,
+		struct xfs_bui_log_item *buip, uint nextents);
+int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
+		struct xfs_bud_log_item *rudp, struct xfs_defer_ops *dfops,
+		enum xfs_bmap_intent_type type, struct xfs_inode *ip,
+		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state,
+		struct xfs_btree_cur **pcur);
+
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
new file mode 100644
index 0000000..1517c83
--- /dev/null
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -0,0 +1,201 @@
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
+/*
+ * This routine is called to allocate an "bmap update intent"
+ * log item that will hold nextents worth of extents.  The
+ * caller must use all nextents extents, because we are not
+ * flexible about this at all.
+ */
+struct xfs_bui_log_item *
+xfs_trans_get_bui(
+	struct xfs_trans		*tp,
+	uint				nextents)
+{
+	struct xfs_bui_log_item		*buip;
+
+	ASSERT(tp != NULL);
+	ASSERT(nextents > 0);
+
+	buip = xfs_bui_init(tp->t_mountp, nextents);
+	ASSERT(buip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &buip->bui_item);
+	return buip;
+}
+
+/*
+ * This routine is called to indicate that the described
+ * extent is to be logged as needing to be freed.  It should
+ * be called once for each extent to be freed.
+ */
+void
+xfs_trans_log_start_bmap_update(
+	struct xfs_trans		*tp,
+	struct xfs_bui_log_item		*buip,
+	enum xfs_bmap_intent_type	type,
+	__uint64_t			owner,
+	int				whichfork,
+	xfs_fileoff_t			startoff,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			blockcount,
+	xfs_exntst_t			state)
+{
+	uint				next_extent;
+	struct xfs_map_extent		*bmap;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	buip->bui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
+	ASSERT(next_extent < buip->bui_format.bui_nextents);
+	bmap = &(buip->bui_format.bui_extents[next_extent]);
+	bmap->me_owner = owner;
+	bmap->me_startblock = startblock;
+	bmap->me_startoff = startoff;
+	bmap->me_len = blockcount;
+	bmap->me_flags = 0;
+	if (state == XFS_EXT_UNWRITTEN)
+		bmap->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
+	if (whichfork == XFS_ATTR_FORK)
+		bmap->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+	switch (type) {
+	case XFS_BMAP_MAP:
+		bmap->me_flags |= XFS_BMAP_EXTENT_MAP;
+		break;
+	case XFS_BMAP_UNMAP:
+		bmap->me_flags |= XFS_BMAP_EXTENT_UNMAP;
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
+struct xfs_bud_log_item *
+xfs_trans_get_bud(
+	struct xfs_trans		*tp,
+	struct xfs_bui_log_item		*buip,
+	uint				nextents)
+{
+	struct xfs_bud_log_item		*budp;
+
+	ASSERT(tp != NULL);
+	ASSERT(nextents > 0);
+
+	budp = xfs_bud_init(tp->t_mountp, buip, nextents);
+	ASSERT(budp != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &budp->bud_item);
+	return budp;
+}
+
+/*
+ * Finish an bmap update and log it to the BUD. Note that the transaction is
+ * marked dirty regardless of whether the bmap update succeeds or fails to
+ * support the BUI/BUD lifecycle rules.
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
+	xfs_exntst_t			state,
+	struct xfs_btree_cur		**pcur)
+{
+	uint				next_extent;
+	struct xfs_map_extent		*bmap;
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
+	next_extent = budp->bud_next_extent;
+	ASSERT(next_extent < budp->bud_format.bud_nextents);
+	bmap = &(budp->bud_format.bud_extents[next_extent]);
+	bmap->me_owner = ip->i_ino;
+	bmap->me_startblock = startblock;
+	bmap->me_startoff = startoff;
+	bmap->me_len = blockcount;
+	bmap->me_flags = 0;
+	if (state == XFS_EXT_UNWRITTEN)
+		bmap->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
+	if (whichfork == XFS_ATTR_FORK)
+		bmap->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+	switch (type) {
+	case XFS_BMAP_MAP:
+		bmap->me_flags |= XFS_BMAP_EXTENT_MAP;
+		break;
+	case XFS_BMAP_UNMAP:
+		bmap->me_flags |= XFS_BMAP_EXTENT_UNMAP;
+		break;
+	default:
+		ASSERT(0);
+	}
+	budp->bud_next_extent++;
+
+	return error;
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
