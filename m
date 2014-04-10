Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85A587FE9
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:11:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B4138F8035
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GJE9gdSNauf9yAIU for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:14 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AGBD8x005014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:13 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s3AGBCQu000747
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 06/20] xfs: use and update the finobt on inode allocation
Date: Thu, 10 Apr 2014 12:10:56 -0400
Message-Id: <1397146270-42993-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
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
xfs_dialloc_ag_slow() and fall back as such if finobt support is
not enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_ialloc.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 210 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c5759aa..462340b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -699,7 +699,7 @@ xfs_ialloc_get_rec(
  * available.
  */
 STATIC int
-xfs_dialloc_ag(
+xfs_dialloc_ag_slow(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
 	xfs_ino_t		parent,
@@ -957,6 +957,215 @@ error0:
 	return error;
 }
 
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
+	struct xfs_btree_cur		*cur;
+	struct xfs_btree_cur		*tcur;
+	struct xfs_inobt_rec_incore	rec;
+	struct xfs_inobt_rec_incore	trec;
+	xfs_ino_t			ino;
+	int				error;
+	int				offset;
+	int				i, j;
+
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+		return xfs_dialloc_ag_slow(tp, agbp, parent, inop);
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
+	if (agno == pagno) {
+		/*
+		 * We're in the same AG as the parent inode so allocate the
+		 * closest inode to the parent.
+		 */
+		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
+		if (error)
+			goto error_cur;
+		if (i == 1) {
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+			if (error)
+				goto error_cur;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
+
+			/*
+			 * See if we've landed in the parent inode record. The
+			 * finobt only tracks chunks with at least one free
+			 * inode, so record existence is enough.
+			 */
+			if (pagino >= rec.ir_startino &&
+			    pagino < (rec.ir_startino + XFS_INODES_PER_CHUNK))
+				goto alloc_inode;
+		}
+
+		error = xfs_btree_dup_cursor(cur, &tcur);
+		if (error) 
+			goto error_cur;
+
+		error = xfs_inobt_lookup(tcur, pagino, XFS_LOOKUP_GE, &j);
+		if (error)
+			goto error_tcur;
+		if (j == 1) {
+			error = xfs_inobt_get_rec(tcur, &trec, &j);
+			if (error)
+				goto error_tcur;
+			XFS_WANT_CORRUPTED_GOTO(j == 1, error_tcur);
+		}
+
+		if (i == 1 && j == 1) {
+			if ((pagino - rec.ir_startino + XFS_INODES_PER_CHUNK - 1) >
+			    (trec.ir_startino - pagino)) {
+				rec = trec;
+				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+				cur = tcur;
+			} else {
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+			}
+		} else if (j == 1) {
+			rec = trec;
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			cur = tcur;
+		} else {
+			xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+		}
+	} else {
+		/*
+		 * Different AG from the parent inode. Check the record for the
+		 * most recently allocated inode.
+		 */
+		if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
+			error = xfs_inobt_lookup(cur, agi->agi_newino,
+						 XFS_LOOKUP_EQ, &i);
+			if (error)
+				goto error_cur;
+			if (i == 1) {
+				error = xfs_inobt_get_rec(cur, &rec, &i);
+				if (error)
+					goto error_cur;
+				XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
+				goto alloc_inode;
+			}
+		}
+
+		/*
+		 * Allocate the first inode available in the AG.
+		 */
+		error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
+		if (error)
+			goto error_cur;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
+
+		error = xfs_inobt_get_rec(cur, &rec, &i);
+		if (error)
+			goto error_cur;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
+	}
+
+alloc_inode:
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
+	 * Lookup and modify the equivalent record in the inobt.
+	 */
+	tcur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+
+	error = xfs_check_agi_freecount(tcur, agi);
+	if (error)
+		goto error_tcur;
+
+	error = xfs_inobt_lookup(tcur, rec.ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		goto error_tcur;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error_tcur);
+
+	error = xfs_inobt_get_rec(tcur, &trec, &i);
+	if (error)
+		goto error_tcur;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error_tcur);
+	ASSERT((XFS_AGINO_TO_OFFSET(mp, trec.ir_startino) %
+				   XFS_INODES_PER_CHUNK) == 0);
+
+	trec.ir_free &= ~XFS_INOBT_MASK(offset);
+	trec.ir_freecount--;
+
+	XFS_WANT_CORRUPTED_GOTO((rec.ir_free == trec.ir_free) &&
+				(rec.ir_freecount == trec.ir_freecount),
+				error_tcur);
+
+	error = xfs_inobt_update(tcur, &trec);
+	if (error)
+		goto error_tcur;
+
+	/*
+	 * Update the perag and superblock.
+	 */
+	be32_add_cpu(&agi->agi_freecount, -1);
+	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
+	pag->pagi_freecount--;
+
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
+
+	error = xfs_check_agi_freecount(tcur, agi);
+	if (error)
+		goto error_tcur;
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error_tcur;
+
+	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_perag_put(pag);
+	*inop = ino;
+	return 0;
+
+error_tcur:
+	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
+error_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * Allocate an inode on disk.
  *
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
