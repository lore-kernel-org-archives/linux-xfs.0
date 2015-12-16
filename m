Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E148F7F37
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 20:39:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBE8730405F
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 18:39:42 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gwBnWLrrBm2eUCEM for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2015 18:39:40 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8028A65EBB81
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 20:39:40 -0600 (CST)
Subject: [PATCH 1/2] xfs_quota: push id/name printing down into report_mount()
References: <5670CD2F.9020009@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5670CEEB.8080805@sandeen.net>
Date: Tue, 15 Dec 2015 20:39:39 -0600
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

Push the printing of the id number and/or name during quota
reporting down into report_mount(), rather than doing it in
the caller.

This lets the next patch do a lookup of any ID found with
a quota, when upper/lower ID bounds are specified.  This patch,
however, changes no behavior.  Both the ID and the name are
passed in, and which one gets printed depends on the
presence of the NO_LOOKUP_FLAG.

If "NULL" is passed in (as in the upper/lower ID search case),
then as before, only the ID is printed.  Next patch changes this.

Drops a few lines of code as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/report.c b/quota/report.c
index 3d84447..55e44c5 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -322,7 +322,11 @@ report_mount(
 	if (!(flags & NO_HEADER_FLAG))
 		report_header(fp, form, type, mount, flags);
 
-	fprintf(fp, "%-10s", name);
+	if ((name == NULL) || (flags & NO_LOOKUP_FLAG))
+		fprintf(fp, "#%-10u", id);
+	else
+		fprintf(fp, "%-10s", name);
+
 	if (form & XFS_BLOCK_QUOTA) {
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
@@ -400,24 +404,18 @@ report_user_mount(
 	uint		flags)
 {
 	struct passwd	*u;
-	char		n[NMAX];
 	uint		id;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			snprintf(n, sizeof(n)-1, "#%u", id);
-			if (report_mount(fp, id, n,
+			if (report_mount(fp, id, NULL,
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
-			if (flags & NO_LOOKUP_FLAG)
-				snprintf(n, sizeof(n)-1, "#%u", u->pw_uid);
-			else
-				strncpy(n, u->pw_name, sizeof(n)-1);
-			if (report_mount(fp, u->pw_uid, n,
+			if (report_mount(fp, u->pw_uid, u->pw_name,
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -438,24 +436,18 @@ report_group_mount(
 	uint		flags)
 {
 	struct group	*g;
-	char		n[NMAX];
 	uint		id;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			snprintf(n, sizeof(n)-1, "#%u", id);
-			if (report_mount(fp, id, n,
+			if (report_mount(fp, id, NULL,
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
-			if (flags & NO_LOOKUP_FLAG)
-				snprintf(n, sizeof(n)-1, "#%u", g->gr_gid);
-		else
-			strncpy(n, g->gr_name, sizeof(n)-1);
-			if (report_mount(fp, g->gr_gid, n,
+			if (report_mount(fp, g->gr_gid, g->gr_name,
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -475,25 +467,18 @@ report_project_mount(
 	uint		flags)
 {
 	fs_project_t	*p;
-	char		n[NMAX];
 	uint		id;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			snprintf(n, sizeof(n)-1, "#%u", id);
-			if (report_mount(fp, id, n,
+			if (report_mount(fp, id, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setprent();
 		while ((p = getprent()) != NULL) {
-			if (flags & NO_LOOKUP_FLAG)
-				snprintf(n, sizeof(n)-1, "#%u",
-					 (unsigned int)p->pr_prid);
-			else
-				strncpy(n, p->pr_name, sizeof(n)-1);
-			if (report_mount(fp, p->pr_prid, n,
+			if (report_mount(fp, p->pr_prid, p->pr_name,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
