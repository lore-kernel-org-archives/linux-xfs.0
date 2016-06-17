Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5EDD48269
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:38:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F5DC8F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:20 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id lq6MTDDUZBd8IQEI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:17 -0700 (PDT)
Subject: [PATCH 070/145] mkfs.xfs: create filesystems with reverse-mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:38:09 -0700
Message-ID: <146612748977.16048.8951256729197337882.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Create v5 filesystems with rmapbt turned on.  Document the rmapbt
options to mkfs, and initialize the extra field we added for reflink
support.

v2: Turn on the rmapbt feature when calculating the minimum log size.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick.wong@oracle.com: split patch, add commit message and extra fields]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_multidisk.h |    2 -
 man/man8/mkfs.xfs.8     |   20 +++++++
 mkfs/maxtrres.c         |    5 +-
 mkfs/xfs_mkfs.c         |  138 +++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 145 insertions(+), 20 deletions(-)


diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index 4429dab..8dc3027 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -68,6 +68,6 @@ extern void res_failed (int err);
 /* maxtrres.c */
 extern int max_trans_res(unsigned long agsize, int crcs_enabled, int dirversion,
 		int sectorlog, int blocklog, int inodelog, int dirblocklog,
-		int logversion, int log_sunit, int finobt);
+		int logversion, int log_sunit, int finobt, int rmapbt);
 
 #endif	/* __XFS_MULTIDISK_H__ */
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 980b0e1..d88d314 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -193,6 +193,26 @@ is used, the free inode btree feature is not supported and is disabled.
 .BI uuid= value
 Use the given value as the filesystem UUID for the newly created filesystem.
 The default is to generate a random UUID.
+.TP
+.BI rmapbt= value
+This option enables the creation of a reverse-mapping btree index in each
+allocation group.  The value is either 0 to disable the feature, or 1 to
+create the btree.
+.IP
+The reverse mapping btree maps filesystem blocks to the owner of the
+filesystem block.  Most of the mappings will be to an inode number and an
+offset, though there will also be mappings to filesystem metadata.  This
+secondary metadata can be used to validate the primary metadata or to
+pinpoint exactly which data has been lost when a disk error occurs.
+.IP
+By default,
+.B mkfs.xfs
+will not create reverse mapping btrees.  This feature is only available
+for filesystems created with the (default)
+.B \-m crc=1
+option set. When the option
+.B \-m crc=0
+is used, the reverse mapping btree feature is not supported and is disabled.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index c0b1b5d..fc24eac 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -38,7 +38,8 @@ max_trans_res(
 	int		dirblocklog,
 	int		logversion,
 	int		log_sunit,
-	int		finobt)
+	int		finobt,
+	int		rmapbt)
 {
 	xfs_sb_t	*sbp;
 	xfs_mount_t	mount;
@@ -72,6 +73,8 @@ max_trans_res(
 			XFS_DFL_SB_VERSION_BITS;
 	if (finobt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	if (rmapbt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 
 	libxfs_mount(&mount, sbp, 0,0,0,0);
 	maxfsb = xfs_log_calc_minimum_size(&mount);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8b3cad8..634dcfd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -680,6 +680,8 @@ struct opt_params mopts = {
 		"finobt",
 #define M_UUID		2
 		"uuid",
+#define M_RMAPBT	3
+		"rmapbt",
 		NULL
 	},
 	.subopt_params = {
@@ -699,6 +701,12 @@ struct opt_params mopts = {
 		  .conflicts = { LAST_CONFLICT },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = M_RMAPBT,
+		  .conflicts = { LAST_CONFLICT },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 0,
+		},
 	},
 };
 
@@ -1454,6 +1462,7 @@ struct sb_feat_args {
 	bool	crcs_enabled;
 	bool	dirftype;
 	bool	parent_pointers;
+	bool	rmapbt;
 };
 
 static void
@@ -1524,6 +1533,8 @@ sb_set_features(
 
 	if (fp->finobt)
 		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	if (fp->rmapbt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -1784,6 +1795,7 @@ main(
 		.crcs_enabled = true,
 		.dirftype = true,
 		.parent_pointers = false,
+		.rmapbt = false,
 	};
 
 	platform_uuid_generate(&uuid);
@@ -2073,6 +2085,10 @@ main(
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
 					break;
+				case M_RMAPBT:
+					sb_feat.rmapbt = getnum(
+						value, &mopts, M_RMAPBT);
+					break;
 				default:
 					unknown('m', value);
 				}
@@ -2409,6 +2425,20 @@ _("sparse inodes not supported without CRC support\n"));
 		}
 		sb_feat.spinodes = 0;
 
+		if (sb_feat.rmapbt) {
+			fprintf(stderr,
+_("rmapbt not supported without CRC support\n"));
+			usage();
+		}
+		sb_feat.rmapbt = false;
+	}
+
+
+	if (sb_feat.rmapbt && xi.rtname) {
+		fprintf(stderr,
+_("rmapbt not supported with realtime devices\n"));
+		usage();
+		sb_feat.rmapbt = false;
 	}
 
 	if (nsflag || nlflag) {
@@ -2890,7 +2920,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	min_logblocks = max_trans_res(agsize,
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
-				   sb_feat.log_version, lsunit, sb_feat.finobt);
+				   sb_feat.log_version, lsunit, sb_feat.finobt,
+				   sb_feat.rmapbt);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
@@ -2965,7 +2996,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
 	/*
-	 * sb_versionnum and finobt flags must be set before we use
+	 * sb_versionnum, finobt and rmapbt flags must be set before we use
 	 * xfs_prealloc_blocks().
 	 */
 	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
@@ -3025,7 +3056,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -3036,6 +3067,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			"", sectorsize, sb_feat.attr_version,
 				    !sb_feat.projid16bit,
 			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
+			sb_feat.rmapbt,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
@@ -3217,6 +3249,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
@@ -3404,24 +3442,88 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		/*
 		 * Free INO btree root block
 		 */
-		if (!sb_feat.finobt) {
-			xfs_perag_put(pag);
-			continue;
+		if (sb_feat.finobt) {
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
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
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
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account freespace btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 2);
+			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(2);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account inode btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 3);
+			rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
+							XFS_IBT_BLOCK(mp));
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account for rmap btree root */
+			rrec = XFS_RMAP_REC_ADDR(block, 4);
+			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(1);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account for the log space */
+			if (loginternal && agno == logagno) {
+				rrec = XFS_RMAP_REC_ADDR(block, 5);
+				rrec->rm_startblock = cpu_to_be32(
+						XFS_FSB_TO_AGBNO(mp, logstart));
+				rrec->rm_blockcount = cpu_to_be32(logblocks);
+				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
+				rrec->rm_offset = 0;
+				be16_add_cpu(&block->bb_numrecs, 1);
+			}
+
+			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		}
+
 		xfs_perag_put(pag);
 	}
 
@@ -3646,7 +3748,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b log=n|size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectlog=n|sectsize=num\n\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
