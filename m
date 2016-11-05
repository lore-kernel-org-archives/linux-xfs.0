Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19126 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754341AbcKEA16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:58 -0400
Subject: [PATCH 32/39] xfs: rebuild the rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:55 -0700
Message-ID: <147830567519.4165.13826961638090689882.stgit@birch.djwong.org>
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

Rebuild the reverse mapping btree from all primary metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_refcount.c |    2 +-
 libxfs/xfs_refcount.h |    3 +++
 libxfs/xfs_rmap.c     |   28 ++++++++++++++++++++++++++++
 libxfs/xfs_rmap.h     |    1 +
 4 files changed, 33 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 124d5c0..be0eab3 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -87,7 +87,7 @@ xfs_refcount_lookup_ge(
 }
 
 /* Convert on-disk record to in-core format. */
-static inline void
+void
 xfs_refcount_btrec_to_irec(
 	union xfs_btree_rec		*rec,
 	struct xfs_refcount_irec	*irec)
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 78cb142..5973c56 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -69,5 +69,8 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+union xfs_btree_rec;
+extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_refcount_irec *irec);
 
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index c7d8aac..77ddb0b 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -1975,6 +1975,34 @@ xfs_rmap_map_shared(
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
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 606efe3..eac90d7 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -225,5 +225,6 @@ int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		xfs_filblks_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
+int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
 #endif	/* __XFS_RMAP_H__ */

