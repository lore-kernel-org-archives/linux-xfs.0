Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F6D3802E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F60830405F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:14 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id rs4eZZZGvjlX9N6T (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:12 -0700 (PDT)
Subject: [PATCH 003/145] libxfs: backport changes from 4.5
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:04 -0700
Message-ID: <146612706430.16048.5914881403419597862.stgit@birch.djwong.org>
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

Backport changes from kernel 4.3 -> 4.5.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h          |    1 +
 libxfs/libxfs_api_defs.h  |    2 +-
 libxfs/libxfs_priv.h      |    8 --------
 libxfs/xfs_alloc_btree.c  |    4 ----
 libxfs/xfs_attr.c         |    2 ++
 libxfs/xfs_dir2.h         |    3 +--
 libxfs/xfs_dir2_data.c    |   14 +++++++-------
 libxfs/xfs_dquot_buf.c    |    4 ++--
 libxfs/xfs_ialloc_btree.c |    2 --
 repair/dir2.c             |    3 +--
 repair/dir2.h             |   20 ++++++++++++++++++++
 repair/phase6.c           |    2 +-
 12 files changed, 36 insertions(+), 29 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index cf2e20e..a34a3a9 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -163,6 +163,7 @@ extern unsigned int	libxfs_log2_roundup(unsigned int i);
 
 extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
+extern int	libxfs_bmap_finish(xfs_trans_t **, xfs_bmap_free_t *, struct xfs_inode *);
 
 extern void 	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
 extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 685c7a7..bb502e0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -85,7 +85,7 @@
 #define xfs_dir_replace			libxfs_dir_replace
 #define xfs_dir2_isblock		libxfs_dir2_isblock
 #define xfs_dir2_isleaf			libxfs_dir2_isleaf
-#define __xfs_dir2_data_freescan	libxfs_dir2_data_freescan
+#define xfs_dir2_data_freescan		libxfs_dir2_data_freescan
 #define xfs_dir2_data_log_entry		libxfs_dir2_data_log_entry
 #define xfs_dir2_data_log_header	libxfs_dir2_data_log_header
 #define xfs_dir2_data_make_free		libxfs_dir2_data_make_free
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2c5aba0..ef9ff3b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -49,14 +49,6 @@
 #ifndef __LIBXFS_INTERNAL_XFS_H__
 #define __LIBXFS_INTERNAL_XFS_H__
 
-/*
- * Repair doesn't have a inode when it calls libxfs_dir2_data_freescan,
- * so we to work around this internally for now.
- */
-#define xfs_dir2_data_freescan(ip, hdr, loghead) \
-	__xfs_dir2_data_freescan((ip)->i_mount->m_dir_geo, \
-				 (ip)->d_ops, hdr, loghead)
-
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
 #include "xfs.h"
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 79d0fb9..094135f 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -289,8 +289,6 @@ xfs_allocbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
 		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
@@ -302,8 +300,6 @@ xfs_allocbt_verify(
 			return false;
 		break;
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
 		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index afe3dcb..82a7c5e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -134,6 +134,8 @@ xfs_attr_get(
 
 	args.value = value;
 	args.valuelen = *valuelenp;
+	/* Entirely possible to look up a name which doesn't exist */
+	args.op_flags = XFS_DA_OP_OKNOENT;
 
 	lock_mode = xfs_ilock_attr_map_shared(ip);
 	if (!xfs_inode_hasattr(ip))
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 0129e37..0a62e73 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -157,8 +157,7 @@ extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
-extern void __xfs_dir2_data_freescan(struct xfs_da_geometry *geo,
-		const struct xfs_dir_ops *ops,
+extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern void xfs_dir2_data_log_entry(struct xfs_da_args *args,
 		struct xfs_buf *bp, struct xfs_dir2_data_entry *dep);
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 6ae5cd2..c80ab7e 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -502,9 +502,8 @@ xfs_dir2_data_freeremove(
  * Given a data block, reconstruct its bestfree map.
  */
 void
-__xfs_dir2_data_freescan(
-	struct xfs_da_geometry	*geo,
-	const struct xfs_dir_ops *ops,
+xfs_dir2_data_freescan(
+	struct xfs_inode	*dp,
 	struct xfs_dir2_data_hdr *hdr,
 	int			*loghead)
 {
@@ -514,6 +513,7 @@ __xfs_dir2_data_freescan(
 	struct xfs_dir2_data_free *bf;
 	char			*endp;		/* end of block's data */
 	char			*p;		/* current entry pointer */
+	struct xfs_da_geometry	*geo = dp->i_mount->m_dir_geo;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -523,13 +523,13 @@ __xfs_dir2_data_freescan(
 	/*
 	 * Start by clearing the table.
 	 */
-	bf = ops->data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(hdr);
 	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
 	*loghead = 1;
 	/*
 	 * Set up pointers.
 	 */
-	p = (char *)ops->data_entry_p(hdr);
+	p = (char *)dp->d_ops->data_entry_p(hdr);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		btp = xfs_dir2_block_tail_p(geo, hdr);
@@ -556,8 +556,8 @@ __xfs_dir2_data_freescan(
 		else {
 			dep = (xfs_dir2_data_entry_t *)p;
 			ASSERT((char *)dep - (char *)hdr ==
-			       be16_to_cpu(*ops->data_entry_tag_p(dep)));
-			p += ops->data_entsize(dep->namelen);
+			       be16_to_cpu(*dp->d_ops->data_entry_tag_p(dep)));
+			p += dp->d_ops->data_entsize(dep->namelen);
 		}
 	}
 }
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 7b7ea83..bfc6383 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -199,8 +199,8 @@ xfs_dquot_buf_verify_crc(
 	if (mp->m_quotainfo)
 		ndquots = mp->m_quotainfo->qi_dqperchunk;
 	else
-		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
-//					XFS_BB_TO_FSB(mp, bp->b_length));
+		ndquots = xfs_calc_dquots_per_chunk(
+					XFS_BB_TO_FSB(mp, bp->b_length));
 
 	for (i = 0; i < ndquots; i++, d++) {
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index a077635..0a7d985 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -227,8 +227,6 @@ xfs_inobt_verify(
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
 		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
diff --git a/repair/dir2.c b/repair/dir2.c
index 61912d1..a2fe5c6 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -921,8 +921,7 @@ _("bad bestfree table in block %u in directory inode %" PRIu64 ": "),
 			da_bno, ino);
 		if (!no_modify) {
 			do_warn(_("repairing table\n"));
-			libxfs_dir2_data_freescan(mp->m_dir_geo, M_DIROPS(mp),
-						  d, &i);
+			repair_dir2_data_freescan(mp, M_DIROPS(mp), d, &i);
 			*dirty = 1;
 		} else {
 			do_warn(_("would repair table\n"));
diff --git a/repair/dir2.h b/repair/dir2.h
index e4d4eeb..a0d873e 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -43,4 +43,24 @@ int
 dir2_is_badino(
 	xfs_ino_t	ino);
 
+/*
+ * Repair doesn't have a inode when it calls libxfs_dir2_data_freescan,
+ * so we to work around this internally for now.
+ */
+static inline void
+repair_dir2_data_freescan(
+	struct xfs_mount		*mp,
+	const struct xfs_dir_ops	*d_ops,
+	struct xfs_dir2_data_hdr	*hdr,
+	int				*loghead)
+{
+	struct xfs_inode	ino;
+
+	ino.d_ops = d_ops;
+	ino.i_mount = mp;
+	return libxfs_dir2_data_freescan(&ino, hdr, loghead);
+}
+
+extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
+
 #endif	/* _XR_DIR2_H */
diff --git a/repair/phase6.c b/repair/phase6.c
index 0a71164..7353c3a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1902,7 +1902,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 	}
 	*num_illegal += nbad;
 	if (needscan)
-		libxfs_dir2_data_freescan(mp->m_dir_geo, M_DIROPS(mp), d, &i);
+		repair_dir2_data_freescan(mp, M_DIROPS(mp), d, &i);
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
 	libxfs_bmap_finish(&tp, &flist, ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
