Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B9C97F50
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 12:01:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBC4A304053
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 10:01:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id McEET6CFwlbPe2cr for
	<xfs@oss.sgi.com>; Mon, 30 Sep 2013 10:01:23 -0700 (PDT)
Message-ID: <5249AE5F.30305@redhat.com>
Date: Mon, 30 Sep 2013 12:01:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Commit:

6a23747d xfs_quota: support relative path as `path' arguments

used realpath() on the supplied pathname to handle things like
relative pathnames and pathnames ending in "/" which otherwise
caused the getmntent scanning to fail.

However, this regressed cases where a path in mtab was a symlink;
realpath() resolves this to the target, and so no match is found.

This causes i.e.:

# xfs_quota -x -c report /dev/mapper/testvg-testlv

to fail with:

xfs_quota: cannot setup path for mount /dev/mapper/testvg-testlv: No such device or address

because the scanning looks for /dev/dm-3, but the long symlink
name is what exists in mtab, and no match is found.

Fix this, but keep the intended enhancements, by testing *both* the
user-specified path (which might be relative, or contain a trailing
slash on a mountpoint) and the realpath-resolved path (which turns
a relative mountpoint into a full path, and removes trailing slashes),
to determine whether the user-specified path is an xfs mountpoint or
device.

While we're at it, add a few comments, and go back to the testing
of "path" not "rpath"; whether or not path is passed to the function
is what determines control flow.  If path is specified, and realpath
succeeds, we're guaranteed to have rpath as well, so there is no need
to retest that.  rpath is initialized to NULL, so an unconditional
free(rpath) is safe as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index bd84cde..7b0e434 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -266,6 +266,10 @@ out_nomem:
 	return ENOMEM;
 }
 
+/*
+ * If *path is NULL, initialize the fs table with all xfs mount points in mtab
+ * If *path is specified, search for that path in mtab
+ */
 static int
 fs_table_initialise_mounts(
 	char		*path)
@@ -288,6 +292,7 @@ fs_table_initialise_mounts(
 	if ((mtp = setmntent(mtab_file, "r")) == NULL)
 		return ENOENT;
 
+	/* Use realpath to resolve symlinks, relative paths, etc */
 	if (path)
 		if ((rpath = realpath(path, NULL)) == NULL)
 			return ENOENT;
@@ -295,31 +300,37 @@ fs_table_initialise_mounts(
 	while ((mnt = getmntent(mtp)) != NULL) {
 		if (strcmp(mnt->mnt_type, "xfs") != 0)
 			continue;
-		if (rpath &&
-		    ((strcmp(rpath, mnt->mnt_dir) != 0) &&
+		if (path &&
+		    ((strcmp(path, mnt->mnt_dir) != 0) &&
+		     (strcmp(path, mnt->mnt_fsname) != 0) &&
+		     (strcmp(rpath, mnt->mnt_dir) != 0) &&
 		     (strcmp(rpath, mnt->mnt_fsname) != 0)))
 			continue;
 		if (fs_extract_mount_options(mnt, &fslog, &fsrt))
 			continue;
 		(void) fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
 					mnt->mnt_fsname, fslog, fsrt);
-		if (rpath) {
+		if (path) {
 			found = 1;
 			break;
 		}
 	}
 	endmntent(mtp);
-	if (rpath) {
-		free(rpath);
-		if (!found)
-			error = ENXIO;
-	}
+	free(rpath);
+
+	if (path && !found)
+		error = ENXIO;
+
 	return error;
 }
 
 #elif defined(HAVE_GETMNTINFO)
 #include <sys/mount.h>
 
+/*
+ * If *path is NULL, initialize the fs table with all xfs mount points in mtab
+ * If *path is specified, search for that path in mtab
+ */
 static int
 fs_table_initialise_mounts(
 	char		*path)
@@ -335,6 +346,7 @@ fs_table_initialise_mounts(
 		return 0;
 	}
 
+	/* Use realpath to resolve symlinks, relative paths, etc */
 	if (path)
 		if ((rpath = realpath(path, NULL)) == NULL)
 			return ENOENT;
@@ -342,24 +354,24 @@ fs_table_initialise_mounts(
 	for (i = 0; i < count; i++) {
 		if (strcmp(stats[i].f_fstypename, "xfs") != 0)
 			continue;
-		if (rpath &&
-		    ((strcmp(rpath, stats[i].f_mntonname) != 0) &&
+		if (path &&
+		    ((strcmp(path, stats[i].f_mntonname) != 0) &&
+		     (strcmp(path, stats[i].f_mntfromname) != 0) &&
+		     (strcmp(rpath, stats[i].f_mntonname) != 0) &&
 		     (strcmp(rpath, stats[i].f_mntfromname) != 0)))
 			continue;
 		/* TODO: external log and realtime device? */
 		(void) fs_table_insert(stats[i].f_mntonname, 0,
 					FS_MOUNT_POINT, stats[i].f_mntfromname,
 					NULL, NULL);
-		if (rpath) {
+		if (path) {
 			found = 1;
 			break;
 		}
 	}
-	if (rpath) {
-		free(rpath);
-		if (!found)
-			error = ENXIO;
-	}
+	free(rpath);
+	if (path && !found)
+		error = ENXIO;
 
 	return error;
 }



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
