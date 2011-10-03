Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93CnPFP241642 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 07:49:25 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 1/6] xfsprogs: libxcmd: rearrange some routines
Date: Mon,  3 Oct 2011 07:49:15 -0500
Message-Id: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
In-Reply-To: <1317646160-5437-1-git-send-email-aelder@sgi.com>
References: <1317646160-5437-1-git-send-email-aelder@sgi.com>
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

Move the definition of a few routines around in the file to avoid
forward references in upcoming patches.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |  162 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 82 insertions(+), 80 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 1e78099..ae9db32 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -143,6 +143,59 @@ fs_table_destroy(void)
 	fs_count = 0;
 }
 
+/*
+ * Table iteration (cursor-based) interfaces
+ */
+
+/*
+ * Initialize an fs_table cursor.  If a directory path is supplied,
+ * the cursor is set up to appear as though the table contains only
+ * a single entry which represents the directory specified.
+ * Otherwise it is set up to prepare for visiting all entries in the
+ * global table, starting with the first.  "flags" can be either
+ * FS_MOUNT_POINT or FS_PROJECT_PATH to limit what type of entries
+ * will be selected by fs_cursor_next_entry().  0 can be used as a
+ * wild card (selecting either type).
+ */
+void
+fs_cursor_initialise(
+	char		*dir,
+	uint		flags,
+	fs_cursor_t	*cur)
+{
+	fs_path_t	*path;
+
+	memset(cur, 0, sizeof(*cur));
+	if (dir) {
+		if ((path = fs_table_lookup(dir, flags)) == NULL)
+			return;
+		cur->local = *path;
+		cur->count = 1;
+		cur->table = &cur->local;
+	} else {
+		cur->count = fs_count;
+		cur->table = fs_table;
+	}
+	cur->flags = flags;
+}
+
+/*
+ * Use the cursor to find the next entry in the table having the
+ * type specified by the cursor's "flags" field.
+ */
+struct fs_path *
+fs_cursor_next_entry(
+	fs_cursor_t	*cur)
+{
+	while (cur->index < cur->count) {
+		fs_path_t	*next = &cur->table[cur->index++];
+
+		if (!cur->flags || (cur->flags & next->fs_flags))
+			return next;
+	}
+	return NULL;
+}
+
 
 #if defined(HAVE_GETMNTENT)
 #include <mntent.h>
@@ -303,6 +356,21 @@ fs_mount_point_from_path(
 	return fs;
 }
 
+void
+fs_table_insert_mount(
+	char		*mount)
+{
+	int		error;
+
+	error = fs_table_initialise_mounts(mount);
+	if (error) {
+		fs_table_destroy();
+		fprintf(stderr, _("%s: cannot setup path for mount %s: %s\n"),
+			progname, mount, strerror(error));
+		exit(1);
+	}
+}
+
 static int
 fs_table_initialise_projects(
 	char		*project)
@@ -348,52 +416,37 @@ fs_table_initialise_projects(
 }
 
 void
-fs_table_initialise(void)
+fs_table_insert_project(
+	char		*project)
 {
 	int		error;
 
-	error = fs_table_initialise_mounts(NULL);
-	if (!error)
-		error = fs_table_initialise_projects(NULL);
-	if (error) {
-		fs_table_destroy();
-		fprintf(stderr, _("%s: cannot initialise path table: %s\n"),
-			progname, strerror(error));
+	if (!fs_count) {
+		fprintf(stderr, _("%s: no mount table yet, so no projects\n"),
+			progname);
 		exit(1);
 	}
-}
-
-void
-fs_table_insert_mount(
-	char		*mount)
-{
-	int		error;
-
-	error = fs_table_initialise_mounts(mount);
+	error = fs_table_initialise_projects(project);
 	if (error) {
 		fs_table_destroy();
-		fprintf(stderr, _("%s: cannot setup path for mount %s: %s\n"),
-			progname, mount, strerror(error));
+		fprintf(stderr, _("%s: cannot setup path for project %s: %s\n"),
+			progname, project, strerror(error));
 		exit(1);
 	}
 }
 
 void
-fs_table_insert_project(
-	char		*project)
+fs_table_initialise(void)
 {
 	int		error;
 
-	if (!fs_count) {
-		fprintf(stderr, _("%s: no mount table yet, so no projects\n"),
-			progname);
-		exit(1);
-	}
-	error = fs_table_initialise_projects(project);
+	error = fs_table_initialise_mounts(NULL);
+	if (!error)
+		error = fs_table_initialise_projects(NULL);
 	if (error) {
 		fs_table_destroy();
-		fprintf(stderr, _("%s: cannot setup path for project %s: %s\n"),
-			progname, project, strerror(error));
+		fprintf(stderr, _("%s: cannot initialise path table: %s\n"),
+			progname, strerror(error));
 		exit(1);
 	}
 }
@@ -428,55 +481,4 @@ fs_table_insert_project_path(
 		exit(1);
 	}
 }
-/*
- * Table iteration (cursor-based) interfaces
- */
 
-/*
- * Initialize an fs_table cursor.  If a directory path is supplied,
- * the cursor is set up to appear as though the table contains only
- * a single entry which represents the directory specified.
- * Otherwise it is set up to prepare for visiting all entries in the
- * global table, starting with the first.  "flags" can be either
- * FS_MOUNT_POINT or FS_PROJECT_PATH to limit what type of entries
- * will be selected by fs_cursor_next_entry().  0 can be used as a
- * wild card (selecting either type).
- */
-void
-fs_cursor_initialise(
-	char		*dir,
-	uint		flags,
-	fs_cursor_t	*cur)
-{
-	fs_path_t	*path;
-
-	memset(cur, 0, sizeof(*cur));
-	if (dir) {
-		if ((path = fs_table_lookup(dir, flags)) == NULL)
-			return;
-		cur->local = *path;
-		cur->count = 1;
-		cur->table = &cur->local;
-	} else {
-		cur->count = fs_count;
-		cur->table = fs_table;
-	}
-	cur->flags = flags;
-}
-
-/*
- * Use the cursor to find the next entry in the table having the
- * type specified by the cursor's "flags" field.
- */
-struct fs_path *
-fs_cursor_next_entry(
-	fs_cursor_t	*cur)
-{
-	while (cur->index < cur->count) {
-		fs_path_t	*next = &cur->table[cur->index++];
-
-		if (!cur->flags || (cur->flags & next->fs_flags))
-			return next;
-	}
-	return NULL;
-}
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
