Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 15:54:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PMsmN3024236
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:54:49 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8A851AF1D23
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:23 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id kwMxIkTbMQcdmiM3 for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:23 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8PMuMIF009867
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:56:22 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8PMuM5k009865
	for xfs@oss.sgi.com; Fri, 26 Sep 2008 00:56:22 +0200
Date: Fri, 26 Sep 2008 00:56:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] factor out xfs_read_agf helper
Message-ID: <20080925225622.GC9822@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-xfs_read_agf
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add a helper to read the AGF header and perform basic verification.
Based on hunks from a larger patch from Dave Chinner.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ag.h	2008-09-25 12:27:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ag.h	2008-09-25 13:58:18.000000000 +0200
@@ -91,6 +91,8 @@ typedef struct xfs_agf {
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
 #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 
 /*
  * Size of the unlinked inode hash table in the agi.
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-09-25 12:27:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-09-25 13:58:38.000000000 +0200
@@ -2233,51 +2233,80 @@ xfs_alloc_put_freelist(
  * Read in the allocation group header (free/alloc section).
  */
 int					/* error */
-xfs_alloc_read_agf(
-	xfs_mount_t	*mp,		/* mount point structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	int		flags,		/* XFS_ALLOC_FLAG_... */
-	xfs_buf_t	**bpp)		/* buffer for the ag freelist header */
+xfs_read_agf(
+	struct xfs_mount	*mp,	/* mount point structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	int			flags,	/* XFS_BUF_ */
+	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
 {
-	xfs_agf_t	*agf;		/* ag freelist header */
+	struct xfs_agf	*agf;		/* ag freelist header */
 	int		agf_ok;		/* set if agf is consistent */
-	xfs_buf_t	*bp;		/* return value */
-	xfs_perag_t	*pag;		/* per allocation group data */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1),
-			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XFS_BUF_TRYLOCK : 0U,
-			&bp);
+			XFS_FSS_TO_BB(mp, 1), flags, bpp);
 	if (error)
 		return error;
-	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (!bp) {
-		*bpp = NULL;
+	if (!*bpp)
 		return 0;
-	}
+
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	agf = XFS_BUF_TO_AGF(*bpp);
+
 	/*
 	 * Validate the magic number of the agf block.
 	 */
-	agf = XFS_BUF_TO_AGF(bp);
 	agf_ok =
 		be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
 		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
 		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
+		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
+		be32_to_cpu(agf->agf_seqno) == agno;
 	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
 			XFS_RANDOM_ALLOC_READ_AGF))) {
 		XFS_CORRUPTION_ERROR("xfs_alloc_read_agf",
 				     XFS_ERRLEVEL_LOW, mp, agf);
-		xfs_trans_brelse(tp, bp);
+		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
+
+	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
+	return 0;
+}
+
+/*
+ * Read in the allocation group header (free/alloc section).
+ */
+int					/* error */
+xfs_alloc_read_agf(
+	struct xfs_mount	*mp,	/* mount point structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	int			flags,	/* XFS_ALLOC_FLAG_... */
+	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
+{
+	struct xfs_agf		*agf;		/* ag freelist header */
+	struct xfs_perag	*pag;		/* per allocation group data */
+	int			error;
+
+	ASSERT(agno != NULLAGNUMBER);
+
+	error = xfs_read_agf(mp, tp, agno,
+			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XFS_BUF_TRYLOCK : 0,
+			bpp);
+	if (error)
+		return error;
+	if (!*bpp)
+		return 0;
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+
+	agf = XFS_BUF_TO_AGF(*bpp);
 	pag = &mp->m_perag[agno];
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
@@ -2304,8 +2333,6 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGF, XFS_AGF_REF);
-	*bpp = bp;
 	return 0;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-25 12:27:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-25 13:58:24.000000000 +0200
@@ -3998,7 +3998,6 @@ xlog_recover_check_summary(
 	xfs_agi_t	*agip;
 	xfs_buf_t	*agfbp;
 	xfs_buf_t	*agibp;
-	xfs_daddr_t	agfdaddr;
 	xfs_buf_t	*sbbp;
 #ifdef XFS_LOUD_RECOVERY
 	xfs_sb_t	*sbp;
@@ -4015,21 +4014,18 @@ xlog_recover_check_summary(
 	itotal = 0LL;
 	ifree = 0LL;
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		agfdaddr = XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp));
-		agfbp = xfs_buf_read(mp->m_ddev_targp, agfdaddr,
-				XFS_FSS_TO_BB(mp, 1), 0);
-		if (XFS_BUF_ISERROR(agfbp)) {
-			xfs_ioerror_alert("xlog_recover_check_summary(agf)",
-						mp, agfbp, agfdaddr);
+		error = xfs_read_agf(mp, NULL, agno, 0, &agfbp);
+		if (error) {
+			xfs_fs_cmn_err(CE_ALERT, mp,
+					"xlog_recover_check_summary(agf)"
+					"agf read failed agno %d error %d",
+							agno, error);
+		} else {
+			agfp = XFS_BUF_TO_AGF(agfbp);
+			freeblks += be32_to_cpu(agfp->agf_freeblks) +
+				    be32_to_cpu(agfp->agf_flcount);
+			xfs_buf_relse(agfbp);
 		}
-		agfp = XFS_BUF_TO_AGF(agfbp);
-		ASSERT(XFS_AGF_MAGIC == be32_to_cpu(agfp->agf_magicnum));
-		ASSERT(XFS_AGF_GOOD_VERSION(be32_to_cpu(agfp->agf_versionnum)));
-		ASSERT(be32_to_cpu(agfp->agf_seqno) == agno);
-
-		freeblks += be32_to_cpu(agfp->agf_freeblks) +
-			    be32_to_cpu(agfp->agf_flcount);
-		xfs_buf_relse(agfbp);
 
 		error = xfs_read_agi(mp, NULL, agno, &agibp);
 		if (error) {

-- 
