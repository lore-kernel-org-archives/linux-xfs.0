Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47645 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1035652AbdEXQmS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 12:42:18 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 08/10] ext4: nowait aio support
Date: Wed, 24 May 2017 11:41:48 -0500
Message-Id: <20170524164150.9492-9-rgoldwyn@suse.de>
In-Reply-To: <20170524164150.9492-1-rgoldwyn@suse.de>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Return EAGAIN if any of the following checks fail for direct I/O:
  + i_rwsem is lockable
  + Writing beyond end of file (will trigger allocation)
  + Blocks are not allocated at the write location

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 831fd6beebf0..07f08ff2c11b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -216,7 +216,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return ext4_dax_write_iter(iocb, from);
 #endif
 
-	inode_lock(inode);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+	} else {
+		inode_lock(inode);
+	}
+
 	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out;
@@ -235,9 +241,15 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	iocb->private = &overwrite;
 	/* Check whether we do a DIO overwrite or not */
-	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
-	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
-		overwrite = 1;
+	if (o_direct && !unaligned_aio) {
+		if (ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
+			if (ext4_should_dioread_nolock(inode))
+				overwrite = 1;
+		} else if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
 
 	ret = __generic_file_write_iter(iocb, from);
 	inode_unlock(inode);
-- 
2.12.0

