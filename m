Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46C337CCD
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1539330405F
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UoN0DcORFVa2Osdl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:48 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id E1ECD64394
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:47 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbLG009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:47 -0400
From: jtulak@redhat.com
Subject: [PATCH 10/19] mkfs: add respecification detection to generic parsing
Date: Thu, 24 Mar 2016 12:15:27 +0100
Message-Id: <1458818136-56043-11-git-send-email-jtulak@redhat.com>
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

CHANGE:
o Add description of new members in opt_params struct.
o Drop "const" from struct opt_params - a previous patch was changed to
  not create it as const.

Add flags to the generic input parameter tables so that
respecification can be detected in a generic manner.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 64 ++++++++++++++++-----------------------------------------
 1 file changed, 18 insertions(+), 46 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 021d682..a8dd304 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -72,6 +72,10 @@ static long long cvtnum(unsigned int blocksize,
  *     it is. The index has to be the same as is the order in subopts list,
  *     so we can access the right item both in subopt_param and subopts.
  *
+ *   seen INTERNAL
+ *     Do not set this flag when definning a subopt. It is used to remeber that
+ *     this subopt was already seen, for example for conflicts detection.
+ *
  *   minval, maxval OPTIONAL
  *     These options are used for automatic range check and they have to be
  *     always used together in pair. If you don't want to limit the max value,
@@ -95,8 +99,10 @@ static long long cvtnum(unsigned int blocksize,
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
@@ -1227,7 +1233,6 @@ struct sb_feat_args {
 	int	dir_version;
 	int	spinodes;
 	int	finobt;
-	bool	finobtflag;
 	bool	inode_align;
 	bool	nci;
 	bool	lazy_sb_counters;
@@ -1363,7 +1368,7 @@ getnum_checked(
 	struct opt_params	*opts,
 	int			index)
 {
-	const struct subopt_param *sp = &opts->subopt_params[index];
+	struct subopt_param *sp = &opts->subopt_params[index];
 	long long		c;
 
 	if (sp->index != index) {
@@ -1373,6 +1378,11 @@ getnum_checked(
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
@@ -1490,7 +1500,6 @@ main(
 	struct fs_topology	ft;
 	struct sb_feat_args	sb_feat = {
 		.finobt = 1,
-		.finobtflag = false,
 		.spinodes = 0,
 		.log_version = 2,
 		.attr_version = 2,
@@ -1552,8 +1561,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case B_LOG:
-					if (blflag)
-						respec('b', subopts, B_LOG);
 					if (bsflag)
 						conflict('b', subopts, B_SIZE,
 							 B_LOG);
@@ -1592,9 +1599,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case D_AGCOUNT:
-					if (daflag)
-						respec('d', subopts, D_AGCOUNT);
-
 					agcount = getnum_checked(value, &dopts,
 								 D_AGCOUNT);
 					daflag = 1;
@@ -1631,8 +1635,6 @@ main(
 					dsize = value;
 					break;
 				case D_SUNIT:
-					if (dsunit)
-						respec('d', subopts, D_SUNIT);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SUNIT);
@@ -1640,8 +1642,6 @@ main(
 								 D_SUNIT);
 					break;
 				case D_SWIDTH:
-					if (dswidth)
-						respec('d', subopts, D_SWIDTH);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SWIDTH);
@@ -1662,8 +1662,6 @@ main(
 						illegal(value, "d su");
 					break;
 				case D_SW:
-					if (dsw)
-						respec('d', subopts, D_SW);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SW);
@@ -1689,8 +1687,6 @@ main(
 					}
 					break;
 				case D_SECTLOG:
-					if (slflag)
-						respec('d', subopts, D_SECTLOG);
 					if (ssflag)
 						conflict('d', subopts, D_SECTSIZE,
 							 D_SECTLOG);
@@ -1753,8 +1749,6 @@ main(
 							value, &iopts, I_ALIGN);
 					break;
 				case I_LOG:
-					if (ilflag)
-						respec('i', subopts, I_LOG);
 					if (ipflag)
 						conflict('i', subopts, I_PERBLOCK,
 							 I_LOG);
@@ -1767,18 +1761,14 @@ main(
 					ilflag = 1;
 					break;
 				case I_MAXPCT:
-					if (imflag)
-						respec('i', subopts, I_MAXPCT);
-					imaxpct = getnum_checked(
-							value, &iopts, I_MAXPCT);
+					imaxpct = getnum_checked(value, &iopts,
+								 I_MAXPCT);
 					imflag = 1;
 					break;
 				case I_PERBLOCK:
 					if (ilflag)
 						conflict('i', subopts, I_LOG,
 							 I_PERBLOCK);
-					if (ipflag)
-						respec('i', subopts, I_PERBLOCK);
 					if (isflag)
 						conflict('i', subopts, I_SIZE,
 							 I_PERBLOCK);
@@ -1795,8 +1785,6 @@ main(
 					if (ipflag)
 						conflict('i', subopts, I_PERBLOCK,
 							 I_SIZE);
-					if (isflag)
-						respec('i', subopts, I_SIZE);
 					isize = getnum_checked(value, &iopts,
 							       I_SIZE);
 					if (!ispow2(isize))
@@ -1832,8 +1820,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case L_AGNUM:
-					if (laflag)
-						respec('l', subopts, L_AGNUM);
 					if (ldflag)
 						conflict('l', subopts, L_AGNUM, L_DEV);
 					logagno = getnum_checked(value, &lopts,
@@ -1855,8 +1841,6 @@ main(
 					if (xi.lisfile)
 						conflict('l', subopts, L_FILE,
 							 L_INTERNAL);
-					if (liflag)
-						respec('l', subopts, L_INTERNAL);
 
 					loginternal = getnum_checked(value,
 							&lopts, L_INTERNAL);
@@ -1874,8 +1858,6 @@ main(
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
-					if (lsunit)
-						respec('l', subopts, L_SUNIT);
 					lsunit = getnum_checked(value, &lopts,
 								 L_SUNIT);
 					lsunitflag = 1;
@@ -1896,10 +1878,9 @@ main(
 					xi.logname = value;
 					break;
 				case L_VERSION:
-					if (lvflag)
-						respec('l', subopts, L_VERSION);
-					sb_feat.log_version = getnum_checked(
-						value, &lopts, L_VERSION);
+					sb_feat.log_version =
+						getnum_checked(value, &lopts,
+							       L_VERSION);
 					lvflag = 1;
 					break;
 				case L_SIZE:
@@ -1911,8 +1892,6 @@ main(
 					lsflag = 1;
 					break;
 				case L_SECTLOG:
-					if (lslflag)
-						respec('l', subopts, L_SECTLOG);
 					if (lssflag)
 						conflict('l', subopts, L_SECTSIZE,
 							 L_SECTLOG);
@@ -1974,7 +1953,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
-					sb_feat.finobtflag = true;
 					sb_feat.finobt = getnum_checked(
 						value, &mopts, M_FINOBT);
 					break;
@@ -1998,8 +1976,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case N_LOG:
-					if (nlflag)
-						respec('n', subopts, N_LOG);
 					if (nsflag)
 						conflict('n', subopts, N_SIZE,
 							 N_LOG);
@@ -2042,8 +2018,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 					nvflag = 1;
 					break;
 				case N_FTYPE:
-					if (nftype)
-						respec('n', subopts, N_FTYPE);
 					if (sb_feat.crcs_enabled) {
 						fprintf(stderr,
 _("cannot specify both -m crc=1 and -n ftype\n"));
@@ -2127,8 +2101,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 						  &value)) {
 				case S_LOG:
 				case S_SECTLOG:
-					if (slflag || lslflag)
-						respec('s', subopts, S_SECTLOG);
 					if (ssflag || lssflag)
 						conflict('s', subopts,
 							 S_SECTSIZE, S_SECTLOG);
@@ -2340,7 +2312,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		 * them off.
 		 */
 		if (sb_feat.finobt){
-			if (sb_feat.finobtflag) {
+			if (mopts.subopt_params[M_FINOBT].seen) {
 				fprintf(stderr,
 	_("warning: finobt not supported without CRC support, disabled.\n"));
 			}
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
