Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 23CDC7F3F
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 15:12:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0508AC002
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:40 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id lIMQS4vjGB6Qlrj5 for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:38 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [RFC 11/11] ext4: add ext4_dax_pfn_mkwrite()
Date: Thu, 29 Oct 2015 14:12:15 -0600
Message-Id: <1446149535-16200-12-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Add ext4_dax_pfn_mkwrite() that properly protects against freeze, sets
the file update time and calls into dax_pfn_mkwrite() to add the newly
dirtied page to the radix tree which tracks dirty DAX pages.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext4/file.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 54d7729..7f62cad 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -272,11 +272,31 @@ static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 				ext4_end_io_unwritten);
 }
 
+static int ext4_dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	loff_t size;
+	int ret;
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
+
+	/* check that the faulting page hasn't raced with truncate */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		ret = VM_FAULT_SIGBUS;
+	else
+		ret = dax_pfn_mkwrite(vma, vmf);
+
+	sb_end_pagefault(inode->i_sb);
+	return ret;
+}
+
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
 	.pmd_fault	= ext4_dax_pmd_fault,
 	.page_mkwrite	= ext4_dax_mkwrite,
-	.pfn_mkwrite	= dax_pfn_mkwrite,
+	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
 };
 #else
 #define ext4_dax_vm_ops	ext4_file_vm_ops
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
