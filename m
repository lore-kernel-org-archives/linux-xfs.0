Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0952B7CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 09:10:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 680A0AC002
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 07:10:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VD6NW2rCXFEuuehR for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2016 07:10:12 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 93E8AEC2
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 09:10:11 -0500 (CDT)
Subject: [PATCH 1/2] libxfs: move iswritable "fatal" decision to caller
References: <ed60d5a2-0343-fd49-236e-52f9442291d2@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <39fbb09c-698f-58cf-99d2-013726773bcb@sandeen.net>
Date: Thu, 8 Sep 2016 09:10:11 -0500
MIME-Version: 1.0
In-Reply-To: <ed60d5a2-0343-fd49-236e-52f9442291d2@redhat.com>
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
To: xfs@oss.sgi.com

Simplify platform_check_iswritable by moving the
"fatal" decision up to the (one) caller.  In other words,
simply return whether mounted+writable is true, and
return 1 if so.  Caller decides what to do with that info
based on /its/ "fatal" argument.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

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
index c9f2baf..67b615b 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -74,9 +74,8 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat64 *s)
 {
-	int		sts = 0;
 	FILE		*f;
 	struct stat64	mst;
 	struct mntent	*mnt;
@@ -86,7 +85,7 @@ platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
 	if ((f = setmntent(mounts, "r")) == NULL) {
 		fprintf(stderr, _("%s: %s contains a possibly writable, "
 				"mounted filesystem\n"), progname, name);
-			return fatal;
+			return 1;
 	}
 	while ((mnt = getmntent(f)) != NULL) {
 		if (stat64(mnt->mnt_fsname, &mst) < 0)
@@ -97,13 +96,14 @@ platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
