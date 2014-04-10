Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 182817FA5
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:08:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6F238F8040
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OsFF8KmKJjPgwEY1 for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:39 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AG8dSU030627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:39 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3AG8dpF013380
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 06/11] xfs: use and update the finobt on inode allocation
Date: Thu, 10 Apr 2014 12:08:31 -0400
Message-Id: <1397146116-42546-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
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

Replace xfs_dialloc_ag() with an implementation that looks for a
record in the finobt. The finobt only tracks records with at least
one free inode. This eliminates the need for the intra-ag scan in
the original algorithm. Once the inode is allocated, update the
finobt appropriately (possibly removing the record) as well as the
inobt.

Move the original xfs_dialloc_ag() algorithm to
xfs_dialloc_ag_inobt() and fall back as such if finobt support is
not enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 295 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 290 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 203db98..8982c88 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -722,13 +722,10 @@ xfs_ialloc_get_rec(
 }
 
 /*
- * Allocate an inode.
- *
- * The caller selected an AG for us, and made sure that free inodes are
- * available.
+ * Allocate an inode using the inobt-only algorithm.
  */
 STATIC int
-xfs_dialloc_ag(
+xfs_dialloc_ag_inobt(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
 	xfs_ino_t		parent,
@@ -987,6 +984,294 @@ error0:
 }
 
 /*
+ * Use the free inode btree to allocate an inode based on distance from the
+ * parent. Note that the provided cursor may be deleted and replaced.
+ */
+STATIC int
+xfs_dialloc_ag_finobt_near(
+	xfs_agino_t			pagino,
+	struct xfs_btree_cur		**ocur,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	struct xfs_btree_cur		*lcur = *ocur;	/* left search cursor */
+	struct xfs_btree_cur		*rcur;	/* right search cursor */
+	struct xfs_inobt_rec_incore	rrec;
+	int				error;
+	int				i, j;
+
+	error = xfs_inobt_lookup(lcur, pagino, XFS_LOOKUP_LE, &i);
+	if (error)
+		return error;
+
+	if (i == 1) {
+		error = xfs_inobt_get_rec(lcur, rec, &i);
+		if (error)
+			return error;
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/*
+		 * See if we've landed in the parent inode record. The finobt
+		 * only tracks chunks with at least one free inode, so record
+		 * existence is enough.
+		 */
+		if (pagino >= rec->ir_startino &&
+		    pagino < (rec->ir_startino + XFS_INODES_PER_CHUNK))
+			return 0;
+	}
+
+	error = xfs_btree_dup_cursor(lcur, &rcur);
+	if (error) 
+		return error;
+
+	error = xfs_inobt_lookup(rcur, pagino, XFS_LOOKUP_GE, &j);
+	if (error)
+		goto error_rcur;
+	if (j == 1) {
+		error = xfs_inobt_get_rec(rcur, &rrec, &j);
+		if (error)
+			goto error_rcur;
+		XFS_WANT_CORRUPTED_GOTO(j == 1, error_rcur);
+	}
+
+	XFS_WANT_CORRUPTED_GOTO(i == 1 || j == 1, error_rcur);
+	if (i == 1 && j == 1) {
+		/*
+		 * Both the left and right records are valid. Choose the closer
+		 * inode chunk to the target.
+		 */
+		if ((pagino - rec->ir_startino + XFS_INODES_PER_CHUNK - 1) >
+		    (rrec.ir_startino - pagino)) {
+			*rec = rrec;
+			xfs_btree_del_cursor(lcur, XFS_BTREE_NOERROR);
+			*ocur = rcur;
+		} else {
+			xfs_btree_del_cursor(rcur, XFS_BTREE_NOERROR);
+		}
+	} else if (j == 1) {
+		/* only the right record is valid */
+		*rec = rrec;
+		xfs_btree_del_cursor(lcur, XFS_BTREE_NOERROR);
+		*ocur = rcur;
+	} else if (i == 1) {
+		/* only the left record is valid */
+		xfs_btree_del_cursor(rcur, XFS_BTREE_NOERROR);
+	}
+
+	return 0;
+
+error_rcur:
+	xfs_btree_del_cursor(rcur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
+ * Use the free inode btree to find a free inode based on a newino hint. If
+ * the hint is NULL, find the first free inode in the AG.
+ */
+STATIC int
+xfs_dialloc_ag_finobt_newino(
+	struct xfs_agi			*agi,
+	struct xfs_btree_cur		*cur,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	int error;
+	int i;
+
+	if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
+		error = xfs_inobt_lookup(cur, agi->agi_newino, XFS_LOOKUP_EQ,
+					 &i);
+		if (error)
+			return error;
+		if (i == 1) {
+			error = xfs_inobt_get_rec(cur, rec, &i);
+			if (error)
+				return error;
+			XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+			return 0;
+		}
+	}
+
+	/*
+	 * Find the first inode available in the AG.
+	 */
+	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+	error = xfs_inobt_get_rec(cur, rec, &i);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+	return 0;
+}
+
+/*
+ * Update the inobt based on a modification made to the finobt. Also ensure that
+ * the records from both trees are equivalent post-modification.
+ */
+STATIC int
+xfs_dialloc_ag_update_inobt(
+	struct xfs_btree_cur		*cur,	/* inobt cursor */
+	struct xfs_inobt_rec_incore	*frec,	/* finobt record */
+	int				offset) /* inode offset */
+{
+	struct xfs_inobt_rec_incore	rec;
+	int				error;
+	int				i;
+
+	error = xfs_inobt_lookup(cur, frec->ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	ASSERT((XFS_AGINO_TO_OFFSET(cur->bc_mp, rec.ir_startino) %
+				   XFS_INODES_PER_CHUNK) == 0);
+
+	rec.ir_free &= ~XFS_INOBT_MASK(offset);
+	rec.ir_freecount--;
+
+	XFS_WANT_CORRUPTED_RETURN((rec.ir_free == frec->ir_free) &&
+				  (rec.ir_freecount == frec->ir_freecount));
+
+	error = xfs_inobt_update(cur, &rec);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+/*
+ * Allocate an inode using the free inode btree, if available. Otherwise, fall
+ * back to the inobt search algorithm.
+ *
+ * The caller selected an AG for us, and made sure that free inodes are
+ * available.
+ */
+STATIC int
+xfs_dialloc_ag(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_ino_t		parent,
+	xfs_ino_t		*inop)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
+	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
+	struct xfs_perag		*pag;
+	struct xfs_btree_cur		*cur;	/* finobt cursor */
+	struct xfs_btree_cur		*icur;	/* inobt cursor */
+	struct xfs_inobt_rec_incore	rec;
+	xfs_ino_t			ino;
+	int				error;
+	int				offset;
+	int				i;
+
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+		return xfs_dialloc_ag_inobt(tp, agbp, parent, inop);
+
+	pag = xfs_perag_get(mp, agno);
+
+	/*
+	 * If pagino is 0 (this is the root inode allocation) use newino.
+	 * This must work because we've just allocated some.
+	 */
+	if (!pagino)
+		pagino = be32_to_cpu(agi->agi_newino);
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error_cur;
+
+	/*
+	 * The search algorithm depends on whether we're in the same AG as the
+	 * parent. If so, find the closest available inode to the parent. If
+	 * not, consider the agi hint or find the first free inode in the AG.
+	 */
+	if (agno == pagno)
+		error = xfs_dialloc_ag_finobt_near(pagino, &cur, &rec);
+	else
+		error = xfs_dialloc_ag_finobt_newino(agi, cur, &rec);
+	if (error)
+		goto error_cur;
+
+	offset = xfs_lowbit64(rec.ir_free);
+	ASSERT(offset >= 0);
+	ASSERT(offset < XFS_INODES_PER_CHUNK);
+	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
+				   XFS_INODES_PER_CHUNK) == 0);
+	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
+
+	/*
+	 * Modify or remove the finobt record.
+	 */
+	rec.ir_free &= ~XFS_INOBT_MASK(offset);
+	rec.ir_freecount--;
+	if (rec.ir_freecount) 
+		error = xfs_inobt_update(cur, &rec);
+	else
+		error = xfs_btree_delete(cur, &i);
+	if (error)
+		goto error_cur;
+
+	/*
+	 * The finobt has now been updated appropriately. We haven't updated the
+	 * agi and superblock yet, so we can create an inobt cursor and validate
+	 * the original freecount. If all is well, make the equivalent update to
+	 * the inobt using the finobt record and offset information.
+	 */
+	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+
+	error = xfs_check_agi_freecount(icur, agi);
+	if (error)
+		goto error_icur;
+
+	error = xfs_dialloc_ag_update_inobt(icur, &rec, offset);
+	if (error)
+		goto error_icur;
+
+	/*
+	 * Both trees have now been updated. We must update the perag and
+	 * superblock before we can check the freecount for each btree.
+	 */
+	be32_add_cpu(&agi->agi_freecount, -1);
+	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
+	pag->pagi_freecount--;
+
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
+
+	error = xfs_check_agi_freecount(icur, agi);
+	if (error)
+		goto error_icur;
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error_icur;
+
+	xfs_btree_del_cursor(icur, XFS_BTREE_NOERROR);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_perag_put(pag);
+	*inop = ino;
+	return 0;
+
+error_icur:
+	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
+error_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_perag_put(pag);
+	return error;
+}
+
+/*
  * Allocate an inode on disk.
  *
  * Mode is used to tell whether the new inode will need space, and whether it
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
