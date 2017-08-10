Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752243AbdHJLHu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Aug 2017 07:07:50 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] fiemap: Allow to specify range to fiemap
Date: Thu, 10 Aug 2017 14:07:44 +0300
Message-Id: <1502363264-32659-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com, Nikolay Borisov <nborisov@suse.com>

Add 2 additional, optional, arguments to the embedded fiemap command,
that way one can specify exact ranges to be fiemapped. This will be used
for a btrfs test. Since the arguments are optional, omitting them just
retains the old behavior. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 75e8820..a3c0c89 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -216,7 +216,11 @@ fiemap_f(
 	int		flg_w = 5;
 	__u64		blocksize = 512;
 	__u64		last_logical = 0;
+	__u64		len = -1LL;
 	struct stat	st;
+	size_t 		fsblocksize, fssectsize;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
 
 	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
 		switch (c) {
@@ -237,6 +241,32 @@ fiemap_f(
 		}
 	}
 
+	if (argc == optind + 2) {
+		off64_t start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (start_offset < 0) {
+			printf("non-numeric offset argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		last_logical = start_offset;
+		last_logical = strtoull(argv[optind], NULL, 10);
+
+		optind++;
+
+		off64_t length = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (length < 0) {
+			printf("non-numeric len argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		len = length;
+	} else if (argc == optind + 1) {
+		off64_t start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (last_logical < 0) {
+			printf("non-numeric offset argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		last_logical = start_offset;
+	}
+
 	if (max_extents)
 		num_extents = min(num_extents, max_extents);
 	map_size = sizeof(struct fiemap) +
@@ -259,7 +289,7 @@ fiemap_f(
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1LL;
+		fiemap->fm_length = len;
 		fiemap->fm_extent_count = num_extents;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -350,7 +380,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [start offset] [len]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
-- 
2.7.4

