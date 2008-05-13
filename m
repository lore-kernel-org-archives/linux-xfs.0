Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 18:05:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D159Vd004106
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 18:05:12 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51E9616A3989
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 18:05:56 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id eANQ7eUlla9d22DJ for <xfs@oss.sgi.com>; Mon, 12 May 2008 18:05:56 -0700 (PDT)
From: Neil Brown <neilb@suse.de>
Date: Tue, 13 May 2008 11:05:42 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18472.59750.744829.929828@notabene.brown>
Subject: [PATCH]  Remove blkdev warning triggered by using md.
In-Reply-To: message from Jens Axboe on Monday May 12
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
	<200805121726.15576.alistair@devzero.co.uk>
	<alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org>
	<20080512164920.GE16217@kernel.dk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <jens.axboe@oracle.com>, Alistair John Strachan <alistair@devzero.co.uk>, xfs@oss.sgi.com, Nick Piggin <npiggin@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jacek Luczak <difrost.kernel@gmail.com>, Prakash Punnoor <prakash@punnoor.de>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org


As setting and clearing queue flags now requires that we hold a
spinlock on the queue, and as blk_queue_stack_limits is called without
that lock, get the lock inside blk_queue_stack_limits.

For blk_queue_stack_limits to be able to find the right lock, each md
personality needs to set q->queue_lock to point to the appropriate
lock.  Those personalities which didn't previously use a spin_lock,
us q->__queue_lock.  So always initialise that lock when allocated.

With this in place, setting/clearing of the QUEUE_FLAG_PLUGGED bit
will no longer cause warnings as it will be clear that the proper
lock is held.

Thanks to Dan Williams for review and fixing the silly bugs.

Signed-off-by: NeilBrown <neilb@suse.de>

--
 diffstat output
 ---------------
 block/blk-core.c       |    5 ++---
 block/blk-settings.c   |    8 +++++++-
 drivers/md/linear.c    |    1 +
 drivers/md/multipath.c |    1 +
 drivers/md/raid0.c     |    1 +
 drivers/md/raid1.c     |    4 +++-
 drivers/md/raid10.c    |    4 +++-
 drivers/md/raid5.c     |    1 +
 8 files changed, 19 insertions(+), 6 deletions(-)


diff --git a/block/blk-core.c b/block/blk-core.c
index 2987fe4..6a9cc0d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -482,6 +482,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
 	mutex_init(&q->sysfs_lock);
+	spin_lock_init(&q->__queue_lock);
 
 	return q;
 }
@@ -544,10 +545,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	 * if caller didn't supply a lock, they get per-queue locking with
 	 * our embedded lock
 	 */
-	if (!lock) {
-		spin_lock_init(&q->__queue_lock);
+	if (!lock)
 		lock = &q->__queue_lock;
-	}
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index bb93d4c..8dd8641 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -286,8 +286,14 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);
 	t->max_segment_size = min(t->max_segment_size, b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
-	if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
+	if (!t->queue_lock)
+		WARN_ON_ONCE(1);
+	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
+		unsigned long flags;
+		spin_lock_irqsave(t->queue_lock, flags);
 		queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
+		spin_unlock_irqrestore(t->queue_lock, flags);
+	}
 }
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 0b85117..1074824 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -250,6 +250,7 @@ static int linear_run (mddev_t *mddev)
 {
 	linear_conf_t *conf;
 
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 	conf = linear_conf(mddev, mddev->raid_disks);
 
 	if (!conf)
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 42ee1a2..4f4d1f3 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -417,6 +417,7 @@ static int multipath_run (mddev_t *mddev)
 	 * bookkeeping area. [whatever we allocate in multipath_run(),
 	 * should be freed in multipath_stop()]
 	 */
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	conf = kzalloc(sizeof(multipath_conf_t), GFP_KERNEL);
 	mddev->private = conf;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 818b482..914c04d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -280,6 +280,7 @@ static int raid0_run (mddev_t *mddev)
 	       (mddev->chunk_size>>1)-1);
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
 	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
 	if (!conf)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6778b7c..ac409b7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1935,6 +1935,9 @@ static int run(mddev_t *mddev)
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
+	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -1958,7 +1961,6 @@ static int run(mddev_t *mddev)
 	}
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index faf3d89..8536ede 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2082,6 +2082,9 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2103,7 +2106,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 087eee0..4fafc79 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4256,6 +4256,7 @@ static int run(mddev_t *mddev)
 			goto abort;
 	}
 	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
