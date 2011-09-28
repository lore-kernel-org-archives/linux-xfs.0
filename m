Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SBieah105770 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 06:44:40 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 2/2] xfsprogs: xfs_quota: kill local variable "type" from
	free_f()
Date: Wed, 28 Sep 2011 06:44:34 -0500
Message-Id: <ccff8f308fbc7e15e9a74f28b5eb98490a0e3c82.1317210237.git.aelder@sgi.com>
In-Reply-To: <1317210274-13086-1-git-send-email-aelder@sgi.com>
References: <1317210274-13086-1-git-send-email-aelder@sgi.com>
In-Reply-To: <a14d653e8a238b3207c5076eb6e6f3358e433422.1317210237.git.aelder@sgi.com>
References: <a14d653e8a238b3207c5076eb6e6f3358e433422.1317210237.git.aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>

Only one value is ever really used for the  "type" variable in
free_f(), and it indicates that either type of entry in fs_table
is wanted.  Just get rid of the variable and make use of the
ability to provide 0 to free_space_list() to indicate that.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 quota/free.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/quota/free.c b/quota/free.c
index 71a7cb2..79b52e9 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -297,14 +297,13 @@ static void
 free_space_list(
 	FILE			*fp,
 	uint			form,
-	uint			type,
 	char			*dir,
 	uint			flags)
 {
 	fs_cursor_t		cursor;
 	fs_path_t		*path;
 
-	fs_cursor_initialise(dir, type, &cursor);
+	fs_cursor_initialise(dir, 0, &cursor);
 	while ((path = fs_cursor_next_entry(&cursor))) {
 		if (free_space(fp, form, path, flags))
 			flags |= NO_HEADER_FLAG;
@@ -318,7 +317,7 @@ free_f(
 {
 	FILE		*fp = NULL;
 	char		*fname = NULL;
-	int		c, flags = 0, form = 0, type = 0;
+	int		c, flags = 0, form = 0;
 
 	while ((c = getopt(argc, argv, "bf:hNir")) != EOF) {
 		switch (c) {
@@ -348,16 +347,13 @@ free_f(
 	if (!form)
 		form = XFS_BLOCK_QUOTA;
 
-	if (!type)
-		type = FS_MOUNT_POINT|FS_PROJECT_PATH;
-
 	if ((fp = fopen_write_secure(fname)) == NULL)
 		return 0;
 
 	if (argc == optind)
-		free_space_list(fp, form, type, NULL, flags);
+		free_space_list(fp, form, NULL, flags);
 	else while (argc > optind)
-		free_space_list(fp, form, type, argv[optind++], flags);
+		free_space_list(fp, form, argv[optind++], flags);
 
 	if (fname)
 		fclose(fp);
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
