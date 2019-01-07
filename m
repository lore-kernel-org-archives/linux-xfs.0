Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35443 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfAGUO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 15:14:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id t200so2164742wmt.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jan 2019 12:14:56 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id j124sm3194818wmb.48.2019.01.07.12.14.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 12:14:54 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 4/5] xfs_metadump: Zap unused space in inode btrees
Date: Mon,  7 Jan 2019 21:13:54 +0100
Message-Id: <20190107201355.18996-5-stefanrin@gmail.com>
In-Reply-To: <20190107201355.18996-1-stefanrin@gmail.com>
References: <20190107201355.18996-1-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Stefan Ring <stefanrin@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index edc288ce..3994c4f4 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2176,6 +2176,19 @@ process_btinode(
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
2.19.2
