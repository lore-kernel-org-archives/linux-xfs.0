Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40909 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387865AbeKFGyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 01:54:22 -0500
Received: by mail-wr1-f53.google.com with SMTP id i17-v6so11164582wre.7
        for <linux-xfs@vger.kernel.org>; Mon, 05 Nov 2018 13:32:40 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id x18-v6sm38861711wrs.50.2018.11.05.13.32.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Nov 2018 13:32:39 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 4/5] xfs_metadump: Zap unused space in inode btrees
Date: Mon,  5 Nov 2018 22:31:44 +0100
Message-Id: <20181105213145.7560-5-stefanrin@gmail.com>
In-Reply-To: <20181105213145.7560-1-stefanrin@gmail.com>
References: <20181105213145.7560-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Stefan Ring <stefanrin@gmail.com>
---
 db/metadump.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index d4c751c0..59765263 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2173,6 +2173,19 @@ process_btinode(
 	}
 
 	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
+
+	if (zero_stale_data) {
+		char	*top;
+
+		/* Unused btree key space */
+		top = (char*)XFS_BMDR_KEY_ADDR(dib, nrecs + 1);
+		memset(top, 0, (char*)pp - top);
+
+		/* Unused btree ptr space */
+		top = (char*)&pp[nrecs];
+		memset(top, 0, (char*)dib + XFS_DFORK_SIZE(dip, mp, whichfork) - top);
+	}
+
 	for (i = 0; i < nrecs; i++) {
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
-- 
2.14.5
