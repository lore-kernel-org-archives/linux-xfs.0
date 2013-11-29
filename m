Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A99367F5D
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 284B7AC002
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	n3OID3HtGm8LdZgq for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:04 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Io-TI
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:53 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002et-SO
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/15] mkfs: merge getnum
Date: Fri, 29 Nov 2013 12:43:47 +1100
Message-Id: <1385689430-10103-13-git-send-email-david@fromorbit.com>
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

getnum() is now only called by getnum_checked(). Move the two
together into a single getnum() function and change all the callers
back to getnum().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_mkfs.h |   4 +-
 mkfs/proto.c       |  20 ++++++
 mkfs/xfs_mkfs.c    | 202 ++++++++++++++++++++++++-----------------------------
 3 files changed, 113 insertions(+), 113 deletions(-)

diff --git a/include/xfs_mkfs.h b/include/xfs_mkfs.h
index f5639b0..a4312e1 100644
--- a/include/xfs_mkfs.h
+++ b/include/xfs_mkfs.h
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
index da5115b..0477d65 100644
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
index e7bee06..827c300 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -49,9 +49,6 @@ static void respec(char opt, char *tab[], int idx);
 static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
 
-static long long cvtnum(unsigned int blocksize,
-			unsigned int sectorsize, const char *s);
-
 /*
  * The configured block and sector sizes are defined as global variables so
  * that they don't need to be passed to functions that require them.
@@ -1269,27 +1266,6 @@ sb_set_features(
 	sbp->sb_features_log_incompat = 0;
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
@@ -1302,8 +1278,8 @@ illegal_option(
 	usage();
 }
 
-static int
-getnum_checked(
+static long long
+getnum(
 	const char		*str,
 	struct opt_params	*opts,
 	int			index)
@@ -1323,13 +1299,32 @@ getnum_checked(
 		respec(opts->name, (char **)opts->subopts, index);
 	sp->seen = true;
 
+	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
 			reqval(opts->name, (char **)opts->subopts, index);
 		return sp->defaultval;
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
+		char		*sp;
+
+		c = strtoll(str, &sp, 0);
+		if (c == 0 && sp == str)
+			illegal_option(str, opts, index);
+		if (*sp != '\0')
+			illegal_option(str, opts, index);
+	}
+
+	/* Validity check the result. */
 	if (c < sp->minval || c > sp->maxval)
 		illegal_option(str, opts, index);
 	if (sp->is_power_2 && !ispow2(c))
@@ -1490,8 +1485,7 @@ main(
 					if (bsflag)
 						conflict('b', subopts, B_SIZE,
 							 B_LOG);
-					blocklog = getnum_checked(value, &bopts,
-								  B_LOG);
+					blocklog = getnum(value, &bopts, B_LOG);
 					blocksize = 1 << blocklog;
 					blflag = 1;
 					break;
@@ -1499,8 +1493,8 @@ main(
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
@@ -1518,18 +1512,17 @@ main(
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
@@ -1551,29 +1544,26 @@ main(
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
 					if (dsu)
@@ -1594,8 +1584,8 @@ main(
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
@@ -1603,28 +1593,27 @@ main(
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
@@ -1642,8 +1631,8 @@ main(
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
@@ -1652,14 +1641,13 @@ main(
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
@@ -1669,8 +1657,8 @@ main(
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
@@ -1680,20 +1668,18 @@ main(
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
 					sb_feat.attr_version =
-						getnum_checked(value, &iopts,
-							       I_ATTR);
+						getnum(value, &iopts, I_ATTR);
 					break;
 				case I_PROJID32BIT:
 					sb_feat.projid16bit =
-						!getnum_checked(value, &iopts,
-								I_PROJID32BIT);
+						!getnum(value, &iopts,
+							I_PROJID32BIT);
 					break;
 				default:
 					unknown('i', value);
@@ -1711,16 +1697,15 @@ main(
 				case L_AGNUM:
 					if (ldflag)
 						conflict('l', subopts, L_AGNUM, L_DEV);
-					logagno = getnum_checked(value, &lopts,
-								 L_AGNUM);
+					logagno = getnum(value, &lopts, L_AGNUM);
 					laflag = 1;
 					break;
 				case L_FILE:
 					if (loginternal)
 						conflict('l', subopts, L_INTERNAL,
 							 L_FILE);
-					xi.lisfile = getnum_checked(value,
-								&lopts, L_FILE);
+					xi.lisfile = getnum(value, &lopts,
+							    L_FILE);
 					if (xi.lisfile)
 						xi.lcreat = 1;
 					break;
@@ -1731,17 +1716,15 @@ main(
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
 					break;
 				case L_SUNIT:
-					lsunit = getnum_checked(value, &lopts,
-								 L_SUNIT);
+					lsunit = getnum(value, &lopts, L_SUNIT);
 					break;
 				case L_NAME:
 				case L_DEV:
@@ -1760,8 +1743,7 @@ main(
 					break;
 				case L_VERSION:
 					sb_feat.log_version =
-						getnum_checked(value, &lopts,
-							       L_VERSION);
+						getnum(value, &lopts, L_VERSION);
 					lvflag = 1;
 					break;
 				case L_SIZE:
@@ -1776,8 +1758,8 @@ main(
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
@@ -1785,15 +1767,15 @@ main(
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
@@ -1816,8 +1798,7 @@ main(
 						  &value)) {
 				case M_CRC:
 					sb_feat.crcs_enabled =
-						getnum_checked(value, &mopts,
-							       M_CRC);
+						getnum(value, &mopts, M_CRC);
 					if (sb_feat.crcs_enabled && nftype) {
 						fprintf(stderr,
 _("cannot specify both -m crc=1 and -n ftype\n"));
@@ -1843,8 +1824,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
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
@@ -1852,8 +1833,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
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
@@ -1868,9 +1849,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
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
@@ -1880,8 +1860,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 _("cannot specify both -m crc=1 and -n ftype\n"));
 						usage();
 					}
-					sb_feat.dirftype = getnum_checked(value,
-								&nopts, N_FTYPE);
+					sb_feat.dirftype = getnum(value, &nopts,
+								  N_FTYPE);
 					nftype = 1;
 					break;
 				default:
@@ -1919,8 +1899,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
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
@@ -1960,8 +1940,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
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
@@ -1972,8 +1952,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
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
@@ -2182,7 +2162,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (dsize) {
 		__uint64_t dbytes;
 
-		dbytes = getnum_checked(dsize, &dopts, D_SIZE);
+		dbytes = getnum(dsize, &dopts, D_SIZE);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2219,7 +2199,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (logsize) {
 		__uint64_t logbytes;
 
-		logbytes = getnum_checked(logsize, &lopts, L_SIZE);
+		logbytes = getnum(logsize, &lopts, L_SIZE);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2241,7 +2221,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (rtsize) {
 		__uint64_t rtbytes;
 
-		rtbytes = getnum_checked(rtsize, &ropts, R_SIZE);
+		rtbytes = getnum(rtsize, &ropts, R_SIZE);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2261,7 +2241,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (rtextsize) {
 		__uint64_t rtextbytes;
 
-		rtextbytes = getnum_checked(rtextsize, &ropts, R_EXTSIZE);
+		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
@@ -3314,8 +3294,8 @@ unknown(
 
 long long
 cvtnum(
-	unsigned int	blocksize,
-	unsigned int	sectorsize,
+	unsigned int	blksize,
+	unsigned int	sectsize,
 	const char	*s)
 {
 	long long	i;
@@ -3328,9 +3308,9 @@ cvtnum(
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
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
