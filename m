Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40557 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754240AbdA3VxL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:53:11 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] ext4: Remove unused function ext4_dax_huge_fault()
Date: Mon, 30 Jan 2017 14:52:52 -0700
Message-Id: <1485813172-7284-1-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <148545058784.17912.6353162518188733642.stgit@djiang5-desk3.ch.intel.com>
References: <148545058784.17912.6353162518188733642.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, dave.hansen@linux.intel.com, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, jack@suse.com, dan.j.williams@intel.com, linux-ext4@vger.kernel.org, kirill.shutemov@linux.intel.com, Dave Jiang <dave.jiang@intel.com>

ext4_dax_pmd_fault() was renamed to ext4_dax_huge_fault() in this commit:

commit 7e90fc0f8785 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")

However, the vm_operations_struct ops table for ext4 was modified in that
commit so that .huge_fault called ext4_dax_fault(), not
ext4_dax_huge_fault().  This is actually fine, though, since as of that
commit ext4_dax_fault() and ext4_dax_huge_fault() are identical, both
eventually calling dax_iomap_fault().

So, instead of changing the opts table to have .huge_fault call
ext4_dax_huge_fault(), just leave it calling ext4_dax_fault() and remove
the unused function.

This fix also quiets the following compilation warning:

/ext4/file.c:279:1: warning: ‘ext4_dax_huge_fault’ defined but not used [-Wunused-function]
 ext4_dax_huge_fault(struct vm_fault *vmf)

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: 7e90fc0f8785 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")
Cc: Dave Jiang <dave.jiang@intel.com>
---
Feel free to squash with 7e90fc0f8785 if that's best.

The commit ID of the original patch comes from mmots/master which is
currently at v4.10-rc5-mmots-2017-01-26-15-49.
---
 fs/ext4/file.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ed22d20..51d7155 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -275,27 +275,6 @@ static int ext4_dax_fault(struct vm_fault *vmf)
 	return result;
 }
 
-static int
-ext4_dax_huge_fault(struct vm_fault *vmf)
-{
-	int result;
-	struct inode *inode = file_inode(vmf->vma->vm_file);
-	struct super_block *sb = inode->i_sb;
-	bool write = vmf->flags & FAULT_FLAG_WRITE;
-
-	if (write) {
-		sb_start_pagefault(sb);
-		file_update_time(vmf->vma->vm_file);
-	}
-	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_fault(vmf, &ext4_iomap_ops);
-	up_read(&EXT4_I(inode)->i_mmap_sem);
-	if (write)
-		sb_end_pagefault(sb);
-
-	return result;
-}
-
 /*
  * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_fault()
  * handler we check for races agaist truncate. Note that since we cycle through
-- 
2.7.4

