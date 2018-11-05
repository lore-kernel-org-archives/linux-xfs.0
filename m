Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53780 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387580AbeKFGyT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 01:54:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id v24-v6so9857021wmh.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Nov 2018 13:32:37 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id x18-v6sm38861711wrs.50.2018.11.05.13.32.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Nov 2018 13:32:35 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
Date: Mon,  5 Nov 2018 22:31:42 +0100
Message-Id: <20181105213145.7560-3-stefanrin@gmail.com>
In-Reply-To: <20181105213145.7560-1-stefanrin@gmail.com>
References: <20181105213145.7560-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Using basically the same code as in process_single_fsb_objects.

Signed-off-by: Stefan Ring <stefanrin@gmail.com>
---
 db/metadump.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 97d2a490..be7cf360 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1881,6 +1881,7 @@ process_multi_fsb_objects(
 	typnm_t		btype,
 	xfs_fileoff_t	last)
 {
+	char		*dp;
 	int		ret = 0;
 
 	switch (btype) {
@@ -1921,15 +1922,19 @@ process_multi_fsb_objects(
 
 			}
 
-			if ((!obfuscate && !zero_stale_data) ||
-			     o >= mp->m_dir_geo->leafblk) {
-				ret = write_buf(iocur_top);
-				goto out_pop;
+			dp = iocur_top->data;
+			if (o >= mp->m_dir_geo->freeblk) {
+				/* TODO, zap any stale data */
+				goto write;
+			} else if (o >= mp->m_dir_geo->leafblk) {
+				process_dir_leaf_block(dp);
+			} else {
+				process_dir_data_block(dp, o,
+					 last == mp->m_dir_geo->fsbcount);
 			}
 
-			process_dir_data_block(iocur_top->data, o,
-					       last == mp->m_dir_geo->fsbcount);
-			iocur_top->need_crc = 1;
+			iocur_top->need_crc = obfuscate || zero_stale_data;
+write:
 			ret = write_buf(iocur_top);
 out_pop:
 			pop_cur();
-- 
2.14.5
