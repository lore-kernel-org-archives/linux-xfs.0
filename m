Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 862B27F59
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D266304039
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:03 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	B5k1tUcMWQ2etF2H for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:01 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Ij-Qm
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002eZ-PO
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/15] mkfs: getbool is redundant
Date: Fri, 29 Nov 2013 12:43:43 +1100
Message-Id: <1385689430-10103-9-git-send-email-david@fromorbit.com>
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

getbool() can be replaced with getnum_checked with appropriate
min/max values set for the boolean variables.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 147 ++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 106 insertions(+), 41 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5842cc7..564f2c1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -53,6 +53,7 @@ static long long cvtnum(unsigned int blocksize,
 			unsigned int sectorsize, const char *s);
 
 #define MAX_SUBOPTS	16
+#define SUBOPT_NEEDS_VAL	(-1LL)
 struct opt_params {
 	const char	name;
 	const char	*subopts[MAX_SUBOPTS];
@@ -60,6 +61,7 @@ struct opt_params {
 		int		index;
 		long long	minval;
 		long long	maxval;
+		long long	defaultval;
 	}		subopt_params[MAX_SUBOPTS];
 };
 
@@ -76,10 +78,12 @@ const struct opt_params bopts = {
 		{ .index = B_LOG,
 		  .minval = XFS_MIN_BLOCKSIZE_LOG,
 		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = B_SIZE,
 		  .minval = XFS_MIN_BLOCKSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -121,38 +125,55 @@ const struct opt_params dopts = {
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_FILE,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 		{ .index = D_NAME,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SUNIT,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SWIDTH,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_AGSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SU,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SW,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SECTLOG,
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SECTSIZE,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_NOALIGN,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_RTINHERIT,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_PROJINHERIT,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_EXTSZINHERIT,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -179,20 +200,31 @@ const struct opt_params iopts = {
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 		{ .index = I_LOG,
 		  .minval = XFS_DINODE_MIN_LOG,
 		  .maxval = XFS_DINODE_MAX_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_MAXPCT,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_PERBLOCK,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_SIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_ATTR,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_PROJID32BIT,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 	},
 };
@@ -228,32 +260,50 @@ const struct opt_params lopts = {
 	},
 	.subopt_params = {
 		{ .index = L_AGNUM,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_INTERNAL,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 		{ .index = L_SIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_VERSION,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SUNIT,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SU,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_DEV,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SECTLOG,
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SECTSIZE,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_FILE,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 		{ .index = L_NAME,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_LAZYSBCNTR,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 	},
 };
@@ -275,14 +325,20 @@ const struct opt_params nopts = {
 		{ .index = N_LOG,
 		  .minval = XFS_MIN_REC_DIRSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_SIZE,
 		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_VERSION,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_FTYPE,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 0,
 		},
 	},
 };
@@ -306,16 +362,22 @@ const struct opt_params ropts = {
 	},
 	.subopt_params = {
 		{ .index = R_EXTSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_SIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_DEV,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_FILE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_NAME,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_NOALIGN,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -337,18 +399,22 @@ const struct opt_params sopts = {
 		{ .index = S_LOG,
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SECTLOG,
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SIZE,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SECTSIZE,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -362,6 +428,9 @@ const struct opt_params mopts = {
 	},
 	.subopt_params = {
 		{ .index = M_CRC,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 0,
 		},
 	},
 };
@@ -1143,22 +1212,6 @@ getnum(
 	return i;
 }
 
-static bool
-getbool(
-	const char	*str,
-	const char	*illegal_str,
-	bool		default_val)
-{
-	long long	c;
-
-	if (!str || *str == '\0')
-		return default_val;
-	c = getnum(str, 0, 0, false);
-	if (c < 0 || c > 1)
-		illegal(str, illegal_str);
-	return c ? true : false;
-}
-
 static __attribute__((noreturn)) void
 illegal_option(
 	const char	*value,
@@ -1173,18 +1226,28 @@ illegal_option(
 
 static int
 getnum_checked(
-	const char	*str,
+	const char		*str,
 	const struct opt_params	*opts,
-	int		index)
+	int			index)
 {
-	long long	c;
+	const struct subopt_param *sp = &opts->subopt_params[index];
+	long long		c;
 
-	if (!str || *str == '\0')
+	if (sp->index != index) {
+		fprintf(stderr,
+	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
+			sp->index, index);
 		reqval(opts->name, (char **)opts->subopts, index);
+	}
+
+	if (!str || *str == '\0') {
+		if (sp->defaultval == SUBOPT_NEEDS_VAL)
+			reqval(opts->name, (char **)opts->subopts, index);
+		return sp->defaultval;
+	}
 
 	c = getnum(str, 0, 0, false);
-	if (c < opts->subopt_params[index].minval ||
-	    c > opts->subopt_params[index].maxval)
+	if (c < sp->minval || c > sp->maxval)
 		illegal_option(str, opts, index);
 	return c;
 }
@@ -1402,8 +1465,8 @@ main(
 					dasize = 1;
 					break;
 				case D_FILE:
-					xi.disfile = getbool(value, "d file",
-							     true);
+					xi.disfile = getnum_checked(value,
+								&dopts, D_FILE);
 					if (xi.disfile && !Nflag)
 						xi.dcreat = 1;
 					break;
@@ -1545,8 +1608,8 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case I_ALIGN:
-					sb_feat.inode_align = getbool(
-							value, "i align", true);
+					sb_feat.inode_align = getnum_checked(
+							value, &iopts, I_ALIGN);
 					break;
 				case I_LOG:
 					if (ilflag)
@@ -1616,8 +1679,9 @@ main(
 					sb_feat.attr_version = c;
 					break;
 				case I_PROJID32BIT:
-					sb_feat.projid16bit = !getbool(value,
-							"i projid32bit", false);
+					sb_feat.projid16bit =
+						!getnum_checked(value, &iopts,
+								I_PROJID32BIT);
 					break;
 				default:
 					unknown('i', value);
@@ -1648,8 +1712,8 @@ main(
 					if (loginternal)
 						conflict('l', subopts, L_INTERNAL,
 							 L_FILE);
-					xi.lisfile = getbool(value, "l file",
-							     true);
+					xi.lisfile = getnum_checked(value,
+								&lopts, L_FILE);
 					if (xi.lisfile)
 						xi.lcreat = 1;
 					break;
@@ -1662,8 +1726,8 @@ main(
 					if (liflag)
 						respec('l', subopts, L_INTERNAL);
 
-					loginternal = getbool(value,
-							"l internal", true);
+					loginternal = getnum_checked(value,
+							&lopts, L_INTERNAL);
 					liflag = 1;
 					break;
 				case L_SU:
@@ -1748,9 +1812,9 @@ main(
 					lssflag = 1;
 					break;
 				case L_LAZYSBCNTR:
-					sb_feat.lazy_sb_counters = getbool(
-							value, "l lazy-count",
-							true);
+					sb_feat.lazy_sb_counters =
+						getnum_checked(value, &lopts,
+							       L_LAZYSBCNTR);
 					break;
 				default:
 					unknown('l', value);
@@ -1771,8 +1835,9 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case M_CRC:
-					sb_feat.crcs_enabled = getbool(
-							value, "m crc", false);
+					sb_feat.crcs_enabled =
+						getnum_checked(value, &mopts,
+							       M_CRC);
 					if (sb_feat.crcs_enabled && nftype) {
 						fprintf(stderr,
 _("cannot specify both -m crc=1 and -n ftype\n"));
@@ -1847,8 +1912,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 _("cannot specify both -m crc=1 and -n ftype\n"));
 						usage();
 					}
-					sb_feat.dirftype = getbool(value,
-							     "n ftype", false);
+					sb_feat.dirftype = getnum_checked(value,
+								&nopts, N_FTYPE);
 					nftype = 1;
 					break;
 				default:
@@ -1886,8 +1951,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 					rtextsize = value;
 					break;
 				case R_FILE:
-					xi.risfile = getbool(value,
-							     "r file", true);
+					xi.risfile = getnum_checked(value,
+								&ropts, R_FILE);
 					if (xi.risfile)
 						xi.rcreat = 1;
 					break;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
