Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B21B87CCC
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02E0BAC001
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id q5ynLCpu2mzHqvtm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 6CBCCA8A6
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:04 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0N007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:03 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 10/19] mkfs: add respecification detection to generic parsing
Date: Thu, 21 Apr 2016 11:39:44 +0200
Message-Id: <1461231593-31294-11-git-send-email-jtulak@redhat.com>
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

Add flags to the generic input parameter tables so that
respecification can be detected in a generic manner.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

---
CHANGES:
* remove unused variable nftype (appeared after a change in some previous patch
removed a line using it and then this patch removed the last usage).
---
 mkfs/xfs_mkfs.c | 67 ++++++++++++++++-----------------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f3d0165..e45b72b 100644
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
@@ -1228,7 +1234,6 @@ struct sb_feat_args {
 	int	dir_version;
 	int	spinodes;
 	int	finobt;
-	bool	finobtflag;
 	bool	inode_align;
 	bool	nci;
 	bool	lazy_sb_counters;
@@ -1364,7 +1369,7 @@ getnum_checked(
 	struct opt_params	*opts,
 	int			index)
 {
-	const struct subopt_param *sp = &opts->subopt_params[index];
+	struct subopt_param *sp = &opts->subopt_params[index];
 	long long		c;
 
 	if (sp->index != index) {
@@ -1374,6 +1379,11 @@ getnum_checked(
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
@@ -1463,7 +1473,6 @@ main(
 	int			nodsflag;
 	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
-	int			nftype;
 	int			nsflag;
 	int			nvflag;
 	int			Nflag;
@@ -1491,7 +1500,6 @@ main(
 	struct fs_topology	ft;
 	struct sb_feat_args	sb_feat = {
 		.finobt = 1,
-		.finobtflag = false,
 		.spinodes = 0,
 		.log_version = 2,
 		.attr_version = 2,
@@ -1522,7 +1530,6 @@ main(
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	sb_feat.dirftype = 1;		/* inode type information in the dir */
 	Nflag = nlflag = nsflag = nvflag = 0;
-	nftype = 0;
 	dirblocklog = dirblocksize = 0;
 	qflag = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
@@ -1553,8 +1560,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case B_LOG:
-					if (blflag)
-						respec('b', subopts, B_LOG);
 					if (bsflag)
 						conflict('b', subopts, B_SIZE,
 							 B_LOG);
@@ -1593,9 +1598,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case D_AGCOUNT:
-					if (daflag)
-						respec('d', subopts, D_AGCOUNT);
-
 					agcount = getnum_checked(value, &dopts,
 								 D_AGCOUNT);
 					daflag = 1;
@@ -1632,8 +1634,6 @@ main(
 					dsize = value;
 					break;
 				case D_SUNIT:
-					if (dsunit)
-						respec('d', subopts, D_SUNIT);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SUNIT);
@@ -1641,8 +1641,6 @@ main(
 								 D_SUNIT);
 					break;
 				case D_SWIDTH:
-					if (dswidth)
-						respec('d', subopts, D_SWIDTH);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SWIDTH);
@@ -1663,8 +1661,6 @@ main(
 						illegal(value, "d su");
 					break;
 				case D_SW:
-					if (dsw)
-						respec('d', subopts, D_SW);
 					if (nodsflag)
 						conflict('d', subopts, D_NOALIGN,
 							 D_SW);
@@ -1690,8 +1686,6 @@ main(
 					}
 					break;
 				case D_SECTLOG:
-					if (slflag)
-						respec('d', subopts, D_SECTLOG);
 					if (ssflag)
 						conflict('d', subopts, D_SECTSIZE,
 							 D_SECTLOG);
@@ -1754,8 +1748,6 @@ main(
 							value, &iopts, I_ALIGN);
 					break;
 				case I_LOG:
-					if (ilflag)
-						respec('i', subopts, I_LOG);
 					if (ipflag)
 						conflict('i', subopts, I_PERBLOCK,
 							 I_LOG);
@@ -1768,18 +1760,14 @@ main(
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
@@ -1796,8 +1784,6 @@ main(
 					if (ipflag)
 						conflict('i', subopts, I_PERBLOCK,
 							 I_SIZE);
-					if (isflag)
-						respec('i', subopts, I_SIZE);
 					isize = getnum_checked(value, &iopts,
 							       I_SIZE);
 					if (!ispow2(isize))
@@ -1833,8 +1819,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case L_AGNUM:
-					if (laflag)
-						respec('l', subopts, L_AGNUM);
 					if (ldflag)
 						conflict('l', subopts, L_AGNUM, L_DEV);
 					logagno = getnum_checked(value, &lopts,
@@ -1856,8 +1840,6 @@ main(
 					if (xi.lisfile)
 						conflict('l', subopts, L_FILE,
 							 L_INTERNAL);
-					if (liflag)
-						respec('l', subopts, L_INTERNAL);
 
 					loginternal = getnum_checked(value,
 							&lopts, L_INTERNAL);
@@ -1875,8 +1857,6 @@ main(
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
-					if (lsunit)
-						respec('l', subopts, L_SUNIT);
 					lsunit = getnum_checked(value, &lopts,
 								 L_SUNIT);
 					lsunitflag = 1;
@@ -1897,10 +1877,9 @@ main(
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
@@ -1912,8 +1891,6 @@ main(
 					lsflag = 1;
 					break;
 				case L_SECTLOG:
-					if (lslflag)
-						respec('l', subopts, L_SECTLOG);
 					if (lssflag)
 						conflict('l', subopts, L_SECTSIZE,
 							 L_SECTLOG);
@@ -1970,7 +1947,6 @@ main(
 						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
-					sb_feat.finobtflag = true;
 					sb_feat.finobt = getnum_checked(
 						value, &mopts, M_FINOBT);
 					break;
@@ -1994,8 +1970,6 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case N_LOG:
-					if (nlflag)
-						respec('n', subopts, N_LOG);
 					if (nsflag)
 						conflict('n', subopts, N_SIZE,
 							 N_LOG);
@@ -2038,11 +2012,8 @@ main(
 					nvflag = 1;
 					break;
 				case N_FTYPE:
-					if (nftype)
-						respec('n', subopts, N_FTYPE);
 					sb_feat.dirftype = getnum_checked(value,
 								&nopts, N_FTYPE);
-					nftype = 1;
 					break;
 				default:
 					unknown('n', value);
@@ -2118,8 +2089,6 @@ main(
 						  &value)) {
 				case S_LOG:
 				case S_SECTLOG:
-					if (slflag || lslflag)
-						respec('s', subopts, S_SECTLOG);
 					if (ssflag || lssflag)
 						conflict('s', subopts,
 							 S_SECTSIZE, S_SECTLOG);
@@ -2330,7 +2299,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		 * tried to use crc=0,finobt=1, then issue a warning before
 		 * turning them off.
 		 */
-		if (sb_feat.finobt && sb_feat.finobtflag) {
+		if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen) {
 			fprintf(stderr,
 _("warning: finobt not supported without CRC support, disabled.\n"));
 		}
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
