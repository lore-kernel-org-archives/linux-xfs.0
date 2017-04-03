Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45977 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752577AbdDCSyD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 14:54:03 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 6/8] nowait aio: ext4
Date: Mon,  3 Apr 2017 13:53:05 -0500
Message-Id: <20170403185307.6243-7-rgoldwyn@suse.de>
In-Reply-To: <20170403185307.6243-1-rgoldwyn@suse.de>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Return EAGAIN if any of the following checks fail for direct I/O:
 + i_rwsem is lockable
 + Writing beyond end of file (will trigger allocation)
 + Blocks are not allocated at the write location
---
 fs/ext4/file.c  | 48 +++++++++++++++++++++++++++++++-----------------
 fs/ext4/super.c |  6 +++---
 2 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8210c1f..e223b9f 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -127,27 +127,22 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
 	return 0;
 }
 
-/* Is IO overwriting allocated and initialized blocks? */
-static bool ext4_overwrite_io(struct inode *inode, loff_t pos, loff_t len)
+/* Are IO blocks allocated */
+static bool ext4_blocks_mapped(struct inode *inode, loff_t pos, loff_t len,
+				struct ext4_map_blocks *map)
 {
-	struct ext4_map_blocks map;
 	unsigned int blkbits = inode->i_blkbits;
 	int err, blklen;
 
 	if (pos + len > i_size_read(inode))
 		return false;
 
-	map.m_lblk = pos >> blkbits;
-	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
-	blklen = map.m_len;
+	map->m_lblk = pos >> blkbits;
+	map->m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
+	blklen = map->m_len;
 
-	err = ext4_map_blocks(NULL, inode, &map, 0);
-	/*
-	 * 'err==len' means that all of the blocks have been preallocated,
-	 * regardless of whether they have been initialized or not. To exclude
-	 * unwritten extents, we need to check m_flags.
-	 */
-	return err == blklen && (map.m_flags & EXT4_MAP_MAPPED);
+	err = ext4_map_blocks(NULL, inode, map, 0);
+	return err == blklen;
 }
 
 static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
@@ -204,6 +199,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int o_direct = iocb->ki_flags & IOCB_DIRECT;
+	int nowait = iocb->ki_flags & IOCB_NOWAIT;
 	int unaligned_aio = 0;
 	int overwrite = 0;
 	ssize_t ret;
@@ -216,7 +212,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return ext4_dax_write_iter(iocb, from);
 #endif
 
-	inode_lock(inode);
+	if (o_direct && nowait) {
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+	} else {
+		inode_lock(inode);
+	}
+
 	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out;
@@ -235,9 +237,21 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	iocb->private = &overwrite;
 	/* Check whether we do a DIO overwrite or not */
-	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
-	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
-		overwrite = 1;
+	if (o_direct && !unaligned_aio) {
+		struct ext4_map_blocks map;
+		if (ext4_blocks_mapped(inode, iocb->ki_pos,
+				      iov_iter_count(from), &map)) {
+	 		/* To exclude unwritten extents, we need to check
+			 * m_flags.
+			 */
+			if (ext4_should_dioread_nolock(inode) &&
+			    (map.m_flags & EXT4_MAP_MAPPED))
+				overwrite = 1;
+		} else if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
 
 	ret = __generic_file_write_iter(iocb, from);
 	inode_unlock(inode);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9448db..e1d424a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -117,7 +117,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_NOWAIT,
 };
 MODULE_ALIAS_FS("ext2");
 MODULE_ALIAS("ext2");
@@ -132,7 +132,7 @@ static struct file_system_type ext3_fs_type = {
 	.name		= "ext3",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_NOWAIT,
 };
 MODULE_ALIAS_FS("ext3");
 MODULE_ALIAS("ext3");
@@ -5623,7 +5623,7 @@ static struct file_system_type ext4_fs_type = {
 	.name		= "ext4",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_NOWAIT,
 };
 MODULE_ALIAS_FS("ext4");
 
-- 
2.10.2

