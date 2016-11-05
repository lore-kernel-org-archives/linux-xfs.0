Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19014 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754285AbcKEA1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:21 -0400
Subject: [PATCH 26/39] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:18 -0700
Message-ID: <147830563877.4165.16863165530527928489.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ialloc.h |    4 ++++
 2 files changed, 62 insertions(+)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 1445315..3d02a16 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2660,3 +2660,61 @@ xfs_ialloc_pagi_init(
 		xfs_trans_brelse(tp, bp);
 	return 0;
 }
+
+/* Is there an inode record covering a given range of inode numbers? */
+int
+xfs_ialloc_has_inode_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agino_t		low,
+	xfs_agino_t		high,
+	bool			*exists)
+{
+	struct xfs_inobt_rec_incore	irec;
+	xfs_agino_t		agino;
+	__uint16_t		holemask;
+	int			has;
+	int			i;
+	int			error;
+
+	*exists = false;
+	error = xfs_inobt_lookup(cur, low, XFS_LOOKUP_LE, &has);
+	while (error == 0 && has) {
+		error = xfs_inobt_get_rec(cur, &irec, &has);
+		if (error || irec.ir_startino > high)
+			break;
+
+		agino = irec.ir_startino;
+		holemask = irec.ir_holemask;
+		for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
+				i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
+			if (holemask & 1)
+				continue;
+			if (agino + XFS_INODES_PER_HOLEMASK_BIT > low &&
+					agino <= high) {
+				*exists = true;
+				goto out;
+			}
+		}
+
+		error = xfs_btree_increment(cur, 0, &has);
+	}
+out:
+	return error;
+}
+
+/* Is there an inode record covering a given extent? */
+int
+xfs_ialloc_has_inodes_at_extent(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	xfs_agino_t		low;
+	xfs_agino_t		high;
+
+	low = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno, 0);
+	high = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno + len, 0) - 1;
+
+	return xfs_ialloc_has_inode_record(cur, low, high, exists);
+}
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 8e5861d..f20d958 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -171,5 +171,9 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
+int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
+		xfs_agino_t high, bool *exists);
 
 #endif	/* __XFS_IALLOC_H__ */

