Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfFCR3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:29:54 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/20] xfs: remove the never used _XBF_COMPOUND flag
Date: Mon,  3 Jun 2019 19:29:27 +0200
Message-Id: <20190603172945.13819-3-hch@lst.de>
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d0b96e071cec..4f2c2bc43003 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -49,7 +49,6 @@ typedef enum {
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
-#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -69,8 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
-	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_COMPOUND,	"COMPOUND" }
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
 
 /*
-- 
2.20.1
