Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67E6E7CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E752304062
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id J4f9IId0t8WGwZDF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 5/9] block: add a block_device_operations method to
	provision space
Date: Thu, 17 Mar 2016 10:30:33 -0400
Message-Id: <1458225037-24155-6-git-send-email-bfoster@redhat.com>
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

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/block_dev.c         | 10 ++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 375a2e4..73e57b9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -517,6 +517,16 @@ int blk_get_reserved_space(struct block_device *bdev, sector_t *nr_sects)
 }
 EXPORT_SYMBOL_GPL(blk_get_reserved_space);
 
+int blk_provision_space(struct block_device *bdev, sector_t offset, sector_t len)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->provision_space)
+		return -EOPNOTSUPP;
+	return ops->provision_space(bdev, offset, len);
+}
+EXPORT_SYMBOL_GPL(blk_provision_space);
+
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f212fe5..d0fa8a35 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1666,6 +1666,7 @@ struct block_device_operations {
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	int (*reserve_space) (struct block_device *, sector_t);
 	int (*get_reserved_space) (struct block_device *, sector_t *);
+	int (*provision_space) (struct block_device *, sector_t, sector_t);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 };
@@ -1679,6 +1680,7 @@ extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 
 extern int blk_reserve_space(struct block_device *, sector_t);
 extern int blk_get_reserved_space(struct block_device *, sector_t *);
+extern int blk_provision_space(struct block_device *, sector_t, sector_t);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
