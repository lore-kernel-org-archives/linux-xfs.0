Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47281 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932328AbcJYXHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:07:31 -0400
Subject: [PATCH 36/39] xfs_repair: use range query when while checking rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:07:26 -0700
Message-ID: <147743684680.11035.15884312919264954016.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

For shared extents, we ought to use a range query on the rmapbt to
find the corresponding rmap.  However, most of the time the observed
rmap will be an exact match for the rmapbt rmap, in which case we
could have used the (much faster) regular lookup.  Therefore, try the
regular lookup first and resort to the range lookup if that doesn't
get us what we want.  This can cut the run time of the rmap check of
xfs_repair in half.

Theoretically, the only reason why an observed rmap wouldn't be an
exact match for an rmapbt rmap is because we modified some file on
account of a metadata error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/rmap.c            |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8c15b75..e95763d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -141,5 +141,6 @@
 #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
 #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
+#define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/rmap.c b/repair/rmap.c
index 849b788..db5a30f 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -916,6 +916,20 @@ rmap_lookup(
 	return -libxfs_rmap_get_rec(bt_cur, tmp, have);
 }
 
+/* Look for an rmap in the rmapbt that matches a given rmap. */
+static int
+rmap_lookup_overlapped(
+	struct xfs_btree_cur	*bt_cur,
+	struct xfs_rmap_irec	*rm_rec,
+	struct xfs_rmap_irec	*tmp,
+	int			*have)
+{
+	/* Have to use our fancy version for overlapped */
+	return -libxfs_rmap_lookup_le_range(bt_cur, rm_rec->rm_startblock,
+				rm_rec->rm_owner, rm_rec->rm_offset,
+				rm_rec->rm_flags, tmp, have);
+}
+
 /* Does the btree rmap cover the observed rmap? */
 #define NEXTP(x)	((x)->rm_startblock + (x)->rm_blockcount)
 #define NEXTL(x)	((x)->rm_offset + (x)->rm_blockcount)
@@ -1004,6 +1018,18 @@ rmaps_verify_btree(
 		error = rmap_lookup(bt_cur, rm_rec, &tmp, &have);
 		if (error)
 			goto err;
+		/*
+		 * Using the range query is expensive, so only do it if
+		 * the regular lookup doesn't find anything or if it doesn't
+		 * match the observed rmap.
+		 */
+		if (xfs_sb_version_hasreflink(&bt_cur->bc_mp->m_sb) &&
+				(!have || !rmap_is_good(rm_rec, &tmp))) {
+			error = rmap_lookup_overlapped(bt_cur, rm_rec,
+					&tmp, &have);
+			if (error)
+				goto err;
+		}
 		if (!have) {
 			do_warn(
 _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \

