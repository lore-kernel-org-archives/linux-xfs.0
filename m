Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933434AbeEWOoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 10:44:32 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/34] iomap: fix the comment describing IOMAP_NOWAIT
Date: Wed, 23 May 2018 16:43:33 +0200
Message-Id: <20180523144357.18985-11-hch@lst.de>
In-Reply-To: <20180523144357.18985-1-hch@lst.de>
References: <20180523144357.18985-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/iomap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8f7095fc514e..13d19b4c29a9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -59,7 +59,7 @@ struct iomap {
 #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
 #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
 #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
-#define IOMAP_NOWAIT		(1 << 5) /* Don't wait for writeback */
+#define IOMAP_NOWAIT		(1 << 5) /* do not block */
 
 struct iomap_ops {
 	/*
-- 
2.17.0

