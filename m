Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1411229E40
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:09:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB3028F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:01 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QphLeHDsxuuGvC0v (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:59 -0800 (PST)
Subject: [PATCH 36/53] mkfs.xfs: Create rmapbt filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:08:56 -0800
Message-ID: <20151219090856.14255.83206.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

>From : Dave Chinner <david@fromorbit.com>

Create v5 filesystems with rmapbt turned on.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[split patch, add commit message]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 101 insertions(+), 17 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 934d7c0..b2b087f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -185,6 +185,8 @@ char	*mopts[] = {
 	"finobt",
 #define M_UUID		2
 	"uuid",
+#define M_RMAPBT	3
+	"rmapbt",
 	NULL
 };
 
@@ -984,6 +986,7 @@ main(
 	int			finobt;
 	bool			finobtflag;
 	int			spinodes;
+	bool			rmapbt;
 
 	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
@@ -1022,6 +1025,7 @@ main(
 	finobt = 1;
 	finobtflag = false;
 	spinodes = 0;
+	rmapbt = false;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1531,6 +1535,13 @@ main(
 						reqval('m', mopts, M_UUID);
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
+				case M_RMAPBT:
+					if (!value || *value == '\0')
+						reqval('m', mopts, M_CRC);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "m rmapbt");
+					rmapbt = c;
 					break;
 				default:
 					unknown('m', value);
@@ -1888,6 +1899,12 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		spinodes = 0;
 	}
 
+	if (rmapbt && !crcs_enabled) {
+		fprintf(stderr,
+_("warning: rmapbt not supported without CRC support, disabled.\n"));
+		rmapbt = 0;
+	}
+
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
@@ -2481,7 +2498,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
 	/*
-	 * sb_versionnum and finobt flags must be set before we use
+	 * sb_versionnum, finobt and rmapbt flags must be set before we use
 	 * xfs_prealloc_blocks().
 	 */
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
@@ -2503,6 +2520,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	if (finobt)
 		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	if (rmapbt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 
 	if (loginternal) {
 		/*
@@ -2566,7 +2585,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -2575,7 +2594,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled, finobt, spinodes,
+			"", crcs_enabled, finobt, spinodes, rmapbt,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
@@ -2764,6 +2783,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
 		pag->pagf_levels[XFS_BTNUM_BNOi] = 1;
 		pag->pagf_levels[XFS_BTNUM_CNTi] = 1;
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			agf->agf_roots[XFS_BTNUM_RMAPi] =
+						cpu_to_be32(XFS_RMAP_BLOCK(mp));
+			agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+		}
+
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
@@ -2951,24 +2976,83 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		/*
 		 * Free INO btree root block
 		 */
-		if (!finobt) {
-			xfs_perag_put(pag);
-			continue;
+		if (finobt) {
+			buf = libxfs_getbuf(mp->m_ddev_targp,
+					XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
+					bsize);
+			buf->b_ops = &xfs_inobt_buf_ops;
+			block = XFS_BUF_TO_BLOCK(buf);
+			memset(block, 0, blocksize);
+			if (xfs_sb_version_hascrc(&mp->m_sb))
+				xfs_btree_init_block(mp, buf, XFS_FIBT_CRC_MAGIC, 0, 0,
+							agno, XFS_BTREE_CRC_BLOCKS);
+			else
+				xfs_btree_init_block(mp, buf, XFS_FIBT_MAGIC, 0, 0,
+							agno, 0);
+			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 		}
 
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
+		/* RMAP btree root block */
+		if (rmapbt) {
+			struct xfs_rmap_rec	*rrec;
+
+			buf = libxfs_getbuf(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_RMAP_BLOCK(mp)),
 				bsize);
-		buf->b_ops = &xfs_inobt_buf_ops;
-		block = XFS_BUF_TO_BLOCK(buf);
-		memset(block, 0, blocksize);
-		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, buf, XFS_FIBT_CRC_MAGIC, 0, 0,
+			buf->b_ops = &xfs_rmapbt_buf_ops;
+			block = XFS_BUF_TO_BLOCK(buf);
+			memset(block, 0, blocksize);
+
+			xfs_btree_init_block(mp, buf, XFS_RMAP_CRC_MAGIC, 0, 0,
 						agno, XFS_BTREE_CRC_BLOCKS);
-		else
-			xfs_btree_init_block(mp, buf, XFS_FIBT_MAGIC, 0, 0,
-						agno, 0);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+			/*
+			 * mark the AG header regions as static metadata
+			 * The BNO btree block is the first block after the
+			 * headers, so it's location defines the size of region
+			 * the static metadata consumes.
+			 */
+			rrec = XFS_RMAP_REC_ADDR(block, 1);
+			rrec->rm_startblock = 0;
+			rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account freespace btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 2);
+			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(2);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account inode btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 3);
+			rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
+							XFS_IBT_BLOCK(mp));
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account for rmap btree root */
+			rrec = XFS_RMAP_REC_ADDR(block, 4);
+			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(1);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account for the log space */
+			if (loginternal && agno == logagno) {
+				rrec = XFS_RMAP_REC_ADDR(block, 5);
+				rrec->rm_startblock = cpu_to_be32(
+						XFS_FSB_TO_AGBNO(mp, logstart));
+				rrec->rm_blockcount = cpu_to_be32(logblocks);
+				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
+				be16_add_cpu(&block->bb_numrecs, 1);
+			}
+
+			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		}
+
 		xfs_perag_put(pag);
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
