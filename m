Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38682 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbcISWI0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Sep 2016 18:08:26 -0400
Subject: [PATCH 1/2] libxfs: move iswritable "fatal" decision to caller
References: <bf987720-16ef-164a-2b0f-ba7cbb13b399@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <62f0019d-c2fb-bda8-8549-a6985d4be6a4@sandeen.net>
Date: Mon, 19 Sep 2016 17:08:24 -0500
MIME-Version: 1.0
In-Reply-To: <bf987720-16ef-164a-2b0f-ba7cbb13b399@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

Simplify platform_check_iswritable by moving the "fatal decision
up to the (one) caller.  In other words, simply return whether
mounted+writable is true, and return 1 if so.  Caller decides
what to do with that info based on /its/ "fatal" argument.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Rebase

diff --git a/libxfs/darwin.c b/libxfs/darwin.c
index 017e190..19d2ab6 100644
--- a/libxfs/darwin.c
+++ b/libxfs/darwin.c
@@ -33,7 +33,7 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat64 *s)
 {
 	int	fd, writable;
 
diff --git a/libxfs/freebsd.c b/libxfs/freebsd.c
index 6c9f089..9e22183 100644
--- a/libxfs/freebsd.c
+++ b/libxfs/freebsd.c
@@ -66,7 +66,7 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat64 *s)
 {
         int cnt, i;
         struct statfs *fsinfo;
@@ -74,7 +74,7 @@ platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
         if ((cnt = getmntinfo(&fsinfo, MNT_NOWAIT)) == 0) {
 		fprintf(stderr, _("%s: %s contains a possibly writable, "
 				"mounted filesystem\n"), progname, name);
-			return fatal;
+			return 1;
 	}
 
         for (i = 0; i < cnt; i++) {
@@ -88,7 +88,7 @@ platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
         if (i == cnt) {
 		fprintf(stderr, _("%s: %s contains a mounted and writable "
 				"filesystem\n"), progname, name);
-		return fatal;
+		return 1;
 	}
 	return 0;
 }
diff --git a/libxfs/init.c b/libxfs/init.c
index c13b123..828ae3e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -75,7 +75,9 @@ check_isactive(char *name, char *block, int fatal)
 		return 0;
 	if (platform_check_ismounted(name, block, &st, 0) == 0)
 		return 0;
-	return platform_check_iswritable(name, block, &st, fatal);
+	if (platform_check_iswritable(name, block, &st))
+		return fatal ? 1 : 0;
+	return 0;
 }
 
 /* libxfs_device_to_fd:
diff --git a/libxfs/init.h b/libxfs/init.h
index 112febb..4dda3ee 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -22,8 +22,7 @@ struct stat64;
 
 extern int platform_check_ismounted (char *path, char *block,
 					struct stat64 *sptr, int verbose);
-extern int platform_check_iswritable (char *path, char *block,
-					struct stat64 *sptr, int fatal);
+extern int platform_check_iswritable (char *path, char *block, struct stat64 *sptr);
 extern int platform_set_blocksize (int fd, char *path, dev_t device, int bsz, int fatal);
 extern void platform_flush_device (int fd, dev_t device);
 extern char *platform_findrawpath(char *path);
diff --git a/libxfs/irix.c b/libxfs/irix.c
index 65aaa7e..c23ebe0 100644
--- a/libxfs/irix.c
+++ b/libxfs/irix.c
@@ -31,7 +31,7 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat64 *s)
 {
 	return 1;
 }
diff --git a/libxfs/linux.c b/libxfs/linux.c
index 44bc1f9..2b67d1a 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -85,9 +85,8 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat64 *s)
 {
-	int		sts = 0;
 	FILE		*f;
 	struct stat64	mst;
 	struct mntent	*mnt;
@@ -97,7 +96,7 @@ platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
 	if ((f = setmntent(mounts, "r")) == NULL) {
 		fprintf(stderr, _("%s: %s contains a possibly writable, "
 				"mounted filesystem\n"), progname, name);
-			return fatal;
+			return 1;
 	}
 	while ((mnt = getmntent(f)) != NULL) {
 		if (stat64(mnt->mnt_fsname, &mst) < 0)
@@ -108,13 +107,14 @@ platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
 		    && hasmntopt(mnt, MNTOPT_RO) != NULL)
 			break;
 	}
+	endmntent(f);
+
 	if (mnt == NULL) {
 		fprintf(stderr, _("%s: %s contains a mounted and writable "
 				"filesystem\n"), progname, name);
-		sts = fatal;
+		return 1;
 	}
-	endmntent(f);
-	return sts;
+	return 0;
 }
 
 int


