Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58650 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387886AbfBMJx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:56 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 8/9] xfs: Rewrite retried read
Date: Wed, 13 Feb 2019 17:50:43 +0800
Message-Id: <20190213095044.29628-9-bob.liu@oracle.com>
In-Reply-To: <20190213095044.29628-1-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

From: Allison Henderson <allison.henderson@oracle.com>

If we had to try more than one mirror to get a successful
read, then write that buffer back to correct the bad mirror

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2c250221cb78..e54dbc776d15 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -861,6 +861,14 @@ xfs_buf_read_map(
 
 		}
 retry_done:
+
+		/*
+		 * if we had to try more than one mirror to sucessfully read
+		 * the buffer, write the buffer back
+		 */
+		if (!bp->b_error && i > 0)
+			xfs_bwrite(bp);
+
 		return bp;
 	}
 
-- 
2.17.1
