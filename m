Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97ED07F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:28:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17C8AAC002
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:28:24 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4YtxwcPJlMpEClts for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:28:23 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1CF0360DDB96
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:28:23 -0600 (CST)
Subject: [PATCH 2/3] xfs_quota: make report_mount() & dump_file() take an
	"output id"
References: <56A1AF9F.80303@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A1AFE7.8040604@sandeen.net>
Date: Thu, 21 Jan 2016 22:28:23 -0600
MIME-Version: 1.0
In-Reply-To: <56A1AF9F.80303@sandeen.net>
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

Allow report_mount() and dump_file() to take a *oid pointer,
an "output id" which will be filled in from the returned quota
information.  Useful if the quotactl returns an ID for something
other than that which was passed in, i.e. GETNEXTQUOTA.

Also, when printing results, print the id which was actually
returned, not the id which was passed in.

Should be a no-op change at this point; the next patch which
wires in Q_XGETNEXTQUOTA will make use of this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 quota/report.c |   46 ++++++++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index c77b24f..3085a9e 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -77,6 +77,7 @@ static void
 dump_file(
 	FILE		*fp,
 	uint		id,
+	uint		*oid,
 	uint		type,
 	char		*dev)
 {
@@ -87,6 +88,10 @@ dump_file(
 			perror("XFS_GETQUOTA");
 		return;
 	}
+
+	if (oid)
+		*oid = d.d_id;
+
 	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
 	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
 	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
@@ -94,7 +99,8 @@ dump_file(
 	fprintf(fp, "fs = %s\n", dev);
 	/* this branch is for backward compatibility reasons */
 	if (d.d_rtb_softlimit || d.d_rtb_hardlimit)
-		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu %7llu %7llu\n", id,
+		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu %7llu %7llu\n",
+			d.d_id,
 			(unsigned long long)d.d_blk_softlimit,
 			(unsigned long long)d.d_blk_hardlimit,
 			(unsigned long long)d.d_ino_softlimit,
@@ -102,7 +108,8 @@ dump_file(
 			(unsigned long long)d.d_rtb_softlimit,
 			(unsigned long long)d.d_rtb_hardlimit);
 	else
-		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu\n", id,
+		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu\n",
+			d.d_id,
 			(unsigned long long)d.d_blk_softlimit,
 			(unsigned long long)d.d_blk_hardlimit,
 			(unsigned long long)d.d_ino_softlimit,
@@ -129,7 +136,7 @@ dump_limits_any_type(
 
 	if (upper) {
 		for (id = lower; id <= upper; id++)
-			dump_file(fp, id, type, mount->fs_name);
+			dump_file(fp, id, NULL, type, mount->fs_name);
 		return;
 	}
 
@@ -138,7 +145,8 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL)
-				dump_file(fp, g->gr_gid, type, mount->fs_name);
+				dump_file(fp, g->gr_gid, NULL, type,
+					  mount->fs_name);
 			endgrent();
 			break;
 		}
@@ -146,7 +154,8 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL)
-				dump_file(fp, p->pr_prid, type, mount->fs_name);
+				dump_file(fp, p->pr_prid, NULL, type,
+					  mount->fs_name);
 			endprent();
 			break;
 		}
@@ -154,7 +163,8 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL)
-				dump_file(fp, u->pw_uid, type, mount->fs_name);
+				dump_file(fp, u->pw_uid, NULL, type,
+					  mount->fs_name);
 			endpwent();
 			break;
 		}
@@ -291,6 +301,7 @@ report_mount(
 	FILE		*fp,
 	__uint32_t	id,
 	char		*name,
+	__uint32_t	*oid,
 	uint		form,
 	uint		type,
 	fs_path_t	*mount,
@@ -308,6 +319,9 @@ report_mount(
 		return 0;
 	}
 
+	if (oid)
+		*oid = d.d_id;
+
 	if (flags & TERSE_FLAG) {
 		count = 0;
 		if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
@@ -324,19 +338,19 @@ report_mount(
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
@@ -425,14 +439,14 @@ report_user_mount(
 
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
@@ -457,14 +471,14 @@ report_group_mount(
 
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
@@ -488,14 +502,14 @@ report_project_mount(
 
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
