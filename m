Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:39:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDd3rD022775
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:03 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F31F54BAE0
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id j6qlvGpHfXxohaoC for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSJB-0000IM-R4
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:39:01 +0000
Date: Mon, 27 Oct 2008 09:39:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] factor out xfs_read_agi helper
Message-ID: <20081027133901.GB1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-xfs_read_agi
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add a helper to read the AGI header and perform basic verification.
Based on hunks from a larger patch from Dave Chinner.

(First sent on Juli 23rd)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ag.h	2008-07-23 18:06:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ag.h	2008-07-23 19:47:29.000000000 +0200
@@ -142,6 +142,9 @@ typedef struct xfs_agi {
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
 #define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
+				xfs_agnumber_t agno, struct xfs_buf **bpp);
+
 /*
  * The third a.g. block contains the a.g. freelist, an array
  * of block pointers to blocks owned by the allocation btree code.
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-07-23 18:06:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-07-23 19:47:29.000000000 +0200
@@ -1370,70 +1370,95 @@ xfs_ialloc_log_agi(
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
+#ifdef DEBUG
+STATIC void
+xfs_check_agi_unlinked(
+	struct xfs_agi		*agi)
+{
+	int			i;
+
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
+		ASSERT(agi->agi_unlinked[i]);
+}
+#else
+#define xfs_check_agi_unlinked(agi)
+#endif
+
 /*
  * Read in the allocation group header (inode allocation section)
  */
 int
-xfs_ialloc_read_agi(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* allocation group hdr buf */
+xfs_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
-	xfs_agi_t	*agi;		/* allocation group header */
-	int		agi_ok;		/* agi is consistent */
-	xfs_buf_t	*bp;		/* allocation group hdr buf */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	int		error;
+	struct xfs_agi		*agi;	/* allocation group header */
+	int			agi_ok;	/* agi is consistent */
+	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp);
+			XFS_FSS_TO_BB(mp, 1), 0, bpp);
 	if (error)
 		return error;
-	ASSERT(bp && !XFS_BUF_GETERROR(bp));
+
+	ASSERT(*bpp && !XFS_BUF_GETERROR(*bpp));
+	agi = XFS_BUF_TO_AGI(*bpp);
 
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	agi = XFS_BUF_TO_AGI(bp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
+	agi_ok = be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
+		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
+		be32_to_cpu(agi->agi_seqno) == agno;
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
 			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR("xfs_ialloc_read_agi", XFS_ERRLEVEL_LOW,
+		XFS_CORRUPTION_ERROR("xfs_read_agi", XFS_ERRLEVEL_LOW,
 				     mp, agi);
-		xfs_trans_brelse(tp, bp);
+		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
+
+	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGI, XFS_AGI_REF);
+
+	xfs_check_agi_unlinked(agi);
+	return 0;
+}
+
+int
+xfs_ialloc_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
+{
+	struct xfs_agi		*agi;	/* allocation group header */
+	struct xfs_perag	*pag;	/* per allocation group data */
+	int			error;
+
+	error = xfs_read_agi(mp, tp, agno, bpp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(*bpp);
 	pag = &mp->m_perag[agno];
+
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
 		pag->pagi_init = 1;
-	} else {
-		/*
-		 * It's possible for these to be out of sync if
-		 * we are in the middle of a forced shutdown.
-		 */
-		ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-			XFS_FORCED_SHUTDOWN(mp));
-	}
-
-#ifdef DEBUG
-	{
-		int	i;
-
-		for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
-			ASSERT(agi->agi_unlinked[i]);
 	}
-#endif
 
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGI, XFS_AGI_REF);
-	*bpp = bp;
+	/*
+	 * It's possible for these to be out of sync if
+	 * we are in the middle of a forced shutdown.
+	 */
+	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
+		XFS_FORCED_SHUTDOWN(mp));
 	return 0;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-07-23 19:45:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-07-23 19:47:29.000000000 +0200
@@ -1776,13 +1776,10 @@ xfs_iunlink(
 	xfs_dinode_t	*dip;
 	xfs_buf_t	*agibp;
 	xfs_buf_t	*ibp;
-	xfs_agnumber_t	agno;
-	xfs_daddr_t	agdaddr;
 	xfs_agino_t	agino;
 	short		bucket_index;
 	int		offset;
 	int		error;
-	int		agi_ok;
 
 	ASSERT(ip->i_d.di_nlink == 0);
 	ASSERT(ip->i_d.di_mode != 0);
@@ -1790,31 +1787,15 @@ xfs_iunlink(
 
 	mp = tp->t_mountp;
 
-	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	agdaddr = XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp));
-
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
 	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, agdaddr,
-				   XFS_FSS_TO_BB(mp, 1), 0, &agibp);
+	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
 	if (error)
 		return error;
-
-	/*
-	 * Validate the magic number of the agi block.
-	 */
 	agi = XFS_BUF_TO_AGI(agibp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IUNLINK,
-			XFS_RANDOM_IUNLINK))) {
-		XFS_CORRUPTION_ERROR("xfs_iunlink", XFS_ERRLEVEL_LOW, mp, agi);
-		xfs_trans_brelse(tp, agibp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
+
 	/*
 	 * Get the index into the agi hash table for the
 	 * list this inode will go on.
@@ -1874,7 +1855,6 @@ xfs_iunlink_remove(
 	xfs_buf_t	*agibp;
 	xfs_buf_t	*ibp;
 	xfs_agnumber_t	agno;
-	xfs_daddr_t	agdaddr;
 	xfs_agino_t	agino;
 	xfs_agino_t	next_agino;
 	xfs_buf_t	*last_ibp;
@@ -1882,45 +1862,23 @@ xfs_iunlink_remove(
 	short		bucket_index;
 	int		offset, last_offset = 0;
 	int		error;
-	int		agi_ok;
 
-	/*
-	 * First pull the on-disk inode from the AGI unlinked list.
-	 */
 	mp = tp->t_mountp;
-
 	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	agdaddr = XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp));
 
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
 	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, agdaddr,
-				   XFS_FSS_TO_BB(mp, 1), 0, &agibp);
+	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error) {
 		cmn_err(CE_WARN,
-			"xfs_iunlink_remove: xfs_trans_read_buf()  returned an error %d on %s.  Returning error.",
+			"xfs_iunlink_remove: xfs_read_agi() returned an error %d on %s. Returning error.",
 			error, mp->m_fsname);
 		return error;
 	}
-	/*
-	 * Validate the magic number of the agi block.
-	 */
 	agi = XFS_BUF_TO_AGI(agibp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IUNLINK_REMOVE,
-			XFS_RANDOM_IUNLINK_REMOVE))) {
-		XFS_CORRUPTION_ERROR("xfs_iunlink_remove", XFS_ERRLEVEL_LOW,
-				     mp, agi);
-		xfs_trans_brelse(tp, agibp);
-		cmn_err(CE_WARN,
-			"xfs_iunlink_remove: XFS_TEST_ERROR()  returned an error on %s.  Returning EFSCORRUPTED.",
-			 mp->m_fsname);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
+
 	/*
 	 * Get the index into the agi hash table for the
 	 * list this inode will go on.
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-07-23 18:06:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-07-23 19:47:29.000000000 +0200
@@ -3134,19 +3134,16 @@ xlog_recover_clear_agi_bucket(
 	int		error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_CLEAR_AGI_BUCKET);
-	error = xfs_trans_reserve(tp, 0, XFS_CLEAR_AGI_BUCKET_LOG_RES(mp), 0, 0, 0);
-	if (!error)
-		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-				   XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				   XFS_FSS_TO_BB(mp, 1), 0, &agibp);
+	error = xfs_trans_reserve(tp, 0, XFS_CLEAR_AGI_BUCKET_LOG_RES(mp),
+				  0, 0, 0);
 	if (error)
 		goto out_abort;
 
-	error = EINVAL;
-	agi = XFS_BUF_TO_AGI(agibp);
-	if (be32_to_cpu(agi->agi_magicnum) != XFS_AGI_MAGIC)
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
 		goto out_abort;
 
+	agi = XFS_BUF_TO_AGI(agibp);
 	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		 (sizeof(xfs_agino_t) * bucket);
@@ -3207,16 +3204,21 @@ xlog_recover_process_iunlinks(
 		/*
 		 * Find the agi for this ag.
 		 */
-		agibp = xfs_buf_read(mp->m_ddev_targp,
-				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				XFS_FSS_TO_BB(mp, 1), 0);
-		if (XFS_BUF_ISERROR(agibp)) {
-			xfs_ioerror_alert("xlog_recover_process_iunlinks(#1)",
-				log->l_mp, agibp,
-				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)));
+		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		if (error) {
+			/*
+			 * AGI is b0rked. Don't process it.
+			 *
+			 * We should probably mark the filesystem as corrupt
+			 * after we've recovered all the ag's we can....
+			 */
+			xfs_fs_cmn_err(CE_ALERT, mp,
+					"xlog_recover_process_iunlinks(#1)"
+					"agi read failed agno %d error %d",
+					agno, error);
+			continue;
 		}
 		agi = XFS_BUF_TO_AGI(agibp);
-		ASSERT(XFS_AGI_MAGIC == be32_to_cpu(agi->agi_magicnum));
 
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
 
@@ -3295,22 +3297,18 @@ xlog_recover_process_iunlinks(
 
 				/*
 				 * Reacquire the agibuffer and continue around
-				 * the loop.
+				 * the loop. This should never fail as we know
+				 * the buffer was good earlier on.
 				 */
-				agibp = xfs_buf_read(mp->m_ddev_targp,
-						XFS_AG_DADDR(mp, agno,
-							XFS_AGI_DADDR(mp)),
-						XFS_FSS_TO_BB(mp, 1), 0);
-				if (XFS_BUF_ISERROR(agibp)) {
-					xfs_ioerror_alert(
-				"xlog_recover_process_iunlinks(#2)",
-						log->l_mp, agibp,
-						XFS_AG_DADDR(mp, agno,
-							XFS_AGI_DADDR(mp)));
+				error = xfs_read_agi(mp, NULL, agno, &agibp);
+				ASSERT(error == 0);
+				if (error) {
+					xfs_fs_cmn_err(CE_ALERT, mp,
+					"xlog_recover_process_iunlinks(#2)"
+					"agi read failed agno %d error %d",
+							agno, error);
 				}
 				agi = XFS_BUF_TO_AGI(agibp);
-				ASSERT(XFS_AGI_MAGIC == be32_to_cpu(
-					agi->agi_magicnum));
 			}
 		}
 
@@ -4004,7 +4002,6 @@ xlog_recover_check_summary(
 	xfs_buf_t	*agfbp;
 	xfs_buf_t	*agibp;
 	xfs_daddr_t	agfdaddr;
-	xfs_daddr_t	agidaddr;
 	xfs_buf_t	*sbbp;
 #ifdef XFS_LOUD_RECOVERY
 	xfs_sb_t	*sbp;
@@ -4013,6 +4010,7 @@ xlog_recover_check_summary(
 	__uint64_t	freeblks;
 	__uint64_t	itotal;
 	__uint64_t	ifree;
+	int		error;
 
 	mp = log->l_mp;
 
@@ -4036,21 +4034,19 @@ xlog_recover_check_summary(
 			    be32_to_cpu(agfp->agf_flcount);
 		xfs_buf_relse(agfbp);
 
-		agidaddr = XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp));
-		agibp = xfs_buf_read(mp->m_ddev_targp, agidaddr,
-				XFS_FSS_TO_BB(mp, 1), 0);
-		if (XFS_BUF_ISERROR(agibp)) {
-			xfs_ioerror_alert("xlog_recover_check_summary(agi)",
-					  mp, agibp, agidaddr);
-		}
-		agip = XFS_BUF_TO_AGI(agibp);
-		ASSERT(XFS_AGI_MAGIC == be32_to_cpu(agip->agi_magicnum));
-		ASSERT(XFS_AGI_GOOD_VERSION(be32_to_cpu(agip->agi_versionnum)));
-		ASSERT(be32_to_cpu(agip->agi_seqno) == agno);
+		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		if (error) {
+			xfs_fs_cmn_err(CE_ALERT, mp,
+					"xlog_recover_check_summary(agi)"
+					"agi read failed agno %d error %d",
+							agno, error);
+		} else {
+			agip = XFS_BUF_TO_AGI(agibp);
 
-		itotal += be32_to_cpu(agip->agi_count);
-		ifree += be32_to_cpu(agip->agi_freecount);
-		xfs_buf_relse(agibp);
+			itotal += be32_to_cpu(agip->agi_count);
+			ifree += be32_to_cpu(agip->agi_freecount);
+			xfs_buf_relse(agibp);
+		}
 	}
 
 	sbbp = xfs_getsb(mp, 0);

-- 
