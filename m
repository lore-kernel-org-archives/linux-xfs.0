Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAVy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:54:58 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/15] FOLD: iomap: make the discard_page method optional
Date: Mon,  1 Jul 2019 23:54:25 +0200
Message-Id: <20190701215439.19162-2-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

For file system that do not support delayed allocations there is
nothing to discard here, so don't require them to implement the
method.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 72ba3962acf3..ebfff663b2a9 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -2545,7 +2545,8 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	 */
 	if (unlikely(error)) {
 		if (!count) {
-			wpc->ops->discard_page(page);
+			if (wpc->ops->discard_page)
+				wpc->ops->discard_page(page);
 			ClearPageUptodate(page);
 			unlock_page(page);
 			goto done;
-- 
2.20.1
