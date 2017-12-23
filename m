Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757107AbdLWAoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:44:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0gVk5097539
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:07 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2f1ct0r09g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:07 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0haXB007624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:37 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0hamR028040
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:36 GMT
Subject: [PATCH 07/21] xfs: add scrub cross-referencing helpers for the
 inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:43:35 -0800
Message-ID: <151398981557.18741.8176324698766997260.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the inode btrees that will be used
to cross-reference metadata against the inobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |   99 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    6 +++
 2 files changed, 105 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 3b57ef0..5de1ef3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2751,3 +2751,102 @@ xfs_verify_dir_ino(
 		return false;
 	return xfs_verify_ino(mp, ino);
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
+	uint16_t		holemask;
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
+
+struct xfs_ialloc_count_inodes {
+	xfs_agino_t			count;
+	xfs_agino_t			freecount;
+};
+
+/* Record inode counts across all inobt records. */
+STATIC int
+xfs_ialloc_count_inodes_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xfs_ialloc_count_inodes	*ci = priv;
+
+	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
+	ci->count += irec.ir_count;
+	ci->freecount += irec.ir_freecount;
+
+	return 0;
+}
+
+/* Count allocated and free inodes under an inobt. */
+int
+xfs_ialloc_count_inodes(
+	struct xfs_btree_cur		*cur,
+	xfs_agino_t			*count,
+	xfs_agino_t			*freecount)
+{
+	struct xfs_ialloc_count_inodes	ci = {0};
+	int				error;
+
+	ASSERT(cur->bc_btnum == XFS_BTNUM_INO);
+	error = xfs_btree_query_all(cur, xfs_ialloc_count_inodes_helper, &ci);
+	if (!error) {
+		*count = ci.count;
+		*freecount = ci.freecount;
+	}
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 66a8de0..c5402bb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -170,6 +170,12 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
+int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
+		xfs_agino_t high, bool *exists);
+int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
+		xfs_agino_t *freecount);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,

