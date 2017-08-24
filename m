Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753011AbdHXPWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 11:22:17 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] iomap: return VM_FAULT_* codes from iomap_page_mkwrite
Date: Thu, 24 Aug 2017 17:22:05 +0200
Message-Id: <20170824152207.30729-2-hch@lst.de>
In-Reply-To: <20170824152207.30729-1-hch@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c        | 4 ++--
 fs/xfs/xfs_file.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 039266128b7f..22ffdfeabeda 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -477,10 +477,10 @@ int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
 
 	set_page_dirty(page);
 	wait_for_stable_page(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 out_unlock:
 	unlock_page(page);
-	return ret;
+	return block_page_mkwrite_return(ret);
 }
 EXPORT_SYMBOL_GPL(iomap_page_mkwrite);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index afa226b8c290..4213f02325a2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1035,7 +1035,6 @@ xfs_filemap_page_mkwrite(
 		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &xfs_iomap_ops);
 	} else {
 		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
-		ret = block_page_mkwrite_return(ret);
 	}
 
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-- 
2.11.0

