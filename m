Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44840 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754676AbcIHOQN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Sep 2016 10:16:13 -0400
Subject: [PATCH 2/2] libxfs: remove ustat() use, factor mount checks into
 helper function
References: <ed60d5a2-0343-fd49-236e-52f9442291d2@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a4e1e08e-1f5f-82b4-7dc2-52ede960aa39@sandeen.net>
Date: Thu, 8 Sep 2016 09:16:11 -0500
MIME-Version: 1.0
In-Reply-To: <ed60d5a2-0343-fd49-236e-52f9442291d2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

ustat() has been deprecated for a very long time, and newer
architectures (aarch64, for one) have not implemented it.
If called, it always returns false, so we can no longer use
it to determine a device's mounted status.

We already have another mechanism for determining the mounted
status of a device in platform_check_iswritable; it iterates
over getmntent looking for the device, and checks its mount
options.  We can do the same thing to check for a simple mount,
and not caring about the "ro" mount option.

Because the loop is essentially the same, factor it into a
helper which accepts a VERBOSE flag to print info if the device
is found in the checked-for state, and a WRITABLE flag which
only checks specifically for a mounted and /writable/ device.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Dave, up to you if you want to take all this in lieu of the
fixed-up patch from Felix, or if you'd like me to rebase this
once you have merged that patch.  Happy to do that if you'd like -
now that I think about it, that may be the cleaner progression
of changes.

Thanks,
-Eric

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 67b615b..fad9a4a 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -48,14 +48,24 @@ static int max_block_alignment;
 
 #define PROC_MOUNTED	"/proc/mounts"
 
-int
-platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
+/*
+ * Check if the filesystem is mounted.  Be verbose if asked, and
+ * optionally restrict check to writable mounts.
+ */
+#define	CHECK_MOUNT_VERBOSE	0x1
+#define	CHECK_MOUNT_WRITABLE	0x2
+
+static int
+platform_check_mount(char *name, char *block, struct stat64 *s, int flags)
 {
-	/* Pad ust; pre-2.6.28 linux copies out too much in 32bit compat mode */
-	struct ustat	ust[2];
 	struct stat64	st;
+	struct stat64	mst;
+	FILE		*f;
+	struct mntent	*mnt;
+	char		mounts[MAXPATHLEN];
 
 	if (!s) {
+		/* If either fails we are neither mounted nor writable */
 		if (stat64(block, &st) < 0)
 			return 0;
 		if ((st.st_mode & S_IFMT) != S_IFBLK)
@@ -63,47 +73,64 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 		s = &st;
 	}
 
-	if (ustat(s->st_rdev, ust) >= 0) {
-		if (verbose)
-			fprintf(stderr,
-				_("%s: %s contains a mounted filesystem\n"),
-				progname, name);
-		return 1;
-	}
-	return 0;
-}
-
-int
-platform_check_iswritable(char *name, char *block, struct stat64 *s)
-{
-	FILE		*f;
-	struct stat64	mst;
-	struct mntent	*mnt;
-	char		mounts[MAXPATHLEN];
-
 	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
 	if ((f = setmntent(mounts, "r")) == NULL) {
+		/* Unexpected failure, warn unconditionally */
 		fprintf(stderr, _("%s: %s contains a possibly writable, "
 				"mounted filesystem\n"), progname, name);
-			return 1;
+		return 1;
 	}
+
 	while ((mnt = getmntent(f)) != NULL) {
 		if (stat64(mnt->mnt_fsname, &mst) < 0)
 			continue;
 		if ((mst.st_mode & S_IFMT) != S_IFBLK)
 			continue;
-		if (mst.st_rdev == s->st_rdev
-		    && hasmntopt(mnt, MNTOPT_RO) != NULL)
-			break;
+		if (mst.st_rdev == s->st_rdev) {
+			/* Found our device */
+			if (!(flags & CHECK_MOUNT_WRITABLE) ||
+			    !hasmntopt(mnt, MNTOPT_RO))
+				break;
+		}
 	}
 	endmntent(f);
 
-	if (mnt == NULL) {
-		fprintf(stderr, _("%s: %s contains a mounted and writable "
-				"filesystem\n"), progname, name);
-		return 1;
+	/* No mounts contained the condition we were looking for */
+	if (mnt == NULL)
+		return 0;
+
+	if (flags & CHECK_MOUNT_VERBOSE) {
+		if (flags & CHECK_MOUNT_WRITABLE) {
+			fprintf(stderr,
+_("%s: %s contains a mounted and writable filesystem\n"),
+				progname, name);
+		} else {
+			fprintf(stderr,
+_("%s: %s contains a mounted filesystem\n"),
+				progname, name);
+		}
 	}
-	return 0;
+
+	return 1;
+}
+
+int
+platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
+{
+	int flags;
+
+	flags = verbose ? CHECK_MOUNT_VERBOSE : 0;
+	return platform_check_mount(name, block, s, flags);
+}
+
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

