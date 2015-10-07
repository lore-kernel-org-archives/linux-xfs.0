Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E36AB7F73
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:56:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D4C958F8035
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:56:04 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id SDEwVZf8BWbEeHqj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:56:03 -0700 (PDT)
Subject: [PATCH 11/58] xfs: enhance the on-disk rmap btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:55:59 -0700
Message-ID: <20151007045559.30457.47862.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Expand the rmap btree to record owner and offset info.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |   68 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c |    2 +
 2 files changed, 69 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ff24083..f0cf383 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1369,6 +1369,8 @@ XFS_RMAP_INO_OWNER(
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
 #define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
 
+#define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
+
 /*
  * Data record structure
  */
@@ -1376,12 +1378,44 @@ struct xfs_rmap_rec {
 	__be32		rm_startblock;	/* extent start block */
 	__be32		rm_blockcount;	/* extent length */
 	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
 };
 
+/*
+ * rmap btree record
+ *  rm_blockcount:31 is the unwritten extent flag (same as l0:63 in bmbt)
+ *  rm_blockcount:0-30 are the extent length
+ *  rm_offset:63 is the attribute fork flag
+ *  rm_offset:62 is the bmbt block flag
+ *  rm_offset:0-61 is the block offset within the inode
+ */
+#define XFS_RMAP_OFF_ATTR	((__uint64_t)1ULL << 63)
+#define XFS_RMAP_OFF_BMBT	((__uint64_t)1ULL << 62)
+#define XFS_RMAP_LEN_UNWRITTEN	((xfs_extlen_t)1U << 31)
+
+#define XFS_RMAP_OFF_MASK	~(XFS_RMAP_OFF_ATTR | XFS_RMAP_OFF_BMBT)
+#define XFS_RMAP_LEN_MASK	~XFS_RMAP_LEN_UNWRITTEN
+
+#define XFS_RMAP_OFF(off)		((off) & XFS_RMAP_OFF_MASK)
+#define XFS_RMAP_LEN(len)		((len) & XFS_RMAP_LEN_MASK)
+
+#define XFS_RMAP_IS_BMBT(off)		(!!((off) & XFS_RMAP_OFF_BMBT))
+#define XFS_RMAP_IS_ATTR_FORK(off)	(!!((off) & XFS_RMAP_OFF_ATTR))
+#define XFS_RMAP_IS_UNWRITTEN(len)	(!!((len) & XFS_RMAP_LEN_UNWRITTEN))
+
+#define RMAPBT_STARTBLOCK_BITLEN	32
+#define RMAPBT_EXNTFLAG_BITLEN		1
+#define RMAPBT_BLOCKCOUNT_BITLEN	31
+#define RMAPBT_OWNER_BITLEN		64
+#define RMAPBT_ATTRFLAG_BITLEN		1
+#define RMAPBT_BMBTFLAG_BITLEN		1
+#define RMAPBT_OFFSET_BITLEN		62
+
 struct xfs_rmap_irec {
 	xfs_agblock_t	rm_startblock;	/* extent start block */
 	xfs_extlen_t	rm_blockcount;	/* extent length */
 	__uint64_t	rm_owner;	/* extent owner */
+	__uint64_t	rm_offset;	/* offset within the owner */
 };
 
 /*
@@ -1391,6 +1425,8 @@ struct xfs_rmap_irec {
  */
 struct xfs_rmap_key {
 	__be32		rm_startblock;	/* extent start block */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
 };
 
 /* btree pointer type */
@@ -1401,6 +1437,38 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
+static inline void
+xfs_owner_info_unpack(
+	struct xfs_owner_info	*oinfo,
+	uint64_t		*owner,
+	uint64_t		*offset)
+{
+	__uint64_t		r;
+
+	*owner = oinfo->oi_owner;
+	r = oinfo->oi_offset;
+	if (oinfo->oi_flags & XFS_RMAP_INO_ATTR_FORK)
+		r |= XFS_RMAP_OFF_ATTR;
+	if (oinfo->oi_flags & XFS_RMAP_BMBT_BLOCK)
+		r |= XFS_RMAP_OFF_BMBT;
+	*offset = r;
+}
+
+static inline void
+xfs_owner_info_pack(
+	struct xfs_owner_info	*oinfo,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	oinfo->oi_owner = owner;
+	oinfo->oi_offset = XFS_RMAP_OFF(offset);
+	oinfo->oi_flags = 0;
+	if (XFS_RMAP_IS_ATTR_FORK(offset))
+		oinfo->oi_flags |= XFS_RMAP_INO_ATTR_FORK;
+	if (XFS_RMAP_IS_BMBT(offset))
+		oinfo->oi_flags |= XFS_RMAP_BMBT_BLOCK;
+}
+
 /*
  * BMAP Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 9a02699..5671771 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -63,7 +63,7 @@ xfs_rmapbt_verify(
 	 * from the on disk AGF. Again, we can only check against maximum limits
 	 * in this case.
 	 */
-	if (block->bb_magic!= cpu_to_be32(XFS_RMAP_CRC_MAGIC))
+	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
 		return false;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
