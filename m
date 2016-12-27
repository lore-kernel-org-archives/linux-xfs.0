Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33052 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932916AbcL0QGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Dec 2016 11:06:25 -0500
From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 42/54] xfs: convert to bio_for_each_segment_all_sp()
Date: Wed, 28 Dec 2016 00:04:51 +0800
Message-Id: <1482854706-14128-11-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
References: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Dave Chinner <david@fromorbit.com>, "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 fs/xfs/xfs_aops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0f56fcd3a5d5..1acd6162aec1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -139,6 +139,7 @@ xfs_destroy_ioend(
 	for (bio = &ioend->io_inline_bio; bio; bio = next) {
 		struct bio_vec	*bvec;
 		int		i;
+		struct bvec_iter_all bia;
 
 		/*
 		 * For the last bio, bi_private points to the ioend, so we
@@ -150,7 +151,7 @@ xfs_destroy_ioend(
 			next = bio->bi_private;
 
 		/* walk each page on bio, ending page IO on them */
-		bio_for_each_segment_all(bvec, bio, i)
+		bio_for_each_segment_all_sp(bvec, bio, i, bia)
 			xfs_finish_page_writeback(inode, bvec, error);
 
 		bio_put(bio);
-- 
2.7.4

