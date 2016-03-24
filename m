Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1736F7CA7
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D994AC009
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7U7DFMzFSenBRpGj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:43 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 440B97AEA2
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:42 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbLA009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:41 -0400
From: jtulak@redhat.com
Subject: [PATCH 04/19] mkfs: validate all input values
Date: Thu, 24 Mar 2016 12:15:21 +0100
Message-Id: <1458818136-56043-5-git-send-email-jtulak@redhat.com>
In-Reply-To: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
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

CHANGELOG
o Fix an unsigned < 0 comparison - save getnum result to another variable
  and test it, before converting it to unsigned logagno.

Right now, mkfs does a poor job of input validation of values. Many
parameters do not check for trailing garbage and so will pass
obviously invalid values as OK. Some don't even detect completely
invalid values, leaving it for other checks later on to fail due to
a bad value conversion - these tend to rely on atoi() implicitly
returning a sane value when it is passed garbage, and atoi gives no
guarantee of the return value when passed garbage.

Clean all this up by passing all strings that need to be converted
into values into a common function that is called regardless of
whether unit conversion is needed or not. Further, make sure every
conversion is checked for a valid result, and abort the moment an
invalid value is detected.

Get rid of the silly "isdigits(), cvtnum()" calls which don't use
any of the conversion capabilities of cvtnum() because we've already
ensured that there are no conversion units in the string via the
isdigits() call. These can simply be replaced by a standard
strtoll() call followed by checking for no trailing bytes.

Finally, the block size of the filesystem is not known until all
the options have been parsed and we can determine if the default is
to be used. This means any parameter that relies on using conversion
from filesystem block size (the "NNNb" format) requires the block
size to first be specified on the command line so it is known.

Similarly, we make the same rule for specifying counts in sectors.
This is a change from the existing behaviour that assumes sectors
are 512 bytes unless otherwise changed on the command line. This,
unfortunately, leads to complete silliness where you can specify the
sector size as a count of sectors. It also means that you can do
some conversions with 512 byte sector sizes, and others with
whatever was specified on the command line, meaning the mkfs
behaviour changes depending in where in the command line the sector
size is changed....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/xfs_multidisk.h |   7 +-
 man/man8/mkfs.xfs.8     |  26 +++++-
 mkfs/proto.c            |  36 ++++----
 mkfs/xfs_mkfs.c         | 217 +++++++++++++++++++++++++-----------------------
 4 files changed, 155 insertions(+), 131 deletions(-)

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index 64d80e1..af35100 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -56,11 +56,8 @@
 #define XFS_NOMULTIDISK_AGLOG		2	/* 4 AGs */
 #define XFS_MULTIDISK_AGCOUNT		(1 << XFS_MULTIDISK_AGLOG)
 
-
-/* xfs_mkfs.c */
-extern int isdigits (char *str);
-extern long long cvtnum (unsigned int blocksize,
-			 unsigned int sectorsize, char *s);
+extern long long getnum(const char *str, unsigned int blocksize,
+			unsigned int sectorsize, bool convert);
 
 /* proto.c */
 extern char *setup_proto (char *fname);
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 980c7bc..8b068ef 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -64,11 +64,11 @@ SCSI disk, use:
 .PP
 The metadata log can be placed on another device to reduce the number
 of disk seeks.  To create a filesystem on the first partition on the
-first SCSI disk with a 10000 block log located on the first partition
+first SCSI disk with a 10MiB log located on the first partition
 on the second SCSI disk, use:
 .RS
 .HP
-.B mkfs.xfs\ \-l\ logdev=/dev/sdb1,size=10000b /dev/sda1
+.B mkfs.xfs\ \-l\ logdev=/dev/sdb1,size=10m /dev/sda1
 .RE
 .PP
 Each of the
@@ -78,9 +78,9 @@ suboptions if multiple suboptions apply to the same option.
 Equivalently, each main option can be given multiple times with
 different suboptions.
 For example,
-.B \-l internal,size=10000b
+.B \-l internal,size=10m
 and
-.B \-l internal \-l size=10000b
+.B \-l internal \-l size=10m
 are equivalent.
 .PP
 In the descriptions below, sizes are given in sectors, bytes, blocks,
@@ -109,6 +109,15 @@ option below).
 .HP
 .BR e "\ \-\ multiply by one exabyte (1,048,576 terabytes)."
 .PD
+.RE
+.PP
+When specifying parameters in units of sectors or filesystem blocks, the
+.B \-s
+option or the
+.B \-b
+option first needs to be added to the command line.
+Failure to specify the size of the units will result in illegal value errors
+when parameters are quantified in those units.
 .SH OPTIONS
 .TP
 .BI \-b " block_size_options"
@@ -126,6 +135,11 @@ or in bytes with
 .BR size= .
 The default value is 4096 bytes (4 KiB), the minimum is 512, and the
 maximum is 65536 (64 KiB).
+.IP
+To specify any options on the command line in units of filesystem blocks, this
+option must be specified first so that the filesystem block size is
+applied consistently to all options.
+.IP
 Although
 .B mkfs.xfs
 will accept any of these values and create a valid filesystem,
@@ -811,6 +825,10 @@ is 512 bytes. The minimum value for sector size is
 .I sector_size
 must be a power of 2 size and cannot be made larger than the
 filesystem block size.
+.IP
+To specify any options on the command line in units of sectors, this
+option must be specified first so that the sector size is
+applied consistently to all options.
 .TP
 .BI \-L " label"
 Set the filesystem
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 50d5e94..5930af8 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -23,7 +23,6 @@
 /*
  * Prototypes for internal functions.
  */
-static long getnum(char **pp);
 static char *getstr(char **pp);
 static void fail(char *msg, int i);
 static void getres(xfs_trans_t *tp, uint blocks);
@@ -78,8 +77,8 @@ setup_proto(
 	 * Skip past the stuff there for compatibility, a string and 2 numbers.
 	 */
 	(void)getstr(&buf);	/* boot image name */
-	(void)getnum(&buf);	/* block count */
-	(void)getnum(&buf);	/* inode count */
+	(void)getnum(getstr(&buf), 0, 0, false);	/* block count */
+	(void)getnum(getstr(&buf), 0, 0, false);	/* inode count */
 	close(fd);
 	return buf;
 
@@ -90,16 +89,6 @@ out_fail:
 	exit(1);
 }
 
-static long
-getnum(
-	char	**pp)
-{
-	char	*s;
-
-	s = getstr(pp);
-	return atol(s);
-}
-
 static void
 fail(
 	char	*msg,
@@ -440,8 +429,8 @@ parseproto(
 		val = val * 8 + mstr[i] - '0';
 	}
 	mode |= val;
-	creds.cr_uid = (int)getnum(pp);
-	creds.cr_gid = (int)getnum(pp);
+	creds.cr_uid = (int)getnum(getstr(pp), 0, 0, false);
+	creds.cr_gid = (int)getnum(getstr(pp), 0, 0, false);
 	xname.name = (unsigned char *)name;
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
@@ -466,7 +455,14 @@ parseproto(
 
 	case IF_RESERVED:			/* pre-allocated space only */
 		value = getstr(pp);
-		llen = cvtnum(mp->m_sb.sb_blocksize, mp->m_sb.sb_sectsize, value);
+		llen = getnum(value, mp->m_sb.sb_blocksize,
+			      mp->m_sb.sb_sectsize, true);
+		if (llen < 0) {
+			fprintf(stderr,
+				_("%s: Bad value %s for proto file %s\n"),
+				progname, value, name);
+			exit(1);
+		}
 		getres(tp, XFS_B_TO_FSB(mp, llen));
 
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
@@ -490,8 +486,8 @@ parseproto(
 
 	case IF_BLOCK:
 		getres(tp, 0);
-		majdev = (int)getnum(pp);
-		mindev = (int)getnum(pp);
+		majdev = getnum(getstr(pp), 0, 0, false);
+		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error) {
@@ -505,8 +501,8 @@ parseproto(
 
 	case IF_CHAR:
 		getres(tp, 0);
-		majdev = (int)getnum(pp);
-		mindev = (int)getnum(pp);
+		majdev = getnum(getstr(pp), 0, 0, false);
+		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 36bcb9f..4811d77 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -45,6 +45,9 @@ static void respec(char opt, char *tab[], int idx);
 static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
 
+static long long cvtnum(unsigned int blocksize,
+			unsigned int sectorsize, const char *s);
+
 /*
  * option tables for getsubopt calls
  */
@@ -982,6 +985,28 @@ sb_set_features(
 
 }
 
+long long
+getnum(
+	const char	*str,
+	unsigned int	blocksize,
+	unsigned int	sectorsize,
+	bool		convert)
+{
+	long long	i;
+	char		*sp;
+
+	if (convert)
+		return cvtnum(blocksize, sectorsize, str);
+
+	i = strtoll(str, &sp, 0);
+	if (i == 0 && sp == str)
+		return -1LL;
+	if (*sp != '\0')
+		return -1LL; /* trailing garbage */
+	return i;
+}
+
+
 int
 main(
 	int			argc,
@@ -1101,8 +1126,8 @@ main(
 
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
-	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
-	sectorsize = lsectorsize = XFS_MIN_SECTORSIZE;
+	sectorlog = lsectorlog = 0;
+	sectorsize = lsectorsize = 0;
 	agsize = daflag = dasize = dblocks = 0;
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
@@ -1146,7 +1171,7 @@ main(
 					if (bsflag)
 						conflict('b', bopts, B_SIZE,
 							 B_LOG);
-					blocklog = atoi(value);
+					blocklog = getnum(value, 0, 0, false);
 					if (blocklog <= 0)
 						illegal(value, "b log");
 					blocksize = 1 << blocklog;
@@ -1160,8 +1185,8 @@ main(
 					if (blflag)
 						conflict('b', bopts, B_LOG,
 							 B_SIZE);
-					blocksize = cvtnum(
-						blocksize, sectorsize, value);
+					blocksize = getnum(value, blocksize,
+							sectorsize, true);
 					if (blocksize <= 0 ||
 					    !ispow2(blocksize))
 						illegal(value, "b size");
@@ -1184,8 +1209,7 @@ main(
 						reqval('d', dopts, D_AGCOUNT);
 					if (daflag)
 						respec('d', dopts, D_AGCOUNT);
-					agcount = (__uint64_t)
-						strtoul(value, NULL, 10);
+					agcount = getnum(value, 0, 0, false);
 					if ((__int64_t)agcount <= 0)
 						illegal(value, "d agcount");
 					daflag = 1;
@@ -1195,14 +1219,16 @@ main(
 						reqval('d', dopts, D_AGSIZE);
 					if (dasize)
 						respec('d', dopts, D_AGSIZE);
-					agsize = cvtnum(
-						blocksize, sectorsize, value);
+					agsize = getnum(value, blocksize,
+							sectorsize, true);
+					if ((__int64_t)agsize <= 0)
+						illegal(value, "d agsize");
 					dasize = 1;
 					break;
 				case D_FILE:
 					if (!value || *value == '\0')
 						value = "1";
-					xi.disfile = atoi(value);
+					xi.disfile = getnum(value, 0, 0, false);
 					if (xi.disfile < 0 || xi.disfile > 1)
 						illegal(value, "d file");
 					if (xi.disfile && !Nflag)
@@ -1230,13 +1256,9 @@ main(
 					if (nodsflag)
 						conflict('d', dopts, D_NOALIGN,
 							 D_SUNIT);
-					if (!isdigits(value)) {
-						fprintf(stderr,
-	_("%s: Specify data sunit in 512-byte blocks, no unit suffix\n"),
-							progname);
-						exit(1);
-					}
-					dsunit = cvtnum(0, 0, value);
+					dsunit = getnum(value, 0, 0, false);
+					if (dsunit < 0)
+						illegal(value, "d sunit");
 					break;
 				case D_SWIDTH:
 					if (!value || *value == '\0')
@@ -1246,13 +1268,9 @@ main(
 					if (nodsflag)
 						conflict('d', dopts, D_NOALIGN,
 							 D_SWIDTH);
-					if (!isdigits(value)) {
-						fprintf(stderr,
-	_("%s: Specify data swidth in 512-byte blocks, no unit suffix\n"),
-							progname);
-						exit(1);
-					}
-					dswidth = cvtnum(0, 0, value);
+					dswidth = getnum(value, 0, 0, false);
+					if (dswidth < 0)
+						illegal(value, "d swidth");
 					break;
 				case D_SU:
 					if (!value || *value == '\0')
@@ -1262,8 +1280,10 @@ main(
 					if (nodsflag)
 						conflict('d', dopts, D_NOALIGN,
 							 D_SU);
-					dsu = cvtnum(
-						blocksize, sectorsize, value);
+					dsu = getnum(value, blocksize,
+						     sectorsize, true);
+					if (dsu < 0)
+						illegal(value, "d su");
 					break;
 				case D_SW:
 					if (!value || *value == '\0')
@@ -1273,13 +1293,9 @@ main(
 					if (nodsflag)
 						conflict('d', dopts, D_NOALIGN,
 							 D_SW);
-					if (!isdigits(value)) {
-						fprintf(stderr,
-		_("%s: Specify data sw as multiple of su, no unit suffix\n"),
-							progname);
-						exit(1);
-					}
-					dsw = cvtnum(0, 0, value);
+					dsw = getnum(value, 0, 0, false);
+					if (dsw < 0)
+						illegal(value, "d sw");
 					break;
 				case D_NOALIGN:
 					if (dsu)
@@ -1304,7 +1320,7 @@ main(
 					if (ssflag)
 						conflict('d', dopts, D_SECTSIZE,
 							 D_SECTLOG);
-					sectorlog = atoi(value);
+					sectorlog = getnum(value, 0, 0, false);
 					if (sectorlog <= 0)
 						illegal(value, "d sectlog");
 					sectorsize = 1 << sectorlog;
@@ -1318,8 +1334,8 @@ main(
 					if (slflag)
 						conflict('d', dopts, D_SECTLOG,
 							 D_SECTSIZE);
-					sectorsize = cvtnum(
-						blocksize, sectorsize, value);
+					sectorsize = getnum(value, blocksize,
+							    sectorsize, true);
 					if (sectorsize <= 0 ||
 					    !ispow2(sectorsize))
 						illegal(value, "d sectsize");
@@ -1359,7 +1375,7 @@ main(
 				case I_ALIGN:
 					if (!value || *value == '\0')
 						reqval('i', iopts, I_ALIGN);
-					c = atoi(value);
+					c = getnum(value, 0, 0, false);
 					if (c < 0 || c > 1)
 						illegal(value, "i align");
 					sb_feat.inode_align = c ? true : false;
@@ -1375,7 +1391,7 @@ main(
 					if (isflag)
 						conflict('i', iopts, I_SIZE,
 							 I_LOG);
-					inodelog = atoi(value);
+					inodelog = getnum(value, 0, 0, false);
 					if (inodelog <= 0)
 						illegal(value, "i log");
 					isize = 1 << inodelog;
@@ -1386,7 +1402,7 @@ main(
 						reqval('i', iopts, I_MAXPCT);
 					if (imflag)
 						respec('i', iopts, I_MAXPCT);
-					imaxpct = atoi(value);
+					imaxpct = getnum(value, 0, 0, false);
 					if (imaxpct < 0 || imaxpct > 100)
 						illegal(value, "i maxpct");
 					imflag = 1;
@@ -1402,7 +1418,7 @@ main(
 					if (isflag)
 						conflict('i', iopts, I_SIZE,
 							 I_PERBLOCK);
-					inopblock = atoi(value);
+					inopblock = getnum(value, 0, 0, false);
 					if (inopblock <
 						XFS_MIN_INODE_PERBLOCK ||
 					    !ispow2(inopblock))
@@ -1420,7 +1436,7 @@ main(
 							 I_SIZE);
 					if (isflag)
 						respec('i', iopts, I_SIZE);
-					isize = cvtnum(0, 0, value);
+					isize = getnum(value, 0, 0, true);
 					if (isize <= 0 || !ispow2(isize))
 						illegal(value, "i size");
 					inodelog = libxfs_highbit32(isize);
@@ -1429,7 +1445,7 @@ main(
 				case I_ATTR:
 					if (!value || *value == '\0')
 						reqval('i', iopts, I_ATTR);
-					c = atoi(value);
+					c = getnum(value, 0, 0, false);
 					if (c < 0 || c > 2)
 						illegal(value, "i attr");
 					sb_feat.attr_version = c;
@@ -1437,7 +1453,7 @@ main(
 				case I_PROJID32BIT:
 					if (!value || *value == '\0')
 						value = "0";
-					c = atoi(value);
+					c = getnum(value, 0, 0, false);
 					if (c < 0 || c > 1)
 						illegal(value, "i projid32bit");
 					sb_feat.projid16bit = c ? false : true;
@@ -1459,6 +1475,7 @@ main(
 			p = optarg;
 			while (*p != '\0') {
 				char	*value;
+				long long tmp_num;
 
 				switch (getsubopt(&p, (constpp)lopts, &value)) {
 				case L_AGNUM:
@@ -1468,7 +1485,10 @@ main(
 						respec('l', lopts, L_AGNUM);
 					if (ldflag)
 						conflict('l', lopts, L_AGNUM, L_DEV);
-					logagno = atoi(value);
+					tmp_num = getnum(value, 0, 0, false);
+					if (tmp_num < 0)
+						illegal(value, "l agno");
+					logagno = (xfs_agnumber_t)tmp_num;
 					laflag = 1;
 					break;
 				case L_FILE:
@@ -1477,7 +1497,7 @@ main(
 					if (loginternal)
 						conflict('l', lopts, L_INTERNAL,
 							 L_FILE);
-					xi.lisfile = atoi(value);
+					xi.lisfile = getnum(value, 0, 0, false);
 					if (xi.lisfile < 0 || xi.lisfile > 1)
 						illegal(value, "l file");
 					if (xi.lisfile)
@@ -1493,7 +1513,7 @@ main(
 							 L_INTERNAL);
 					if (liflag)
 						respec('l', lopts, L_INTERNAL);
-					loginternal = atoi(value);
+					loginternal = getnum(value, 0, 0, false);
 					if (loginternal < 0 || loginternal > 1)
 						illegal(value, "l internal");
 					liflag = 1;
@@ -1503,8 +1523,10 @@ main(
 						reqval('l', lopts, L_SU);
 					if (lsu)
 						respec('l', lopts, L_SU);
-					lsu = cvtnum(
-						blocksize, sectorsize, value);
+					lsu = getnum(value, blocksize,
+						     sectorsize, true);
+					if (lsu < 0)
+						illegal(value, "l su");
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
@@ -1512,12 +1534,9 @@ main(
 						reqval('l', lopts, L_SUNIT);
 					if (lsunit)
 						respec('l', lopts, L_SUNIT);
-					if (!isdigits(value)) {
-						fprintf(stderr,
-		_("Specify log sunit in 512-byte blocks, no size suffix\n"));
-						usage();
-					}
-					lsunit = cvtnum(0, 0, value);
+					lsunit = getnum(value, 0, 0, false);
+					if (lsunit < 0)
+						illegal(value, "l sunit");
 					lsunitflag = 1;
 					break;
 				case L_NAME:
@@ -1540,7 +1559,7 @@ main(
 						reqval('l', lopts, L_VERSION);
 					if (lvflag)
 						respec('l', lopts, L_VERSION);
-					c = atoi(value);
+					c = getnum(value, 0, 0, false);
 					if (c < 1 || c > 2)
 						illegal(value, "l version");
 					sb_feat.log_version = c;
@@ -1562,7 +1581,7 @@ main(
 					if (lssflag)
 						conflict('l', lopts, L_SECTSIZE,
 							 L_SECTLOG);
-					lsectorlog = atoi(value);
+					lsectorlog = getnum(value, 0, 0, false);
 					if (lsectorlog <= 0)
 						illegal(value, "l sectlog");
 					lsectorsize = 1 << lsectorlog;
@@ -1576,8 +1595,8 @@ main(
 					if (lslflag)
 						conflict('l', lopts, L_SECTLOG,
 							 L_SECTSIZE);
-					lsectorsize = cvtnum(
-						blocksize, sectorsize, value);
+					lsectorsize = getnum(value, blocksize,
+							     sectorsize, true);
 					if (lsectorsize <= 0 ||
 					    !ispow2(lsectorsize))
 						illegal(value, "l sectsize");
@@ -1589,7 +1608,7 @@ main(
 					if (!value || *value == '\0')
 						reqval('l', lopts,
 								L_LAZYSBCNTR);
-					c = atoi(value);
+					c = getnum(value, 0, 0, false);
 					if (c < 0 || c > 1)
 						illegal(value, "l lazy-count");
 					sb_feat.lazy_sb_counters = c ? true
@@ -1614,7 +1633,7 @@ main(
 				case M_CRC:
 					if (!value || *value == '\0')
 						reqval('m', mopts, M_CRC);
-					c = atoi(value);
+					c = getnum(value, 0, 0, false);
 					if (c < 0 || c > 1)
 						illegal(value, "m crc");
 					if (c && nftype) {
@@ -1660,7 +1679,7 @@ _("cannot specify both crc and ftype\n"));
 					if (nsflag)
 						conflict('n', nopts, N_SIZE,
 							 N_LOG);
-					dirblocklog = atoi(value);
+					dirblocklog = getnum(value, 0, 0, false);
 					if (dirblocklog <= 0)
 						illegal(value, "n log");
 					dirblocksize = 1 << dirblocklog;
@@ -1674,8 +1693,8 @@ _("cannot specify both crc and ftype\n"));
 					if (nlflag)
 						conflict('n', nopts, N_LOG,
 							 N_SIZE);
-					dirblocksize = cvtnum(
-						blocksize, sectorsize, value);
+					dirblocksize = getnum(value, blocksize,
+							      sectorsize, true);
 					if (dirblocksize <= 0 ||
 					    !ispow2(dirblocksize))
 						illegal(value, "n size");
@@ -1692,7 +1711,7 @@ _("cannot specify both crc and ftype\n"));
 						/* ASCII CI mode */
 						sb_feat.nci = true;
 					} else {
-						c = atoi(value);
+						c = getnum(value, 0, 0, false);
 						if (c != 2)
 							illegal(value,
 								"n version");
@@ -1705,7 +1724,7 @@ _("cannot specify both crc and ftype\n"));
 						reqval('n', nopts, N_FTYPE);
 					if (nftype)
 						respec('n', nopts, N_FTYPE);
-					c = atoi(value);
+					c = getnum(value, 0, 0, false);
 					if (c < 0 || c > 1)
 						illegal(value, "n ftype");
 					if (sb_feat.crcs_enabled) {
@@ -1751,7 +1770,7 @@ _("cannot specify both crc and ftype\n"));
 				case R_FILE:
 					if (!value || *value == '\0')
 						value = "1";
-					xi.risfile = atoi(value);
+					xi.risfile = getnum(value, 0, 0, false);
 					if (xi.risfile < 0 || xi.risfile > 1)
 						illegal(value, "r file");
 					if (xi.risfile)
@@ -1795,7 +1814,7 @@ _("cannot specify both crc and ftype\n"));
 					if (ssflag || lssflag)
 						conflict('s', sopts, S_SECTSIZE,
 							 S_SECTLOG);
-					sectorlog = atoi(value);
+					sectorlog = getnum(value, 0, 0, false);
 					if (sectorlog <= 0)
 						illegal(value, "s sectlog");
 					lsectorlog = sectorlog;
@@ -1812,8 +1831,8 @@ _("cannot specify both crc and ftype\n"));
 					if (slflag || lslflag)
 						conflict('s', sopts, S_SECTLOG,
 							 S_SECTSIZE);
-					sectorsize = cvtnum(
-						blocksize, sectorsize, value);
+					sectorsize = getnum(value, blocksize,
+							    sectorsize, true);
 					if (sectorsize <= 0 ||
 					    !ispow2(sectorsize))
 						illegal(value, "s sectsize");
@@ -1873,6 +1892,15 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		usage();
 	}
 
+	if (!slflag && !ssflag) {
+		sectorlog = XFS_MIN_SECTORSIZE_LOG;
+		sectorsize = XFS_MIN_SECTORSIZE;
+	}
+	if (!lslflag && !lssflag) {
+		lsectorlog = sectorlog;
+		lsectorsize = sectorsize;
+	}
+
 	memset(&ft, 0, sizeof(ft));
 	get_topology(&xi, &ft, force_overwrite);
 
@@ -2038,7 +2066,9 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (dsize) {
 		__uint64_t dbytes;
 
-		dbytes = cvtnum(blocksize, sectorsize, dsize);
+		dbytes = getnum(dsize, blocksize, sectorsize, true);
+		if ((__int64_t)dbytes < 0)
+			illegal(dsize, "d size");
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2075,7 +2105,9 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (logsize) {
 		__uint64_t logbytes;
 
-		logbytes = cvtnum(blocksize, sectorsize, logsize);
+		logbytes = getnum(logsize, blocksize, sectorsize, true);
+		if ((__int64_t)logbytes < 0)
+			illegal(logsize, "l size");
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2097,7 +2129,9 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (rtsize) {
 		__uint64_t rtbytes;
 
-		rtbytes = cvtnum(blocksize, sectorsize, rtsize);
+		rtbytes = getnum(rtsize, blocksize, sectorsize, true);
+		if ((__int64_t)rtbytes < 0)
+			illegal(rtsize, "r size");
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2117,7 +2151,9 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	if (rtextsize) {
 		__uint64_t rtextbytes;
 
-		rtextbytes = cvtnum(blocksize, sectorsize, rtextsize);
+		rtextbytes = getnum(rtextsize, blocksize, sectorsize, true);
+		if ((__int64_t)rtextbytes < 0)
+			illegal(rtsize, "r extsize");
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
@@ -3230,28 +3266,11 @@ unknown(
 	usage();
 }
 
-/*
- * isdigits -- returns 1 if string contains nothing but [0-9], 0 otherwise
- */
-int
-isdigits(
-	char		*str)
-{
-	int		i;
-	int		n = strlen(str);
-
-	for (i = 0; i < n; i++) {
-		if (!isdigit((int)str[i]))
-			return 0;
-	}
-	return 1;
-}
-
 long long
 cvtnum(
 	unsigned int	blocksize,
 	unsigned int	sectorsize,
-	char		*s)
+	const char	*s)
 {
 	long long	i;
 	char		*sp;
@@ -3262,17 +3281,11 @@ cvtnum(
 	if (*sp == '\0')
 		return i;
 
-	if (*sp == 'b' && sp[1] == '\0') {
-		if (blocksize)
-			return i * blocksize;
-		fprintf(stderr, _("blocksize not available yet.\n"));
-		usage();
-	}
-	if (*sp == 's' && sp[1] == '\0') {
-		if (sectorsize)
-			return i * sectorsize;
-		return i * BBSIZE;
-	}
+	if (*sp == 'b' && sp[1] == '\0')
+		return i * blocksize;
+	if (*sp == 's' && sp[1] == '\0')
+		return i * sectorsize;
+
 	if (*sp == 'k' && sp[1] == '\0')
 		return 1024LL * i;
 	if (*sp == 'm' && sp[1] == '\0')
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
