Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 71BFB7D2D
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:00:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 19D048F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QYIuU9ryTrh6GKEM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:28 -0700 (PDT)
Subject: [PATCH 39/47] xfs: log rmap intent items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 22:00:22 -0700
Message-ID: <146907722270.25461.16807773108455455837.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Provide a mechanism for higher levels to create RUI/RUD items, submit
them to the log, and a stub function to deal with recovered RUI items.
These parts will be connected to the rmapbt in a later patch.

v2: Refactor flag setting into a helper function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile          |    1 
 fs/xfs/xfs_log_recover.c |  154 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rmap_item.c   |   60 +++++++++++++
 fs/xfs/xfs_rmap_item.h   |    1 
 fs/xfs/xfs_trans.h       |   17 ++++
 fs/xfs/xfs_trans_rmap.c  |  205 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 438 insertions(+)
 create mode 100644 fs/xfs/xfs_trans_rmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6c90393..3124210 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -109,6 +109,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
+				   xfs_trans_rmap.o \
 
 # optional features
 xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f64d4d0..365aef6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -43,6 +43,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_error.h"
 #include "xfs_dir2.h"
+#include "xfs_rmap_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -1911,6 +1912,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_QUOTAOFF:
 		case XFS_LI_EFD:
 		case XFS_LI_EFI:
+		case XFS_LI_RUI:
+		case XFS_LI_RUD:
 			trace_xfs_log_recover_item_reorder_tail(log,
 							trans, item, pass);
 			list_move_tail(&item->ri_list, &inode_list);
@@ -3415,6 +3418,101 @@ xlog_recover_efd_pass2(
 }
 
 /*
+ * This routine is called to create an in-core extent rmap update
+ * item from the rui format structure which was logged on disk.
+ * It allocates an in-core rui, copies the extents from the format
+ * structure into it, and adds the rui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_rui_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rui_log_format	*rui_formatp;
+
+	rui_formatp = item->ri_buf[0].i_addr;
+
+	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
+	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
+	if (error) {
+		xfs_rui_item_free(ruip);
+		return error;
+	}
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	spin_lock(&log->l_ailp->xa_lock);
+	/*
+	 * The RUI has two references. One for the RUD and one for RUI to ensure
+	 * it makes it into the AIL. Insert the RUI into the AIL directly and
+	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
+	xfs_rui_release(ruip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an RUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding RUI if it
+ * was still in the log. To do this it searches the AIL for the RUI with an id
+ * equal to that in the RUD format structure. If we find it we drop the RUD
+ * reference, which removes the RUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_rud_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_rud_log_format	*rud_formatp;
+	struct xfs_rui_log_item		*ruip = NULL;
+	struct xfs_log_item		*lip;
+	__uint64_t			rui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	rud_formatp = item->ri_buf[0].i_addr;
+	ASSERT(item->ri_buf[0].i_len == (sizeof(struct xfs_rud_log_format) +
+			((rud_formatp->rud_nextents - 1) *
+			sizeof(struct xfs_map_extent))));
+	rui_id = rud_formatp->rud_rui_id;
+
+	/*
+	 * Search for the RUI with the id in the RUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_RUI) {
+			ruip = (struct xfs_rui_log_item *)lip;
+			if (ruip->rui_format.rui_id == rui_id) {
+				/*
+				 * Drop the RUD reference to the RUI. This
+				 * removes the RUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->xa_lock);
+				xfs_rui_release(ruip);
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
@@ -3639,6 +3737,8 @@ xlog_recover_ra_pass2(
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
 	case XFS_LI_QUOTAOFF:
+	case XFS_LI_RUI:
+	case XFS_LI_RUD:
 	default:
 		break;
 	}
@@ -3662,6 +3762,8 @@ xlog_recover_commit_pass1(
 	case XFS_LI_EFD:
 	case XFS_LI_DQUOT:
 	case XFS_LI_ICREATE:
+	case XFS_LI_RUI:
+	case XFS_LI_RUD:
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
@@ -3692,6 +3794,10 @@ xlog_recover_commit_pass2(
 		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
 	case XFS_LI_EFD:
 		return xlog_recover_efd_pass2(log, item);
+	case XFS_LI_RUI:
+		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
+	case XFS_LI_RUD:
+		return xlog_recover_rud_pass2(log, item);
 	case XFS_LI_DQUOT:
 		return xlog_recover_dquot_pass2(log, buffer_list, item,
 						trans->r_lsn);
@@ -4204,11 +4310,52 @@ xlog_recover_cancel_efi(
 	spin_lock(&ailp->xa_lock);
 }
 
+/* Recover the RUI if necessary. */
+STATIC int
+xlog_recover_process_rui(
+	struct xfs_mount		*mp,
+	struct xfs_ail			*ailp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_rui_log_item		*ruip;
+	int				error;
+
+	/*
+	 * Skip RUIs that we've already processed.
+	 */
+	ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
+	if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags))
+		return 0;
+
+	spin_unlock(&ailp->xa_lock);
+	error = xfs_rui_recover(mp, ruip);
+	spin_lock(&ailp->xa_lock);
+
+	return error;
+}
+
+/* Release the RUI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_rui(
+	struct xfs_mount		*mp,
+	struct xfs_ail			*ailp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_rui_log_item		*ruip;
+
+	ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
+
+	spin_unlock(&ailp->xa_lock);
+	xfs_rui_release(ruip);
+	spin_lock(&ailp->xa_lock);
+}
+
 /* Is this log item a deferred action intent? */
 static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 {
 	switch (lip->li_type) {
 	case XFS_LI_EFI:
+	case XFS_LI_RUI:
 		return true;
 	default:
 		return false;
@@ -4269,6 +4416,9 @@ xlog_recover_process_intents(
 		case XFS_LI_EFI:
 			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_RUI:
+			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
+			break;
 		}
 		if (error)
 			goto out;
@@ -4313,6 +4463,9 @@ xlog_recover_cancel_intents(
 		case XFS_LI_EFI:
 			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
 			break;
+		case XFS_LI_RUI:
+			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
+			break;
 		}
 
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
@@ -5130,6 +5283,7 @@ xlog_recover_finish(
 			xfs_alert(log->l_mp, "Failed to recover intents");
 			return error;
 		}
+
 		/*
 		 * Sync the log to get all the intents out of the AIL.
 		 * This isn't absolutely necessary, but it helps in
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5398b84..fecd1e4 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
@@ -457,3 +458,62 @@ xfs_rud_init(
 
 	return rudp;
 }
+
+/*
+ * Process an rmap update intent item that was recovered from the log.
+ * We need to update the rmapbt.
+ */
+int
+xfs_rui_recover(
+	struct xfs_mount		*mp,
+	struct xfs_rui_log_item		*ruip)
+{
+	int				i;
+	int				error = 0;
+	struct xfs_map_extent		*rmap;
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
+
+	/*
+	 * First check the validity of the extents described by the
+	 * RUI.  If any are bad, then assume that all are bad and
+	 * just toss the RUI.
+	 */
+	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
+		rmap = &(ruip->rui_format.rui_extents[i]);
+		startblock_fsb = XFS_BB_TO_FSB(mp,
+				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
+		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+		case XFS_RMAP_EXTENT_MAP:
+		case XFS_RMAP_EXTENT_UNMAP:
+		case XFS_RMAP_EXTENT_CONVERT:
+		case XFS_RMAP_EXTENT_ALLOC:
+		case XFS_RMAP_EXTENT_FREE:
+			op_ok = true;
+			break;
+		default:
+			op_ok = false;
+			break;
+		}
+		if (!op_ok || (startblock_fsb == 0) ||
+		    (rmap->me_len == 0) ||
+		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
+		    (rmap->me_len >= mp->m_sb.sb_agblocks) ||
+		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)) {
+			/*
+			 * This will pull the RUI from the AIL and
+			 * free the memory associated with it.
+			 */
+			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+			xfs_rui_release(ruip);
+			return -EIO;
+		}
+	}
+
+	/* XXX: do nothing for now */
+	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+	xfs_rui_release(ruip);
+	return error;
+}
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index bd36ab5..59ef3ec 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -96,5 +96,6 @@ int xfs_rui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
 void xfs_rui_release(struct xfs_rui_log_item *);
+int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
 
 #endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 497c740..fd2dfc0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -232,4 +232,21 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 extern kmem_zone_t	*xfs_trans_zone;
 extern kmem_zone_t	*xfs_log_item_desc_zone;
 
+enum xfs_rmap_intent_type;
+
+struct xfs_rui_log_item *xfs_trans_get_rui(struct xfs_trans *tp, uint nextents);
+void xfs_trans_log_start_rmap_update(struct xfs_trans *tp,
+		struct xfs_rui_log_item *ruip, enum xfs_rmap_intent_type type,
+		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
+		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
+		xfs_exntst_t state);
+
+struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
+		struct xfs_rui_log_item *ruip, uint nextents);
+int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
+		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
+		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
+		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
+		xfs_exntst_t state);
+
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
new file mode 100644
index 0000000..e3a5172
--- /dev/null
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -0,0 +1,205 @@
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
+#include "xfs_rmap_item.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap.h"
+
+/*
+ * This routine is called to allocate an "rmap update intent"
+ * log item that will hold nextents worth of extents.  The
+ * caller must use all nextents extents, because we are not
+ * flexible about this at all.
+ */
+struct xfs_rui_log_item *
+xfs_trans_get_rui(
+	struct xfs_trans		*tp,
+	uint				nextents)
+{
+	struct xfs_rui_log_item		*ruip;
+
+	ASSERT(tp != NULL);
+	ASSERT(nextents > 0);
+
+	ruip = xfs_rui_init(tp->t_mountp, nextents);
+	ASSERT(ruip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	return ruip;
+}
+
+/* Set the map extent flags for this reverse mapping. */
+static void
+xfs_trans_set_rmap_flags(
+	struct xfs_map_extent		*rmap,
+	enum xfs_rmap_intent_type	type,
+	int				whichfork,
+	xfs_exntst_t			state)
+{
+	rmap->me_flags = 0;
+	if (state == XFS_EXT_UNWRITTEN)
+		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
+	if (whichfork == XFS_ATTR_FORK)
+		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
+	switch (type) {
+	case XFS_RMAP_MAP:
+		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
+		break;
+	case XFS_RMAP_UNMAP:
+		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP;
+		break;
+	case XFS_RMAP_CONVERT:
+		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT;
+		break;
+	case XFS_RMAP_ALLOC:
+		rmap->me_flags |= XFS_RMAP_EXTENT_ALLOC;
+		break;
+	case XFS_RMAP_FREE:
+		rmap->me_flags |= XFS_RMAP_EXTENT_FREE;
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+/*
+ * This routine is called to indicate that the described reverse
+ * mapping is to be logged as needing to be updated.  It should be
+ * called once for each mapping.
+ */
+void
+xfs_trans_log_start_rmap_update(
+	struct xfs_trans		*tp,
+	struct xfs_rui_log_item		*ruip,
+	enum xfs_rmap_intent_type	type,
+	__uint64_t			owner,
+	int				whichfork,
+	xfs_fileoff_t			startoff,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			blockcount,
+	xfs_exntst_t			state)
+{
+	uint				next_extent;
+	struct xfs_map_extent		*rmap;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	ruip->rui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&ruip->rui_next_extent) - 1;
+	ASSERT(next_extent < ruip->rui_format.rui_nextents);
+	rmap = &(ruip->rui_format.rui_extents[next_extent]);
+	rmap->me_owner = owner;
+	rmap->me_startblock = startblock;
+	rmap->me_startoff = startoff;
+	rmap->me_len = blockcount;
+	xfs_trans_set_rmap_flags(rmap, type, whichfork, state);
+}
+
+
+/*
+ * This routine is called to allocate an "rmap update done"
+ * log item that will hold nextents worth of extents.  The
+ * caller must use all nextents extents, because we are not
+ * flexible about this at all.
+ */
+struct xfs_rud_log_item *
+xfs_trans_get_rud(
+	struct xfs_trans		*tp,
+	struct xfs_rui_log_item		*ruip,
+	uint				nextents)
+{
+	struct xfs_rud_log_item		*rudp;
+
+	ASSERT(tp != NULL);
+	ASSERT(nextents > 0);
+
+	rudp = xfs_rud_init(tp->t_mountp, ruip, nextents);
+	ASSERT(rudp != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &rudp->rud_item);
+	return rudp;
+}
+
+/*
+ * Finish an rmap update and log it to the RUD. Note that the transaction is
+ * marked dirty regardless of whether the rmap update succeeds or fails to
+ * support the RUI/RUD lifecycle rules.
+ */
+int
+xfs_trans_log_finish_rmap_update(
+	struct xfs_trans		*tp,
+	struct xfs_rud_log_item		*rudp,
+	enum xfs_rmap_intent_type	type,
+	__uint64_t			owner,
+	int				whichfork,
+	xfs_fileoff_t			startoff,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			blockcount,
+	xfs_exntst_t			state)
+{
+	uint				next_extent;
+	struct xfs_map_extent		*rmap;
+	int				error;
+
+	/* XXX: actually finish the rmap update here */
+	error = -EFSCORRUPTED;
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the RUI and frees the RUD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	rudp->rud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
+
+	next_extent = rudp->rud_next_extent;
+	ASSERT(next_extent < rudp->rud_format.rud_nextents);
+	rmap = &(rudp->rud_format.rud_extents[next_extent]);
+	rmap->me_owner = owner;
+	rmap->me_startblock = startblock;
+	rmap->me_startoff = startoff;
+	rmap->me_len = blockcount;
+	xfs_trans_set_rmap_flags(rmap, type, whichfork, state);
+	rudp->rud_next_extent++;
+
+	return error;
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
