Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 480C17FE0
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:11:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3E5FAC00C
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0vk6GiCyzEpazaQ5 for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:13 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AGBDlh007972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:13 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3AGBCBQ015427
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 08/20] xfs: update the finobt on inode free
Date: Thu, 10 Apr 2014 12:10:58 -0400
Message-Id: <1397146270-42993-9-git-send-email-bfoster@redhat.com>
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

An inode free operation can have several effects on the finobt. If
all inodes have been freed and the chunk deallocated, we remove the
finobt record. If the inode chunk was previously full, we must
insert a new record based on the existing inobt record. Otherwise,
we modify the record in place.

Create the xfs_ifree_finobt() function to identify the potential
scenarios and update the finobt appropriately.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_ialloc.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f0d6397..21af5b3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1454,6 +1454,106 @@ error0:
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
@@ -1521,6 +1621,15 @@ xfs_difree(
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
