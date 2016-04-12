Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08DA57CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 11:42:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC97D30406B
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A9sdyN7gFcoIVCyg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:55 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 04/10] dm: add methods to set and get reserved space
Date: Tue, 12 Apr 2016 12:42:47 -0400
Message-Id: <1460479373-63317-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
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
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>

From: Mike Snitzer <snitzer@redhat.com>

[BF: Condensed to single function.]

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c               | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  5 +++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index be49057..8f95e78 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -664,6 +664,46 @@ out:
 	return r;
 }
 
+/*
+ * FIXME: factor out common helper that can be used by
+ * multiple block_device_operations -> target methods
+ * (including dm_blk_ioctl above)
+ */
+
+static int dm_blk_reserve_space(struct block_device *bdev, int mode,
+				sector_t offset, sector_t len, sector_t *res)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	int srcu_idx;
+	struct dm_table *map;
+	struct dm_target *tgt;
+	int r = -EINVAL;
+
+	map = dm_get_live_table(md, &srcu_idx);
+
+	if (!map || !dm_table_get_size(map))
+		goto out;
+
+	/* We only support devices that have a single target */
+	if (dm_table_get_num_targets(map) != 1)
+		goto out;
+
+	tgt = dm_table_get_target(map, 0);
+	if (!tgt->type->reserve_space)
+		goto out;
+
+	if (dm_suspended_md(md)) {
+		r = -EAGAIN;
+		goto out;
+	}
+
+	r = tgt->type->reserve_space(tgt, mode, offset, len, res);
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return r;
+}
+
 static struct dm_io *alloc_io(struct mapped_device *md)
 {
 	return mempool_alloc(md->io_pool, GFP_NOIO);
@@ -3723,6 +3763,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
+	.reserve_space = dm_blk_reserve_space,
 	.owner = THIS_MODULE
 };
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0830c9e..b4825db 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -116,6 +116,10 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+typedef int (*dm_reserve_space_fn) (struct dm_target *ti, int mode,
+				    sector_t offset, sector_t len,
+				    sector_t *res);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -162,6 +166,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_reserve_space_fn reserve_space;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
