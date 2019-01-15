Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732930AbfAOVKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 16:10:33 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] iomap: get/put the page in iomap_page_create/release()
Date: Tue, 15 Jan 2019 22:10:28 +0100
Message-Id: <20190115211028.15742-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>

migrate_page_move_mapping() expects pages with private data set to have
a page_count elevated by 1.  This is what used to happen for xfs through
the buffer_heads code before the switch to iomap in commit 82cb14175e7d
("xfs: add support for sub-pagesize writeback without buffer_heads").
Not having the count elevated causes move_pages() to fail on memory
mapped files coming from xfs.

Make iomap compatible with the migrate_page_move_mapping() assumption by
elevating the page count as part of iomap_page_create() and lowering it
in iomap_page_release().

It causes the move_pages() syscall to misbehave on memory mapped files
from xfs.  It does not not move any pages, which I suppose is "just" a
perf issue, but it also ends up returning a positive number which is out
of spec for the syscall.  Talking to Michal Hocko, it sounds like
returning positive numbers might be a necessary update to move_pages()
anyway though.

Based on an earlier patch and changelog from Piotr Jaroszynski, except
that this version actually puts/gets the page aswell when migrating
pages using a copy, and thus actually survives xfstests.

Fixes: 82cb14175e7d ("xfs: add support for sub-pagesize writeback without buffer_heads")
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>
---
 fs/iomap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index a3088fae567b..cb184ff68680 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -116,6 +116,12 @@ iomap_page_create(struct inode *inode, struct page *page)
 	atomic_set(&iop->read_count, 0);
 	atomic_set(&iop->write_count, 0);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
+
+	/*
+	 * migrate_page_move_mapping() assumes that pages with private data have
+	 * their count elevated by 1.
+	 */
+	get_page(page);
 	set_page_private(page, (unsigned long)iop);
 	SetPagePrivate(page);
 	return iop;
@@ -132,6 +138,7 @@ iomap_page_release(struct page *page)
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
+	put_page(page);
 	kfree(iop);
 }
 
@@ -569,8 +576,10 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
 
 	if (page_has_private(page)) {
 		ClearPagePrivate(page);
+		get_page(newpage);
 		set_page_private(newpage, page_private(page));
 		set_page_private(page, 0);
+		put_page(page);
 		SetPagePrivate(newpage);
 	}
 
-- 
2.20.1
