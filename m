Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0E437F5E
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B19598F8035
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CaBax0CkFgPr80eY for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:04 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006In-Sf
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:53 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002eo-Rn
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/15] mkfs: table based parsing for converted parameters
Date: Fri, 29 Nov 2013 12:43:46 +1100
Message-Id: <1385689430-10103-12-git-send-email-david@fromorbit.com>
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

All the parameters that can be passed as block or sector sizes need
to be passed the block and sector sizes that they should be using
for conversion. For parameter parsing, it is always the same two
variables, so to make things easy just declare them as global
variables so we can avoid needing to pass them to getnum_checked().

We also need to mark these parameters are requiring conversion so
that we don't need to pass this information manually to
getnum_checked(). Further, some of these options are required to
have a power of 2 value, so add optional checking for that as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 171 ++++++++++++++++++++++----------------------------------
 1 file changed, 68 insertions(+), 103 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index af9b9c4..e7bee06 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -52,6 +52,13 @@ static int  ispow2(unsigned int i);
 static long long cvtnum(unsigned int blocksize,
 			unsigned int sectorsize, const char *s);
 
+/*
+ * The configured block and sector sizes are defined as global variables so
+ * that they don't need to be passed to functions that require them.
+ */
+unsigned int		blocksize;
+unsigned int		sectorsize;
+
 #define MAX_SUBOPTS	16
 #define SUBOPT_NEEDS_VAL	(-1LL)
 struct opt_params {
@@ -61,6 +68,8 @@ struct opt_params {
 	struct subopt_param {
 		int		index;
 		bool		seen;
+		bool		convert;
+		bool		is_power_2;
 		long long	minval;
 		long long	maxval;
 		long long	defaultval;
@@ -83,6 +92,8 @@ struct opt_params bopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = B_SIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_BLOCKSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -140,6 +151,9 @@ struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SIZE,
+		  .convert = true,
+		  .minval = XFS_AG_MIN_BYTES,
+		  .maxval = LLONG_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SUNIT,
@@ -153,11 +167,15 @@ struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_AGSIZE,
+		  .convert = true,
 		  .minval = XFS_AG_MIN_BYTES,
 		  .maxval = XFS_AG_MAX_BYTES,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SU,
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SW,
@@ -171,6 +189,8 @@ struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SECTSIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -235,11 +255,13 @@ struct opt_params iopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_PERBLOCK,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_INODE_PERBLOCK,
 		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_SIZE,
+		  .is_power_2 = true,
 		  .minval = XFS_DINODE_MIN_SIZE,
 		  .maxval = XFS_DINODE_MAX_SIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -298,6 +320,9 @@ struct opt_params lopts = {
 		  .defaultval = 1,
 		},
 		{ .index = L_SIZE,
+		  .convert = true,
+		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
+		  .maxval = XFS_MAX_LOG_BYTES,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_VERSION,
@@ -311,6 +336,9 @@ struct opt_params lopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SU,
+		  .convert = true,
+		  .minval = XLOG_MIN_RECORD_BSIZE,
+		  .maxval = XLOG_MAX_RECORD_BSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_DEV,
@@ -322,6 +350,8 @@ struct opt_params lopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SECTSIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -362,6 +392,8 @@ struct opt_params nopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_SIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -398,9 +430,15 @@ struct opt_params ropts = {
 	},
 	.subopt_params = {
 		{ .index = R_EXTSIZE,
+		  .convert = true,
+		  .minval = XFS_MIN_RTEXTSIZE,
+		  .maxval = XFS_MAX_RTEXTSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_SIZE,
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = LLONG_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_DEV,
@@ -443,11 +481,15 @@ struct opt_params sopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SECTSIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -1230,15 +1272,15 @@ sb_set_features(
 long long
 getnum(
 	const char	*str,
-	unsigned int	blocksize,
-	unsigned int	sectorsize,
+	unsigned int	blksize,
+	unsigned int	sectsize,
 	bool		convert)
 {
 	long long	i;
 	char		*sp;
 
 	if (convert)
-		return cvtnum(blocksize, sectorsize, str);
+		return cvtnum(blksize, sectsize, str);
 
 	i = strtoll(str, &sp, 0);
 	if (i == 0 && sp == str)
@@ -1287,9 +1329,11 @@ getnum_checked(
 		return sp->defaultval;
 	}
 
-	c = getnum(str, 0, 0, false);
+	c = getnum(str, blocksize, sectorsize, sp->convert);
 	if (c < sp->minval || c > sp->maxval)
 		illegal_option(str, opts, index);
+	if (sp->is_power_2 && !ispow2(c))
+		illegal_option(str, opts, index);
 	return c;
 }
 
@@ -1307,7 +1351,6 @@ main(
 	struct xfs_btree_block	*block;
 	int			blflag;
 	int			blocklog;
-	unsigned int		blocksize;
 	int			bsflag;
 	int			bsize;
 	xfs_buf_t		*buf;
@@ -1377,7 +1420,6 @@ main(
 	char			*rtsize;
 	xfs_sb_t		*sbp;
 	int			sectorlog;
-	unsigned int		sectorsize;
 	__uint64_t		sector_mask;
 	int			slflag;
 	int			ssflag;
@@ -1454,18 +1496,11 @@ main(
 					blflag = 1;
 					break;
 				case B_SIZE:
-					if (!value || *value == '\0')
-						reqval('b', subopts, B_SIZE);
-					if (bsflag)
-						respec('b', subopts, B_SIZE);
 					if (blflag)
 						conflict('b', subopts, B_LOG,
 							 B_SIZE);
-					blocksize = getnum(value, blocksize,
-							sectorsize, true);
-					if (blocksize <= 0 ||
-					    !ispow2(blocksize))
-						illegal(value, "b size");
+					blocksize = getnum_checked(value, &bopts,
+								  B_SIZE);
 					blocklog = libxfs_highbit32(blocksize);
 					bsflag = 1;
 					break;
@@ -1488,14 +1523,8 @@ main(
 					daflag = 1;
 					break;
 				case D_AGSIZE:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_AGSIZE);
-					if (dasize)
-						respec('d', subopts, D_AGSIZE);
-					agsize = getnum(value, blocksize,
-							sectorsize, true);
-					if ((__int64_t)agsize <= 0)
-						illegal(value, "d agsize");
+					agsize = getnum_checked(value, &dopts,
+								 D_AGSIZE);
 					dasize = 1;
 					break;
 				case D_FILE:
@@ -1533,17 +1562,11 @@ main(
 								 D_SWIDTH);
 					break;
 				case D_SU:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_SU);
-					if (dsu)
-						respec('d', subopts, D_SU);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SU);
-					dsu = getnum(value, blocksize,
-						     sectorsize, true);
-					if (dsu < 0)
-						illegal(value, "d su");
+					dsu = getnum_checked(value, &dopts,
+								 D_SU);
 					break;
 				case D_SW:
 					if (nodsflag)
@@ -1577,18 +1600,11 @@ main(
 					slflag = 1;
 					break;
 				case D_SECTSIZE:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_SECTSIZE);
-					if (ssflag)
-						respec('d', subopts, D_SECTSIZE);
 					if (slflag)
 						conflict('d', subopts, D_SECTLOG,
 							 D_SECTSIZE);
-					sectorsize = getnum(value, blocksize,
-							    sectorsize, true);
-					if (sectorsize <= 0 ||
-					    !ispow2(sectorsize))
-						illegal(value, "d sectsize");
+					sectorsize = getnum_checked(value,
+							&dopts, D_SECTSIZE);
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					ssflag = 1;
@@ -1655,8 +1671,6 @@ main(
 							 I_PERBLOCK);
 					inopblock = getnum_checked(value, &iopts,
 								   I_PERBLOCK);
-					if (!ispow2(inopblock))
-						illegal(value, "i perblock");
 					ipflag = 1;
 					break;
 				case I_SIZE:
@@ -1668,8 +1682,6 @@ main(
 							 I_SIZE);
 					isize = getnum_checked(value, &iopts,
 							       I_SIZE);
-					if (!ispow2(isize))
-						illegal(value, "i size");
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
 					break;
@@ -1724,14 +1736,8 @@ main(
 					liflag = 1;
 					break;
 				case L_SU:
-					if (!value || *value == '\0')
-						reqval('l', subopts, L_SU);
-					if (lsu)
-						respec('l', subopts, L_SU);
-					lsu = getnum(value, blocksize,
-						     sectorsize, true);
-					if (lsu < 0)
-						illegal(value, "l su");
+					lsu = getnum_checked(value, &lopts,
+								 L_SU);
 					break;
 				case L_SUNIT:
 					lsunit = getnum_checked(value, &lopts,
@@ -1776,18 +1782,11 @@ main(
 					lslflag = 1;
 					break;
 				case L_SECTSIZE:
-					if (!value || *value == '\0')
-						reqval('l', subopts, L_SECTSIZE);
-					if (lssflag)
-						respec('l', subopts, L_SECTSIZE);
 					if (lslflag)
 						conflict('l', subopts, L_SECTLOG,
 							 L_SECTSIZE);
-					lsectorsize = getnum(value, blocksize,
-							     sectorsize, true);
-					if (lsectorsize <= 0 ||
-					    !ispow2(lsectorsize))
-						illegal(value, "l sectsize");
+					lsectorsize = getnum_checked(value,
+							&lopts, L_SECTSIZE);
 					lsectorlog =
 						libxfs_highbit32(lsectorsize);
 					lssflag = 1;
@@ -1850,18 +1849,11 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 					nlflag = 1;
 					break;
 				case N_SIZE:
-					if (!value || *value == '\0')
-						reqval('n', subopts, N_SIZE);
-					if (nsflag)
-						respec('n', subopts, N_SIZE);
 					if (nlflag)
 						conflict('n', subopts, N_LOG,
 							 N_SIZE);
-					dirblocksize = getnum(value, blocksize,
-							      sectorsize, true);
-					if (dirblocksize <= 0 ||
-					    !ispow2(dirblocksize))
-						illegal(value, "n size");
+					dirblocksize = getnum_checked(value,
+								&nopts, N_SIZE);
 					dirblocklog =
 						libxfs_highbit32(dirblocksize);
 					nsflag = 1;
@@ -1977,18 +1969,11 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
-					if (!value || *value == '\0')
-						reqval('s', subopts, S_SECTSIZE);
-					if (ssflag || lssflag)
-						respec('s', subopts, S_SECTSIZE);
 					if (slflag || lslflag)
 						conflict('s', subopts, S_SECTLOG,
 							 S_SECTSIZE);
-					sectorsize = getnum(value, blocksize,
-							    sectorsize, true);
-					if (sectorsize <= 0 ||
-					    !ispow2(sectorsize))
-						illegal(value, "s sectsize");
+					sectorsize = getnum_checked(value,
+							&sopts, S_SECTSIZE);
 					lsectorsize = sectorsize;
 					sectorlog =
 						libxfs_highbit32(sectorsize);
@@ -2197,9 +2182,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (dsize) {
 		__uint64_t dbytes;
 
-		dbytes = getnum(dsize, blocksize, sectorsize, true);
-		if ((__int64_t)dbytes < 0)
-			illegal(dsize, "d size");
+		dbytes = getnum_checked(dsize, &dopts, D_SIZE);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2236,9 +2219,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (logsize) {
 		__uint64_t logbytes;
 
-		logbytes = getnum(logsize, blocksize, sectorsize, true);
-		if ((__int64_t)logbytes < 0)
-			illegal(logsize, "l size");
+		logbytes = getnum_checked(logsize, &lopts, L_SIZE);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2260,9 +2241,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (rtsize) {
 		__uint64_t rtbytes;
 
-		rtbytes = getnum(rtsize, blocksize, sectorsize, true);
-		if ((__int64_t)rtbytes < 0)
-			illegal(rtsize, "r size");
+		rtbytes = getnum_checked(rtsize, &ropts, R_SIZE);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2282,27 +2261,13 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (rtextsize) {
 		__uint64_t rtextbytes;
 
-		rtextbytes = getnum(rtextsize, blocksize, sectorsize, true);
-		if ((__int64_t)rtextbytes < 0)
-			illegal(rtsize, "r extsize");
+		rtextbytes = getnum_checked(rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
 				(long long)rtextbytes, blocksize);
 			usage();
 		}
-		if (rtextbytes > XFS_MAX_RTEXTSIZE) {
-			fprintf(stderr,
-				_("rt extent size %s too large, maximum %d\n"),
-				rtextsize, XFS_MAX_RTEXTSIZE);
-			usage();
-		}
-		if (rtextbytes < XFS_MIN_RTEXTSIZE) {
-			fprintf(stderr,
-				_("rt extent size %s too small, minimum %d\n"),
-				rtextsize, XFS_MIN_RTEXTSIZE);
-			usage();
-		}
 		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
 	} else {
 		/*
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
