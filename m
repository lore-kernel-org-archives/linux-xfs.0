Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F7547CA6
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67272304062
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bIQ9S2b0gpewNSPS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:43 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 386B68E231
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:43 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbLB009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:42 -0400
From: jtulak@redhat.com
Subject: [PATCH 05/19] mkfs: factor boolean option parsing
Date: Thu, 24 Mar 2016 12:15:22 +0100
Message-Id: <1458818136-56043-6-git-send-email-jtulak@redhat.com>
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

UPDATE:
- add a forgotten getbool update to FINOBT
- change -m crc and ftype to enable by specifying (instead of toggle off)

Many of the options passed to mkfs have boolean options (0 or 1) and
all hand roll the same code and validity checks. Factor these out
into a common function.

Note that the lazy-count option is now changed to match other
booleans in that if you don't specify a value, it reverts to the
default value (on) rather than throwing an error. 

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 109 +++++++++++++++++++++++---------------------------------
 1 file changed, 44 insertions(+), 65 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4811d77..9394bd3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -38,7 +38,7 @@ struct fs_topology {
  * Prototypes for internal functions.
  */
 static void conflict(char opt, char *tab[], int oldidx, int newidx);
-static void illegal(char *value, char *opt);
+static void illegal(const char *value, const char *opt);
 static __attribute__((noreturn)) void usage (void);
 static __attribute__((noreturn)) void reqval(char opt, char *tab[], int idx);
 static void respec(char opt, char *tab[], int idx);
@@ -1006,6 +1006,21 @@ getnum(
 	return i;
 }

+static bool
+getbool(
+	const char	*str,
+	const char	*illegal_str,
+	bool		default_val)
+{
+	long long	c;
+
+	if (!str || *str == '\0')
+		return default_val;
+	c = getnum(str, 0, 0, false);
+	if (c < 0 || c > 1)
+		illegal(str, illegal_str);
+	return c ? true : false;
+}

 int
 main(
@@ -1226,11 +1241,8 @@ main(
 					dasize = 1;
 					break;
 				case D_FILE:
-					if (!value || *value == '\0')
-						value = "1";
-					xi.disfile = getnum(value, 0, 0, false);
-					if (xi.disfile < 0 || xi.disfile > 1)
-						illegal(value, "d file");
+					xi.disfile = getbool(value, "d file",
+							     true);
 					if (xi.disfile && !Nflag)
 						xi.dcreat = 1;
 					break;
@@ -1373,12 +1385,8 @@ main(

 				switch (getsubopt(&p, (constpp)iopts, &value)) {
 				case I_ALIGN:
-					if (!value || *value == '\0')
-						reqval('i', iopts, I_ALIGN);
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "i align");
-					sb_feat.inode_align = c ? true : false;
+					sb_feat.inode_align = getbool(
+							value, "i align", true);
 					break;
 				case I_LOG:
 					if (!value || *value == '\0')
@@ -1451,12 +1459,8 @@ main(
 					sb_feat.attr_version = c;
 					break;
 				case I_PROJID32BIT:
-					if (!value || *value == '\0')
-						value = "0";
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "i projid32bit");
-					sb_feat.projid16bit = c ? false : true;
+					sb_feat.projid16bit = !getbool(value,
+							"i projid32bit", false);
 					break;
 				case I_SPINODES:
 					if (!value || *value == '\0')
@@ -1492,20 +1496,15 @@ main(
 					laflag = 1;
 					break;
 				case L_FILE:
-					if (!value || *value == '\0')
-						value = "1";
 					if (loginternal)
 						conflict('l', lopts, L_INTERNAL,
 							 L_FILE);
-					xi.lisfile = getnum(value, 0, 0, false);
-					if (xi.lisfile < 0 || xi.lisfile > 1)
-						illegal(value, "l file");
+					xi.lisfile = getbool(value, "l file",
+							     true);
 					if (xi.lisfile)
 						xi.lcreat = 1;
 					break;
 				case L_INTERNAL:
-					if (!value || *value == '\0')
-						value = "1";
 					if (ldflag)
 						conflict('l', lopts, L_INTERNAL, L_DEV);
 					if (xi.lisfile)
@@ -1513,9 +1512,9 @@ main(
 							 L_INTERNAL);
 					if (liflag)
 						respec('l', lopts, L_INTERNAL);
-					loginternal = getnum(value, 0, 0, false);
-					if (loginternal < 0 || loginternal > 1)
-						illegal(value, "l internal");
+
+					loginternal = getbool(value,
+							"l internal", true);
 					liflag = 1;
 					break;
 				case L_SU:
@@ -1605,14 +1604,9 @@ main(
 					lssflag = 1;
 					break;
 				case L_LAZYSBCNTR:
-					if (!value || *value == '\0')
-						reqval('l', lopts,
-								L_LAZYSBCNTR);
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "l lazy-count");
-					sb_feat.lazy_sb_counters = c ? true
-								     : false;
+					sb_feat.lazy_sb_counters = getbool(
+							value, "l lazy-count",
+							true);
 					break;
 				default:
 					unknown('l', value);
@@ -1631,28 +1625,20 @@ main(

 				switch (getsubopt(&p, (constpp)mopts, &value)) {
 				case M_CRC:
-					if (!value || *value == '\0')
-						reqval('m', mopts, M_CRC);
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "m crc");
-					if (c && nftype) {
+					sb_feat.crcs_enabled = getbool(
+							value, "m crc", true);
+					if (sb_feat.crcs_enabled && nftype) {
 						fprintf(stderr,
-_("cannot specify both crc and ftype\n"));
+_("cannot specify both -m crc=1 and -n ftype\n"));
 						usage();
 					}
-					sb_feat.crcs_enabled = c ? true : false;
-					if (c)
+					if (sb_feat.crcs_enabled)
 						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
-					if (!value || *value == '\0')
-						reqval('m', mopts, M_CRC);
-					c = atoi(value);
-					if (c < 0 || c > 1)
-						illegal(value, "m finobt");
 					sb_feat.finobtflag = true;
-					sb_feat.finobt = c;
+					sb_feat.finobt = getbool(
+						value, "m finobt", true);
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
@@ -1720,19 +1706,15 @@ _("cannot specify both crc and ftype\n"));
 					nvflag = 1;
 					break;
 				case N_FTYPE:
-					if (!value || *value == '\0')
-						reqval('n', nopts, N_FTYPE);
 					if (nftype)
 						respec('n', nopts, N_FTYPE);
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "n ftype");
 					if (sb_feat.crcs_enabled) {
 						fprintf(stderr,
-_("cannot specify both crc and ftype\n"));
+_("cannot specify both -m crc=1 and -n ftype\n"));
 						usage();
 					}
-					sb_feat.dirftype = c ? true : false;
+					sb_feat.dirftype = getbool(value,
+							     "n ftype", true);
 					nftype = 1;
 					break;
 				default:
@@ -1768,11 +1750,8 @@ _("cannot specify both crc and ftype\n"));
 					rtextsize = value;
 					break;
 				case R_FILE:
-					if (!value || *value == '\0')
-						value = "1";
-					xi.risfile = getnum(value, 0, 0, false);
-					if (xi.risfile < 0 || xi.risfile > 1)
-						illegal(value, "r file");
+					xi.risfile = getbool(value,
+							     "r file", true);
 					if (xi.risfile)
 						xi.rcreat = 1;
 					break;
@@ -3220,8 +3199,8 @@ conflict(

 static void
 illegal(
-	char		*value,
-	char		*opt)
+	const char	*value,
+	const char	*opt)
 {
 	fprintf(stderr, _("Illegal value %s for -%s option\n"), value, opt);
 	usage();
--
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
