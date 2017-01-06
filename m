Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34595 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755140AbdAFOLY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 09:11:24 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 5/8] jbd2: mark the transaction context with the scope GFP_NOFS context
Date: Fri,  6 Jan 2017 15:11:04 +0100
Message-Id: <20170106141107.23953-6-mhocko@kernel.org>
In-Reply-To: <20170106141107.23953-1-mhocko@kernel.org>
References: <20170106141107.23953-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

now that we have memalloc_nofs_{save,restore} api we can mark the whole
transaction context as implicitly GFP_NOFS. All allocations will
automatically inherit GFP_NOFS this way. This means that we do not have
to mark any of those requests with GFP_NOFS and moreover all the
ext4_kv[mz]alloc(GFP_NOFS) are also safe now because even the hardcoded
GFP_KERNEL allocations deep inside the vmalloc will be NOFS now.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 11 +++++++++++
 include/linux/jbd2.h  |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e1652665bd93..35a5d3d76182 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -388,6 +388,11 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
 
 	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
 	jbd2_journal_free_transaction(new_transaction);
+	/*
+	 * Make sure that no allocations done while the transaction is
+	 * open is going to recurse back to the fs layer.
+	 */
+	handle->saved_alloc_context = memalloc_nofs_save();
 	return 0;
 }
 
@@ -466,6 +471,7 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int rsv_blocks,
 	trace_jbd2_handle_start(journal->j_fs_dev->bd_dev,
 				handle->h_transaction->t_tid, type,
 				line_no, nblocks);
+
 	return handle;
 }
 EXPORT_SYMBOL(jbd2__journal_start);
@@ -1760,6 +1766,11 @@ int jbd2_journal_stop(handle_t *handle)
 	if (handle->h_rsv_handle)
 		jbd2_journal_free_reserved(handle->h_rsv_handle);
 free_and_exit:
+	/*
+	 * scope of th GFP_NOFS context is over here and so we can
+	 * restore the original alloc context.
+	 */
+	memalloc_nofs_restore(handle->saved_alloc_context);
 	jbd2_free_handle(handle);
 	return err;
 }
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index dfaa1f4dcb0c..606b6bce3a5b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -491,6 +491,8 @@ struct jbd2_journal_handle
 
 	unsigned long		h_start_jiffies;
 	unsigned int		h_requested_credits;
+
+	unsigned int		saved_alloc_context;
 };
 
 
-- 
2.11.0

