Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32BC77F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:28:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FD07304039
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:28:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sUvuHav3HCTlHrek for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:28:56 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4458260DDB96
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:28:56 -0600 (CST)
Subject: [PATCH 3/3] xfs_quota: use Q_XGETNEXTQUOTA for report and dump
References: <56A1AF9F.80303@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A1B008.1020801@sandeen.net>
Date: Thu, 21 Jan 2016 22:28:56 -0600
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

Rather than a loop over getpwnam() etc, use the Q_XGETNEXTQUOTA
command to iterate through all active quotas in quota
reports and quota file dump.

If Q_XGETNEXTQUOTA fails, go back to the old way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


(This stuff is screaming to be refactored and made consistent,
but my first attempt left me screaming too, so I'll leave
it for another day.)


 quota/quota.h  |    1 +
 quota/report.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/quota/quota.h b/quota/quota.h
index 2bbc176..4bde351 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -74,6 +74,7 @@ enum {
 	DEFAULTS_FLAG =		0x0100,	/* use value as a default */
 	ABSOLUTE_FLAG =		0x0200, /* absolute time, not related to now */
 	NO_LOOKUP_FLAG =	0x0400, /* skip name lookups, just report ID */
+	GETNEXTQUOTA_FLAG =	0x0800, /* use getnextquota quotactl */
 };
 
 /*
diff --git a/quota/report.c b/quota/report.c
index 3085a9e..8653134 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -73,20 +73,27 @@ report_help(void)
 "\n"));
 }
 
-static void
+static int 
 dump_file(
 	FILE		*fp,
 	uint		id,
 	uint		*oid,
 	uint		type,
-	char		*dev)
+	char		*dev,
+	int		flags)
 {
 	fs_disk_quota_t	d;
+	int		cmd;
+
+	if (flags & GETNEXTQUOTA_FLAG)
+		cmd = XFS_GETNEXTQUOTA;
+	else
+		cmd = XFS_GETQUOTA;
 
-	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
+	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
 			perror("XFS_GETQUOTA");
-		return;
+		return 0;
 	}
 
 	if (oid)
@@ -95,7 +102,7 @@ dump_file(
 	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
 	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
 	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
-		return;
+		return 1;
 	fprintf(fp, "fs = %s\n", dev);
 	/* this branch is for backward compatibility reasons */
 	if (d.d_rtb_softlimit || d.d_rtb_hardlimit)
@@ -114,6 +121,8 @@ dump_file(
 			(unsigned long long)d.d_blk_hardlimit,
 			(unsigned long long)d.d_ino_softlimit,
 			(unsigned long long)d.d_ino_hardlimit);
+
+	return 1;
 }
 
 static void
@@ -125,7 +134,7 @@ dump_limits_any_type(
 	uint		upper)
 {
 	fs_path_t	*mount;
-	uint		id;
+	uint		id = 0, oid;
 
 	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
 		exitcode = 1;
@@ -134,19 +143,30 @@ dump_limits_any_type(
 		return;
 	}
 
+	/* Range was specified; query everything in it */
 	if (upper) {
 		for (id = lower; id <= upper; id++)
-			dump_file(fp, id, NULL, type, mount->fs_name);
+			dump_file(fp, id, NULL, type, mount->fs_name, 0);
 		return;
 	}
 
+	/* Use GETNEXTQUOTA if it's available */
+	if (dump_file(fp, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+		id = oid + 1;
+		while (dump_file(fp, id, &oid, type, mount->fs_name,
+				 GETNEXTQUOTA_FLAG))
+			id = oid + 1;
+		return;
+        }
+
+	/* Otherwise fall back to iterating over each uid/gid/prjid */
 	switch (type) {
 	case XFS_GROUP_QUOTA: {
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL)
 				dump_file(fp, g->gr_gid, NULL, type,
-					  mount->fs_name);
+					  mount->fs_name, 0);
 			endgrent();
 			break;
 		}
@@ -155,7 +175,7 @@ dump_limits_any_type(
 			setprent();
 			while ((p = getprent()) != NULL)
 				dump_file(fp, p->pr_prid, NULL, type,
-					  mount->fs_name);
+					  mount->fs_name, 0);
 			endprent();
 			break;
 		}
@@ -164,7 +184,7 @@ dump_limits_any_type(
 			setpwent();
 			while ((u = getpwent()) != NULL)
 				dump_file(fp, u->pw_uid, NULL, type,
-					  mount->fs_name);
+					  mount->fs_name, 0);
 			endpwent();
 			break;
 		}
@@ -312,8 +332,14 @@ report_mount(
 	char		c[8], h[8], s[8];
 	uint		qflags;
 	int		count;
+	int		cmd;
+
+	if (flags & GETNEXTQUOTA_FLAG)
+		cmd = XFS_GETNEXTQUOTA;
+	else
+		cmd = XFS_GETQUOTA;
 
-	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
+	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
 			perror("XFS_GETQUOTA");
 		return 0;
@@ -435,7 +461,7 @@ report_user_mount(
 	uint		flags)
 {
 	struct passwd	*u;
-	uint		id;
+	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
@@ -443,6 +469,16 @@ report_user_mount(
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
+	} else if (report_mount(fp, id, NULL, &oid, form,
+				XFS_USER_QUOTA, mount,
+				flags|GETNEXTQUOTA_FLAG)) {
+		id = oid + 1;
+		flags |= GETNEXTQUOTA_FLAG;
+		flags |= NO_HEADER_FLAG;
+		while (report_mount(fp, id, NULL, &oid, form, XFS_USER_QUOTA,
+				    mount, flags)) {
+			id = oid + 1;
+		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
@@ -467,7 +503,7 @@ report_group_mount(
 	uint		flags)
 {
 	struct group	*g;
-	uint		id;
+	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
@@ -475,6 +511,16 @@ report_group_mount(
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
+	} else if (report_mount(fp, id, NULL, &oid, form,
+				XFS_GROUP_QUOTA, mount,
+				flags|GETNEXTQUOTA_FLAG)) {
+		id = oid + 1;
+		flags |= GETNEXTQUOTA_FLAG;
+		flags |= NO_HEADER_FLAG;
+		while (report_mount(fp, id, NULL, &oid, form, XFS_GROUP_QUOTA,
+				    mount, flags)) {
+			id = oid + 1;
+		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
@@ -498,7 +544,7 @@ report_project_mount(
 	uint		flags)
 {
 	fs_project_t	*p;
-	uint		id;
+	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
@@ -506,6 +552,16 @@ report_project_mount(
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
+	} else if (report_mount(fp, id, NULL, &oid, form,
+				XFS_PROJ_QUOTA, mount,
+				flags|GETNEXTQUOTA_FLAG)) {
+		id = oid + 1;
+		flags |= GETNEXTQUOTA_FLAG;
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
