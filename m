Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E6F67F52
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 08:46:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17692304043
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 06:46:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tiO0JyJjE3BquMGK for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 06:46:17 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1OEkFDB017263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 09:46:16 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1OEU4OQ001270
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 09:30:04 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 07/11] xfs: refactor xfs_difree() inobt bits into
	xfs_difree_inobt() helper
Date: Mon, 24 Feb 2014 09:29:59 -0500
Message-Id: <1393252203-7423-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1393252203-7423-1-git-send-email-bfoster@redhat.com>
References: <1393252203-7423-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Refactor xfs_difree() in preparation for the finobt. xfs_difree()
performs the validity checks against the ag and reads the agi
header. The work of physically updating the inode allocation btree
is pushed down into the new xfs_difree_inobt() helper.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 161 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 96 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 74131ab..85a8db5 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1418,74 +1418,30 @@ out_error:
 	return XFS_ERROR(error);
 }
 
-/*
- * Free disk inode.  Carefully avoids touching the incore inode, all
- * manipulations incore are the caller's responsibility.
- * The on-disk inode is not changed by this operation, only the
- * btree (free inode mask) is changed.
- */
-int
-xfs_difree(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_ino_t	inode,		/* inode to be freed */
-	xfs_bmap_free_t	*flist,		/* extents to free */
-	int		*delete,	/* set if inode cluster was deleted */
-	xfs_ino_t	*first_ino)	/* first inode in deleted cluster */
+STATIC int
+xfs_difree_inobt(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	xfs_agino_t			agino,
+	struct xfs_bmap_free		*flist,
+	int				*delete,
+	xfs_ino_t			*first_ino,
+	struct xfs_inobt_rec_incore	*orec)
 {
-	/* REFERENCED */
-	xfs_agblock_t	agbno;	/* block number containing inode */
-	xfs_buf_t	*agbp;	/* buffer containing allocation group header */
-	xfs_agino_t	agino;	/* inode number relative to allocation group */
-	xfs_agnumber_t	agno;	/* allocation group number */
-	xfs_agi_t	*agi;	/* allocation group header */
-	xfs_btree_cur_t	*cur;	/* inode btree cursor */
-	int		error;	/* error return value */
-	int		i;	/* result code */
-	int		ilen;	/* inodes in an inode cluster */
-	xfs_mount_t	*mp;	/* mount structure for filesystem */
-	int		off;	/* offset of inode in inode chunk */
-	xfs_inobt_rec_incore_t rec;	/* btree record */
-	struct xfs_perag *pag;
-
-	mp = tp->t_mountp;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	struct xfs_perag		*pag;
+	struct xfs_btree_cur		*cur;
+	struct xfs_inobt_rec_incore	rec;
+	int				ilen;
+	int				error;
+	int				i;
+	int				off;
 
-	/*
-	 * Break up inode number into its components.
-	 */
-	agno = XFS_INO_TO_AGNO(mp, inode);
-	if (agno >= mp->m_sb.sb_agcount)  {
-		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
-			__func__, agno, mp->m_sb.sb_agcount);
-		ASSERT(0);
-		return XFS_ERROR(EINVAL);
-	}
-	agino = XFS_INO_TO_AGINO(mp, inode);
-	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
-		xfs_warn(mp, "%s: inode != XFS_AGINO_TO_INO() (%llu != %llu).",
-			__func__, (unsigned long long)inode,
-			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
-		ASSERT(0);
-		return XFS_ERROR(EINVAL);
-	}
-	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno >= mp->m_sb.sb_agblocks)  {
-		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
-			__func__, agbno, mp->m_sb.sb_agblocks);
-		ASSERT(0);
-		return XFS_ERROR(EINVAL);
-	}
-	/*
-	 * Get the allocation group header.
-	 */
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
-	if (error) {
-		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
-			__func__, error);
-		return error;
-	}
-	agi = XFS_BUF_TO_AGI(agbp);
 	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
-	ASSERT(agbno < be32_to_cpu(agi->agi_length));
+	ASSERT(XFS_AGINO_TO_AGBNO(mp, agino) < be32_to_cpu(agi->agi_length));
+
 	/*
 	 * Initialize the cursor.
 	 */
@@ -1581,6 +1537,7 @@ xfs_difree(
 	if (error)
 		goto error0;
 
+	*orec = rec;
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
@@ -1589,6 +1546,80 @@ error0:
 	return error;
 }
 
+/*
+ * Free disk inode.  Carefully avoids touching the incore inode, all
+ * manipulations incore are the caller's responsibility.
+ * The on-disk inode is not changed by this operation, only the
+ * btree (free inode mask) is changed.
+ */
+int
+xfs_difree(
+	struct xfs_trans	*tp,		/* transaction pointer */
+	xfs_ino_t		inode,		/* inode to be freed */
+	struct xfs_bmap_free	*flist,		/* extents to free */
+	int			*delete,/* set if inode cluster was deleted */
+	xfs_ino_t		*first_ino)/* first inode in deleted cluster */
+{
+	/* REFERENCED */
+	xfs_agblock_t		agbno;	/* block number containing inode */
+	struct xfs_buf		*agbp;	/* buffer for allocation group header */
+	xfs_agino_t		agino;	/* allocation group inode number */
+	xfs_agnumber_t		agno;	/* allocation group number */
+	int			error;	/* error return value */
+	struct xfs_mount	*mp;	/* mount structure for filesystem */
+	struct xfs_inobt_rec_incore rec;/* btree record */
+
+	mp = tp->t_mountp;
+
+	/*
+	 * Break up inode number into its components.
+	 */
+	agno = XFS_INO_TO_AGNO(mp, inode);
+	if (agno >= mp->m_sb.sb_agcount)  {
+		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
+			__func__, agno, mp->m_sb.sb_agcount);
+		ASSERT(0);
+		return XFS_ERROR(EINVAL);
+	}
+	agino = XFS_INO_TO_AGINO(mp, inode);
+	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
+		xfs_warn(mp, "%s: inode != XFS_AGINO_TO_INO() (%llu != %llu).",
+			__func__, (unsigned long long)inode,
+			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
+		ASSERT(0);
+		return XFS_ERROR(EINVAL);
+	}
+	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+	if (agbno >= mp->m_sb.sb_agblocks)  {
+		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
+			__func__, agbno, mp->m_sb.sb_agblocks);
+		ASSERT(0);
+		return XFS_ERROR(EINVAL);
+	}
+	/*
+	 * Get the allocation group header.
+	 */
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error) {
+		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
+			__func__, error);
+		return error;
+	}
+
+	/*
+	 * Fix up the inode allocation btree.
+	 */
+	error = xfs_difree_inobt(mp, tp, agbp, agino, flist, delete, first_ino,
+				 &rec);
+	if (error)
+		goto error0;
+
+	return 0;
+
+error0:
+	return error;
+}
+
 STATIC int
 xfs_imap_lookup(
 	struct xfs_mount	*mp,
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
