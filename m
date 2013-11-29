Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B747B7F59
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A4B2AC002
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lVw4tQkWaJPJbEXI for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Im-S6
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002ej-R6
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/15] mkfs: add respecification detection to generic parsing
Date: Fri, 29 Nov 2013 12:43:45 +1100
Message-Id: <1385689430-10103-11-git-send-email-david@fromorbit.com>
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

Add flags to the generic input parameter tables so that
respecification can be detected in a generic manner.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 64 +++++++++++++++------------------------------------------
 1 file changed, 17 insertions(+), 47 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2f51f5b..af9b9c4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -57,15 +57,17 @@ static long long cvtnum(unsigned int blocksize,
 struct opt_params {
 	const char	name;
 	const char	*subopts[MAX_SUBOPTS];
+
 	struct subopt_param {
 		int		index;
+		bool		seen;
 		long long	minval;
 		long long	maxval;
 		long long	defaultval;
 	}		subopt_params[MAX_SUBOPTS];
 };
 
-const struct opt_params bopts = {
+struct opt_params bopts = {
 	.name = 'b',
 	.subopts = {
 #define	B_LOG		0
@@ -88,7 +90,7 @@ const struct opt_params bopts = {
 	},
 };
 
-const struct opt_params dopts = {
+struct opt_params dopts = {
 	.name = 'd',
 	.subopts = {
 #define	D_AGCOUNT	0
@@ -197,7 +199,7 @@ const struct opt_params dopts = {
 };
 
 
-const struct opt_params iopts = {
+struct opt_params iopts = {
 	.name = 'i',
 	.subopts = {
 #define	I_ALIGN		0
@@ -255,7 +257,7 @@ const struct opt_params iopts = {
 	},
 };
 
-const struct opt_params lopts = {
+struct opt_params lopts = {
 	.name = 'l',
 	.subopts = {
 #define	L_AGNUM		0
@@ -340,7 +342,7 @@ const struct opt_params lopts = {
 	},
 };
 
-const struct opt_params nopts = {
+struct opt_params nopts = {
 	.name = 'n',
 	.subopts = {
 #define	N_LOG		0
@@ -377,7 +379,7 @@ const struct opt_params nopts = {
 	},
 };
 
-const struct opt_params ropts = {
+struct opt_params ropts = {
 	.name = 'r',
 	.subopts = {
 #define	R_EXTSIZE	0
@@ -416,7 +418,7 @@ const struct opt_params ropts = {
 	},
 };
 
-const struct opt_params sopts = {
+struct opt_params sopts = {
 	.name = 's',
 	.subopts = {
 #define	S_LOG		0
@@ -453,7 +455,7 @@ const struct opt_params sopts = {
 	},
 };
 
-const struct opt_params mopts = {
+struct opt_params mopts = {
 	.name = 'm',
 	.subopts = {
 #define	M_CRC		0
@@ -1261,10 +1263,10 @@ illegal_option(
 static int
 getnum_checked(
 	const char		*str,
-	const struct opt_params	*opts,
+	struct opt_params	*opts,
 	int			index)
 {
-	const struct subopt_param *sp = &opts->subopt_params[index];
+	struct subopt_param *sp = &opts->subopt_params[index];
 	long long		c;
 
 	if (sp->index != index) {
@@ -1274,6 +1276,11 @@ getnum_checked(
 		reqval(opts->name, (char **)opts->subopts, index);
 	}
 
+	/* check for respecification of the option */
+	if (sp->seen)
+		respec(opts->name, (char **)opts->subopts, index);
+	sp->seen = true;
+
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
 			reqval(opts->name, (char **)opts->subopts, index);
@@ -1438,8 +1445,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case B_LOG:
-					if (blflag)
-						respec('b', subopts, B_LOG);
 					if (bsflag)
 						conflict('b', subopts, B_SIZE,
 							 B_LOG);
@@ -1478,9 +1483,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case D_AGCOUNT:
-					if (daflag)
-						respec('d', subopts, D_AGCOUNT);
-
 					agcount = getnum_checked(value, &dopts,
 								 D_AGCOUNT);
 					daflag = 1;
@@ -1517,8 +1519,6 @@ main(
 					dsize = value;
 					break;
 				case D_SUNIT:
-					if (dsunit)
-						respec('d', subopts, D_SUNIT);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SUNIT);
@@ -1526,8 +1526,6 @@ main(
 								 D_SUNIT);
 					break;
 				case D_SWIDTH:
-					if (dswidth)
-						respec('d', subopts, D_SWIDTH);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SWIDTH);
@@ -1548,8 +1546,6 @@ main(
 						illegal(value, "d su");
 					break;
 				case D_SW:
-					if (dsw)
-						respec('d', subopts, D_SW);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SW);
@@ -1572,8 +1568,6 @@ main(
 					nodsflag = 1;
 					break;
 				case D_SECTLOG:
-					if (slflag)
-						respec('d', subopts, D_SECTLOG);
 					if (ssflag)
 						conflict('d', subopts, D_SECTSIZE,
 							 D_SECTLOG);
@@ -1636,8 +1630,6 @@ main(
 							value, &iopts, I_ALIGN);
 					break;
 				case I_LOG:
-					if (ilflag)
-						respec('i', subopts, I_LOG);
 					if (ipflag)
 						conflict('i', subopts, I_PERBLOCK,
 							 I_LOG);
@@ -1650,8 +1642,6 @@ main(
 					ilflag = 1;
 					break;
 				case I_MAXPCT:
-					if (imflag)
-						respec('i', subopts, I_MAXPCT);
 					imaxpct = getnum_checked(value, &iopts,
 								 I_MAXPCT);
 					imflag = 1;
@@ -1660,8 +1650,6 @@ main(
 					if (ilflag)
 						conflict('i', subopts, I_LOG,
 							 I_PERBLOCK);
-					if (ipflag)
-						respec('i', subopts, I_PERBLOCK);
 					if (isflag)
 						conflict('i', subopts, I_SIZE,
 							 I_PERBLOCK);
@@ -1678,8 +1666,6 @@ main(
 					if (ipflag)
 						conflict('i', subopts, I_PERBLOCK,
 							 I_SIZE);
-					if (isflag)
-						respec('i', subopts, I_SIZE);
 					isize = getnum_checked(value, &iopts,
 							       I_SIZE);
 					if (!ispow2(isize))
@@ -1711,8 +1697,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case L_AGNUM:
-					if (laflag)
-						respec('l', subopts, L_AGNUM);
 					if (ldflag)
 						conflict('l', subopts, L_AGNUM, L_DEV);
 					logagno = getnum_checked(value, &lopts,
@@ -1734,8 +1718,6 @@ main(
 					if (xi.lisfile)
 						conflict('l', subopts, L_FILE,
 							 L_INTERNAL);
-					if (liflag)
-						respec('l', subopts, L_INTERNAL);
 
 					loginternal = getnum_checked(value,
 							&lopts, L_INTERNAL);
@@ -1752,8 +1734,6 @@ main(
 						illegal(value, "l su");
 					break;
 				case L_SUNIT:
-					if (lsunit)
-						respec('l', subopts, L_SUNIT);
 					lsunit = getnum_checked(value, &lopts,
 								 L_SUNIT);
 					break;
@@ -1773,8 +1753,6 @@ main(
 					xi.logname = value;
 					break;
 				case L_VERSION:
-					if (lvflag)
-						respec('l', subopts, L_VERSION);
 					sb_feat.log_version =
 						getnum_checked(value, &lopts,
 							       L_VERSION);
@@ -1789,8 +1767,6 @@ main(
 					lsflag = 1;
 					break;
 				case L_SECTLOG:
-					if (lslflag)
-						respec('l', subopts, L_SECTLOG);
 					if (lssflag)
 						conflict('l', subopts, L_SECTSIZE,
 							 L_SECTLOG);
@@ -1865,8 +1841,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case N_LOG:
-					if (nlflag)
-						respec('n', subopts, N_LOG);
 					if (nsflag)
 						conflict('n', subopts, N_SIZE,
 							 N_LOG);
@@ -1909,8 +1883,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 					nvflag = 1;
 					break;
 				case N_FTYPE:
-					if (nftype)
-						respec('n', subopts, N_FTYPE);
 					if (sb_feat.crcs_enabled) {
 						fprintf(stderr,
 _("cannot specify both -m crc=1 and -n ftype\n"));
@@ -1993,8 +1965,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 						  &value)) {
 				case S_LOG:
 				case S_SECTLOG:
-					if (slflag || lslflag)
-						respec('s', subopts, S_SECTLOG);
 					if (ssflag || lssflag)
 						conflict('s', subopts,
 							 S_SECTSIZE, S_SECTLOG);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
