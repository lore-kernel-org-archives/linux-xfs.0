Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0615B7F51
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 16:21:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAA2A8F804C
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 14:21:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cASQWFgynDLhHQur for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 14:21:23 -0700 (PDT)
Message-ID: <53C449D2.6090008@sandeen.net>
Date: Mon, 14 Jul 2014 16:21:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfsprogs: libxcmd/paths: make all comparisons using
	realpath'd paths
References: <53C09034.3070203@redhat.com> <53C090A0.9050403@sandeen.net>
In-Reply-To: <53C090A0.9050403@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Both mountpoints and devices can be symlinks, so given a path
to look for, and mountpoints/devices from the system, use
realpath() on *everything* before making the comparison to see
if our path is a match.

So, with symlinks for mount points as well as for devices:

# ls -l /dev/mapper/testvg-lvol0 
lrwxrwxrwx. 1 root root 7 Jul 11 19:24 /dev/mapper/testvg-lvol0 -> ../dm-3
# ls -l /mnt/scratch2
lrwxrwxrwx. 1 root root 12 Jul 11 19:57 /mnt/scratch2 -> /mnt/scratch

this should all work, and does now:

# xfs_quota -xc "report -h" /mnt/scratch2
User quota on /mnt/scratch (/dev/mapper/testvg-lvol0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

# xfs_quota -xc "report -h" /mnt/scratch
User quota on /mnt/scratch (/dev/mapper/testvg-lvol0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

# xfs_quota -xc "report -h" /dev/dm-3 
User quota on /mnt/scratch (/dev/mapper/testvg-lvol0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

# xfs_quota -xc "report -h" /dev/mapper/testvg-lvol0 
User quota on /mnt/scratch (/dev/mapper/testvg-lvol0)
                        Blocks              
User ID      Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
root            0      0      0  00 [------]

The commit:

050a7f1 xfsprogs: handle symlinks etc in fs_table_initialise_mounts()

tried to fix this earlier, but only worked one way;
it compared the argument path in both given and realpath
form to the paths in getmntent, but did not compare to
the realpaths of the getmntent devices.

If we reduce everything, everywhere, to a realpath(), we've
got our best shot at finding the match.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: remove the quota/report.c change which snuck in...
V3: don't use dynamically allocated realpaths

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 7b0e434..443adbb 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -269,6 +269,9 @@ out_nomem:
 /*
  * If *path is NULL, initialize the fs table with all xfs mount points in mtab
  * If *path is specified, search for that path in mtab
+ *
+ * Everything - path, devices, and mountpoints - are boiled down to realpath()
+ * for comparison, but fs_table is populated with what comes from getmntent.
  */
 static int
 fs_table_initialise_mounts(
@@ -278,7 +281,7 @@ fs_table_initialise_mounts(
 	FILE		*mtp;
 	char		*fslog, *fsrt;
 	int		error, found;
-	char		*rpath = NULL;
+	char		rpath[PATH_MAX], rmnt_fsname[PATH_MAX], rmnt_dir[PATH_MAX];
 
 	error = found = 0;
 	fslog = fsrt = NULL;
@@ -294,17 +297,20 @@ fs_table_initialise_mounts(
 
 	/* Use realpath to resolve symlinks, relative paths, etc */
 	if (path)
-		if ((rpath = realpath(path, NULL)) == NULL)
-			return ENOENT;
+		if (!realpath(path, rpath))
+			return errno;
 
 	while ((mnt = getmntent(mtp)) != NULL) {
 		if (strcmp(mnt->mnt_type, "xfs") != 0)
 			continue;
+		if (!realpath(mnt->mnt_dir, rmnt_dir))
+			continue;
+		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
+			continue;
+
 		if (path &&
-		    ((strcmp(path, mnt->mnt_dir) != 0) &&
-		     (strcmp(path, mnt->mnt_fsname) != 0) &&
-		     (strcmp(rpath, mnt->mnt_dir) != 0) &&
-		     (strcmp(rpath, mnt->mnt_fsname) != 0)))
+		    ((strcmp(rpath, rmnt_dir) != 0) &&
+		     (strcmp(rpath, rmnt_fsname) != 0)))
 			continue;
 		if (fs_extract_mount_options(mnt, &fslog, &fsrt))
 			continue;
@@ -316,7 +322,6 @@ fs_table_initialise_mounts(
 		}
 	}
 	endmntent(mtp);
-	free(rpath);
 
 	if (path && !found)
 		error = ENXIO;
@@ -330,6 +335,9 @@ fs_table_initialise_mounts(
 /*
  * If *path is NULL, initialize the fs table with all xfs mount points in mtab
  * If *path is specified, search for that path in mtab
+ *
+ * Everything - path, devices, and mountpoints - are boiled down to realpath()
+ * for comparison, but fs_table is populated with what comes from getmntinfo.
  */
 static int
 fs_table_initialise_mounts(
@@ -337,7 +345,7 @@ fs_table_initialise_mounts(
 {
 	struct statfs	*stats;
 	int		i, count, error, found;
-	char		*rpath = NULL;
+	char		rpath[PATH_MAX], rmntfromname[PATH_MAX], rmntonname[PATH_MAX];
 
 	error = found = 0;
 	if ((count = getmntinfo(&stats, 0)) < 0) {
@@ -348,17 +356,20 @@ fs_table_initialise_mounts(
 
 	/* Use realpath to resolve symlinks, relative paths, etc */
 	if (path)
-		if ((rpath = realpath(path, NULL)) == NULL)
-			return ENOENT;
+		if (!realpath(path, rpath))
+			return errno;
 
 	for (i = 0; i < count; i++) {
 		if (strcmp(stats[i].f_fstypename, "xfs") != 0)
 			continue;
+		if (!realpath(stats[i].f_mntfromname, rmntfromname))
+			continue;
+		if (!realpath(stats[i].f_mntonname, rmnttomname)))
+			continue;
+
 		if (path &&
-		    ((strcmp(path, stats[i].f_mntonname) != 0) &&
-		     (strcmp(path, stats[i].f_mntfromname) != 0) &&
-		     (strcmp(rpath, stats[i].f_mntonname) != 0) &&
-		     (strcmp(rpath, stats[i].f_mntfromname) != 0)))
+		    ((strcmp(rpath, rmntonname) != 0) &&
+		     (strcmp(rpath, rmntfromname) != 0)))
 			continue;
 		/* TODO: external log and realtime device? */
 		(void) fs_table_insert(stats[i].f_mntonname, 0,
@@ -369,7 +380,6 @@ fs_table_initialise_mounts(
 			break;
 		}
 	}
-	free(rpath);
 	if (path && !found)
 		error = ENXIO;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
