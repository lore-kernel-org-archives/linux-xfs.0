Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52387 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdB1X7y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 18:59:54 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 6/8] nowait aio: ext4
Date: Tue, 28 Feb 2017 17:36:08 -0600
Message-Id: <20170228233610.25456-7-rgoldwyn@suse.de>
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Return EAGAIN if any of the following checks fail for direct I/O:
 + i_rwsem is lockable
 + Writing beyond end of file (will trigger allocation)
 + Blocks are not allocated at the write location

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ext4/file.c | 53 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d663d3d..391e03b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -124,27 +124,22 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
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
@@ -176,6 +171,7 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 	bool overwrite = false;
+	struct ext4_map_blocks map;
 
 	inode_lock(inode);
 	ret = ext4_write_checks(iocb, from);
@@ -188,7 +184,9 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret)
 		goto out;
 
-	if (ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
+	if (ext4_blocks_mapped(inode, iocb->ki_pos,
+				iov_iter_count(from), &map) &&
+	    (map.m_flags & EXT4_MAP_MAPPED)) {
 		overwrite = true;
 		downgrade_write(&inode->i_rwsem);
 	}
@@ -209,6 +207,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int o_direct = iocb->ki_flags & IOCB_DIRECT;
+	int nowait = iocb->ki_flags & IOCB_NOWAIT;
 	int unaligned_aio = 0;
 	int overwrite = 0;
 	ssize_t ret;
@@ -218,7 +217,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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
@@ -237,9 +242,21 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
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
-- 
2.10.2

