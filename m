Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA6E27F5E
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B1D0F8F8035
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:03 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ij1SPQ6iUbZuvpP8 for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:00 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Ib-NA
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002eA-M3
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/15] mkfs: Sanitise the superblock feature macros
Date: Fri, 29 Nov 2013 12:43:38 +1100
Message-Id: <1385689430-10103-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1385689430-10103-1-git-send-email-david@fromorbit.com>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
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
---
 include/xfs_mkfs.h |  25 +-----
 mkfs/xfs_mkfs.c    | 227 ++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 146 insertions(+), 106 deletions(-)

diff --git a/include/xfs_mkfs.h b/include/xfs_mkfs.h
index 3388f6d..3af9cb1 100644
--- a/include/xfs_mkfs.h
+++ b/include/xfs_mkfs.h
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
index 3145205..caa0631 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -862,6 +862,86 @@ discard_blocks(dev_t dev, __uint64_t nsectors)
 		platform_discard_blocks(fd, 0, nsectors << 9);
 }
 
+struct sb_feat_args {
+	int	log_version;
+	int	attr_version;
+	int	dir_version;
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
+}
+
 int
 main(
 	int			argc,
@@ -873,8 +953,6 @@ main(
 	xfs_agnumber_t		agno;
 	__uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
-	int			attrversion;
-	int			projid16bit;
 	struct xfs_btree_block	*block;
 	int			blflag;
 	int			blocklog;
@@ -889,8 +967,6 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	int			dirftype;
-	int			dirversion;
 	char			*dsize;
 	int			dsu;
 	int			dsw;
@@ -898,7 +974,6 @@ main(
 	int			dswidth;
 	int			force_overwrite;
 	struct fsxattr		fsx;
-	int			iaflag;
 	int			ilflag;
 	int			imaxpct;
 	int			imflag;
@@ -918,7 +993,6 @@ main(
 	int			loginternal;
 	char			*logsize;
 	xfs_dfsbno_t		logstart;
-	int			logversion;
 	int			lvflag;
 	int			lsflag;
 	int			lsectorlog;
@@ -938,7 +1012,6 @@ main(
 	int			nftype;
 	int			nsflag;
 	int			nvflag;
-	int			nci;
 	int			Nflag;
 	int			discard = 1;
 	char			*p;
@@ -962,16 +1035,24 @@ main(
 	int			worst_freelist;
 	libxfs_init_t		xi;
 	struct fs_topology	ft;
-	int			lazy_sb_counters;
-	int			crcs_enabled;
+	struct sb_feat_args	sb_feat = {
+		.log_version = 2,
+		.attr_version = 2,
+		.dir_version = XFS_DFL_DIR_VERSION,
+		.inode_align = XFS_IFLAG_ALIGN,
+		.nci = false,
+		.lazy_sb_counters = true,
+		.projid16bit = false,
+		.crcs_enabled = false,
+		.dirftype = false,
+		.parent_pointers = false,
+	};
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	attrversion = 2;
-	projid16bit = 0;
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
 	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
@@ -980,23 +1061,18 @@ main(
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = ldflag = lvflag = 0;
 	loginternal = 1;
-	logversion = 2;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
-	Nflag = nlflag = nsflag = nvflag = nci = 0;
-	nftype = dirftype = 0;		/* inode type information in the dir */
+	Nflag = nlflag = nsflag = nvflag = 0;
+	nftype = 0;
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
-	crcs_enabled = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1235,10 +1311,11 @@ main(
 				switch (getsubopt(&p, (constpp)iopts, &value)) {
 				case I_ALIGN:
 					if (!value || *value == '\0')
-						value = "1";
-					iaflag = atoi(value);
-					if (iaflag < 0 || iaflag > 1)
+						break;
+					c = atoi(value);
+					if (c < 0 || c > 1)
 						illegal(value, "i align");
+					sb_feat.inode_align = c ? true : false;
 					break;
 				case I_LOG:
 					if (!value || *value == '\0')
@@ -1308,7 +1385,7 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 2)
 						illegal(value, "i attr");
-					attrversion = c;
+					sb_feat.attr_version = c;
 					break;
 				case I_PROJID32BIT:
 					if (!value || *value == '\0')
@@ -1316,7 +1393,7 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "i projid32bit");
-					projid16bit = c ? 0 : 1;
+					sb_feat.projid16bit = c ? false : true;
 					break;
 				default:
 					unknown('i', value);
@@ -1406,9 +1483,10 @@ main(
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
@@ -1457,7 +1535,8 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "l lazy-count");
-					lazy_sb_counters = c;
+					sb_feat.lazy_sb_counters = c ? true
+								     : false;
 					break;
 				default:
 					unknown('l', value);
@@ -1481,12 +1560,14 @@ main(
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "m crc");
-					crcs_enabled = c;
-					if (nftype && crcs_enabled) {
+					if (c && nftype) {
 						fprintf(stderr,
 _("cannot specify both crc and ftype\n"));
 						usage();
 					}
+					sb_feat.crcs_enabled = c ? true : false;
+					if (c)
+						sb_feat.dirftype = true;
 					break;
 				default:
 					unknown('m', value);
@@ -1536,12 +1617,14 @@ _("cannot specify both crc and ftype\n"));
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
@@ -1553,12 +1636,12 @@ _("cannot specify both crc and ftype\n"));
 					c = atoi(value);
 					if (c < 0 || c > 1)
 						illegal(value, "n ftype");
-					if (crcs_enabled) {
+					if (sb_feat.crcs_enabled) {
 						fprintf(stderr,
 _("cannot specify both crc and ftype\n"));
 						usage();
 					}
-					dirftype = c;
+					sb_feat.dirftype = c ? true : false;
 					nftype = 1;
 					break;
 				default:
@@ -1778,7 +1861,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 		usage();
 	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
 		lsu = blocksize;
-		logversion = 2;
+		sb_feat.log_version = 2;
 	}
 
 	/*
@@ -1786,7 +1869,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	 * no longer optional for CRC enabled filesystems.  Catch them up front
 	 * here before doing anything else.
 	 */
-	if (crcs_enabled) {
+	if (sb_feat.crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
 		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
 			fprintf(stderr,
@@ -1796,28 +1879,28 @@ _("Minimum inode size for CRCs is %d bytes\n"),
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
@@ -1825,7 +1908,7 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 
 		/* 32 bit project quota always on */
 		/* attr2 always on */
-		if (projid16bit == 1) {
+		if (sb_feat.projid16bit) {
 			fprintf(stderr,
 _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 			usage();
@@ -1879,11 +1962,11 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
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
@@ -2015,10 +2098,10 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
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
@@ -2333,12 +2416,12 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
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
 		fprintf(stderr,
 	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
 			(lsunit * blocksize));
@@ -2346,9 +2429,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		fprintf(stderr, _("log stripe unit adjusted to 32KiB\n"));
 	}
 
-	min_logblocks = max_trans_res(crcs_enabled, dirversion,
+	min_logblocks = max_trans_res(sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
-				   logversion, lsunit);
+				   sb_feat.log_version, lsunit);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
@@ -2462,14 +2545,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
@@ -2482,13 +2557,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
-			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled,
+			"", sectorsize, sb_feat.attr_version,
+				    !sb_feat.projid16bit,
+			"", sb_feat.crcs_enabled,
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
@@ -2531,17 +2609,17 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
@@ -2552,22 +2630,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
+	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
 
 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
@@ -2623,7 +2686,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	libxfs_log_clear(mp->m_logdev_targp,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT);
+		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT);
 
 	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
