Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB52C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjBPU4N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjBPU4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:56:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410A34E5C5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCAB4B82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C13C433EF;
        Thu, 16 Feb 2023 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580967;
        bh=Oe0vtEnajby24/YMbaStKIJblIJwTqMapF7EqRcEV0E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PJ5AQWzSCjjRTTI5XoM/b3o/VdRUALibcsZsZ9lzD3BWT9Hbk92yvz4zbC2lFIcJQ
         A3b7RHy/CDgxc9TPFGcVexfXZYrWaC5sWMTVQjlRh9sfhX8+34rWE3lNl+l5ycMlzW
         Cdus2iQzv182ObyeXwRiX7/VNRxZXXdGoFu7vdsVf6loTRLyq8aiK0ejm6DNE+AEeI
         o+4iD+i4tEiSNYjgTy65BB3cKUr7sjhYrZzqgaiB/IF7gmwc9ba9dPGMTfzziFTMMR
         CjYyU9L6OHWNTuUyVb3ixMxbNTVNTm5vpqDN48Y9Wx5Xq7k4UwoZIl4+sRogWlJW/O
         LVLorRCaJ2sEw==
Date:   Thu, 16 Feb 2023 12:56:07 -0800
Subject: [PATCH 10/25] xfsprogs: extend transaction reservations for parent
 attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879036.3476112.16087980108025238104.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 99c10e460207a624b3e243e4a3665737d436d08c

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
[djwong: fix indentation errors]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h    |    1 
 libxfs/xfs_trans_resv.c |  322 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 271 insertions(+), 52 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 567bd237..9dec26f9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -521,6 +521,7 @@ static inline int retzero(void) { return 0; }
 
 #define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
+#define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
 
 /*
  * Prototypes for kernel static functions that are aren't in their
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 04c44480..50315738 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
+#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -419,29 +420,108 @@ xfs_calc_itruncate_reservation_minlogsize(
 	return xfs_calc_itruncate_reservation(mp, true);
 }
 
+static inline unsigned int xfs_calc_pptr_link_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_replace_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+
 /*
  * In renaming a files we can modify:
  *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
+ *	of bmap blocks) giving (t2):
  *    the agf for the ags in which the blocks live: 3 * sector size
  *    the agfl for the ags in which the blocks live: 3 * sector size
  *    the superblock for the free block count: sector size
  *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ * If parent pointers are enabled (t3), then each transaction in the chain
+ *    must be capable of setting or removing the extended attribute
+ *    containing the parent information.  It must also be able to handle
+ *    the three xattr intent items that track the progress of the parent
+ *    pointer update.
  */
 STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 5) +
-		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_inode_res(mp, 5) +
+	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+			XFS_FSB_TO_B(mp, 1));
+
+	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
+			XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		unsigned int	rename_overhead, exchange_overhead;
+
+		t3 = max(resp->tr_attrsetm.tr_logres,
+			 resp->tr_attrrm.tr_logres);
+
+		/*
+		 * For a standard rename, the three xattr intent log items
+		 * are (1) replacing the pptr for the source file; (2)
+		 * removing the pptr on the dest file; and (3) adding a
+		 * pptr for the whiteout file in the src dir.
+		 *
+		 * For an RENAME_EXCHANGE, there are two xattr intent
+		 * items to replace the pptr for both src and dest
+		 * files.  Link counts don't change and there is no
+		 * whiteout.
+		 *
+		 * In the worst case we can end up relogging all log
+		 * intent items to allow the log tail to move ahead, so
+		 * they become overhead added to each transaction in a
+		 * processing chain.
+		 */
+		rename_overhead = xfs_calc_pptr_replace_overhead() +
+				  xfs_calc_pptr_unlink_overhead() +
+				  xfs_calc_pptr_link_overhead();
+		exchange_overhead = 2 * xfs_calc_pptr_replace_overhead();
+
+		overhead += max(rename_overhead, exchange_overhead);
+	}
+
+	return overhead + max3(t1, t2, t3);
+}
+
+static inline unsigned int
+xfs_rename_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	/* One for the rename, one more for freeing blocks */
+	unsigned int		ret = XFS_RENAME_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to remove or add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += max(resp->tr_attrsetm.tr_logcount,
+			   resp->tr_attrrm.tr_logcount);
+
+	return ret;
 }
 
 /*
@@ -458,6 +538,23 @@ xfs_calc_iunlink_remove_reservation(
 	       2 * M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_link_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_LINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For creating a link to an inode:
  *    the parent directory inode: inode size
@@ -474,14 +571,23 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_remove_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_remove_reservation(mp);
+	t1 = xfs_calc_inode_res(mp, 2) +
+	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -496,6 +602,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 			M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_remove_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_REMOVE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrrm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -512,14 +635,24 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_add_reservation(mp);
+
+	t1 = xfs_calc_inode_res(mp, 2) +
+	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += xfs_calc_pptr_unlink_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -568,12 +701,40 @@ xfs_calc_icreate_resv_alloc(
 		xfs_calc_finobt_res(mp);
 }
 
+static inline unsigned int
+xfs_icreate_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_CREATE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 STATIC uint
-xfs_calc_icreate_reservation(xfs_mount_t *mp)
+xfs_calc_icreate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max(xfs_calc_icreate_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_icreate_resv_alloc(mp);
+	t2 = xfs_calc_create_resv_modify(mp);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 STATIC uint
@@ -586,6 +747,23 @@ xfs_calc_create_tmpfile_reservation(
 	return res + xfs_calc_iunlink_add_reservation(mp);
 }
 
+static inline unsigned int
+xfs_mkdir_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_MKDIR_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * Making a new directory is the same as creating a new file.
  */
@@ -596,6 +774,22 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_icreate_reservation(mp);
 }
 
+static inline unsigned int
+xfs_symlink_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_SYMLINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
 
 /*
  * Making a new symplink is the same as creating a new file, but
@@ -908,6 +1102,52 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This requires that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
+
+	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
+	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
+	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
+	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
+	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
+	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
+	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
+	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
+	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
+	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
+	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -927,35 +1167,11 @@ xfs_trans_resv_calc(
 	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
-	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
-	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
-	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
-	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
-	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
-	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
-	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
-	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
-	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
-	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -985,6 +1201,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.

