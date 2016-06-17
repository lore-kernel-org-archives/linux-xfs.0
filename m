Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B68178474
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:44:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A8A0AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ees1io5VaHKZ0r7u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:44:54 -0700 (PDT)
Subject: [PATCH 133/145] xfs_repair: use range query when while checking rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:44:44 -0700
Message-ID: <146612788463.16048.1497238555000280268.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

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
 repair/rmap.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)


diff --git a/repair/rmap.c b/repair/rmap.c
index 5c0e015..1b89d4c 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -909,6 +909,20 @@ lookup_rmap(
 	return xfs_rmap_get_rec(bt_cur, tmp, have);
 }
 
+/* Look for an rmap in the rmapbt that matches a given rmap. */
+static int
+lookup_rmap_overlapped(
+	struct xfs_btree_cur	*bt_cur,
+	struct xfs_rmap_irec	*rm_rec,
+	struct xfs_rmap_irec	*tmp,
+	int			*have)
+{
+	/* Have to use our fancy version for overlapped */
+	return xfs_rmap_lookup_le_range(bt_cur, rm_rec->rm_startblock,
+				rm_rec->rm_owner, rm_rec->rm_offset,
+				rm_rec->rm_flags, tmp, have);
+}
+
 /* Does the btree rmap cover the observed rmap? */
 #define NEXTP(x)	((x)->rm_startblock + (x)->rm_blockcount)
 #define NEXTL(x)	((x)->rm_offset + (x)->rm_blockcount)
@@ -997,6 +1011,18 @@ check_rmaps(
 		error = lookup_rmap(bt_cur, rm_rec, &tmp, &have);
 		if (error)
 			goto err;
+		/*
+		 * Using the range query is expensive, so only do it if
+		 * the regular lookup doesn't find anything or if it doesn't
+		 * match the observed rmap.
+		 */
+		if (xfs_sb_version_hasreflink(&bt_cur->bc_mp->m_sb) &&
+				(!have || !is_good_rmap(rm_rec, &tmp))) {
+			error = lookup_rmap_overlapped(bt_cur, rm_rec,
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
