Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 393CF7CB9
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E99E230404E
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mCZF73mgHm7o64Mm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 40FF6C08E29C
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:05 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0O007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:04 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 11/19] mkfs: table based parsing for converted parameters
Date: Thu, 21 Apr 2016 11:39:45 +0200
Message-Id: <1461231593-31294-12-git-send-email-jtulak@redhat.com>
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
Signed-off-by: Jan Tulak <jtulak@redhat.com>

Was reviewed, but one small change added...
 Reviewed-by: Eric Sandeen <sandeen@redhat.com>

---
CHANGES:
* L_SU minval changed from XLOG_MIN_RECORD_BSIZE to 0 to comply with
  tests generic/054 and 055 - is this a valid solution, or the tests
  should be fixed?
---
 mkfs/xfs_mkfs.c | 182 ++++++++++++++++++++++++--------------------------------
 1 file changed, 78 insertions(+), 104 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e45b72b..8551b09 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -48,6 +48,13 @@ static int  ispow2(unsigned int i);
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
 /*
@@ -76,6 +83,15 @@ static long long cvtnum(unsigned int blocksize,
  *     Do not set this flag when definning a subopt. It is used to remeber that
  *     this subopt was already seen, for example for conflicts detection.
  *
+ *   convert OPTIONAL
+ *     A flag signalling whether the user-given value can use suffixes.
+ *     If you want to allow the use of user-friendly values like 13k, 42G,
+ *     set it to true.
+ *
+ *   is_power_2 OPTIONAL
+ *     An optional flag for subopts where the given value has to be a power
+ *     of two.
+ *
  *   minval, maxval OPTIONAL
  *     These options are used for automatic range check and they have to be
  *     always used together in pair. If you don't want to limit the max value,
@@ -103,6 +119,8 @@ struct opt_params {
 	struct subopt_param {
 		int		index;
 		bool		seen;
+		bool		convert;
+		bool		is_power_2;
 		long long	minval;
 		long long	maxval;
 		long long	defaultval;
@@ -125,6 +143,8 @@ struct opt_params bopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = B_SIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_BLOCKSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -182,6 +202,9 @@ struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SIZE,
+		  .convert = true,
+		  .minval = XFS_AG_MIN_BYTES,
+		  .maxval = LLONG_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SUNIT,
@@ -195,11 +218,15 @@ struct opt_params dopts = {
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
@@ -213,6 +240,8 @@ struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SECTSIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -279,11 +308,13 @@ struct opt_params iopts = {
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
@@ -347,6 +378,9 @@ struct opt_params lopts = {
 		  .defaultval = 1,
 		},
 		{ .index = L_SIZE,
+		  .convert = true,
+		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
+		  .maxval = XFS_MAX_LOG_BYTES,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_VERSION,
@@ -360,6 +394,9 @@ struct opt_params lopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SU,
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_DEV,
@@ -371,6 +408,8 @@ struct opt_params lopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SECTSIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -411,6 +450,8 @@ struct opt_params nopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_SIZE,
+		  .convert = true,
+		  .is_power_2 = true,
 		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -447,9 +488,15 @@ struct opt_params ropts = {
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
@@ -496,11 +543,15 @@ struct opt_params sopts = {
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
@@ -1333,15 +1384,15 @@ sb_set_features(
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
@@ -1363,7 +1414,7 @@ illegal_option(
 	usage();
 }
 
-static int
+static long long
 getnum_checked(
 	const char		*str,
 	struct opt_params	*opts,
@@ -1398,9 +1449,11 @@ getnum_checked(
 		exit(1);
 	}
 
-	c = getnum(str, 0, 0, false);
+	c = getnum(str, blocksize, sectorsize, sp->convert);
 	if (c < sp->minval || c > sp->maxval)
 		illegal_option(str, opts, index);
+	if (sp->is_power_2 && !ispow2(c))
+		illegal_option(str, opts, index);
 	return c;
 }
 
@@ -1418,7 +1471,6 @@ main(
 	struct xfs_btree_block	*block;
 	int			blflag;
 	int			blocklog;
-	unsigned int		blocksize;
 	int			bsflag;
 	int			bsize;
 	xfs_buf_t		*buf;
@@ -1489,7 +1541,6 @@ main(
 	char			*rtsize;
 	xfs_sb_t		*sbp;
 	int			sectorlog;
-	unsigned int		sectorsize;
 	__uint64_t		sector_mask;
 	int			slflag;
 	int			ssflag;
@@ -1569,18 +1620,11 @@ main(
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
@@ -1603,14 +1647,8 @@ main(
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
@@ -1648,17 +1686,11 @@ main(
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
@@ -1695,18 +1727,11 @@ main(
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
@@ -1773,8 +1798,6 @@ main(
 							 I_PERBLOCK);
 					inopblock = getnum_checked(value, &iopts,
 								   I_PERBLOCK);
-					if (!ispow2(inopblock))
-						illegal(value, "i perblock");
 					ipflag = 1;
 					break;
 				case I_SIZE:
@@ -1786,8 +1809,6 @@ main(
 							 I_SIZE);
 					isize = getnum_checked(value, &iopts,
 							       I_SIZE);
-					if (!ispow2(isize))
-						illegal(value, "i size");
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
 					break;
@@ -1846,14 +1867,8 @@ main(
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
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
@@ -1900,18 +1915,11 @@ main(
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
@@ -1979,18 +1987,11 @@ main(
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
@@ -2101,18 +2102,11 @@ main(
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
@@ -2341,9 +2335,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (dsize) {
 		__uint64_t dbytes;
 
-		dbytes = getnum(dsize, blocksize, sectorsize, true);
-		if ((__int64_t)dbytes < 0)
-			illegal(dsize, "d size");
+		dbytes = getnum_checked(dsize, &dopts, D_SIZE);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2380,9 +2372,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (logsize) {
 		__uint64_t logbytes;
 
-		logbytes = getnum(logsize, blocksize, sectorsize, true);
-		if ((__int64_t)logbytes < 0)
-			illegal(logsize, "l size");
+		logbytes = getnum_checked(logsize, &lopts, L_SIZE);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2404,9 +2394,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (rtsize) {
 		__uint64_t rtbytes;
 
-		rtbytes = getnum(rtsize, blocksize, sectorsize, true);
-		if ((__int64_t)rtbytes < 0)
-			illegal(rtsize, "r size");
+		rtbytes = getnum_checked(rtsize, &ropts, R_SIZE);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2426,27 +2414,13 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
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
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
