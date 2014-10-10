Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9D547F63
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B914A8F8059
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id JQkNP46KwiAkelGB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:08 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] block: strict rq_affinity
Date: Fri, 10 Oct 2014 16:23:10 +0200
Message-Id: <1412951028-4085-6-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Christoph Hellwig <hch@infradead.org>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jens Axboe <jaxboe@fusionio.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

From: Dan Williams <dan.j.williams@intel.com>

Some systems benefit from completions always being steered to the strict
requester cpu rather than the looser "per-socket" steering that
blk_cpu_to_group() attempts by default. This is because the first
CPU in the group mask ends up being completely overloaded with work,
while the others (including the original submitter) has power left
to spare.

Allow the strict mode to be set by writing '2' to the sysfs control
file. This is identical to the scheme used for the nomerges file,
where '2' is a more aggressive setting than just being turned on.

echo 2 > /sys/block/<bdev>/queue/rq_affinity

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@purestorage.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 Documentation/block/queue-sysfs.txt | 10 +++++++---
 block/blk-core.c                    |  6 ++----
 block/blk-softirq.c                 | 11 +++++++----
 block/blk-sysfs.c                   | 13 +++++++++----
 include/linux/blkdev.h              |  3 ++-
 5 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index f65274081c8d..d8147b336c35 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -45,9 +45,13 @@ device.
 
 rq_affinity (RW)
 ----------------
-If this option is enabled, the block layer will migrate request completions
-to the CPU that originally submitted the request. For some workloads
-this provides a significant reduction in CPU cycles due to caching effects.
+If this option is '1', the block layer will migrate request completions to the
+cpu "group" that originally submitted the request. For some workloads this
+provides a significant reduction in CPU cycles due to caching effects.
+
+For storage configurations that need to maximize distribution of completion
+processing setting this option to '2' forces the completion to run on the
+requesting cpu (bypassing the "group" aggregation logic).
 
 scheduler (RW)
 --------------
diff --git a/block/blk-core.c b/block/blk-core.c
index a56485292062..b3228255304d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1279,10 +1279,8 @@ get_rq:
 	init_request_from_bio(req, bio);
 
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
-	    bio_flagged(bio, BIO_CPU_AFFINE)) {
-		req->cpu = blk_cpu_to_group(get_cpu());
-		put_cpu();
-	}
+	    bio_flagged(bio, BIO_CPU_AFFINE))
+		req->cpu = smp_processor_id();
 
 	plug = current->plug;
 	if (plug) {
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c21602228..475fab809a80 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -103,22 +103,25 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 
 void __blk_complete_request(struct request *req)
 {
+	int ccpu, cpu, group_cpu = NR_CPUS;
 	struct request_queue *q = req->q;
 	unsigned long flags;
-	int ccpu, cpu, group_cpu;
 
 	BUG_ON(!q->softirq_done_fn);
 
 	local_irq_save(flags);
 	cpu = smp_processor_id();
-	group_cpu = blk_cpu_to_group(cpu);
 
 	/*
 	 * Select completion CPU
 	 */
-	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1)
+	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
 		ccpu = req->cpu;
-	else
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
+			ccpu = blk_cpu_to_group(ccpu);
+			group_cpu = blk_cpu_to_group(cpu);
+		}
+	} else
 		ccpu = cpu;
 
 	if (ccpu == cpu || ccpu == group_cpu) {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index d935bd859c87..0ee17b5e7fb6 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -244,8 +244,9 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
 {
 	bool set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
+	bool force = test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags);
 
-	return queue_var_show(set, page);
+	return queue_var_show(set << force, page);
 }
 
 static ssize_t
@@ -257,10 +258,14 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 
 	ret = queue_var_store(&val, page, count);
 	spin_lock_irq(q->queue_lock);
-	if (val)
+	if (val) {
 		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
-	else
-		queue_flag_clear(QUEUE_FLAG_SAME_COMP,  q);
+		if (val == 2)
+			queue_flag_set(QUEUE_FLAG_SAME_FORCE, q);
+	} else {
+		queue_flag_clear(QUEUE_FLAG_SAME_COMP, q);
+		queue_flag_clear(QUEUE_FLAG_SAME_FORCE, q);
+	}
 	spin_unlock_irq(q->queue_lock);
 #endif
 	return ret;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c0cd9a2f22ef..0e67c45b3bc9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -392,7 +392,7 @@ struct request_queue {
 #define QUEUE_FLAG_ELVSWITCH	6	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		7	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES     8	/* disable merge attempts */
-#define QUEUE_FLAG_SAME_COMP	9	/* force complete on same CPU */
+#define QUEUE_FLAG_SAME_COMP	9	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO     10	/* fake timeout */
 #define QUEUE_FLAG_STACKABLE   11	/* supports request stacking */
 #define QUEUE_FLAG_NONROT      12	/* non-rotational device (SSD) */
@@ -402,6 +402,7 @@ struct request_queue {
 #define QUEUE_FLAG_NOXMERGES   15	/* No extended merges */
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
+#define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
