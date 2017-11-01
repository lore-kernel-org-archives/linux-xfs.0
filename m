Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44143 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754818AbdKAPhE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Nov 2017 11:37:04 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 15/18] ext4: Simplify error handling in ext4_dax_huge_fault()
Date: Wed,  1 Nov 2017 16:36:44 +0100
Message-Id: <20171101153648.30166-16-jack@suse.cz>
In-Reply-To: <20171101153648.30166-1-jack@suse.cz>
References: <20171101153648.30166-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>

If transaction starting fails, just bail out of the function immediately
instead of checking for that condition throughout the function.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3cec0b95672f..208adfc3e673 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -302,16 +302,17 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 					       EXT4_DATA_TRANS_BLOCKS(sb));
+		if (IS_ERR(handle)) {
+			up_read(&EXT4_I(inode)->i_mmap_sem);
+			sb_end_pagefault(sb);
+			return VM_FAULT_SIGBUS;
+		}
 	} else {
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	if (!IS_ERR(handle))
-		result = dax_iomap_fault(vmf, pe_size, NULL, &ext4_iomap_ops);
-	else
-		result = VM_FAULT_SIGBUS;
+	result = dax_iomap_fault(vmf, pe_size, NULL, &ext4_iomap_ops);
 	if (write) {
-		if (!IS_ERR(handle))
-			ext4_journal_stop(handle);
+		ext4_journal_stop(handle);
 		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
 	} else {
-- 
2.12.3

