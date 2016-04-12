Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E03E17CA1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 11:42:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32E4FAC002
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PwYutAjVesMcyVxL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:56 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 05/10] dm thin: add methods to set and get reserved
	space
Date: Tue, 12 Apr 2016 12:42:48 -0400
Message-Id: <1460479373-63317-6-git-send-email-bfoster@redhat.com>
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
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>

From: Joe Thornber <ejt@redhat.com>

Experimental reserve interface for XFS guys to play with.

I have big reservations (no pun intended) about this patch.

[BF:
 - Support for reservation reduction.
 - Support for space provisioning.
 - Condensed to a single function.]

Not-Signed-off-by: Joe Thornber <ejt@redhat.com>
Not-Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 181 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 171 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 92237b6..32bc5bd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -271,6 +271,8 @@ struct pool {
 	process_mapping_fn process_prepared_discard;
 
 	struct dm_bio_prison_cell **cell_sort_array;
+
+	dm_block_t reserve_count;
 };
 
 static enum pool_mode get_pool_mode(struct pool *pool);
@@ -318,6 +320,8 @@ struct thin_c {
 	 */
 	atomic_t refcount;
 	struct completion can_destroy;
+
+	dm_block_t reserve_count;
 };
 
 /*----------------------------------------------------------------*/
@@ -1359,24 +1363,19 @@ static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
 	}
 }
 
-static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
+static int get_free_blocks(struct pool *pool, dm_block_t *free_blocks)
 {
 	int r;
-	dm_block_t free_blocks;
-	struct pool *pool = tc->pool;
-
-	if (WARN_ON(get_pool_mode(pool) != PM_WRITE))
-		return -EINVAL;
 
-	r = dm_pool_get_free_block_count(pool->pmd, &free_blocks);
+	r = dm_pool_get_free_block_count(pool->pmd, free_blocks);
 	if (r) {
 		metadata_operation_failed(pool, "dm_pool_get_free_block_count", r);
 		return r;
 	}
 
-	check_low_water_mark(pool, free_blocks);
+	check_low_water_mark(pool, *free_blocks);
 
-	if (!free_blocks) {
+	if (!*free_blocks) {
 		/*
 		 * Try to commit to see if that will free up some
 		 * more space.
@@ -1385,7 +1384,7 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 		if (r)
 			return r;
 
-		r = dm_pool_get_free_block_count(pool->pmd, &free_blocks);
+		r = dm_pool_get_free_block_count(pool->pmd, free_blocks);
 		if (r) {
 			metadata_operation_failed(pool, "dm_pool_get_free_block_count", r);
 			return r;
@@ -1397,6 +1396,76 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 		}
 	}
 
+	return r;
+}
+
+/*
+ * Returns true iff either:
+ * i) decrement succeeded (ie. there was reserve left)
+ * ii) there is extra space in the pool
+ */
+static bool dec_reserve_count(struct thin_c *tc, dm_block_t free_blocks)
+{
+	bool r = false;
+	unsigned long flags;
+
+	if (!free_blocks)
+		return false;
+
+	spin_lock_irqsave(&tc->pool->lock, flags);
+	if (tc->reserve_count > 0) {
+		tc->reserve_count--;
+		tc->pool->reserve_count--;
+		r = true;
+	} else {
+		if (free_blocks > tc->pool->reserve_count)
+			r = true;
+	}
+	spin_unlock_irqrestore(&tc->pool->lock, flags);
+
+	return r;
+}
+
+static int set_reserve_count(struct thin_c *tc, dm_block_t count)
+{
+	int r;
+	dm_block_t free_blocks;
+	int64_t delta;
+	unsigned long flags;
+
+	r = get_free_blocks(tc->pool, &free_blocks);
+	if (r)
+		return r;
+
+	spin_lock_irqsave(&tc->pool->lock, flags);
+	delta = count - tc->reserve_count;
+	if (tc->pool->reserve_count + delta > free_blocks)
+		r = -ENOSPC;
+	else {
+		tc->reserve_count = count;
+		tc->pool->reserve_count += delta;
+	}
+	spin_unlock_irqrestore(&tc->pool->lock, flags);
+
+	return r;
+}
+
+static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
+{
+	int r;
+	dm_block_t free_blocks;
+	struct pool *pool = tc->pool;
+
+	if (WARN_ON(get_pool_mode(pool) != PM_WRITE))
+		return -EINVAL;
+
+	r = get_free_blocks(tc->pool, &free_blocks);
+	if (r)
+		return r;
+
+	if (!dec_reserve_count(tc, free_blocks))
+		return -ENOSPC;
+
 	r = dm_pool_alloc_data_block(pool->pmd, result);
 	if (r) {
 		metadata_operation_failed(pool, "dm_pool_alloc_data_block", r);
@@ -2880,6 +2949,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pool->last_commit_jiffies = jiffies;
 	pool->pool_md = pool_md;
 	pool->md_dev = metadata_dev;
+	pool->reserve_count = 0;
 	__pool_table_insert(pool);
 
 	return pool;
@@ -3936,6 +4006,7 @@ static void thin_dtr(struct dm_target *ti)
 
 	spin_lock_irqsave(&tc->pool->lock, flags);
 	list_del_rcu(&tc->list);
+	tc->pool->reserve_count -= tc->reserve_count;
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 	synchronize_rcu();
 
@@ -4074,6 +4145,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	init_completion(&tc->can_destroy);
 	list_add_tail_rcu(&tc->list, &tc->pool->active_thins);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
+	tc->reserve_count = 0;
 	/*
 	 * This synchronize_rcu() call is needed here otherwise we risk a
 	 * wake_worker() call finding no bios to process (because the newly
@@ -4271,6 +4343,94 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
 }
 
+static int thin_provision_space(struct dm_target *ti, sector_t offset,
+				sector_t len, sector_t *res)
+{
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+	sector_t end;
+	dm_block_t pblock;
+	dm_block_t vblock;
+	int error;
+	struct dm_thin_lookup_result lookup;
+
+	if (!is_factor(offset, pool->sectors_per_block))
+		return -EINVAL;
+
+	if (!len || !is_factor(len, pool->sectors_per_block))
+		return -EINVAL;
+
+	if (res && !is_factor(*res, pool->sectors_per_block))
+		return -EINVAL;
+
+	end = offset + len;
+
+	while (offset < end) {
+		vblock = offset;
+		do_div(vblock, pool->sectors_per_block);
+
+		error = dm_thin_find_block(tc->td, vblock, true, &lookup);
+		if (error == 0)
+			goto next;
+		if (error != -ENODATA)
+			return error;
+
+		error = alloc_data_block(tc, &pblock);
+		if (error)
+			return error;
+
+		error = dm_thin_insert_block(tc->td, vblock, pblock);
+		if (error)
+			return error;
+
+		if (res && *res)
+			*res -= pool->sectors_per_block;
+next:
+		offset += pool->sectors_per_block;
+	}
+
+	return 0;
+}
+
+static int thin_reserve_space(struct dm_target *ti, int mode, sector_t offset,
+			      sector_t len, sector_t *res)
+{
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+	sector_t blocks;
+	unsigned long flags;
+	int error;
+
+	if (mode == BDEV_RES_PROVISION)
+		return thin_provision_space(ti, offset, len, res);
+
+	/* res required for get/set */
+	error = -EINVAL;
+	if (!res)
+		return error;
+
+	if (mode == BDEV_RES_GET) {
+		spin_lock_irqsave(&tc->pool->lock, flags);
+		*res = tc->reserve_count * pool->sectors_per_block;
+		spin_unlock_irqrestore(&tc->pool->lock, flags);
+		error = 0;
+	} else if (mode == BDEV_RES_MOD) {
+		/*
+		* @res must always be a factor of the pool's blocksize; upper
+		* layers can rely on the bdev's minimum_io_size for this.
+		*/
+		if (!is_factor(*res, pool->sectors_per_block))
+			return error;
+
+		blocks = *res;
+		(void) sector_div(blocks, pool->sectors_per_block);
+
+		error = set_reserve_count(tc, blocks);
+	}
+
+	return error;
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
 	.version = {1, 18, 0},
@@ -4285,6 +4445,7 @@ static struct target_type thin_target = {
 	.status = thin_status,
 	.iterate_devices = thin_iterate_devices,
 	.io_hints = thin_io_hints,
+	.reserve_space = thin_reserve_space,
 };
 
 /*----------------------------------------------------------------*/
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
