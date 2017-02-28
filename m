Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbdB1X7y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 18:59:54 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/8] nowait aio: Return if cannot get hold of i_rwsem
Date: Tue, 28 Feb 2017 17:36:04 -0600
Message-Id: <20170228233610.25456-3-rgoldwyn@suse.de>
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

A failure to lock i_rwsem would mean there is I/O being performed
by another thread. So, let's bail.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 mm/filemap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3f9afde..78dd50e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2973,7 +2973,12 @@ ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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

