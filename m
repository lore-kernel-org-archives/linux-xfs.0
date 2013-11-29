Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07CDC7F5F
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C17758F8035
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iUp7bbevZWwvR9YH for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Iv-Uh
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:53 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002f3-Tx
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/15] mkfs: add string options to generic parsing
Date: Fri, 29 Nov 2013 12:43:49 +1100
Message-Id: <1385689430-10103-15-git-send-email-david@fromorbit.com>
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

So that string options are correctly detected for conflicts and
respecification, add a getstr() function that modifies the option
tables appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 129 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 71 insertions(+), 58 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8395fa4..88dd53e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -68,6 +68,7 @@ struct opt_params {
 	struct subopt_param {
 		int		index;
 		bool		seen;
+		bool		str_seen;
 		bool		convert;
 		bool		is_power_2;
 		int		conflicts[MAX_CONFLICTS];
@@ -1351,14 +1352,15 @@ illegal_option(
 	usage();
 }
 
-static long long
-getnum(
+static void
+check_opt(
 	const char		*str,
 	struct opt_params	*opts,
-	int			index)
+	int			index,
+	bool			str_seen)
 {
-	struct subopt_param *sp = &opts->subopt_params[index];
-	long long		c;
+	struct subopt_param	*sp = &opts->subopt_params[index];
+	int			i;
 
 	if (sp->index != index) {
 		fprintf(stderr,
@@ -1367,19 +1369,44 @@ getnum(
 		reqval(opts->name, (char **)opts->subopts, index);
 	}
 
-	/* check for respecification of the option */
-	if (sp->seen)
-		respec(opts->name, (char **)opts->subopts, index);
-	sp->seen = true;
+	/*
+	 * Check for respecification of the option. This is more complex than it
+	 * seems because some options are parsed twice - once as a string during
+	 * input parsing, then later the string is passed to getnum for
+	 * conversion into a number and bounds checking. Hence the two variables
+	 * used to track the different uses based on the @str parameter passed
+	 * to us.
+	 */
+	if (!str_seen) {
+		if (sp->seen)
+			respec(opts->name, (char **)opts->subopts, index);
+		sp->seen = true;
+	} else {
+		if (sp->str_seen)
+			respec(opts->name, (char **)opts->subopts, index);
+		sp->str_seen = true;
+	}
 
 	/* check for conflicts with the option */
-	for (c = 0; c < MAX_CONFLICTS; c++) {
-		if (sp->conflicts[c] == LAST_CONFLICT)
+	for (i = 0; i < MAX_CONFLICTS; i++) {
+		if (sp->conflicts[i] == LAST_CONFLICT)
 			break;
-		if (opts->subopt_params[c].seen)
-			conflict(opts->name, (char **)opts->subopts, c, index);
+		if (opts->subopt_params[i].seen ||
+		    opts->subopt_params[i].str_seen)
+			conflict(opts->name, (char **)opts->subopts, i, index);
 	}
+}
+
+static long long
+getnum(
+	const char		*str,
+	struct opt_params	*opts,
+	int			index)
+{
+	struct subopt_param	*sp = &opts->subopt_params[index];
+	long long		c;
 
+	check_opt(str, opts, index, false);
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
@@ -1413,6 +1440,26 @@ getnum(
 	return c;
 }
 
+/*
+ * Option is a string - do all the option table work, and check there
+ * is actually an option string. Otherwise we don't do anything with the string
+ * here - validation will be done later when the string is converted to a value
+ * or used as a file/device path.
+ */
+static char *
+getstr(
+	char			*str,
+	struct opt_params	*opts,
+	int			index)
+{
+	check_opt(str, opts, index, true);
+
+	/* empty strings for string options are not valid */
+	if (!str || *str == '\0')
+		reqval(opts->name, (char **)opts->subopts, index);
+	return str;
+}
+
 int
 main(
 	int			argc,
@@ -1602,18 +1649,10 @@ main(
 						xi.dcreat = 1;
 					break;
 				case D_NAME:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_NAME);
-					if (xi.dname)
-						respec('d', subopts, D_NAME);
-					xi.dname = value;
+					xi.dname = getstr(value, &dopts, D_NAME);
 					break;
 				case D_SIZE:
-					if (!value || *value == '\0')
-						reqval('d', subopts, D_SIZE);
-					if (dsize)
-						respec('d', subopts, D_SIZE);
-					dsize = value;
+					dsize = getstr(value, &dopts, D_SIZE);
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &dopts, D_SUNIT);
@@ -1745,18 +1784,10 @@ main(
 					break;
 				case L_NAME:
 				case L_DEV:
-					if (laflag)
-						conflict('l', subopts, L_AGNUM, L_DEV);
-					if (liflag)
-						conflict('l', subopts, L_INTERNAL, L_DEV);
-					if (!value || *value == '\0')
-						reqval('l', subopts, L_NAME);
-					if (xi.logname)
-						respec('l', subopts, L_NAME);
+					logfile = getstr(value, &lopts, L_NAME);
+					xi.logname = logfile;
 					ldflag = 1;
 					loginternal = 0;
-					logfile = value;
-					xi.logname = value;
 					break;
 				case L_VERSION:
 					sb_feat.log_version =
@@ -1764,12 +1795,7 @@ main(
 					lvflag = 1;
 					break;
 				case L_SIZE:
-					if (!value || *value == '\0')
-						reqval('l', subopts, L_SIZE);
-					if (logsize)
-						respec('l', subopts, L_SIZE);
-					logsize = value;
-					lsflag = 1;
+					logsize = getstr(value, &lopts, L_SIZE);
 					break;
 				case L_SECTLOG:
 					lsectorlog = getnum(value, &lopts,
@@ -1845,10 +1871,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 					nsflag = 1;
 					break;
 				case N_VERSION:
-					if (!value || *value == '\0')
-						reqval('n', subopts, N_VERSION);
-					if (nvflag)
-						respec('n', subopts, N_VERSION);
+					value = getstr(value, &nopts, N_VERSION);
 					if (!strcasecmp(value, "ci")) {
 						/* ASCII CI mode */
 						sb_feat.nci = true;
@@ -1897,11 +1920,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case R_EXTSIZE:
-					if (!value || *value == '\0')
-						reqval('r', subopts, R_EXTSIZE);
-					if (rtextsize)
-						respec('r', subopts, R_EXTSIZE);
-					rtextsize = value;
+					rtextsize = getstr(value, &ropts,
+							   R_EXTSIZE);
 					break;
 				case R_FILE:
 					xi.risfile = getnum(value, &ropts,
@@ -1911,18 +1931,11 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 					break;
 				case R_NAME:
 				case R_DEV:
-					if (!value || *value == '\0')
-						reqval('r', subopts, R_NAME);
-					if (xi.rtname)
-						respec('r', subopts, R_NAME);
-					xi.rtname = value;
+					xi.rtname = getstr(value, &ropts,
+							   R_NAME);
 					break;
 				case R_SIZE:
-					if (!value || *value == '\0')
-						reqval('r', subopts, R_SIZE);
-					if (rtsize)
-						respec('r', subopts, R_SIZE);
-					rtsize = value;
+					rtsize = getstr(value, &ropts, R_SIZE);
 					break;
 				case R_NOALIGN:
 					norsflag = 1;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
