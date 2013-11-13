Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66A087F50
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:37:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 355228F8035
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 06:37:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id msz2hhAFnHWPcEWs for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 06:37:10 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADEbAmN024553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:37:10 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADEb9sC031368
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:37:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 08/11] xfs: update the finobt on inode free
Date: Wed, 13 Nov 2013 09:37:04 -0500
Message-Id: <1384353427-36205-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
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

An inode free operation can have several effects on the finobt. If
all inodes have been freed and the chunk deallocated, we remove the
finobt record. If the inode chunk was previously full, we must
insert a new record based on the existing inobt record. Otherwise,
we modify the record in place.

Create the xfs_ifree_finobt() function to identify the potential
scenarios and update the finobt appropriately.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index fd77b28..de46ba2 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1479,6 +1479,106 @@ error0:
 }
 
 /*
+ * Free an inode in the free inode btree.
+ */
+STATIC int
+xfs_difree_finobt(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	xfs_agino_t			agino,
+	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
+{
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	struct xfs_btree_cur		*cur;
+	struct xfs_inobt_rec_incore	rec;
+	int				offset = agino - ibtrec->ir_startino;
+	int				error;
+	int				i;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+
+	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		goto error;
+	if (i == 0) {
+		/*
+		 * If the record does not exist in the finobt, we must have just
+		 * freed an inode in a previously fully allocated chunk. If not,
+		 * something is out of sync.
+		 */
+		XFS_WANT_CORRUPTED_GOTO(ibtrec->ir_freecount == 1, error);
+
+		error = xfs_inobt_insert_rec(cur, ibtrec->ir_freecount,
+					     ibtrec->ir_free, &i);
+		if (error)
+			goto error;
+		ASSERT(i == 1);
+
+		goto out;
+	}
+
+	/*
+	 * Read and update the existing record.
+	 */
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+
+	rec.ir_free |= XFS_INOBT_MASK(offset);
+	rec.ir_freecount++;
+
+	XFS_WANT_CORRUPTED_GOTO((rec.ir_free == ibtrec->ir_free) &&
+				(rec.ir_freecount == ibtrec->ir_freecount),
+				error);
+
+	/*
+	 * The content of inobt records should always match between the inobt
+	 * and finobt. The lifecycle of records in the finobt is different from
+	 * the inobt in that the finobt only tracks records with at least one
+	 * free inode. This is to optimize lookup for inode allocation purposes.
+	 * The following checks determine whether to update the existing record or
+	 * remove it entirely.
+	 */
+
+	if (rec.ir_freecount == XFS_IALLOC_INODES(mp) &&
+	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+		/*
+		 * If all inodes are free and we're in !ikeep mode, the entire
+		 * inode chunk has been deallocated. Remove the record from the
+		 * finobt.
+		 */
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto error;
+		ASSERT(i == 1);
+	} else {
+		/*
+		 * The existing finobt record was modified and has a combination
+		 * of allocated and free inodes or is completely free and ikeep
+		 * is enabled. Update the record.
+		 */
+		error = xfs_inobt_update(cur, &rec);
+		if (error)
+			goto error;
+	}
+
+out:
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
  * Free disk inode.  Carefully avoids touching the incore inode, all
  * manipulations incore are the caller's responsibility.
  * The on-disk inode is not changed by this operation, only the
@@ -1546,6 +1646,15 @@ xfs_difree(
 	if (error)
 		goto error0;
 
+	/*
+	 * Fix up the free inode btree.
+	 */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		error = xfs_difree_finobt(mp, tp, agbp, agino, &rec);
+		if (error)
+			goto error0;
+	}
+
 	return 0;
 
 error0:
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
