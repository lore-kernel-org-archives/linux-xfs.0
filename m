Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36014 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbfETQOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:14:48 -0400
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkw2-0005Pt-Ic
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:14:46 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/17] xfs: remove the never used _XBF_COMPOUND flag
Date: Mon, 20 May 2019 18:13:32 +0200
Message-Id: <20190520161347.3044-3-hch@lst.de>
In-Reply-To: <20190520161347.3044-1-hch@lst.de>
References: <20190520161347.3044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1701efee4fd4..f67024c1deaa 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -43,7 +43,6 @@
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
-#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -63,8 +62,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
-	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_COMPOUND,	"COMPOUND" }
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
 
 /*
-- 
2.20.1
