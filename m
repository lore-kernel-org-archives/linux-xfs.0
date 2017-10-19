Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34039 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752433AbdJSNIn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:08:43 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/17] dax: Create local variable for VMA in dax_iomap_pte_fault()
Date: Thu, 19 Oct 2017 14:58:04 +0200
Message-Id: <20171019125817.11580-6-jack@suse.cz>
In-Reply-To: <20171019125817.11580-1-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>

There are already two users and more are coming.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 116eef8d6c69..c09465884bbe 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1108,7 +1108,8 @@ static int dax_fault_return(int error)
 static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			       const struct iomap_ops *ops)
 {
-	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	struct vm_area_struct *vma = vmf->vma;
+	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
@@ -1196,7 +1197,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
-			count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
+			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
 		error = dax_insert_mapping(vmf, &iomap, pos, entry);
-- 
2.12.3

