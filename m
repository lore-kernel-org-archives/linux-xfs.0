Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8674C375AAB;
	Thu,  9 Apr 2026 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750655; cv=none; b=RmlLY9KtMtZpK7MPSdmwWkuAc347wXEkXaoquCRU11trd2RZibyP7RM2rWGwn227bkwpw64x/X7ToZRtbE3UukPVPTxLljJHnFv08MRfzTAMZEfyZ3w32NZHGW2mo08QnJgg0kv+sO7Vt3WclzLOis/JOipH9dKWtuC6pWVkCGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750655; c=relaxed/simple;
	bh=wIl9V5GGCJCkRrsaF8OpOxK5GGOnJQSmPCFqZEJka9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etSVndzTafIi/30ETizlyG2LblzrKlmy8XEJ59mYg2gG/heTkmfF0uALAmteGROK3mP68vxbAuWY32DWw1D8dHyzS8QgwyV7OhB5RYOC3ysyw5QWRIC6psJrYpn3w/wtCV26LJ/oyJpKeTWZ6Y7m2nySCBKu/yvINxw9u3yxPUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nIzszVk5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nIzszVk5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Qe5mnGzEB/wWBOUGDmubvFkmhKAHTYP67dtOsLhdgJI=; b=nIzszVk5F/SLjplG6aMsYgl9n8
	coxGaRbHTbaQHQ81UFEVQMA8CaN/uuOWbPLlgU5Sw5BfWk4MNBbgKG2DJNXhvJAlwOqQ1eaZ2r4si
	jW0Hh7ufGU7cZBohm0ayLl2aYPLfAFxsUOSzIhTVu6YnkvQ73VNgB+gLr5tS86C985EzbGZ4Ka5C/
	YAov2SC0M4mFWZha1SkPprrz6kK7vc4GQavDpHnKoKJZd15YJfoy8sU97IW/6DSJPmwErm+wPn2/j
	q7PnDzsP4c8aw0EmXP3/PveiQOxOHBkYGfQ6pPH+V8MAnsneZccORuYJ8iJQB4/TwfOCIskH4qdHg
	vygsLNGQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArrS-0000000At8n-1mov;
	Thu, 09 Apr 2026 16:04:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion support
Date: Thu,  9 Apr 2026 18:02:21 +0200
Message-ID: <20260409160243.1008358-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
option") explains why workqueue aren't great for low-latency completion
handling.  Switch to a per-cpu kthread to handle it instead.  This code
is based on the erofs code in the above commit, but further simplified
by directly using a kthread instead of a kthread_work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 117 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 65 insertions(+), 52 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 88d191455762..6a993fb129a0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -19,7 +19,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 #include <linux/kmemleak.h>
-#include <linux/llist.h>
+#include <linux/freezer.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1718,51 +1718,83 @@ void bio_check_pages_dirty(struct bio *bio)
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
 struct bio_complete_batch {
-	struct llist_head list;
-	struct delayed_work work;
-	int cpu;
+	spinlock_t lock;
+	struct bio_list bios;
+	struct task_struct *worker;
 };
 
 static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
-static struct workqueue_struct *bio_complete_wq;
 
-static void bio_complete_work_fn(struct work_struct *w)
+static bool bio_try_complete_batch(struct bio_complete_batch *batch)
 {
-	struct delayed_work *dw = to_delayed_work(w);
-	struct bio_complete_batch *batch =
-		container_of(dw, struct bio_complete_batch, work);
-	struct llist_node *node;
-	struct bio *bio, *next;
+	struct bio_list bios;
+	unsigned long flags;
+	struct bio *bio;
 
-	do {
-		node = llist_del_all(&batch->list);
-		if (!node)
-			break;
+	spin_lock_irqsave(&batch->lock, flags);
+	bios = batch->bios;
+	bio_list_init(&batch->bios);
+	spin_unlock_irqrestore(&batch->lock, flags);
 
-		node = llist_reverse_order(node);
-		llist_for_each_entry_safe(bio, next, node, bi_llist)
-			bio->bi_end_io(bio);
+	if (bio_list_empty(&bios))
+		return false;
 
-		if (need_resched()) {
-			if (!llist_empty(&batch->list))
-				mod_delayed_work_on(batch->cpu,
-						    bio_complete_wq,
-						    &batch->work, 0);
-			break;
-		}
-	} while (1);
+	__set_current_state(TASK_RUNNING);
+	while ((bio = bio_list_pop(&bios)))
+		bio->bi_end_io(bio);
+	return true;
+}
+
+static int bio_complete_thread(void *private)
+{
+	struct bio_complete_batch *batch = private;
+
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!bio_try_complete_batch(batch))
+			schedule();
+	}
+
+	return 0;
 }
 
 void __bio_complete_in_task(struct bio *bio)
 {
-	struct bio_complete_batch *batch = this_cpu_ptr(&bio_complete_batch);
+	struct bio_complete_batch *batch;
+	unsigned long flags;
+	bool wake;
+
+	get_cpu();
+	batch = this_cpu_ptr(&bio_complete_batch);
+	spin_lock_irqsave(&batch->lock, flags);
+	wake = bio_list_empty(&batch->bios);
+	bio_list_add(&batch->bios, bio);
+	spin_unlock_irqrestore(&batch->lock, flags);
+	put_cpu();
 
-	if (llist_add(&bio->bi_llist, &batch->list))
-		mod_delayed_work_on(batch->cpu, bio_complete_wq,
-				    &batch->work, 1);
+	if (wake)
+		wake_up_process(batch->worker);
 }
 EXPORT_SYMBOL_GPL(__bio_complete_in_task);
 
+static void __init bio_complete_batch_init(int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct task_struct *worker;
+
+	worker = kthread_create_on_cpu(bio_complete_thread,
+			per_cpu_ptr(&bio_complete_batch, cpu),
+			cpu, "bio_worker/%u");
+	if (IS_ERR(worker))
+		panic("bio: can't create kthread_work");
+	sched_set_fifo_low(worker);
+
+	spin_lock_init(&batch->lock);
+	bio_list_init(&batch->bios);
+	batch->worker = worker;
+}
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -2028,16 +2060,7 @@ EXPORT_SYMBOL(bioset_init);
  */
 static int bio_complete_batch_cpu_dead(unsigned int cpu)
 {
-	struct bio_complete_batch *batch =
-		per_cpu_ptr(&bio_complete_batch, cpu);
-	struct llist_node *node;
-	struct bio *bio, *next;
-
-	node = llist_del_all(&batch->list);
-	node = llist_reverse_order(node);
-	llist_for_each_entry_safe(bio, next, node, bi_llist)
-		bio->bi_end_io(bio);
-
+	bio_try_complete_batch(per_cpu_ptr(&bio_complete_batch, cpu));
 	return 0;
 }
 
@@ -2055,18 +2078,8 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
-	for_each_possible_cpu(i) {
-		struct bio_complete_batch *batch =
-			per_cpu_ptr(&bio_complete_batch, i);
-
-		init_llist_head(&batch->list);
-		INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
-		batch->cpu = i;
-	}
-
-	bio_complete_wq = alloc_workqueue("bio_complete", WQ_MEM_RECLAIM, 0);
-	if (!bio_complete_wq)
-		panic("bio: can't allocate bio_complete workqueue\n");
+	for_each_possible_cpu(i)
+		bio_complete_batch_init(i);
 
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
 				NULL, bio_complete_batch_cpu_dead);
-- 
2.47.3

