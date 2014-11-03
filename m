Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B12857F51
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:38:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C3FE304032
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:38:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tqXiB4iFwPJxsmZR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:38:15 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GcEcE015780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:38:14 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCS1v023875
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 08/17] xfs: create helper to manage record overlap for
	sparse inode chunks
Date: Mon,  3 Nov 2014 11:12:17 -0500
Message-Id: <1415031146-9107-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
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

Create xfs_inobt_rec_exists() to receive the parameters of a new sparse
inode chunk allocation and identify whether a record exists that is
capable of tracking this sparse chunk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b53fb5d..6879213 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -359,6 +359,67 @@ xfs_ialloc_inode_init(
 }
 
 /*
+ * Determine whether part of a sparse inode chunk that has just been allocated
+ * is covered by an existing inobt record.
+ */
+STATIC int
+xfs_inobt_rec_exists(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	xfs_agino_t			newino,
+	xfs_agino_t			count,
+	xfs_btnum_t			btnum,
+	struct xfs_inobt_rec_incore	*orec)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	int				error;
+	int				i;
+	struct xfs_inobt_rec_incore	rec;
+
+	orec->ir_startino = NULLAGINO;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+
+	/*
+	 * Find the first record prior to the inode that has just been
+	 * allocated.
+	 */
+	error = xfs_inobt_lookup(cur, newino, XFS_LOOKUP_LE, &i);
+	if (error)
+		goto error;
+	if (i == 0)
+		goto out;
+
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+
+	/*
+	 * Check whether the record covers a range that includes the new inodes.
+	 * We can't allocate a sparse chunk that spans multiple records, so we
+	 * only need to check the ino range.
+	 */
+	if (rec.ir_startino + XFS_INODES_PER_CHUNK <= newino)
+		goto out;
+
+	ASSERT(rec.ir_startino <= newino &&
+	       rec.ir_startino + XFS_INODES_PER_CHUNK > newino);
+
+	*orec = rec;	/* struct copy */
+
+out:
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
