Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752700AbdDNMDU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Apr 2017 08:03:20 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 6/8] nowait aio: ext4
Date: Fri, 14 Apr 2017 07:02:55 -0500
Message-Id: <20170414120257.8932-7-rgoldwyn@suse.de>
In-Reply-To: <20170414120257.8932-1-rgoldwyn@suse.de>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
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

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ext4/file.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cefa9835f275..2efdc6d4d3e8 100644
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

