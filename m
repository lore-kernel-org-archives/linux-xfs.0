Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34054 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934307AbcJ2IPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2016 04:15:51 -0400
From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 51/60] xfs: convert to bio_for_each_segment_all_rd()
Date: Sat, 29 Oct 2016 16:08:50 +0800
Message-Id: <1477728600-12938-52-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Dave Chinner <david@fromorbit.com>, "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 fs/xfs/xfs_aops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3e57a56cf829..974b0a516f1d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -144,6 +144,7 @@ xfs_destroy_ioend(
 	for (bio = &ioend->io_inline_bio; bio; bio = next) {
 		struct bio_vec	*bvec;
 		int		i;
+		struct bvec_iter_all bia;
 
 		/*
 		 * For the last bio, bi_private points to the ioend, so we
@@ -155,7 +156,7 @@ xfs_destroy_ioend(
 			next = bio->bi_private;
 
 		/* walk each page on bio, ending page IO on them */
-		bio_for_each_segment_all(bvec, bio, i)
+		bio_for_each_segment_all_rd(bvec, bio, i, bia)
 			xfs_finish_page_writeback(inode, bvec, error);
 
 		bio_put(bio);
-- 
2.7.4

