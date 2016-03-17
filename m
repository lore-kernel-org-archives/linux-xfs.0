Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B21F47CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2232EAC006
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dwnmE96ka51A0Dew (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:39 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 1/9] block: add block_device_operations methods to set and
	get reserved space
Date: Thu, 17 Mar 2016 10:30:29 -0400
Message-Id: <1458225037-24155-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

From: Mike Snitzer <snitzer@redhat.com>

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 fs/block_dev.c         | 20 ++++++++++++++++++++
 include/linux/blkdev.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 826b164..375a2e4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -497,6 +497,26 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
+int blk_reserve_space(struct block_device *bdev, sector_t nr_sects)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->reserve_space)
+		return -EOPNOTSUPP;
+	return ops->reserve_space(bdev, nr_sects);
+}
+EXPORT_SYMBOL_GPL(blk_reserve_space);
+
+int blk_get_reserved_space(struct block_device *bdev, sector_t *nr_sects)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->get_reserved_space)
+		return -EOPNOTSUPP;
+	return ops->get_reserved_space(bdev, nr_sects);
+}
+EXPORT_SYMBOL_GPL(blk_get_reserved_space);
+
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 413c84f..f212fe5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1664,6 +1664,8 @@ struct block_device_operations {
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
+	int (*reserve_space) (struct block_device *, sector_t);
+	int (*get_reserved_space) (struct block_device *, sector_t *);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 };
@@ -1674,6 +1676,9 @@ extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
+
+extern int blk_reserve_space(struct block_device *, sector_t);
+extern int blk_get_reserved_space(struct block_device *, sector_t *);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
