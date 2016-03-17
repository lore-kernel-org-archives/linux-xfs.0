Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA89C7CB1
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0736AC007
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Te3nhYZ1CF0CLHc0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:39 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 2/9] dm: add methods to set and get reserved space
Date: Thu, 17 Mar 2016 10:30:30 -0400
Message-Id: <1458225037-24155-3-git-send-email-bfoster@redhat.com>
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
 drivers/md/dm.c               | 75 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  5 +++
 2 files changed, 80 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index be49057..4da5d3e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -664,6 +664,79 @@ out:
 	return r;
 }
 
+/*
+ * FIXME: factor out common helper that can be used by
+ * multiple block_device_operations -> target methods
+ * (including dm_blk_ioctl above)
+ */
+
+static int dm_blk_reserve_space(struct block_device *bdev, sector_t nr_sects)
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
+	r = tgt->type->reserve_space(tgt, nr_sects);
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return r;
+}
+
+static int dm_blk_get_reserved_space(struct block_device *bdev,
+				     sector_t *nr_sects)
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
+	if (!tgt->type->get_reserved_space)
+		goto out;
+
+	if (dm_suspended_md(md)) {
+		r = -EAGAIN;
+		goto out;
+	}
+
+	r = tgt->type->get_reserved_space(tgt, nr_sects);
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return r;
+}
+
 static struct dm_io *alloc_io(struct mapped_device *md)
 {
 	return mempool_alloc(md->io_pool, GFP_NOIO);
@@ -3723,6 +3796,8 @@ static const struct block_device_operations dm_blk_dops = {
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
+	.reserve_space = dm_blk_reserve_space,
+	.get_reserved_space = dm_blk_get_reserved_space,
 	.owner = THIS_MODULE
 };
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0830c9e..540c772 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -116,6 +116,9 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+typedef int (*dm_reserve_space_fn) (struct dm_target *ti, sector_t nr_sects);
+typedef int (*dm_get_reserved_space_fn) (struct dm_target *ti, sector_t *nr_sects);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -162,6 +165,8 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_reserve_space_fn reserve_space;
+	dm_get_reserved_space_fn get_reserved_space;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
