Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37148 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdH3Ov2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:28 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 05/14] fsx: fix compile warnings
Date: Wed, 30 Aug 2017 17:51:37 +0300
Message-Id: <1504104706-11965-6-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 ltp/fsx.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 1502905..e789aad 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -211,9 +211,9 @@ prt(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buffer, BUF_SIZE, fmt, args);
 	va_end(args);
-	fprintf(stdout, buffer);
+	fputs(buffer, stdout);
 	if (fsxlogf)
-		fprintf(fsxlogf, buffer);
+		fputs(buffer, fsxlogf);
 }
 
 void
@@ -569,14 +569,20 @@ check_trunc_hack(void)
 {
 	struct stat statbuf;
 
-	ftruncate(fd, (off_t)0);
-	ftruncate(fd, (off_t)100000);
+	if (ftruncate(fd, (off_t)0))
+		goto ftruncate_err;
+	if (ftruncate(fd, (off_t)100000))
+		goto ftruncate_err;
 	fstat(fd, &statbuf);
 	if (statbuf.st_size != (off_t)100000) {
 		prt("no extend on truncate! not posix!\n");
 		exit(130);
 	}
-	ftruncate(fd, 0);
+	if (ftruncate(fd, 0)) {
+ftruncate_err:
+		prterr("check_trunc_hack: ftruncate");
+		exit(131);
+	}
 }
 
 void
@@ -1742,7 +1748,10 @@ __test_fallocate(int mode, const char *mode_str)
 					mode_str);
 		} else {
 			ret = 1;
-			ftruncate(fd, 0);
+			if (ftruncate(fd, 0)) {
+				warn("main: ftruncate");
+				exit(132);
+			}
 		}
 	}
 	return ret;
-- 
2.7.4

