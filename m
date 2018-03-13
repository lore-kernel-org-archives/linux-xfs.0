Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37948 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932885AbeCMKtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 06:49:41 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evhUy-0006Fy-Os
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 10:49:41 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] xfs: remove the unused log_flushed variable in xfs_extent_busy_flush
Date: Tue, 13 Mar 2018 11:49:22 +0100
Message-Id: <20180313104927.12926-4-hch@lst.de>
In-Reply-To: <20180313104927.12926-1-hch@lst.de>
References: <20180313104927.12926-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 77760dbf0242..1b439db95634 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -611,10 +611,10 @@ xfs_extent_busy_flush(
 	unsigned		busy_gen)
 {
 	DEFINE_WAIT		(wait);
-	int			log_flushed = 0, error;
+	int			error;
 
 	trace_xfs_log_force(mp, 0, _THIS_IP_);
-	error = _xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
+	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
 	if (error)
 		return;
 
-- 
2.14.2

