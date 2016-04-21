Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0059D7CB9
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2B17304066
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EeYoVmY4qZEOYTIo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:08 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id BB22A81104
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:07 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0R007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:07 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 14/19] mkfs: add string options to generic parsing
Date: Thu, 21 Apr 2016 11:39:48 +0200
Message-Id: <1461231593-31294-15-git-send-email-jtulak@redhat.com>
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

So that string options are correctly detected for conflicts and
respecification, add a getstr() function that modifies the option
tables appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 mkfs/xfs_mkfs.c | 143 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 78 insertions(+), 65 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 83ccab5..b1043fb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -83,6 +83,10 @@ unsigned int		sectorsize;
  *     Do not set this flag when definning a subopt. It is used to remeber that
  *     this subopt was already seen, for example for conflicts detection.
  *
+ *   str_seen INTERNAL
+ *     Do not set. It is used internally for respecification, when some options
+ *     has to be parsed twice - at first as a string, then later as a number.
+ *
  *   convert OPTIONAL
  *     A flag signalling whether the user-given value can use suffixes.
  *     If you want to allow the use of user-friendly values like 13k, 42G,
@@ -124,6 +128,7 @@ struct opt_params {
 	struct subopt_param {
 		int		index;
 		bool		seen;
+		bool		str_seen;
 		bool		convert;
 		bool		is_power_2;
 		int		conflicts[MAX_CONFLICTS];
@@ -1471,14 +1476,17 @@ illegal_option(
 	usage();
 }
 
-static long long
-getnum(
-	const char		*str,
+/*
+ * Check for conflicts and option respecification.
+ */
+static void
+check_opt(
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
@@ -1487,22 +1495,47 @@ getnum(
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
-		int conflict_opt = sp->conflicts[c];
+	for (i = 0; i < MAX_CONFLICTS; i++) {
+		int conflict_opt = sp->conflicts[i];
 
 		if (conflict_opt == LAST_CONFLICT)
 			break;
-		if (opts->subopt_params[conflict_opt].seen)
+		if (opts->subopt_params[conflict_opt].seen ||
+			opts->subopt_params[conflict_opt].str_seen)
 			conflict(opts->name, (char **)opts->subopts,
 				 conflict_opt, index);
 	}
+}
 
+static long long
+getnum(
+	const char		*str,
+	struct opt_params	*opts,
+	int			index)
+{
+	struct subopt_param	*sp = &opts->subopt_params[index];
+	long long		c;
+
+	check_opt(opts, index, false);
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
@@ -1544,6 +1577,26 @@ getnum(
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
+	check_opt(opts, index, true);
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
@@ -1737,18 +1790,10 @@ main(
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
@@ -1889,18 +1934,10 @@ main(
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
@@ -1908,12 +1945,7 @@ main(
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
@@ -1994,10 +2026,7 @@ main(
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
@@ -2040,11 +2069,8 @@ main(
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
@@ -2054,18 +2080,11 @@ main(
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
 					norsflag = getnum(value, &ropts,
@@ -2125,13 +2144,7 @@ main(
 		fprintf(stderr, _("extra arguments\n"));
 		usage();
 	} else if (argc - optind == 1) {
-		dfile = xi.volname = argv[optind];
-		if (xi.dname) {
-			fprintf(stderr,
-				_("cannot specify both %s and -d name=%s\n"),
-				xi.volname, xi.dname);
-			usage();
-		}
+		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
 	} else
 		dfile = xi.dname;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
