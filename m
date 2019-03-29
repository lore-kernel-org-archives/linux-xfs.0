Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58700 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbfC2OYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:24:48 -0400
From: Bob Liu <bob.liu@oracle.com>
Subject: [PATCH v3 1/3] block: introduce submit_bio_verify()
Date: Fri, 29 Mar 2019 22:23:44 +0800
Message-Id: <20190329142346.1677-2-bob.liu@oracle.com>
In-Reply-To: <20190329142346.1677-1-bob.liu@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, axboe@kernel.dk, tytso@mit.edu, Bob Liu <bob.liu@oracle.com>

This patch adds a function verifier callback to submit_bio.  The
filesystem layer can use submit_bio_verify to pass a call back
to the block layer which can then be used to verify if the data
read is correct.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 block/blk-core.c    | 13 ++++++++++---
 include/linux/bio.h |  2 ++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6b78ec56a4f2..d265d2924c32 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1156,15 +1156,16 @@ blk_qc_t direct_make_request(struct bio *bio)
 EXPORT_SYMBOL_GPL(direct_make_request);
 
 /**
- * submit_bio - submit a bio to the block device layer for I/O
+ * submit_bio_verify - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
  *
- * submit_bio() is very similar in purpose to generic_make_request(), and
+ * submit_bio_verify() is very similar in purpose to generic_make_request(), and
  * uses that function to do most of the work. Both are fairly rough
  * interfaces; @bio must be presetup and ready for I/O.
  *
  */
-blk_qc_t submit_bio(struct bio *bio)
+blk_qc_t submit_bio_verify(struct bio *bio,
+		int (*verifier_cb_func)(struct bio *))
 {
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
@@ -1197,6 +1198,12 @@ blk_qc_t submit_bio(struct bio *bio)
 
 	return generic_make_request(bio);
 }
+EXPORT_SYMBOL(submit_bio_verify);
+
+blk_qc_t submit_bio(struct bio *bio)
+{
+	return submit_bio_verify(bio, NULL);
+}
 EXPORT_SYMBOL(submit_bio);
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7380b094dcca..ddaadab74dcf 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -398,6 +398,8 @@ static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
 }
 
+extern blk_qc_t submit_bio_verify(struct bio *,
+		int (*verifier_cb_func)(struct bio *));
 extern blk_qc_t submit_bio(struct bio *);
 
 extern void bio_endio(struct bio *);
-- 
2.17.1
