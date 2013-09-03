Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A03567F53
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FEBE8F8035
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TmH1mgeCwwCQ1sFV for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:47 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPlLm005968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r83IPkUd011559
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 09/11] xfs: use and update the finobt on inode allocation
Date: Tue,  3 Sep 2013 14:25:06 -0400
Message-Id: <1378232708-57156-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_ialloc.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 135 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e64a728..516f4af 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -708,7 +708,7 @@ xfs_ialloc_get_rec(
  * available.
  */
 STATIC int
-xfs_dialloc_ag(
+xfs_dialloc_ag_slow(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
 	xfs_ino_t		parent,
@@ -966,6 +966,140 @@ error0:
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
+	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
+	struct xfs_perag		*pag;
+	struct xfs_btree_cur		*fcur;
+	struct xfs_btree_cur		*icur;
+	struct xfs_inobt_rec_incore	frec;
+	struct xfs_inobt_rec_incore	irec;
+	xfs_ino_t			ino;
+	int				error;
+	int				offset;
+	int				i;
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
+	fcur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+
+	error = xfs_check_agi_freecount(fcur, agi);
+	if (error)
+		goto error;
+	error = xfs_check_agi_freecount(icur, agi);
+	if (error)
+		goto error;
+
+	/*
+	 * Search the finobt.
+	 */
+	error = xfs_inobt_lookup(fcur, pagino, XFS_LOOKUP_LE, &i);
+	if (error)
+		goto error;
+	if (i == 0) {
+		error = xfs_inobt_lookup(fcur, pagino, XFS_LOOKUP_GE, &i);
+		if (error)
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+	}
+
+	error = xfs_inobt_get_rec(fcur, &frec, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+
+	offset = xfs_lowbit64(frec.ir_free);
+	ASSERT(offset >= 0);
+	ASSERT(offset < XFS_INODES_PER_CHUNK);
+	ASSERT((XFS_AGINO_TO_OFFSET(mp, frec.ir_startino) %
+				   XFS_INODES_PER_CHUNK) == 0);
+	ino = XFS_AGINO_TO_INO(mp, agno, frec.ir_startino + offset);
+
+	/*
+	 * Modify or remove the finobt record.
+	 */
+	frec.ir_free &= ~XFS_INOBT_MASK(offset);
+	frec.ir_freecount--;
+	if (frec.ir_freecount) 
+		error = xfs_inobt_update(fcur, &frec);
+	else
+		error = xfs_btree_delete(fcur, &i);
+	if (error)
+		goto error;
+
+	/*
+	 * Lookup and modify the equivalent record in the inobt.
+	 */
+	error = xfs_inobt_lookup(icur, frec.ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+
+	error = xfs_inobt_get_rec(icur, &irec, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+	ASSERT((XFS_AGINO_TO_OFFSET(mp, irec.ir_startino) %
+				   XFS_INODES_PER_CHUNK) == 0);
+
+	irec.ir_free &= ~XFS_INOBT_MASK(offset);
+	irec.ir_freecount--;
+
+	XFS_WANT_CORRUPTED_GOTO((frec.ir_free == irec.ir_free) &&
+				(frec.ir_freecount == irec.ir_freecount),
+				error);
+
+	error = xfs_inobt_update(icur, &irec);
+	if (error)
+		goto error;
+
+	/*
+	 * Update the perag and superblock.
+	 */
+	be32_add_cpu(&agi->agi_freecount, -1);
+	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
+	pag->pagi_freecount--;
+
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
+	xfs_perag_put(pag);
+
+	error = xfs_check_agi_freecount(fcur, agi);
+	if (error)
+		goto error;
+	error = xfs_check_agi_freecount(icur, agi);
+	if (error)
+		goto error;
+
+	xfs_btree_del_cursor(icur, XFS_BTREE_NOERROR);
+	xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
+	*inop = ino;
+	return 0;
+error:
+	xfs_perag_put(pag);
+	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
+	xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
+	return error;
+}
+
 /*
  * Allocate an inode on disk.
  *
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
