Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DB117F5A
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 00:20:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6130AC002
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:20:27 -0700 (PDT)
Received: from e28smtp01.in.ibm.com (e28smtp01.in.ibm.com [122.248.162.1]) by
	cuda.sgi.com with ESMTP id kaHWdB4bof57SpgQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 22:20:22 -0700 (PDT)
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Mon, 30 Sep 2013 10:50:18 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id F0490E0057
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 10:51:24 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8U5MfsW27394294
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 10:52:42 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8U5KFKe027776 for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 10:50:15 +0530
Message-ID: <1380518411.2985.14.camel@ThinkPad-T5421>
Subject: [PATCH v2] xfsprogs: cleanup size/log setting flags of mkfs
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Mon, 30 Sep 2013 13:20:11 +0800
In-Reply-To: <20130929230638.GG26872@dastard>
References: <1380272973.2836.5.camel@ThinkPad-T5421>
	<5245C07A.3000700@sandeen.net> <1380437441.3811.9.camel@ThinkPad-T5421>
	<1380445971.3811.14.camel@ThinkPad-T5421>
	<20130929230638.GG26872@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfsprogs <xfs@oss.sgi.com>

As Dave suggested, for the size/log flags, we could use:
 a value of 1 to mean it was initialized (by the other suboption),
 a value of 2 to mean it was a command lien parameter.

And after the options are parsed, if we want to check whether a value
is set manually or not, we could just use one of the flags, e.g. *sflag:
 non-zero means it was manually set ( 2 - by size, 1 - by log ),
 zero means it was not manually set.

There are also some small option checking order adjustments, so respec 
checking is done before conflict checking -- just make them consistent 
with others.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mkfs/xfs_mkfs.c | 88 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 34bf2ff..b7c1ca8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1011,7 +1011,7 @@ main(
 				case B_LOG:
 					if (!value || *value == '\0')
 						reqval('b', bopts, B_LOG);
-					if (blflag)
+					if (blflag > 1)
 						respec('b', bopts, B_LOG);
 					if (bsflag)
 						conflict('b', bopts, B_SIZE,
@@ -1020,12 +1020,13 @@ main(
 					if (blocklog <= 0)
 						illegal(value, "b log");
 					blocksize = 1 << blocklog;
-					blflag = 1;
+					blflag = 2; /* command line parameter */
+					bsflag = 1; /* value initialized */
 					break;
 				case B_SIZE:
 					if (!value || *value == '\0')
 						reqval('b', bopts, B_SIZE);
-					if (bsflag)
+					if (bsflag > 1)
 						respec('b', bopts, B_SIZE);
 					if (blflag)
 						conflict('b', bopts, B_LOG,
@@ -1036,7 +1037,8 @@ main(
 					    !ispow2(blocksize))
 						illegal(value, "b size");
 					blocklog = libxfs_highbit32(blocksize);
-					bsflag = 1;
+					bsflag = 2;
+					blflag = 1;
 					break;
 				default:
 					unknown('b', value);
@@ -1169,7 +1171,7 @@ main(
 				case D_SECTLOG:
 					if (!value || *value == '\0')
 						reqval('d', dopts, D_SECTLOG);
-					if (slflag)
+					if (slflag > 1)
 						respec('d', dopts, D_SECTLOG);
 					if (ssflag)
 						conflict('d', dopts, D_SECTSIZE,
@@ -1178,12 +1180,13 @@ main(
 					if (sectorlog <= 0)
 						illegal(value, "d sectlog");
 					sectorsize = 1 << sectorlog;
-					slflag = 1;
+					slflag = 2;
+					ssflag = 1;
 					break;
 				case D_SECTSIZE:
 					if (!value || *value == '\0')
 						reqval('d', dopts, D_SECTSIZE);
-					if (ssflag)
+					if (ssflag > 1)
 						respec('d', dopts, D_SECTSIZE);
 					if (slflag)
 						conflict('d', dopts, D_SECTLOG,
@@ -1195,7 +1198,8 @@ main(
 						illegal(value, "d sectsize");
 					sectorlog =
 						libxfs_highbit32(sectorsize);
-					ssflag = 1;
+					ssflag = 2;
+					slflag = 1;
 					break;
 				case D_RTINHERIT:
 					fsx.fsx_xflags |= \
@@ -1236,19 +1240,20 @@ main(
 				case I_LOG:
 					if (!value || *value == '\0')
 						reqval('i', iopts, I_LOG);
-					if (ilflag)
+					if (ilflag > 1)
 						respec('i', iopts, I_LOG);
-					if (ipflag)
-						conflict('i', iopts, I_PERBLOCK,
-							 I_LOG);
 					if (isflag)
 						conflict('i', iopts, I_SIZE,
 							 I_LOG);
+					if (ipflag)
+						conflict('i', iopts, I_PERBLOCK,
+							 I_LOG);
 					inodelog = atoi(value);
 					if (inodelog <= 0)
 						illegal(value, "i log");
 					isize = 1 << inodelog;
-					ilflag = 1;
+					ilflag = 2;
+					isflag = 1;
 					break;
 				case I_MAXPCT:
 					if (!value || *value == '\0')
@@ -1263,11 +1268,11 @@ main(
 				case I_PERBLOCK:
 					if (!value || *value == '\0')
 						reqval('i', iopts, I_PERBLOCK);
-					if (ilflag)
-						conflict('i', iopts, I_LOG,
-							 I_PERBLOCK);
 					if (ipflag)
 						respec('i', iopts, I_PERBLOCK);
+					if (ilflag > 1)
+						conflict('i', iopts, I_LOG,
+							 I_PERBLOCK);
 					if (isflag)
 						conflict('i', iopts, I_SIZE,
 							 I_PERBLOCK);
@@ -1281,19 +1286,20 @@ main(
 				case I_SIZE:
 					if (!value || *value == '\0')
 						reqval('i', iopts, I_SIZE);
+					if (isflag > 1)
+						respec('i', iopts, I_SIZE);
 					if (ilflag)
 						conflict('i', iopts, I_LOG,
 							 I_SIZE);
 					if (ipflag)
 						conflict('i', iopts, I_PERBLOCK,
 							 I_SIZE);
-					if (isflag)
-						respec('i', iopts, I_SIZE);
 					isize = cvtnum(0, 0, value);
 					if (isize <= 0 || !ispow2(isize))
 						illegal(value, "i size");
 					inodelog = libxfs_highbit32(isize);
-					isflag = 1;
+					isflag = 2;
+					ilflag = 1;
 					break;
 				case I_ATTR:
 					if (!value || *value == '\0')
@@ -1415,7 +1421,7 @@ main(
 				case L_SECTLOG:
 					if (!value || *value == '\0')
 						reqval('l', lopts, L_SECTLOG);
-					if (lslflag)
+					if (lslflag > 1)
 						respec('l', lopts, L_SECTLOG);
 					if (lssflag)
 						conflict('l', lopts, L_SECTSIZE,
@@ -1424,12 +1430,13 @@ main(
 					if (lsectorlog <= 0)
 						illegal(value, "l sectlog");
 					lsectorsize = 1 << lsectorlog;
-					lslflag = 1;
+					lslflag = 2;
+					lssflag = 1;
 					break;
 				case L_SECTSIZE:
 					if (!value || *value == '\0')
 						reqval('l', lopts, L_SECTSIZE);
-					if (lssflag)
+					if (lssflag > 1)
 						respec('l', lopts, L_SECTSIZE);
 					if (lslflag)
 						conflict('l', lopts, L_SECTLOG,
@@ -1441,7 +1448,8 @@ main(
 						illegal(value, "l sectsize");
 					lsectorlog =
 						libxfs_highbit32(lsectorsize);
-					lssflag = 1;
+					lssflag = 2;
+					lslflag = 1;
 					break;
 				case L_LAZYSBCNTR:
 					if (!value || *value == '\0')
@@ -1490,7 +1498,7 @@ main(
 				case N_LOG:
 					if (!value || *value == '\0')
 						reqval('n', nopts, N_LOG);
-					if (nlflag)
+					if (nlflag > 1)
 						respec('n', nopts, N_LOG);
 					if (nsflag)
 						conflict('n', nopts, N_SIZE,
@@ -1499,12 +1507,13 @@ main(
 					if (dirblocklog <= 0)
 						illegal(value, "n log");
 					dirblocksize = 1 << dirblocklog;
-					nlflag = 1;
+					nlflag = 2;
+					nsflag = 1;
 					break;
 				case N_SIZE:
 					if (!value || *value == '\0')
 						reqval('n', nopts, N_SIZE);
-					if (nsflag)
+					if (nsflag > 1)
 						respec('n', nopts, N_SIZE);
 					if (nlflag)
 						conflict('n', nopts, N_LOG,
@@ -1516,7 +1525,8 @@ main(
 						illegal(value, "n size");
 					dirblocklog =
 						libxfs_highbit32(dirblocksize);
-					nsflag = 1;
+					nsflag = 2;
+					nlflag = 1;
 					break;
 				case N_VERSION:
 					if (!value || *value == '\0')
@@ -1607,7 +1617,7 @@ main(
 				case S_SECTLOG:
 					if (!value || *value == '\0')
 						reqval('s', sopts, S_SECTLOG);
-					if (slflag || lslflag)
+					if (slflag > 1 || lslflag > 1)
 						respec('s', sopts, S_SECTLOG);
 					if (ssflag || lssflag)
 						conflict('s', sopts, S_SECTSIZE,
@@ -1618,13 +1628,14 @@ main(
 					lsectorlog = sectorlog;
 					sectorsize = 1 << sectorlog;
 					lsectorsize = sectorsize;
-					lslflag = slflag = 1;
+					lslflag = slflag = 2;
+					lssflag = ssflag = 1;
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
 					if (!value || *value == '\0')
 						reqval('s', sopts, S_SECTSIZE);
-					if (ssflag || lssflag)
+					if (ssflag > 1 || lssflag > 1)
 						respec('s', sopts, S_SECTSIZE);
 					if (slflag || lslflag)
 						conflict('s', sopts, S_SECTLOG,
@@ -1638,7 +1649,8 @@ main(
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					lsectorlog = sectorlog;
-					lssflag = ssflag = 1;
+					lssflag = ssflag = 2;
+					lslflag = slflag = 1;
 					break;
 				default:
 					unknown('s', value);
@@ -1671,7 +1683,7 @@ main(
 	 * For RAID4/5/6 we want to align sector size and block size,
 	 * so we need to start with the device geometry extraction too.
 	 */
-	if (!blflag && !bsflag) {
+	if (!bsflag) {
 		blocklog = XFS_DFL_BLOCKSIZE_LOG;
 		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
 	}
@@ -1693,7 +1705,7 @@ main(
 		 * ft.sectoralign will never be set.
 		 */
 		sectorsize = blocksize;
-	} else if (!ssflag && !slflag) {
+	} else if (!ssflag) {
 		/*
 		 * Unless specified manually on the command line use the
 		 * advertised sector size of the device.  We use the physical
@@ -1721,7 +1733,7 @@ _("switching to logical sector size %d\n"),
 		}
 	}
 
-	if (ft.sectoralign || (!ssflag && !slflag)) {
+	if (ft.sectoralign || !ssflag) {
 		sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
 			lsectorsize = sectorsize;
@@ -1731,7 +1743,7 @@ _("switching to logical sector size %d\n"),
 
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
-		if (ssflag || slflag)
+		if (ssflag)
 			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
 		else
 			fprintf(stderr,
@@ -1760,7 +1772,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	 */
 	if (crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
-		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		if (isflag && inodelog < XFS_DINODE_DFL_CRC_LOG) {
 			fprintf(stderr,
 _("Minimum inode size for CRCs is %d bytes\n"),
 				1 << XFS_DINODE_DFL_CRC_LOG);
@@ -1804,7 +1816,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		}
 	}
 
-	if (nsflag || nlflag) {
+	if (nsflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
 			fprintf(stderr, _("illegal directory block size %d\n"),
@@ -1850,7 +1862,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (ipflag) {
 		inodelog = blocklog - libxfs_highbit32(inopblock);
 		isize = 1 << inodelog;
-	} else if (!ilflag && !isflag) {
+	} else if (!isflag) {
 		inodelog = crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
 					: XFS_DINODE_DFL_LOG;
 		isize = 1 << inodelog;
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
