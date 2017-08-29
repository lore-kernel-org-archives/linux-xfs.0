Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754534AbdH2Oh7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:37:59 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A40D051D
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:37:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86E882E07F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:37:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/9] xfs: ordered buffer log items are never formatted
Date: Tue, 29 Aug 2017 10:37:52 -0400
Message-Id: <20170829143758.58990-4-bfoster@redhat.com>
In-Reply-To: <20170829143758.58990-1-bfoster@redhat.com>
References: <20170829143758.58990-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Ordered buffers pass through the logging infrastructure without ever
being written to the log. The way this works is that the ordered
buffer status is transferred to the log vector at commit time via
the ->iop_size() callback. In xlog_cil_insert_format_items(),
ordered log vectors bypass ->iop_format() processing altogether.

Therefore it is unnecessary for xfs_buf_item_format() to handle
ordered buffers. Remove the unnecessary logic and assert that an
ordered buffer never reaches this point.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c | 12 ++----------
 fs/xfs/xfs_trace.h    |  1 -
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ff076d1..ef2c137 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -323,6 +323,8 @@ xfs_buf_item_format(
 	ASSERT((bip->bli_flags & XFS_BLI_STALE) ||
 	       (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF
 	        && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF));
+	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED) ||
+	       (bip->bli_flags & XFS_BLI_STALE));
 
 
 	/*
@@ -347,16 +349,6 @@ xfs_buf_item_format(
 		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 	}
 
-	if ((bip->bli_flags & (XFS_BLI_ORDERED|XFS_BLI_STALE)) ==
-							XFS_BLI_ORDERED) {
-		/*
-		 * The buffer has been logged just to order it.  It is not being
-		 * included in the transaction commit, so don't format it.
-		 */
-		trace_xfs_buf_item_format_ordered(bip);
-		return;
-	}
-
 	for (i = 0; i < bip->bli_format_count; i++) {
 		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
 					    &bip->bli_formats[i]);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6881047..e839ab4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -517,7 +517,6 @@ DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_ordered);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_ordered);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_ordered);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
-- 
2.9.5

