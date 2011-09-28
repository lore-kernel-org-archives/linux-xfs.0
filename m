Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SAvJY3103518 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 05:57:19 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 5/5] xfsprogs: libxcmd: use fs_device_number() consistently
Date: Wed, 28 Sep 2011 05:57:12 -0500
Message-Id: <c6abffe0a5f72665410627b5a03333627a860818.1317207144.git.aelder@sgi.com>
In-Reply-To: <1317207432-8464-1-git-send-email-aelder@sgi.com>
References: <1317207432-8464-1-git-send-email-aelder@sgi.com>
In-Reply-To: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
References: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
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

The libxcmd code builds up a table that records information about
all filesystems that might be subject to quotas, as well as a set
of directories that are the roots of project quota trees.

When building the table, the device number for each affected
filesystem is determined (in fs_device_number()) using a call to
stat64().  It turns out that in all cases when doing this, a
directory path (and *not* a device special file path) is specified,
in which case the appropriate filesystem device id is found in the
st_dev field produce by the call to stat64() (i.e., the device id
for the mounted filesystem containing the path).  Accordingly,
fs_device_number() always returns the st_dev field.

Another routine, fs_table_lookup(), looks up an entry in this table
based on the path name provided.  However this function allows a
path to a device special file be provided.  In that case the right
device id to use is found in the st_rdev field returned by stat64().

I found this to be confusing, and it took a while to convince
myself that this wasn't actually bug.  (It wasn't initially clear
that device special files were never passed to fs_device_number().)

In order to prevent myself and others from ever wasting time like
this again, use fs_device_number() every time a device number is
needed, and in doing so determine it consistently in all cases (that
is--use st_rdev for device special files and st_dev otherwise).

In the process, change fs_device_number() to return an zero on
success (or an errno) rather than its first argument (or NULL).

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   46 +++++++++++++++++++++-------------------------
 1 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index aa0aeb6..f4110d4 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -37,18 +37,26 @@ struct fs_path *fs_path;
 char *mtab_file;
 #define PROC_MOUNTS	"/proc/self/mounts"
 
-static char *
+static int
 fs_device_number(
-	char		*name,
+	const char	*name,
 	dev_t		*devnum)
 {
 	struct stat64	sbuf;
 
 	if (stat64(name, &sbuf) < 0)
-		return NULL;
-	*devnum = sbuf.st_dev;
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
 
-	return name;
+	return 0;
 }
 
 /*
@@ -61,23 +69,12 @@ fs_table_lookup(
 	const char	*dir,
 	uint		flags)
 {
-	struct stat64	sbuf;
 	uint		i;
-	dev_t		dev;
+	dev_t		dev = 0;
 
-	if (stat64(dir, &sbuf) < 0)
+	if (fs_device_number(dir, &dev))
 		return NULL;
 
-	/*
-	 * We want to match st_rdev if the directory provided is a
-	 * device special file.  Otherwise we are looking for the
-	 * the device id for the containing filesystem, in st_dev.
-	 */
-	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode))
-		dev = sbuf.st_rdev;
-	else
-		dev = sbuf.st_dev;
-
 	for (i = 0; i < fs_count; i++) {
 		if ((flags & fs_table[i].fs_flags) == 0)
 			continue;
@@ -103,11 +100,11 @@ fs_table_insert(
 		return EINVAL;
 
 	datadev = logdev = rtdev = 0;
-	if (!fs_device_number(dir, &datadev))
+	if (fs_device_number(dir, &datadev))
 		return errno;
-	if (fslog && !fs_device_number(fslog, &logdev))
+	if (fslog && fs_device_number(fslog, &logdev))
 		return errno;
-	if (fsrt && !fs_device_number(fsrt, &rtdev))
+	if (fsrt && fs_device_number(fsrt, &rtdev))
 		return errno;
 
 	tmp_fs_table = realloc(fs_table, sizeof(fs_path_t) * (fs_count + 1));
@@ -293,15 +290,14 @@ fs_mount_point_from_path(
 {
 	fs_cursor_t	cursor;
 	fs_path_t	*fs;
-	struct stat64	s;
+	dev_t		dev = 0;
 
-	if (stat64(dir, &s) < 0) {
+	if (fs_device_number(dir, &dev))
 		return NULL;
-	}
 
 	fs_cursor_initialise(NULL, FS_MOUNT_POINT, &cursor);
 	while ((fs = fs_cursor_next_entry(&cursor))) {
-		if (fs->fs_datadev == s.st_dev)
+		if (fs->fs_datadev == dev)
 			break;
 	}
 	return fs;
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
