Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45919 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752288AbdDCSxn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 14:53:43 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/8] nowait aio: Return if cannot get hold of i_rwsem
Date: Mon,  3 Apr 2017 13:53:01 -0500
Message-Id: <20170403185307.6243-3-rgoldwyn@suse.de>
In-Reply-To: <20170403185307.6243-1-rgoldwyn@suse.de>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

A failure to lock i_rwsem would mean there is I/O being performed
by another thread. So, let's bail.

Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/filemap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 1694623..e08f3b9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2982,7 +2982,12 @@ ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	inode_lock(inode);
+	if (!inode_trylock(inode)) {
+		/* Don't sleep on inode rwsem */
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		inode_lock(inode);
+	}
 	ret = generic_write_checks(iocb, from);
 	if (ret > 0)
 		ret = __generic_file_write_iter(iocb, from);
-- 
2.10.2

