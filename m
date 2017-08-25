Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933341AbdHYPF7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 11:05:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 46A68C058EBF
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 15:05:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ADD380E8D
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 15:05:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/9] xfs: open-code xfs_buf_item_dirty()
Date: Fri, 25 Aug 2017 11:05:49 -0400
Message-Id: <20170825150557.43010-2-bfoster@redhat.com>
In-Reply-To: <20170825150557.43010-1-bfoster@redhat.com>
References: <20170825150557.43010-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

It checks a single flag and has one caller. It probably isn't worth
its own function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c  | 11 -----------
 fs/xfs/xfs_buf_item.h  |  1 -
 fs/xfs/xfs_trans_buf.c |  2 +-
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 573fc72..cdae0ad5e0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -945,17 +945,6 @@ xfs_buf_item_log(
 }
 
 
-/*
- * Return 1 if the buffer has been logged or ordered in a transaction (at any
- * point, not just the current transaction) and 0 if not.
- */
-uint
-xfs_buf_item_dirty(
-	xfs_buf_log_item_t	*bip)
-{
-	return (bip->bli_flags & XFS_BLI_DIRTY);
-}
-
 STATIC void
 xfs_buf_item_free(
 	xfs_buf_log_item_t	*bip)
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 530686e..e0e744a 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -64,7 +64,6 @@ typedef struct xfs_buf_log_item {
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
 void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
-uint	xfs_buf_item_dirty(xfs_buf_log_item_t *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, xfs_log_item_t *),
 			      xfs_log_item_t *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 86987d8..cac8abb 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -435,7 +435,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
 		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_buf_item_relse(bp);
-	} else if (!xfs_buf_item_dirty(bip)) {
+	} else if (!(bip->bli_flags & XFS_BLI_DIRTY)) {
 /***
 		ASSERT(bp->b_pincount == 0);
 ***/
-- 
2.9.5

