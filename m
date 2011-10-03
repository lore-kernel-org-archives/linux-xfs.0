Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93CnMCt241622 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 07:49:22 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 3/6] xfsprogs: libxcmd: encapsulate fs_table initialization
Date: Mon,  3 Oct 2011 07:49:17 -0500
Message-Id: <88405c2d80277cf7acaf03e31a378d8776a0c5b8.1317646036.git.aelder@sgi.com>
In-Reply-To: <1317646160-5437-1-git-send-email-aelder@sgi.com>
References: <1317646160-5437-1-git-send-email-aelder@sgi.com>
In-Reply-To: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
References: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
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

Change fs_table_initialise() so it takes an array of mount points
and an array of project identifiers as arguments (along with their
respective sizes).

Change the quota code to provide fs_table_initialise() these arrays
rather than doing the individual mount point and project insertion
by itself.  Other users just pass 0 counts, which results in filling
fs_table with entries for all mounted filesystems and all defined
projects.

This allows a few fs_table functions to be given private scope.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 growfs/xfs_growfs.c |    2 +-
 include/path.h      |    4 +---
 io/parent.c         |    2 +-
 libxcmd/paths.c     |   49 ++++++++++++++++++++++++++++++++++++++-----------
 quota/init.c        |   15 ++-------------
 5 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 98ce5df..a6d298b 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -193,7 +193,7 @@ main(int argc, char **argv)
 	if (dflag + lflag + rflag == 0)
 		aflag = 1;
 
-	fs_table_initialise();
+	fs_table_initialise(0, NULL, 0, NULL);
 	fs = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
 	if (!fs) {
 		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
diff --git a/include/path.h b/include/path.h
index b8c8b31..757ba49 100644
--- a/include/path.h
+++ b/include/path.h
@@ -47,11 +47,9 @@ extern fs_path_t *fs_table;	/* array of entries in fs table  */
 extern fs_path_t *fs_path;	/* current entry in the fs table */
 extern char *mtab_file;
 
-extern void fs_table_initialise(void);
+extern void fs_table_initialise(int, char *[], int, char *[]);
 extern void fs_table_destroy(void);
 
-extern void fs_table_insert_mount(char *__mount);
-extern void fs_table_insert_project(char *__project);
 extern void fs_table_insert_project_path(char *__dir, uint __projid);
 
 
diff --git a/io/parent.c b/io/parent.c
index 5d356e6..47faaa0 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -377,7 +377,7 @@ parent_f(int argc, char **argv)
 
 	if (!tab_init) {
 		tab_init = 1;
-		fs_table_initialise();
+		fs_table_initialise(0, NULL, 0, NULL);
 	}
 	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
 	if (!fs) {
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index ed93110..755307e 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -365,7 +365,7 @@ fs_mount_point_from_path(
 	return fs;
 }
 
-void
+static void
 fs_table_insert_mount(
 	char		*mount)
 {
@@ -424,7 +424,7 @@ fs_table_initialise_projects(
 	return error;
 }
 
-void
+static void
 fs_table_insert_project(
 	char		*project)
 {
@@ -444,20 +444,47 @@ fs_table_insert_project(
 	}
 }
 
+/*
+ * Initialize fs_table to contain the given set of mount points and
+ * projects.  If mount_count is zero, mounts is ignored and the
+ * table is populated with mounted filesystems.  If project_count is
+ * zero, projects is ignored and the table is populated with all
+ * projects defined in the projects file.
+ */
 void
-fs_table_initialise(void)
+fs_table_initialise(
+	int	mount_count,
+	char	*mounts[],
+	int	project_count,
+	char	*projects[])
 {
-	int		error;
+	int	error;
+	int	i;
 
-	error = fs_table_initialise_mounts(NULL);
-	if (!error)
+	if (mount_count) {
+		for (i = 0; i < mount_count; i++)
+			fs_table_insert_mount(mounts[i]);
+	} else {
+		error = fs_table_initialise_mounts(NULL);
+		if (error)
+			goto out_exit;
+	}
+	if (project_count) {
+		for (i = 0; i < project_count; i++)
+			fs_table_insert_project(projects[i]);
+	} else {
 		error = fs_table_initialise_projects(NULL);
-	if (error) {
-		fs_table_destroy();
-		fprintf(stderr, _("%s: cannot initialise path table: %s\n"),
-			progname, strerror(error));
-		exit(1);
+		if (error)
+			goto out_exit;
 	}
+
+	return;
+
+out_exit:
+	fs_table_destroy();
+	fprintf(stderr, _("%s: cannot initialise path table: %s\n"),
+		progname, strerror(error));
+	exit(1);
 }
 
 void 
diff --git a/quota/init.c b/quota/init.c
index 96b6389..3293b90 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -135,19 +135,8 @@ init(
 		}
 	}
 
-	if (optind == argc) {
-		fs_table_initialise();
-	} else {
-		while (optind < argc)
-			fs_table_insert_mount(argv[optind++]);
-		if (!nprojopts)
-			fs_table_insert_project(NULL);
-		else
-			for (c = 0; c < nprojopts; c++)
-				fs_table_insert_project(projopts[c]);
-	}
-	if (projopts)
-		free(projopts);
+	fs_table_initialise(argc - optind, &argv[optind], nprojopts, projopts);
+	free(projopts);
 
 	init_commands();
 	add_args_command(init_args_command);
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
