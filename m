Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1M5RQt236332 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 16:05:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ADB44F05FE
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 14:07:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2bOMalUQXXzbFOuE for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 14:07:11 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PNupS-0007oH-MP
	for xfs@oss.sgi.com; Wed, 01 Dec 2010 22:07:10 +0000
Message-Id: <20101201220710.647499265@bombadil.infradead.org>
Date: Wed, 01 Dec 2010 17:06:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: untangle phase1 vs phase2 recovery helpers
References: <20101201220620.340188389@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-split-log-recovery-passes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dispatch to a different helper for phase1 vs phase2 in xlog_recover_commit_trans
instead of doing it in all the low-level functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-12-01 17:03:04.922253529 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2010-12-01 17:12:29.318255483 +0100
@@ -1616,11 +1616,12 @@ xlog_recover_reorder_trans(
  * record in the table to tell us how many times we expect to see this
  * record during the second pass.
  */
-STATIC void
-xlog_recover_do_buffer_pass1(
+STATIC int
+xlog_recover_buffer_pass1(
 	struct log		*log,
-	xfs_buf_log_format_t	*buf_f)
+	xlog_recover_item_t	*item)
 {
+	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 	struct list_head	*bucket;
 	struct xfs_buf_cancel	*bcp;
 
@@ -1629,7 +1630,7 @@ xlog_recover_do_buffer_pass1(
 	 */
 	if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
 		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
-		return;
+		return 0;
 	}
 
 	/*
@@ -1642,7 +1643,7 @@ xlog_recover_do_buffer_pass1(
 		    bcp->bc_len == buf_f->blf_len) {
 			bcp->bc_refcount++;
 			trace_xfs_log_recover_buf_cancel_ref_inc(log, buf_f);
-			return;
+			return 0;
 		}
 	}
 
@@ -1653,6 +1654,7 @@ xlog_recover_do_buffer_pass1(
 	list_add_tail(&bcp->bc_list, bucket);
 
 	trace_xfs_log_recover_buf_cancel_add(log, buf_f);
+	return 0;
 }
 
 /*
@@ -2081,10 +2083,9 @@ xlog_recover_do_dquot_buffer(
  * for more details on the implementation of the table of cancel records.
  */
 STATIC int
-xlog_recover_do_buffer_trans(
+xlog_recover_buffer_pass2(
 	xlog_t			*log,
-	xlog_recover_item_t	*item,
-	int			pass)
+	xlog_recover_item_t	*item)
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 	xfs_mount_t		*mp = log->l_mp;
@@ -2092,27 +2093,16 @@ xlog_recover_do_buffer_trans(
 	int			error;
 	uint			buf_flags;
 
-	if (pass == XLOG_RECOVER_PASS1) {
-		/*
-		 * In this pass we're only looking for buf items
-		 * with the XFS_BLF_CANCEL bit set.
-		 */
-		xlog_recover_do_buffer_pass1(log, buf_f);
+	/*
+	 * In this pass we only want to recover all the buffers which have
+	 * not been cancelled and are not cancellation buffers themselves.
+	 */
+	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
+			buf_f->blf_len, buf_f->blf_flags)) {
+		trace_xfs_log_recover_buf_cancel(log, buf_f);
 		return 0;
-	} else {
-		/*
-		 * In this pass we want to recover all the buffers
-		 * which have not been cancelled and are not
-		 * cancellation buffers themselves.  The routine
-		 * we call here will tell us whether or not to
-		 * continue with the replay of this buffer.
-		 */
-		if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
-				buf_f->blf_len, buf_f->blf_flags)) {
-			trace_xfs_log_recover_buf_cancel(log, buf_f);
-			return 0;
-		}
 	}
+
 	trace_xfs_log_recover_buf_recover(log, buf_f);
 
 	buf_flags = XBF_LOCK;
@@ -2172,16 +2162,14 @@ xlog_recover_do_buffer_trans(
 }
 
 STATIC int
-xlog_recover_do_inode_trans(
+xlog_recover_inode_pass2(
 	xlog_t			*log,
-	xlog_recover_item_t	*item,
-	int			pass)
+	xlog_recover_item_t	*item)
 {
 	xfs_inode_log_format_t	*in_f;
-	xfs_mount_t		*mp;
+	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
 	xfs_dinode_t		*dip;
-	xfs_ino_t		ino;
 	int			len;
 	xfs_caddr_t		src;
 	xfs_caddr_t		dest;
@@ -2191,10 +2179,6 @@ xlog_recover_do_inode_trans(
 	xfs_icdinode_t		*dicp;
 	int			need_free = 0;
 
-	if (pass == XLOG_RECOVER_PASS1) {
-		return 0;
-	}
-
 	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
 		in_f = item->ri_buf[0].i_addr;
 	} else {
@@ -2204,8 +2188,6 @@ xlog_recover_do_inode_trans(
 		if (error)
 			goto error;
 	}
-	ino = in_f->ilf_ino;
-	mp = log->l_mp;
 
 	/*
 	 * Inode buffers can be freed, look out for it,
@@ -2240,8 +2222,8 @@ xlog_recover_do_inode_trans(
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
 			"xfs_inode_recover: Bad inode magic number, dino ptr = 0x%p, dino bp = 0x%p, ino = %Ld",
-			dip, bp, ino);
-		XFS_ERROR_REPORT("xlog_recover_do_inode_trans(1)",
+			dip, bp, in_f->ilf_ino);
+		XFS_ERROR_REPORT("xlog_recover_inode_pass2(1)",
 				 XFS_ERRLEVEL_LOW, mp);
 		error = EFSCORRUPTED;
 		goto error;
@@ -2251,8 +2233,8 @@ xlog_recover_do_inode_trans(
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
 			"xfs_inode_recover: Bad inode log record, rec ptr 0x%p, ino %Ld",
-			item, ino);
-		XFS_ERROR_REPORT("xlog_recover_do_inode_trans(2)",
+			item, in_f->ilf_ino);
+		XFS_ERROR_REPORT("xlog_recover_inode_pass2(2)",
 				 XFS_ERRLEVEL_LOW, mp);
 		error = EFSCORRUPTED;
 		goto error;
@@ -2280,12 +2262,12 @@ xlog_recover_do_inode_trans(
 	if (unlikely((dicp->di_mode & S_IFMT) == S_IFREG)) {
 		if ((dicp->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (dicp->di_format != XFS_DINODE_FMT_BTREE)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_do_inode_trans(3)",
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
 					 XFS_ERRLEVEL_LOW, mp, dicp);
 			xfs_buf_relse(bp);
 			xfs_fs_cmn_err(CE_ALERT, mp,
 				"xfs_inode_recover: Bad regular inode log record, rec ptr 0x%p, ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
-				item, dip, bp, ino);
+				item, dip, bp, in_f->ilf_ino);
 			error = EFSCORRUPTED;
 			goto error;
 		}
@@ -2293,40 +2275,40 @@ xlog_recover_do_inode_trans(
 		if ((dicp->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (dicp->di_format != XFS_DINODE_FMT_BTREE) &&
 		    (dicp->di_format != XFS_DINODE_FMT_LOCAL)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_do_inode_trans(4)",
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
 					     XFS_ERRLEVEL_LOW, mp, dicp);
 			xfs_buf_relse(bp);
 			xfs_fs_cmn_err(CE_ALERT, mp,
 				"xfs_inode_recover: Bad dir inode log record, rec ptr 0x%p, ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
-				item, dip, bp, ino);
+				item, dip, bp, in_f->ilf_ino);
 			error = EFSCORRUPTED;
 			goto error;
 		}
 	}
 	if (unlikely(dicp->di_nextents + dicp->di_anextents > dicp->di_nblocks)){
-		XFS_CORRUPTION_ERROR("xlog_recover_do_inode_trans(5)",
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
 			"xfs_inode_recover: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, dino bp 0x%p, ino %Ld, total extents = %d, nblocks = %Ld",
-			item, dip, bp, ino,
+			item, dip, bp, in_f->ilf_ino,
 			dicp->di_nextents + dicp->di_anextents,
 			dicp->di_nblocks);
 		error = EFSCORRUPTED;
 		goto error;
 	}
 	if (unlikely(dicp->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_do_inode_trans(6)",
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
 			"xfs_inode_recover: Bad inode log rec ptr 0x%p, dino ptr 0x%p, dino bp 0x%p, ino %Ld, forkoff 0x%x",
-			item, dip, bp, ino, dicp->di_forkoff);
+			item, dip, bp, in_f->ilf_ino, dicp->di_forkoff);
 		error = EFSCORRUPTED;
 		goto error;
 	}
 	if (unlikely(item->ri_buf[1].i_len > sizeof(struct xfs_icdinode))) {
-		XFS_CORRUPTION_ERROR("xlog_recover_do_inode_trans(7)",
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
@@ -2418,7 +2400,7 @@ xlog_recover_do_inode_trans(
 			break;
 
 		default:
-			xlog_warn("XFS: xlog_recover_do_inode_trans: Invalid flag");
+			xlog_warn("XFS: xlog_recover_inode_pass2: Invalid flag");
 			ASSERT(0);
 			xfs_buf_relse(bp);
 			error = EIO;
@@ -2442,18 +2424,11 @@ error:
  * of that type.
  */
 STATIC int
-xlog_recover_do_quotaoff_trans(
+xlog_recover_quotaoff_pass1(
 	xlog_t			*log,
-	xlog_recover_item_t	*item,
-	int			pass)
+	xlog_recover_item_t	*item)
 {
-	xfs_qoff_logformat_t	*qoff_f;
-
-	if (pass == XLOG_RECOVER_PASS2) {
-		return (0);
-	}
-
-	qoff_f = item->ri_buf[0].i_addr;
+	xfs_qoff_logformat_t	*qoff_f = item->ri_buf[0].i_addr;
 	ASSERT(qoff_f);
 
 	/*
@@ -2474,22 +2449,17 @@ xlog_recover_do_quotaoff_trans(
  * Recover a dquot record
  */
 STATIC int
-xlog_recover_do_dquot_trans(
+xlog_recover_dquot_pass2(
 	xlog_t			*log,
-	xlog_recover_item_t	*item,
-	int			pass)
+	xlog_recover_item_t	*item)
 {
-	xfs_mount_t		*mp;
+	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
 	struct xfs_disk_dquot	*ddq, *recddq;
 	int			error;
 	xfs_dq_logformat_t	*dq_f;
 	uint			type;
 
-	if (pass == XLOG_RECOVER_PASS1) {
-		return 0;
-	}
-	mp = log->l_mp;
 
 	/*
 	 * Filesystems are required to send in quota flags at mount time.
@@ -2533,7 +2503,7 @@ xlog_recover_do_dquot_trans(
 	if ((error = xfs_qm_dqcheck(recddq,
 			   dq_f->qlf_id,
 			   0, XFS_QMOPT_DOWARN,
-			   "xlog_recover_do_dquot_trans (log copy)"))) {
+			   "xlog_recover_dquot_pass2 (log copy)"))) {
 		return XFS_ERROR(EIO);
 	}
 	ASSERT(dq_f->qlf_len == 1);
@@ -2556,7 +2526,7 @@ xlog_recover_do_dquot_trans(
 	 * minimal initialization then.
 	 */
 	if (xfs_qm_dqcheck(ddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
-			   "xlog_recover_do_dquot_trans")) {
+			   "xlog_recover_dquot_pass2")) {
 		xfs_buf_relse(bp);
 		return XFS_ERROR(EIO);
 	}
@@ -2579,24 +2549,18 @@ xlog_recover_do_dquot_trans(
  * LSN.
  */
 STATIC int
-xlog_recover_do_efi_trans(
+xlog_recover_efi_pass2(
 	xlog_t			*log,
 	xlog_recover_item_t	*item,
-	xfs_lsn_t		lsn,
-	int			pass)
+	xfs_lsn_t		lsn)
 {
 	int			error;
-	xfs_mount_t		*mp;
+	xfs_mount_t		*mp = log->l_mp;
 	xfs_efi_log_item_t	*efip;
 	xfs_efi_log_format_t	*efi_formatp;
 
-	if (pass == XLOG_RECOVER_PASS1) {
-		return 0;
-	}
-
 	efi_formatp = item->ri_buf[0].i_addr;
 
-	mp = log->l_mp;
 	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
 	if ((error = xfs_efi_copy_format(&(item->ri_buf[0]),
 					 &(efip->efi_format)))) {
@@ -2623,11 +2587,10 @@ xlog_recover_do_efi_trans(
  * efd format structure.  If we find it, we remove the efi from the
  * AIL and free it.
  */
-STATIC void
-xlog_recover_do_efd_trans(
+STATIC int
+xlog_recover_efd_pass2(
 	xlog_t			*log,
-	xlog_recover_item_t	*item,
-	int			pass)
+	xlog_recover_item_t	*item)
 {
 	xfs_efd_log_format_t	*efd_formatp;
 	xfs_efi_log_item_t	*efip = NULL;
@@ -2636,10 +2599,6 @@ xlog_recover_do_efd_trans(
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp = log->l_ailp;
 
-	if (pass == XLOG_RECOVER_PASS1) {
-		return;
-	}
-
 	efd_formatp = item->ri_buf[0].i_addr;
 	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
 		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
@@ -2671,6 +2630,8 @@ xlog_recover_do_efd_trans(
 	}
 	xfs_trans_ail_cursor_done(ailp, &cur);
 	spin_unlock(&ailp->xa_lock);
+
+	return 0;
 }
 
 /*
@@ -2699,32 +2660,59 @@ xlog_recover_free_trans(
 }
 
 STATIC int
-xlog_recover_commit_item(
+xlog_recover_commit_pass1(
 	struct log		*log,
 	struct xlog_recover	*trans,
-	xlog_recover_item_t	*item,
-	int			pass)
+	xlog_recover_item_t	*item)
 {
-	trace_xfs_log_recover_item_recover(log, trans, item, pass);
+	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS1);
 
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_BUF:
-		return xlog_recover_do_buffer_trans(log, item, pass);
-		break;
+		return xlog_recover_buffer_pass1(log, item);
+	case XFS_LI_QUOTAOFF:
+		return xlog_recover_quotaoff_pass1(log, item);
 	case XFS_LI_INODE:
-		return xlog_recover_do_inode_trans(log, item, pass);
 	case XFS_LI_EFI:
-		return xlog_recover_do_efi_trans(log, item, trans->r_lsn, pass);
 	case XFS_LI_EFD:
-		xlog_recover_do_efd_trans(log, item, pass);
+	case XFS_LI_DQUOT:
+		/* nothing to do in pass 1 */
 		return 0;
+	default:
+		xlog_warn(
+	"XFS: invalid item type (%d) xlog_recover_commit_pass1",
+			ITEM_TYPE(item));
+		ASSERT(0);
+		return XFS_ERROR(EIO);
+	}
+}
+
+STATIC int
+xlog_recover_commit_pass2(
+	struct log		*log,
+	struct xlog_recover	*trans,
+	xlog_recover_item_t	*item)
+{
+	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
+
+	switch (ITEM_TYPE(item)) {
+	case XFS_LI_BUF:
+		return xlog_recover_buffer_pass2(log, item);
+	case XFS_LI_INODE:
+		return xlog_recover_inode_pass2(log, item);
+	case XFS_LI_EFI:
+		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
+	case XFS_LI_EFD:
+		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_DQUOT:
-		return xlog_recover_do_dquot_trans(log, item, pass);
+		return xlog_recover_dquot_pass2(log, item);
 	case XFS_LI_QUOTAOFF:
-		return xlog_recover_do_quotaoff_trans(log, item, pass);
+		/* nothing to do in pass2 */
+		return 0;
 	default:
 		xlog_warn(
-	"XFS: invalid item type (%d) xlog_recover_do_trans", ITEM_TYPE(item));
+	"XFS: invalid item type (%d) xlog_recover_commit_pass2",
+			ITEM_TYPE(item));
 		ASSERT(0);
 		return XFS_ERROR(EIO);
 	}
@@ -2752,7 +2740,10 @@ xlog_recover_commit_trans(
 		return error;
 
 	list_for_each_entry(item, &trans->r_itemq, ri_list) {
-		error = xlog_recover_commit_item(log, trans, item, pass);
+		if (pass == XLOG_RECOVER_PASS1)
+			error = xlog_recover_commit_pass1(log, trans, item);
+		else
+			error = xlog_recover_commit_pass2(log, trans, item);
 		if (error)
 			return error;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
