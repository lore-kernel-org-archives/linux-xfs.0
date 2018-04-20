Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:9425 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752881AbeDTWJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Apr 2018 18:09:18 -0400
From: Aleksei Besogonov <cyberax@amazon.com>
Subject: [PATCH 1/2] fs: Add iomap_swap_activate
Date: Fri, 20 Apr 2018 22:08:14 +0000
Message-ID: <20180420220815.44160-2-cyberax@amazon.com>
In-Reply-To: <20180420220815.44160-1-cyberax@amazon.com>
References: <20180420220815.44160-1-cyberax@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Aleksei Besogonov <cyberax@amazon.com>

This commit adds an alternative to generic_swapfile_activate function
based on iomap family. The major driver for this is swap file support
on XFS, currently it doesn't work on files with holes due to deficiencies
in the old bmap() interface that is used by generic_swapfile_activate.
---
 fs/iomap.c            | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  5 +++
 mm/swapfile.c         |  1 +
 3 files changed, 93 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index afd163586aa0..9f0980637dbc 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1089,3 +1089,90 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
+
+struct iomap_swap_walker_context
+{
+    struct swap_info_struct *sis;
+    unsigned int page_no;
+    unsigned int nr_extents;
+    sector_t *span;
+};
+
+static loff_t
+iomap_swap_map(struct inode *inode, loff_t pos, loff_t length,
+		void *data, struct iomap *iomap)
+{
+	struct iomap_swap_walker_context *ctx = data;
+	unsigned int blocks_per_page = PAGE_SIZE >> inode->i_blkbits;
+	u64 num_pages;
+	u64 aligned_address;
+	sector_t disk_pos;
+	loff_t eff_length;
+	loff_t ret;
+
+	/*
+	 * Swap extents need to be PAGE_SIZE aligned on the disk
+	 */
+	aligned_address = ALIGN(iomap->addr, PAGE_SIZE);
+	eff_length = length - (aligned_address - iomap->addr);
+	BUG_ON(eff_length > length);
+	disk_pos = aligned_address >> inode->i_blkbits;
+
+	if (eff_length < 0)
+		return length; /* Continue probing */
+
+	num_pages = eff_length / PAGE_SIZE;
+
+	/* Can't add blocks less than 1 page */
+	if (num_pages == 0)
+		return length; /* Continue probing */
+
+	ret = add_swap_extent(ctx->sis, ctx->page_no, num_pages, disk_pos);
+	if (ret < 0)
+		return ret;
+
+	ctx->nr_extents += ret;
+	ctx->page_no += num_pages;
+	*(ctx->span) += num_pages * blocks_per_page;
+
+	return length; /* continue probing */
+}
+
+int
+iomap_swap_activate(struct swap_info_struct *sis, struct file *file,
+		sector_t *span, const struct iomap_ops *ops)
+{
+	struct iomap_swap_walker_context ctx = {
+		.sis = sis,
+		.page_no = 0,
+		.nr_extents = 0,
+		.span = span
+	};
+
+	struct inode * inode = file_inode(file);
+	loff_t len = i_size_read(inode);
+	loff_t pos = 0;
+	loff_t ret = -EINVAL;
+
+	while(len > 0) {
+		ret = iomap_apply(inode, pos, len, IOMAP_REPORT, ops,
+				  &ctx, iomap_swap_map);
+		if (ret <= 0)
+			break;
+
+		pos += ret;
+		len -= ret;
+	}
+
+	if (ret < 0) {
+		pr_err("Failed to activate the swap file\n");
+		return -EINVAL;
+	}
+
+	sis->max = ctx.page_no == 0 ? 1 : ctx.page_no;
+	sis->pages = ctx.page_no;
+	sis->highest_bit = ctx.page_no;
+
+	return ctx.nr_extents;
+}
+EXPORT_SYMBOL_GPL(iomap_swap_activate);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 19a07de28212..a85da0db6c2e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -10,6 +10,8 @@ struct iov_iter;
 struct kiocb;
 struct vm_area_struct;
 struct vm_fault;
+struct file;
+struct swap_info_struct;
 
 /*
  * Types of block ranges for iomap mappings:
@@ -106,4 +108,7 @@ typedef int (iomap_dio_end_io_t)(struct kiocb *iocb, ssize_t ret,
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, iomap_dio_end_io_t end_io);
 
+int iomap_swap_activate(struct swap_info_struct *sis, struct file *file,
+			sector_t *span, const struct iomap_ops *ops);
+
 #endif /* LINUX_IOMAP_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c7a33717d079..9e6d3c1a882e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2381,6 +2381,7 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 	list_add_tail(&new_se->list, &sis->first_swap_extent.list);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(add_swap_extent);
 
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
-- 
2.14.1

