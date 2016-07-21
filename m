Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D1467CC9
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 239C28F8039
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3H46WPjOStnMP85u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:35 -0700 (PDT)
Subject: [PATCH 31/47] xfs: support overlapping intervals in the rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:59:29 -0700
Message-ID: <146907716980.25461.7950119875516554062.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Now that the generic btree code supports overlapping intervals, plug
in the rmap btree to this functionality.  We will need it to find
potential left neighbors in xfs_rmap_{alloc,free} later in the patch
set.

v2: Fix bit manipulation bug when generating high key offset.
v3: Move unwritten bit to rm_offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   68 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rmap_btree.h |   10 +++++-
 2 files changed, 74 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 95cb964..232450c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -180,6 +180,35 @@ xfs_rmapbt_init_key_from_rec(
 	key->rmap.rm_offset = rec->rmap.rm_offset;
 }
 
+/*
+ * The high key for a reverse mapping record can be computed by shifting
+ * the startblock and offset to the highest value that would still map
+ * to that record.  In practice this means that we add blockcount-1 to
+ * the startblock for all records, and if the record is for a data/attr
+ * fork mapping, we add blockcount-1 to the offset too.
+ */
+STATIC void
+xfs_rmapbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	__uint64_t		off;
+	int			adj;
+
+	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
+
+	key->rmap.rm_startblock = rec->rmap.rm_startblock;
+	be32_add_cpu(&key->rmap.rm_startblock, adj);
+	key->rmap.rm_owner = rec->rmap.rm_owner;
+	key->rmap.rm_offset = rec->rmap.rm_offset;
+	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rmap.rm_owner)) ||
+	    XFS_RMAP_IS_BMBT_BLOCK(be64_to_cpu(rec->rmap.rm_offset)))
+		return;
+	off = be64_to_cpu(key->rmap.rm_offset);
+	off = (XFS_RMAP_OFF(off) + adj) | (off & ~XFS_RMAP_OFF_MASK);
+	key->rmap.rm_offset = cpu_to_be64(off);
+}
+
 STATIC void
 xfs_rmapbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
@@ -235,6 +264,38 @@ xfs_rmapbt_key_diff(
 	return 0;
 }
 
+STATIC __int64_t
+xfs_rmapbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	struct xfs_rmap_key	*kp1 = &k1->rmap;
+	struct xfs_rmap_key	*kp2 = &k2->rmap;
+	__int64_t		d;
+	__u64			x, y;
+
+	d = (__int64_t)be32_to_cpu(kp1->rm_startblock) -
+		       be32_to_cpu(kp2->rm_startblock);
+	if (d)
+		return d;
+
+	x = be64_to_cpu(kp1->rm_owner);
+	y = be64_to_cpu(kp2->rm_owner);
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+
+	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
+	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+	return 0;
+}
+
 static bool
 xfs_rmapbt_verify(
 	struct xfs_buf		*bp)
@@ -382,10 +443,12 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.get_minrecs		= xfs_rmapbt_get_minrecs,
 	.get_maxrecs		= xfs_rmapbt_get_maxrecs,
 	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
+	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
 #if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
@@ -412,8 +475,9 @@ xfs_rmapbt_init_cursor(
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
+	/* Overlapping btree; 2 keys per pointer. */
 	cur->bc_btnum = XFS_BTNUM_RMAP;
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS;
+	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_ops = &xfs_rmapbt_ops;
 	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
@@ -438,7 +502,7 @@ xfs_rmapbt_maxrecs(
 	if (leaf)
 		return blocklen / sizeof(struct xfs_rmap_rec);
 	return blocklen /
-		(sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
+		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
 }
 
 /* Compute the maximum height of an rmap btree. */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index a3a6b7d..e73a553 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -38,12 +38,18 @@ struct xfs_mount;
 #define XFS_RMAP_KEY_ADDR(block, index) \
 	((struct xfs_rmap_key *) \
 		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
-		 ((index) - 1) * sizeof(struct xfs_rmap_key)))
+		 ((index) - 1) * 2 * sizeof(struct xfs_rmap_key)))
+
+#define XFS_RMAP_HIGH_KEY_ADDR(block, index) \
+	((struct xfs_rmap_key *) \
+		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
+		 sizeof(struct xfs_rmap_key) + \
+		 ((index) - 1) * 2 * sizeof(struct xfs_rmap_key)))
 
 #define XFS_RMAP_PTR_ADDR(block, index, maxrecs) \
 	((xfs_rmap_ptr_t *) \
 		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
-		 (maxrecs) * sizeof(struct xfs_rmap_key) + \
+		 (maxrecs) * 2 * sizeof(struct xfs_rmap_key) + \
 		 ((index) - 1) * sizeof(xfs_rmap_ptr_t)))
 
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
