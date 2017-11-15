Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757342AbdKOMK0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Nov 2017 07:10:26 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 1/2] fiemap: Factor out actual fiemap call code
Date: Wed, 15 Nov 2017 14:10:20 +0200
Message-Id: <1510747821-13270-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, david@fromorbit.com, darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

This will be needed to in a subsequent patch to avoid code duplication

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index e6fd66da753d..08391f69d9bd 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -211,6 +211,31 @@ calc_print_format(
 	}
 }
 
+static int
+__fiemap(
+	 struct fiemap * fiemap,
+	 int		 mapsize,
+	 __u32		 flags,
+	 __u64		 start,
+	 __u64		 length) {
+
+	int ret;
+
+	memset(fiemap, 0, mapsize);
+	fiemap->fm_flags = flags;
+	fiemap->fm_start = start;
+	fiemap->fm_length = length;
+	fiemap->fm_extent_count = EXTENT_BATCH;
+	ret = ioctl(file->fd, FS_IOC_FIEMAP, fiemap);
+	if (ret < 0) {
+	        fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
+	                "%s\n", progname, file->name, strerror(errno));
+	        return ret;
+	}
+
+	return 0;
+}
+
 int
 fiemap_f(
 	int		argc,
@@ -266,19 +291,11 @@ fiemap_f(
 
 	while (!last && (cur_extent != max_extents)) {
 
-		memset(fiemap, 0, map_size);
-		fiemap->fm_flags = fiemap_flags;
-		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1LL;
-		fiemap->fm_extent_count = EXTENT_BATCH;
-
-		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+		ret = __fiemap(fiemap, map_size, fiemap_flags, last_logical,
+			       -1LL);
 		if (ret < 0) {
-			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
-				"%s\n", progname, file->name, strerror(errno));
-			free(fiemap);
 			exitcode = 1;
-			return 0;
+			goto out;
 		}
 
 		/* No more extents to map, exit */
-- 
2.7.4

