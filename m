Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FIOJlL113881 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 13:24:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73984B0B030
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 11:24:16 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UNCDhyYpjIl2XUi8 for <xfs@oss.sgi.com>;
	Mon, 15 Aug 2011 11:24:16 -0700 (PDT)
Date: Mon, 15 Aug 2011 14:24:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] mkfs: reject emptry suboption arguments
Message-ID: <20110815182415.GA30466@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chris Pearson <kermit4@gmail.com>

We require the argument to suboptions to not only exist, but also contain
a non-empty string, as cvtnum can't handle empty strings properly.  Also add
the missing argument check to the -l agnum suboption which was lacking it.

Reported-by: Chris Pearson <kermit4@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2011-08-15 07:48:00.000000000 +0000
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2011-08-15 09:43:37.000000000 +0000
@@ -969,7 +969,7 @@ main(
 
 				switch (getsubopt(&p, (constpp)bopts, &value)) {
 				case B_LOG:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('b', bopts, B_LOG);
 					if (blflag)
 						respec('b', bopts, B_LOG);
@@ -983,7 +983,7 @@ main(
 					blflag = 1;
 					break;
 				case B_SIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('b', bopts, B_SIZE);
 					if (bsflag)
 						respec('b', bopts, B_SIZE);
@@ -1010,7 +1010,7 @@ main(
 
 				switch (getsubopt(&p, (constpp)dopts, &value)) {
 				case D_AGCOUNT:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_AGCOUNT);
 					if (daflag)
 						respec('d', dopts, D_AGCOUNT);
@@ -1021,7 +1021,7 @@ main(
 					daflag = 1;
 					break;
 				case D_AGSIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_AGSIZE);
 					if (dasize)
 						respec('d', dopts, D_AGSIZE);
@@ -1030,7 +1030,7 @@ main(
 					dasize = 1;
 					break;
 				case D_FILE:
-					if (!value)
+					if (!value || *value == '\0')
 						value = "1";
 					xi.disfile = atoi(value);
 					if (xi.disfile < 0 || xi.disfile > 1)
@@ -1039,21 +1039,21 @@ main(
 						xi.dcreat = 1;
 					break;
 				case D_NAME:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_NAME);
 					if (xi.dname)
 						respec('d', dopts, D_NAME);
 					xi.dname = value;
 					break;
 				case D_SIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_SIZE);
 					if (dsize)
 						respec('d', dopts, D_SIZE);
 					dsize = value;
 					break;
 				case D_SUNIT:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_SUNIT);
 					if (dsunit)
 						respec('d', dopts, D_SUNIT);
@@ -1069,7 +1069,7 @@ main(
 					dsunit = cvtnum(0, 0, value);
 					break;
 				case D_SWIDTH:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_SWIDTH);
 					if (dswidth)
 						respec('d', dopts, D_SWIDTH);
@@ -1085,7 +1085,7 @@ main(
 					dswidth = cvtnum(0, 0, value);
 					break;
 				case D_SU:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_SU);
 					if (dsu)
 						respec('d', dopts, D_SU);
@@ -1096,7 +1096,7 @@ main(
 						blocksize, sectorsize, value);
 					break;
 				case D_SW:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_SW);
 					if (dsw)
 						respec('d', dopts, D_SW);
@@ -1127,7 +1127,7 @@ main(
 					nodsflag = 1;
 					break;
 				case D_SECTLOG:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_SECTLOG);
 					if (slflag)
 						respec('d', dopts, D_SECTLOG);
@@ -1141,7 +1141,7 @@ main(
 					slflag = 1;
 					break;
 				case D_SECTSIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_SECTSIZE);
 					if (ssflag)
 						respec('d', dopts, D_SECTSIZE);
@@ -1162,14 +1162,14 @@ main(
 						XFS_DIFLAG_RTINHERIT;
 					break;
 				case D_PROJINHERIT:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_PROJINHERIT);
 					fsx.fsx_projid = atoi(value);
 					fsx.fsx_xflags |= \
 						XFS_DIFLAG_PROJINHERIT;
 					break;
 				case D_EXTSZINHERIT:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('d', dopts, D_EXTSZINHERIT);
 					fsx.fsx_extsize = atoi(value);
 					fsx.fsx_xflags |= \
@@ -1187,14 +1187,14 @@ main(
 
 				switch (getsubopt(&p, (constpp)iopts, &value)) {
 				case I_ALIGN:
-					if (!value)
+					if (!value || *value == '\0')
 						value = "1";
 					iaflag = atoi(value);
 					if (iaflag < 0 || iaflag > 1)
 						illegal(value, "i align");
 					break;
 				case I_LOG:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('i', iopts, I_LOG);
 					if (ilflag)
 						respec('i', iopts, I_LOG);
@@ -1211,7 +1211,7 @@ main(
 					ilflag = 1;
 					break;
 				case I_MAXPCT:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('i', iopts, I_MAXPCT);
 					if (imflag)
 						respec('i', iopts, I_MAXPCT);
@@ -1221,7 +1221,7 @@ main(
 					imflag = 1;
 					break;
 				case I_PERBLOCK:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('i', iopts, I_PERBLOCK);
 					if (ilflag)
 						conflict('i', iopts, I_LOG,
@@ -1239,7 +1239,7 @@ main(
 					ipflag = 1;
 					break;
 				case I_SIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('i', iopts, I_SIZE);
 					if (ilflag)
 						conflict('i', iopts, I_LOG,
@@ -1256,7 +1256,7 @@ main(
 					isflag = 1;
 					break;
 				case I_ATTR:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('i', iopts, I_ATTR);
 					c = atoi(value);
 					if (c < 0 || c > 2)
@@ -1264,7 +1264,7 @@ main(
 					attrversion = c;
 					break;
 				case I_PROJID32BIT:
-					if (!value)
+					if (!value || *value == '\0')
 						value = "0";
 					c = atoi(value);
 					if (c < 0 || c > 1)
@@ -1283,6 +1283,8 @@ main(
 
 				switch (getsubopt(&p, (constpp)lopts, &value)) {
 				case L_AGNUM:
+					if (!value || *value == '\0')
+						reqval('l', lopts, L_AGNUM);
 					if (laflag)
 						respec('l', lopts, L_AGNUM);
 					if (ldflag)
@@ -1291,7 +1293,7 @@ main(
 					laflag = 1;
 					break;
 				case L_FILE:
-					if (!value)
+					if (!value || *value == '\0')
 						value = "1";
 					if (loginternal)
 						conflict('l', lopts, L_INTERNAL,
@@ -1303,7 +1305,7 @@ main(
 						xi.lcreat = 1;
 					break;
 				case L_INTERNAL:
-					if (!value)
+					if (!value || *value == '\0')
 						value = "1";
 					if (ldflag)
 						conflict('l', lopts, L_INTERNAL, L_DEV);
@@ -1318,7 +1320,7 @@ main(
 					liflag = 1;
 					break;
 				case L_SU:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts, L_SU);
 					if (lsu)
 						respec('l', lopts, L_SU);
@@ -1326,7 +1328,7 @@ main(
 						blocksize, sectorsize, value);
 					break;
 				case L_SUNIT:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts, L_SUNIT);
 					if (lsunit)
 						respec('l', lopts, L_SUNIT);
@@ -1343,7 +1345,7 @@ main(
 						conflict('l', lopts, L_AGNUM, L_DEV);
 					if (liflag)
 						conflict('l', lopts, L_INTERNAL, L_DEV);
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts, L_NAME);
 					if (xi.logname)
 						respec('l', lopts, L_NAME);
@@ -1353,7 +1355,7 @@ main(
 					xi.logname = value;
 					break;
 				case L_VERSION:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts, L_VERSION);
 					if (lvflag)
 						respec('l', lopts, L_VERSION);
@@ -1363,7 +1365,7 @@ main(
 					lvflag = 1;
 					break;
 				case L_SIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts, L_SIZE);
 					if (logsize)
 						respec('l', lopts, L_SIZE);
@@ -1371,7 +1373,7 @@ main(
 					lsflag = 1;
 					break;
 				case L_SECTLOG:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts, L_SECTLOG);
 					if (lslflag)
 						respec('l', lopts, L_SECTLOG);
@@ -1385,7 +1387,7 @@ main(
 					lslflag = 1;
 					break;
 				case L_SECTSIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts, L_SECTSIZE);
 					if (lssflag)
 						respec('l', lopts, L_SECTSIZE);
@@ -1402,7 +1404,7 @@ main(
 					lssflag = 1;
 					break;
 				case L_LAZYSBCNTR:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('l', lopts,
 								L_LAZYSBCNTR);
 					c = atoi(value);
@@ -1427,7 +1429,7 @@ main(
 
 				switch (getsubopt(&p, (constpp)nopts, &value)) {
 				case N_LOG:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('n', nopts, N_LOG);
 					if (nlflag)
 						respec('n', nopts, N_LOG);
@@ -1441,7 +1443,7 @@ main(
 					nlflag = 1;
 					break;
 				case N_SIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('n', nopts, N_SIZE);
 					if (nsflag)
 						respec('n', nopts, N_SIZE);
@@ -1458,7 +1460,7 @@ main(
 					nsflag = 1;
 					break;
 				case N_VERSION:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('n', nopts, N_VERSION);
 					if (nvflag)
 						respec('n', nopts, N_VERSION);
@@ -1498,14 +1500,14 @@ main(
 
 				switch (getsubopt(&p, (constpp)ropts, &value)) {
 				case R_EXTSIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('r', ropts, R_EXTSIZE);
 					if (rtextsize)
 						respec('r', ropts, R_EXTSIZE);
 					rtextsize = value;
 					break;
 				case R_FILE:
-					if (!value)
+					if (!value || *value == '\0')
 						value = "1";
 					xi.risfile = atoi(value);
 					if (xi.risfile < 0 || xi.risfile > 1)
@@ -1515,14 +1517,14 @@ main(
 					break;
 				case R_NAME:
 				case R_DEV:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('r', ropts, R_NAME);
 					if (xi.rtname)
 						respec('r', ropts, R_NAME);
 					xi.rtname = value;
 					break;
 				case R_SIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('r', ropts, R_SIZE);
 					if (rtsize)
 						respec('r', ropts, R_SIZE);
@@ -1544,7 +1546,7 @@ main(
 				switch (getsubopt(&p, (constpp)sopts, &value)) {
 				case S_LOG:
 				case S_SECTLOG:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('s', sopts, S_SECTLOG);
 					if (slflag || lslflag)
 						respec('s', sopts, S_SECTLOG);
@@ -1561,7 +1563,7 @@ main(
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
-					if (!value)
+					if (!value || *value == '\0')
 						reqval('s', sopts, S_SECTSIZE);
 					if (ssflag || lssflag)
 						respec('s', sopts, S_SECTSIZE);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
