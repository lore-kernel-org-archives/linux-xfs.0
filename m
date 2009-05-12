Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CLIvST098764 for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:18:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4639F9E141
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 14:23:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kUIHEdSj3wOz5ZZA for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 14:23:40 -0700 (PDT)
Message-Id: <20090512211902.905185000@bombadil.infradead.org>
Date: Tue, 12 May 2009 17:16:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: improve xfs_inobt_update prototype
References: <20090512211607.197071000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-better-xfs_inobt_update-prototype
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

Both callers of xfs_inobt_update have the record in form of a
xfs_inobt_rec_incore_t, so just pass a pointer to it instead of the
individual variables.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-02-25 15:39:43.062918771 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2009-02-25 15:42:10.898919328 +0100
@@ -110,22 +110,19 @@ xfs_inobt_lookup_le(
 }
 
 /*
- * Update the record referred to by cur to the value given
- * by [ino, fcnt, free].
+ * Update the record referred to by cur to the value given.
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
 STATIC int				/* error */
 xfs_inobt_update(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free)	/* free inode mask */
+	xfs_inobt_rec_incore_t	*irec)	/* btree record */
 {
 	union xfs_btree_rec	rec;
 
-	rec.inobt.ir_startino = cpu_to_be32(ino);
-	rec.inobt.ir_freecount = cpu_to_be32(fcnt);
-	rec.inobt.ir_free = cpu_to_be64(free);
+	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
+	rec.inobt.ir_freecount = cpu_to_be32(irec->ir_freecount);
+	rec.inobt.ir_free = cpu_to_be64(irec->ir_free);
 	return xfs_btree_update(cur, &rec);
 }
 
@@ -946,8 +943,8 @@ nextag:
 	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
-	if ((error = xfs_inobt_update(cur, rec.ir_startino, rec.ir_freecount,
-			rec.ir_free)))
+	error = xfs_inobt_update(cur, &rec);
+	if (error)
 		goto error0;
 	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
@@ -1149,12 +1146,14 @@ xfs_difree(
 	} else {
 		*delete = 0;
 
-		if ((error = xfs_inobt_update(cur, rec.ir_startino, rec.ir_freecount, rec.ir_free))) {
+		error = xfs_inobt_update(cur, &rec);
+		if (error) {
 			cmn_err(CE_WARN,
-				"xfs_difree: xfs_inobt_update()  returned an error %d on %s.  Returning error.",
+	"xfs_difree: xfs_inobt_update returned an error %d on %s.",
 				error, mp->m_fsname);
 			goto error0;
 		}
+
 		/* 
 		 * Change the inode free counts and log the ag/sb changes.
 		 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
