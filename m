Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93CnQjn241657 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 07:49:26 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 5/6] xfsprogs: libxcmd: avoid exiting when an error occurs
Date: Mon,  3 Oct 2011 07:49:19 -0500
Message-Id: <1b5744a656cb33ea84e6646c69d8d2d711e25fd0.1317646036.git.aelder@sgi.com>
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

In a number of spots handling setting up fs_table, libxcmd simply
prints a message and exits if an error occurs.  There should be no
real need to exit in these cases.  Notifying the user that something
went wrong is appropriate but this should not preclude continued
operation.  In a few cases the contents of fs_table built up so far
are discarded as well, and this too can be avoided.

Make it so errors do not lead to exits, nor do they result in
destroying fs_table.  Doing this requires returning a value from
fs_extract_mount_options() so its caller can skip other processing
in this case.  But in most cases we simply no longer exit, and no
longer destroy the fs_table.  This means there is no more use for
fs_table_destroy(), so it can be removed.

There is a sort of short-circuit exit in fs_table_insert_project()
that is unnecessary as well, so get rid of it.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   66 ++++++++++++++++--------------------------------------
 1 files changed, 20 insertions(+), 46 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 13873ef..a6adc51 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -154,23 +154,6 @@ out_nodev:
 	return error;
 }
 
-void
-fs_table_destroy(void)
-{
-	while (--fs_count >= 0) {
-		free(fs_table[fs_count].fs_name);
-		if (fs_table[fs_count].fs_log)
-			free(fs_table[fs_count].fs_log);
-		if (fs_table[fs_count].fs_rt)
-			free(fs_table[fs_count].fs_rt);
-		free(fs_table[fs_count].fs_dir);
-	}
-	if (fs_table)
-		free(fs_table);
-	fs_table = NULL;
-	fs_count = 0;
-}
-
 /*
  * Table iteration (cursor-based) interfaces
  */
@@ -236,7 +219,7 @@ fs_cursor_next_entry(
  * present.  Note that the path buffers returned are allocated
  * dynamically and it is the caller's responsibility to free them.
  */
-static void
+static int
 fs_extract_mount_options(
 	struct mntent	*mnt,
 	char		**logp,
@@ -253,24 +236,27 @@ fs_extract_mount_options(
 	/* Do this only after we've finished processing mount options */
 	if (fslog) {
 		fslog = strndup(fslog, strcspn(fslog, " ,"));
-		if (!fslog) {
-			fprintf(stderr, _("%s: %s: out of memory (fslog)\n"),
-				    progname, __func__);
-			exit(1);
-		}
+		if (!fslog)
+			goto out_nomem;
 	}
 	if (fsrt) {
 		fsrt = strndup(fsrt, strcspn(fsrt, " ,"));
 		if (!fsrt) {
-			fprintf(stderr, _("%s: %s: out of memory (fsrt)\n"),
-				    progname, __func__);
 			free(fslog);
-			exit(1);
+			goto out_nomem;
 		}
 	}
-
 	*logp = fslog;
 	*rtp = fsrt;
+
+	return 0;
+
+out_nomem:
+	*logp = NULL;
+	*rtp = NULL;
+	fprintf(stderr, _("%s: unable to extract mount options for \"%s\"\n"),
+		progname, mnt->mnt_dir);
+	return ENOMEM;
 }
 
 static int
@@ -302,7 +288,8 @@ fs_table_initialise_mounts(
 		     (strcmp(path, mnt->mnt_fsname) != 0)))
 			continue;
 		found = 1;
-		fs_extract_mount_options(mnt, &fslog, &fsrt);
+		if (fs_extract_mount_options(mnt, &fslog, &fsrt))
+			continue;
 		error = fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
 					mnt->mnt_fsname, fslog, fsrt);
 		if (error)
@@ -386,12 +373,9 @@ fs_table_insert_mount(
 	int		error;
 
 	error = fs_table_initialise_mounts(mount);
-	if (error) {
-		fs_table_destroy();
+	if (error)
 		fprintf(stderr, _("%s: cannot setup path for mount %s: %s\n"),
 			progname, mount, strerror(error));
-		exit(1);
-	}
 }
 
 static int
@@ -436,18 +420,10 @@ fs_table_insert_project(
 {
 	int		error;
 
-	if (!fs_count) {
-		fprintf(stderr, _("%s: no mount table yet, so no projects\n"),
-			progname);
-		exit(1);
-	}
 	error = fs_table_initialise_projects(project);
-	if (error) {
-		fs_table_destroy();
+	if (error)
 		fprintf(stderr, _("%s: cannot setup path for project %s: %s\n"),
 			progname, project, strerror(error));
-		exit(1);
-	}
 }
 
 /*
@@ -473,7 +449,7 @@ fs_table_initialise(
 	} else {
 		error = fs_table_initialise_mounts(NULL);
 		if (error)
-			goto out_exit;
+			goto out_error;
 	}
 	if (project_count) {
 		for (i = 0; i < project_count; i++)
@@ -481,16 +457,14 @@ fs_table_initialise(
 	} else {
 		error = fs_table_initialise_projects(NULL);
 		if (error)
-			goto out_exit;
+			goto out_error;
 	}
 
 	return;
 
-out_exit:
-	fs_table_destroy();
+out_error:
 	fprintf(stderr, _("%s: cannot initialise path table: %s\n"),
 		progname, strerror(error));
-	exit(1);
 }
 
 void 
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
