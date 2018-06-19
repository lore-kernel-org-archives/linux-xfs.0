Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55838 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030250AbeFSQmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 12:42:00 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] iomap: add private pointer to struct iomap
Date: Tue, 19 Jun 2018 18:41:36 +0200
Message-Id: <20180619164137.13720-7-hch@lst.de>
In-Reply-To: <20180619164137.13720-1-hch@lst.de>
References: <20180619164137.13720-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

Add a private pointer to struct iomap to allow filesystems to pass data
from iomap_begin to iomap_end.  Will be used by gfs2 for passing on the
on-disk inode buffer head.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/iomap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 45f43865b0f0..1f36523d448a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -57,6 +57,7 @@ struct iomap {
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
+	void			*private; /* filesystem private */
 
 	/*
 	 * Called when finished processing a page in the mapping returned in
-- 
2.17.1

