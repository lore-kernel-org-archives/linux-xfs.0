Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55253 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdH1GhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 02:37:09 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] iomap: return VM_FAULT_* codes from iomap_page_mkwrite
Date: Mon, 28 Aug 2017 08:36:58 +0200
Message-Id: <20170828063659.21045-2-hch@lst.de>
In-Reply-To: <20170828063659.21045-1-hch@lst.de>
References: <20170828063659.21045-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz

All callers will need the VM_FAULT_* flags, so convert in the helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/iomap.c        | 4 ++--
 fs/xfs/xfs_file.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 59cc98ad7577..8554a8d75281 100644
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
index c4893e226fd8..8b0181c6d2a6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1035,7 +1035,6 @@ xfs_filemap_page_mkwrite(
 		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
 	} else {
 		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
-		ret = block_page_mkwrite_return(ret);
 	}
 
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-- 
2.11.0

