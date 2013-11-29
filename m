Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69ABB7F60
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3DC3AC003
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:01 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YAEHa3RBRWeNrCSo for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:43:59 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Id-OO
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002eK-NX
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/15] mkfs: factor boolean option parsing
Date: Fri, 29 Nov 2013 12:43:40 +1100
Message-Id: <1385689430-10103-6-git-send-email-david@fromorbit.com>
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

Many of the options passed to mkfs have boolean options (0 or 1) and
all hand roll the same code and validity checks. Factor these out
into a common function.

Note that the lazy-count option is now changed to match other
booleans in that if you don't specify a value, it reverts to the
default value (on) rather than throwing an error. Similarly the -m
crc and -n ftype options default to off rather than throwing an
error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 101 +++++++++++++++++++++++---------------------------------
 1 file changed, 42 insertions(+), 59 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1cc2bcb..126cbea 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -42,7 +42,7 @@ struct fs_topology {
  * Prototypes for internal functions.
  */
 static void conflict(char opt, char *tab[], int oldidx, int newidx);
-static void illegal(char *value, char *opt);
+static void illegal(const char *value, const char *opt);
 static __attribute__((noreturn)) void usage (void);
 static __attribute__((noreturn)) void reqval(char opt, char *tab[], int idx);
 static void respec(char opt, char *tab[], int idx);
@@ -966,6 +966,21 @@ getnum(
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
@@ -1179,11 +1194,8 @@ main(
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
@@ -1326,12 +1338,8 @@ main(
 
 				switch (getsubopt(&p, (constpp)iopts, &value)) {
 				case I_ALIGN:
-					if (!value || *value == '\0')
-						break;
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "i align");
-					sb_feat.inode_align = c ? true : false;
+					sb_feat.inode_align = getbool(
+							value, "i align", true);
 					break;
 				case I_LOG:
 					if (!value || *value == '\0')
@@ -1404,12 +1412,8 @@ main(
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
 				default:
 					unknown('i', value);
@@ -1435,20 +1439,15 @@ main(
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
@@ -1456,9 +1455,9 @@ main(
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
@@ -1546,14 +1545,9 @@ main(
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
@@ -1572,18 +1566,14 @@ main(
 
 				switch (getsubopt(&p, (constpp)mopts, &value)) {
 				case M_CRC:
-					if (!value || *value == '\0')
-						reqval('m', mopts, M_CRC);
-					c = getnum(value, 0, 0, false);
-					if (c < 0 || c > 1)
-						illegal(value, "m crc");
-					if (c && nftype) {
+					sb_feat.crcs_enabled = getbool(
+							value, "m crc", false);
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
 				default:
@@ -1646,19 +1636,15 @@ _("cannot specify both crc and ftype\n"));
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
+							     "n ftype", false);
 					nftype = 1;
 					break;
 				default:
@@ -1694,11 +1680,8 @@ _("cannot specify both crc and ftype\n"));
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
@@ -3074,8 +3057,8 @@ conflict(
 
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
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
