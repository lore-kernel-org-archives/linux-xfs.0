Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFZNXt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jun 2019 09:23:49 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 3/3] iomap: fix page_done callback for short writes
Date: Wed, 26 Jun 2019 15:23:35 +0200
Message-Id: <20190626132335.14809-3-agruenba@redhat.com>
In-Reply-To: <20190626132335.14809-1-agruenba@redhat.com>
References: <20190626132335.14809-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

When we truncate a short write to have it retried, pass the truncated
length to the page_done callback instead of the full length.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 97569064faaa..9a9d016b2782 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -803,7 +803,7 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 	if (old_size < pos)
 		pagecache_isize_extended(inode, old_size, pos);
 	if (page_ops && page_ops->page_done)
-		page_ops->page_done(inode, pos, copied, page, iomap);
+		page_ops->page_done(inode, pos, ret, page, iomap);
 	put_page(page);
 
 	if (ret < len)
-- 
2.20.1
