Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbfBOLQM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Feb 2019 06:16:12 -0500
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V15 09/18] fs/buffer.c: use bvec iterator to truncate the bio
Date: Fri, 15 Feb 2019 19:13:15 +0800
Message-Id: <20190215111324.30129-10-ming.lei@redhat.com>
In-Reply-To: <20190215111324.30129-1-ming.lei@redhat.com>
References: <20190215111324.30129-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Ming Lei <ming.lei@redhat.com>

Once multi-page bvec is enabled, the last bvec may include more than one
page, this patch use mp_bvec_last_segment() to truncate the bio.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/buffer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 52d024bfdbc1..817871274c77 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3032,7 +3032,10 @@ void guard_bio_eod(int op, struct bio *bio)
 
 	/* ..and clear the end of the buffer for reads */
 	if (op == REQ_OP_READ) {
-		zero_user(bvec->bv_page, bvec->bv_offset + bvec->bv_len,
+		struct bio_vec bv;
+
+		mp_bvec_last_segment(bvec, &bv);
+		zero_user(bv.bv_page, bv.bv_offset + bv.bv_len,
 				truncated_bytes);
 	}
 }
-- 
2.9.5
