Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57028 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751712AbcI3UxE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:53:04 -0400
Subject: [PATCH 2/5] xfs_io: factor out new get_last_inode() helper
References: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cc70dd3b-3566-7409-4fd5-84e1df05c451@sandeen.net>
Date: Fri, 30 Sep 2016 15:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

The inode command by default finds the last allocated
inode in the filesystem via bulkstat, and this specific
function is open-coded after other cases are handled, leading
to a fairly long inode_f function and confusing code flow.

Clean it up by factoring it into a new function, more refactoring
will follow.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/open.c |   68 +++++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/io/open.c b/io/open.c
index 5efa739..c8c82b7 100644
--- a/io/open.c
+++ b/io/open.c
@@ -767,14 +767,51 @@ inode_help(void)
 "\n"));
 }
 
+static __u64
+get_last_inode(void)
+{
+	__u64			lastip = 0;
+	__u64			lastgrp = 0;
+	__s32			ocount = 0;
+	__u64			last_ino;
+	struct xfs_inogrp	igroup[1024];
+	struct xfs_fsop_bulkreq	bulkreq;
+
+	bulkreq.lastip = &lastip;
+	bulkreq.ubuffer = &igroup;
+	bulkreq.icount = sizeof(igroup) / sizeof(struct xfs_inogrp);
+	bulkreq.ocount = &ocount;
+
+	for (;;) {
+		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
+				&bulkreq)) {
+			perror("XFS_IOC_FSINUMBERS");
+			return 0;
+		}
+
+		/* Did we reach the last inode? */
+		if (ocount == 0)
+			break;
+
+		/* last inode in igroup table */
+		lastgrp = ocount;
+	}
+
+	lastgrp--;
+
+	/* The last inode number in use */
+	last_ino = igroup[lastgrp].xi_startino +
+		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
+
+	return last_ino;
+}
+
 static int
 inode_f(
 	  int			argc,
 	  char			**argv)
 {
 	__s32			count = 0;
-	__s32			lastgrp = 0;
-	__u64			last = 0;
 	__u64			lastino = 0;
 	__u64			userino = 0;
 	char			*p;
@@ -782,7 +819,6 @@ inode_f(
 	int			verbose = 0;
 	int			ret_next = 0;
 	int			cmd = 0;
-	struct xfs_inogrp	igroup[1024];
 	struct xfs_fsop_bulkreq	bulkreq;
 	struct xfs_bstat	bstat;
 
@@ -854,29 +890,13 @@ inode_f(
 		return command_usage(&inode_cmd);
 	}
 
-	bulkreq.lastip = &last;
-	bulkreq.icount = 1024; /* User-defined maybe!? */
-	bulkreq.ubuffer = &igroup;
-	bulkreq.ocount = &count;
-
-	for (;;) {
-		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
-				&bulkreq)) {
-			perror("XFS_IOC_FSINUMBERS");
-			exitcode = 1;
-			return 0;
-		}
-
-		if (count == 0)
-			break;
-
-		lastgrp = count;
+	/* We are finding last inode in use */
+	lastino = get_last_inode();
+	if (!lastino) {
+		exitcode = 1;
+		return 0;
 	}
 
-	lastgrp--;
-	lastino = igroup[lastgrp].xi_startino +
-		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
-
 	if (verbose)
 		printf("%llu:%d\n", lastino,
 			lastino > XFS_MAXINUMBER_32 ? 64 : 32);
-- 
1.7.1

