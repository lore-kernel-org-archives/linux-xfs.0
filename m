Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53597 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfAGUOy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 15:14:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id d15so2046017wmb.3
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jan 2019 12:14:53 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id j124sm3194818wmb.48.2019.01.07.12.14.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 12:14:51 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
Date: Mon,  7 Jan 2019 21:13:52 +0100
Message-Id: <20190107201355.18996-3-stefanrin@gmail.com>
In-Reply-To: <20190107201355.18996-1-stefanrin@gmail.com>
References: <20190107201355.18996-1-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Using basically the same code as in process_single_fsb_objects.

Signed-off-by: Stefan Ring <stefanrin@gmail.com>
---
 db/metadump.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 97d2a490..45705685 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1881,6 +1881,7 @@ process_multi_fsb_objects(
 	typnm_t		btype,
 	xfs_fileoff_t	last)
 {
+	char		*dp;
 	int		ret = 0;
 
 	switch (btype) {
@@ -1921,15 +1922,21 @@ process_multi_fsb_objects(
 
 			}
 
-			if ((!obfuscate && !zero_stale_data) ||
-			     o >= mp->m_dir_geo->leafblk) {
-				ret = write_buf(iocur_top);
-				goto out_pop;
-			}
+			if (!obfuscate && !zero_stale_data)
+				goto write;
 
-			process_dir_data_block(iocur_top->data, o,
-					       last == mp->m_dir_geo->fsbcount);
+			dp = iocur_top->data;
+			if (o >= mp->m_dir_geo->freeblk) {
+				/* TODO, zap any stale data */
+				goto write;
+			} else if (o >= mp->m_dir_geo->leafblk) {
+				process_dir_leaf_block(dp);
+			} else {
+				process_dir_data_block(dp, o,
+					 last == mp->m_dir_geo->fsbcount);
+			}
 			iocur_top->need_crc = 1;
+write:
 			ret = write_buf(iocur_top);
 out_pop:
 			pop_cur();
-- 
2.19.2
