Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE21C837C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:57:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B063D8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:57:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GnGgoqT9oYxmeewf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:57:18 -0700 (PDT)
Subject: [PATCH 18/24] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:57:14 -0700
Message-ID: <147216943485.6398.7135955874180910126.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ialloc.h |    4 ++++
 2 files changed, 62 insertions(+)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b880f78..2a1dc47 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2659,3 +2659,61 @@ xfs_ialloc_pagi_init(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
