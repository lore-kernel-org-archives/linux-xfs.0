Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39999 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754294AbcKEA12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:28 -0400
Subject: [PATCH 27/39] xfs: cross-reference reverse-mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:24 -0700
Message-ID: <147830564483.4165.15700660701028715848.stgit@birch.djwong.org>
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

When scrubbing various btrees, we should cross-reference the records
with the reverse mapping btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rmap.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap.h |    5 +++++
 2 files changed, 63 insertions(+)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 97fc4dd..0b8eed1 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2304,3 +2304,61 @@ xfs_rmap_free_extent(
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_FREE, owner,
 			XFS_DATA_FORK, &bmap);
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.r.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.r.rm_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_record_exists(
+	struct xfs_btree_cur	*cur,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	struct xfs_owner_info	*oinfo,
+	bool			*has_rmap)
+{
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags;
+	int			stat;
+	struct xfs_rmap_irec	irec;
+	int			error;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	error = xfs_rmap_get_rec(cur, &irec, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	*has_rmap = (irec.rm_startblock <= bno &&
+		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
+	return 0;
+}
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 3fa4559..ea359ab 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -217,5 +217,10 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
 
 #endif	/* __XFS_RMAP_H__ */

