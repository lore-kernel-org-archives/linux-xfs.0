Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1172656AbdDXO3d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 10:29:33 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B75C7F4BE
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 14:29:32 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-64.rdu2.redhat.com [10.10.121.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 159E17F278
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 14:29:31 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH v3] xfsprogs: ensure growfs rejects non-existent mount point
Date: Mon, 24 Apr 2017 09:29:26 -0500
Message-Id: <20170424142926.25934-1-billodo@redhat.com>
In-Reply-To: <20170407175809.8540-1-billodo@redhat.com>
References: <20170407175809.8540-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_growfs manpage clearly states that the filesystem must
be mounted to be grown. Current behavior allows xfs_growfs
to proceed if the filesystem /containing/ the path
of the desired target is mounted. This is not the specified
behavior. Instead, also check the targeted fs argument against
the entry found in the fstable lookup. Unless the targeted
fs is actually mounted, reject the command.

In order to cover bind-mounts, create a new lookup function
based on the mountpoints instead of just the device name.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---

v3: improve error message for realpath failure. Add comments
to better document the differences between fs_table_lookup()
and fs_table_lookup_mount(). Use realpath() in fs_table_lookup_mount()
prior to directory comparison.

v2: in order to properly handle relative pathnames, symlinks,
and bind-mounts, use realpath to establish canonical path name.
This also requires the introduction of a lookup function based
on the target mountpoint.

 growfs/xfs_growfs.c | 10 +++++++++-
 include/path.h      |  1 +
 libxcmd/paths.c     | 31 +++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a294e14..c3344d0 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -133,6 +133,7 @@ main(int argc, char **argv)
 	int			spinodes;
 	int			rmapbt_enabled;
 	int			reflink_enabled;
+	char			rpath[PATH_MAX];
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -202,7 +203,14 @@ main(int argc, char **argv)
 		aflag = 1;
 
 	fs_table_initialise(0, NULL, 0, NULL);
-	fs = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
+
+	if (!realpath(argv[optind], rpath)) {
+		fprintf(stderr, _("Path resolution failed for %s: %s\n"),
+			progname, argv[optind]);
+		return 1;
+	}
+
+	fs = fs_table_lookup_mount(rpath);
 	if (!fs) {
 		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
 			progname, argv[optind]);
diff --git a/include/path.h b/include/path.h
index d077bac..1d3a902 100644
--- a/include/path.h
+++ b/include/path.h
@@ -56,6 +56,7 @@ extern void fs_table_insert_project_path(char *__dir, uint __projid);
 
 
 extern fs_path_t *fs_table_lookup(const char *__dir, uint __flags);
+extern fs_path_t *fs_table_lookup_mount(const char *__dir);
 
 typedef struct fs_cursor {
 	uint		count;		/* total count of mount entries	*/
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 816acc2..b767e9d 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -65,6 +65,9 @@ fs_device_number(
  * Find the FS table entry for the given path.  The "flags" argument
  * is a mask containing FS_MOUNT_POINT or FS_PROJECT_PATH (or both)
  * to indicate the type of table entry sought.
+ * fs_table_lookup() finds the fs table entry for the filesystem hosting
+ * the file represented in the "dir" argument. To compare against actual
+ * mount point entries, use fs_table_lookup_mount() instead.
  */
 struct fs_path *
 fs_table_lookup(
@@ -86,6 +89,34 @@ fs_table_lookup(
 	return NULL;
 }
 
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
 static int
 fs_table_insert(
 	char		*dir,
-- 
2.9.3

