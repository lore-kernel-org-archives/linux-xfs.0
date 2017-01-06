Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18044 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753592AbdAFHIK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 02:08:10 -0500
Date: Thu, 5 Jan 2017 23:07:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] duperemove: test presence of dedupe ioctl
Message-ID: <20170106070732.GA14020@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mfasheh@versity.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

Since a zero-length dedupe operation is guaranteed to succeed, use that
to test whether or not this filesystem supports dedupe.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: declare variables on the stack instead of introducing fake types
---
 file_scan.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/file_scan.c b/file_scan.c
index 617f166..2708bfe 100644
--- a/file_scan.c
+++ b/file_scan.c
@@ -45,11 +45,7 @@
 #include "file_scan.h"
 #include "dbfile.h"
 #include "util.h"
-
-/* This is not in linux/magic.h */
-#ifndef	XFS_SB_MAGIC
-#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
-#endif
+#include "btrfs-ioctl.h"
 
 static char path[PATH_MAX] = { 0, };
 static char *pathp = path;
@@ -189,6 +185,37 @@ static int walk_dir(const char *name)
 	return ret;
 }
 
+/*
+ * A zero-length dedupe between two files should always succeed,
+ * so we can use this to test the presence of dedupe functionality.
+ */
+static bool check_ioctl_works(int fd)
+{
+	struct {
+		struct btrfs_ioctl_same_args args;
+		struct btrfs_ioctl_same_extent_info info;
+	} sa = {0};
+	struct stat sb;
+	static int cached = -1;
+	int ret;
+
+	if (cached >= 0)
+		return cached != 0;
+
+	ret = fstat(fd, &sb);
+	if (ret)
+		return false;
+
+	sa.args.dest_count = 1;
+	sa.args.length = 0;
+	sa.info.fd = fd;
+	sa.info.logical_offset = 0;
+	errno = 0;
+	ret = btrfs_extent_same(fd, &sa.args);
+	cached = !ret && !errno && !sa.info.status;
+	return cached;
+}
+
 static int __add_file(const char *name, struct stat *st,
 		      struct filerec **ret_file)
 {
@@ -235,12 +262,10 @@ static int __add_file(const char *name, struct stat *st,
 		goto out;
 	}
 
-	if (run_dedupe &&
-	    ((fs.f_type != BTRFS_SUPER_MAGIC &&
-	      fs.f_type != XFS_SB_MAGIC))) {
+	if (run_dedupe && !check_ioctl_works(fd)) {
 		close(fd);
-		fprintf(stderr,	"\"%s\": Can only dedupe files on btrfs or xfs "
-			"(experimental)\n", name);
+		fprintf(stderr,	"\"%s\": dedupe ioctl not supported on this "
+			"filesystem.\n", name);
 		return ENOSYS;
 	}
 
