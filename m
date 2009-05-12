Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CLIvJ3098762 for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:18:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96146F9E145
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 14:23:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qx4UhhlU8JcGpguv for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 14:23:40 -0700 (PDT)
Message-Id: <20090512211903.247953000@bombadil.infradead.org>
Date: Tue, 12 May 2009 17:16:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: factor out debug checks from xfs_dialloc and
	xfs_difree
References: <20090512211607.197071000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-freecount-checks
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

From: Dave Chinner <dgc@sgi.com>

Factor out a common helper from repeated debug checks in xfs_dialloc and
xfs_difree.

[hch: split out from Dave's dynamic allocation policy patches]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-02-25 15:42:10.898919328 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2009-02-25 15:44:27.680921419 +0100
@@ -148,6 +148,47 @@ xfs_inobt_get_rec(
 }
 
 /*
+ * Verify that the number of free inodes in the AGI is correct.
+ */
+#ifdef DEBUG
+STATIC int
+xfs_check_agi_freecount(
+	struct xfs_btree_cur	*cur,
+	struct xfs_agi		*agi)
+{
+	if (cur->bc_nlevels == 1) {
+		xfs_inobt_rec_incore_t rec;
+		int		freecount = 0;
+		int		error;
+		int		i;
+
+		error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i);
+		if (error)
+			return error;
+
+		do {
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+			if (error)
+				return error;
+
+			if (i) {
+				freecount += rec.ir_freecount;
+				error = xfs_btree_increment(cur, 0, &i);
+				if (error)
+					return error;
+			}
+		} while (i == 1);
+
+		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
+			ASSERT(freecount == be32_to_cpu(agi->agi_freecount));
+	}
+	return 0;
+}
+#else
+#define xfs_check_agi_freecount(cur, agi)	0
+#endif
+
+/*
  * Initialise a new set of inodes.
  */
 STATIC void
@@ -548,6 +589,7 @@ nextag:
 	}
 }
 
+
 /*
  * Visible inode allocation functions.
  */
@@ -733,27 +775,11 @@ nextag:
 	 */
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
-#ifdef DEBUG
-	if (cur->bc_nlevels == 1) {
-		int	freecount = 0;
 
-		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		do {
-			error = xfs_inobt_get_rec(cur, &rec, &i);
-			if (error)
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			freecount += rec.ir_freecount;
-			if ((error = xfs_btree_increment(cur, 0, &i)))
-				goto error0;
-		} while (i == 1);
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
 
-		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
-		       XFS_FORCED_SHUTDOWN(mp));
-	}
-#endif
 	/*
 	 * If in the same a.g. as the parent, try to get near the parent.
 	 */
@@ -951,25 +977,11 @@ nextag:
 	down_read(&mp->m_peraglock);
 	mp->m_perag[tagno].pagi_freecount--;
 	up_read(&mp->m_peraglock);
-#ifdef DEBUG
-	if (cur->bc_nlevels == 1) {
-		int	freecount = 0;
 
-		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
-			goto error0;
-		do {
-			error = xfs_inobt_get_rec(cur, &rec, &i);
-			if (error)
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			freecount += rec.ir_freecount;
-			if ((error = xfs_btree_increment(cur, 0, &i)))
-				goto error0;
-		} while (i == 1);
-		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
-		       XFS_FORCED_SHUTDOWN(mp));
-	}
-#endif
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
+
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 	*inop = ino;
@@ -1060,26 +1072,11 @@ xfs_difree(
 	 * Initialize the cursor.
 	 */
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-#ifdef DEBUG
-	if (cur->bc_nlevels == 1) {
-		int freecount = 0;
 
-		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
-			goto error0;
-		do {
-			error = xfs_inobt_get_rec(cur, &rec, &i);
-			if (error)
-				goto error0;
-			if (i) {
-				freecount += rec.ir_freecount;
-				if ((error = xfs_btree_increment(cur, 0, &i)))
-					goto error0;
-			}
-		} while (i == 1);
-		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
-		       XFS_FORCED_SHUTDOWN(mp));
-	}
-#endif
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
+
 	/*
 	 * Look for the entry describing this inode.
 	 */
@@ -1165,26 +1162,10 @@ xfs_difree(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
 
-#ifdef DEBUG
-	if (cur->bc_nlevels == 1) {
-		int freecount = 0;
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
 
-		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
-			goto error0;
-		do {
-			error = xfs_inobt_get_rec(cur, &rec, &i);
-			if (error)
-				goto error0;
-			if (i) {
-				freecount += rec.ir_freecount;
-				if ((error = xfs_btree_increment(cur, 0, &i)))
-					goto error0;
-			}
-		} while (i == 1);
-		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
-		       XFS_FORCED_SHUTDOWN(mp));
-	}
-#endif
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
