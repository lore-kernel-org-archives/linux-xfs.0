Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38970 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbcISWL6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Sep 2016 18:11:58 -0400
Subject: [PATCH 2/2] libxfs: factor mount checks into helper function
References: <bf987720-16ef-164a-2b0f-ba7cbb13b399@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6e1172fd-077a-b6b8-dd4c-d2b5cf9334c6@sandeen.net>
Date: Mon, 19 Sep 2016 17:11:56 -0500
MIME-Version: 1.0
In-Reply-To: <bf987720-16ef-164a-2b0f-ba7cbb13b399@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

platform_check_ismounted switched to a getmntent() loop after
ustat disappeared on some new platforms.

We also use a similar mechanism for determining the
ro/rw-mounted status of a device in platform_check_iswritable.

Because the loops are essentially the same, factor them into a
single helper which accepts a VERBOSE flag to print info if the
device is found in the checked-for state, and a WRITABLE flag
which only checks specifically for a mounted and /writable/ device.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: rebase, as the ustat-removal is already committed upstream.

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 2b67d1a..30aa276 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -45,8 +45,15 @@ static int max_block_alignment;
 
 #define PROC_MOUNTED	"/proc/mounts"
 
-int
-platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
+/*
+ * Check if the filesystem is mounted.  Be verbose if asked, and
+ * optionally restrict check to /writable/ mounts (i.e. RO is OK)
+ */
+#define	CHECK_MOUNT_VERBOSE	0x1
+#define	CHECK_MOUNT_WRITABLE	0x2
+
+static int
+platform_check_mount(char *name, char *block, struct stat64 *s, int flags)
 {
 	FILE		*f;
 	struct stat64	st, mst;
@@ -54,6 +61,7 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 	char		mounts[MAXPATHLEN];
 
 	if (!s) {
+		/* If either fails we are not mounted */
 		if (stat64(block, &st) < 0)
 			return 0;
 		if ((st.st_mode & S_IFMT) != S_IFBLK)
@@ -63,6 +71,7 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 
 	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
 	if ((f = setmntent(mounts, "r")) == NULL) {
+		/* Unexpected failure, warn unconditionally */
 		fprintf(stderr,
 		    _("%s: %s possibly contains a mounted filesystem\n"),
 		    progname, name);
@@ -73,48 +82,49 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 			continue;
 		if (mst.st_dev != s->st_rdev)
 			continue;
+		/* Found our device, is RO OK? */
+		if ((flags & CHECK_MOUNT_WRITABLE) && hasmntopt(mnt, MNTOPT_RO))
+			continue;
+		else
+			break;
+	}
+	endmntent(f);
+
+	/* No mounts contained the condition we were looking for */
+	if (mnt == NULL)
+		return 0;
 
-		if (verbose)
+	if (flags & CHECK_MOUNT_VERBOSE) {
+		if (flags & CHECK_MOUNT_WRITABLE) {
 			fprintf(stderr,
-				_("%s: %s contains a mounted filesystem\n"),
+_("%s: %s contains a mounted and writable filesystem\n"),
 				progname, name);
-		break;
-	}
-	endmntent(f);
-	return mnt != NULL;
+		} else {
+			fprintf(stderr,
+_("%s: %s contains a mounted filesystem\n"),
+				progname, name);
+		}
+ 	}
+	return 1;
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s)
+platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 {
-	FILE		*f;
-	struct stat64	mst;
-	struct mntent	*mnt;
-	char		mounts[MAXPATHLEN];
+	int flags;
 
-	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
-	if ((f = setmntent(mounts, "r")) == NULL) {
-		fprintf(stderr, _("%s: %s contains a possibly writable, "
-				"mounted filesystem\n"), progname, name);
-			return 1;
-	}
-	while ((mnt = getmntent(f)) != NULL) {
-		if (stat64(mnt->mnt_fsname, &mst) < 0)
-			continue;
-		if ((mst.st_mode & S_IFMT) != S_IFBLK)
-			continue;
-		if (mst.st_rdev == s->st_rdev
-		    && hasmntopt(mnt, MNTOPT_RO) != NULL)
-			break;
-	}
-	endmntent(f);
+	flags = verbose ? CHECK_MOUNT_VERBOSE : 0;
+	return platform_check_mount(name, block, s, flags);
+}
 
-	if (mnt == NULL) {
-		fprintf(stderr, _("%s: %s contains a mounted and writable "
-				"filesystem\n"), progname, name);
-		return 1;
-	}
-	return 0;
+int
+platform_check_iswritable(char *name, char *block, struct stat64 *s)
+{
+	int flags;
+
+	/* Writable checks are always verbose */
+	flags = CHECK_MOUNT_WRITABLE | CHECK_MOUNT_VERBOSE;
+	return platform_check_mount(name, block, s, flags);
 }
 
 int


