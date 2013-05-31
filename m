Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C65957F4E
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 10:45:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1540304089
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 08:45:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8LzSHlJYzPqhqqea for
	<xfs@oss.sgi.com>; Fri, 31 May 2013 08:45:33 -0700 (PDT)
Message-ID: <51A8C59B.3030308@redhat.com>
Date: Fri, 31 May 2013 10:45:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
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
To: xfs-oss <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

currently the seek_sanity_test (generic/285) fails on ext3
or ext2 due to fallocate() failures.  Just ignore that test
if the fs doesn't support fallocate.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index cd3b1ee..fbf5a8c 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -96,9 +96,13 @@ static int do_fallocate(int fd, off_t offset, off_t length, int mode)
 	int ret;
 
 	ret = fallocate(fd, mode, offset, length);
-	if (ret)
+	if (ret) {
+		/* Don't warn about a filesystem w/o fallocate support */
+		if (errno == EOPNOTSUPP)
+			return ret;
 		fprintf(stderr, "  ERROR %d: Failed to preallocate "
 			"space to %ld bytes\n", errno, (long) length);
+	}
 
 	return ret;
 }
@@ -290,8 +294,14 @@ static int test09(int fd, int testnum)
 
 	/* preallocate 8M space to file */
 	ret = do_fallocate(fd, 0, filsz, 0);
-	if (ret < 0)
+	if (ret < 0) {
+		/* Report success if fs doesn't support fallocate */
+		if (errno == EOPNOTSUPP) {
+			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
+			ret = 0;
+		}
 		goto out;
+	}
 
 	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
 	if (!ret) {
@@ -336,8 +346,14 @@ static int test08(int fd, int testnum)
 
 	/* preallocate 4M space to file */
 	ret = do_fallocate(fd, 0, filsz, 0);
-	if (ret < 0)
+	if (ret < 0) {
+		/* Report success if fs doesn't support fallocate */
+		if (errno == EOPNOTSUPP) {
+			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
+			ret = 0;
+		}
 		goto out;
+	}
 
 	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
 	if (ret)
@@ -379,8 +395,14 @@ static int test07(int fd, int testnum)
 
 	/* preallocate 4M space to file */
 	ret = do_fallocate(fd, 0, filsz, 0);
-	if (ret < 0)
+	if (ret < 0) {
+		/* Report success if fs doesn't support fallocate */
+		if (errno == EOPNOTSUPP) {
+			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
+			ret = 0;
+		}
 		goto out;
+	}
 
 	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
 	if (ret)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
