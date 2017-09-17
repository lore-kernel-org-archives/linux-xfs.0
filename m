Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43629 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbdIQVHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:31 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 32/47] xfs: evict all inodes involved with log redo item
Date: Sun, 17 Sep 2017 14:06:57 -0700
Message-Id: <20170917210712.10804-33-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, viro@ZenIV.linux.org.uk

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 799ea9e9c59949008770aab4e1da87f10e99dbe4 upstream.

When we introduced the bmap redo log items, we set MS_ACTIVE on the
mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
from being truncated prematurely during log recovery.  This also had the
effect of putting linked inodes on the lru instead of evicting them.

Unfortunately, we neglected to find all those unreferenced lru inodes
and evict them after finishing log recovery, which means that we leak
them if anything goes wrong in the rest of xfs_mountfs, because the lru
is only cleaned out on unmount.

Therefore, evict unreferenced inodes in the lru list immediately
after clearing MS_ACTIVE.

Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: viro@ZenIV.linux.org.uk
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/inode.c         |  1 +
 fs/internal.h      |  1 -
 fs/xfs/xfs_log.c   | 12 ++++++++++++
 include/linux/fs.h |  1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 88110fd0b282..920aa0b1c6b0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -637,6 +637,7 @@ void evict_inodes(struct super_block *sb)
 
 	dispose_list(&dispose);
 }
+EXPORT_SYMBOL_GPL(evict_inodes);
 
 /**
  * invalidate_inodes	- attempt to free all inodes on a superblock
diff --git a/fs/internal.h b/fs/internal.h
index f4da3341b4a3..8b7143b0211c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -136,7 +136,6 @@ extern bool atime_needs_update_rcu(const struct path *, struct inode *);
 extern void inode_io_list_del(struct inode *inode);
 
 extern long get_nr_dirty_inodes(void);
-extern void evict_inodes(struct super_block *);
 extern int invalidate_inodes(struct super_block *, bool);
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ebe20f1591f1..fe5f3df8b253 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -761,12 +761,24 @@ xfs_log_mount_finish(
 	 * inodes.  Turn it off immediately after recovery finishes
 	 * so that we don't leak the quota inodes if subsequent mount
 	 * activities fail.
+	 *
+	 * We let all inodes involved in redo item processing end up on
+	 * the LRU instead of being evicted immediately so that if we do
+	 * something to an unlinked inode, the irele won't cause
+	 * premature truncation and freeing of the inode, which results
+	 * in log recovery failure.  We have to evict the unreferenced
+	 * lru inodes after clearing MS_ACTIVE because we don't
+	 * otherwise clean up the lru if there's a subsequent failure in
+	 * xfs_mountfs, which leads to us leaking the inodes if nothing
+	 * else (e.g. quotacheck) references the inodes before the
+	 * mount failure occurs.
 	 */
 	mp->m_super->s_flags |= MS_ACTIVE;
 	error = xlog_recover_finish(mp->m_log);
 	if (!error)
 		xfs_log_work_queue(mp);
 	mp->m_super->s_flags &= ~MS_ACTIVE;
+	evict_inodes(mp->m_super);
 
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd88ded27fc8..d705ae084edd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2760,6 +2760,7 @@ static inline void lockdep_annotate_inode_mutex_key(struct inode *inode) { };
 #endif
 extern void unlock_new_inode(struct inode *);
 extern unsigned int get_next_ino(void);
+extern void evict_inodes(struct super_block *sb);
 
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
-- 
2.14.1

