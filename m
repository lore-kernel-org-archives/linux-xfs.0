Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG7rC6Q022690
	for <linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 01:53:12 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26EE9173A68C
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 23:53:09 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id 6ESXeKPFPzRFE0gn for
	<linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 23:53:09 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH] xfs_quota: Don't ignore every error when asking for quota.
Date: Tue, 16 Dec 2008 08:53:08 +0100
Message-Id: <1229413988-212167-1-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Errors from quotactl() were silently ignored like:

$ xfs_quota -x -c "report -u -L 12000 -U 12001"
$

Print error messages for conditions other than ENOENT and ENOSYS
(these two aren't actually errors for the way quotactl is used).

We now get:

$ ./xfs_quota -x -c "report -u -L 12000 -U 12001"  /home
XFS_GETQUOTA: Operation not permitted
XFS_GETQUOTA: Operation not permitted
$

which is consistent with error reporting in rest of quotactl using code.
---
 xfsprogs/quota/report.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/xfsprogs/quota/report.c b/xfsprogs/quota/report.c
index 2184158..73248d0 100644
--- a/xfsprogs/quota/report.c
+++ b/xfsprogs/quota/report.c
@@ -81,8 +81,11 @@ dump_file(
 {
 	fs_disk_quota_t	d;
 
-	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0)
+	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
+		if (errno != ENOENT && errno != ENOSYS)
+			perror("XFS_GETQUOTA");
 		return;
+	}
 	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
 	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
 	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
@@ -298,8 +301,11 @@ report_mount(
 	uint		qflags;
 	int		count;
 
-	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0)
+	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
+		if (errno != ENOENT && errno != ENOSYS)
+			perror("XFS_GETQUOTA");
 		return 0;
+	}
 
 	if (flags & TERSE_FLAG) {
 		count = 0;
@@ -514,8 +520,10 @@ report_any_type(
 	if (type & XFS_USER_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
-			xfsquotactl(XFS_QSYNC, mount->fs_name,
-						XFS_USER_QUOTA, 0, NULL);
+			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
+						XFS_USER_QUOTA, 0, NULL) < 0
+					&& errno != ENOENT && errno != ENOSYS)
+				perror("XFS_QSYNC user quota");
 			report_user_mount(fp, form, mount,
 						lower, upper, flags);
 		}
@@ -523,8 +531,10 @@ report_any_type(
 	if (type & XFS_GROUP_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
-			xfsquotactl(XFS_QSYNC, mount->fs_name,
-						XFS_GROUP_QUOTA, 0, NULL);
+			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
+						XFS_GROUP_QUOTA, 0, NULL) < 0
+					&& errno != ENOENT && errno != ENOSYS)
+				perror("XFS_QSYNC group quota");
 			report_group_mount(fp, form, mount,
 						lower, upper, flags);
 		}
@@ -532,8 +542,10 @@ report_any_type(
 	if (type & XFS_PROJ_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
-			xfsquotactl(XFS_QSYNC, mount->fs_name,
-						XFS_PROJ_QUOTA, 0, NULL);
+			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
+						XFS_PROJ_QUOTA, 0, NULL) < 0
+					&& errno != ENOENT && errno != ENOSYS)
+				perror("XFS_QSYNC proj quota");
 			report_project_mount(fp, form, mount,
 						lower, upper, flags);
 		}
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
