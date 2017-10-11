Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58319 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757503AbdJKUGU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:06:20 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 16/19] ext4: Support for synchronous DAX faults
Date: Wed, 11 Oct 2017 22:06:00 +0200
Message-Id: <20171011200603.27442-17-jack@suse.cz>
In-Reply-To: <20171011200603.27442-1-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>

We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
synchronous write fault when inode has some uncommitted metadata
changes. In the fault handler ext4_dax_fault() we then detect this case,
call vfs_fsync_range() to make sure all metadata is committed, and call
dax_insert_pfn_mkwrite() to insert page table entry. Note that this will
also dirty corresponding radix tree entry which is what we want -
fsync(2) will still provide data integrity guarantees for applications
not using userspace flushing. And applications using userspace flushing
can avoid calling fsync(2) and thus avoid the performance overhead.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c       |  6 +++++-
 fs/ext4/inode.c      | 15 +++++++++++++++
 fs/jbd2/journal.c    | 17 +++++++++++++++++
 include/linux/jbd2.h |  1 +
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 208adfc3e673..61a8788168f3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -295,6 +295,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	 */
 	bool write = (vmf->flags & FAULT_FLAG_WRITE) &&
 		(vmf->vma->vm_flags & VM_SHARED);
+	pfn_t pfn;
 
 	if (write) {
 		sb_start_pagefault(sb);
@@ -310,9 +311,12 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	} else {
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	result = dax_iomap_fault(vmf, pe_size, NULL, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, pe_size, &pfn, &ext4_iomap_ops);
 	if (write) {
 		ext4_journal_stop(handle);
+		/* Handling synchronous page fault? */
+		if (result & VM_FAULT_NEEDDSYNC)
+			result = dax_finish_sync_fault(vmf, pe_size, pfn);
 		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
 	} else {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 31db875bc7a1..13a198924a0f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3394,6 +3394,19 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 }
 
 #ifdef CONFIG_FS_DAX
+static bool ext4_inode_datasync_dirty(struct inode *inode)
+{
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+
+	if (journal)
+		return !jbd2_transaction_committed(journal,
+					EXT4_I(inode)->i_datasync_tid);
+	/* Any metadata buffers to write? */
+	if (!list_empty(&inode->i_mapping->private_list))
+		return true;
+	return inode->i_state & I_DIRTY_DATASYNC;
+}
+
 static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			    unsigned flags, struct iomap *iomap)
 {
@@ -3466,6 +3479,8 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	}
 
 	iomap->flags = 0;
+	if ((flags & IOMAP_WRITE) && ext4_inode_datasync_dirty(inode))
+		iomap->flags |= IOMAP_F_DIRTY;
 	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->dax_dev = sbi->s_daxdev;
 	iomap->offset = first_block << blkbits;
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

