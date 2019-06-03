Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729963AbfFCRag (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:36 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqn5-0003jz-Ib
        for linux-xfs@vger.kernel.org; Mon, 03 Jun 2019 17:30:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/20] xfs: properly type the b_log_item field in struct xfs_buf
Date: Mon,  3 Jun 2019 19:29:44 +0200
Message-Id: <20190603172945.13819-20-hch@lst.de>
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that the log code doesn't abuse this field any more we can
declare it as a struct xfs_buf_log_item pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c1965c7e76bb..2abd2435d6aa 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -156,7 +156,7 @@ typedef struct xfs_buf {
 	struct work_struct	b_ioend_work;
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
-	void			*b_log_item;
+	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
-- 
2.20.1
