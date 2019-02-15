Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394232AbfBOLPv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Feb 2019 06:15:51 -0500
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V15 08/18] block: introduce mp_bvec_last_segment()
Date: Fri, 15 Feb 2019 19:13:14 +0800
Message-Id: <20190215111324.30129-9-ming.lei@redhat.com>
In-Reply-To: <20190215111324.30129-1-ming.lei@redhat.com>
References: <20190215111324.30129-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Ming Lei <ming.lei@redhat.com>

BTRFS and guard_bio_eod() need to get the last singlepage segment
from one multipage bvec, so introduce this helper to make them happy.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bvec.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0ae729b1c9fe..21f76bad7be2 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -131,4 +131,26 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 	.bi_bvec_done	= 0,						\
 }
 
+/*
+ * Get the last single-page segment from the multi-page bvec and store it
+ * in @seg
+ */
+static inline void mp_bvec_last_segment(const struct bio_vec *bvec,
+					struct bio_vec *seg)
+{
+	unsigned total = bvec->bv_offset + bvec->bv_len;
+	unsigned last_page = (total - 1) / PAGE_SIZE;
+
+	seg->bv_page = nth_page(bvec->bv_page, last_page);
+
+	/* the whole segment is inside the last page */
+	if (bvec->bv_offset >= last_page * PAGE_SIZE) {
+		seg->bv_offset = bvec->bv_offset % PAGE_SIZE;
+		seg->bv_len = bvec->bv_len;
+	} else {
+		seg->bv_offset = 0;
+		seg->bv_len = total - last_page * PAGE_SIZE;
+	}
+}
+
 #endif /* __LINUX_BVEC_ITER_H */
-- 
2.9.5
