Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f54.google.com ([209.85.221.54]:33551 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbeJLCvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 22:51:53 -0400
Received: by mail-wr1-f54.google.com with SMTP id e4-v6so10939068wrs.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 12:23:17 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 1/2] xfs_metadump: Extend zapping to multi fsb dir blocks
Date: Thu, 11 Oct 2018 21:23:06 +0200
Message-Id: <20181011192307.18553-2-stefanrin@gmail.com>
In-Reply-To: <20181011192307.18553-1-stefanrin@gmail.com>
References: <20181011192307.18553-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Stefan Ring <str@visotech.com>

From: Stefan Ring <str@visotech.com>

The processing for data zeroing was never added to process_multi_fsb_objects.
It is now the same thing that process_single_fsb_objects does.
---
 db/metadump.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index cc2ae9af..ff96860d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1862,6 +1862,7 @@ process_multi_fsb_objects(
 	typnm_t		btype,
 	xfs_fileoff_t	last)
 {
+	char		*dp;
 	int		ret = 0;
 
 	switch (btype) {
@@ -1902,14 +1903,16 @@ process_multi_fsb_objects(
 
 			}
 
-			if ((!obfuscate && !zero_stale_data) ||
-			     o >= mp->m_dir_geo->leafblk) {
-				ret = write_buf(iocur_top);
-				goto out_pop;
+			dp = iocur_top->data;
+			if (o >= mp->m_dir_geo->freeblk) {
+				process_dir_free_block(dp);
+			} else if (o >= mp->m_dir_geo->leafblk) {
+				process_dir_leaf_block(dp);
+			} else {
+				process_dir_data_block(
+					dp, o, last == mp->m_dir_geo->fsbcount);
 			}
 
-			process_dir_data_block(iocur_top->data, o,
-					       last == mp->m_dir_geo->fsbcount);
 			iocur_top->need_crc = 1;
 			ret = write_buf(iocur_top);
 out_pop:
-- 
2.14.4
