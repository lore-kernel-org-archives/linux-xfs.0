Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42737 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751394AbdFEFgM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Jun 2017 01:36:12 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 10/10] btrfs: nowait aio support
Date: Mon,  5 Jun 2017 00:35:40 -0500
Message-Id: <20170605053540.19393-11-rgoldwyn@suse.de>
In-Reply-To: <20170605053540.19393-1-rgoldwyn@suse.de>
References: <20170605053540.19393-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Return EAGAIN if any of the following checks fail
 + i_rwsem is not lockable
 + NODATACOW or PREALLOC is not set
 + Cannot nocow at the desired location
 + Writing beyond end of file which is not allocated

Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c  | 25 ++++++++++++++++++++-----
 fs/btrfs/inode.c |  3 +++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index da1096eb1a40..aae088e49915 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1875,12 +1875,29 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	ssize_t num_written = 0;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 	ssize_t err;
-	loff_t pos;
-	size_t count;
+	loff_t pos = iocb->ki_pos;
+	size_t count = iov_iter_count(from);
 	loff_t oldsize;
 	int clean_page = 0;
 
-	inode_lock(inode);
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+			(iocb->ki_flags & IOCB_DIRECT)) {
+		/* Don't sleep on inode rwsem */
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+		/*
+		 * We will allocate space in case nodatacow is not set,
+		 * so bail
+		 */
+		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+					      BTRFS_INODE_PREALLOC)) ||
+		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
+			inode_unlock(inode);
+			return -EAGAIN;
+		}
+	} else
+		inode_lock(inode);
+
 	err = generic_write_checks(iocb, from);
 	if (err <= 0) {
 		inode_unlock(inode);
@@ -1914,8 +1931,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	 */
 	update_time_for_write(inode);
 
-	pos = iocb->ki_pos;
-	count = iov_iter_count(from);
 	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
 	if (start_pos > oldsize) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe9306faf..2ab71b946829 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8755,6 +8755,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			dio_data.overwrite = 1;
 			inode_unlock(inode);
 			relock = true;
+		} else if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
 		}
 		ret = btrfs_delalloc_reserve_space(inode, offset, count);
 		if (ret)
-- 
2.12.0

