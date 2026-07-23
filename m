Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F7F471268;
	Thu, 23 Jul 2026 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818238; cv=none; b=UsY2y9LFWbWSjMtsCehhaI5ExBLBcUmEyIP2mpPrlk4E9ZGjcC+aVuCWdM9XAon0z0WjY4QY8ImY96f+lnn9qmYDQCfms+Q8vryBvRRk5eAcj3NvMOFTTX8d6RcXSlmUSDT0eLCPx0PCiBfXqa7yqWZyn6b4Ophto8Ub3AUmYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818238; c=relaxed/simple;
	bh=Hc7dQvYy7u03Ae4ACPUzPMrH4i8qOjwdnuFLzw3gTTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/a1ICfnVd8gHLaQ6Mw4kQEGB4IFczrURioOBYpIfotR92paW5GYN/36FkxA/jC4oKoHDeWojdb+L7EQcrqjPkERieAQfbvDfLS6zBGIe78U7wUAYsJQZGE6NCI4IxkLrR5fZdesFi9eE+6Vm5bKFqOztro3vXo8FO0suW6yMBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fc2CAhhw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fc2CAhhw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/rU4jTR/BOV1A4Mgi6V0kNEBjbZMhSjzLdSvcct/wz8=; b=Fc2CAhhwWyvHr+ngadWOB51vL6
	EmJrCMRk5Zdf0TaSQoxEvH0w6Q3b1Q24pja+3cfsJ6zDQSJXw1NAE4REkQf0Odseb0DulbA7LFG2k
	kSpc6pecZqsyd7kJzaAOk6+5dtEYy5gR6vilhUzuvGckv0GDQWFDtyzngjWYWA+eYGTJeK7UKn9Fc
	SzQ3XqEQge73rnhxi7DNPcldfEhgJijOcO3fMHVhBj4UFCXYiL09BPnpd3VqMSgiWuNfdY2qiTBNk
	vy2qC7HC6jAKfgmgBwOcFI6p8bqOGBYNXK3OwSt6nqnrVIX6zlrWL/zwtnKyFJQkVu4t82ZKPxBY0
	2TM7h8sw==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuks-0000000EXJ2-21LG;
	Thu, 23 Jul 2026 14:50:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/22] block: add task-context bio completion infrastructure
Date: Thu, 23 Jul 2026 16:49:32 +0200
Message-ID: <20260723145000.116419-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Tal Zussman <tz2294@columbia.edu>

Some bio completion handlers need to run from preemptible task context,
but bio_endio() may be called from IRQ context (e.g., buffer_head
writeback). Callers need a way to ensure their callback eventually runs
from a sleepable context. Add infrastructure for that, in two forms:

  1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
     in advance that its callback needs task context (e.g., dropbehind
     writeback). bio_endio() sees the flag and offloads completion to a
     worker automatically.

  2. bio_complete_in_task(), a helper that completion callbacks can
     invoke from within bi_end_io() when the deferral decision is
     dynamic (e.g., fserror reporting).

Both share a per-CPU batch list drained by a delayed work item on a
WQ_PERCPU workqueue. Producers push the bio onto the local CPU's batch
and schedule the work item, which then dispatches each bio's bi_end_io()
from task context. The delayed work item uses a 1-jiffie delay to allow
batches of completions to accumulate before processing.

Both methods are gated on bio_in_atomic(), which returns true in any
context where a sleeping bi_end_io() is unsafe, including
non-preemptible task context. This logic is copied from commit
c99fab6e80b7 ("erofs: fix atomic context detection when
!CONFIG_DEBUG_LOCK_ALLOC").

Two CPU hotplug callbacks are used to drain remaining bios from the
departing CPU's batch, while maintaining the per-CPU behavior. The
CPUHP_AP_ONLINE_DYN callback disables the per-CPU delayed work while the
CPU is still online, preventing it from running on an unbound worker
later. CPUHP_BP_PREPARE_DYN then drains any bios added between disabling
the work item and CPU offline.

Link: https://lore.kernel.org/all/20260409160243.1008358-1-hch@lst.de/
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c               | 147 +++++++++++++++++++++++++++++++++++++-
 include/linux/bio.h       |  32 +++++++++
 include/linux/blk_types.h |   1 +
 3 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 6a2f6fc3413e..f228940d6b42 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -19,6 +19,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 #include <linux/kmemleak.h>
+#include <linux/local_lock.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1741,6 +1742,79 @@ void bio_check_pages_dirty(struct bio *bio)
 	schedule_work(&bio_dirty_work);
 }
 
+/*
+ * Infrastructure for deferring bio completions to task-context via a per-CPU
+ * workqueue. Triggered either by the BIO_COMPLETE_IN_TASK bio flag (static
+ * decision at submit time) or by calling bio_complete_in_task() from
+ * bi_end_io() (dynamic decision at completion time).
+ */
+
+struct bio_complete_batch {
+	local_lock_t lock;
+	struct bio_list list;
+	struct delayed_work work;
+	int cpu;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+static struct workqueue_struct *bio_complete_wq;
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct bio_complete_batch *batch =
+		container_of(dw, struct bio_complete_batch, work);
+
+	while (1) {
+		struct bio_list list;
+		struct bio *bio;
+
+		local_lock_irq(&bio_complete_batch.lock);
+		list = batch->list;
+		bio_list_init(&batch->list);
+		local_unlock_irq(&bio_complete_batch.lock);
+
+		if (bio_list_empty(&list))
+			break;
+
+		while ((bio = bio_list_pop(&list)))
+			bio->bi_end_io(bio);
+
+		if (need_resched()) {
+			bool is_empty;
+
+			local_lock_irq(&bio_complete_batch.lock);
+			is_empty = bio_list_empty(&batch->list);
+			local_unlock_irq(&bio_complete_batch.lock);
+			if (!is_empty)
+				mod_delayed_work_on(batch->cpu,
+						    bio_complete_wq,
+						    &batch->work, 0);
+			break;
+		}
+	}
+}
+
+void __bio_complete_in_task(struct bio *bio)
+{
+	struct bio_complete_batch *batch;
+	unsigned long flags;
+	bool was_empty;
+
+	local_lock_irqsave(&bio_complete_batch.lock, flags);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	was_empty = bio_list_empty(&batch->list);
+	bio_list_add(&batch->list, bio);
+	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
+
+	if (was_empty)
+		mod_delayed_work_on(batch->cpu, bio_complete_wq,
+				    &batch->work, 1);
+}
+EXPORT_SYMBOL_GPL(__bio_complete_in_task);
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1815,7 +1889,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
+		__bio_complete_in_task(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -2001,6 +2077,51 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+static int bio_complete_batch_cpu_online(unsigned int cpu)
+{
+	enable_delayed_work(&per_cpu(bio_complete_batch, cpu).work);
+	return 0;
+}
+
+/*
+ * Disable this CPU's delayed work so that it cannot run on an unbound worker
+ * after the CPU is offlined.
+ */
+static int bio_complete_batch_cpu_down_prep(unsigned int cpu)
+{
+	disable_delayed_work_sync(&per_cpu(bio_complete_batch, cpu).work);
+	return 0;
+}
+
+/*
+ * Drain a dead CPU's deferred bio completions. The CPU is dead and the worker
+ * is canceled so no locking is needed.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&batch->list)))
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
+static void __init bio_complete_batch_init(int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+
+	bio_list_init(&batch->list);
+	INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
+	batch->cpu = cpu;
+
+	if (!cpu_online(cpu))
+		disable_delayed_work_sync(&batch->work);
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -2015,6 +2136,30 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i)
+		bio_complete_batch_init(i);
+
+	bio_complete_wq = alloc_workqueue("bio_complete",
+					   WQ_MEM_RECLAIM | WQ_PERCPU, 0);
+	if (!bio_complete_wq)
+		panic("bio: can't allocate bio_complete workqueue\n");
+
+	/*
+	 * bio task-context completion draining on hot-unplugged CPUs:
+	 *
+	 *   1. Stop the per-CPU delayed work while the CPU is still online, so
+	 *      that it cannot run on an unbound worker later.
+	 *   2. Drain leftover bios added between worker disabling and CPU
+	 *      offlining.
+	 */
+	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+				  "block/bio:complete:online",
+				  bio_complete_batch_cpu_online,
+				  bio_complete_batch_cpu_down_prep);
+	cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
+				  "block/bio:complete:dead",
+				  NULL, bio_complete_batch_cpu_dead);
+
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f..501847105aa8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -368,6 +368,38 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/**
+ * bio_in_atomic - check if the current context is unsafe for bio completion
+ *
+ * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
+ * %false when a bio can be safely completed in the current context.
+ */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
+void __bio_complete_in_task(struct bio *bio);
+
+/**
+ * bio_complete_in_task - ensure a bio is completed in preemptible task context
+ * @bio: bio to complete
+ *
+ * If called from non-task context, offload the bio completion to a worker
+ * thread and return %true. Else return %false and do nothing.
+ */
+static inline bool bio_complete_in_task(struct bio *bio)
+{
+	if (!bio_in_atomic())
+		return false;
+	__bio_complete_in_task(bio);
+	return true;
+}
+
 extern void bio_endio(struct bio *);
 
 /**
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..d49d97a050d0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -322,6 +322,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 
-- 
2.53.0

