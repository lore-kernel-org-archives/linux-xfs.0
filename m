Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030250AbeFSQl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 12:41:57 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] iomap: add a page_done callback
Date: Tue, 19 Jun 2018 18:41:35 +0200
Message-Id: <20180619164137.13720-6-hch@lst.de>
In-Reply-To: <20180619164137.13720-1-hch@lst.de>
References: <20180619164137.13720-1-hch@lst.de>
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
index 4aecd7c5dbd8..a1f71e64ea49 100644
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
index 10d6cff7f69a..45f43865b0f0 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -9,6 +9,7 @@ struct fiemap_extent_info;
 struct inode;
 struct iov_iter;
 struct kiocb;
+struct page;
 struct vm_area_struct;
 struct vm_fault;
 
@@ -56,6 +57,14 @@ struct iomap {
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
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

