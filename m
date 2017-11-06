Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41810 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753078AbdKFOfX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:23 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUk-00026y-S6
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] xfs: mark xlog_verify_dest_ptr STATIC
Date: Mon,  6 Nov 2017 15:34:56 +0100
Message-Id: <20171106143456.13567-9-hch@lst.de>
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
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3ce44e6d6639..38d4227895ae 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3763,7 +3763,7 @@ xlog_ticket_alloc(
  * one of the iclogs.  This uses backup pointers stored in a different
  * part of the log in case we trash the log structure.
  */
-void
+STATIC void
 xlog_verify_dest_ptr(
 	struct xlog	*log,
 	void		*ptr)
-- 
2.14.2

