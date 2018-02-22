Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44756 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932876AbeBVPaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 10:30:07 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] fs: don't clear I_DIRTY_TIME before calling mark_inode_dirty_sync
Date: Thu, 22 Feb 2018 07:29:56 -0800
Message-Id: <20180222152957.19624-2-hch@lst.de>
In-Reply-To: <20180222152957.19624-1-hch@lst.de>
References: <20180222152957.19624-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

__mark_inode_dirty already takes care of that, and for the XFS lazytime
implementation we need to know that ->dirty_inode was called because
I_DIRTY_TIME was set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c | 1 -
 fs/sync.c  | 6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ef362364d396..6295f1415761 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1533,7 +1533,6 @@ void iput(struct inode *inode)
 	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
 		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
 			atomic_inc(&inode->i_count);
-			inode->i_state &= ~I_DIRTY_TIME;
 			spin_unlock(&inode->i_lock);
 			trace_writeback_lazytime_iput(inode);
 			mark_inode_dirty_sync(inode);
diff --git a/fs/sync.c b/fs/sync.c
index 6e0a2cbaf6de..09f0259724ff 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -187,12 +187,8 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!file->f_op->fsync)
 		return -EINVAL;
-	if (!datasync && (inode->i_state & I_DIRTY_TIME)) {
-		spin_lock(&inode->i_lock);
-		inode->i_state &= ~I_DIRTY_TIME;
-		spin_unlock(&inode->i_lock);
+	if (!datasync && (inode->i_state & I_DIRTY_TIME))
 		mark_inode_dirty_sync(inode);
-	}
 	return file->f_op->fsync(file, start, end, datasync);
 }
 EXPORT_SYMBOL(vfs_fsync_range);
-- 
2.14.2

