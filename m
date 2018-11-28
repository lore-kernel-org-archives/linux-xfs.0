Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50990 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbeK1Owo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:44 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 6/7] xfs: Rewrite retried read
Date: Tue, 27 Nov 2018 20:49:50 -0700
Message-Id: <1543376991-5764-7-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

If we had to try more than one mirror to get a successful
read, then write that buffer back to correct the bad mirro

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f102d01..81f6491 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -847,6 +847,14 @@ xfs_buf_read_map(
 
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
2.7.4
