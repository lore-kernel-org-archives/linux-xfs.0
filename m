Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752214AbeGBOzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:55:01 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] iomap: add inline data support to iomap_readpage_actor
Date: Mon,  2 Jul 2018 08:54:58 -0600
Message-Id: <20180702145458.22330-4-hch@lst.de>
In-Reply-To: <20180702145458.22330-1-hch@lst.de>
References: <20180702145458.22330-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

Just copy the inline data into the page using the existing helper.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 98a1fdd5c091..13cdcf33e6c0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -155,6 +155,12 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	bool is_contig = false;
 	sector_t sector;
 
+	if (iomap->type == IOMAP_INLINE) {
+		WARN_ON_ONCE(poff);
+		iomap_read_inline_data(inode, page, iomap);
+		return PAGE_SIZE;
+	}
+
 	/* we don't support blocksize < PAGE_SIZE quite yet. */
 	WARN_ON_ONCE(pos != page_offset(page));
 	WARN_ON_ONCE(plen != PAGE_SIZE);
-- 
2.18.0

