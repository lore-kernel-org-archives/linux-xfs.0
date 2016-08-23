Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94B0F7CA1
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 11:40:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B47A8F8037
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 09:40:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3qhlhkB8xhY9rgHV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 09:40:39 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 2722443A37
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 16:40:39 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-62-210.rdu2.redhat.com
	[10.10.62.210])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7NGeb4Y007416
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 12:40:38 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v3 1/2] xfs_quota: add capabilities for use on ext4
Date: Tue, 23 Aug 2016 11:40:25 -0500
Message-Id: <1471970426-5509-2-git-send-email-billodo@redhat.com>
In-Reply-To: <1471970426-5509-1-git-send-email-billodo@redhat.com>
References: <1471970426-5509-1-git-send-email-billodo@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch allows xfs_quota to be used on ext4 for project
quota testing in xfstests.

This patch was originally submitted by Dave Chinner
(http://oss.sgi.com/archives/xfs/2016-02/msg00131.html)

Notes:
As a part of its support for foreign filesystems xfs_quota
is modified with a "-f" command line flag to enable select
commands on those filesystems. With this addition, some
of the logic, notably in quota/init.c requires adjustment.

The original init_args_command() code in init.c searched
for the first mount point entry in the filesystem table
(i.e. a FS_MOUNT_POINT entry) and it did so by skipping
over FS_PROJECT_PATH entries. Once it found an entry that
was not a project quota path entry, it stopped, since it now
had an XFS mount point to work from.

In the original submitted patch series:
(http://oss.sgi.com/archives/xfs/2016-02/msg00131.html),
a subtle change in init_args_command() introduced an error,
preventing correct break from its do-while loop, ultimately
resulting in xfs quota test failure. This new patch includes
modifications to that logic to effect proper break from the
loop for xfs and foreign filesystems.

With the introduction of the foreign file system flag, make
usage and man-page changes accordingly. If thrown, the -f
flag will allow select user and administrative commands to
be run on mounted foreign filesystems (e.g. ext4).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 include/command.h    |  3 ++-
 include/path.h       |  1 +
 io/init.h            |  2 +-
 libxcmd/paths.c      |  7 +++----
 man/man8/xfs_quota.8 |  7 +++++++
 quota/free.c         |  2 ++
 quota/init.c         | 37 ++++++++++++++++++++++++++++++++++---
 quota/init.h         |  1 +
 quota/path.c         |  5 +++--
 quota/project.c      |  1 +
 quota/quot.c         |  1 +
 quota/quota.c        |  2 ++
 quota/report.c       | 11 +++++++++--
 quota/state.c        |  4 +++-
 quota/util.c         |  1 +
 15 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/include/command.h b/include/command.h
index 7b9fc28..81d5a4d 100644
--- a/include/command.h
+++ b/include/command.h
@@ -20,7 +20,8 @@
 
 #include <sys/time.h>
 
-#define CMD_FLAG_GLOBAL	((int)0x80000000)	/* don't iterate "args" */
+#define CMD_FLAG_GLOBAL		(1<<31)	/* don't iterate "args" */
+#define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
 
 typedef int (*cfunc_t)(int argc, char **argv);
 typedef void (*helpfunc_t)(void);
diff --git a/include/path.h b/include/path.h
index 46a887e..39c1a95 100644
--- a/include/path.h
+++ b/include/path.h
@@ -29,6 +29,7 @@
 
 #define FS_MOUNT_POINT	(1<<0)
 #define FS_PROJECT_PATH	(1<<1)
+#define FS_FOREIGN	(1<<2)
 
 typedef struct fs_path {
 	char		*fs_name;	/* Data device for filesystem 	*/
diff --git a/io/init.h b/io/init.h
index d773b1b..bb25242 100644
--- a/io/init.h
+++ b/io/init.h
@@ -18,7 +18,7 @@
 
 #define CMD_NOFILE_OK	(1<<0)	/* command doesn't need an open file	*/
 #define CMD_NOMAP_OK	(1<<1)	/* command doesn't need a mapped region	*/
-#define CMD_FOREIGN_OK	(1<<2)	/* command not restricted to XFS files	*/
+#define CMD_FOREIGN_OK	CMD_FLAG_FOREIGN_OK
 
 extern char	*progname;
 extern int	exitcode;
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 71af25f..7c8c673 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -113,6 +113,9 @@ fs_table_insert(
 			goto out_nodev;
 	}
 
+	if (!platform_test_xfs_path(dir))
+		flags |= FS_FOREIGN;
+
 	/*
 	 * Make copies of the directory and data device path.
 	 * The log device and real-time device, if non-null,
@@ -301,8 +304,6 @@ fs_table_initialise_mounts(
 			return errno;
 
 	while ((mnt = getmntent(mtp)) != NULL) {
-		if (strcmp(mnt->mnt_type, "xfs") != 0)
-			continue;
 		if (!realpath(mnt->mnt_dir, rmnt_dir))
 			continue;
 		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
@@ -360,8 +361,6 @@ fs_table_initialise_mounts(
 			return errno;
 
 	for (i = 0; i < count; i++) {
-		if (strcmp(stats[i].f_fstypename, "xfs") != 0)
-			continue;
 		if (!realpath(stats[i].f_mntfromname, rmntfromname))
 			continue;
 		if (!realpath(stats[i].f_mntonname, rmntonname))
diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index f66e421..03add20 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -6,6 +6,8 @@ xfs_quota \- manage use of quota on XFS filesystems
 [
 .B \-x
 ] [
+.B \-f
+] [
 .B \-p
 .I prog
 ] [
@@ -51,6 +53,11 @@ All of the administrative commands (see the ADMINISTRATOR COMMANDS
 section below) which allow modifications to the quota system are
 available only in expert mode.
 .TP
+.B \-f
+Enable foreign filesystem mode.
+A limited number of user and administrative commands are available for
+use on some foreign (non-XFS) filesystems.
+.TP
 .BI \-d " project"
 Project names or numeric identifiers may be specified with this option,
 which restricts the output of the individual
diff --git a/quota/free.c b/quota/free.c
index e9e0319..b9be954 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <stdbool.h>
 #include "command.h"
 #include "init.h"
 #include "quota.h"
@@ -371,6 +372,7 @@ free_init(void)
 	free_cmd.args = _("[-bir] [-hn] [-f file]");
 	free_cmd.oneline = _("show free and used counts for blocks and inodes");
 	free_cmd.help = free_help;
+	free_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	add_command(&free_cmd);
 }
diff --git a/quota/init.c b/quota/init.c
index 52f7941..137cd68 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -24,6 +24,7 @@
 char	*progname;
 int	exitcode;
 int	expert;
+bool	foreign_allowed = false;
 
 static char **projopts;	/* table of project names (cmdline) */
 static int nprojopts;	/* number of entries in name table. */
@@ -45,7 +46,7 @@ static void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-V] [-x] [-p prog] [-c cmd]... [-d project]... [path]\n"),
+		_("Usage: %s [-V] [-x] [-f] [-p prog] [-c cmd]... [-d project]... [path]\n"),
 		progname);
 	exit(1);
 }
@@ -83,15 +84,42 @@ init_args_command(
 
 	do {
 		fs_path = &fs_table[index++];
-	} while ((fs_path->fs_flags & FS_PROJECT_PATH) && index < fs_count);
+		/* skip project quota entries */
+		if ((fs_path->fs_flags & FS_PROJECT_PATH))
+			continue;
+
+		/* only consider foreign filesystems if told so */
+		if (!foreign_allowed && (fs_path->fs_flags & FS_FOREIGN))
+			continue;
+
+		/* We can use this one */
+		break;
+	} while (index < fs_count);
 
 	if (fs_path->fs_flags & FS_PROJECT_PATH)
 		return 0;
+	if (!foreign_allowed && (fs_path->fs_flags & FS_FOREIGN))
+		return 0;
 	if (index > fs_count)
 		return 0;
 	return index;
 }
 
+static int
+init_check_command(
+	const cmdinfo_t	*ct)
+{
+	if (fs_path &&
+	    !(ct->flags & CMD_FLAG_FOREIGN_OK) &&
+	     (fs_path->fs_flags & FS_FOREIGN)) {
+		fprintf(stderr,
+	_("foreign mount active, %s command is for XFS filesystems only\n"),
+			ct->name);
+		return 0;
+	}
+	return 1;
+}
+
 static void
 init(
 	int		argc,
@@ -104,7 +132,7 @@ init(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((c = getopt(argc, argv, "c:d:D:P:p:t:xV")) != EOF) {
+	while ((c = getopt(argc, argv, "c:d:D:fP:p:t:xV")) != EOF) {
 		switch (c) {
 		case 'c':	/* commands */
 			add_user_command(optarg);
@@ -112,6 +140,8 @@ init(
 		case 'd':
 			add_project_opt(optarg);
 			break;
+		case 'f':
+			foreign_allowed = true;
 		case 't':
 			mtab_file = optarg;
 			break;
@@ -140,6 +170,7 @@ init(
 
 	init_commands();
 	add_args_command(init_args_command);
+	add_check_command(init_check_command);
 
 	/*
 	 * Ensure that global commands don't end up with an invalid path pointer
diff --git a/quota/init.h b/quota/init.h
index 71706cb..6879855 100644
--- a/quota/init.h
+++ b/quota/init.h
@@ -19,6 +19,7 @@
 extern char	*progname;
 extern int	exitcode;
 extern int	expert;
+extern bool	foreign_allowed;
 
 extern void	edit_init(void);
 extern void	free_init(void);
diff --git a/quota/path.c b/quota/path.c
index bdb8c98..a623d25 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -42,6 +42,7 @@ printpath(
 	if (number) {
 		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
 	}
+	printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
 	printf(_("%-19s %s"), path->fs_dir, path->fs_name);
 	if (path->fs_flags & FS_PROJECT_PATH) {
 		prj = getprprid(path->fs_prid);
@@ -127,7 +128,7 @@ path_init(void)
 	path_cmd.cfunc = path_f;
 	path_cmd.argmin = 0;
 	path_cmd.argmax = 1;
-	path_cmd.flags = CMD_FLAG_GLOBAL;
+	path_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
 	path_cmd.oneline = _("set current path, or show the list of paths");
 
 	print_cmd.name = "print";
@@ -135,7 +136,7 @@ path_init(void)
 	print_cmd.cfunc = print_f;
 	print_cmd.argmin = 0;
 	print_cmd.argmax = 0;
-	print_cmd.flags = CMD_FLAG_GLOBAL;
+	print_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
 	print_cmd.oneline = _("list known mount points and projects");
 
 	if (expert)
diff --git a/quota/project.c b/quota/project.c
index fb8b9e1..e4e7a01 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -355,6 +355,7 @@ project_init(void)
 	project_cmd.argmax = -1;
 	project_cmd.oneline = _("check, setup or clear project quota trees");
 	project_cmd.help = project_help;
+	project_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	if (expert)
 		add_command(&project_cmd);
diff --git a/quota/quot.c b/quota/quot.c
index 2e583e5..ccc154f 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <stdbool.h>
 #include "command.h"
 #include <ctype.h>
 #include <pwd.h>
diff --git a/quota/quota.c b/quota/quota.c
index e0da7c0..d09e239 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <stdbool.h>
 #include "command.h"
 #include <ctype.h>
 #include <pwd.h>
@@ -469,6 +470,7 @@ quota_init(void)
 	quota_cmd.args = _("[-bir] [-g|-p|-u] [-hnNv] [-f file] [id|name]...");
 	quota_cmd.oneline = _("show usage and limits");
 	quota_cmd.help = quota_help;
+	quota_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	add_command(&quota_cmd);
 }
diff --git a/quota/report.c b/quota/report.c
index 70220b4..604f50d 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
+#include <stdbool.h>
 #include "command.h"
 #include <sys/types.h>
 #include <pwd.h>
@@ -618,6 +618,8 @@ report_any_type(
 	if (type & XFS_USER_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
+			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
+				continue;
 			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
 						XFS_USER_QUOTA, 0, NULL) < 0
 					&& errno != ENOENT && errno != ENOSYS)
@@ -629,6 +631,8 @@ report_any_type(
 	if (type & XFS_GROUP_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
+			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
+				continue;
 			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
 						XFS_GROUP_QUOTA, 0, NULL) < 0
 					&& errno != ENOENT && errno != ENOSYS)
@@ -640,6 +644,8 @@ report_any_type(
 	if (type & XFS_PROJ_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
+			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
+				continue;
 			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
 						XFS_PROJ_QUOTA, 0, NULL) < 0
 					&& errno != ENOENT && errno != ENOSYS)
@@ -754,16 +760,17 @@ report_init(void)
 	dump_cmd.args = _("[-g|-p|-u] [-f file]");
 	dump_cmd.oneline = _("dump quota information for backup utilities");
 	dump_cmd.help = dump_help;
+	dump_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	report_cmd.name = "report";
 	report_cmd.altname = "repquota";
 	report_cmd.cfunc = report_f;
 	report_cmd.argmin = 0;
 	report_cmd.argmax = -1;
-	report_cmd.flags = CMD_FLAG_GLOBAL;
 	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
 	report_cmd.oneline = _("report filesystem quota information");
 	report_cmd.help = report_help;
+	report_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
 
 	if (expert) {
 		add_command(&dump_cmd);
diff --git a/quota/state.c b/quota/state.c
index 8186762..d134580 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
+#include <stdbool.h>
 #include "command.h"
 #include "init.h"
 #include "quota.h"
@@ -527,6 +527,7 @@ state_init(void)
 	off_cmd.args = _("[-gpu] [-v]");
 	off_cmd.oneline = _("permanently switch quota off for a path");
 	off_cmd.help = off_help;
+	off_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	state_cmd.name = "state";
 	state_cmd.cfunc = state_f;
@@ -535,6 +536,7 @@ state_init(void)
 	state_cmd.args = _("[-gpu] [-a] [-v] [-f file]");
 	state_cmd.oneline = _("get overall quota state information");
 	state_cmd.help = state_help;
+	state_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	enable_cmd.name = "enable";
 	enable_cmd.cfunc = enable_f;
diff --git a/quota/util.c b/quota/util.c
index e3c5398..cafd45f 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -17,6 +17,7 @@
  */
 
 #include <sys/types.h>
+#include <stdbool.h>
 #include <pwd.h>
 #include <grp.h>
 #include <utmp.h>
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
