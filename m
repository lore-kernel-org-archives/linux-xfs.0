Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C062029E90
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:09:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0DE1304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:09:13 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4hiMFMR46MTHk3kJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:09:11 -0700 (PDT)
Subject: [PATCH 36/51] mkfs.xfs: Create rmapbt filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:09:08 -0700
Message-ID: <20151007050907.1504.65033.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
 mkfs/xfs_mkfs.c |  119 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 102 insertions(+), 17 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b326116..b496349 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -181,6 +181,8 @@ char	*mopts[] = {
 	"crc",
 #define M_FINOBT	1
 	"finobt",
+#define M_RMAPBT	2
+	"rmapbt",
 	NULL
 };
 
@@ -947,6 +949,7 @@ main(
 	int			finobt;
 	bool			finobtflag;
 	int			spinodes;
+	bool			rmapbt;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -984,6 +987,7 @@ main(
 	finobt = 1;
 	finobtflag = false;
 	spinodes = 0;
+	rmapbt = false;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1488,6 +1492,14 @@ main(
 					finobt = c;
 					finobtflag = true;
 					break;
+				case M_RMAPBT:
+					if (!value || *value == '\0')
+						reqval('m', mopts, M_CRC);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "m rmapbt");
+					rmapbt = c;
+					break;
 				default:
 					unknown('m', value);
 				}
@@ -1844,6 +1856,12 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
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
@@ -2437,7 +2455,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
 	/*
-	 * sb_versionnum and finobt flags must be set before we use
+	 * sb_versionnum, finobt and rmapbt flags must be set before we use
 	 * xfs_prealloc_blocks().
 	 */
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
@@ -2459,6 +2477,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	if (finobt)
 		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	if (rmapbt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 
 	if (loginternal) {
 		/*
@@ -2522,7 +2542,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -2531,7 +2551,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled, finobt, spinodes,
+			"", crcs_enabled, finobt, spinodes, rmapbt,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
@@ -2721,6 +2741,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
@@ -2908,24 +2934,83 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
