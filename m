Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36374 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754981AbeBAUhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 15:37:51 -0500
Received: by mail-qk0-f195.google.com with SMTP id d21so21169800qkj.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 Feb 2018 12:37:51 -0800 (PST)
Received: from testarossa.localdomain ([191.177.187.140])
        by smtp.googlemail.com with ESMTPSA id n20sm303020qka.47.2018.02.01.12.37.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Feb 2018 12:37:49 -0800 (PST)
From: Marco A Benatto <marco.antonio.780@gmail.com>
Subject: [PATCH] xfs_mdrestore: Don't restore over a dump file
Date: Thu,  1 Feb 2018 18:37:43 -0200
Message-Id: <1517517463-99951-1-git-send-email-marco.antonio.780@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Currently, if the user switch source and target parameters
position, xfs_mdrestore truncates the dumpfile before abort
the execution.

This patch checks the target parameter and if XFS_MD_MAGIC is
found, it aborts execution and leave dump file intact.

Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>
---
 mdrestore/xfs_mdrestore.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c49c13a..b4bf7b4 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -205,7 +205,7 @@ main(
 	int 		argc,
 	char 		**argv)
 {
-	FILE		*src_f;
+	FILE		*src_f, *dst_f;
 	int		dst_fd;
 	int		c;
 	int		open_flags;
@@ -277,6 +277,7 @@ main(
 
 	optind++;
 
+
 	/* check and open target */
 	open_flags = O_RDWR;
 	is_target_file = 0;
@@ -285,6 +286,19 @@ main(
 		open_flags |= O_CREAT;
 		is_target_file = 1;
 	} else if (S_ISREG(statbuf.st_mode))  {
+		xfs_metablock_t mb;
+
+		dst_f = fopen(argv[optind], "rb");
+		if (dst_f == NULL)
+			fatal("cannot open target\n");
+
+		if (fread(&mb, sizeof(mb), 1, dst_f) == 1) {
+			if (be32_to_cpu(mb.mb_magic) == XFS_MD_MAGIC)
+				fatal("target file is a xfs_metadump. switched arguments?\n");
+		}
+
+		fclose(dst_f);
+
 		open_flags |= O_TRUNC;
 		is_target_file = 1;
 	} else  {
-- 
1.8.3.1

