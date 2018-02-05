Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbeBEQuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 11:50:50 -0500
Date: Mon, 5 Feb 2018 08:50:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/4] xfs_io: fix copy_file_range symbol name collision
Message-ID: <20180205165041.GH4849@magnolia>
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151760738102.29371.13542858379823064383.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, fredrik@crux.nu

From: Darrick J. Wong <darrick.wong@oracle.com>

glibc 2.27 has a copy_file_range wrapper, so we need to change our
internal function out of the way to avoid compiler warnings.

Reported-by: fredrik@crux.nu
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/copy_file_range.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index d1dfc5a..99fba20 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -42,13 +42,18 @@ copy_range_help(void)
 "));
 }
 
+/*
+ * Issue a raw copy_file_range syscall; for our test program we don't want the
+ * glibc buffered copy fallback.
+ */
 static loff_t
-copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
+copy_file_range_cmd(int fd, loff_t *src, loff_t *dst, size_t len)
 {
 	loff_t ret;
 
 	do {
-		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst, len, 0);
+		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst,
+				len, 0);
 		if (ret == -1) {
 			perror("copy_range");
 			return errno;
@@ -130,7 +135,7 @@ copy_range_f(int argc, char **argv)
 		copy_dst_truncate();
 	}
 
-	ret = copy_file_range(fd, &src, &dst, len);
+	ret = copy_file_range_cmd(fd, &src, &dst, len);
 	close(fd);
 	return ret;
 }
