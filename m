Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfEWRiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:38:17 -0400
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrfT-0000UV-SE
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:38:16 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/20] xfs: renumber XBF_WRITE_FAIL
Date: Thu, 23 May 2019 19:37:25 +0200
Message-Id: <20190523173742.15551-4-hch@lst.de>
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Assining a numerical value that is not close to the flags
defined near by is just asking for conflicts later on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4f2c2bc43003..15f6ce3974ac 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -34,7 +34,7 @@ typedef enum {
 #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
-#define XBF_WRITE_FAIL	 (1 << 24)/* async writes have failed on this buffer */
+#define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
 
 /* I/O hints for the BIO layer */
 #define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
-- 
2.20.1
