Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:41:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDfQ03024601
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:27 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C79141487F56
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id GJBB86A50iQoyMjj for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:25 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSLU-0000px-Vp
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:41:25 +0000
Date: Mon, 27 Oct 2008 09:41:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/6] merge xfs_imap into xfs_dilocate
Message-ID: <20081027134124.GD3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-merge-xfs_imap-xfs_dilocate
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_imap is the only caller of xfs_dilocate and doesn't add any significant
value.  Merge the two functions and document the various cases we have for
inode cluster lookup in the new xfs_imap.

Also remove the unused im_agblkno and im_ioffset fields from struct xfs_imap
while we're at it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-25 13:28:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-25 13:28:50.000000000 +0200
@@ -40,6 +40,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
+#include "xfs_imap.h"
 
 
 /*
@@ -1196,36 +1197,28 @@ error0:
 }
 
 /*
- * Return the location of the inode in bno/off, for mapping it into a buffer.
+ * Return the location of the inode in imap, for mapping it into a buffer.
  */
-/*ARGSUSED*/
 int
-xfs_dilocate(
-	xfs_mount_t	*mp,	/* file system mount structure */
-	xfs_trans_t	*tp,	/* transaction pointer */
+xfs_imap(
+	xfs_mount_t	 *mp,	/* file system mount structure */
+	xfs_trans_t	 *tp,	/* transaction pointer */
 	xfs_ino_t	ino,	/* inode to locate */
-	xfs_fsblock_t	*bno,	/* output: block containing inode */
-	int		*len,	/* output: num blocks in inode cluster */
-	int		*off,	/* output: index in block of inode */
-	uint		flags)	/* flags concerning inode lookup */
+	struct xfs_imap	*imap,	/* location map structure */
+	uint		flags)	/* flags for inode btree lookup */
 {
 	xfs_agblock_t	agbno;	/* block number of inode in the alloc group */
-	xfs_buf_t	*agbp;	/* agi buffer */
 	xfs_agino_t	agino;	/* inode number within alloc group */
 	xfs_agnumber_t	agno;	/* allocation group number */
 	int		blks_per_cluster; /* num blocks per inode cluster */
 	xfs_agblock_t	chunk_agbno;	/* first block in inode chunk */
-	xfs_agino_t	chunk_agino;	/* first agino in inode chunk */
-	__int32_t	chunk_cnt;	/* count of free inodes in chunk */
-	xfs_inofree_t	chunk_free;	/* mask of free inodes in chunk */
 	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
-	xfs_btree_cur_t	*cur;	/* inode btree cursor */
 	int		error;	/* error code */
-	int		i;	/* temp state */
 	int		offset;	/* index of inode in its buffer */
 	int		offset_agbno;	/* blks from chunk start to inode */
 
 	ASSERT(ino != NULLFSINO);
+
 	/*
 	 * Split up the inode number into its parts.
 	 */
@@ -1240,20 +1233,20 @@ xfs_dilocate(
 			return XFS_ERROR(EINVAL);
 		if (agno >= mp->m_sb.sb_agcount) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: agno (%d) >= "
+					"xfs_imap: agno (%d) >= "
 					"mp->m_sb.sb_agcount (%d)",
 					agno,  mp->m_sb.sb_agcount);
 		}
 		if (agbno >= mp->m_sb.sb_agblocks) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: agbno (0x%llx) >= "
+					"xfs_imap: agbno (0x%llx) >= "
 					"mp->m_sb.sb_agblocks (0x%lx)",
 					(unsigned long long) agbno,
 					(unsigned long) mp->m_sb.sb_agblocks);
 		}
 		if (ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: ino (0x%llx) != "
+					"xfs_imap: ino (0x%llx) != "
 					"XFS_AGINO_TO_INO(mp, agno, agino) "
 					"(0x%llx)",
 					ino, XFS_AGINO_TO_INO(mp, agno, agino));
@@ -1262,34 +1255,65 @@ xfs_dilocate(
 #endif /* DEBUG */
 		return XFS_ERROR(EINVAL);
 	}
-	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp))) {
+
+	/*
+	 * If the inode cluster size is the same as the blocksize or
+	 * bigger we get to the buffer by simple arithmetics.
+	 */
+	if (XFS_INODE_CLUSTER_SIZE(mp) <= mp->m_sb.sb_blocksize) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
-		*bno = XFS_AGB_TO_FSB(mp, agno, agbno);
-		*off = offset;
-		*len = 1;
+
+		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		imap->im_len = XFS_FSB_TO_BB(mp, 1);
+		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
 		return 0;
 	}
+
 	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
-	if (*bno != NULLFSBLOCK) {
+
+	/*
+	 * If we get a block number passed from bulkstat we can use it to
+	 * find the buffer easily.
+	 */
+	if (imap->im_blkno) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
-		cluster_agbno = XFS_FSB_TO_AGBNO(mp, *bno);
-		*off = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
-			offset;
-		*len = blks_per_cluster;
+
+		cluster_agbno = XFS_DADDR_TO_AGBNO(mp, imap->im_blkno);
+		offset += (agbno - cluster_agbno) * mp->m_sb.sb_inopblock;
+
+		imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
 		return 0;
 	}
+
+	/*
+	 * With aligned inodes it's again quite simple and we can skip the
+	 * btree lookup.
+	 */
 	if (mp->m_inoalign_mask) {
 		offset_agbno = agbno & mp->m_inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
+
+	/*
+	 * Worst case: we actually have to actually perform a lookup in the
+	 * inode btree.
+	 */
 	} else {
+		xfs_btree_cur_t	*cur;	/* inode btree cursor */
+		xfs_agino_t	chunk_agino; /* first agino in inode chunk */
+		__int32_t	chunk_cnt; /* count of free inodes in chunk */
+		xfs_inofree_t	chunk_free; /* mask of free inodes in chunk */
+		xfs_buf_t	*agbp;	/* agi buffer */
+		int		i;	/* temp state */
+
 		down_read(&mp->m_peraglock);
 		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
 		up_read(&mp->m_peraglock);
 		if (error) {
 #ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_ialloc_read_agi() returned "
 					"error %d, agno %d",
 					error, agno);
@@ -1299,7 +1323,7 @@ xfs_dilocate(
 		cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
 		if ((error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i))) {
 #ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_inobt_lookup_le() failed");
 #endif /* DEBUG */
 			goto error0;
@@ -1307,18 +1331,19 @@ xfs_dilocate(
 		if ((error = xfs_inobt_get_rec(cur, &chunk_agino, &chunk_cnt,
 				&chunk_free, &i))) {
 #ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_inobt_get_rec() failed");
 #endif /* DEBUG */
 			goto error0;
 		}
 		if (i == 0) {
 #ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_inobt_get_rec() failed");
 #endif /* DEBUG */
 			error = XFS_ERROR(EINVAL);
 		}
+ error0:
 		xfs_trans_brelse(tp, agbp);
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 		if (error)
@@ -1326,19 +1351,35 @@ xfs_dilocate(
 		chunk_agbno = XFS_AGINO_TO_AGBNO(mp, chunk_agino);
 		offset_agbno = agbno - chunk_agbno;
 	}
+
 	ASSERT(agbno >= chunk_agbno);
 	cluster_agbno = chunk_agbno +
 		((offset_agbno / blks_per_cluster) * blks_per_cluster);
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
-	*bno = XFS_AGB_TO_FSB(mp, agno, cluster_agbno);
-	*off = offset;
-	*len = blks_per_cluster;
+
+	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
+	imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+	imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
+
+	/*
+	 * If the inode number maps to a block outside the bounds
+	 * of the file system then return NULL rather than calling
+	 * read_buf and panicing when we get an error from the
+	 * driver.
+	 */
+	if ((imap->im_blkno + imap->im_len) >
+	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
+			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
+			(unsigned long long) imap->im_blkno,
+			(unsigned long long) imap->im_len,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+		return EINVAL;
+	}
+
 	return 0;
-error0:
-	xfs_trans_brelse(tp, agbp);
-	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	return error;
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.h	2008-10-01 06:30:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.h	2008-10-25 13:28:50.000000000 +0200
@@ -20,6 +20,7 @@
 
 struct xfs_buf;
 struct xfs_dinode;
+struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
 
@@ -104,17 +105,14 @@ xfs_difree(
 	xfs_ino_t	*first_ino);	/* first inode in deleted cluster */
 
 /*
- * Return the location of the inode in bno/len/off,
- * for mapping it into a buffer.
+ * Return the location of the inode in imap, for mapping it into a buffer.
  */
 int
-xfs_dilocate(
+xfs_imap(
 	struct xfs_mount *mp,		/* file system mount structure */
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	ino,		/* inode to locate */
-	xfs_fsblock_t	*bno,		/* output: block containing inode */
-	int		*len,		/* output: num blocks in cluster*/
-	int		*off,		/* output: index in block of inode */
+	struct xfs_imap	*imap,		/* location map structure */
 	uint		flags);		/* flags for inode btree lookup */
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_imap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_imap.h	2008-10-01 06:30:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_imap.h	2008-10-25 13:28:50.000000000 +0200
@@ -25,14 +25,7 @@
 typedef struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
 	uint		im_len;		/* length in BBs of inode chunk */
-	xfs_agblock_t	im_agblkno;	/* logical block of inode chunk in ag */
-	ushort		im_ioffset;	/* inode offset in block in "inodes" */
 	ushort		im_boffset;	/* inode offset in block in bytes */
 } xfs_imap_t;
 
-struct xfs_mount;
-struct xfs_trans;
-int	xfs_imap(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-		 xfs_imap_t *, uint);
-
 #endif	/* __XFS_IMAP_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-25 13:28:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-25 13:28:50.000000000 +0200
@@ -266,7 +266,7 @@ xfs_inotobp(
  * in once, thus we can use the mapping information stored in the inode
  * rather than calling xfs_imap().  This allows us to avoid the overhead
  * of looking at the inode btree for small block file systems
- * (see xfs_dilocate()).
+ * (see xfs_imap()).
  */
 int
 xfs_itobp(
@@ -2505,64 +2505,6 @@ xfs_idata_realloc(
 	ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
 }
 
-
-
-
-/*
- * Map inode to disk block and offset.
- *
- * mp -- the mount point structure for the current file system
- * tp -- the current transaction
- * ino -- the inode number of the inode to be located
- * imap -- this structure is filled in with the information necessary
- *	 to retrieve the given inode from disk
- * flags -- flags to pass to xfs_dilocate indicating whether or not
- *	 lookups in the inode btree were OK or not
- */
-int
-xfs_imap(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	xfs_imap_t	*imap,
-	uint		flags)
-{
-	xfs_fsblock_t	fsbno;
-	int		len;
-	int		off;
-	int		error;
-
-	fsbno = imap->im_blkno ?
-		XFS_DADDR_TO_FSB(mp, imap->im_blkno) : NULLFSBLOCK;
-	error = xfs_dilocate(mp, tp, ino, &fsbno, &len, &off, flags);
-	if (error)
-		return error;
-
-	imap->im_blkno = XFS_FSB_TO_DADDR(mp, fsbno);
-	imap->im_len = XFS_FSB_TO_BB(mp, len);
-	imap->im_agblkno = XFS_FSB_TO_AGBNO(mp, fsbno);
-	imap->im_ioffset = (ushort)off;
-	imap->im_boffset = (ushort)(off << mp->m_sb.sb_inodelog);
-
-	/*
-	 * If the inode number maps to a block outside the bounds
-	 * of the file system then return NULL rather than calling
-	 * read_buf and panicing when we get an error from the
-	 * driver.
-	 */
-	if ((imap->im_blkno + imap->im_len) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
-			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
-			(unsigned long long) imap->im_blkno,
-			(unsigned long long) imap->im_len,
-			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		return EINVAL;
-	}
-	return 0;
-}
-
 void
 xfs_idestroy_fork(
 	xfs_inode_t	*ip,
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:28:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:28:50.000000000 +0200
@@ -157,7 +157,7 @@ typedef struct xfs_icdinode {
 #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
 
 /*
- * Flags for xfs_inotobp, xfs_imap() and xfs_dilocate().
+ * Flags for xfs_inotobp and xfs_imap().
  */
 #define XFS_IMAP_BULKSTAT	0x1
 

-- 
