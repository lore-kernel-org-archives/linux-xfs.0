Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161893AbdDUQnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 12:43:24 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d1aNN-0005V7-Fz
        for linux-xfs@vger.kernel.org; Fri, 21 Apr 2017 15:21:37 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] xfs: corruption needs to respect endianess too!
Date: Fri, 21 Apr 2017 17:21:20 +0200
Message-Id: <20170421152123.11316-4-hch@lst.de>
In-Reply-To: <20170421152123.11316-1-hch@lst.de>
References: <20170421152123.11316-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

At least if we want to be able to recognize the pattern.  Add a missing
byte swap to the corruption injection case in xlog_sync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bb58cd1873c9..3731f13f63e9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1852,7 +1852,7 @@ xlog_sync(
 	 */
 	if (log->l_badcrc_factor &&
 	    (prandom_u32() % log->l_badcrc_factor == 0)) {
-		iclog->ic_header.h_crc &= 0xAAAAAAAA;
+		iclog->ic_header.h_crc &= cpu_to_le32(0xAAAAAAAA);
 		iclog->ic_state |= XLOG_STATE_IOABORT;
 		xfs_warn(log->l_mp,
 	"Intentionally corrupted log record at LSN 0x%llx. Shutdown imminent.",
-- 
2.11.0

