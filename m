Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93CnQm5241673 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 07:49:26 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 4/6] xfsprogs: libxcmd: isolate strdup() calls to
	fs_table_insert()
Date: Mon,  3 Oct 2011 07:49:18 -0500
Message-Id: <0f871eebf39384818415253082320f860739f113.1317646036.git.aelder@sgi.com>
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

Calls to fs_table_insert() are made in four places, and in all four
the mount directory and device name arguments passed are the result
of calls to strdup().  Rather than have all the callers handle
allocating and freeing of these strings, consolidate that into
fs_table_insert().

Only one place passes non-null values for the fslog and fsrt
arguments, and in that case it's easier to keep the allocation of
duplicate strings where they are in the caller.  Add a comment in
fs_table_insert() to ensure that's understood.

Note also that fs_table_insert() is always called with both its
dir and fsname arguments non-null, so drop a check for that at
the top of the function.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |  138 +++++++++++++++++++++++++++----------------------------
 1 files changed, 67 insertions(+), 71 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 755307e..13873ef 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -95,21 +95,37 @@ fs_table_insert(
 {
 	dev_t		datadev, logdev, rtdev;
 	struct fs_path	*tmp_fs_table;
-
-	if (!dir || !fsname)
-		return EINVAL;
+	int		error;
 
 	datadev = logdev = rtdev = 0;
-	if (fs_device_number(dir, &datadev))
-		return errno;
-	if (fslog && fs_device_number(fslog, &logdev))
-		return errno;
-	if (fsrt && fs_device_number(fsrt, &rtdev))
-		return errno;
+	error = fs_device_number(dir, &datadev);
+	if (error)
+		goto out_nodev;
+	if (fslog && (error = fs_device_number(fslog, &logdev)))
+		goto out_nodev;
+	if (fsrt && (error = fs_device_number(fsrt, &rtdev)))
+		goto out_nodev;
+
+	/*
+	 * Make copies of the directory and data device path.
+	 * The log device and real-time device, if non-null,
+	 * are already the result of strdup() calls so we
+	 * don't need to duplicate those.  In fact, this
+	 * function is assumed to "consume" both of those
+	 * pointers, meaning if an error occurs they will
+	 * both get freed.
+	 */
+	error = ENOMEM;
+	dir = strdup(dir);
+	if (!dir)
+		goto out_nodev;
+	fsname = strdup(fsname);
+	if (!fsname)
+		goto out_noname;
 
 	tmp_fs_table = realloc(fs_table, sizeof(fs_path_t) * (fs_count + 1));
 	if (!tmp_fs_table)
-		return ENOMEM;
+		goto out_norealloc;
 	fs_table = tmp_fs_table;
 
 	fs_path = &fs_table[fs_count];
@@ -123,7 +139,19 @@ fs_table_insert(
 	fs_path->fs_logdev = logdev;
 	fs_path->fs_rtdev = rtdev;
 	fs_count++;
+
 	return 0;
+
+out_norealloc:
+	free(fsname);
+out_noname:
+	free(dir);
+out_nodev:
+	/* "Consume" fslog and fsrt even if there's an error */
+	free(fslog);
+	free(fsrt);
+
+	return error;
 }
 
 void
@@ -200,6 +228,14 @@ fs_cursor_next_entry(
 #if defined(HAVE_GETMNTENT)
 #include <mntent.h>
 
+/*
+ * Determines whether the "logdev" or "rtdev" mount options are
+ * present for the given mount point.  If so, the value for each (a
+ * device path) is returned in the pointers whose addresses are
+ * provided.  The pointers are assigned NULL for an option not
+ * present.  Note that the path buffers returned are allocated
+ * dynamically and it is the caller's responsibility to free them.
+ */
 static void
 fs_extract_mount_options(
 	struct mntent	*mnt,
@@ -243,11 +279,11 @@ fs_table_initialise_mounts(
 {
 	struct mntent	*mnt;
 	FILE		*mtp;
-	char		*dir, *fsname, *fslog, *fsrt;
+	char		*fslog, *fsrt;
 	int		error, found;
 
 	error = found = 0;
-	dir = fsname = fslog = fsrt = NULL;
+	fslog = fsrt = NULL;
 
 	if (!mtab_file) {
 		mtab_file = PROC_MOUNTS;
@@ -266,26 +302,16 @@ fs_table_initialise_mounts(
 		     (strcmp(path, mnt->mnt_fsname) != 0)))
 			continue;
 		found = 1;
-		dir = strdup(mnt->mnt_dir);
-		fsname = strdup(mnt->mnt_fsname);
-		if (!dir || !fsname) {
-			error = ENOMEM;
-			break;
-		}
 		fs_extract_mount_options(mnt, &fslog, &fsrt);
-		if ((error = fs_table_insert(dir, 0, FS_MOUNT_POINT,
-						fsname, fslog, fsrt)))
+		error = fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
+					mnt->mnt_fsname, fslog, fsrt);
+		if (error)
 			break;
 	}
 	endmntent(mtp);
 	if (!error && path && !found)
 		error = ENXIO;
-	if (error) {
-		if (dir) free(dir);
-		if (fsrt) free(fsrt);
-		if (fslog) free(fslog);
-		if (fsname) free(fsname);
-	}
+
 	return error;
 }
 
@@ -297,12 +323,9 @@ fs_table_initialise_mounts(
 	char		*path)
 {
 	struct statfs	*stats;
-	char		*dir, *fsname, *fslog, *fsrt;
 	int		i, count, error, found;
 
 	error = found = 0;
-	dir = fsname = fslog = fsrt = NULL;
-
 	if ((count = getmntinfo(&stats, 0)) < 0) {
 		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
 				progname, strerror(errno));
@@ -317,25 +340,16 @@ fs_table_initialise_mounts(
 		     (strcmp(path, stats[i].f_mntfromname) != 0)))
 			continue;
 		found = 1;
-		dir = strdup(stats[i].f_mntonname);
-		fsname = strdup(stats[i].f_mntfromname);
-		if (!dir || !fsname) {
-			error = ENOMEM;
-			break;
-		}
 		/* TODO: external log and realtime device? */
-		if ((error = fs_table_insert(dir, 0, FS_MOUNT_POINT,
-						fsname, fslog, fsrt)))
+		error = fs_table_insert(stats[i].f_mntonname, 0,
+					FS_MOUNT_POINT, stats[i].f_mntfromname,
+					NULL, NULL);
+		if (error)
 			break;
 	}
 	if (!error && path && !found)
 		error = ENXIO;
-	if (error) {
-		if (dir) free(dir);
-		if (fsrt) free(fsrt);
-		if (fslog) free(fslog);
-		if (fsname) free(fsname);
-	}
+
 	return error;
 }
 
@@ -387,7 +401,6 @@ fs_table_initialise_projects(
 	fs_project_path_t *path;
 	fs_path_t	*fs;
 	prid_t		prid = 0;
-	char		*dir = NULL, *fsname = NULL;
 	int		error = 0, found = 0;
 
 	if (project)
@@ -403,24 +416,17 @@ fs_table_initialise_projects(
 			continue;
 		}
 		found = 1;
-		dir = strdup(path->pp_pathname);
-		fsname = strdup(fs->fs_name);
-		if (!dir || !fsname) {
-			error = ENOMEM;
-			break;
-		}
-		if ((error = fs_table_insert(dir, path->pp_prid,
-					FS_PROJECT_PATH, fsname, NULL, NULL)))
+		error = fs_table_insert(path->pp_pathname, path->pp_prid,
+					FS_PROJECT_PATH, fs->fs_name,
+					NULL, NULL);
+		if (error)
 			break;
 	}
 	endprpathent();
 
 	if (!error && project && !found)
 		error = ENOENT;
-	if (error) {
-		if (dir) free(dir);
-		if (fsname) free(fsname);
-	}
+
 	return error;
 }
 
@@ -489,31 +495,21 @@ out_exit:
 
 void 
 fs_table_insert_project_path(
-	char		*udir,
+	char		*dir,
 	prid_t		prid)
 {
 	fs_path_t	*fs;
-	char		*dir = NULL, *fsname = NULL;
 	int		error = 0;
 
-	if ((fs = fs_mount_point_from_path(udir)) != NULL) {
-		dir = strdup(udir);
-		fsname = strdup(fs->fs_name);
-		if (dir && fsname)
-			error = fs_table_insert(dir, prid,
-					FS_PROJECT_PATH, fsname, NULL, NULL);
-		else
-			error = ENOMEM;
+	if ((fs = fs_mount_point_from_path(dir)) != NULL) {
+		error = fs_table_insert(dir, prid, FS_PROJECT_PATH,
+					fs->fs_name, NULL, NULL);
 	} else
 		error = ENOENT;
 
 	if (error) {
-		if (dir)
-			free(dir);
-		if (fsname)
-			free(fsname);
 		fprintf(stderr, _("%s: cannot setup path for project dir %s: %s\n"),
-				progname, udir, strerror(error));
+				progname, dir, strerror(error));
 		exit(1);
 	}
 }
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
