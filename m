Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751270AbdHXLr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 07:47:58 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/6] fiemap: Eliminate num_extents
Date: Thu, 24 Aug 2017 14:47:49 +0300
Message-Id: <1503575272-28263-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1503575272-28263-1-git-send-email-nborisov@suse.com>
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Nikolay Borisov <nborisov@suse.com>

Fiemap has this rather convoluted logic to calculate the number of extents to
query. This introduces needless complexity with no real benefit. Remove
num_extents and instead hardcode the number of extents we query for in a single
go to 32. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index d284248e4fe1..a31db790c86d 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -23,6 +23,8 @@
 #include "init.h"
 #include "io.h"
 
+#define EXTENT_BATCH 32
+
 static cmdinfo_t fiemap_cmd;
 static int max_extents = 0;
 
@@ -195,7 +197,6 @@ fiemap_f(
 	char		**argv)
 {
 	struct fiemap	*fiemap;
-	int		num_extents = 32;
 	int		last = 0;
 	int		lflag = 0;
 	int		vflag = 0;
@@ -231,10 +232,8 @@ fiemap_f(
 		}
 	}
 
-	if (max_extents)
-		num_extents = min(num_extents, max_extents);
 	map_size = sizeof(struct fiemap) +
-		(num_extents * sizeof(struct fiemap_extent));
+		(EXTENT_BATCH * sizeof(struct fiemap_extent));
 	fiemap = malloc(map_size);
 	if (!fiemap) {
 		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
@@ -246,15 +245,12 @@ fiemap_f(
 	printf("%s:\n", file->name);
 
 	while (!last && ((cur_extent + 1) != max_extents)) {
-		if (max_extents)
-			num_extents = min(num_extents,
-					  max_extents - (cur_extent + 1));
 
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
 		fiemap->fm_length = -1LL;
-		fiemap->fm_extent_count = num_extents;
+		fiemap->fm_extent_count = EXTENT_BATCH;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
 		if (ret < 0) {
-- 
2.7.4

