Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 65ED97F3F
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 20:41:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5339A8F8035
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 18:41:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KkoZmK39CHnV1MlS for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2015 18:41:52 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 03AAB65EBB81
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 20:41:51 -0600 (CST)
Subject: [PATCH 2/2] xfs_quota: allow name lookup when reporting from ID range
References: <5670CD2F.9020009@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5670CF6F.4070005@sandeen.net>
Date: Tue, 15 Dec 2015 20:41:51 -0600
MIME-Version: 1.0
In-Reply-To: <5670CD2F.9020009@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add a new "-l" (lookup) argument to the "report" command, to
enable id->name lookups when doing a report across a lower/upper
ID range as specified by the -L / -U report options.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 9b555e9..3bee145 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -335,7 +335,7 @@ file.
 ] [
 .B \-bir
 ] [
-.B \-ahntLNU
+.B \-ahntlLNU
 ] [
 .B \-f
 .I file
@@ -363,7 +363,11 @@ option outputs the numeric ID instead of the name. The
 .B \-L
 and
 .B \-U
-options specify lower and upper ID bounds to report on. The
+options specify lower and upper ID bounds to report on.  If upper/lower
+bounds are specified, then by default only the IDs will be displayed
+in output; with the
+.B \-l
+option, a lookup will be performed to translate these IDs to names. The
 .B \-N
 option reports information without the header line. The
 .B \-t
diff --git a/quota/report.c b/quota/report.c
index 55e44c5..c77b24f 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -45,7 +45,7 @@ dump_help(void)
 static void
 report_help(void)
 {
-	report_cmd.args = _("[-bir] [-gpu] [-ahntLNU] [-f file]");
+	report_cmd.args = _("[-bir] [-gpu] [-ahntlLNU] [-f file]");
 	report_cmd.oneline = _("report filesystem quota information");
 	printf(_(
 "\n"
@@ -63,6 +63,7 @@ report_help(void)
 " -t -- terse output format, hides rows which are all zero\n"
 " -L -- lower ID bound to report on\n"
 " -U -- upper ID bound to report on\n"
+" -l -- look up names for IDs in lower-upper range\n"
 " -g -- report group usage and quota information\n"
 " -p -- report project usage and quota information\n"
 " -u -- report user usage and quota information\n"
@@ -322,10 +323,26 @@ report_mount(
 	if (!(flags & NO_HEADER_FLAG))
 		report_header(fp, form, type, mount, flags);
 
-	if ((name == NULL) || (flags & NO_LOOKUP_FLAG))
+	if (flags & NO_LOOKUP_FLAG) {
 		fprintf(fp, "#%-10u", id);
-	else
+	} else {
+		if (name == NULL) {
+			if (type == XFS_USER_QUOTA) {
+				struct passwd	*u = getpwuid(id);
+				if (u)
+					name = u->pw_name;
+			} else if (type == XFS_GROUP_QUOTA) {
+				struct group	*g = getgrgid(id);
+				if (g)
+					name = g->gr_name;
+			} else if (type == XFS_PROJ_QUOTA) {
+				fs_project_t	*p = getprprid(id);
+				if (p)
+					name = p->pr_name;
+			}
+		}
 		fprintf(fp, "%-10s", name);
+	}
 
 	if (form & XFS_BLOCK_QUOTA) {
 		qflags = (flags & HUMAN_FLAG);
@@ -545,9 +562,10 @@ report_f(
 	FILE		*fp = NULL;
 	char		*fname = NULL;
 	uint		lower = 0, upper = 0;
+	bool		lookup = false;
 	int		c, flags = 0, type = 0, form = 0;
 
-	while ((c = getopt(argc, argv, "abf:ghiL:NnprtuU:")) != EOF) {
+	while ((c = getopt(argc, argv, "abdf:ghilL:NnprtuU:")) != EOF) {
 		switch (c) {
 		case 'f':
 			fname = optarg;
@@ -587,9 +605,14 @@ report_f(
 			break;
 		case 'L':
 			lower = (uint)atoi(optarg);
+			flags |= NO_LOOKUP_FLAG;
 			break;
 		case 'U':
 			upper = (uint)atoi(optarg);
+			flags |= NO_LOOKUP_FLAG;
+			break;
+		case 'l':
+			lookup = true;
 			break;
 		default:
 			return command_usage(&report_cmd);
@@ -602,6 +625,9 @@ report_f(
 	if (!type)
 		type = XFS_USER_QUOTA | XFS_GROUP_QUOTA | XFS_PROJ_QUOTA;
 
+	if (lookup)
+		flags &= ~NO_LOOKUP_FLAG;
+
 	if ((fp = fopen_write_secure(fname)) == NULL)
 		return 0;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
