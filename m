Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCC2F800E
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:58:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC8198F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:57 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id rf2IOW8kl1gUboxT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:43 -0800 (PST)
Subject: [PATCH 21/76] xfs: enhance rmap btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:58:40 -0800
Message-ID: <20151219085840.12713.88949.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Adapt the rmap btree to store owner offsets within each rmap record,
and to handle the primary key being extended to [agblk, owner, offset].
The expansion of the primary key is crucial to allowing multiple owners
per extent.  Unfortunately, doing so adds the requirement that all rmap
records for file extents (metadata always has one owner) correspond to
some bmbt entry somewhere.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c       |   32 +++++++++++++++++---
 fs/xfs/libxfs/xfs_rmap_btree.c |   65 ++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_rmap_btree.h |    7 ++++
 3 files changed, 84 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 64b2525..f6fe742 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -37,26 +37,48 @@
 #include "xfs_extent_busy.h"
 
 /*
- * Lookup the first record less than or equal to [bno, len]
+ * Lookup the first record less than or equal to [bno, len, owner, offset]
  * in the btree given by cur.
  */
-STATIC int
+int
 xfs_rmap_lookup_le(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	uint64_t		owner,
+	uint64_t		offset,
 	int			*stat)
 {
 	cur->bc_rec.r.rm_startblock = bno;
 	cur->bc_rec.r.rm_blockcount = len;
 	cur->bc_rec.r.rm_owner = owner;
+	cur->bc_rec.r.rm_offset = offset;
 	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
 }
 
 /*
+ * Lookup the record exactly matching [bno, len, owner, offset]
+ * in the btree given by cur.
+ */
+int
+xfs_rmap_lookup_eq(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset,
+	int			*stat)
+{
+	cur->bc_rec.r.rm_startblock = bno;
+	cur->bc_rec.r.rm_blockcount = len;
+	cur->bc_rec.r.rm_owner = owner;
+	cur->bc_rec.r.rm_offset = offset;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
+/*
  * Update the record referred to by cur to the value given
- * by [bno, len, ref].
+ * by [bno, len, owner, offset].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
 STATIC int
@@ -69,13 +91,14 @@ xfs_rmap_update(
 	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
 	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
 	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
+	rec.rmap.rm_offset = cpu_to_be64(irec->rm_offset);
 	return xfs_btree_update(cur, &rec);
 }
 
 /*
  * Get the data from the pointed-to record.
  */
-STATIC int
+int
 xfs_rmap_get_rec(
 	struct xfs_btree_cur	*cur,
 	struct xfs_rmap_irec	*irec,
@@ -91,6 +114,7 @@ xfs_rmap_get_rec(
 	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
 	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
 	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
+	irec->rm_offset = be64_to_cpu(rec->rmap.rm_offset);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 58bdac3..5fe717b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -37,21 +37,26 @@
 /*
  * Reverse map btree.
  *
- * This is a per-ag tree used to track the owner of a given extent. Owner
- * records are inserted when an extent is allocated, and removed when an extent
- * is freed. There can only be one owner of an extent, usually an inode or some
- * other metadata structure like a AG btree.
+ * This is a per-ag tree used to track the owner(s) of a given extent. With
+ * reflink it is possible for there to be multiple owners, which is a departure
+ * from classic XFS. Owner records for data extents are inserted when the
+ * extent is mapped and removed when an extent is unmapped.  Owner records for
+ * all other block types (i.e. metadata) are inserted when an extent is
+ * allocated and removed when an extent is freed. There can only be one owner
+ * of a metadata extent, usually an inode or some other metadata structure like
+ * an AG btree.
  *
  * The rmap btree is part of the free space management, so blocks for the tree
  * are sourced from the agfl. Hence we need transaction reservation support for
  * this tree so that the freelist is always large enough. This also impacts on
  * the minimum space we need to leave free in the AG.
  *
- * The tree is ordered by block number - there's no need to order/search by
- * extent size for online updating/management of the tree, and the reverse
- * lookups are going to be "who owns this block" and so are by-block ordering is
- * perfect for this.
- *
+ * The tree is ordered by [ag block, owner, offset]. This is a large key size,
+ * but it is the only way to enforce unique keys when a block can be owned by
+ * multiple files at any offset. There's no need to order/search by extent
+ * size for online updating/management of the tree. It is intended that most
+ * reverse lookups will be to find the owner(s) of a particular block, or to
+ * try to recover tree and file data from corrupt primary metadata.
  */
 
 static struct xfs_btree_cur *
@@ -165,6 +170,8 @@ xfs_rmapbt_init_key_from_rec(
 	union xfs_btree_rec	*rec)
 {
 	key->rmap.rm_startblock = rec->rmap.rm_startblock;
+	key->rmap.rm_owner = rec->rmap.rm_owner;
+	key->rmap.rm_offset = rec->rmap.rm_offset;
 }
 
 STATIC void
@@ -173,6 +180,8 @@ xfs_rmapbt_init_rec_from_key(
 	union xfs_btree_rec	*rec)
 {
 	rec->rmap.rm_startblock = key->rmap.rm_startblock;
+	rec->rmap.rm_owner = key->rmap.rm_owner;
+	rec->rmap.rm_offset = key->rmap.rm_offset;
 }
 
 STATIC void
@@ -183,6 +192,7 @@ xfs_rmapbt_init_rec_from_cur(
 	rec->rmap.rm_startblock = cpu_to_be32(cur->bc_rec.r.rm_startblock);
 	rec->rmap.rm_blockcount = cpu_to_be32(cur->bc_rec.r.rm_blockcount);
 	rec->rmap.rm_owner = cpu_to_be64(cur->bc_rec.r.rm_owner);
+	rec->rmap.rm_offset = cpu_to_be64(cur->bc_rec.r.rm_offset);
 }
 
 STATIC void
@@ -205,8 +215,16 @@ xfs_rmapbt_key_diff(
 {
 	struct xfs_rmap_irec	*rec = &cur->bc_rec.r;
 	struct xfs_rmap_key	*kp = &key->rmap;
-
-	return (__int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
+	__int64_t		d;
+
+	d = (__int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
+	if (d)
+		return d;
+	d = (__int64_t)be64_to_cpu(kp->rm_owner) - rec->rm_owner;
+	if (d)
+		return d;
+	d = (__int64_t)be64_to_cpu(kp->rm_offset) - rec->rm_offset;
+	return d;
 }
 
 static bool
@@ -307,8 +325,16 @@ xfs_rmapbt_keys_inorder(
 	union xfs_btree_key	*k1,
 	union xfs_btree_key	*k2)
 {
-	return be32_to_cpu(k1->rmap.rm_startblock) <
-	       be32_to_cpu(k2->rmap.rm_startblock);
+	if (be32_to_cpu(k1->rmap.rm_startblock) <
+	    be32_to_cpu(k2->rmap.rm_startblock))
+		return 1;
+	if (be64_to_cpu(k1->rmap.rm_owner) <
+	    be64_to_cpu(k2->rmap.rm_owner))
+		return 1;
+	if (be64_to_cpu(k1->rmap.rm_offset) <=
+	    be64_to_cpu(k2->rmap.rm_offset))
+		return 1;
+	return 0;
 }
 
 STATIC int
@@ -317,9 +343,16 @@ xfs_rmapbt_recs_inorder(
 	union xfs_btree_rec	*r1,
 	union xfs_btree_rec	*r2)
 {
-	return be32_to_cpu(r1->rmap.rm_startblock) +
-		be32_to_cpu(r1->rmap.rm_blockcount) <=
-		be32_to_cpu(r2->rmap.rm_startblock);
+	if (be32_to_cpu(r1->rmap.rm_startblock) <
+	    be32_to_cpu(r2->rmap.rm_startblock))
+		return 1;
+	if (be64_to_cpu(r1->rmap.rm_offset) <
+	    be64_to_cpu(r2->rmap.rm_offset))
+		return 1;
+	if (be64_to_cpu(r1->rmap.rm_owner) <=
+	    be64_to_cpu(r2->rmap.rm_owner))
+		return 1;
+	return 0;
 }
 #endif	/* DEBUG */
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 2e02362..a5c97f8 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -51,6 +51,13 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				xfs_agnumber_t agno);
 int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
 
+int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t	bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset, int *stat);
+int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t	bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset, int *stat);
+int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
+		int *stat);
+
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		   struct xfs_owner_info *oinfo);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
