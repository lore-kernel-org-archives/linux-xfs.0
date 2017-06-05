Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42625 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751298AbdFEFf5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Jun 2017 01:35:57 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 05/10] fs: return if direct write will trigger writeback
Date: Mon,  5 Jun 2017 00:35:35 -0500
Message-Id: <20170605053540.19393-6-rgoldwyn@suse.de>
In-Reply-To: <20170605053540.19393-1-rgoldwyn@suse.de>
References: <20170605053540.19393-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Find out if the write will trigger a wait due to writeback. If yes,
return -EAGAIN.

Return -EINVAL for buffered AIO: there are multiple causes of
delay such as page locks, dirty throttling logic, page loading
from disk etc. which cannot be taken care of.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 mm/filemap.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 097213275461..bc146efa6815 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2675,6 +2675,9 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 
 	pos = iocb->ki_pos;
 
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+		return -EINVAL;
+
 	if (limit != RLIM_INFINITY) {
 		if (iocb->ki_pos >= limit) {
 			send_sig(SIGXFSZ, current, 0);
@@ -2743,9 +2746,17 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	write_len = iov_iter_count(from);
 	end = (pos + write_len - 1) >> PAGE_SHIFT;
 
-	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
-	if (written)
-		goto out;
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* If there are pages to writeback, return */
+		if (filemap_range_has_page(inode->i_mapping, pos,
+					   pos + iov_iter_count(from)))
+			return -EAGAIN;
+	} else {
+		written = filemap_write_and_wait_range(mapping, pos,
+							pos + write_len - 1);
+		if (written)
+			goto out;
+	}
 
 	/*
 	 * After a write we want buffered reads to be sure to go to disk to get
-- 
2.12.0

