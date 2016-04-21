Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 018E47CB2
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 760C88F8040
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3y0srM5EtbL0vuZb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:39:58 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 7DB2D3E70A3
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:39:58 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0G007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:39:57 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
Date: Thu, 21 Apr 2016 11:39:37 +0200
Message-Id: <1461231593-31294-4-git-send-email-jtulak@redhat.com>
In-Reply-To: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
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

From: Dave Chinner <dchinner@redhat.com>

They are horrible macros that simply obfuscate the code, so
let's factor the code and make them nice functions.

To do this, add a sb_feat_args structure that carries around the
variables rather than a strange assortment of variables. This means
all the default can be clearly defined in a structure
initialisation, and dependent feature bits are easy to check.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
UPDATE
* if -m crc=0,finobt=1, simplify the condition
* remove a check for -m crc, -n ftype conflict causing a bug
* -i align should default to 1 is no value given
---
 include/xfs_multidisk.h |  25 +---
 mkfs/xfs_mkfs.c         | 295 +++++++++++++++++++++++++++++-------------------
 2 files changed, 183 insertions(+), 137 deletions(-)

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index 4b99992..11d6233 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -23,36 +23,13 @@
                  XFS_SB_VERSION_EXTFLGBIT | \
                  XFS_SB_VERSION_DIRV2BIT)
 
-#define XFS_SB_VERSION_MKFS(crc,ia,dia,log2,attr1,sflag,ci,more) (\
-	((crc)||(ia)||(dia)||(log2)||(attr1)||(sflag)||(ci)||(more)) ? \
-	(((crc) ? XFS_SB_VERSION_5 : XFS_SB_VERSION_4) |		\
-		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
-		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
-		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
-		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
-		((ci) ? XFS_SB_VERSION_BORGBIT : 0) |			\
-		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
-	        XFS_DFL_SB_VERSION_BITS |                               \
-	0 ) : XFS_SB_VERSION_1 )
-
-#define XFS_SB_VERSION2_MKFS(crc, lazycount, attr2, projid32bit, parent, \
-			     ftype) (\
-	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
-	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
-	((projid32bit) ? XFS_SB_VERSION2_PROJID32BIT : 0) |		\
-	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
-	((crc) ? XFS_SB_VERSION2_CRCBIT : 0) |				\
-	((ftype) ? XFS_SB_VERSION2_FTYPE : 0) |				\
-	0 )
-
 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
 #define	XFS_DINODE_DFL_LOG	8		/* 256 byte inodes */
 #define	XFS_DINODE_DFL_CRC_LOG	9		/* 512 byte inodes for CRCs */
 #define	XFS_MIN_DATA_BLOCKS	100
 #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
 #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
-#define	XFS_IFLAG_ALIGN		1		/* -i align defaults on */
+#define	XFS_IFLAG_ALIGN		true		/* -i align defaults on */
 #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
 #define	XFS_DFL_DIR_VERSION	2		/* default directory version */
 #define	XFS_DFL_LOG_SIZE	1000		/* default log size, blocks */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4be14da..963545b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -880,6 +880,109 @@ discard_blocks(dev_t dev, __uint64_t nsectors)
 		platform_discard_blocks(fd, 0, nsectors << 9);
 }
 
+struct sb_feat_args {
+	int	log_version;
+	int	attr_version;
+	int	dir_version;
+	int	spinodes;
+	int	finobt;
+	bool	finobtflag;
+	bool	inode_align;
+	bool	nci;
+	bool	lazy_sb_counters;
+	bool	projid16bit;
+	bool	crcs_enabled;
+	bool	dirftype;
+	bool	parent_pointers;
+};
+
+static void
+sb_set_features(
+	struct xfs_sb		*sbp,
+	struct sb_feat_args	*fp,
+	int			sectsize,
+	int			lsectsize,
+	int			dsunit)
+{
+
+	sbp->sb_versionnum = XFS_DFL_SB_VERSION_BITS;
+	if (fp->crcs_enabled)
+		sbp->sb_versionnum |= XFS_SB_VERSION_5;
+	else
+		sbp->sb_versionnum |= XFS_SB_VERSION_4;
+
+	if (fp->inode_align)
+		sbp->sb_versionnum |= XFS_SB_VERSION_ALIGNBIT;
+	if (dsunit)
+		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
+	if (fp->log_version == 2)
+		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
+	if (fp->attr_version == 1)
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	if (sectsize > BBSIZE || lsectsize > BBSIZE)
+		sbp->sb_versionnum |= XFS_SB_VERSION_SECTORBIT;
+	if (fp->nci)
+		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;
+
+
+	sbp->sb_features2 = 0;
+	if (fp->lazy_sb_counters)
+		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+	if (!fp->projid16bit)
+		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
+	if (fp->parent_pointers)
+		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
+	if (fp->crcs_enabled)
+		sbp->sb_features2 |= XFS_SB_VERSION2_CRCBIT;
+	if (fp->attr_version == 2)
+		sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
+
+	/* v5 superblocks have their own feature bit for dirftype */
+	if (fp->dirftype && !fp->crcs_enabled)
+		sbp->sb_features2 |= XFS_SB_VERSION2_FTYPE;
+
+	/* update whether extended features are in use */
+	if (sbp->sb_features2 != 0)
+		sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+
+	/*
+	 * Due to a structure alignment issue, sb_features2 ended up in one
+	 * of two locations, the second "incorrect" location represented by
+	 * the sb_bad_features2 field. To avoid older kernels mounting
+	 * filesystems they shouldn't, set both field to the same value.
+	 */
+	sbp->sb_bad_features2 = sbp->sb_features2;
+
+	if (!fp->crcs_enabled)
+		return;
+
+	/* default features for v5 filesystems */
+	sbp->sb_features_compat = 0;
+	sbp->sb_features_ro_compat = 0;
+	sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
+	sbp->sb_features_log_incompat = 0;
+
+	if (fp->finobt)
+		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
+
+	/*
+	 * Sparse inode chunk support has two main inode alignment requirements.
+	 * First, sparse chunk alignment must match the cluster size. Second,
+	 * full chunk alignment must match the inode chunk size.
+	 *
+	 * Copy the already calculated/scaled inoalignmt to spino_align and
+	 * update the former to the full inode chunk size.
+	 */
+	if (fp->spinodes) {
+		sbp->sb_spino_align = sbp->sb_inoalignmt;
+		sbp->sb_inoalignmt = \
+			XFS_INODES_PER_CHUNK * \
+			sbp->sb_inodesize >> sbp->sb_blocklog;
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
+	}
+
+}
+
 int
 main(
 	int			argc,
@@ -891,8 +994,6 @@ main(
 	xfs_agnumber_t		agno;
 	__uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
-	int			attrversion;
-	int			projid16bit;
 	struct xfs_btree_block	*block;
 	int			blflag;
 	int			blocklog;
@@ -907,8 +1008,6 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	int			dirftype;
-	int			dirversion;
 	char			*dsize;
 	int			dsu;
 	int			dsw;
@@ -916,7 +1015,6 @@ main(
 	int			dswidth;
 	int			force_overwrite;
 	struct fsxattr		fsx;
-	int			iaflag;
 	int			ilflag;
 	int			imaxpct;
 	int			imflag;
@@ -936,7 +1034,6 @@ main(
 	int			loginternal;
 	char			*logsize;
 	xfs_fsblock_t		logstart;
-	int			logversion;
 	int			lvflag;
 	int			lsflag;
 	int			lsuflag;
@@ -958,7 +1055,6 @@ main(
 	int			nftype;
 	int			nsflag;
 	int			nvflag;
-	int			nci;
 	int			Nflag;
 	int			discard = 1;
 	char			*p;
@@ -982,11 +1078,21 @@ main(
 	int			worst_freelist;
 	libxfs_init_t		xi;
 	struct fs_topology	ft;
-	int			lazy_sb_counters;
-	int			crcs_enabled;
-	int			finobt;
-	bool			finobtflag;
-	int			spinodes;
+	struct sb_feat_args	sb_feat = {
+		.finobt = 1,
+		.finobtflag = false,
+		.spinodes = 0,
+		.log_version = 2,
+		.attr_version = 2,
+		.dir_version = XFS_DFL_DIR_VERSION,
+		.inode_align = XFS_IFLAG_ALIGN,
+		.nci = false,
+		.lazy_sb_counters = true,
+		.projid16bit = false,
+		.crcs_enabled = true,
+		.dirftype = false,
+		.parent_pointers = false,
+	};
 
 	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
@@ -994,8 +1100,6 @@ main(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	attrversion = 2;
-	projid16bit = 0;
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
 	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
@@ -1004,27 +1108,19 @@ main(
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
-	logversion = 2;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
-	Nflag = nlflag = nsflag = nvflag = nci = 0;
-	dirftype = 1;		/* inode type information in the dir */
+	sb_feat.dirftype = 1;		/* inode type information in the dir */
+	Nflag = nlflag = nsflag = nvflag = 0;
 	nftype = 0;
 	dirblocklog = dirblocksize = 0;
-	dirversion = XFS_DFL_DIR_VERSION;
 	qflag = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
-	iaflag = XFS_IFLAG_ALIGN;
 	dfile = logfile = rtfile = NULL;
 	dsize = logsize = rtsize = rtextsize = protofile = NULL;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
 	nodsflag = norsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
-	lazy_sb_counters = 1;
-	crcs_enabled = 1;
-	finobt = 1;
-	finobtflag = false;
-	spinodes = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1264,9 +1360,10 @@ main(
 				case I_ALIGN:
 					if (!value || *value == '\0')
 						value = "1";
-					iaflag = atoi(value);
-					if (iaflag < 0 || iaflag > 1)
+					c = atoi(value);
+					if (c < 0 || c > 1)
 						illegal(value, "i align");
+					sb_feat.inode_align = c ? true : false;
 					break;
 				case I_LOG:
 					if (!value || *value == '\0')
@@ -1336,7 +1433,7 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 2)
 						illegal(value, "i attr");
-					attrversion = c;
+					sb_feat.attr_version = c;
 					break;
 				case I_PROJID32BIT:
 					if (!value || *value == '\0')
@@ -1344,14 +1441,15 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "i projid32bit");
-					projid16bit = c ? 0 : 1;
+					sb_feat.projid16bit = c ? false : true;
 					break;
 				case I_SPINODES:
 					if (!value || *value == '\0')
 						value = "1";
-					spinodes = atoi(value);
-					if (spinodes < 0 || spinodes > 1)
+					c = atoi(value);
+					if (c < 0 || c > 1)
 						illegal(value, "i spinodes");
+					sb_feat.spinodes = c;
 					break;
 				default:
 					unknown('i', value);
@@ -1443,9 +1541,10 @@ main(
 						reqval('l', lopts, L_VERSION);
 					if (lvflag)
 						respec('l', lopts, L_VERSION);
-					logversion = atoi(value);
-					if (logversion < 1 || logversion > 2)
+					c = atoi(value);
+					if (c < 1 || c > 2)
 						illegal(value, "l version");
+					sb_feat.log_version = c;
 					lvflag = 1;
 					break;
 				case L_SIZE:
@@ -1494,7 +1593,8 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "l lazy-count");
-					lazy_sb_counters = c;
+					sb_feat.lazy_sb_counters = c ? true
+								     : false;
 					break;
 				default:
 					unknown('l', value);
@@ -1518,7 +1618,9 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "m crc");
-					crcs_enabled = c;
+					sb_feat.crcs_enabled = c ? true : false;
+					if (c)
+						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
 					if (!value || *value == '\0')
@@ -1526,8 +1628,8 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "m finobt");
-					finobt = c;
-					finobtflag = true;
+					sb_feat.finobtflag = true;
+					sb_feat.finobt = c;
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
@@ -1583,12 +1685,14 @@ main(
 					if (nvflag)
 						respec('n', nopts, N_VERSION);
 					if (!strcasecmp(value, "ci")) {
-						nci = 1; /* ASCII CI mode */
+						/* ASCII CI mode */
+						sb_feat.nci = true;
 					} else {
-						dirversion = atoi(value);
-						if (dirversion != 2)
+						c = atoi(value);
+						if (c != 2)
 							illegal(value,
 								"n version");
+						sb_feat.dir_version = c;
 					}
 					nvflag = 1;
 					break;
@@ -1600,7 +1704,7 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "n ftype");
-					dirftype = c;
+					sb_feat.dirftype = c ? true : false;
 					nftype = 1;
 					break;
 				default:
@@ -1749,13 +1853,13 @@ main(
 		fprintf(stderr, _("illegal block size %d\n"), blocksize);
 		usage();
 	}
-	if (crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
+	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 		fprintf(stderr,
 _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 			XFS_MIN_CRC_BLOCKSIZE);
 		usage();
 	}
-	if (crcs_enabled && !dirftype) {
+	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
 		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
 		usage();
 	}
@@ -1820,7 +1924,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 		usage();
 	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
 		lsu = blocksize;
-		logversion = 2;
+		sb_feat.log_version = 2;
 	}
 
 	/*
@@ -1828,7 +1932,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	 * no longer optional for CRC enabled filesystems.  Catch them up front
 	 * here before doing anything else.
 	 */
-	if (crcs_enabled) {
+	if (sb_feat.crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
 		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
 			fprintf(stderr,
@@ -1838,28 +1942,28 @@ _("Minimum inode size for CRCs is %d bytes\n"),
 		}
 
 		/* inodes always aligned */
-		if (iaflag != 1) {
+		if (!sb_feat.inode_align) {
 			fprintf(stderr,
 _("Inodes always aligned for CRC enabled filesytems\n"));
 			usage();
 		}
 
 		/* lazy sb counters always on */
-		if (lazy_sb_counters != 1) {
+		if (!sb_feat.lazy_sb_counters) {
 			fprintf(stderr,
 _("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
 			usage();
 		}
 
 		/* version 2 logs always on */
-		if (logversion != 2) {
+		if (sb_feat.log_version != 2) {
 			fprintf(stderr,
 _("V2 logs always enabled for CRC enabled filesytems\n"));
 			usage();
 		}
 
 		/* attr2 always on */
-		if (attrversion != 2) {
+		if (sb_feat.attr_version != 2) {
 			fprintf(stderr,
 _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 			usage();
@@ -1867,7 +1971,7 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 
 		/* 32 bit project quota always on */
 		/* attr2 always on */
-		if (projid16bit == 1) {
+		if (sb_feat.projid16bit) {
 			fprintf(stderr,
 _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 			usage();
@@ -1881,17 +1985,17 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		 * tried to use crc=0,finobt=1, then issue a warning before
 		 * turning them off.
 		 */
-		if (finobt && finobtflag) {
+		if (sb_feat.finobt && sb_feat.finobtflag) {
 			fprintf(stderr,
 _("warning: finobt not supported without CRC support, disabled.\n"));
 		}
-		finobt = 0;
+		sb_feat.finobt = 0;
 	}
 
-	if (spinodes && !crcs_enabled) {
+	if (sb_feat.spinodes && !sb_feat.crcs_enabled) {
 		fprintf(stderr,
 _("warning: sparse inodes not supported without CRC support, disabled.\n"));
-		spinodes = 0;
+		sb_feat.spinodes = 0;
 	}
 
 	if (nsflag || nlflag) {
@@ -1941,11 +2045,11 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		inodelog = blocklog - libxfs_highbit32(inopblock);
 		isize = 1 << inodelog;
 	} else if (!ilflag && !isflag) {
-		inodelog = crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
-					: XFS_DINODE_DFL_LOG;
+		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
+						: XFS_DINODE_DFL_LOG;
 		isize = 1 << inodelog;
 	}
-	if (crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+	if (sb_feat.crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
 		fprintf(stderr,
 		_("Minimum inode size for CRCs is %d bytes\n"),
 			1 << XFS_DINODE_DFL_CRC_LOG);
@@ -2075,10 +2179,10 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	}
 
 	/* if lsu or lsunit was specified, automatically use v2 logs */
-	if ((lsu || lsunit) && logversion == 1) {
+	if ((lsu || lsunit) && sb_feat.log_version == 1) {
 		fprintf(stderr,
 			_("log stripe unit specified, using v2 logs\n"));
-		logversion = 2;
+		sb_feat.log_version = 2;
 	}
 
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
@@ -2393,12 +2497,12 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		}
 		/* convert from 512 byte blocks to fs blocks */
 		lsunit = DTOBT(lsunit);
-	} else if (logversion == 2 && loginternal && dsunit) {
+	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
 		/* lsunit and dsunit now in fs blocks */
 		lsunit = dsunit;
 	}
 
-	if (logversion == 2 && (lsunit * blocksize) > 256 * 1024) {
+	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
 		/* Warn only if specified on commandline */
 		if (lsuflag || lsunitflag) {
 			fprintf(stderr,
@@ -2410,9 +2514,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		lsunit = (32 * 1024) >> blocklog;
 	}
 
-	min_logblocks = max_trans_res(crcs_enabled, dirversion,
+	min_logblocks = max_trans_res(sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
-				   logversion, lsunit, finobt);
+				   sb_feat.log_version, lsunit, sb_feat.finobt);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
@@ -2490,25 +2594,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * sb_versionnum and finobt flags must be set before we use
 	 * XFS_PREALLOC_BLOCKS().
 	 */
-	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
-					attrversion == 2, !projid16bit, 0,
-					(!crcs_enabled && dirftype));
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
+	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
 
-	if (finobt)
-		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
 
 	if (loginternal) {
 		/*
@@ -2560,14 +2647,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	}
 	validate_log_size(logblocks, blocklog, min_logblocks);
 
-	/*
-	 * dirent filetype field always enabled on v5 superblocks
-	 */
-	if (crcs_enabled) {
-		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
-		dirftype = 1;
-	}
-
 	if (!qflag || Nflag) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
@@ -2580,13 +2659,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
-			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled, finobt, spinodes,
+			"", sectorsize, sb_feat.attr_version,
+				    !sb_feat.projid16bit,
+			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
-			dirversion, dirblocksize, nci, dirftype,
+			sb_feat.dir_version, dirblocksize, sb_feat.nci,
+				sb_feat.dirftype,
 			logfile, 1 << blocklog, (long long)logblocks,
-			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
+			sb_feat.log_version, "", lsectorsize, lsunit,
+				sb_feat.lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
 			(long long)rtblocks, (long long)rtextents);
 		if (Nflag)
@@ -2630,17 +2712,17 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_unit = dsunit;
 	sbp->sb_width = dswidth;
 	sbp->sb_dirblklog = dirblocklog - blocklog;
-	if (logversion == 2) {	/* This is stored in bytes */
+	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
 		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
 		sbp->sb_logsunit = lsunit;
 	} else
 		sbp->sb_logsunit = 0;
-	if (iaflag) {
+	if (sb_feat.inode_align) {
 		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-		if (crcs_enabled)
+		if (sb_feat.crcs_enabled)
 			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
 		sbp->sb_inoalignmt = cluster_size >> blocklog;
-		iaflag = sbp->sb_inoalignmt != 0;
+		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
 	if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
@@ -2651,19 +2733,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_logsectsize = 0;
 	}
 
-	/*
-	 * Sparse inode chunk support has two main inode alignment requirements.
-	 * First, sparse chunk alignment must match the cluster size. Second,
-	 * full chunk alignment must match the inode chunk size.
-	 *
-	 * Copy the already calculated/scaled inoalignmt to spino_align and
-	 * update the former to the full inode chunk size.
-	 */
-	if (spinodes) {
-		sbp->sb_spino_align = sbp->sb_inoalignmt;
-		sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK * isize >> blocklog;
-		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
-	}
+	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
 
 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
@@ -2719,8 +2789,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	libxfs_log_clear(mp->m_logdev_targp, NULL,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT, XLOG_INIT_CYCLE,
-		false);
+		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
 
 	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
@@ -2825,7 +2894,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agi->agi_count = 0;
 		agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
 		agi->agi_level = cpu_to_be32(1);
-		if (finobt) {
+		if (sb_feat.finobt) {
 			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
 			agi->agi_free_level = cpu_to_be32(1);
 		}
@@ -2958,7 +3027,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		/*
 		 * Free INO btree root block
 		 */
-		if (!finobt) {
+		if (!sb_feat.finobt) {
 			xfs_perag_put(pag);
 			continue;
 		}
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
