Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27240 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933269AbdHYWRO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:17:14 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMHDde022054
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMHDg4016164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:13 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMHDCC022901
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:13 GMT
Subject: [PATCH 03/19] xfs: add repair helpers for the reverse mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:17:08 -0700
Message-ID: <150369942803.9957.11932753417949296877.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the reverse mapping btree that will be used
to repair the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h |    4 ++
 2 files changed, 83 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 9c33fd6..d14af8b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1977,6 +1977,34 @@ xfs_rmap_map_shared(
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
@@ -2391,3 +2419,54 @@ xfs_rmap_record_exists(
 		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
 	return 0;
 }
+
+struct xfs_rmap_has_other_keys {
+	uint64_t			owner;
+	uint64_t			offset;
+	bool				*has_rmap;
+	unsigned int			flags;
+};
+
+/* For each rmap given, figure out if it doesn't match the key we want. */
+STATIC int
+xfs_rmap_has_other_keys_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_rmap_has_other_keys	*rhok = priv;
+
+	if (rhok->owner == rec->rm_owner && rhok->offset == rec->rm_offset &&
+	    ((rhok->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rhok->flags)
+		return 0;
+	*rhok->has_rmap = true;
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
+	struct xfs_rmap_has_other_keys	rhok;
+
+	xfs_owner_info_unpack(oinfo, &rhok.owner, &rhok.offset, &rhok.flags);
+	*has_rmap = false;
+	rhok.has_rmap = has_rmap;
+
+	low.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno + len - 1;
+
+	return xfs_rmap_query_range(cur, &low, &high,
+			xfs_rmap_has_other_keys_helper, &rhok);
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 32c9382..180b127 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -224,5 +224,9 @@ int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
+int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
+int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
 #endif	/* __XFS_RMAP_H__ */

