Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35187 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbeEKAWe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 20:22:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 643EEAE35
        for <linux-xfs@vger.kernel.org>; Fri, 11 May 2018 00:22:33 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] xfs_io: Make copy_range arguments understand *iB values
Date: Thu, 10 May 2018 19:22:23 -0500
Message-Id: <20180511002223.14386-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>

Arguments such as 2MiB or 2M are converted to 2 because copy_range uses
strtoull(). Convert strtoull() to cvtnum().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 99fba20a..0cf658e1 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -47,7 +47,7 @@ copy_range_help(void)
  * glibc buffered copy fallback.
  */
 static loff_t
-copy_file_range_cmd(int fd, loff_t *src, loff_t *dst, size_t len)
+copy_file_range_cmd(int fd, long long *src, long long *dst, long long len)
 {
 	loff_t ret;
 
@@ -89,34 +89,36 @@ copy_dst_truncate(void)
 static int
 copy_range_f(int argc, char **argv)
 {
-	loff_t src = 0;
-	loff_t dst = 0;
+	long long src = 0;
+	long long dst = 0;
 	size_t len = 0;
-	char *sp;
 	int opt;
 	int ret;
 	int fd;
+	size_t fsblocksize, fssectsize;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
 
 	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
 		switch (opt) {
 		case 's':
-			src = strtoull(optarg, &sp, 10);
-			if (!sp || sp == optarg) {
-				printf(_("invalid source offset -- %s\n"), sp);
+			src = cvtnum(fsblocksize, fssectsize, optarg);
+			if (src < 0) {
+				printf(_("invalid source offset -- %s\n"), optarg);
 				return 0;
 			}
 			break;
 		case 'd':
-			dst = strtoull(optarg, &sp, 10);
-			if (!sp || sp == optarg) {
-				printf(_("invalid destination offset -- %s\n"), sp);
+			dst = cvtnum(fsblocksize, fssectsize, optarg);
+			if (dst < 0) {
+				printf(_("invalid destination offset -- %s\n"), optarg);
 				return 0;
 			}
 			break;
 		case 'l':
-			len = strtoull(optarg, &sp, 10);
-			if (!sp || sp == optarg) {
-				printf(_("invalid length -- %s\n"), sp);
+			len = cvtnum(fsblocksize, fssectsize, optarg);
+			if (len < 0) {
+				printf(_("invalid length -- %s\n"), optarg);
 				return 0;
 			}
 			break;
