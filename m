Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBFJTuVi032159
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 13:29:56 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41E66218A7
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 11:29:47 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id DfwCErQrTIA8oJXo for
	<linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 11:29:47 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH 6/6] xfs_quota: Fix range for -U.
Date: Mon, 15 Dec 2008 20:29:46 +0100
Message-Id: <1229369386-66312-6-git-send-email-arekm@maven.pl>
In-Reply-To: <1229369386-66312-5-git-send-email-arekm@maven.pl>
References: <1229369386-66312-1-git-send-email-arekm@maven.pl>
	<1229369386-66312-2-git-send-email-arekm@maven.pl>
	<1229369386-66312-3-git-send-email-arekm@maven.pl>
	<1229369386-66312-4-git-send-email-arekm@maven.pl>
	<1229369386-66312-5-git-send-email-arekm@maven.pl>
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

xfs_quota report "-L" option specifies lower range of requested IDs.
"-U" specifies upper range but "-L" is closed range while "-U" is open
range.

Make "-U" closed range, too which is something more expected.
---
 xfsprogs/quota/report.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/xfsprogs/quota/report.c b/xfsprogs/quota/report.c
index 21b4edb..2184158 100644
--- a/xfsprogs/quota/report.c
+++ b/xfsprogs/quota/report.c
@@ -124,7 +124,7 @@ dump_limits_any_type(
 	}
 
 	if (upper) {
-		for (id = lower; id < upper; id++)
+		for (id = lower; id <= upper; id++)
 			dump_file(fp, id, type, mount->fs_name);
 		return;
 	}
@@ -398,7 +398,7 @@ report_user_mount(
 	uint		id;
 
 	if (upper) {	/* identifier range specified */
-		for (id = lower; id < upper; id++) {
+		for (id = lower; id <= upper; id++) {
 			snprintf(n, sizeof(n)-1, "#%u", id);
 			if (report_mount(fp, id, n,
 					form, XFS_USER_QUOTA, mount, flags))
@@ -436,7 +436,7 @@ report_group_mount(
 	uint		id;
 
 	if (upper) {	/* identifier range specified */
-		for (id = lower; id < upper; id++) {
+		for (id = lower; id <= upper; id++) {
 			snprintf(n, sizeof(n)-1, "#%u", id);
 			if (report_mount(fp, id, n,
 					form, XFS_GROUP_QUOTA, mount, flags))
@@ -473,7 +473,7 @@ report_project_mount(
 	uint		id;
 
 	if (upper) {	/* identifier range specified */
-		for (id = lower; id < upper; id++) {
+		for (id = lower; id <= upper; id++) {
 			snprintf(n, sizeof(n)-1, "#%u", id);
 			if (report_mount(fp, id, n,
 					form, XFS_PROJ_QUOTA, mount, flags))
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
