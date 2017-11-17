Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25021 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdKQUOh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:14:37 -0500
Subject: [PATCH 09/12] libfrog: move paths.c out of libxcmd
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:14:31 -0800
Message-ID: <151094967171.29763.2156733816905533240.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the fs_table code into libfrog since it's not really a command.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/Makefile   |   10 +
 libfrog/paths.c    |  586 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/projects.c |  201 ++++++++++++++++++
 libxcmd/Makefile   |   10 -
 libxcmd/paths.c    |  586 ----------------------------------------------------
 libxcmd/projects.c |  201 ------------------
 quota/Makefile     |    4 
 spaceman/Makefile  |    4 
 8 files changed, 802 insertions(+), 800 deletions(-)
 create mode 100644 libfrog/paths.c
 create mode 100644 libfrog/projects.c
 delete mode 100644 libxcmd/paths.c
 delete mode 100644 libxcmd/projects.c


diff --git a/libfrog/Makefile b/libfrog/Makefile
index 467362c..4c15605 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -14,11 +14,21 @@ CFILES = \
 avl64.c \
 convert.c \
 list_sort.c \
+paths.c \
+projects.c \
 radix-tree.c \
 topology.c \
 util.c \
 workqueue.c
 
+ifeq ($(HAVE_GETMNTENT),yes)
+LCFLAGS += -DHAVE_GETMNTENT
+endif
+
+ifeq ($(HAVE_GETMNTINFO),yes)
+LCFLAGS += -DHAVE_GETMNTINFO
+endif
+
 default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
diff --git a/libfrog/paths.c b/libfrog/paths.c
new file mode 100644
index 0000000..b767e9d
--- /dev/null
+++ b/libfrog/paths.c
@@ -0,0 +1,586 @@
+/*
+ * Copyright (c) 2005-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <paths.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include "path.h"
+#include "input.h"
+#include "project.h"
+#include <limits.h>
+
+extern char *progname;
+
+int fs_count;
+int xfs_fs_count;
+struct fs_path *fs_table;
+struct fs_path *fs_path;
+
+char *mtab_file;
+#define PROC_MOUNTS	"/proc/self/mounts"
+
+static int
+fs_device_number(
+	const char	*name,
+	dev_t		*devnum)
+{
+	struct stat	sbuf;
+
+	if (stat(name, &sbuf) < 0)
+		return errno;
+	/*
+	 * We want to match st_rdev if the path provided is a device
+	 * special file.  Otherwise we are looking for the the
+	 * device id for the containing filesystem, in st_dev.
+	 */
+	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode))
+		*devnum = sbuf.st_rdev;
+	else
+		*devnum = sbuf.st_dev;
+
+	return 0;
+}
+
+/*
+ * Find the FS table entry for the given path.  The "flags" argument
+ * is a mask containing FS_MOUNT_POINT or FS_PROJECT_PATH (or both)
+ * to indicate the type of table entry sought.
+ * fs_table_lookup() finds the fs table entry for the filesystem hosting
+ * the file represented in the "dir" argument. To compare against actual
+ * mount point entries, use fs_table_lookup_mount() instead.
+ */
+struct fs_path *
+fs_table_lookup(
+	const char	*dir,
+	uint		flags)
+{
+	uint		i;
+	dev_t		dev = 0;
+
+	if (fs_device_number(dir, &dev))
+		return NULL;
+
+	for (i = 0; i < fs_count; i++) {
+		if (flags && !(flags & fs_table[i].fs_flags))
+			continue;
+		if (fs_table[i].fs_datadev == dev)
+			return &fs_table[i];
+	}
+	return NULL;
+}
+
+/*
+ * Find the FS table entry describing an actual mount for the given path.
+ * Unlike fs_table_lookup(), fs_table_lookup_mount() compares the "dir"
+ * argument to actual mount point entries in the table. Accordingly, it
+ * will find matches only if the "dir" argument is indeed mounted.
+ */
+struct fs_path *
+fs_table_lookup_mount(
+	const char	*dir)
+{
+	uint		i;
+	dev_t		dev = 0;
+	char		rpath[PATH_MAX];
+
+	if (fs_device_number(dir, &dev))
+		return NULL;
+
+	for (i = 0; i < fs_count; i++) {
+		if (fs_table[i].fs_flags != FS_MOUNT_POINT)
+			continue;
+		if (!realpath(fs_table[i].fs_dir, rpath))
+			continue;
+		if (strcmp(rpath, dir) == 0)
+			return &fs_table[i];
+	}
+	return NULL;
+}
+
+static int
+fs_table_insert(
+	char		*dir,
+	uint		prid,
+	uint		flags,
+	char		*fsname,
+	char		*fslog,
+	char		*fsrt)
+{
+	dev_t		datadev, logdev, rtdev;
+	struct fs_path	*tmp_fs_table;
+	int		error;
+
+	datadev = logdev = rtdev = 0;
+	error = fs_device_number(dir, &datadev);
+	if (error)
+		goto out_nodev;
+	if (fslog) {
+		error = fs_device_number(fslog, &logdev);
+		if (error)
+			goto out_nodev;
+	}
+	if (fsrt) {
+		error = fs_device_number(fsrt, &rtdev);
+		if (error)
+			goto out_nodev;
+	}
+
+	if (!platform_test_xfs_path(dir))
+		flags |= FS_FOREIGN;
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
+
+	tmp_fs_table = realloc(fs_table, sizeof(fs_path_t) * (fs_count + 1));
+	if (!tmp_fs_table)
+		goto out_norealloc;
+	fs_table = tmp_fs_table;
+
+	/* Put foreign filesystems at the end, xfs filesystems at the front */
+	if (flags & FS_FOREIGN || fs_count == 0) {
+		fs_path = &fs_table[fs_count];
+	} else {
+		/* move foreign fs entries down, insert new one just before */
+		memmove(&fs_table[xfs_fs_count + 1], &fs_table[xfs_fs_count],
+			sizeof(fs_path_t)*(fs_count - xfs_fs_count));
+		fs_path = &fs_table[xfs_fs_count];
+	}
+	fs_path->fs_dir = dir;
+	fs_path->fs_prid = prid;
+	fs_path->fs_flags = flags;
+	fs_path->fs_name = fsname;
+	fs_path->fs_log = fslog;
+	fs_path->fs_rt = fsrt;
+	fs_path->fs_datadev = datadev;
+	fs_path->fs_logdev = logdev;
+	fs_path->fs_rtdev = rtdev;
+	fs_count++;
+	if (!(flags & FS_FOREIGN))
+		xfs_fs_count++;
+
+	return 0;
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
+}
+
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
+
+#if defined(HAVE_GETMNTENT)
+#include <mntent.h>
+
+/*
+ * Determines whether the "logdev" or "rtdev" mount options are
+ * present for the given mount point.  If so, the value for each (a
+ * device path) is returned in the pointers whose addresses are
+ * provided.  The pointers are assigned NULL for an option not
+ * present.  Note that the path buffers returned are allocated
+ * dynamically and it is the caller's responsibility to free them.
+ */
+static int
+fs_extract_mount_options(
+	struct mntent	*mnt,
+	char		**logp,
+	char		**rtp)
+{
+	char		*fslog, *fsrt;
+
+	/*
+	 * Extract log device and realtime device from mount options.
+	 *
+	 * Note: the glibc hasmntopt implementation requires that the
+	 * character in mnt_opts immediately after the search string
+	 * must be a NULL ('\0'), a comma (','), or an equals ('=').
+	 * Therefore we cannot search for 'logdev=' directly.
+	 */
+	if ((fslog = hasmntopt(mnt, "logdev")) && fslog[6] == '=')
+		fslog += 7;
+	if ((fsrt = hasmntopt(mnt, "rtdev")) && fsrt[5] == '=')
+		fsrt += 6;
+
+	/* Do this only after we've finished processing mount options */
+	if (fslog) {
+		fslog = strndup(fslog, strcspn(fslog, " ,"));
+		if (!fslog)
+			goto out_nomem;
+	}
+	if (fsrt) {
+		fsrt = strndup(fsrt, strcspn(fsrt, " ,"));
+		if (!fsrt) {
+			free(fslog);
+			goto out_nomem;
+		}
+	}
+	*logp = fslog;
+	*rtp = fsrt;
+
+	return 0;
+
+out_nomem:
+	*logp = NULL;
+	*rtp = NULL;
+	fprintf(stderr, _("%s: unable to extract mount options for \"%s\"\n"),
+		progname, mnt->mnt_dir);
+	return ENOMEM;
+}
+
+/*
+ * If *path is NULL, initialize the fs table with all xfs mount points in mtab
+ * If *path is specified, search for that path in mtab
+ *
+ * Everything - path, devices, and mountpoints - are boiled down to realpath()
+ * for comparison, but fs_table is populated with what comes from getmntent.
+ */
+static int
+fs_table_initialise_mounts(
+	char		*path)
+{
+	struct mntent	*mnt;
+	FILE		*mtp;
+	char		*fslog, *fsrt;
+	int		error, found;
+	char		rpath[PATH_MAX], rmnt_fsname[PATH_MAX], rmnt_dir[PATH_MAX];
+
+	error = found = 0;
+	fslog = fsrt = NULL;
+
+	if (!mtab_file) {
+		mtab_file = PROC_MOUNTS;
+		if (access(mtab_file, R_OK) != 0)
+			mtab_file = MOUNTED;
+	}
+
+	if ((mtp = setmntent(mtab_file, "r")) == NULL)
+		return ENOENT;
+
+	/* Use realpath to resolve symlinks, relative paths, etc */
+	if (path)
+		if (!realpath(path, rpath))
+			return errno;
+
+	while ((mnt = getmntent(mtp)) != NULL) {
+		if (!realpath(mnt->mnt_dir, rmnt_dir))
+			continue;
+		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
+			continue;
+
+		if (path &&
+		    ((strcmp(rpath, rmnt_dir) != 0) &&
+		     (strcmp(rpath, rmnt_fsname) != 0)))
+			continue;
+		if (fs_extract_mount_options(mnt, &fslog, &fsrt))
+			continue;
+		(void) fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
+					mnt->mnt_fsname, fslog, fsrt);
+		if (path) {
+			found = 1;
+			break;
+		}
+	}
+	endmntent(mtp);
+
+	if (path && !found)
+		error = ENXIO;
+
+	return error;
+}
+
+#elif defined(HAVE_GETMNTINFO)
+#include <sys/mount.h>
+
+/*
+ * If *path is NULL, initialize the fs table with all xfs mount points in mtab
+ * If *path is specified, search for that path in mtab
+ *
+ * Everything - path, devices, and mountpoints - are boiled down to realpath()
+ * for comparison, but fs_table is populated with what comes from getmntinfo.
+ */
+static int
+fs_table_initialise_mounts(
+	char		*path)
+{
+	struct statfs	*stats;
+	int		i, count, error, found;
+	char		rpath[PATH_MAX], rmntfromname[PATH_MAX], rmntonname[PATH_MAX];
+
+	error = found = 0;
+	if ((count = getmntinfo(&stats, 0)) < 0) {
+		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
+				progname, strerror(errno));
+		return 0;
+	}
+
+	/* Use realpath to resolve symlinks, relative paths, etc */
+	if (path)
+		if (!realpath(path, rpath))
+			return errno;
+
+	for (i = 0; i < count; i++) {
+		if (!realpath(stats[i].f_mntfromname, rmntfromname))
+			continue;
+		if (!realpath(stats[i].f_mntonname, rmntonname))
+			continue;
+
+		if (path &&
+		    ((strcmp(rpath, rmntonname) != 0) &&
+		     (strcmp(rpath, rmntfromname) != 0)))
+			continue;
+		/* TODO: external log and realtime device? */
+		(void) fs_table_insert(stats[i].f_mntonname, 0,
+					FS_MOUNT_POINT, stats[i].f_mntfromname,
+					NULL, NULL);
+		if (path) {
+			found = 1;
+			break;
+		}
+	}
+	if (path && !found)
+		error = ENXIO;
+
+	return error;
+}
+
+#else
+# error "How do I extract info about mounted filesystems on this platform?"
+#endif
+
+/*
+ * Given a directory, match it up to a filesystem mount point.
+ */
+static struct fs_path *
+fs_mount_point_from_path(
+	const char	*dir)
+{
+	fs_cursor_t	cursor;
+	fs_path_t	*fs;
+	dev_t		dev = 0;
+
+	if (fs_device_number(dir, &dev))
+		return NULL;
+
+	fs_cursor_initialise(NULL, FS_MOUNT_POINT, &cursor);
+	while ((fs = fs_cursor_next_entry(&cursor))) {
+		if (fs->fs_datadev == dev)
+			break;
+	}
+	return fs;
+}
+
+static void
+fs_table_insert_mount(
+	char		*mount)
+{
+	int		error;
+
+	error = fs_table_initialise_mounts(mount);
+	if (error)
+		fprintf(stderr, _("%s: cannot setup path for mount %s: %s\n"),
+			progname, mount, strerror(error));
+}
+
+static int
+fs_table_initialise_projects(
+	char		*project)
+{
+	fs_project_path_t *path;
+	fs_path_t	*fs;
+	prid_t		prid = 0;
+	int		error = 0, found = 0;
+
+	if (project)
+		prid = prid_from_string(project);
+
+	setprpathent();
+	while ((path = getprpathent()) != NULL) {
+		if (project && prid != path->pp_prid)
+			continue;
+		fs = fs_mount_point_from_path(path->pp_pathname);
+		if (!fs) {
+			fprintf(stderr, _("%s: cannot find mount point for path `%s': %s\n"),
+					progname, path->pp_pathname, strerror(errno));
+			continue;
+		}
+		(void) fs_table_insert(path->pp_pathname, path->pp_prid,
+					FS_PROJECT_PATH, fs->fs_name,
+					NULL, NULL);
+		if (project) {
+			found = 1;
+			break;
+		}
+	}
+	endprpathent();
+
+	if (project && !found)
+		error = ENOENT;
+
+	return error;
+}
+
+static void
+fs_table_insert_project(
+	char		*project)
+{
+	int		error;
+
+	error = fs_table_initialise_projects(project);
+	if (error)
+		fprintf(stderr, _("%s: cannot setup path for project %s: %s\n"),
+			progname, project, strerror(error));
+}
+
+/*
+ * Initialize fs_table to contain the given set of mount points and
+ * projects.  If mount_count is zero, mounts is ignored and the
+ * table is populated with mounted filesystems.  If project_count is
+ * zero, projects is ignored and the table is populated with all
+ * projects defined in the projects file.
+ */
+void
+fs_table_initialise(
+	int	mount_count,
+	char	*mounts[],
+	int	project_count,
+	char	*projects[])
+{
+	int	error;
+	int	i;
+
+	if (mount_count) {
+		for (i = 0; i < mount_count; i++)
+			fs_table_insert_mount(mounts[i]);
+	} else {
+		error = fs_table_initialise_mounts(NULL);
+		if (error)
+			goto out_error;
+	}
+	if (project_count) {
+		for (i = 0; i < project_count; i++)
+			fs_table_insert_project(projects[i]);
+	} else {
+		error = fs_table_initialise_projects(NULL);
+		if (error)
+			goto out_error;
+	}
+
+	return;
+
+out_error:
+	fprintf(stderr, _("%s: cannot initialise path table: %s\n"),
+		progname, strerror(error));
+}
+
+void
+fs_table_insert_project_path(
+	char		*dir,
+	prid_t		prid)
+{
+	fs_path_t	*fs;
+	int		error = 0;
+
+	fs = fs_mount_point_from_path(dir);
+	if (fs)
+		error = fs_table_insert(dir, prid, FS_PROJECT_PATH,
+					fs->fs_name, NULL, NULL);
+	else
+		error = ENOENT;
+
+	if (error) {
+		fprintf(stderr, _("%s: cannot setup path for project dir %s: %s\n"),
+				progname, dir, strerror(error));
+		exit(1);
+	}
+}
diff --git a/libfrog/projects.c b/libfrog/projects.c
new file mode 100644
index 0000000..c9e863d
--- /dev/null
+++ b/libfrog/projects.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (c) 2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "project.h"
+
+#define PROJID		"/etc/projid"
+#define PROJECT_PATHS	"/etc/projects"
+char *projid_file;
+char *projects_file;
+
+static FILE *projects;
+static fs_project_t p;
+static char projects_buffer[512];
+
+static FILE *project_paths;
+static fs_project_path_t pp;
+static char project_paths_buffer[1024];
+
+void
+setprfiles(void)
+{
+	if (!projid_file)
+		projid_file = PROJID;
+	if (!projects_file)
+		projects_file = PROJECT_PATHS;
+}
+
+void
+setprent(void)
+{
+	setprfiles();
+	projects = fopen(projid_file, "r");
+}
+
+void
+setprpathent(void)
+{
+	setprfiles();
+	project_paths = fopen(projects_file, "r");
+}
+
+void
+endprent(void)
+{
+	if (projects)
+		fclose(projects);
+	projects = NULL;
+}
+
+void
+endprpathent(void)
+{
+	if (project_paths)
+		fclose(project_paths);
+	project_paths = NULL;
+}
+
+fs_project_t *
+getprent(void)
+{
+	char	*idstart, *idend;
+	size_t	size = sizeof(projects_buffer) - 1;
+
+	if (!projects)
+		return NULL;
+	for (;;) {
+		if (!fgets(projects_buffer, size, projects))
+			break;
+		/*
+		 * /etc/projid file format -- "name:id\n", ignore "^#..."
+		 */
+		if (projects_buffer[0] == '#')
+			continue;
+		idstart = strchr(projects_buffer, ':');
+		if (!idstart)
+			continue;
+		if ((idstart + 1) - projects_buffer >= size)
+			continue;
+		idend = strchr(idstart+1, ':');
+		if (idend)
+			*idend = '\0';
+		*idstart = '\0';
+		p.pr_prid = atoi(idstart+1);
+		p.pr_name = &projects_buffer[0];
+		return &p;
+	}
+
+	return NULL;
+}
+
+fs_project_t *
+getprnam(
+	char		*name)
+{
+	fs_project_t	*p = NULL;
+
+	setprent();
+	while ((p = getprent()) != NULL)
+		if (strcmp(p->pr_name, name) == 0)
+			break;
+	endprent();
+	return p;
+}
+
+fs_project_t *
+getprprid(
+	prid_t		prid)
+{
+	fs_project_t	*p = NULL;
+
+	setprent();
+	while ((p = getprent()) != NULL)
+		if (p->pr_prid == prid)
+			break;
+	endprent();
+	return p;
+}
+
+fs_project_path_t *
+getprpathent(void)
+{
+	char		*nmstart, *nmend;
+	size_t		size = sizeof(project_paths_buffer) - 1;
+
+	if (!project_paths)
+		return NULL;
+	for (;;) {
+		if (!fgets(project_paths_buffer, size, project_paths))
+			break;
+		/*
+		 * /etc/projects format -- "id:pathname\n", ignore "^#..."
+		 */
+		if (project_paths_buffer[0] == '#')
+			continue;
+		nmstart = strchr(project_paths_buffer, ':');
+		if (!nmstart)
+			continue;
+		if ((nmstart + 1) - project_paths_buffer >= size)
+			continue;
+		nmend = strchr(nmstart + 1, '\n');
+		if (nmend)
+			*nmend = '\0';
+		*nmstart = '\0';
+		pp.pp_pathname = nmstart + 1;
+		pp.pp_prid = atoi(&project_paths_buffer[0]);
+		return &pp;
+	}
+
+	return NULL;
+}
+
+
+int
+getprojid(
+	const char	*name,
+	int		fd,
+	prid_t		*projid)
+{
+	struct fsxattr	fsx;
+
+	if (xfsctl(name, fd, FS_IOC_FSGETXATTR, &fsx)) {
+		perror("FS_IOC_FSGETXATTR");
+		return -1;
+	}
+	*projid = fsx.fsx_projid;
+	return 0;
+}
+
+int
+setprojid(
+	const char	*name,
+	int		fd,
+	prid_t		projid)
+{
+	struct fsxattr	fsx;
+	int		error;
+
+	if ((error = xfsctl(name, fd, FS_IOC_FSGETXATTR, &fsx)) == 0) {
+		fsx.fsx_projid = projid;
+		error = xfsctl(name, fd, FS_IOC_FSSETXATTR, &fsx);
+	}
+	return error;
+}
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index 7701ed9..de0e49c 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -10,15 +10,7 @@ LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
 
-CFILES = command.c input.c paths.c projects.c help.c quit.c
-
-ifeq ($(HAVE_GETMNTENT),yes)
-LCFLAGS += -DHAVE_GETMNTENT
-endif
-
-ifeq ($(HAVE_GETMNTINFO),yes)
-LCFLAGS += -DHAVE_GETMNTINFO
-endif
+CFILES = command.c input.c help.c quit.c
 
 ifeq ($(ENABLE_READLINE),yes)
 LCFLAGS += -DENABLE_READLINE
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
deleted file mode 100644
index b767e9d..0000000
--- a/libxcmd/paths.c
+++ /dev/null
@@ -1,586 +0,0 @@
-/*
- * Copyright (c) 2005-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <paths.h>
-#include <errno.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include "path.h"
-#include "input.h"
-#include "project.h"
-#include <limits.h>
-
-extern char *progname;
-
-int fs_count;
-int xfs_fs_count;
-struct fs_path *fs_table;
-struct fs_path *fs_path;
-
-char *mtab_file;
-#define PROC_MOUNTS	"/proc/self/mounts"
-
-static int
-fs_device_number(
-	const char	*name,
-	dev_t		*devnum)
-{
-	struct stat	sbuf;
-
-	if (stat(name, &sbuf) < 0)
-		return errno;
-	/*
-	 * We want to match st_rdev if the path provided is a device
-	 * special file.  Otherwise we are looking for the the
-	 * device id for the containing filesystem, in st_dev.
-	 */
-	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode))
-		*devnum = sbuf.st_rdev;
-	else
-		*devnum = sbuf.st_dev;
-
-	return 0;
-}
-
-/*
- * Find the FS table entry for the given path.  The "flags" argument
- * is a mask containing FS_MOUNT_POINT or FS_PROJECT_PATH (or both)
- * to indicate the type of table entry sought.
- * fs_table_lookup() finds the fs table entry for the filesystem hosting
- * the file represented in the "dir" argument. To compare against actual
- * mount point entries, use fs_table_lookup_mount() instead.
- */
-struct fs_path *
-fs_table_lookup(
-	const char	*dir,
-	uint		flags)
-{
-	uint		i;
-	dev_t		dev = 0;
-
-	if (fs_device_number(dir, &dev))
-		return NULL;
-
-	for (i = 0; i < fs_count; i++) {
-		if (flags && !(flags & fs_table[i].fs_flags))
-			continue;
-		if (fs_table[i].fs_datadev == dev)
-			return &fs_table[i];
-	}
-	return NULL;
-}
-
-/*
- * Find the FS table entry describing an actual mount for the given path.
- * Unlike fs_table_lookup(), fs_table_lookup_mount() compares the "dir"
- * argument to actual mount point entries in the table. Accordingly, it
- * will find matches only if the "dir" argument is indeed mounted.
- */
-struct fs_path *
-fs_table_lookup_mount(
-	const char	*dir)
-{
-	uint		i;
-	dev_t		dev = 0;
-	char		rpath[PATH_MAX];
-
-	if (fs_device_number(dir, &dev))
-		return NULL;
-
-	for (i = 0; i < fs_count; i++) {
-		if (fs_table[i].fs_flags != FS_MOUNT_POINT)
-			continue;
-		if (!realpath(fs_table[i].fs_dir, rpath))
-			continue;
-		if (strcmp(rpath, dir) == 0)
-			return &fs_table[i];
-	}
-	return NULL;
-}
-
-static int
-fs_table_insert(
-	char		*dir,
-	uint		prid,
-	uint		flags,
-	char		*fsname,
-	char		*fslog,
-	char		*fsrt)
-{
-	dev_t		datadev, logdev, rtdev;
-	struct fs_path	*tmp_fs_table;
-	int		error;
-
-	datadev = logdev = rtdev = 0;
-	error = fs_device_number(dir, &datadev);
-	if (error)
-		goto out_nodev;
-	if (fslog) {
-		error = fs_device_number(fslog, &logdev);
-		if (error)
-			goto out_nodev;
-	}
-	if (fsrt) {
-		error = fs_device_number(fsrt, &rtdev);
-		if (error)
-			goto out_nodev;
-	}
-
-	if (!platform_test_xfs_path(dir))
-		flags |= FS_FOREIGN;
-
-	/*
-	 * Make copies of the directory and data device path.
-	 * The log device and real-time device, if non-null,
-	 * are already the result of strdup() calls so we
-	 * don't need to duplicate those.  In fact, this
-	 * function is assumed to "consume" both of those
-	 * pointers, meaning if an error occurs they will
-	 * both get freed.
-	 */
-	error = ENOMEM;
-	dir = strdup(dir);
-	if (!dir)
-		goto out_nodev;
-	fsname = strdup(fsname);
-	if (!fsname)
-		goto out_noname;
-
-	tmp_fs_table = realloc(fs_table, sizeof(fs_path_t) * (fs_count + 1));
-	if (!tmp_fs_table)
-		goto out_norealloc;
-	fs_table = tmp_fs_table;
-
-	/* Put foreign filesystems at the end, xfs filesystems at the front */
-	if (flags & FS_FOREIGN || fs_count == 0) {
-		fs_path = &fs_table[fs_count];
-	} else {
-		/* move foreign fs entries down, insert new one just before */
-		memmove(&fs_table[xfs_fs_count + 1], &fs_table[xfs_fs_count],
-			sizeof(fs_path_t)*(fs_count - xfs_fs_count));
-		fs_path = &fs_table[xfs_fs_count];
-	}
-	fs_path->fs_dir = dir;
-	fs_path->fs_prid = prid;
-	fs_path->fs_flags = flags;
-	fs_path->fs_name = fsname;
-	fs_path->fs_log = fslog;
-	fs_path->fs_rt = fsrt;
-	fs_path->fs_datadev = datadev;
-	fs_path->fs_logdev = logdev;
-	fs_path->fs_rtdev = rtdev;
-	fs_count++;
-	if (!(flags & FS_FOREIGN))
-		xfs_fs_count++;
-
-	return 0;
-
-out_norealloc:
-	free(fsname);
-out_noname:
-	free(dir);
-out_nodev:
-	/* "Consume" fslog and fsrt even if there's an error */
-	free(fslog);
-	free(fsrt);
-
-	return error;
-}
-
-/*
- * Table iteration (cursor-based) interfaces
- */
-
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
-
-
-#if defined(HAVE_GETMNTENT)
-#include <mntent.h>
-
-/*
- * Determines whether the "logdev" or "rtdev" mount options are
- * present for the given mount point.  If so, the value for each (a
- * device path) is returned in the pointers whose addresses are
- * provided.  The pointers are assigned NULL for an option not
- * present.  Note that the path buffers returned are allocated
- * dynamically and it is the caller's responsibility to free them.
- */
-static int
-fs_extract_mount_options(
-	struct mntent	*mnt,
-	char		**logp,
-	char		**rtp)
-{
-	char		*fslog, *fsrt;
-
-	/*
-	 * Extract log device and realtime device from mount options.
-	 *
-	 * Note: the glibc hasmntopt implementation requires that the
-	 * character in mnt_opts immediately after the search string
-	 * must be a NULL ('\0'), a comma (','), or an equals ('=').
-	 * Therefore we cannot search for 'logdev=' directly.
-	 */
-	if ((fslog = hasmntopt(mnt, "logdev")) && fslog[6] == '=')
-		fslog += 7;
-	if ((fsrt = hasmntopt(mnt, "rtdev")) && fsrt[5] == '=')
-		fsrt += 6;
-
-	/* Do this only after we've finished processing mount options */
-	if (fslog) {
-		fslog = strndup(fslog, strcspn(fslog, " ,"));
-		if (!fslog)
-			goto out_nomem;
-	}
-	if (fsrt) {
-		fsrt = strndup(fsrt, strcspn(fsrt, " ,"));
-		if (!fsrt) {
-			free(fslog);
-			goto out_nomem;
-		}
-	}
-	*logp = fslog;
-	*rtp = fsrt;
-
-	return 0;
-
-out_nomem:
-	*logp = NULL;
-	*rtp = NULL;
-	fprintf(stderr, _("%s: unable to extract mount options for \"%s\"\n"),
-		progname, mnt->mnt_dir);
-	return ENOMEM;
-}
-
-/*
- * If *path is NULL, initialize the fs table with all xfs mount points in mtab
- * If *path is specified, search for that path in mtab
- *
- * Everything - path, devices, and mountpoints - are boiled down to realpath()
- * for comparison, but fs_table is populated with what comes from getmntent.
- */
-static int
-fs_table_initialise_mounts(
-	char		*path)
-{
-	struct mntent	*mnt;
-	FILE		*mtp;
-	char		*fslog, *fsrt;
-	int		error, found;
-	char		rpath[PATH_MAX], rmnt_fsname[PATH_MAX], rmnt_dir[PATH_MAX];
-
-	error = found = 0;
-	fslog = fsrt = NULL;
-
-	if (!mtab_file) {
-		mtab_file = PROC_MOUNTS;
-		if (access(mtab_file, R_OK) != 0)
-			mtab_file = MOUNTED;
-	}
-
-	if ((mtp = setmntent(mtab_file, "r")) == NULL)
-		return ENOENT;
-
-	/* Use realpath to resolve symlinks, relative paths, etc */
-	if (path)
-		if (!realpath(path, rpath))
-			return errno;
-
-	while ((mnt = getmntent(mtp)) != NULL) {
-		if (!realpath(mnt->mnt_dir, rmnt_dir))
-			continue;
-		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
-			continue;
-
-		if (path &&
-		    ((strcmp(rpath, rmnt_dir) != 0) &&
-		     (strcmp(rpath, rmnt_fsname) != 0)))
-			continue;
-		if (fs_extract_mount_options(mnt, &fslog, &fsrt))
-			continue;
-		(void) fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
-					mnt->mnt_fsname, fslog, fsrt);
-		if (path) {
-			found = 1;
-			break;
-		}
-	}
-	endmntent(mtp);
-
-	if (path && !found)
-		error = ENXIO;
-
-	return error;
-}
-
-#elif defined(HAVE_GETMNTINFO)
-#include <sys/mount.h>
-
-/*
- * If *path is NULL, initialize the fs table with all xfs mount points in mtab
- * If *path is specified, search for that path in mtab
- *
- * Everything - path, devices, and mountpoints - are boiled down to realpath()
- * for comparison, but fs_table is populated with what comes from getmntinfo.
- */
-static int
-fs_table_initialise_mounts(
-	char		*path)
-{
-	struct statfs	*stats;
-	int		i, count, error, found;
-	char		rpath[PATH_MAX], rmntfromname[PATH_MAX], rmntonname[PATH_MAX];
-
-	error = found = 0;
-	if ((count = getmntinfo(&stats, 0)) < 0) {
-		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
-				progname, strerror(errno));
-		return 0;
-	}
-
-	/* Use realpath to resolve symlinks, relative paths, etc */
-	if (path)
-		if (!realpath(path, rpath))
-			return errno;
-
-	for (i = 0; i < count; i++) {
-		if (!realpath(stats[i].f_mntfromname, rmntfromname))
-			continue;
-		if (!realpath(stats[i].f_mntonname, rmntonname))
-			continue;
-
-		if (path &&
-		    ((strcmp(rpath, rmntonname) != 0) &&
-		     (strcmp(rpath, rmntfromname) != 0)))
-			continue;
-		/* TODO: external log and realtime device? */
-		(void) fs_table_insert(stats[i].f_mntonname, 0,
-					FS_MOUNT_POINT, stats[i].f_mntfromname,
-					NULL, NULL);
-		if (path) {
-			found = 1;
-			break;
-		}
-	}
-	if (path && !found)
-		error = ENXIO;
-
-	return error;
-}
-
-#else
-# error "How do I extract info about mounted filesystems on this platform?"
-#endif
-
-/*
- * Given a directory, match it up to a filesystem mount point.
- */
-static struct fs_path *
-fs_mount_point_from_path(
-	const char	*dir)
-{
-	fs_cursor_t	cursor;
-	fs_path_t	*fs;
-	dev_t		dev = 0;
-
-	if (fs_device_number(dir, &dev))
-		return NULL;
-
-	fs_cursor_initialise(NULL, FS_MOUNT_POINT, &cursor);
-	while ((fs = fs_cursor_next_entry(&cursor))) {
-		if (fs->fs_datadev == dev)
-			break;
-	}
-	return fs;
-}
-
-static void
-fs_table_insert_mount(
-	char		*mount)
-{
-	int		error;
-
-	error = fs_table_initialise_mounts(mount);
-	if (error)
-		fprintf(stderr, _("%s: cannot setup path for mount %s: %s\n"),
-			progname, mount, strerror(error));
-}
-
-static int
-fs_table_initialise_projects(
-	char		*project)
-{
-	fs_project_path_t *path;
-	fs_path_t	*fs;
-	prid_t		prid = 0;
-	int		error = 0, found = 0;
-
-	if (project)
-		prid = prid_from_string(project);
-
-	setprpathent();
-	while ((path = getprpathent()) != NULL) {
-		if (project && prid != path->pp_prid)
-			continue;
-		fs = fs_mount_point_from_path(path->pp_pathname);
-		if (!fs) {
-			fprintf(stderr, _("%s: cannot find mount point for path `%s': %s\n"),
-					progname, path->pp_pathname, strerror(errno));
-			continue;
-		}
-		(void) fs_table_insert(path->pp_pathname, path->pp_prid,
-					FS_PROJECT_PATH, fs->fs_name,
-					NULL, NULL);
-		if (project) {
-			found = 1;
-			break;
-		}
-	}
-	endprpathent();
-
-	if (project && !found)
-		error = ENOENT;
-
-	return error;
-}
-
-static void
-fs_table_insert_project(
-	char		*project)
-{
-	int		error;
-
-	error = fs_table_initialise_projects(project);
-	if (error)
-		fprintf(stderr, _("%s: cannot setup path for project %s: %s\n"),
-			progname, project, strerror(error));
-}
-
-/*
- * Initialize fs_table to contain the given set of mount points and
- * projects.  If mount_count is zero, mounts is ignored and the
- * table is populated with mounted filesystems.  If project_count is
- * zero, projects is ignored and the table is populated with all
- * projects defined in the projects file.
- */
-void
-fs_table_initialise(
-	int	mount_count,
-	char	*mounts[],
-	int	project_count,
-	char	*projects[])
-{
-	int	error;
-	int	i;
-
-	if (mount_count) {
-		for (i = 0; i < mount_count; i++)
-			fs_table_insert_mount(mounts[i]);
-	} else {
-		error = fs_table_initialise_mounts(NULL);
-		if (error)
-			goto out_error;
-	}
-	if (project_count) {
-		for (i = 0; i < project_count; i++)
-			fs_table_insert_project(projects[i]);
-	} else {
-		error = fs_table_initialise_projects(NULL);
-		if (error)
-			goto out_error;
-	}
-
-	return;
-
-out_error:
-	fprintf(stderr, _("%s: cannot initialise path table: %s\n"),
-		progname, strerror(error));
-}
-
-void
-fs_table_insert_project_path(
-	char		*dir,
-	prid_t		prid)
-{
-	fs_path_t	*fs;
-	int		error = 0;
-
-	fs = fs_mount_point_from_path(dir);
-	if (fs)
-		error = fs_table_insert(dir, prid, FS_PROJECT_PATH,
-					fs->fs_name, NULL, NULL);
-	else
-		error = ENOENT;
-
-	if (error) {
-		fprintf(stderr, _("%s: cannot setup path for project dir %s: %s\n"),
-				progname, dir, strerror(error));
-		exit(1);
-	}
-}
diff --git a/libxcmd/projects.c b/libxcmd/projects.c
deleted file mode 100644
index c9e863d..0000000
--- a/libxcmd/projects.c
+++ /dev/null
@@ -1,201 +0,0 @@
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include "project.h"
-
-#define PROJID		"/etc/projid"
-#define PROJECT_PATHS	"/etc/projects"
-char *projid_file;
-char *projects_file;
-
-static FILE *projects;
-static fs_project_t p;
-static char projects_buffer[512];
-
-static FILE *project_paths;
-static fs_project_path_t pp;
-static char project_paths_buffer[1024];
-
-void
-setprfiles(void)
-{
-	if (!projid_file)
-		projid_file = PROJID;
-	if (!projects_file)
-		projects_file = PROJECT_PATHS;
-}
-
-void
-setprent(void)
-{
-	setprfiles();
-	projects = fopen(projid_file, "r");
-}
-
-void
-setprpathent(void)
-{
-	setprfiles();
-	project_paths = fopen(projects_file, "r");
-}
-
-void
-endprent(void)
-{
-	if (projects)
-		fclose(projects);
-	projects = NULL;
-}
-
-void
-endprpathent(void)
-{
-	if (project_paths)
-		fclose(project_paths);
-	project_paths = NULL;
-}
-
-fs_project_t *
-getprent(void)
-{
-	char	*idstart, *idend;
-	size_t	size = sizeof(projects_buffer) - 1;
-
-	if (!projects)
-		return NULL;
-	for (;;) {
-		if (!fgets(projects_buffer, size, projects))
-			break;
-		/*
-		 * /etc/projid file format -- "name:id\n", ignore "^#..."
-		 */
-		if (projects_buffer[0] == '#')
-			continue;
-		idstart = strchr(projects_buffer, ':');
-		if (!idstart)
-			continue;
-		if ((idstart + 1) - projects_buffer >= size)
-			continue;
-		idend = strchr(idstart+1, ':');
-		if (idend)
-			*idend = '\0';
-		*idstart = '\0';
-		p.pr_prid = atoi(idstart+1);
-		p.pr_name = &projects_buffer[0];
-		return &p;
-	}
-
-	return NULL;
-}
-
-fs_project_t *
-getprnam(
-	char		*name)
-{
-	fs_project_t	*p = NULL;
-
-	setprent();
-	while ((p = getprent()) != NULL)
-		if (strcmp(p->pr_name, name) == 0)
-			break;
-	endprent();
-	return p;
-}
-
-fs_project_t *
-getprprid(
-	prid_t		prid)
-{
-	fs_project_t	*p = NULL;
-
-	setprent();
-	while ((p = getprent()) != NULL)
-		if (p->pr_prid == prid)
-			break;
-	endprent();
-	return p;
-}
-
-fs_project_path_t *
-getprpathent(void)
-{
-	char		*nmstart, *nmend;
-	size_t		size = sizeof(project_paths_buffer) - 1;
-
-	if (!project_paths)
-		return NULL;
-	for (;;) {
-		if (!fgets(project_paths_buffer, size, project_paths))
-			break;
-		/*
-		 * /etc/projects format -- "id:pathname\n", ignore "^#..."
-		 */
-		if (project_paths_buffer[0] == '#')
-			continue;
-		nmstart = strchr(project_paths_buffer, ':');
-		if (!nmstart)
-			continue;
-		if ((nmstart + 1) - project_paths_buffer >= size)
-			continue;
-		nmend = strchr(nmstart + 1, '\n');
-		if (nmend)
-			*nmend = '\0';
-		*nmstart = '\0';
-		pp.pp_pathname = nmstart + 1;
-		pp.pp_prid = atoi(&project_paths_buffer[0]);
-		return &pp;
-	}
-
-	return NULL;
-}
-
-
-int
-getprojid(
-	const char	*name,
-	int		fd,
-	prid_t		*projid)
-{
-	struct fsxattr	fsx;
-
-	if (xfsctl(name, fd, FS_IOC_FSGETXATTR, &fsx)) {
-		perror("FS_IOC_FSGETXATTR");
-		return -1;
-	}
-	*projid = fsx.fsx_projid;
-	return 0;
-}
-
-int
-setprojid(
-	const char	*name,
-	int		fd,
-	prid_t		projid)
-{
-	struct fsxattr	fsx;
-	int		error;
-
-	if ((error = xfsctl(name, fd, FS_IOC_FSGETXATTR, &fsx)) == 0) {
-		fsx.fsx_projid = projid;
-		error = xfsctl(name, fd, FS_IOC_FSSETXATTR, &fsx);
-	}
-	return error;
-}
diff --git a/quota/Makefile b/quota/Makefile
index 9c6411e..120af2e 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -14,8 +14,8 @@ CFILES += $(PKG_PLATFORM).c
 PCFILES = darwin.c freebsd.c irix.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
-LLDLIBS = $(LIBXCMD)
-LTDEPENDENCIES = $(LIBXCMD)
+LLDLIBS = $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_READLINE),yes)
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 95ec3c0..8b31030 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -9,8 +9,8 @@ LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
 CFILES = init.c file.c prealloc.c trim.c
 
-LLDLIBS = $(LIBXCMD)
-LTDEPENDENCIES = $(LIBXCMD)
+LLDLIBS = $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_READLINE),yes)

