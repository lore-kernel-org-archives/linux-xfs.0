Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 988977DA7
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:22:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1128EAC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:22:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id tMFRv4xxAg23v0NO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:22:14 -0700 (PDT)
Subject: [PATCH 040/119] xfs: create helpers for mapping, unmapping,
	and converting file fork extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:22:08 -0700
Message-ID: <146612652855.12839.8509289990733155675.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Create two helper functions to assist with mapping, unmapping, and
converting flag status of extents in a file's data/attr forks.  For
non-shared files we can use the _alloc, _free, and _convert functions;
when reflink comes these functions will be augmented to deal with
shared extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index f92eaa1..76fc5c2 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1123,11 +1123,53 @@ done:
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
