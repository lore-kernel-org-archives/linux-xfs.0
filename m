Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53109 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751369AbdHQQI2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 12:08:28 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/13] dax: Create local variable for VMA in dax_iomap_pte_fault()
Date: Thu, 17 Aug 2017 18:08:06 +0200
Message-Id: <20170817160815.30466-5-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>

There are already two users and more are coming.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1122356f8b88..75aa0d9fb39f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1097,7 +1097,8 @@ static int dax_fault_return(int error)
 static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			       const struct iomap_ops *ops)
 {
-	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	struct vm_area_struct *vma = vmf->vma;
+	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
@@ -1185,7 +1186,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
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

