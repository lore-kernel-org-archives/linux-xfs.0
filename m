Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 537947F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 12:57:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4019AC002
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 10:57:44 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bxkCkfZVLXGNNDOY for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2016 10:57:42 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9307D61AC509
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 12:57:42 -0600 (CST)
Subject: [PATCH 2/3] xfs_quota: make report_mount() take an "output id"
References: <56900640.1050200@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <569006A6.7010102@sandeen.net>
Date: Fri, 8 Jan 2016 12:57:42 -0600
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

Allow report_mount() to take a *oid pointer, an "output id"
which will be filled in if the quotactl returns an ID for
something other than that which was passed in.

Also, when printing results, print the id which was actually
returned, not the id which was passed in.

Should be a no-op change at this point; the next patch which
wires in Q_XGETQUOTA2 will make use of this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 quota/report.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index c77b24f..746b04a 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -291,6 +291,7 @@ report_mount(
 	FILE		*fp,
 	__uint32_t	id,
 	char		*name,
+	__uint32_t	*oid,
 	uint		form,
 	uint		type,
 	fs_path_t	*mount,
@@ -308,6 +309,9 @@ report_mount(
 		return 0;
 	}
 
+	if (oid)
+		*oid = d.d_id;
+
 	if (flags & TERSE_FLAG) {
 		count = 0;
 		if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
@@ -324,19 +328,19 @@ report_mount(
 		report_header(fp, form, type, mount, flags);
 
 	if (flags & NO_LOOKUP_FLAG) {
-		fprintf(fp, "#%-10u", id);
+		fprintf(fp, "#%-10u", d.d_id);
 	} else {
 		if (name == NULL) {
 			if (type == XFS_USER_QUOTA) {
-				struct passwd	*u = getpwuid(id);
+				struct passwd	*u = getpwuid(d.d_id);
 				if (u)
 					name = u->pw_name;
 			} else if (type == XFS_GROUP_QUOTA) {
-				struct group	*g = getgrgid(id);
+				struct group	*g = getgrgid(d.d_id);
 				if (g)
 					name = g->gr_name;
 			} else if (type == XFS_PROJ_QUOTA) {
-				fs_project_t	*p = getprprid(id);
+				fs_project_t	*p = getprprid(d.d_id);
 				if (p)
 					name = p->pr_name;
 			}
@@ -425,14 +429,14 @@ report_user_mount(
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL,
+			if (report_mount(fp, id, NULL, NULL,
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
-			if (report_mount(fp, u->pw_uid, u->pw_name,
+			if (report_mount(fp, u->pw_uid, u->pw_name, NULL,
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -457,14 +461,14 @@ report_group_mount(
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL,
+			if (report_mount(fp, id, NULL, NULL,
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
-			if (report_mount(fp, g->gr_gid, g->gr_name,
+			if (report_mount(fp, g->gr_gid, g->gr_name, NULL,
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -488,14 +492,14 @@ report_project_mount(
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL,
+			if (report_mount(fp, id, NULL, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setprent();
 		while ((p = getprent()) != NULL) {
-			if (report_mount(fp, p->pr_prid, p->pr_name,
+			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
