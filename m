Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 602D67FEF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:36:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B8D3AC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:36:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fHfHmrmvX7kYiqtj for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4P-0003BM-BG
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4O-0000Ey-Ry
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/50] libxfs: sync xfs_ialloc.c to the kernel code
Date: Wed, 19 Jun 2013 15:35:43 +1000
Message-Id: <1371620173-712-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

include the missing xfs_difree() function. it's not used by
userspace, but it makes no sense to have just this one arbitrary
difference between the kernel and userspace files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_ialloc.c |  179 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 173 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 48916dd..bbdaf3f 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -314,7 +314,7 @@ xfs_ialloc_ag_alloc(
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
 	 * an entire stripe unit with inodes.
- 	 */
+	 */
 	agi = XFS_BUF_TO_AGI(agbp);
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
@@ -324,8 +324,6 @@ xfs_ialloc_ag_alloc(
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		args.type = XFS_ALLOCTYPE_THIS_BNO;
-		args.mod = args.total = args.wasdel = args.isfl =
-			args.userdata = args.minalignslop = 0;
 		args.prod = 1;
 
 		/*
@@ -378,8 +376,6 @@ xfs_ialloc_ag_alloc(
 		 * Allocate a fixed-size extent of inodes.
 		 */
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.mod = args.total = args.wasdel = args.isfl =
-			args.userdata = args.minalignslop = 0;
 		args.prod = 1;
 		/*
 		 * Allow space for the inode btree to split.
@@ -1074,6 +1070,177 @@ out_error:
 	return XFS_ERROR(error);
 }
 
+/*
+ * Free disk inode.  Carefully avoids touching the incore inode, all
+ * manipulations incore are the caller's responsibility.
+ * The on-disk inode is not changed by this operation, only the
+ * btree (free inode mask) is changed.
+ */
+int
+xfs_difree(
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_ino_t	inode,		/* inode to be freed */
+	xfs_bmap_free_t	*flist,		/* extents to free */
+	int		*delete,	/* set if inode cluster was deleted */
+	xfs_ino_t	*first_ino)	/* first inode in deleted cluster */
+{
+	/* REFERENCED */
+	xfs_agblock_t	agbno;	/* block number containing inode */
+	xfs_buf_t	*agbp;	/* buffer containing allocation group header */
+	xfs_agino_t	agino;	/* inode number relative to allocation group */
+	xfs_agnumber_t	agno;	/* allocation group number */
+	xfs_agi_t	*agi;	/* allocation group header */
+	xfs_btree_cur_t	*cur;	/* inode btree cursor */
+	int		error;	/* error return value */
+	int		i;	/* result code */
+	int		ilen;	/* inodes in an inode cluster */
+	xfs_mount_t	*mp;	/* mount structure for filesystem */
+	int		off;	/* offset of inode in inode chunk */
+	xfs_inobt_rec_incore_t rec;	/* btree record */
+	struct xfs_perag *pag;
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
+	agi = XFS_BUF_TO_AGI(agbp);
+	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
+	ASSERT(agbno < be32_to_cpu(agi->agi_length));
+	/*
+	 * Initialize the cursor.
+	 */
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
+
+	/*
+	 * Look for the entry describing this inode.
+	 */
+	if ((error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i))) {
+		xfs_warn(mp, "%s: xfs_inobt_lookup() returned error %d.",
+			__func__, error);
+		goto error0;
+	}
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error) {
+		xfs_warn(mp, "%s: xfs_inobt_get_rec() returned error %d.",
+			__func__, error);
+		goto error0;
+	}
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	/*
+	 * Get the offset in the inode chunk.
+	 */
+	off = agino - rec.ir_startino;
+	ASSERT(off >= 0 && off < XFS_INODES_PER_CHUNK);
+	ASSERT(!(rec.ir_free & XFS_INOBT_MASK(off)));
+	/*
+	 * Mark the inode free & increment the count.
+	 */
+	rec.ir_free |= XFS_INOBT_MASK(off);
+	rec.ir_freecount++;
+
+	/*
+	 * When an inode cluster is free, it becomes eligible for removal
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
+	    (rec.ir_freecount == XFS_IALLOC_INODES(mp))) {
+
+		*delete = 1;
+		*first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
+
+		/*
+		 * Remove the inode cluster from the AGI B+Tree, adjust the
+		 * AGI and Superblock inode counts, and mark the disk space
+		 * to be freed when the transaction is committed.
+		 */
+		ilen = XFS_IALLOC_INODES(mp);
+		be32_add_cpu(&agi->agi_count, -ilen);
+		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
+		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
+		pag = xfs_perag_get(mp, agno);
+		pag->pagi_freecount -= ilen - 1;
+		xfs_perag_put(pag);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
+
+		if ((error = xfs_btree_delete(cur, &i))) {
+			xfs_warn(mp, "%s: xfs_btree_delete returned error %d.",
+				__func__, error);
+			goto error0;
+		}
+
+		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
+				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
+				XFS_IALLOC_BLOCKS(mp), flist, mp);
+	} else {
+		*delete = 0;
+
+		error = xfs_inobt_update(cur, &rec);
+		if (error) {
+			xfs_warn(mp, "%s: xfs_inobt_update returned error %d.",
+				__func__, error);
+			goto error0;
+		}
+
+		/* 
+		 * Change the inode free counts and log the ag/sb changes.
+		 */
+		be32_add_cpu(&agi->agi_freecount, 1);
+		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
+		pag = xfs_perag_get(mp, agno);
+		pag->pagi_freecount++;
+		xfs_perag_put(pag);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
+	}
+
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
 STATIC int
 xfs_imap_lookup(
 	struct xfs_mount	*mp,
@@ -1153,7 +1320,7 @@ xfs_imap(
 	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
 	int		error;	/* error code */
 	int		offset;	/* index of inode in its buffer */
-	xfs_agblock_t	offset_agbno;	/* blks from chunk start to inode */
+	int		offset_agbno;	/* blks from chunk start to inode */
 
 	ASSERT(ino != NULLFSINO);
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
