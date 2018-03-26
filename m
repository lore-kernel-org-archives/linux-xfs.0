Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeCZX4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 19:56:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2QNpuFG005302
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:15 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2gyawe808p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:15 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNuE3f008634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:14 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNuEbr022766
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:14 GMT
Subject: [PATCH 03/20] xfs: add repair helpers for the reverse mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 26 Mar 2018 16:56:13 -0700
Message-ID: <152210857318.13184.219852203461550085.stgit@magnolia>
In-Reply-To: <152210855435.13184.6475770131389744177.stgit@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
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
index 79822cf..c051d47 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2031,6 +2031,34 @@ xfs_rmap_map_shared(
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
@@ -2454,3 +2482,54 @@ xfs_rmap_record_exists(
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

