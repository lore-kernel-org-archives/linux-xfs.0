Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57156 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbcI3UyW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:54:22 -0400
Subject: [PATCH 3/5] xfs_io: move inode command arg handling to top
References: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <796ceb5c-bd7c-61b3-2c1c-031b2a41db34@sandeen.net>
Date: Fri, 30 Sep 2016 15:54:21 -0500
MIME-Version: 1.0
In-Reply-To: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

As it stands, collecting the inode number and testing args
validity is all tangled up; for example the test for
"-n" having no inode is buried in an else after a large
code block which handles something else.

Get inode number argument collection and testing out of the
way before doing anything else.

Clean up the error message if a non-numeric inode arg is given.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/open.c |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/io/open.c b/io/open.c
index c8c82b7..ba8b243 100644
--- a/io/open.c
+++ b/io/open.c
@@ -813,7 +813,7 @@ inode_f(
 {
 	__s32			count = 0;
 	__u64			lastino = 0;
-	__u64			userino = 0;
+	__u64			userino = NULLFSINO;
 	char			*p;
 	int			c;
 	int			verbose = 0;
@@ -835,27 +835,32 @@ inode_f(
 		}
 	}
 
-	/*
-	 * Inode number can be passed with or without extra arguments, so we
-	 * should handle inode numbers passed by user out of getopt()
-	 */
+	/* Last arg (if present) should be an inode number */
 	if (optind < argc) {
-
-		if (ret_next) {
-			cmd = XFS_IOC_FSBULKSTAT;
-		} else {
-			if ((argc > 2) && !verbose)
-				return command_usage(&inode_cmd);
-			else
-				cmd = XFS_IOC_FSBULKSTAT_SINGLE;
-		}
-
 		userino = strtoull(argv[optind], &p, 10);
 		if ((*p != '\0')) {
-			printf(_("[num] must be a numeric value\n"));
+			printf(_("%s is not a numeric inode value\n"),
+				argv[optind]);
 			exitcode = 1;
 			return 0;
 		}
+		optind++;
+	}
+
+	/* Extra junk? */
+	if (optind < argc)
+		return command_usage(&inode_cmd);
+
+	/* -n option requires an inode number */
+	if (ret_next && userino == NULLFSINO)
+		return command_usage(&inode_cmd);
+
+	if (userino != NULLFSINO) {
+
+		if (ret_next)	/* get next inode */
+			cmd = XFS_IOC_FSBULKSTAT;
+		else		/* get this inode */
+			cmd = XFS_IOC_FSBULKSTAT_SINGLE;
 
 		bulkreq.lastip = &userino;
 		bulkreq.icount = 1;
@@ -885,9 +890,6 @@ inode_f(
 			printf("%llu\n", userino);
 		return 0;
 
-	/* -n option must not be used stand alone */
-	} else if (ret_next) {
-		return command_usage(&inode_cmd);
 	}
 
 	/* We are finding last inode in use */
-- 
1.7.1

