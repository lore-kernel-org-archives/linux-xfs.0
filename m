Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752992AbdKFOfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:20 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUi-00026S-0z
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:20 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] xfs: mark xlog_recover_check_summary STATIC
Date: Mon,  6 Nov 2017 15:34:55 +0100
Message-Id: <20171106143456.13567-8-hch@lst.de>
In-Reply-To: <20171106143456.13567-1-hch@lst.de>
References: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We already did it in the forward declaration, but not for the function
body itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6e0e38b5b7ad..87b1c331f9eb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5825,7 +5825,7 @@ xlog_recover_cancel(
  * Read all of the agf and agi counters and check that they
  * are consistent with the superblock counters.
  */
-void
+STATIC void
 xlog_recover_check_summary(
 	struct xlog	*log)
 {
-- 
2.14.2

