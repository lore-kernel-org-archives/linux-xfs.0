Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 75C2F7CAE
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28B118F8040
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mtruWQva9l7sXerj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:00 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 285522FD
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:00 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0I007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:39:59 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 05/19] mkfs: factor boolean option parsing
Date: Thu, 21 Apr 2016 11:39:39 +0200
Message-Id: <1461231593-31294-6-git-send-email-jtulak@redhat.com>
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

Many of the options passed to mkfs have boolean options (0 or 1) and
all hand roll the same code and validity checks. Factor these out
into a common function.

Note that the lazy-count option is now changed to match other
booleans in that if you don't specify a value, it reverts to the
default value (on) rather than throwing an error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
CHANGES
* add getbool treatment to I_SPINODES
---
 mkfs/xfs_mkfs.c | 111 ++++++++++++++++++++++----------------------------------
 1 file changed, 43 insertions(+), 68 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 53a0ef3..94ae7e2 100644
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
@@ -1007,6 +1007,21 @@ getnum(
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
@@ -1227,11 +1242,8 @@ main(
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
@@ -1374,12 +1386,8 @@ main(
 
 				switch (getsubopt(&p, (constpp)iopts, &value)) {
 				case I_ALIGN:
-					if (!value || *value == '\0')
-						value = "1";
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "i align");
-					sb_feat.inode_align = c ? true : false;
+					sb_feat.inode_align = getbool(
+							value, "i align", true);
 					break;
 				case I_LOG:
 					if (!value || *value == '\0')
@@ -1452,20 +1460,12 @@ main(
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
-					if (!value || *value == '\0')
-						value = "1";
-					c = atoi(value);
-					if (c < 0 || c > 1)
-						illegal(value, "i spinodes");
-					sb_feat.spinodes = c;
+					sb_feat.spinodes = getbool(value,
+							"i spinodes", true);
 					break;
 				default:
 					unknown('i', value);
@@ -1491,20 +1491,15 @@ main(
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
@@ -1512,9 +1507,9 @@ main(
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
@@ -1604,14 +1599,9 @@ main(
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
@@ -1630,23 +1620,15 @@ main(
 
 				switch (getsubopt(&p, (constpp)mopts, &value)) {
 				case M_CRC:
-					if (!value || *value == '\0')
-						reqval('m', mopts, M_CRC);
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "m crc");
-					sb_feat.crcs_enabled = c ? true : false;
-					if (c)
+					sb_feat.crcs_enabled = getbool(
+							value, "m crc", true);
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
@@ -1714,14 +1696,10 @@ main(
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
-					sb_feat.dirftype = c ? true : false;
+					sb_feat.dirftype = getbool(value,
+							     "n ftype", true);
 					nftype = 1;
 					break;
 				default:
@@ -1757,11 +1735,8 @@ main(
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
@@ -3207,8 +3182,8 @@ conflict(
 
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
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
