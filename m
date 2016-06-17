Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C09FA84BC
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:45:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49110AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:52 -0700 (PDT)
Received: from aserp1050.oracle.com (aserp1050.oracle.com [141.146.126.70]) by
	cuda.sgi.com with ESMTP id 6e8ENQB75qBUkusg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id u5H1jdl5031639
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 01:45:40 GMT
Subject: [PATCH 135/145] mkfs.xfs: format reflink enabled filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:44:56 -0700
Message-ID: <146612789675.16048.3320445583494719487.stgit@birch.djwong.org>
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

Create the refcount btree at mkfs time and set the feature flag.

v2: Turn on the reflink feature when calculating the minimum log size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_multidisk.h |    3 +-
 man/man8/mkfs.xfs.8     |   28 ++++++++++++++++++++
 mkfs/maxtrres.c         |    5 +++-
 mkfs/xfs_mkfs.c         |   67 +++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 95 insertions(+), 8 deletions(-)


diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index 8dc3027..ce9bbce 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -68,6 +68,7 @@ extern void res_failed (int err);
 /* maxtrres.c */
 extern int max_trans_res(unsigned long agsize, int crcs_enabled, int dirversion,
 		int sectorlog, int blocklog, int inodelog, int dirblocklog,
-		int logversion, int log_sunit, int finobt, int rmapbt);
+		int logversion, int log_sunit, int finobt, int rmapbt,
+		int reflink);
 
 #endif	/* __XFS_MULTIDISK_H__ */
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index d88d314..6131e24 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -213,6 +213,34 @@ for filesystems created with the (default)
 option set. When the option
 .B \-m crc=0
 is used, the reverse mapping btree feature is not supported and is disabled.
+.TP
+.BI reflink= value
+This option enables the use of a separate reference count btree index in each
+allocation group. The value is either 0 to disable the feature, or 1 to create
+a reference count btree in each allocation group.
+.IP
+The reference count btree enables the sharing of physical extents between
+the data forks of different files, which is commonly known as "reflink".
+Unlike traditional Unix filesystems which assume that every inode and
+logical block pair map to a unique physical block, a reflink-capable
+XFS filesystem removes the uniqueness requirement, allowing up to four
+billion arbitrary inode/logical block pairs to map to a physical block.
+If a program tries to write to a multiply-referenced block in a file, the write
+will be redirected to a new block, and that file's logical-to-physical
+mapping will be changed to the new block ("copy on write").  This feature
+enables the creation of per-file snapshots and deduplication.  It is only
+available for the data forks of regular files.
+.IP
+By default,
+.B mkfs.xfs
+will not create reference count btrees and therefore will not enable the
+reflink feature.  This feature is only available for filesystems created with
+the (default)
+.B \-m crc=1
+option set. When the option
+.B \-m crc=0
+is used, the reference count btree feature is not supported and reflink is
+disabled.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index fc24eac..a9c0985 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -39,7 +39,8 @@ max_trans_res(
 	int		logversion,
 	int		log_sunit,
 	int		finobt,
-	int		rmapbt)
+	int		rmapbt,
+	int		reflink)
 {
 	xfs_sb_t	*sbp;
 	xfs_mount_t	mount;
@@ -75,6 +76,8 @@ max_trans_res(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
 	if (rmapbt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	if (reflink)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 
 	libxfs_mount(&mount, sbp, 0,0,0,0);
 	maxfsb = xfs_log_calc_minimum_size(&mount);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 634dcfd..3753731 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -682,6 +682,8 @@ struct opt_params mopts = {
 		"uuid",
 #define M_RMAPBT	3
 		"rmapbt",
+#define M_REFLINK	4
+		"reflink",
 		NULL
 	},
 	.subopt_params = {
@@ -707,6 +709,12 @@ struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 0,
 		},
+		{ .index = M_REFLINK,
+		  .conflicts = { LAST_CONFLICT },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 0,
+		},
 	},
 };
 
@@ -1463,6 +1471,7 @@ struct sb_feat_args {
 	bool	dirftype;
 	bool	parent_pointers;
 	bool	rmapbt;
+	bool	reflink;
 };
 
 static void
@@ -1535,6 +1544,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
 	if (fp->rmapbt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	if (fp->reflink)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -1796,6 +1807,7 @@ main(
 		.dirftype = true,
 		.parent_pointers = false,
 		.rmapbt = false,
+		.reflink = false,
 	};
 
 	platform_uuid_generate(&uuid);
@@ -2089,6 +2101,10 @@ main(
 					sb_feat.rmapbt = getnum(
 						value, &mopts, M_RMAPBT);
 					break;
+				case M_REFLINK:
+					sb_feat.reflink = getnum(
+						value, &mopts, M_REFLINK);
+					break;
 				default:
 					unknown('m', value);
 				}
@@ -2431,6 +2447,13 @@ _("rmapbt not supported without CRC support\n"));
 			usage();
 		}
 		sb_feat.rmapbt = false;
+
+		if (sb_feat.reflink) {
+			fprintf(stderr,
+_("reflink not supported without CRC support\n"));
+			usage();
+		}
+		sb_feat.reflink = false;
 	}
 
 
@@ -2921,7 +2944,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
 				   sb_feat.log_version, lsunit, sb_feat.finobt,
-				   sb_feat.rmapbt);
+				   sb_feat.rmapbt, sb_feat.reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
@@ -3056,7 +3079,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -3067,7 +3090,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			"", sectorsize, sb_feat.attr_version,
 				    !sb_feat.projid16bit,
 			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
-			sb_feat.rmapbt,
+			sb_feat.rmapbt, sb_feat.reflink,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
@@ -3254,7 +3277,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						cpu_to_be32(XFS_RMAP_BLOCK(mp));
 			agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
 		}
-
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			agf->agf_refcount_root = cpu_to_be32(xfs_refc_block(mp));
+			agf->agf_refcount_level = cpu_to_be32(1);
+		}
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
@@ -3423,6 +3449,23 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
+		 * refcount btree root block
+		 */
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			buf = libxfs_getbuf(mp->m_ddev_targp,
+					XFS_AGB_TO_DADDR(mp, agno, xfs_refc_block(mp)),
+					bsize);
+			buf->b_ops = &xfs_refcountbt_buf_ops;
+
+			block = XFS_BUF_TO_BLOCK(buf);
+			memset(block, 0, blocksize);
+			xfs_btree_init_block(mp, buf, XFS_REFC_CRC_MAGIC, 0, 0,
+						agno, XFS_BTREE_CRC_BLOCKS);
+
+			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		}
+
+		/*
 		 * INO btree root block
 		 */
 		buf = libxfs_getbuf(mp->m_ddev_targp,
@@ -3510,9 +3553,21 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
+			/* account for refcount btree root */ 
+			if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+				rrec = XFS_RMAP_REC_ADDR(block, 5);
+				rrec->rm_startblock = cpu_to_be32(
+							xfs_refc_block(mp));
+				rrec->rm_blockcount = cpu_to_be32(1);
+				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_REFC);
+				rrec->rm_offset = 0;
+				be16_add_cpu(&block->bb_numrecs, 1);
+			}
+
 			/* account for the log space */
 			if (loginternal && agno == logagno) {
-				rrec = XFS_RMAP_REC_ADDR(block, 5);
+				rrec = XFS_RMAP_REC_ADDR(block,
+					be16_to_cpu(block->bb_numrecs) + 1);
 				rrec->rm_startblock = cpu_to_be32(
 						XFS_FSB_TO_AGBNO(mp, logstart));
 				rrec->rm_blockcount = cpu_to_be32(logblocks);
@@ -3748,7 +3803,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b log=n|size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectlog=n|sectsize=num\n\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
