Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6D1729EFE
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:10:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98C918F8035
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:10:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id O16k1FOWvAcV9r11 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:10:46 -0700 (PDT)
Subject: [PATCH 50/51] mkfs.xfs: format reflink enabled filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:10:39 -0700
Message-ID: <20151007051039.1504.53891.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Create the refcount btree at mkfs time and set the feature flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   28 +++++++++++++++++++++++
 mkfs/xfs_mkfs.c     |   62 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 85 insertions(+), 5 deletions(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 6260e0c..4caf7b1 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -169,6 +169,34 @@ will create free inode btrees for filesystems created with the (default)
 option set. When the option
 .B \-m crc=0
 is used, the free inode btree feature is not supported and is disabled.
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
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 573774c..556b691 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -183,6 +183,8 @@ char	*mopts[] = {
 	"finobt",
 #define M_RMAPBT	2
 	"rmapbt",
+#define M_REFLINK	3
+	"reflink",
 	NULL
 };
 
@@ -950,6 +952,7 @@ main(
 	bool			finobtflag;
 	int			spinodes;
 	bool			rmapbt;
+	bool			reflink;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -988,6 +991,7 @@ main(
 	finobtflag = false;
 	spinodes = 0;
 	rmapbt = false;
+	reflink = false;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1500,6 +1504,14 @@ main(
 						illegal(value, "m rmapbt");
 					rmapbt = c;
 					break;
+				case M_REFLINK:
+					if (!value || *value == '\0')
+						reqval('m', mopts, M_CRC);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "m reflink");
+					reflink = c;
+					break;
 				default:
 					unknown('m', value);
 				}
@@ -1862,6 +1874,12 @@ _("warning: rmapbt not supported without CRC support, disabled.\n"));
 		rmapbt = 0;
 	}
 
+	if (reflink && !crcs_enabled) {
+		fprintf(stderr,
+_("warning: reflink not supported without CRC support, disabled.\n"));
+		reflink = false;
+	}
+
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
@@ -2479,6 +2497,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
 	if (rmapbt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	if (reflink)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 
 	if (loginternal) {
 		/*
@@ -2542,7 +2562,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -2551,7 +2571,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled, finobt, spinodes, rmapbt,
+			"", crcs_enabled, finobt, spinodes, rmapbt, reflink,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
@@ -2746,7 +2766,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						cpu_to_be32(XFS_RMAP_BLOCK(mp));
 			agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
 		}
-
+		if (reflink) {
+			agf->agf_refcount_root = cpu_to_be32(xfs_refc_block(mp));
+			agf->agf_refcount_level = cpu_to_be32(1);
+		}
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
@@ -2915,6 +2938,23 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
+		 * refcount btree root block
+		 */
+		if (reflink) {
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
@@ -3002,9 +3042,21 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
+			/* account for refcount btree root */ 
+			if (reflink) {
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
@@ -3253,7 +3305,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b log=n|size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,reflink=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectlog=n|sectsize=num\n\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
