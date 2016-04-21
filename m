Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9A247CB7
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF08130404E
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xsxLhW985mAlVL78 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:03 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id BF0AC3E70A7
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:02 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0L007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:02 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 08/19] mkfs: getbool is redundant
Date: Thu, 21 Apr 2016 11:39:42 +0200
Message-Id: <1461231593-31294-9-git-send-email-jtulak@redhat.com>
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

getbool() can be replaced with getnum_checked with appropriate
min/max values set for the boolean variables. Make boolean
arguments consistent - all accept 0 or 1 value now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
CHANGES:
* man page fixes
---
 man/man8/mkfs.xfs.8 |  19 +++--
 mkfs/xfs_mkfs.c     | 219 +++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 169 insertions(+), 69 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 8b068ef..be3d1a0 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -118,6 +118,9 @@ option or the
 option first needs to be added to the command line.
 Failure to specify the size of the units will result in illegal value errors
 when parameters are quantified in those units.
+.PP
+Many options allows for optional argument of value 0 or 1, to explicitly
+disable or enable the functionality.
 .SH OPTIONS
 .TP
 .BI \-b " block_size_options"
@@ -312,10 +315,12 @@ and
 .B swidth
 values.
 .TP
-.BI noalign
-This option disables automatic geometry detection and creates the filesystem
+.BI noalign[= value ]
+If the
+.I value
+is 1, this option disables automatic geometry detection and creates the filesystem
 without stripe geometry alignment even if the underlying storage device provides
-this information.
+this information. 0 disables this option, that is, enables automatic detection.
 .RE
 .TP
 .B \-f
@@ -805,9 +810,11 @@ This suboption is only needed if the real-time section of the
 filesystem should occupy less space than the size of the partition
 or logical volume containing the section.
 .TP
-.BI noalign
-This option disables stripe size detection, enforcing a realtime device with no
-stripe geometry.
+.BI noalign[= value ]
+If the
+.I value
+is 1, then the option disables stripe size detection, enforcing a realtime
+device with no stripe geometry. 0 will enable stripe size detection.
 .RE
 .TP
 .BI \-s " sector_size"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 86cfb7b..2f76b67 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -49,6 +49,7 @@ static long long cvtnum(unsigned int blocksize,
 			unsigned int sectorsize, const char *s);
 
 #define MAX_SUBOPTS	16
+#define SUBOPT_NEEDS_VAL	(-1LL)
 /*
  * Table for parsing mkfs parameters.
  *
@@ -83,6 +84,13 @@ static long long cvtnum(unsigned int blocksize,
  *     (Said in another way, you can't have minval and maxval both equal
  *     to zero. But if one value is different: minval=0 and maxval=1,
  *     then it is OK.)
+ *
+ *   defaultval MANDATORY
+ *     The value used if user specifies the subopt, but no value.
+ *     If the subopt accepts some values (-d file=[1|0]), then this
+ *     sets what is used with simple specifying the subopt (-d file).
+ *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
+ *     value in any case.
  */
 struct opt_params {
 	const char	name;
@@ -91,6 +99,7 @@ struct opt_params {
 		int		index;
 		long long	minval;
 		long long	maxval;
+		long long	defaultval;
 	}		subopt_params[MAX_SUBOPTS];
 };
 
@@ -107,10 +116,12 @@ struct opt_params bopts = {
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
@@ -152,38 +163,57 @@ struct opt_params dopts = {
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
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
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
@@ -212,22 +242,36 @@ struct opt_params iopts = {
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
 		{ .index = I_SPINODES,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 	},
 };
@@ -263,32 +307,50 @@ struct opt_params lopts = {
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
@@ -310,14 +372,20 @@ struct opt_params nopts = {
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
+		  .defaultval = 1,
 		},
 	},
 };
@@ -341,16 +409,26 @@ struct opt_params ropts = {
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
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 		{ .index = R_NAME,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_NOALIGN,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
 		},
 	},
 };
@@ -372,18 +450,22 @@ struct opt_params sopts = {
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
@@ -394,13 +476,24 @@ struct opt_params mopts = {
 #define	M_CRC		0
 		"crc",
 #define M_FINOBT	1
-	"finobt",
+		"finobt",
 #define M_UUID		2
 		"uuid",
 		NULL
 	},
 	.subopt_params = {
 		{ .index = M_CRC,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = M_FINOBT,
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = M_UUID,
+		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -1221,22 +1314,6 @@ getnum(
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
@@ -1251,17 +1328,27 @@ illegal_option(
 
 static int
 getnum_checked(
-	const char	*str,
+	const char		*str,
 	struct opt_params	*opts,
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
 
-	if (opts->subopt_params[index].minval == 0 &&
-	    opts->subopt_params[index].maxval == 0) {
+	if (sp->minval == 0 && sp->maxval == 0) {
 		fprintf(stderr,
 			_("Option -%c %s has undefined minval/maxval."
 			  "Can't verify value range. This is a bug.\n"),
@@ -1270,8 +1357,7 @@ getnum_checked(
 	}
 
 	c = getnum(str, 0, 0, false);
-	if (c < opts->subopt_params[index].minval ||
-	    c > opts->subopt_params[index].maxval)
+	if (c < sp->minval || c > sp->maxval)
 		illegal_option(str, opts, index);
 	return c;
 }
@@ -1496,8 +1582,8 @@ main(
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
@@ -1565,19 +1651,22 @@ main(
 						illegal(value, "d sw");
 					break;
 				case D_NOALIGN:
-					if (dsu)
-						conflict('d', subopts, D_SU,
-							 D_NOALIGN);
-					if (dsunit)
-						conflict('d', subopts, D_SUNIT,
-							 D_NOALIGN);
-					if (dsw)
-						conflict('d', subopts, D_SW,
-							 D_NOALIGN);
-					if (dswidth)
-						conflict('d', subopts, D_SWIDTH,
-							 D_NOALIGN);
-					nodsflag = 1;
+					nodsflag = getnum_checked(value,
+								&dopts, D_NOALIGN);
+					if (nodsflag) {
+						if (dsu)
+							conflict('d', subopts, D_SU,
+								D_NOALIGN);
+						if (dsunit)
+							conflict('d', subopts, D_SUNIT,
+								D_NOALIGN);
+						if (dsw)
+							conflict('d', subopts, D_SW,
+								D_NOALIGN);
+						if (dswidth)
+							conflict('d', subopts, D_SWIDTH,
+								D_NOALIGN);
+					}
 					break;
 				case D_SECTLOG:
 					if (slflag)
@@ -1639,8 +1728,8 @@ main(
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
@@ -1710,12 +1799,14 @@ main(
 					sb_feat.attr_version = c;
 					break;
 				case I_PROJID32BIT:
-					sb_feat.projid16bit = !getbool(value,
-							"i projid32bit", false);
+					sb_feat.projid16bit =
+						!getnum_checked(value, &iopts,
+								I_PROJID32BIT);
 					break;
 				case I_SPINODES:
-					sb_feat.spinodes = getbool(value,
-							"i spinodes", true);
+					sb_feat.spinodes =
+						getnum_checked(value, &iopts,
+								I_SPINODES);
 					break;
 				default:
 					unknown('i', value);
@@ -1743,11 +1834,11 @@ main(
 					laflag = 1;
 					break;
 				case L_FILE:
-					if (loginternal)
+					xi.lisfile = getnum_checked(value,
+								&lopts, L_FILE);
+					if (xi.lisfile && loginternal)
 						conflict('l', subopts, L_INTERNAL,
 							 L_FILE);
-					xi.lisfile = getbool(value, "l file",
-							     true);
 					if (xi.lisfile)
 						xi.lcreat = 1;
 					break;
@@ -1760,8 +1851,8 @@ main(
 					if (liflag)
 						respec('l', subopts, L_INTERNAL);
 
-					loginternal = getbool(value,
-							"l internal", true);
+					loginternal = getnum_checked(value,
+							&lopts, L_INTERNAL);
 					liflag = 1;
 					break;
 				case L_SU:
@@ -1848,9 +1939,9 @@ main(
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
@@ -1871,15 +1962,16 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case M_CRC:
-					sb_feat.crcs_enabled = getbool(
-							value, "m crc", true);
+					sb_feat.crcs_enabled =
+						getnum_checked(value, &mopts,
+							       M_CRC);
 					if (sb_feat.crcs_enabled)
 						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
 					sb_feat.finobtflag = true;
-					sb_feat.finobt = getbool(
-						value, "m finobt", true);
+					sb_feat.finobt = getnum_checked(
+						value, &mopts, M_FINOBT);
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
@@ -1948,8 +2040,8 @@ main(
 				case N_FTYPE:
 					if (nftype)
 						respec('n', subopts, N_FTYPE);
-					sb_feat.dirftype = getbool(value,
-							     "n ftype", true);
+					sb_feat.dirftype = getnum_checked(value,
+								&nopts, N_FTYPE);
 					nftype = 1;
 					break;
 				default:
@@ -1987,8 +2079,8 @@ main(
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
@@ -2008,7 +2100,8 @@ main(
 					rtsize = value;
 					break;
 				case R_NOALIGN:
-					norsflag = 1;
+					norsflag = getnum_checked(value,
+								&ropts, R_NOALIGN);
 					break;
 				default:
 					unknown('r', value);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
