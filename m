Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387742AbfBMJxl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:41 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 5/9] Add b_alt_retry to xfs_buf
Date: Wed, 13 Feb 2019 17:50:40 +0800
Message-Id: <20190213095044.29628-6-bob.liu@oracle.com>
In-Reply-To: <20190213095044.29628-1-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds b_alt_retry boolean to xfs_buf. We will use
this to enable alternate device retry when the bio completes
for single buffer bios.

At this time, we do not yet support alternate device retry for
multi buffer bio

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c | 8 ++++++++
 fs/xfs/xfs_buf.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4f5f2ff3f70f..e2683c8e868c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1409,6 +1409,14 @@ xfs_buf_ioapply_map(
 			flush_kernel_vmap_range(bp->b_addr,
 						xfs_buf_vmap_len(bp));
 		}
+
+		/*
+		 * At the moment, we only support alternate
+		 * device retry on single bio buffers
+		 */
+		if (size == 0)
+			bp->b_alt_retry = true;
+
 		submit_bio(bio);
 		if (size)
 			goto next_chunk;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9f5511ea998..989b97a17486 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -198,6 +198,7 @@ typedef struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
+	bool			b_alt_retry;	/* toggle alt device retry */
 } xfs_buf_t;
 
 /* Finding and Reading Buffers */
-- 
2.17.1
