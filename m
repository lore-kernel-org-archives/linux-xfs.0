Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38933 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbeJ0E6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 00:58:36 -0400
Received: by mail-wr1-f43.google.com with SMTP id r10-v6so2539631wrv.6
        for <linux-xfs@vger.kernel.org>; Fri, 26 Oct 2018 13:20:11 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id 193-v6sm7669219wmj.21.2018.10.26.13.20.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Oct 2018 13:20:09 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
Date: Fri, 26 Oct 2018 22:19:40 +0200
Message-Id: <20181026201943.24131-3-stefanrin@gmail.com>
In-Reply-To: <20181026201943.24131-1-stefanrin@gmail.com>
References: <20181026201943.24131-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Using the same code as in process_single_fsb_objects.
---
 db/metadump.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 97d2a490..c1bfc818 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1881,6 +1881,7 @@ process_multi_fsb_objects(
 	typnm_t		btype,
 	xfs_fileoff_t	last)
 {
+	char		*dp;
 	int		ret = 0;
 
 	switch (btype) {
@@ -1921,14 +1922,17 @@ process_multi_fsb_objects(
 
 			}
 
-			if ((!obfuscate && !zero_stale_data) ||
-			     o >= mp->m_dir_geo->leafblk) {
-				ret = write_buf(iocur_top);
-				goto out_pop;
+			dp = iocur_top->data;
+			if (o >= mp->m_dir_geo->freeblk) {
+				/* TODO, zap any stale data */
+				break;
+			} else if (o >= mp->m_dir_geo->leafblk) {
+				process_dir_leaf_block(dp);
+			} else {
+				process_dir_data_block(dp, o,
+					 last == mp->m_dir_geo->fsbcount);
 			}
 
-			process_dir_data_block(iocur_top->data, o,
-					       last == mp->m_dir_geo->fsbcount);
 			iocur_top->need_crc = 1;
 			ret = write_buf(iocur_top);
 out_pop:
-- 
2.14.5
