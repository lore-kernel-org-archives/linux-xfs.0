Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11D1C7CA3
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68F0BAC008
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 01kHRUHkMimiTJZ1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 6/9] dm: add method to provision space
Date: Thu, 17 Mar 2016 10:30:34 -0400
Message-Id: <1458225037-24155-7-git-send-email-bfoster@redhat.com>
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
 drivers/md/dm.c               | 35 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  2 ++
 2 files changed, 37 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4da5d3e..e1aec28 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -737,6 +737,40 @@ out:
 	return r;
 }
 
+static int dm_blk_provision_space(struct block_device *bdev,
+				  sector_t offset, sector_t len)
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
+	if (!tgt->type->provision_space)
+		goto out;
+
+	if (dm_suspended_md(md)) {
+		r = -EAGAIN;
+		goto out;
+	}
+
+	r = tgt->type->provision_space(tgt, offset, len);
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return r;
+}
+
 static struct dm_io *alloc_io(struct mapped_device *md)
 {
 	return mempool_alloc(md->io_pool, GFP_NOIO);
@@ -3798,6 +3832,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.pr_ops = &dm_pr_ops,
 	.reserve_space = dm_blk_reserve_space,
 	.get_reserved_space = dm_blk_get_reserved_space,
+	.provision_space = dm_blk_provision_space,
 	.owner = THIS_MODULE
 };
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 540c772..0ebf172 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -118,6 +118,7 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
 
 typedef int (*dm_reserve_space_fn) (struct dm_target *ti, sector_t nr_sects);
 typedef int (*dm_get_reserved_space_fn) (struct dm_target *ti, sector_t *nr_sects);
+typedef int (*dm_provision_space_fn) (struct dm_target *ti, sector_t offset, sector_t len);
 
 void dm_error(const char *message);
 
@@ -167,6 +168,7 @@ struct target_type {
 	dm_io_hints_fn io_hints;
 	dm_reserve_space_fn reserve_space;
 	dm_get_reserved_space_fn get_reserved_space;
+	dm_provision_space_fn provision_space;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
