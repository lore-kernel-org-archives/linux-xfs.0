Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfCDVbj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Mar 2019 16:31:39 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9787A8667B
        for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2019 21:31:39 +0000 (UTC)
Received: from dell-r730-011.dsal.lab.eng.rdu2.redhat.com (dell-r730-011.dsal.lab.eng.rdu2.redhat.com [10.1.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D01F1949C
        for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2019 21:31:39 +0000 (UTC)
From: tgill@redhat.com
Subject: [PATCH] Add xfs_only flag to fs_table_initialise_mounts() function
Date: Mon,  4 Mar 2019 16:31:24 -0500
Message-Id: <20190304213124.552-1-tgill@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Todd Gill <tgill@redhat.com>

The xfs_only flag will allow the caller to request only XFS filesystems are
added to the fs table.

For commands that are XFS specific (xfs_fsr, xfs_growfs, xfs_scrub) - pass
the flag as 1.

The change avoids a hang when remote filesystem (like NFS) are non
responsive.

Signed-off-by: Todd Gill <tgill@redhat.com>
---
 fsr/xfs_fsr.c       |  2 +-
 growfs/xfs_growfs.c |  2 +-
 include/path.h      |  2 +-
 io/fsmap.c          |  2 +-
 io/init.c           |  2 +-
 io/parent.c         |  2 +-
 libfrog/paths.c     | 20 +++++++++++++-------
 quota/init.c        |  2 +-
 scrub/xfs_scrub.c   |  2 +-
 spaceman/init.c     |  2 +-
 10 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index fef6262c..ea0b1167 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -247,7 +247,7 @@ main(int argc, char **argv)
 	RealUid = getuid();
 
 	pagesize = getpagesize();
-	fs_table_initialise(0, NULL, 0, NULL);
+	fs_table_initialise(0, NULL, 0, NULL, 1);
 	if (optind < argc) {
 		for (; optind < argc; optind++) {
 			argname = argv[optind];
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 2af7e5ba..b4855b6d 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -131,7 +131,7 @@ main(int argc, char **argv)
 	if (dflag + lflag + rflag + mflag == 0)
 		aflag = 1;
 
-	fs_table_initialise(0, NULL, 0, NULL);
+	fs_table_initialise(0, NULL, 0, NULL, 1);
 
 	if (!realpath(argv[optind], rpath)) {
 		fprintf(stderr, _("%s: path resolution failed for %s: %s\n"),
diff --git a/include/path.h b/include/path.h
index 2d6c3c53..580048a6 100644
--- a/include/path.h
+++ b/include/path.h
@@ -37,7 +37,7 @@ extern fs_path_t *fs_table;	/* array of entries in fs table  */
 extern fs_path_t *fs_path;	/* current entry in the fs table */
 extern char *mtab_file;
 
-extern void fs_table_initialise(int, char *[], int, char *[]);
+extern void fs_table_initialise(int, char *[], int, char *[], int);
 extern void fs_table_destroy(void);
 
 extern void fs_table_insert_project_path(char *__dir, uint __projid);
diff --git a/io/fsmap.c b/io/fsmap.c
index 477c36fc..53528361 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -518,7 +518,7 @@ fsmap_f(
 	 * (We report AG number/block for data device extents on XFS).
 	 */
 	if (!tab_init) {
-		fs_table_initialise(0, NULL, 0, NULL);
+		fs_table_initialise(0, NULL, 0, NULL, 0);
 		tab_init = true;
 	}
 	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
diff --git a/io/init.c b/io/init.c
index 83f08f2d..8ed3b47c 100644
--- a/io/init.c
+++ b/io/init.c
@@ -144,7 +144,7 @@ init(
 	pagesize = getpagesize();
 	gettimeofday(&stopwatch, NULL);
 
-	fs_table_initialise(0, NULL, 0, NULL);
+	fs_table_initialise(0, NULL, 0, NULL, 0);
 	while ((c = getopt(argc, argv, "ac:C:dFfiLm:p:PnrRstTVx")) != EOF) {
 		switch (c) {
 		case 'a':
diff --git a/io/parent.c b/io/parent.c
index ffa55f6d..3e321be4 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -369,7 +369,7 @@ parent_f(int argc, char **argv)
 
 	if (!tab_init) {
 		tab_init = 1;
-		fs_table_initialise(0, NULL, 0, NULL);
+		fs_table_initialise(0, NULL, 0, NULL, 0);
 	}
 	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
 	if (!fs) {
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 6e266654..f4d0a61e 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -363,7 +363,8 @@ out_nomem:
  */
 static int
 fs_table_initialise_mounts(
-	char		*path)
+	char		*path,
+	int			xfs_only)
 {
 	struct mntent	*mnt;
 	FILE		*mtp;
@@ -389,6 +390,8 @@ fs_table_initialise_mounts(
 			return errno;
 
 	while ((mnt = getmntent(mtp)) != NULL) {
+		if (xfs_only && strcmp(mnt->mnt_type, "xfs") != 0)
+			continue;
 		if (!realpath(mnt->mnt_dir, rmnt_dir))
 			continue;
 		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
@@ -443,11 +446,12 @@ fs_mount_point_from_path(
 
 static void
 fs_table_insert_mount(
-	char		*mount)
+	char		*mount,
+	int			xfs_only)
 {
 	int		error;
 
-	error = fs_table_initialise_mounts(mount);
+	error = fs_table_initialise_mounts(mount, xfs_only);
 	if (error)
 		fprintf(stderr, _("%s: cannot setup path for mount %s: %s\n"),
 			progname, mount, strerror(error));
@@ -508,23 +512,25 @@ fs_table_insert_project(
  * projects.  If mount_count is zero, mounts is ignored and the
  * table is populated with mounted filesystems.  If project_count is
  * zero, projects is ignored and the table is populated with all
- * projects defined in the projects file.
+ * projects defined in the projects file.  If xfs_only is 1, filter
+ * out non-XFS filesystems.
  */
 void
 fs_table_initialise(
 	int	mount_count,
 	char	*mounts[],
 	int	project_count,
-	char	*projects[])
+	char	*projects[],
+	int	xfs_only)
 {
 	int	error;
 	int	i;
 
 	if (mount_count) {
 		for (i = 0; i < mount_count; i++)
-			fs_table_insert_mount(mounts[i]);
+			fs_table_insert_mount(mounts[i], xfs_only);
 	} else {
-		error = fs_table_initialise_mounts(NULL);
+		error = fs_table_initialise_mounts(NULL, xfs_only);
 		if (error)
 			goto out_error;
 	}
diff --git a/quota/init.c b/quota/init.c
index 8244e38d..06ac3d0f 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -174,7 +174,7 @@ init(
 		}
 	}
 
-	fs_table_initialise(argc - optind, &argv[optind], nprojopts, projopts);
+	fs_table_initialise(argc - optind, &argv[optind], nprojopts, projopts, 0);
 	free(projopts);
 
 	init_commands();
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index b8138000..3da606bc 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -705,7 +705,7 @@ main(
 			mtab = _PATH_MOUNTED;
 	}
 
-	fs_table_initialise(0, NULL, 0, NULL);
+	fs_table_initialise(0, NULL, 0, NULL, 1);
 	fsp = fs_table_lookup_mount(ctx.mntpoint);
 	if (!fsp) {
 		fprintf(stderr, _("%s: Not a XFS mount point.\n"),
diff --git a/spaceman/init.c b/spaceman/init.c
index 181a3446..30d98c8f 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -68,7 +68,7 @@ init(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	fs_table_initialise(0, NULL, 0, NULL);
+	fs_table_initialise(0, NULL, 0, NULL, 0);
 	while ((c = getopt(argc, argv, "c:p:V")) != EOF) {
 		switch (c) {
 		case 'c':
-- 
2.17.2
