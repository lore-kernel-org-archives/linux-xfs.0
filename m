Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5I7V0xa213408 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 02:31:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D87323E3E48
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 00:33:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	8aHKSlaQCeJUx2An for <xfs@oss.sgi.com>;
	Fri, 18 Jun 2010 00:33:36 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: validate untrusted inode numbers during lookup
Date: Fri, 18 Jun 2010 17:32:52 +1000
Message-Id: <1276846374-23916-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1276846374-23916-1-git-send-email-david@fromorbit.com>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
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
Cc: security@kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we decode a handle or do a bulkstat lookup, we are using an
inode number we cannot trust to be valid. If we are deleting inode
chunks from disk (default noikeep mode), then we cannot trust the on
disk inode buffer for any given inode number to correctly reflect
whether the inode has been unlinked as the di_mode nor the
generation number may have been updated on disk.

This is due to the fact that when we delete an inode chunk, we do
not write the clusters back to disk when they are removed - instead
we mark them stale to avoid them being written back potentially over
the top of something that has been subsequently allocated at that
location. The result is that we can have locations of disk that look
like they contain valid inodes but in reality do not. Hence we
cannot simply convert the inode number to a block number and read
the location from disk to determine if the inode is valid or not.

As a result, and XFS_IGET_BULKSTAT lookup needs to actually look the
inode up in the inode allocation btree to determine if the inode
number is valid or not.

It should be noted even on ikeep filesystems, there is the
possibility that blocks on disk may look like valid inode clusters.
e.g. if there are filesystem images hosted on the filesystem. Hence
even for ikeep filesystems we really need to validate that the inode
number is valid before issuing the inode buffer read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ialloc.c |  139 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 96 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 0cf49f0..06eb987 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1199,6 +1199,81 @@ error0:
 	return error;
 }
 
+static int
+xfs_imap_lookup(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	agino,
+	xfs_agblock_t	agbno,
+	xfs_agblock_t	*chunk_agbno,
+	xfs_agblock_t	*offset_agbno,
+	int		flags)
+{
+	xfs_inobt_rec_incore_t rec;
+	xfs_btree_cur_t	*cur;
+	xfs_buf_t	*agbp;
+	int		error;
+	int		i;
+	xfs_agino_t	startino;
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+				"xfs_ialloc_read_agi() returned "
+				"error %d, agno %d",
+				error, agno);
+		return error;
+	}
+
+	/*
+	 * derive and lookup the exact inode record for the given agino. If the
+	 * record cannot be found, then it's an invalid inode number and we
+	 * should abort.
+	 */
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	startino = agino & ~(XFS_IALLOC_INODES(mp) - 1);
+	error = xfs_inobt_lookup(cur, startino, XFS_LOOKUP_EQ, &i);
+	if (error) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+				"xfs_inobt_lookup() failed");
+		goto error0;
+	}
+	if (i == 0) {
+		error = EINVAL;
+		goto error0;
+	}
+
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+				"xfs_inobt_get_rec() failed");
+		goto error0;
+	}
+	if (i == 0) {
+#ifdef DEBUG
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+				"xfs_inobt_get_rec() failed");
+#endif /* DEBUG */
+		error = XFS_ERROR(EINVAL);
+	}
+error0:
+	xfs_trans_brelse(tp, agbp);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	if (error)
+		return error;
+
+	/* for untrusted inodes check it is allocated first */
+	if ((flags & XFS_IGET_BULKSTAT) &&
+	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
+		return EINVAL;
+
+	*chunk_agbno = XFS_AGINO_TO_AGBNO(mp, rec.ir_startino);
+	*offset_agbno = agbno - *chunk_agbno;
+	return 0;
+}
+
 /*
  * Return the location of the inode in imap, for mapping it into a buffer.
  */
@@ -1259,6 +1334,23 @@ xfs_imap(
 		return XFS_ERROR(EINVAL);
 	}
 
+	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
+
+	/*
+	 * For bulkstat and handle lookups, we have an untrusted inode number
+	 * that we have to verify is valid. We cannot do this just by reading
+	 * the inode buffer as it may have been unlinked and removed leaving
+	 * inodes in stale state on disk. Hence we have to do a btree lookup
+	 * in all cases where an untrusted inode number is passed.
+	 */
+	if (flags & XFS_IGET_BULKSTAT) {
+		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
+					&chunk_agbno, &offset_agbno, flags);
+		if (error)
+			return error;
+		goto out_map;
+	}
+
 	/*
 	 * If the inode cluster size is the same as the blocksize or
 	 * smaller we get to the buffer by simple arithmetics.
@@ -1273,10 +1365,8 @@ xfs_imap(
 		return 0;
 	}
 
-	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
-
 	/*
-	 * If we get a block number passed from bulkstat we can use it to
+	 * If we get a block number passed we can use it to
 	 * find the buffer easily.
 	 */
 	if (imap->im_blkno) {
@@ -1300,50 +1390,13 @@ xfs_imap(
 		offset_agbno = agbno & mp->m_inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 	} else {
-		xfs_btree_cur_t	*cur;	/* inode btree cursor */
-		xfs_inobt_rec_incore_t chunk_rec;
-		xfs_buf_t	*agbp;	/* agi buffer */
-		int		i;	/* temp state */
-
-		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
-		if (error) {
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-					"xfs_ialloc_read_agi() returned "
-					"error %d, agno %d",
-					error, agno);
-			return error;
-		}
-
-		cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
-		if (error) {
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-					"xfs_inobt_lookup() failed");
-			goto error0;
-		}
-
-		error = xfs_inobt_get_rec(cur, &chunk_rec, &i);
-		if (error) {
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-					"xfs_inobt_get_rec() failed");
-			goto error0;
-		}
-		if (i == 0) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-					"xfs_inobt_get_rec() failed");
-#endif /* DEBUG */
-			error = XFS_ERROR(EINVAL);
-		}
- error0:
-		xfs_trans_brelse(tp, agbp);
-		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
+					&chunk_agbno, &offset_agbno, flags);
 		if (error)
 			return error;
-		chunk_agbno = XFS_AGINO_TO_AGBNO(mp, chunk_rec.ir_startino);
-		offset_agbno = agbno - chunk_agbno;
 	}
 
+out_map:
 	ASSERT(agbno >= chunk_agbno);
 	cluster_agbno = chunk_agbno +
 		((offset_agbno / blks_per_cluster) * blks_per_cluster);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
