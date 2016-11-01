Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754299AbcKATyd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Nov 2016 15:54:33 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v9 10/16] dax: add dax_iomap_sector() helper function
Date: Tue,  1 Nov 2016 13:54:12 -0600
Message-Id: <1478030058-1422-11-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

To be able to correctly calculate the sector from a file position and a
struct iomap there is a complex little bit of logic that currently happens
in both dax_iomap_actor() and dax_iomap_fault().  This will need to be
repeated yet again in the DAX PMD fault handler when it is added, so break
it out into a helper function.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index fdbd7a1..7737954 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1030,6 +1030,11 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 EXPORT_SYMBOL_GPL(dax_truncate_page);
 
 #ifdef CONFIG_FS_IOMAP
+static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
+{
+	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
+}
+
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -1055,8 +1060,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct blk_dax_ctl dax = { 0 };
 		ssize_t map_len;
 
-		dax.sector = iomap->blkno +
-			(((pos & PAGE_MASK) - iomap->offset) >> 9);
+		dax.sector = dax_iomap_sector(iomap, pos);
 		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
 		map_len = dax_map_atomic(iomap->bdev, &dax);
 		if (map_len < 0) {
@@ -1193,7 +1197,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		goto unlock_entry;
 	}
 
-	sector = iomap.blkno + (((pos & PAGE_MASK) - iomap.offset) >> 9);
+	sector = dax_iomap_sector(&iomap, pos);
 
 	if (vmf->cow_page) {
 		switch (iomap.type) {
-- 
2.7.4

