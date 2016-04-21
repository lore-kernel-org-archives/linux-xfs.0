Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41BA57CAE
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8EC0AC002
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id L3WyR3CODu8OAWzH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:06 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 14F4B64067
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:06 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0P007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:05 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 12/19] mkfs: merge getnum
Date: Thu, 21 Apr 2016 11:39:46 +0200
Message-Id: <1461231593-31294-13-git-send-email-jtulak@redhat.com>
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

getnum() is now only called by getnum_checked(). Move the two
together into a single getnum() function and change all the callers
back to getnum().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xfs_multidisk.h |   4 +-
 mkfs/proto.c            |  20 +++++
 mkfs/xfs_mkfs.c         | 213 ++++++++++++++++++++++--------------------------
 3 files changed, 119 insertions(+), 118 deletions(-)

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index ecc8f0a..fe3e98f 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -57,8 +57,8 @@
 #define XFS_NOMULTIDISK_AGLOG		2	/* 4 AGs */
 #define XFS_MULTIDISK_AGCOUNT		(1 << XFS_MULTIDISK_AGLOG)
 
-extern long long getnum(const char *str, unsigned int blocksize,
-			unsigned int sectorsize, bool convert);
+extern long long cvtnum(unsigned int blksize, unsigned int sectsize,
+			const char *str);
 
 /* proto.c */
 extern char *setup_proto (char *fname);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 19943cb..09a9439 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -43,6 +43,26 @@ static long filesize(int fd);
 	((uint)(MKFS_BLOCKRES_INODE + XFS_DA_NODE_MAXDEPTH + \
 	(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1) + (rb)))
 
+static long long
+getnum(
+	const char	*str,
+	unsigned int	blksize,
+	unsigned int	sectsize,
+	bool		convert)
+{
+	long long	i;
+	char		*sp;
+
+	if (convert)
+		return cvtnum(blksize, sectsize, str);
+
+	i = strtoll(str, &sp, 0);
+	if (i == 0 && sp == str)
+		return -1LL;
+	if (*sp != '\0')
+		return -1LL; /* trailing garbage */
+	return i;
+}
 
 char *
 setup_proto(
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8551b09..a45dc7f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -45,9 +45,6 @@ static void respec(char opt, char *tab[], int idx);
 static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
 
-static long long cvtnum(unsigned int blocksize,
-			unsigned int sectorsize, const char *s);
-
 /*
  * The configured block and sector sizes are defined as global variables so
  * that they don't need to be passed to functions that require them.
@@ -1381,27 +1378,6 @@ sb_set_features(
 
 }
 
-long long
-getnum(
-	const char	*str,
-	unsigned int	blksize,
-	unsigned int	sectsize,
-	bool		convert)
-{
-	long long	i;
-	char		*sp;
-
-	if (convert)
-		return cvtnum(blksize, sectsize, str);
-
-	i = strtoll(str, &sp, 0);
-	if (i == 0 && sp == str)
-		return -1LL;
-	if (*sp != '\0')
-		return -1LL; /* trailing garbage */
-	return i;
-}
-
 static __attribute__((noreturn)) void
 illegal_option(
 	const char	*value,
@@ -1415,7 +1391,7 @@ illegal_option(
 }
 
 static long long
-getnum_checked(
+getnum(
 	const char		*str,
 	struct opt_params	*opts,
 	int			index)
@@ -1435,6 +1411,7 @@ getnum_checked(
 		respec(opts->name, (char **)opts->subopts, index);
 	sp->seen = true;
 
+	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
 			reqval(opts->name, (char **)opts->subopts, index);
@@ -1449,7 +1426,25 @@ getnum_checked(
 		exit(1);
 	}
 
-	c = getnum(str, blocksize, sectorsize, sp->convert);
+	/*
+	 * Some values are pure numbers, others can have suffixes that define
+	 * the units of the number. Those get passed to cvtnum(), otherwise we
+	 * convert it ourselves to guarantee there is no trailing garbage in the
+	 * number.
+	 */
+	if (sp->convert)
+		c = cvtnum(blocksize, sectorsize, str);
+	else {
+		char		*str_end;
+
+		c = strtoll(str, &str_end, 0);
+		if (c == 0 && str_end == str)
+			illegal_option(str, opts, index);
+		if (*str_end != '\0')
+			illegal_option(str, opts, index);
+	}
+
+	/* Validity check the result. */
 	if (c < sp->minval || c > sp->maxval)
 		illegal_option(str, opts, index);
 	if (sp->is_power_2 && !ispow2(c))
@@ -1614,8 +1609,7 @@ main(
 					if (bsflag)
 						conflict('b', subopts, B_SIZE,
 							 B_LOG);
-					blocklog = getnum_checked(value, &bopts,
-								  B_LOG);
+					blocklog = getnum(value, &bopts, B_LOG);
 					blocksize = 1 << blocklog;
 					blflag = 1;
 					break;
@@ -1623,8 +1617,8 @@ main(
 					if (blflag)
 						conflict('b', subopts, B_LOG,
 							 B_SIZE);
-					blocksize = getnum_checked(value, &bopts,
-								  B_SIZE);
+					blocksize = getnum(value, &bopts,
+							   B_SIZE);
 					blocklog = libxfs_highbit32(blocksize);
 					bsflag = 1;
 					break;
@@ -1642,18 +1636,17 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case D_AGCOUNT:
-					agcount = getnum_checked(value, &dopts,
-								 D_AGCOUNT);
+					agcount = getnum(value, &dopts,
+							 D_AGCOUNT);
 					daflag = 1;
 					break;
 				case D_AGSIZE:
-					agsize = getnum_checked(value, &dopts,
-								 D_AGSIZE);
+					agsize = getnum(value, &dopts, D_AGSIZE);
 					dasize = 1;
 					break;
 				case D_FILE:
-					xi.disfile = getnum_checked(value,
-								&dopts, D_FILE);
+					xi.disfile = getnum(value, &dopts,
+							    D_FILE);
 					if (xi.disfile && !Nflag)
 						xi.dcreat = 1;
 					break;
@@ -1675,33 +1668,30 @@ main(
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SUNIT);
-					dsunit = getnum_checked(value, &dopts,
-								 D_SUNIT);
+					dsunit = getnum(value, &dopts, D_SUNIT);
 					break;
 				case D_SWIDTH:
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SWIDTH);
-					dswidth = getnum_checked(value, &dopts,
-								 D_SWIDTH);
+					dswidth = getnum(value, &dopts,
+							 D_SWIDTH);
 					break;
 				case D_SU:
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SU);
-					dsu = getnum_checked(value, &dopts,
-								 D_SU);
+					dsu = getnum(value, &dopts, D_SU);
 					break;
 				case D_SW:
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SW);
-					dsw = getnum_checked(value, &dopts,
-								 D_SW);
+					dsw = getnum(value, &dopts, D_SW);
 					break;
 				case D_NOALIGN:
-					nodsflag = getnum_checked(value,
-								&dopts, D_NOALIGN);
+					nodsflag = getnum(value, &dopts,
+							 	D_NOALIGN);
 					if (nodsflag) {
 						if (dsu)
 							conflict('d', subopts, D_SU,
@@ -1721,8 +1711,8 @@ main(
 					if (ssflag)
 						conflict('d', subopts, D_SECTSIZE,
 							 D_SECTLOG);
-					sectorlog = getnum_checked(value, &dopts,
-								   D_SECTLOG);
+					sectorlog = getnum(value, &dopts,
+							   D_SECTLOG);
 					sectorsize = 1 << sectorlog;
 					slflag = 1;
 					break;
@@ -1730,28 +1720,27 @@ main(
 					if (slflag)
 						conflict('d', subopts, D_SECTLOG,
 							 D_SECTSIZE);
-					sectorsize = getnum_checked(value,
-							&dopts, D_SECTSIZE);
+					sectorsize = getnum(value, &dopts,
+							    D_SECTSIZE);
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					ssflag = 1;
 					break;
 				case D_RTINHERIT:
-					c = getnum_checked(value, &dopts,
-							   D_RTINHERIT);
+					c = getnum(value, &dopts, D_RTINHERIT);
 					if (c)
 						fsx.fsx_xflags |=
 							XFS_DIFLAG_RTINHERIT;
 					break;
 				case D_PROJINHERIT:
-					fsx.fsx_projid = getnum_checked(value,
-							&dopts, D_PROJINHERIT);
+					fsx.fsx_projid = getnum(value, &dopts,
+								D_PROJINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_PROJINHERIT;
 					break;
 				case D_EXTSZINHERIT:
-					fsx.fsx_extsize = getnum_checked(value,
-							&dopts, D_EXTSZINHERIT);
+					fsx.fsx_extsize = getnum(value, &dopts,
+								 D_EXTSZINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_EXTSZINHERIT;
 					break;
@@ -1769,8 +1758,8 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case I_ALIGN:
-					sb_feat.inode_align = getnum_checked(
-							value, &iopts, I_ALIGN);
+					sb_feat.inode_align = getnum(value,
+								&iopts, I_ALIGN);
 					break;
 				case I_LOG:
 					if (ipflag)
@@ -1779,14 +1768,13 @@ main(
 					if (isflag)
 						conflict('i', subopts, I_SIZE,
 							 I_LOG);
-					inodelog = getnum_checked(value, &iopts,
-								  I_LOG);
+					inodelog = getnum(value, &iopts, I_LOG);
 					isize = 1 << inodelog;
 					ilflag = 1;
 					break;
 				case I_MAXPCT:
-					imaxpct = getnum_checked(value, &iopts,
-								 I_MAXPCT);
+					imaxpct = getnum(value, &iopts,
+							 I_MAXPCT);
 					imflag = 1;
 					break;
 				case I_PERBLOCK:
@@ -1796,8 +1784,8 @@ main(
 					if (isflag)
 						conflict('i', subopts, I_SIZE,
 							 I_PERBLOCK);
-					inopblock = getnum_checked(value, &iopts,
-								   I_PERBLOCK);
+					inopblock = getnum(value, &iopts,
+							   I_PERBLOCK);
 					ipflag = 1;
 					break;
 				case I_SIZE:
@@ -1807,23 +1795,22 @@ main(
 					if (ipflag)
 						conflict('i', subopts, I_PERBLOCK,
 							 I_SIZE);
-					isize = getnum_checked(value, &iopts,
-							       I_SIZE);
+					isize = getnum(value, &iopts, I_SIZE);
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
 					break;
 				case I_ATTR:
-					sb_feat.attr_version = getnum_checked(
-							value, &iopts, I_ATTR);
+					sb_feat.attr_version =
+						getnum(value, &iopts, I_ATTR);
 					break;
 				case I_PROJID32BIT:
 					sb_feat.projid16bit =
-						!getnum_checked(value, &iopts,
-								I_PROJID32BIT);
+						!getnum(value, &iopts,
+							I_PROJID32BIT);
 					break;
 				case I_SPINODES:
 					sb_feat.spinodes =
-						getnum_checked(value, &iopts,
+						getnum(value, &iopts,
 								I_SPINODES);
 					break;
 				default:
@@ -1842,13 +1829,12 @@ main(
 				case L_AGNUM:
 					if (ldflag)
 						conflict('l', subopts, L_AGNUM, L_DEV);
-					logagno = getnum_checked(value, &lopts,
-								 L_AGNUM);
+					logagno = getnum(value, &lopts, L_AGNUM);
 					laflag = 1;
 					break;
 				case L_FILE:
-					xi.lisfile = getnum_checked(value,
-								&lopts, L_FILE);
+					xi.lisfile = getnum(value, &lopts,
+							    L_FILE);
 					if (xi.lisfile && loginternal)
 						conflict('l', subopts, L_INTERNAL,
 							 L_FILE);
@@ -1862,18 +1848,16 @@ main(
 						conflict('l', subopts, L_FILE,
 							 L_INTERNAL);
 
-					loginternal = getnum_checked(value,
-							&lopts, L_INTERNAL);
+					loginternal = getnum(value, &lopts,
+							     L_INTERNAL);
 					liflag = 1;
 					break;
 				case L_SU:
-					lsu = getnum_checked(value, &lopts,
-								 L_SU);
+					lsu = getnum(value, &lopts, L_SU);
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
-					lsunit = getnum_checked(value, &lopts,
-								 L_SUNIT);
+					lsunit = getnum(value, &lopts, L_SUNIT);
 					lsunitflag = 1;
 					break;
 				case L_NAME:
@@ -1893,8 +1877,7 @@ main(
 					break;
 				case L_VERSION:
 					sb_feat.log_version =
-						getnum_checked(value, &lopts,
-							       L_VERSION);
+						getnum(value, &lopts, L_VERSION);
 					lvflag = 1;
 					break;
 				case L_SIZE:
@@ -1909,8 +1892,8 @@ main(
 					if (lssflag)
 						conflict('l', subopts, L_SECTSIZE,
 							 L_SECTLOG);
-					lsectorlog = getnum_checked(value,
-							&lopts, L_SECTLOG);
+					lsectorlog = getnum(value, &lopts,
+							    L_SECTLOG);
 					lsectorsize = 1 << lsectorlog;
 					lslflag = 1;
 					break;
@@ -1918,15 +1901,15 @@ main(
 					if (lslflag)
 						conflict('l', subopts, L_SECTLOG,
 							 L_SECTSIZE);
-					lsectorsize = getnum_checked(value,
-							&lopts, L_SECTSIZE);
+					lsectorsize = getnum(value, &lopts,
+							     L_SECTSIZE);
 					lsectorlog =
 						libxfs_highbit32(lsectorsize);
 					lssflag = 1;
 					break;
 				case L_LAZYSBCNTR:
 					sb_feat.lazy_sb_counters =
-						getnum_checked(value, &lopts,
+							getnum(value, &lopts,
 							       L_LAZYSBCNTR);
 					break;
 				default:
@@ -1949,13 +1932,12 @@ main(
 						  &value)) {
 				case M_CRC:
 					sb_feat.crcs_enabled =
-						getnum_checked(value, &mopts,
-							       M_CRC);
+						getnum(value, &mopts, M_CRC);
 					if (sb_feat.crcs_enabled)
 						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
-					sb_feat.finobt = getnum_checked(
+					sb_feat.finobt = getnum(
 						value, &mopts, M_FINOBT);
 					break;
 				case M_UUID:
@@ -1981,8 +1963,8 @@ main(
 					if (nsflag)
 						conflict('n', subopts, N_SIZE,
 							 N_LOG);
-					dirblocklog = getnum_checked(value,
-								&nopts, N_LOG);
+					dirblocklog = getnum(value, &nopts,
+							     N_LOG);
 					dirblocksize = 1 << dirblocklog;
 					nlflag = 1;
 					break;
@@ -1990,8 +1972,8 @@ main(
 					if (nlflag)
 						conflict('n', subopts, N_LOG,
 							 N_SIZE);
-					dirblocksize = getnum_checked(value,
-								&nopts, N_SIZE);
+					dirblocksize = getnum(value, &nopts,
+							      N_SIZE);
 					dirblocklog =
 						libxfs_highbit32(dirblocksize);
 					nsflag = 1;
@@ -2006,15 +1988,14 @@ main(
 						sb_feat.nci = true;
 					} else {
 						sb_feat.dir_version =
-							getnum_checked(value,
-								&nopts,
-								N_VERSION);
+							getnum(value, &nopts,
+							       N_VERSION);
 					}
 					nvflag = 1;
 					break;
 				case N_FTYPE:
-					sb_feat.dirftype = getnum_checked(value,
-								&nopts, N_FTYPE);
+					sb_feat.dirftype = getnum(value, &nopts,
+								  N_FTYPE);
 					break;
 				default:
 					unknown('n', value);
@@ -2051,8 +2032,8 @@ main(
 					rtextsize = value;
 					break;
 				case R_FILE:
-					xi.risfile = getnum_checked(value,
-								&ropts, R_FILE);
+					xi.risfile = getnum(value, &ropts,
+							    R_FILE);
 					if (xi.risfile)
 						xi.rcreat = 1;
 					break;
@@ -2072,8 +2053,8 @@ main(
 					rtsize = value;
 					break;
 				case R_NOALIGN:
-					norsflag = getnum_checked(value,
-								&ropts, R_NOALIGN);
+					norsflag = getnum(value, &ropts,
+								R_NOALIGN);
 					break;
 				default:
 					unknown('r', value);
@@ -2093,8 +2074,8 @@ main(
 					if (ssflag || lssflag)
 						conflict('s', subopts,
 							 S_SECTSIZE, S_SECTLOG);
-					sectorlog = getnum_checked(value, &sopts,
-								   S_SECTLOG);
+					sectorlog = getnum(value, &sopts,
+							   S_SECTLOG);
 					lsectorlog = sectorlog;
 					sectorsize = 1 << sectorlog;
 					lsectorsize = sectorsize;
@@ -2105,8 +2086,8 @@ main(
 					if (slflag || lslflag)
 						conflict('s', subopts, S_SECTLOG,
 							 S_SECTSIZE);
-					sectorsize = getnum_checked(value,
-							&sopts, S_SECTSIZE);
+					sectorsize = getnum(value, &sopts,
+							    S_SECTSIZE);
 					lsectorsize = sectorsize;
 					sectorlog =
 						libxfs_highbit32(sectorsize);
@@ -2335,7 +2316,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (dsize) {
 		__uint64_t dbytes;
 
-		dbytes = getnum_checked(dsize, &dopts, D_SIZE);
+		dbytes = getnum(dsize, &dopts, D_SIZE);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2372,7 +2353,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (logsize) {
 		__uint64_t logbytes;
 
-		logbytes = getnum_checked(logsize, &lopts, L_SIZE);
+		logbytes = getnum(logsize, &lopts, L_SIZE);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2394,7 +2375,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (rtsize) {
 		__uint64_t rtbytes;
 
-		rtbytes = getnum_checked(rtsize, &ropts, R_SIZE);
+		rtbytes = getnum(rtsize, &ropts, R_SIZE);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2414,7 +2395,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (rtextsize) {
 		__uint64_t rtextbytes;
 
-		rtextbytes = getnum_checked(rtextsize, &ropts, R_EXTSIZE);
+		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
@@ -3517,8 +3498,8 @@ unknown(
 
 long long
 cvtnum(
-	unsigned int	blocksize,
-	unsigned int	sectorsize,
+	unsigned int	blksize,
+	unsigned int	sectsize,
 	const char	*s)
 {
 	long long	i;
@@ -3531,9 +3512,9 @@ cvtnum(
 		return i;
 
 	if (*sp == 'b' && sp[1] == '\0')
-		return i * blocksize;
+		return i * blksize;
 	if (*sp == 's' && sp[1] == '\0')
-		return i * sectorsize;
+		return i * sectsize;
 
 	if (*sp == 'k' && sp[1] == '\0')
 		return 1024LL * i;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
