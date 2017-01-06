Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32941 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbdAFOTG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 09:19:06 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [DEBUG PATCH 2/2] silent warnings which we cannot do anything about
Date: Fri,  6 Jan 2017 15:18:45 +0100
Message-Id: <20170106141845.24362-3-mhocko@kernel.org>
In-Reply-To: <20170106141845.24362-1-mhocko@kernel.org>
References: <20170106141107.23953-1-mhocko@kernel.org>
 <20170106141845.24362-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

THIS PATCH IS FOR TESTING ONLY AND NOT MEANT TO HIT LINUS TREE

There are some code paths used by all the filesystems which we cannot
change to drop the GFP_NOFS, yet they generate a lot of warnings.
Provide {disable,enable}_scope_gfp_check to silence those.
alloc_page_buffers and grow_dev_page are silenced right away.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/buffer.c           |  4 ++++
 include/linux/sched.h | 11 +++++++++++
 mm/page_alloc.c       |  3 +++
 3 files changed, 18 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 28484b3ebc98..dbe529e7881b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -873,7 +873,9 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	head = NULL;
 	offset = PAGE_SIZE;
 	while ((offset -= size) >= 0) {
+		disable_scope_gfp_check();
 		bh = alloc_buffer_head(GFP_NOFS);
+		enable_scope_gfp_check();
 		if (!bh)
 			goto no_grow;
 
@@ -1003,7 +1005,9 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	 */
 	gfp_mask |= __GFP_NOFAIL;
 
+	disable_scope_gfp_check();
 	page = find_or_create_page(inode->i_mapping, index, gfp_mask);
+	enable_scope_gfp_check();
 	if (!page)
 		return ret;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 59428926e989..f60294732ed5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1988,6 +1988,7 @@ struct task_struct {
 	/* A live task holds one reference. */
 	atomic_t stack_refcount;
 #endif
+	bool disable_scope_gfp_warn;
 	unsigned long nofs_caller;
 	unsigned long noio_caller;
 /* CPU-specific state of this task */
@@ -2390,6 +2391,16 @@ static inline unsigned int __memalloc_nofs_save(unsigned long caller)
 	return flags;
 }
 
+static inline void disable_scope_gfp_check(void)
+{
+	current->disable_scope_gfp_warn = true;
+}
+
+static inline void enable_scope_gfp_check(void)
+{
+	current->disable_scope_gfp_warn = false;
+}
+
 #define memalloc_nofs_save()	__memalloc_nofs_save(_RET_IP_)
 
 static inline void memalloc_nofs_restore(unsigned int flags)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 87a2bb5262b2..5405278bd733 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3762,6 +3762,9 @@ void debug_scope_gfp_context(gfp_t gfp_mask)
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return;
 
+	if (current->disable_scope_gfp_warn)
+		return;
+
 	if (current->flags & PF_MEMALLOC_NOIO)
 		restrict_mask = __GFP_IO;
 	else if ((current->flags & PF_MEMALLOC_NOFS) && (gfp_mask & __GFP_IO))
-- 
2.11.0

