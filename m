Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53185 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752671AbdHQQIa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 12:08:30 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 13/13] ext4: Support for synchronous DAX faults
Date: Thu, 17 Aug 2017 18:08:15 +0200
Message-Id: <20170817160815.30466-14-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>

We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
synchronous write fault when inode has some uncommitted metadata
changes. In the fault handler ext4_dax_fault() we then detect this case,
call vfs_fsync_range() to make sure all metadata is committed, and call
dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also
dirty corresponding radix tree entry which is what we want - fsync(2)
will still provide data integrity guarantees for applications not using
userspace flushing. And applications using userspace flushing can avoid
calling fsync(2) and thus avoid the performance overhead.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c       | 36 ++++++++++++++++++++++++++++++------
 fs/ext4/inode.c      |  4 ++++
 fs/jbd2/journal.c    | 17 +++++++++++++++++
 include/linux/jbd2.h |  1 +
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 850037e140d7..3765c4ed1368 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -280,6 +280,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	pfn_t pfn;
 
 	if (write) {
 		sb_start_pagefault(sb);
@@ -287,16 +288,39 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
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
-		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, NULL);
-	else
-		result = VM_FAULT_SIGBUS;
+	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, &pfn);
 	if (write) {
-		if (!IS_ERR(handle))
-			ext4_journal_stop(handle);
+		ext4_journal_stop(handle);
+		/* Write fault but PFN mapped only RO? */
+		if (result & VM_FAULT_NEEDDSYNC) {
+			int err;
+			loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
+			size_t len = 0;
+
+			if (pe_size == PE_SIZE_PTE)
+				len = PAGE_SIZE;
+#ifdef CONFIG_FS_DAX_PMD
+			else if (pe_size == PE_SIZE_PMD)
+				len = HPAGE_PMD_SIZE;
+#endif
+			else
+				WARN_ON_ONCE(1);
+			err = vfs_fsync_range(vmf->vma->vm_file, start,
+					      start + len - 1, 1);
+			if (err)
+				result = VM_FAULT_SIGBUS;
+			else
+				result = dax_insert_pfn_mkwrite(vmf, pe_size,
+								pfn);
+		}
 		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
 	} else {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c600f02673f..7a7529c3f0c8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3429,6 +3429,10 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	}
 
 	iomap->flags = 0;
+	if ((flags & IOMAP_WRITE) &&
+	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
+					EXT4_I(inode)->i_datasync_tid))
+		iomap->flags |= IOMAP_F_NEEDDSYNC;
 	bdev = inode->i_sb->s_bdev;
 	iomap->bdev = bdev;
 	if (blk_queue_dax(bdev->bd_queue))
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7d5ef3bf3f3e..fa8cde498b4b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -738,6 +738,23 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 	return err;
 }
 
+/* Return 1 when transaction with given tid has already committed. */
+int jbd2_transaction_committed(journal_t *journal, tid_t tid)
+{
+	int ret = 1;
+
+	read_lock(&journal->j_state_lock);
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == tid)
+		ret = 0;
+	if (journal->j_committing_transaction &&
+	    journal->j_committing_transaction->t_tid == tid)
+		ret = 0;
+	read_unlock(&journal->j_state_lock);
+	return ret;
+}
+EXPORT_SYMBOL(jbd2_transaction_committed);
+
 /*
  * When this function returns the transaction corresponding to tid
  * will be completed.  If the transaction has currently running, start
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 606b6bce3a5b..296d1e0ea87b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1367,6 +1367,7 @@ int jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
+int jbd2_transaction_committed(journal_t *journal, tid_t tid);
 int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
 int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
-- 
2.12.3

