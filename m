Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfCNVEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:04:49 -0400
Subject: [PATCH 09/36] xfs_io: don't walk off the end of argv in fzero_f
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:04:45 -0700
Message-ID: <155259748531.31886.6568534900832262149.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The fzero_f function doesn't check that there are enough non-switch
parameters to supply offset and length arguments to fallocate.  As a
result, we can walk off the end of the argv array and crash.  A
secondary problem is that we don't use getopt to detect the -k, which is
not how most xfs_io commands work.

Therefore, use getopt to detect the -k argument and rewire the offset
and length interpretation code to check optind and use argv correctly.
This bug is trivially reproduced by "xfs_io -c 'fzero -k 0' /some/file".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/prealloc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 9a372bae..6d452354 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -285,18 +285,24 @@ fzero_f(
 {
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_ZERO_RANGE;
-	int		index = 1;
+	int		c;
 
-	if (strncmp(argv[index], "-k", 3) == 0) {
-		mode |= FALLOC_FL_KEEP_SIZE;
-		index++;
+	while ((c = getopt(argc, argv, "k")) != EOF) {
+		switch (c) {
+		case 'k':
+			mode |= FALLOC_FL_KEEP_SIZE;
+			break;
+		default:
+			command_usage(&fzero_cmd);
+		}
 	}
+        if (optind != argc - 2)
+                return command_usage(&fzero_cmd);
 
-	if (!offset_length(argv[index], argv[index + 1], &segment))
+	if (!offset_length(argv[optind], argv[optind + 1], &segment))
 		return 0;
 
-	if (fallocate(file->fd, mode,
-			segment.l_start, segment.l_len)) {
+	if (fallocate(file->fd, mode, segment.l_start, segment.l_len)) {
 		perror("fallocate");
 		return 0;
 	}
