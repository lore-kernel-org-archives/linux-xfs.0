Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE4C229DFC
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71969304039
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:26:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JNAldkXrZzp5eFB6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:41 -0700 (PDT)
Subject: [PATCH 09/15] mkfs.xfs: create reflink btree
From: "Darrick J. Wong" <djwong@birch.djwong.org>
Date: Mon, 29 Jun 2015 20:26:37 -0700
Message-ID: <20150630032637.572.59058.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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

Create the reflink btree at mkfs time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   26 ++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c     |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 70 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 6260e0c..c390f51 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -169,6 +169,32 @@ will create free inode btrees for filesystems created with the (default)
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
+will not create reflink btrees.  This feature is only available for filesystems
+created with the (default)
+.B \-m crc=1
+option set. When the option
+.B \-m crc=0
+is used, the reference count btree feature is not supported and is disabled.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5664121..93e3a2f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -189,6 +189,8 @@ char	*mopts[] = {
 	"finobt",
 #define M_RMAPBT	2
 	"rmapbt",
+#define M_REFLINK	3
+	"reflink",
 	NULL
 };
 
@@ -1011,6 +1013,7 @@ main(
 	bool			finobtflag;
 	int			spinodes;
 	bool			rmapbt;
+	bool			reflink;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1048,6 +1051,7 @@ main(
 	finobtflag = false;
 	spinodes = 0;
 	rmapbt = false;
+	reflink = false;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1565,6 +1569,14 @@ _("cannot specify both crc and ftype\n"));
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
@@ -1938,6 +1950,12 @@ _("warning: rmapbt not supported without CRC support, disabled.\n"));
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
@@ -2555,6 +2573,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
 	if (rmapbt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	if (reflink)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 
 	if (loginternal) {
 		/*
@@ -2618,7 +2638,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -2627,7 +2647,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled, finobt, spinodes, rmapbt,
+			"", crcs_enabled, finobt, spinodes, rmapbt, reflink,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
@@ -2817,7 +2837,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						cpu_to_be32(XFS_RMAP_BLOCK(mp));
 			agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
 		}
-
+		if (reflink) {
+			agf->agf_reflink_root = cpu_to_be32(XFS_RL_BLOCK(mp));
+			agf->agf_reflink_level = cpu_to_be32(1);
+		}
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
@@ -2986,6 +3009,23 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
+		 * reflink btree root block
+		 */
+		if (reflink) {
+			buf = libxfs_getbuf(mp->m_ddev_targp,
+					XFS_AGB_TO_DADDR(mp, agno, XFS_RL_BLOCK(mp)),
+					bsize);
+			buf->b_ops = &xfs_reflinkbt_buf_ops;
+
+			block = XFS_BUF_TO_BLOCK(buf);
+			memset(block, 0, blocksize);
+			xfs_btree_init_block(mp, buf, XFS_RLBT_CRC_MAGIC, 0, 0,
+						agno, XFS_BTREE_CRC_BLOCKS);
+
+			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		}
+
+		/*
 		 * INO btree root block
 		 */
 		buf = libxfs_getbuf(mp->m_ddev_targp,
@@ -3318,7 +3358,7 @@ usage( void )
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
