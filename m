Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57364 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751400AbcI3U4H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:56:07 -0400
Subject: [PATCH 4/5] xfs_io: refactor inode command
References: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4862fa94-e367-88fd-056a-c9748b6965de@sandeen.net>
Date: Fri, 30 Sep 2016 15:56:06 -0500
MIME-Version: 1.0
In-Reply-To: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

The inode_f function is a bit convoluted; the default
find-last-inode case appears at the end, there are several return
points, we print the same basic information using 2 different variables
in 2 different locations depending on the mode we're in, the
"inode not found" was a printf & exit in the middle of the function,
 etc.

Move the default case up to the top so it's more obvious, not
buried.

Make a new var, result_ino, which holds whatever we want to print
regardless of the mode, and then handle all the output at the end.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/open.c |   65 ++++++++++++++++++++++++++++--------------------------------
 1 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/io/open.c b/io/open.c
index ba8b243..7d952a0 100644
--- a/io/open.c
+++ b/io/open.c
@@ -812,7 +812,7 @@ inode_f(
 	  char			**argv)
 {
 	__s32			count = 0;
-	__u64			lastino = 0;
+	__u64			result_ino = 0;
 	__u64			userino = NULLFSINO;
 	char			*p;
 	int			c;
@@ -855,8 +855,14 @@ inode_f(
 	if (ret_next && userino == NULLFSINO)
 		return command_usage(&inode_cmd);
 
-	if (userino != NULLFSINO) {
-
+	if (userino == NULLFSINO) {
+		/* We are finding last inode in use */
+		result_ino = get_last_inode();
+		if (!result_ino) {
+			exitcode = 1;
+			return 0;
+		}
+	} else {
 		if (ret_next)	/* get next inode */
 			cmd = XFS_IOC_FSBULKSTAT;
 		else		/* get this inode */
@@ -868,43 +874,32 @@ inode_f(
 		bulkreq.ocount = &count;
 
 		if (xfsctl(file->name, file->fd, cmd, &bulkreq)) {
-			if (errno == EINVAL) {
-				if (!ret_next)
-					printf("0\n");
+			if (!ret_next && errno == EINVAL) {
+				/* Not in use */
+				result_ino = 0;
 			} else {
 				perror("xfsctl");
+				exitcode = 1;
+				return 0;
 			}
-			exitcode = 1;
-			return 0;
-		}
-
-		if (ret_next)
-			userino = bstat.bs_ino;
-
-		if (verbose)
-			printf("%llu:%d\n",
-			       userino,
-			       userino > XFS_MAXINUMBER_32 ? 64 : 32);
-		else
-			/* Inode in use */
-			printf("%llu\n", userino);
-		return 0;
-
-	}
-
-	/* We are finding last inode in use */
-	lastino = get_last_inode();
-	if (!lastino) {
-		exitcode = 1;
-		return 0;
+		} else if (ret_next)	/* The next inode in use */
+			result_ino = bstat.bs_ino;
+		else			/* The inode we asked about */
+			result_ino = userino;
+	}
+
+	if (verbose && result_ino) {
+		/* Requested verbose and we have an answer */
+		printf("%llu:%d\n", result_ino,
+			result_ino > XFS_MAXINUMBER_32 ? 64 : 32);
+	} else if (userino == NULLFSINO) {
+		/* Just checking 32 or 64 bit presence, non-verbose */
+		printf("%d\n", result_ino > XFS_MAXINUMBER_32 ? 1 : 0);
+	} else {
+		/* We asked about a specific inode, non-verbose */
+		printf("%llu\n", result_ino);
 	}
 
-	if (verbose)
-		printf("%llu:%d\n", lastino,
-			lastino > XFS_MAXINUMBER_32 ? 64 : 32);
-	else
-		printf("%d\n", lastino > XFS_MAXINUMBER_32 ? 1 : 0);
-
 	return 0;
 }
 
-- 
1.7.1

