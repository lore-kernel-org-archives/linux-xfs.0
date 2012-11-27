Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARA3o2A034304 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 04:03:51 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id DNPeKvE4D0DgPcMF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 02:06:06 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9FF8C3EE0B5
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:06:04 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 80A5C45DEB6
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:06:04 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 6A60A45DEB2
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:06:04 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5E1001DB803C
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:06:04 +0900 (JST)
Received: from g01jpexchkw02.g01.fujitsu.local
	(g01jpexchkw02.g01.fujitsu.local [10.0.194.41])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 1C7221DB803B
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:06:04 +0900 (JST)
Message-ID: <50B49074.1020000@jp.fujitsu.com>
Date: Tue, 27 Nov 2012 19:05:40 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [RFC] [PATCH] xfs_quota: support relative path as `path' arguments
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs ML <xfs@oss.sgi.com>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Current xfs_quota only accepts absolute path as its `path' arguments.
This patch adds the support of relative path for user's convenience.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 libxcmd/paths.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 2a92299..bd84cde 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -27,6 +27,7 @@
 #include <xfs/path.h>
 #include <xfs/input.h>
 #include <xfs/project.h>
+#include <limits.h>
 
 extern char *progname;
 
@@ -273,6 +274,7 @@ fs_table_initialise_mounts(
 	FILE		*mtp;
 	char		*fslog, *fsrt;
 	int		error, found;
+	char		*rpath = NULL;
 
 	error = found = 0;
 	fslog = fsrt = NULL;
@@ -286,26 +288,32 @@ fs_table_initialise_mounts(
 	if ((mtp = setmntent(mtab_file, "r")) == NULL)
 		return ENOENT;
 
+	if (path)
+		if ((rpath = realpath(path, NULL)) == NULL)
+			return ENOENT;
+
 	while ((mnt = getmntent(mtp)) != NULL) {
 		if (strcmp(mnt->mnt_type, "xfs") != 0)
 			continue;
-		if (path &&
-		    ((strcmp(path, mnt->mnt_dir) != 0) &&
-		     (strcmp(path, mnt->mnt_fsname) != 0)))
+		if (rpath &&
+		    ((strcmp(rpath, mnt->mnt_dir) != 0) &&
+		     (strcmp(rpath, mnt->mnt_fsname) != 0)))
 			continue;
 		if (fs_extract_mount_options(mnt, &fslog, &fsrt))
 			continue;
 		(void) fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
 					mnt->mnt_fsname, fslog, fsrt);
-		if (path) {
+		if (rpath) {
 			found = 1;
 			break;
 		}
 	}
 	endmntent(mtp);
-	if (path && !found)
-		error = ENXIO;
-
+	if (rpath) {
+		free(rpath);
+		if (!found)
+			error = ENXIO;
+	}
 	return error;
 }
 
@@ -318,6 +326,7 @@ fs_table_initialise_mounts(
 {
 	struct statfs	*stats;
 	int		i, count, error, found;
+	char		*rpath = NULL;
 
 	error = found = 0;
 	if ((count = getmntinfo(&stats, 0)) < 0) {
@@ -326,24 +335,31 @@ fs_table_initialise_mounts(
 		return 0;
 	}
 
+	if (path)
+		if ((rpath = realpath(path, NULL)) == NULL)
+			return ENOENT;
+
 	for (i = 0; i < count; i++) {
 		if (strcmp(stats[i].f_fstypename, "xfs") != 0)
 			continue;
-		if (path &&
-		    ((strcmp(path, stats[i].f_mntonname) != 0) &&
-		     (strcmp(path, stats[i].f_mntfromname) != 0)))
+		if (rpath &&
+		    ((strcmp(rpath, stats[i].f_mntonname) != 0) &&
+		     (strcmp(rpath, stats[i].f_mntfromname) != 0)))
 			continue;
 		/* TODO: external log and realtime device? */
 		(void) fs_table_insert(stats[i].f_mntonname, 0,
 					FS_MOUNT_POINT, stats[i].f_mntfromname,
 					NULL, NULL);
-		if (path) {
+		if (rpath) {
 			found = 1;
 			break;
 		}
 	}
-	if (path && !found)
-		error = ENXIO;
+	if (rpath) {
+		free(rpath);
+		if (!found)
+			error = ENXIO;
+	}
 
 	return error;
 }
-- 
1.7.10.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
