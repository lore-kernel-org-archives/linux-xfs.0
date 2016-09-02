Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 897927CA7
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 16:22:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAB62AC002
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 14:22:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4URyBEEKLKtTMHvq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Sep 2016 14:22:10 -0700 (PDT)
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v2] xfsprogs: (xfs_quota) foreign fs path handling changes
Date: Fri,  2 Sep 2016 16:22:08 -0500
Message-Id: <1472851328-25542-1-git-send-email-billodo@redhat.com>
In-Reply-To: <1472478012-23627-1-git-send-email-billodo@redhat.com>
References: <1472478012-23627-1-git-send-email-billodo@redhat.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Version 2 of this patch to xfs_quota in order to properly
handle foreign fs mount paths. Note that this version (2)
abandons the incorrect approach of version 1, in which the
fs-table wasn't populated with the foreign fs paths.

Commits b20b6c2 and 29647c8 modified xfs_quota for use on
non-XFS filesystems. Modifications to fs_initialise_mounts
(paths.c) resulted in an xfstest fail (xfs/261), due to foreign
fs paths being picked up from the fs table, and the xfs_quota
print command complaining about not being able to print the
foreign paths.

This patch fixes the foreign path print problem, with a
modification of the print and path commands to always be
allowed, regardless of fs type (similar to the help and quit
commands).

Additionally, the printpath() function in path.c is corrected
to skip printing foreign paths unless the -f flag is thrown
in the xfs_quota invocation. Also, some minor formatting
changes and comment clarifications to the print command are
made.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 quota/init.c | 19 +++++++++++++------
 quota/path.c | 19 ++++++++++++++-----
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/quota/init.c b/quota/init.c
index 44be322..9f95e8f 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -112,21 +112,28 @@ init_check_command(
 	if (!fs_path)
 		return 1;
 
-	/* Always run commands that we are told to skip here */
+	/* Always run commands that are valid for all fs types. */
 	if (ct->flags & CMD_ALL_FSTYPES)
 		return 1;
 
-	/* if it's an XFS filesystem, always run the command */
+	/* If it's an XFS filesystem, always run the command. */
 	if (!(fs_path->fs_flags & FS_FOREIGN))
 		return 1;
 
-	/* If the user specified foreign filesysetms are ok, run it */
+	/* If the user specified foreign filesystems are ok (-f), run cmd. */
 	if (foreign_allowed &&
-	    (ct->flags & CMD_FLAG_FOREIGN_OK))
+		(ct->flags & CMD_FLAG_FOREIGN_OK))
 		return 1;
 
-	/* foreign filesystem and it's not a valid command! */
-	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
+	/* If cmd not allowed on foreign fs, regardless of -f flag, skip it. */
+	if (!(ct->flags & CMD_FLAG_FOREIGN_OK)) {
+		fprintf(stderr, _("%s: command is for XFS filesystems only\n"),
+		ct->name);
+		return 0;
+	}
+
+	/* foreign fs, but cmd only allowed via -f flag. Skip it. */
+	fprintf(stderr, _("%s: foreign filesystem. Use -f to enable.\n"),
 		ct->name);
 	return 0;
 }
diff --git a/quota/path.c b/quota/path.c
index a623d25..d8f8f3c 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -36,14 +36,23 @@ printpath(
 	int		c;
 
 	if (index == 0) {
-		printf(_("%sFilesystem          Pathname\n"),
+		printf(_("%s    Filesystem          Pathname\n"),
 			number ? _("      ") : "");
 	}
 	if (number) {
 		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
 	}
-	printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
-	printf(_("%-19s %s"), path->fs_dir, path->fs_name);
+	if (path->fs_flags & FS_FOREIGN) {
+	    if (foreign_allowed) {
+	      printf("(F) ");
+	      printf(_("%-19s %s"), path->fs_dir, path->fs_name);
+	    }
+	}
+	else {
+	      printf("    ");
+	      printf(_("%-19s %s"), path->fs_dir, path->fs_name);
+	}
+
 	if (path->fs_flags & FS_PROJECT_PATH) {
 		prj = getprprid(path->fs_prid);
 		printf(_(" (project %u"), path->fs_prid);
@@ -128,7 +137,7 @@ path_init(void)
 	path_cmd.cfunc = path_f;
 	path_cmd.argmin = 0;
 	path_cmd.argmax = 1;
-	path_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
+	path_cmd.flags = CMD_FLAG_GLOBAL | CMD_ALL_FSTYPES;
 	path_cmd.oneline = _("set current path, or show the list of paths");
 
 	print_cmd.name = "print";
@@ -136,7 +145,7 @@ path_init(void)
 	print_cmd.cfunc = print_f;
 	print_cmd.argmin = 0;
 	print_cmd.argmax = 0;
-	print_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
+	print_cmd.flags = CMD_FLAG_GLOBAL | CMD_ALL_FSTYPES;
 	print_cmd.oneline = _("list known mount points and projects");
 
 	if (expert)
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
