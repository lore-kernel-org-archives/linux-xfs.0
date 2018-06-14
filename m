Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936080AbeFNMFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 08:05:18 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] iomap: add a page_done callback
Date: Thu, 14 Jun 2018 14:04:57 +0200
Message-Id: <20180614120457.28285-7-hch@lst.de>
In-Reply-To: <20180614120457.28285-1-hch@lst.de>
References: <20180614120457.28285-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

This will be used by gfs2 to attach data to transactions for the journaled
data mode.  But the concept is generic enough that we might be able to
use it for other purposes like encryption/integrity post-processing in the
future.

Based on a patch from Andreas Gruenbacher.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 3 +++
 include/linux/iomap.h | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 6d5a2ebe5dd8..9e265118e8b0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -201,6 +201,9 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 				copied, page, NULL);
 	}
 
+	if (iomap->page_done)
+		iomap->page_done(inode, pos, copied, page, iomap);
+
 	if (ret < len)
 		iomap_write_failed(inode, pos, len);
 	return ret;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 69ef622f650e..43cc9208599f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -9,6 +9,7 @@ struct fiemap_extent_info;
 struct inode;
 struct iov_iter;
 struct kiocb;
+struct page;
 struct vm_area_struct;
 struct vm_fault;
 
@@ -58,6 +59,14 @@ struct iomap {
 		struct dax_device   *dax_dev;
 		void		    *inline_data;
 	};
+
+	/*
+	 * Called when finished processing a page in the mapping returned in
+	 * this iomap.  At least for now this is only supported in the buffered
+	 * write path.
+	 */
+	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
+			struct page *page, struct iomap *iomap);
 };
 
 /*
-- 
2.17.1

