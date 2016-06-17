Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00DE48181
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:35:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7EFE304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:26 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1CnhPHzuN8W5x95G (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:25 -0700 (PDT)
Subject: [PATCH 043/145] xfs: create helpers for mapping, unmapping,
	and converting file fork extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:35:15 -0700
Message-ID: <146612731576.16048.5963316524847608377.stgit@birch.djwong.org>
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

Create two helper functions to assist with mapping, unmapping, and
converting flag status of extents in a file's data/attr forks.  For
non-shared files we can use the _alloc, _free, and _convert functions;
when reflink comes these functions will be augmented to deal with
shared extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rmap.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 3c13fac..47f37d7 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -1121,11 +1121,53 @@ done:
 	return error;
 }
 
+/*
+ * Convert an unwritten extent to a real extent or vice versa.
+ */
+STATIC int
+xfs_rmap_convert(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	return __xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
+}
+
 #undef	NEW
 #undef	LEFT
 #undef	RIGHT
 #undef	PREV
 
+/*
+ * Find an extent in the rmap btree and unmap it.
+ */
+STATIC int
+xfs_rmap_unmap(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	return __xfs_rmap_free(cur, bno, len, unwritten, oinfo);
+}
+
+/*
+ * Find an extent in the rmap btree and map it.
+ */
+STATIC int
+xfs_rmap_map(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	return __xfs_rmap_alloc(cur, bno, len, unwritten, oinfo);
+}
+
 struct xfs_rmapbt_query_range_info {
 	xfs_rmapbt_query_range_fn	fn;
 	void				*priv;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
