Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEA33DBD7C;
	Thu,  9 Apr 2026 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750586; cv=none; b=bwTFkFet96OKQezBdz+1c75SJD4Lxz/pZg3984jKxDXz6VFZ2uOgKRFpzwuLpuS4HxXqEVWPsLKOrXYAc0/5yRm72w4cmvtNWN0WQi4ykVrsSufL9bdgfVsQhinO3yKt1G7GNamS1MYDmrMnTI1ToHWycDPw8NkIOaBs86TikS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750586; c=relaxed/simple;
	bh=8C+YvCVnj1h+qaRDw3us46NBjE4kdCB2TRbrr+Hct5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hhx7PnZ69sLlFwT3AyIuYi+wxnBrUgJysz4IC3hefebp2WKQH8dREfBugRZRxBSAr7M5DhjOBdvrdADiW0ekYslAr2yNb9iy3Y6o35htg2Qk7CMtOOvtW6dnw80GgSX3tX9H/fr26O+8CEHcLk9FO9Q5fpzVQbnzQxQQ2cEXgBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gh85pBMa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gh85pBMa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h53OigJvhKi2R7WTc8tD2Nme4RfoPqZlyMjNikVjZqA=; b=Gh85pBMata1NecuSQtkzPmgc8E
	y1ebnQvyYW25FfwUI17O4uZoCDE7vls4dhGt96+ueNNXPYmujBBng7gsL0iUV75VIfe8J6vn2aG6a
	ZPAfuTRRfoC17tS3PZ0HbJv1P5BeTKx+sfpGs0L3+tw7U6PGAgrkBmMo7Y4EQLOk/ZGBMAtr48oz1
	ODp7rpGFFHu/QFMmE2Rzpbo44Yj2BbVwHuodmI5KQr7Gywz1TSTAxvyE0uT06c1VVNkVDXeBeHyXX
	NVVPn66SBi1sP/VgWIzRWLYj9yti124GCrwl0cae7PB2PD5mv3sZQTBrA5TeKG2ipRUAbGSMz64gD
	Xxu+2rRw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqO-0000000At2j-3j5h;
	Thu, 09 Apr 2026 16:03:01 +0000
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
Subject: [PATCH 1/8] block: add BIO_COMPLETE_IN_TASK for task-context completion
Date: Thu,  9 Apr 2026 18:02:14 +0200
Message-ID: <20260409160243.1008358-2-hch@lst.de>
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

From: Tal Zussman <tz2294@columbia.edu>

Some bio completion handlers need to run in task context but bio_endio()
can be called from IRQ context (e.g. buffer_head writeback). Add a
BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
task-context completion of their bi_end_io callback.

When bio_endio() sees this flag and is running in non-task context, it
queues the bio to a per-cpu lockless list and schedules a delayed work
item to call bi_end_io() from task context.  The delayed work uses a
1-jiffie delay to allow batches of completions to accumulate before
processing. A CPU hotplug dead callback drains any remaining bios from
the departing CPU's batch.

This will be used to enable RWF_DONTCACHE for block devices, and could
be used for other subsystems like fscrypt that need task-context bio
completion.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c               | 83 ++++++++++++++++++++++++++++++++++++++-
 include/linux/blk_types.h |  7 +++-
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 641ef0928d73..550eb770bfa6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -19,6 +19,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 #include <linux/kmemleak.h>
+#include <linux/llist.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1716,6 +1717,51 @@ void bio_check_pages_dirty(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
+struct bio_complete_batch {
+	struct llist_head list;
+	struct delayed_work work;
+	int cpu;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
+static struct workqueue_struct *bio_complete_wq;
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct bio_complete_batch *batch =
+		container_of(dw, struct bio_complete_batch, work);
+	struct llist_node *node;
+	struct bio *bio, *next;
+
+	do {
+		node = llist_del_all(&batch->list);
+		if (!node)
+			break;
+
+		node = llist_reverse_order(node);
+		llist_for_each_entry_safe(bio, next, node, bi_llist)
+			bio->bi_end_io(bio);
+
+		if (need_resched()) {
+			if (!llist_empty(&batch->list))
+				mod_delayed_work_on(batch->cpu,
+						    bio_complete_wq,
+						    &batch->work, 0);
+			break;
+		}
+	} while (1);
+}
+
+static void bio_queue_completion(struct bio *bio)
+{
+	struct bio_complete_batch *batch = this_cpu_ptr(&bio_complete_batch);
+
+	if (llist_add(&bio->bi_llist, &batch->list))
+		mod_delayed_work_on(batch->cpu, bio_complete_wq,
+				    &batch->work, 1);
+}
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1790,7 +1836,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
+		bio_queue_completion(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -1976,6 +2024,24 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+/*
+ * Drain a dead CPU's deferred bio completions.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct llist_node *node;
+	struct bio *bio, *next;
+
+	node = llist_del_all(&batch->list);
+	node = llist_reverse_order(node);
+	llist_for_each_entry_safe(bio, next, node, bi_llist)
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1990,6 +2056,21 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i) {
+		struct bio_complete_batch *batch =
+			per_cpu_ptr(&bio_complete_batch, i);
+
+		init_llist_head(&batch->list);
+		INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
+		batch->cpu = i;
+	}
+
+	bio_complete_wq = alloc_workqueue("bio_complete", WQ_MEM_RECLAIM, 0);
+	if (!bio_complete_wq)
+		panic("bio: can't allocate bio_complete workqueue\n");
+
+	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
+				NULL, bio_complete_batch_cpu_dead);
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..0b55159d110d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/ktime.h>
 #include <linux/rw_hint.h>
+#include <linux/llist.h>
 
 struct bio_set;
 struct bio;
@@ -208,7 +209,10 @@ typedef unsigned int blk_qc_t;
  * stacking drivers)
  */
 struct bio {
-	struct bio		*bi_next;	/* request queue link */
+	union {
+		struct bio	*bi_next;	/* request queue link */
+		struct llist_node bi_llist;	/* deferred completion */
+	};
 	struct block_device	*bi_bdev;
 	blk_opf_t		bi_opf;		/* bottom bits REQ_OP, top bits
 						 * req_flags.
@@ -322,6 +326,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 
-- 
2.47.3

