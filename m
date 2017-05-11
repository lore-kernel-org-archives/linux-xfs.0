Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34418 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757894AbdEKQsU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 12:48:20 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] generic/285: Add more SEEK_HOLE tests
Date: Thu, 11 May 2017 18:48:09 +0200
Message-Id: <20170511164809.29739-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

Add tests for bugs found in ext4 & xfs SEEK_HOLE implementations
fixed by following patches:

xfs: Fix missed holes in SEEK_HOLE implementation
ext4: Fix SEEK_HOLE

Signed-off-by: Jan Kara <jack@suse.cz>
---
 src/seek_sanity_test.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index a6dd48cc257b..86a9397fa7e9 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -246,6 +246,100 @@ out:
 }
 
 /*
+ * test file with unwritten extents, only have pagevec worth of dirty pages
+ * in page cache, a hole and then another page.
+ */
+static int test14(int fd, int testnum)
+{
+	int ret = 0;
+	char *buf = NULL;
+	int bufsz = sysconf(_SC_PAGE_SIZE) * 14;
+	int filsz = 4 << 20;
+
+	/* HOLE - unwritten DATA in dirty page */
+	/* Each unit is bufsz */
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	/* preallocate 4M space to file */
+	ret = do_fallocate(fd, 0, filsz, 0);
+	if (ret < 0) {
+		/* Report success if fs doesn't support fallocate */
+		if (errno == EOPNOTSUPP) {
+			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
+			ret = 0;
+		}
+		goto out;
+	}
+
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	ret = do_pwrite(fd, buf, bufsz, 3 * bufsz);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, bufsz);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, bufsz);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 3 * bufsz, 4 * bufsz);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, 1);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, bufsz, 3 * bufsz);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/*
+ * test file with unwritten extents, only have pagevec worth of dirty pages
+ * in page cache.
+ */
+static int test13(int fd, int testnum)
+{
+	int ret = 0;
+	char *buf = NULL;
+	int bufsz = sysconf(_SC_PAGE_SIZE) * 14;
+	int filsz = 4 << 20;
+
+	/* HOLE - unwritten DATA in dirty page */
+	/* Each unit is bufsz */
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	/* preallocate 4M space to file */
+	ret = do_fallocate(fd, 0, filsz, 0);
+	if (ret < 0) {
+		/* Report success if fs doesn't support fallocate */
+		if (errno == EOPNOTSUPP) {
+			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
+			ret = 0;
+		}
+		goto out;
+	}
+
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, bufsz);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, bufsz);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, 1);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/*
  * Test huge file to check for overflows of block counts due to usage of
  * 32-bit types.
  */
@@ -678,6 +772,8 @@ struct testrec seek_tests[] = {
        { 10, test10, "Test a huge file for offset overflow" },
        { 11, test11, "Test a huge file for block number signed" },
        { 12, test12, "Test a huge file for block number overflow" },
+       { 13, test13, "Test file with unwritten extents, only have pagevec dirty pages" },
+       { 14, test14, "Test file with unwritten extents, small hole after pagevec dirty pages" },
 };
 
 static int run_test(struct testrec *tr)
-- 
2.12.0

