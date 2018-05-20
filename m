Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35287 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752634AbeETW0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:34 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 08/12] target: convert to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 18:25:54 -0400
Message-Id: <20180520222558.7053-9-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/target/target_core_iblock.c | 14 ++++++--------
 drivers/target/target_core_iblock.h |  2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 44cacd001a..ce1321a5cb 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -94,8 +94,8 @@ static int iblock_configure_device(struct se_device *dev)
 		return -EINVAL;
 	}
 
-	ib_dev->ibd_bio_set = bioset_create(IBLOCK_BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-	if (!ib_dev->ibd_bio_set) {
+	ret = bioset_init(&ib_dev->ibd_bio_set, IBLOCK_BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	if (ret) {
 		pr_err("IBLOCK: Unable to create bioset\n");
 		goto out;
 	}
@@ -141,7 +141,7 @@ static int iblock_configure_device(struct se_device *dev)
 
 	bi = bdev_get_integrity(bd);
 	if (bi) {
-		struct bio_set *bs = ib_dev->ibd_bio_set;
+		struct bio_set *bs = &ib_dev->ibd_bio_set;
 
 		if (!strcmp(bi->profile->name, "T10-DIF-TYPE3-IP") ||
 		    !strcmp(bi->profile->name, "T10-DIF-TYPE1-IP")) {
@@ -174,8 +174,7 @@ static int iblock_configure_device(struct se_device *dev)
 out_blkdev_put:
 	blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
 out_free_bioset:
-	bioset_free(ib_dev->ibd_bio_set);
-	ib_dev->ibd_bio_set = NULL;
+	bioset_exit(&ib_dev->ibd_bio_set);
 out:
 	return ret;
 }
@@ -199,8 +198,7 @@ static void iblock_destroy_device(struct se_device *dev)
 
 	if (ib_dev->ibd_bd != NULL)
 		blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
-	if (ib_dev->ibd_bio_set != NULL)
-		bioset_free(ib_dev->ibd_bio_set);
+	bioset_exit(&ib_dev->ibd_bio_set);
 }
 
 static unsigned long long iblock_emulate_read_cap_with_block_size(
@@ -332,7 +330,7 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int op,
 	if (sg_num > BIO_MAX_PAGES)
 		sg_num = BIO_MAX_PAGES;
 
-	bio = bio_alloc_bioset(GFP_NOIO, sg_num, ib_dev->ibd_bio_set);
+	bio = bio_alloc_bioset(GFP_NOIO, sg_num, &ib_dev->ibd_bio_set);
 	if (!bio) {
 		pr_err("Unable to allocate memory for bio\n");
 		return NULL;
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index b4aeb2584a..9cc3843404 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -22,7 +22,7 @@ struct iblock_dev {
 	struct se_device dev;
 	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];
 	u32	ibd_flags;
-	struct bio_set	*ibd_bio_set;
+	struct bio_set	ibd_bio_set;
 	struct block_device *ibd_bd;
 	bool ibd_readonly;
 } ____cacheline_aligned;
-- 
2.17.0

