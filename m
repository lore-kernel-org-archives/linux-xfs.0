Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35758 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753080AbeAEVxn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jan 2018 16:53:43 -0500
Date: Fri, 5 Jan 2018 13:53:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 08/21] xfs: add scrub cross-referencing helpers for the
 rmap btrees
Message-ID: <20180105215339.GL5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398982164.18741.14153975836991113575.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398982164.18741.14153975836991113575.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the rmap btrees that will be used
to cross-reference metadata against the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: expand documentation to clarify the behavior of _record_exists
---
 fs/xfs/libxfs/xfs_rmap.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h |    5 +++
 2 files changed, 72 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 50db920..79822cf 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2387,3 +2387,70 @@ xfs_rmap_compare(
 	else
 		return 0;
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
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
+/*
+ * Is there a record for this owner completely covering a given physical
+ * extent?  If so, *has_rmap will be set to true.  If there is no record
+ * or the record only covers part of the range, we set *has_rmap to false.
+ * This function doesn't perform range lookups or offset checks, so it is
+ * not suitable for checking data fork blocks.
+ */
+int
+xfs_rmap_record_exists(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo,
+	bool			*has_rmap)
+{
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags;
+	int			has_record;
+	struct xfs_rmap_irec	irec;
+	int			error;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+	ASSERT(XFS_RMAP_NON_INODE_OWNER(owner) ||
+	       (flags & XFS_RMAP_BMBT_BLOCK));
+
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags,
+			&has_record);
+	if (error)
+		return error;
+	if (!has_record) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	error = xfs_rmap_get_rec(cur, &irec, &has_record);
+	if (error)
+		return error;
+	if (!has_record) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	*has_rmap = (irec.rm_owner == owner && irec.rm_startblock <= bno &&
+		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 0fcd5b1..380e53b 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -233,5 +233,10 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
 
 #endif	/* __XFS_RMAP_H__ */
