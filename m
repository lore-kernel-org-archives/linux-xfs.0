Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 934207F5F
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 634F7304039
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:07 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	G58eHF3maB82EOZW for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:05 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Ik-RV
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002ee-QV
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/15] mkfs: use getnum_checked for all ranged parameters
Date: Fri, 29 Nov 2013 12:43:44 +1100
Message-Id: <1385689430-10103-10-git-send-email-david@fromorbit.com>
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

Now that getnum_checked can handle min/max checking, use this for
all parameters that take straight numbers and don't require unit
conversions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_mkfs.h |   5 +-
 mkfs/xfs_mkfs.c    | 152 +++++++++++++++++++++++++++--------------------------
 2 files changed, 81 insertions(+), 76 deletions(-)

diff --git a/include/xfs_mkfs.h b/include/xfs_mkfs.h
index 996b690..f5639b0 100644
--- a/include/xfs_mkfs.h
+++ b/include/xfs_mkfs.h
@@ -42,8 +42,9 @@
 
 #define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
 #define	XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
-#define XFS_AG_MIN_BLOCKS(blog)	((XFS_AG_BYTES(15)) >> (blog))
-#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_BYTES(31) - 1) >> (blog))
+#define	XFS_AG_MAX_BYTES	((XFS_AG_BYTES(31)))	/* 1 TB */
+#define XFS_AG_MIN_BLOCKS(blog)	(XFS_AG_MIN_BYTES >> (blog))
+#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_MAX_BYTES - 1) >> (blog))
 
 #define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 564f2c1..2f51f5b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -125,6 +125,8 @@ const struct opt_params dopts = {
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
+		  .minval = 1,
+		  .maxval = XFS_MAX_AGNUMBER,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_FILE,
@@ -139,18 +141,26 @@ const struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SUNIT,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SWIDTH,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_AGSIZE,
+		  .minval = XFS_AG_MIN_BYTES,
+		  .maxval = XFS_AG_MAX_BYTES,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SU,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SW,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SECTLOG,
@@ -164,15 +174,23 @@ const struct opt_params dopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_NOALIGN,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .minval = 1,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 		{ .index = D_RTINHERIT,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .minval = 1,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 		{ .index = D_PROJINHERIT,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_EXTSZINHERIT,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 	},
@@ -210,15 +228,23 @@ const struct opt_params iopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_MAXPCT,
+		  .minval = 0,
+		  .maxval = 100,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_PERBLOCK,
+		  .minval = XFS_MIN_INODE_PERBLOCK,
+		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_SIZE,
+		  .minval = XFS_DINODE_MIN_SIZE,
+		  .maxval = XFS_DINODE_MAX_SIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_ATTR,
+		  .minval = 0,
+		  .maxval = 2,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_PROJID32BIT,
@@ -260,6 +286,8 @@ const struct opt_params lopts = {
 	},
 	.subopt_params = {
 		{ .index = L_AGNUM,
+		  .minval = 0,
+		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_INTERNAL,
@@ -271,9 +299,13 @@ const struct opt_params lopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_VERSION,
+		  .minval = 1,
+		  .maxval = 2,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SUNIT,
+		  .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
+		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SU,
@@ -333,6 +365,8 @@ const struct opt_params nopts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_VERSION,
+		  .minval = 2,
+		  .maxval = 2,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_FTYPE,
@@ -1444,13 +1478,11 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case D_AGCOUNT:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_AGCOUNT);
 					if (daflag)
 						respec('d', subopts, D_AGCOUNT);
-					agcount = getnum(value, 0, 0, false);
-					if ((__int64_t)agcount <= 0)
-						illegal(value, "d agcount");
+
+					agcount = getnum_checked(value, &dopts,
+								 D_AGCOUNT);
 					daflag = 1;
 					break;
 				case D_AGSIZE:
@@ -1485,28 +1517,22 @@ main(
 					dsize = value;
 					break;
 				case D_SUNIT:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_SUNIT);
 					if (dsunit)
 						respec('d', subopts, D_SUNIT);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SUNIT);
-					dsunit = getnum(value, 0, 0, false);
-					if (dsunit < 0)
-						illegal(value, "d sunit");
+					dsunit = getnum_checked(value, &dopts,
+								 D_SUNIT);
 					break;
 				case D_SWIDTH:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_SWIDTH);
 					if (dswidth)
 						respec('d', subopts, D_SWIDTH);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SWIDTH);
-					dswidth = getnum(value, 0, 0, false);
-					if (dswidth < 0)
-						illegal(value, "d swidth");
+					dswidth = getnum_checked(value, &dopts,
+								 D_SWIDTH);
 					break;
 				case D_SU:
 					if (!value || *value == '\0')
@@ -1522,16 +1548,13 @@ main(
 						illegal(value, "d su");
 					break;
 				case D_SW:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_SW);
 					if (dsw)
 						respec('d', subopts, D_SW);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SW);
-					dsw = getnum(value, 0, 0, false);
-					if (dsw < 0)
-						illegal(value, "d sw");
+					dsw = getnum_checked(value, &dopts,
+								 D_SW);
 					break;
 				case D_NOALIGN:
 					if (dsu)
@@ -1577,21 +1600,22 @@ main(
 					ssflag = 1;
 					break;
 				case D_RTINHERIT:
-					fsx.fsx_xflags |= \
-						XFS_DIFLAG_RTINHERIT;
+					c = getnum_checked(value, &dopts,
+							   D_RTINHERIT);
+					if (c)
+						fsx.fsx_xflags |=
+							XFS_DIFLAG_RTINHERIT;
 					break;
 				case D_PROJINHERIT:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_PROJINHERIT);
-					fsx.fsx_projid = atoi(value);
-					fsx.fsx_xflags |= \
+					fsx.fsx_projid = getnum_checked(value,
+							&dopts, D_PROJINHERIT);
+					fsx.fsx_xflags |=
 						XFS_DIFLAG_PROJINHERIT;
 					break;
 				case D_EXTSZINHERIT:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_EXTSZINHERIT);
-					fsx.fsx_extsize = atoi(value);
-					fsx.fsx_xflags |= \
+					fsx.fsx_extsize = getnum_checked(value,
+							&dopts, D_EXTSZINHERIT);
+					fsx.fsx_xflags |=
 						XFS_DIFLAG_EXTSZINHERIT;
 					break;
 				default:
@@ -1626,18 +1650,13 @@ main(
 					ilflag = 1;
 					break;
 				case I_MAXPCT:
-					if (!value || *value == '\0')
-						reqval('i', subopts, I_MAXPCT);
 					if (imflag)
 						respec('i', subopts, I_MAXPCT);
-					imaxpct = getnum(value, 0, 0, false);
-					if (imaxpct < 0 || imaxpct > 100)
-						illegal(value, "i maxpct");
+					imaxpct = getnum_checked(value, &iopts,
+								 I_MAXPCT);
 					imflag = 1;
 					break;
 				case I_PERBLOCK:
-					if (!value || *value == '\0')
-						reqval('i', subopts, I_PERBLOCK);
 					if (ilflag)
 						conflict('i', subopts, I_LOG,
 							 I_PERBLOCK);
@@ -1646,16 +1665,13 @@ main(
 					if (isflag)
 						conflict('i', subopts, I_SIZE,
 							 I_PERBLOCK);
-					inopblock = getnum(value, 0, 0, false);
-					if (inopblock <
-						XFS_MIN_INODE_PERBLOCK ||
-					    !ispow2(inopblock))
+					inopblock = getnum_checked(value, &iopts,
+								   I_PERBLOCK);
+					if (!ispow2(inopblock))
 						illegal(value, "i perblock");
 					ipflag = 1;
 					break;
 				case I_SIZE:
-					if (!value || *value == '\0')
-						reqval('i', subopts, I_SIZE);
 					if (ilflag)
 						conflict('i', subopts, I_LOG,
 							 I_SIZE);
@@ -1664,19 +1680,17 @@ main(
 							 I_SIZE);
 					if (isflag)
 						respec('i', subopts, I_SIZE);
-					isize = getnum(value, 0, 0, true);
-					if (isize <= 0 || !ispow2(isize))
+					isize = getnum_checked(value, &iopts,
+							       I_SIZE);
+					if (!ispow2(isize))
 						illegal(value, "i size");
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
 					break;
 				case I_ATTR:
-					if (!value || *value == '\0')
-						reqval('i', subopts, I_ATTR);
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 2)
-						illegal(value, "i attr");
-					sb_feat.attr_version = c;
+					sb_feat.attr_version =
+						getnum_checked(value, &iopts,
+							       I_ATTR);
 					break;
 				case I_PROJID32BIT:
 					sb_feat.projid16bit =
@@ -1697,15 +1711,12 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case L_AGNUM:
-					if (!value || *value == '\0')
-						reqval('l', subopts, L_AGNUM);
 					if (laflag)
 						respec('l', subopts, L_AGNUM);
 					if (ldflag)
 						conflict('l', subopts, L_AGNUM, L_DEV);
-					logagno = getnum(value, 0, 0, false);
-					if (logagno < 0)
-						illegal(value, "l agno");
+					logagno = getnum_checked(value, &lopts,
+								 L_AGNUM);
 					laflag = 1;
 					break;
 				case L_FILE:
@@ -1741,13 +1752,10 @@ main(
 						illegal(value, "l su");
 					break;
 				case L_SUNIT:
-					if (!value || *value == '\0')
-						reqval('l', subopts, L_SUNIT);
 					if (lsunit)
 						respec('l', subopts, L_SUNIT);
-					lsunit = getnum(value, 0, 0, false);
-					if (lsunit < 0)
-						illegal(value, "l sunit");
+					lsunit = getnum_checked(value, &lopts,
+								 L_SUNIT);
 					break;
 				case L_NAME:
 				case L_DEV:
@@ -1765,14 +1773,11 @@ main(
 					xi.logname = value;
 					break;
 				case L_VERSION:
-					if (!value || *value == '\0')
-						reqval('l', subopts, L_VERSION);
 					if (lvflag)
 						respec('l', subopts, L_VERSION);
-					c = getnum(value, 0, 0, false);
-					if (c < 1 || c > 2)
-						illegal(value, "l version");
-					sb_feat.log_version = c;
+					sb_feat.log_version =
+						getnum_checked(value, &lopts,
+							       L_VERSION);
 					lvflag = 1;
 					break;
 				case L_SIZE:
@@ -1896,11 +1901,10 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 						/* ASCII CI mode */
 						sb_feat.nci = true;
 					} else {
-						c = getnum(value, 0, 0, false);
-						if (c != 2)
-							illegal(value,
-								"n version");
-						sb_feat.dir_version = c;
+						sb_feat.dir_version =
+							getnum_checked(value,
+								&nopts,
+								N_VERSION);
 					}
 					nvflag = 1;
 					break;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
