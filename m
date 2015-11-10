Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A94D77F47
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 14:45:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C8CA304032
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 12:45:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WTAwerSubci5rbpy for <xfs@oss.sgi.com>;
	Tue, 10 Nov 2015 12:45:47 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4327265BD16C
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 14:45:47 -0600 (CST)
Subject: [PATCH] xfsprogs: tidy up xfs_fsr.c
References: <56423596.3030300@redhat.com> <20151110202806.GG14311@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5642577A.8000206@sandeen.net>
Date: Tue, 10 Nov 2015 14:45:46 -0600
MIME-Version: 1.0
In-Reply-To: <20151110202806.GG14311@dastard>
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

Make the mountpoint stat structure "ms" local to
find_mountpoint_check(), no caller uses it.  And remove 3rd
"sb2" statbuf in that same function, we can just re-use ms.

rename "struct mntent *mp" to "struct mntent *mnt" -
"mp" has its own common meaning in xfsprogs.

And a couple more minor whitespace removals.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 2887ceb..d5962f7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -177,44 +177,41 @@ aborter(int unused)
  * of that.
  */
 static char *
-find_mountpoint_check(struct stat64 *sb, struct mntent *t, struct stat64 *ms)
+find_mountpoint_check(struct stat64 *sb, struct mntent *t)
 {
+	struct stat64 ms;
+
 	if (S_ISDIR(sb->st_mode)) {		/* mount point */
-		if (stat64(t->mnt_dir, ms) < 0)
+		if (stat64(t->mnt_dir, &ms) < 0)
 			return NULL;
-		if (sb->st_ino != ms->st_ino)
+		if (sb->st_ino != ms.st_ino)
 			return NULL;
-		if (sb->st_dev != ms->st_dev)
+		if (sb->st_dev != ms.st_dev)
 			return NULL;
 		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
 			return NULL;
 	} else {				/* device */
-		struct stat64 sb2;
-
-		if (stat64(t->mnt_fsname, ms) < 0)
+		if (stat64(t->mnt_fsname, &ms) < 0)
 			return NULL;
-		if (sb->st_rdev != ms->st_rdev)
+		if (sb->st_rdev != ms.st_rdev)
 			return NULL;
 		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
 			return NULL;
-
 		/*
 		 * Make sure the mountpoint given by mtab is accessible
 		 * before using it.
 		 */
-		if (stat64(t->mnt_dir, &sb2) < 0)
+		if (stat64(t->mnt_dir, &ms) < 0)
 			return NULL;
 	}
 
 	return t->mnt_dir;
-
 }
 
 static char *
 find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 {
 	struct mntent_cursor cursor;
-	struct stat64 ms;
 	struct mntent *t = NULL;
 	char *mntp = NULL;
 
@@ -224,7 +221,7 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 	}
 
 	while ((t = platform_mntent_next(&cursor)) != NULL) {
-		mntp = find_mountpoint_check(sb, t, &ms);
+		mntp = find_mountpoint_check(sb, t);
 		if (mntp == NULL)
 			continue;
 		break;
@@ -408,7 +405,7 @@ static void
 initallfs(char *mtab)
 {
 	struct mntent_cursor cursor;
-	struct mntent *mp = NULL;
+	struct mntent *mnt= NULL;
 	int mi;
 	char *cp;
 	struct stat64 sb;
@@ -429,15 +426,15 @@ initallfs(char *mtab)
 		exit(1);
 	}
 
-	while ((mp = platform_mntent_next(&cursor)) != NULL) {
+	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
 		int rw = 0;
 
-		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0 ||
-		    stat64(mp->mnt_fsname, &sb) == -1 ||
+		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
+		    stat64(mnt->mnt_fsname, &sb) == -1 ||
 		    !S_ISBLK(sb.st_mode))
 			continue;
 
-		cp = strtok(mp->mnt_opts,",");
+		cp = strtok(mnt->mnt_opts,",");
 		do {
 			if (strcmp("rw", cp) == 0)
 				rw++;
@@ -445,7 +442,7 @@ initallfs(char *mtab)
 		if (rw == 0) {
 			if (dflag)
 				fsrprintf(_("Skipping %s: not mounted rw\n"),
-					mp->mnt_fsname);
+					mnt->mnt_fsname);
 			continue;
 		}
 
@@ -465,15 +462,15 @@ initallfs(char *mtab)
 			fs = (fsbase + mi);  /* Needed ? */
 		}
 
-		fs->dev = strdup(mp->mnt_fsname);
-		fs->mnt = strdup(mp->mnt_dir);
+		fs->dev = strdup(mnt->mnt_fsname);
+		fs->mnt = strdup(mnt->mnt_dir);
 
 		if (fs->dev == NULL) {
-			fsrprintf(_("strdup(%s) failed\n"), mp->mnt_fsname);
+			fsrprintf(_("strdup(%s) failed\n"), mnt->mnt_fsname);
 			exit(1);
 		}
 		if (fs->mnt == NULL) {
-			fsrprintf(_("strdup(%s) failed\n"), mp->mnt_dir);
+			fsrprintf(_("strdup(%s) failed\n"), mnt->mnt_dir);
 			exit(1);
 		}
 		mi++;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
