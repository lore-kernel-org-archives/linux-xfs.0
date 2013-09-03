Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC2617F54
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D611304087
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nK8S27oNXoGuckJh for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:47 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPl6Q031080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r83IPkmC021394
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 10/11] xfs: update the finobt on inode free
Date: Tue,  3 Sep 2013 14:25:07 -0400
Message-Id: <1378232708-57156-11-git-send-email-bfoster@redhat.com>
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

An inode free operation can have several effects on the finobt. If
all inodes have been freed and the chunk deallocated, we remove the
finobt record. If the inode chunk was previously full, we must
insert a new record based on the existing inobt record. Otherwise,
we modify the record in place.

Create the xfs_ifree_finobt() function to identify the potential
scenarios and update the finobt appropriately.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 516f4af..96f71b5 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -198,6 +198,117 @@ xfs_inobt_insert(
 }
 
 /*
+ * Free an inode in the free inode btree.
+ */
+STATIC int
+xfs_ifree_finobt(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	struct xfs_inobt_rec_incore	*ibtrec,/* inobt record */
+	int				offset)	/* offset of inode */
+{
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	struct xfs_btree_cur		*cur;
+	struct xfs_inobt_rec_incore	rec;
+	int				error;
+	int				i;
+
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+		return 0;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+
+	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		goto error;
+
+	if (i == 1) {
+		int j;
+		/*
+		 * Read and update the existing record.
+		 */
+		error = xfs_inobt_get_rec(cur, &rec, &j);
+		if (error)
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(j == 1, error);
+
+		rec.ir_free |= XFS_INOBT_MASK(offset);
+		rec.ir_freecount++;
+
+		XFS_WANT_CORRUPTED_GOTO((rec.ir_free == ibtrec->ir_free) &&
+					(rec.ir_freecount == ibtrec->ir_freecount),
+					error);
+	}
+
+	/*
+	 * The content of inobt records should always match between the inobt
+	 * and finobt. The lifecycle of records in the finobt is different from
+	 * the inobt in that the finobt only tracks records with at least one
+	 * free inode. This is to optimize lookup for inode allocation purposes.
+	 * The following checks fix up the finobt appropriately based on the
+	 * state of the record subsequent to the current operation.
+	 */
+
+	if ((i == 1) &&
+	    (rec.ir_freecount == XFS_IALLOC_INODES(mp) &&
+	     !(mp->m_flags & XFS_MOUNT_IKEEP))) {
+		/*
+		 * We have an existing finobt record. If all inodes are free
+		 * and we're in !ikeep mode, the entire inode chunk has been
+		 * deallocated. Remove the record from the finobt.
+		 */
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto error;
+		ASSERT(i == 1);
+	} else if ((i == 0) && (ibtrec->ir_freecount == 1)) {
+		/*
+		 * No existing finobt record and the inobt record has a single
+		 * free inode. This means we've freed an inode in a previously
+		 * fully allocated chunk. Insert a new record into the finobt
+		 * based on the current inobt record.
+		 */
+		cur->bc_rec.i.ir_startino = ibtrec->ir_startino;
+		cur->bc_rec.i.ir_free = ibtrec->ir_free;
+		cur->bc_rec.i.ir_freecount = ibtrec->ir_freecount;
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto error;
+		ASSERT(i == 1);
+	} else if (i == 1) {
+		/*
+		 * The existing finobt record was modified and has a combination
+		 * of allocated and free inodes or is completely free and ikeep
+		 * is enabled. Update the record.
+		 */
+		error = xfs_inobt_update(cur, &rec);
+		if (error)
+			goto error;
+	} else {
+		/* somehow out of sync */
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     agbp->b_addr);
+		ASSERT(0);
+
+		error = XFS_ERROR(EFSCORRUPTED);
+		goto error;
+	}
+
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return error;
+}
+
+/*
  * Initialise a new set of inodes. When called without a transaction context
  * (e.g. from recovery) we initiate a delayed write of the inode buffers rather
  * than logging them (which in a transaction context puts them into the AIL
@@ -1422,6 +1533,15 @@ xfs_difree(
 	if (error)
 		goto error0;
 
+	/*
+	 * Fix up the free inode btree.
+	 */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		error = xfs_ifree_finobt(mp, tp, agbp, &rec, off);
+		if (error)
+			goto error0;
+	}
+
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
