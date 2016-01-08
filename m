Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 583047F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 12:57:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AA1C304075
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 10:57:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JqQdny9ML7AvKP2v for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2016 10:57:56 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EFEDE61AC509
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 12:57:55 -0600 (CST)
Subject: [PATCH 3/3] xfs_quota: use Q_XGETQUOTA2 for repquota
References: <56900640.1050200@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <569006B3.8000300@sandeen.net>
Date: Fri, 8 Jan 2016 12:57:55 -0600
MIME-Version: 1.0
In-Reply-To: <56900640.1050200@redhat.com>
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

Rather than a loop over getpwnam() etc, use the Q_XGETQUOTA2
command to iterate through all active quotas.

If Q_XGETQUOTA2 fails, go back to the old way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 quota/quota.h  |    1 +
 quota/report.c |   41 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/quota/quota.h b/quota/quota.h
index 8b80029..dec8330 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -74,6 +74,7 @@ enum {
 	DEFAULTS_FLAG =		0x0100,	/* use value as a default */
 	ABSOLUTE_FLAG =		0x0200, /* absolute time, not related to now */
 	NO_LOOKUP_FLAG =	0x0400, /* skip name lookups, just report ID */
+	GETQUOTA2_FLAG =	0x0800, /* use getquota2 quotactl */
 };
 
 /*
diff --git a/quota/report.c b/quota/report.c
index 746b04a..093155b 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -302,8 +302,14 @@ report_mount(
 	char		c[8], h[8], s[8];
 	uint		qflags;
 	int		count;
+	int		cmd;
 
-	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
+	if (flags & GETQUOTA2_FLAG)
+		cmd = XFS_GETQUOTA2;
+	else
+		cmd = XFS_GETQUOTA;
+
+	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
 			perror("XFS_GETQUOTA");
 		return 0;
@@ -425,7 +431,7 @@ report_user_mount(
 	uint		flags)
 {
 	struct passwd	*u;
-	uint		id;
+	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
@@ -433,6 +439,15 @@ report_user_mount(
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
+	} else if (report_mount(fp, id, NULL, &oid, form,
+				XFS_USER_QUOTA, mount, flags|GETQUOTA2_FLAG)) {
+		id = oid + 1;
+		flags |= GETQUOTA2_FLAG;
+		flags |= NO_HEADER_FLAG;
+		while (report_mount(fp, id, NULL, &oid, form, XFS_USER_QUOTA,
+				    mount, flags)) {
+			id = oid + 1;
+		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
@@ -457,7 +472,7 @@ report_group_mount(
 	uint		flags)
 {
 	struct group	*g;
-	uint		id;
+	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
@@ -465,6 +480,15 @@ report_group_mount(
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
+	} else if (report_mount(fp, id, NULL, &oid, form,
+				XFS_GROUP_QUOTA, mount, flags|GETQUOTA2_FLAG)) {
+		id = oid + 1;
+		flags |= GETQUOTA2_FLAG;
+		flags |= NO_HEADER_FLAG;
+		while (report_mount(fp, id, NULL, &oid, form, XFS_GROUP_QUOTA,
+				    mount, flags)) {
+			id = oid + 1;
+		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
@@ -488,7 +512,7 @@ report_project_mount(
 	uint		flags)
 {
 	fs_project_t	*p;
-	uint		id;
+	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
@@ -496,6 +520,15 @@ report_project_mount(
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
+	} else if (report_mount(fp, id, NULL, &oid, form,
+				XFS_PROJ_QUOTA, mount, flags|GETQUOTA2_FLAG)) {
+		id = oid + 1;
+		flags |= GETQUOTA2_FLAG;
+		flags |= NO_HEADER_FLAG;
+		while (report_mount(fp, id, NULL, &oid, form, XFS_PROJ_QUOTA,
+				    mount, flags)) {
+			id = oid + 1;
+		}
 	} else {
 		setprent();
 		while ((p = getprent()) != NULL) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
