Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B0A182BE
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:54:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F0B88F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:54:06 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9HcHLOpgZArJOc0x (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:54:04 -0700 (PDT)
Subject: [PATCH 69/71] xfs_repair: use range query when while checking rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:54:00 -0700
Message-ID: <147216924076.4420.12782764054758153515.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
index 28bac11..8026522 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -140,5 +140,6 @@
 #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
 #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
+#define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/rmap.c b/repair/rmap.c
index c53d6b7..597655b 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -909,6 +909,20 @@ rmap_lookup(
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
@@ -997,6 +1011,18 @@ rmaps_verify_btree(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
