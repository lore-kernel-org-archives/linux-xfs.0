Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUlke073601 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16E9F105D79
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KW8WgRxWC4UX39y0 for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:30:11 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEj-0005oM-7v
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:41 +0000
Message-Id: <20090210202941.150266000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/13] xfs: add CRC checks to the AGFL
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-agfl-crc
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

Add CRC checks, location information and a magic number to the AGFL.
Previously the AGFL was just a block containing nothing but the
free block pointers.  The new AGFL has a real header with the usual
boilerplate instead, so that we can verify it's not corrupted and
written into the right place.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2009-02-09 19:15:48.966944136 +0100
+++ xfs/fs/xfs/xfs_ag.h	2009-02-09 19:15:51.063944366 +0100
@@ -30,6 +30,7 @@ struct xfs_trans;
 
 #define	XFS_AGF_MAGIC	0x58414746	/* 'XAGF' */
 #define	XFS_AGI_MAGIC	0x58414749	/* 'XAGI' */
+#define	XFS_AGFL_MAGIC	0x5841464c	/* 'XAFL' */
 #define	XFS_AGF_VERSION	1
 #define	XFS_AGI_VERSION	1
 
@@ -162,13 +163,31 @@ extern int xfs_read_agi(struct xfs_mount
  */
 #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
-#define XFS_AGFL_SIZE(mp)	((mp)->m_sb.sb_sectsize / sizeof(xfs_agblock_t))
 #define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)XFS_BUF_PTR(bp))
 
+#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
+	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
+		(__be32 *)XFS_BUF_PTR(bp))
+
+/*
+ * Size of the AGFL.  For CRC-enabled filesystes we steal the last two slots
+ * for location information (agno) and the crc.
+ */
+#define XFS_AGFL_SIZE(mp) \
+	((mp)->m_sb.sb_sectsize / sizeof(xfs_agblock_t) - \
+	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? sizeof(struct xfs_agfl) : 0))
+
 typedef struct xfs_agfl {
-	__be32		agfl_bno[1];	/* actually XFS_AGFL_SIZE(mp) */
+	__be32		agfl_magicnum;
+	__be32		agfl_seqno;
+	uuid_t		agfl_uuid;
+	__be32		agfl_crc;
+	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
 } xfs_agfl_t;
 
+extern void xfs_agfl_calc_crc(struct xfs_buf *bp);
+
 /*
  * Busy block/extent entry.  Used in perag to mark blocks that have been freed
  * but whose transactions aren't committed to disk yet.
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2009-02-09 19:15:46.920944300 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2009-02-09 19:15:51.064977738 +0100
@@ -472,6 +472,27 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
+#define xfs_buf_verify_cksum(bp, offset) \
+	xfs_verify_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp), offset)
+#define xfs_buf_update_cksum(bp, offset) \
+	xfs_update_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp), offset)
+
+/*
+ * Calculate CRC on AGFL and stuff it into the structure.
+ *
+ * We CRC the entire AGFL sector, not just the bits we use so that changes
+ * in structure size as features are included do not invalidate CRCs.
+ *
+ * We get called here just before the AGFL is written to disk. We should
+ * also do some validity checking here.
+ */
+void
+xfs_agfl_calc_crc(
+	struct xfs_buf		*bp)
+{
+	xfs_buf_update_cksum(bp, offsetof(struct xfs_agfl, agfl_crc));
+}
+
 /*
  * Read in the allocation group free block array.
  */
@@ -494,8 +515,31 @@ xfs_alloc_read_agfl(
 		return error;
 	ASSERT(bp);
 	ASSERT(!XFS_BUF_GETERROR(bp));
+
+	/*
+	 * Validate the CRC of the AGF block only if the block is clean (i.e.
+	 * it just came from disk) and we have CRCs enabled.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !(XFS_BUF_ISWRITE(bp) || XFS_BUF_ISDELAYWRITE(bp))) {
+		struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(bp);
+
+		if (!xfs_buf_verify_cksum(bp, offsetof(xfs_agfl_t, agfl_crc)) ||
+		    !uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_uuid) ||
+		    be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC ||
+		    be32_to_cpu(agfl->agfl_seqno) != agno) {
+			XFS_CORRUPTION_ERROR("xfs_read_agfl crc",
+					XFS_ERRLEVEL_LOW, mp, agfl);
+			xfs_trans_brelse(tp, bp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+
+		xfs_buf_set_io_callback(bp, xfs_agfl_calc_crc);
+	}
+
 	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGFL, XFS_AGFL_REF);
 	*bpp = bp;
+
 	return 0;
 }
 
@@ -2063,18 +2107,18 @@ xfs_alloc_get_freelist(
 	int		btreeblk) /* destination is a AGF btree */
 {
 	xfs_agf_t	*agf;	/* a.g. freespace structure */
-	xfs_agfl_t	*agfl;	/* a.g. freelist structure */
 	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
+	__be32		*agfl_bno;
 	int		error;
 	int		logflags;
-	xfs_mount_t	*mp;	/* mount structure */
+	xfs_mount_t	*mp = tp->t_mountp;
 	xfs_perag_t	*pag;	/* per allocation group data */
 
-	agf = XFS_BUF_TO_AGF(agbp);
 	/*
 	 * Freelist is empty, give up.
 	 */
+	agf = XFS_BUF_TO_AGF(agbp);
 	if (!agf->agf_flcount) {
 		*bnop = NULLAGBLOCK;
 		return 0;
@@ -2082,15 +2126,17 @@ xfs_alloc_get_freelist(
 	/*
 	 * Read the array of free blocks.
 	 */
-	mp = tp->t_mountp;
-	if ((error = xfs_alloc_read_agfl(mp, tp,
-			be32_to_cpu(agf->agf_seqno), &agflbp)))
+	error = xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno),
+				    &agflbp);
+	if (error)
 		return error;
-	agfl = XFS_BUF_TO_AGFL(agflbp);
+
+
 	/*
 	 * Get the block number and update the data structures.
 	 */
-	bno = be32_to_cpu(agfl->agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
 	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
@@ -2186,12 +2232,13 @@ xfs_alloc_put_freelist(
 	int			btreeblk) /* block came from a AGF btree */
 {
 	xfs_agf_t		*agf;	/* a.g. freespace structure */
-	xfs_agfl_t		*agfl;	/* a.g. free block array */
 	__be32			*blockp;/* pointer to array entry */
 	int			error;
 	int			logflags;
 	xfs_mount_t		*mp;	/* mount structure */
 	xfs_perag_t		*pag;	/* per allocation group data */
+	__be32			*agfl_bno;
+	int			startoff;
 
 	agf = XFS_BUF_TO_AGF(agbp);
 	mp = tp->t_mountp;
@@ -2199,7 +2246,6 @@ xfs_alloc_put_freelist(
 	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
 		return error;
-	agfl = XFS_BUF_TO_AGFL(agflbp);
 	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
 		agf->agf_fllast = 0;
@@ -2219,14 +2265,17 @@ xfs_alloc_put_freelist(
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
-	blockp = &agfl->agfl_bno[be32_to_cpu(agf->agf_fllast)];
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
 	*blockp = cpu_to_be32(bno);
+
 	TRACE_MODAGF(NULL, agf, logflags);
 	xfs_alloc_log_agf(tp, agbp, logflags);
-	xfs_trans_log_buf(tp, agflbp,
-		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
-		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
-			sizeof(xfs_agblock_t) - 1));
+
+	startoff = (char *)blockp - XFS_BUF_PTR(agflbp);
+	xfs_trans_log_buf(tp, agflbp, startoff,
+			  startoff + sizeof(xfs_agblock_t) - 1);
 	return 0;
 }
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:48.970972860 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:51.066944119 +0100
@@ -1999,6 +1999,9 @@ xlog_recover_do_reg_buffer(
  	case XFS_AGI_MAGIC:
 		xfs_agi_calc_crc(bp);
 		break;
+ 	case XFS_AGFL_MAGIC:
+		xfs_agfl_calc_crc(bp);
+		break;
 	default:
 		break;
 	}
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2009-02-09 19:15:48.966944136 +0100
+++ xfs/fs/xfs/xfs_fsops.c	2009-02-09 19:15:51.066944119 +0100
@@ -253,6 +253,30 @@ xfs_growfs_data_private(
 		if (error) {
 			goto error0;
 		}
+
+		/*
+		 * AGFL block.
+		 */
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			struct xfs_agfl		*agfl;
+
+			bp = xfs_buf_get(mp->m_ddev_targp,
+					  XFS_AG_DADDR(mp, agno,
+					  	       XFS_AGFL_DADDR(mp)),
+					  XFS_FSS_TO_BB(mp, 1), 0);
+			agfl = XFS_BUF_TO_AGFL(bp);
+
+			memset(agfl, 0, mp->m_sb.sb_sectsize);
+			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
+			agfl->agfl_seqno = cpu_to_be32(agno);
+			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
+			xfs_buf_set_io_callback(bp, xfs_agfl_calc_crc);
+
+			error = xfs_bwrite(mp, bp);
+			if (error)
+				goto error0;
+		}
+
 		/*
 		 * BNO btree root block
 		 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
