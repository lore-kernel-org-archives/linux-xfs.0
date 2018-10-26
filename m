Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f51.google.com ([209.85.128.51]:53355 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbeJ0E6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 00:58:40 -0400
Received: by mail-wm1-f51.google.com with SMTP id l26-v6so2620702wmh.3
        for <linux-xfs@vger.kernel.org>; Fri, 26 Oct 2018 13:20:14 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id 193-v6sm7669219wmj.21.2018.10.26.13.20.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Oct 2018 13:20:12 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 4/5] xfs_metadump: Zap unused space in inode btrees
Date: Fri, 26 Oct 2018 22:19:42 +0200
Message-Id: <20181026201943.24131-5-stefanrin@gmail.com>
In-Reply-To: <20181026201943.24131-1-stefanrin@gmail.com>
References: <20181026201943.24131-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

---
 db/metadump.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index a4867783..39183fb7 100644
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
+		memset(top, 'a', (char*)pp - top);
+
+		/* Unused btree ptr space */
+		top = (char*)&pp[nrecs];
+		memset(top, 'b', (char*)dib + XFS_DFORK_SIZE(dip, mp, whichfork) - top);
+	}
+
 	for (i = 0; i < nrecs; i++) {
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
-- 
2.14.5
