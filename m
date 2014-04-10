Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A6897FDA
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:11:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 178F3304064
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MKGCYh5lbtVbkU7Z for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:14 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AGBDNM031395
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:14 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3AGBCqw021278
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 11/20] xfsprogs/mkfs: finobt mkfs support
Date: Thu, 10 Apr 2014 12:11:01 -0400
Message-Id: <1397146270-42993-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add the 'finobt' metadata option to mkfs to format an fs with free
inode btree support. If enabled, initialize the associated AGI
header fields and btree root block.

Also, do the initialization of the superblock version and feature
bits (including the new finobt flag) a bit earlier. These fields
must now be initialized prior to the use of XFS_PREALLOC_BLOCKS(),
as the latter returns a value that depends on whether a finobt root
btree block is reserved.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 mkfs/xfs_mkfs.c | 83 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 20 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f7cf394..654cb8a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -183,6 +183,8 @@ char	*sopts[] = {
 char	*mopts[] = {
 #define	M_CRC		0
 	"crc",
+#define M_FINOBT	1
+	"finobt",
 	NULL
 };
 
@@ -962,6 +964,7 @@ main(
 	struct fs_topology	ft;
 	int			lazy_sb_counters;
 	int			crcs_enabled;
+	int			finobt;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -995,6 +998,7 @@ main(
 	worst_freelist = 0;
 	lazy_sb_counters = 1;
 	crcs_enabled = 0;
+	finobt = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1486,6 +1490,14 @@ _("cannot specify both crc and ftype\n"));
 						usage();
 					}
 					break;
+				case M_FINOBT:
+					if (!value || *value == '\0')
+						reqval('m', mopts, M_CRC);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "m finobt");
+					finobt = c;
+					break;
 				default:
 					unknown('m', value);
 				}
@@ -2415,6 +2427,30 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
+	/*
+	 * sb_versionnum and finobt flags must be set before we use
+	 * XFS_PREALLOC_BLOCKS().
+	 */
+	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
+					attrversion == 2, !projid16bit, 0,
+					(!crcs_enabled && dirftype));
+	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
+					dsunit != 0,
+					logversion == 2, attrversion == 1,
+					(sectorsize != BBSIZE ||
+							lsectorsize != BBSIZE),
+					nci, sbp->sb_features2 != 0);
+	/*
+	 * Due to a structure alignment issue, sb_features2 ended up in one
+	 * of two locations, the second "incorrect" location represented by
+	 * the sb_bad_features2 field. To avoid older kernels mounting
+	 * filesystems they shouldn't, set both field to the same value.
+	 */
+	sbp->sb_bad_features2 = sbp->sb_features2;
+
+	if (finobt)
+		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
+
 	if (loginternal) {
 		/*
 		 * Readjust the log size to fit within an AG if it was sized
@@ -2477,7 +2513,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -2486,7 +2522,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled,
+			"", crcs_enabled, finobt,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
@@ -2555,23 +2591,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_logsectsize = 0;
 	}
 
-	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
-				   attrversion == 2, !projid16bit, 0,
-				   (!crcs_enabled && dirftype));
-	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
-					dsunit != 0,
-					logversion == 2, attrversion == 1,
-					(sectorsize != BBSIZE ||
-							lsectorsize != BBSIZE),
-					nci, sbp->sb_features2 != 0);
-	/*
-	 * Due to a structure alignment issue, sb_features2 ended up in one
-	 * of two locations, the second "incorrect" location represented by
-	 * the sb_bad_features2 field. To avoid older kernels mounting
-	 * filesystems they shouldn't, set both field to the same value.
-	 */
-	sbp->sb_bad_features2 = sbp->sb_features2;
-
 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
 
@@ -2728,6 +2747,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agi->agi_count = 0;
 		agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
 		agi->agi_level = cpu_to_be32(1);
+		if (finobt) {
+			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
+			agi->agi_free_level = cpu_to_be32(1);
+		}
 		agi->agi_freecount = 0;
 		agi->agi_newino = cpu_to_be32(NULLAGINO);
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
@@ -2853,6 +2876,26 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			xfs_btree_init_block(mp, buf, XFS_IBT_MAGIC, 0, 0,
 						agno, 0);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+		/*
+		 * Free INO btree root block
+		 */
+		if (!finobt)
+			continue;
+
+		buf = libxfs_getbuf(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
+				bsize);
+		buf->b_ops = &xfs_inobt_buf_ops;
+		block = XFS_BUF_TO_BLOCK(buf);
+		memset(block, 0, blocksize);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, buf, XFS_FIBT_CRC_MAGIC, 0, 0,
+						agno, XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, buf, XFS_FIBT_MAGIC, 0, 0,
+						agno, 0);
+		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	}
 
 	/*
@@ -3089,7 +3132,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b log=n|size=num]\n\
-/* metadata */		[-m crc=[0|1]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectlog=n|sectsize=num\n\
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
