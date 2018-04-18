Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45638 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRClg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:36 -0400
Subject: [PATCH 4/9] xfs: add repair helpers for the reverse mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:41:17 -0700
Message-ID: <152401927719.11792.16362101708177668747.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the reverse mapping btree that will be used
to repair the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h |    4 ++
 2 files changed, 85 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index fba8d27..3d7fa03 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2030,6 +2030,34 @@ xfs_rmap_map_shared(
 	return error;
 }
 
+/* Insert a raw rmap into the rmapbt. */
+int
+xfs_rmap_map_raw(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rmap)
+{
+	struct xfs_owner_info	oinfo;
+
+	oinfo.oi_owner = rmap->rm_owner;
+	oinfo.oi_offset = rmap->rm_offset;
+	oinfo.oi_flags = 0;
+	if (rmap->rm_flags & XFS_RMAP_ATTR_FORK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (rmap->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+
+	if (rmap->rm_flags || XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+		return xfs_rmap_map(cur, rmap->rm_startblock,
+				rmap->rm_blockcount,
+				rmap->rm_flags & XFS_RMAP_UNWRITTEN,
+				&oinfo);
+
+	return xfs_rmap_map_shared(cur, rmap->rm_startblock,
+			rmap->rm_blockcount,
+			rmap->rm_flags & XFS_RMAP_UNWRITTEN,
+			&oinfo);
+}
+
 struct xfs_rmap_query_range_info {
 	xfs_rmap_query_range_fn	fn;
 	void				*priv;
@@ -2453,3 +2481,56 @@ xfs_rmap_record_exists(
 		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
 	return 0;
 }
+
+struct xfs_rmap_key_state {
+	uint64_t			owner;
+	uint64_t			offset;
+	unsigned int			flags;
+	bool				has_rmap;
+};
+
+/* For each rmap given, figure out if it doesn't match the key we want. */
+STATIC int
+xfs_rmap_has_other_keys_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_rmap_key_state	*rks = priv;
+
+	if (rks->owner == rec->rm_owner && rks->offset == rec->rm_offset &&
+	    ((rks->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rks->flags)
+		return 0;
+	rks->has_rmap = true;
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/*
+ * Given an extent and some owner info, can we find records overlapping
+ * the extent whose owner info does not match the given owner?
+ */
+int
+xfs_rmap_has_other_keys(
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo,
+	bool				*has_rmap)
+{
+	struct xfs_rmap_irec		low = {0};
+	struct xfs_rmap_irec		high;
+	struct xfs_rmap_key_state	rks;
+	int				error;
+
+	xfs_owner_info_unpack(oinfo, &rks.owner, &rks.offset, &rks.flags);
+	rks.has_rmap = false;
+
+	low.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno + len - 1;
+
+	error = xfs_rmap_query_range(cur, &low, &high,
+			xfs_rmap_has_other_keys_helper, &rks);
+	*has_rmap = rks.has_rmap;
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 380e53b..43e506f 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -238,5 +238,9 @@ int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
+int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
+int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
 #endif	/* __XFS_RMAP_H__ */

