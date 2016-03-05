Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6FA87CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 20:52:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E4958F8039
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:52:06 -0800 (PST)
Received: from g1t6220.austin.hp.com (g1t6220.austin.hp.com [15.73.96.84]) by
	cuda.sgi.com with ESMTP id qBx393gMBjT0043W (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 18:52:03 -0800 (PST)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH 1/2] percpu_counter: Allow falling back to global counter
	on large system
Date: Fri,  4 Mar 2016 21:51:38 -0500
Message-Id: <1457146299-1601-2-git-send-email-Waiman.Long@hpe.com>
In-Reply-To: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
References: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
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
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Scott J Norton <scott.norton@hp.com>, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, Douglas Hatch <doug.hatch@hp.com>

Per-cpu counters are used in quite a number of places within
the kernel.  On large system with a lot of CPUs, however, doing a
percpu_counter_sum() can be very expensive as nr_cpu cachelines will
need to be read. In __percpu_counter_compare(), the chance of calling
percpu_counter_sum() also increases with increasing number of CPUs
if the global counter value is relatively small.

On large system, using a global counter with lock may actually be
faster than doing a percpu_counter_sum() which can be frequently
called from __percpu_counter_compare().

This patch provides a mechanism to selectively degenerate per-cpu
counters to global counters at per-cpu counter initialization time. The
following new API is added:

  percpu_counter_set_limit(struct percpu_counter *fbc,
                           u32 percpu_limit)

The function should be called after percpu_counter_set(). It will
compare the total limit (nr_cpu * percpu_limit) against the current
counter value.  If the limit is not smaller, it will disable per-cpu
counter and use only the global counter instead. At run time, when
the counter value grows past the total limit, per-cpu counter will
be enabled again.

Runtime disabling of per-cpu counters, however, is not currently
supported as it will slow down the per-cpu fast path.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 include/linux/percpu_counter.h |   10 +++++
 lib/percpu_counter.c           |   72 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 1 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 84a1094..04a3783 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -16,8 +16,14 @@
 
 #ifdef CONFIG_SMP
 
+/*
+ * The per-cpu counter will be degenerated into a global counter when limit
+ * is set at initialization time. It will change back to a real per-cpu
+ * counter once the count exceed the given limit.
+ */
 struct percpu_counter {
 	raw_spinlock_t lock;
+	u32 limit;
 	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
@@ -42,6 +48,7 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch);
+void percpu_counter_set_limit(struct percpu_counter *fbc, u32 percpu_limit);
 
 static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 {
@@ -170,6 +177,9 @@ static inline int percpu_counter_initialized(struct percpu_counter *fbc)
 	return 1;
 }
 
+static inline void percpu_counter_set_limit(struct percpu_counter *fbc,
+					    u32 percpu_limit) { }
+
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index f051d69..f101c06 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -75,11 +75,25 @@ EXPORT_SYMBOL(percpu_counter_set);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	unsigned long flags;
+
+	if (fbc->limit) {
+		raw_spin_lock_irqsave(&fbc->lock, flags);
+		if (unlikely(!fbc->limit)) {
+			raw_spin_unlock_irqrestore(&fbc->lock, flags);
+			goto percpu_add;
+		}
+		fbc->count += amount;
+		if (abs(fbc->count) > fbc->limit)
+			fbc->limit = 0;	/* Revert back to per-cpu counter */
 
+		raw_spin_unlock_irqrestore(&fbc->lock, flags);
+		return;
+	}
+percpu_add:
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		unsigned long flags;
 		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
 		__this_cpu_sub(*fbc->counters, count - amount);
@@ -94,6 +108,8 @@ EXPORT_SYMBOL(__percpu_counter_add);
 /*
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
+ *
+ * If a limit is set, the count can be returned directly without locking.
  */
 s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
@@ -101,6 +117,9 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	int cpu;
 	unsigned long flags;
 
+	if (READ_ONCE(fbc->limit))
+		return READ_ONCE(fbc->count);
+
 	raw_spin_lock_irqsave(&fbc->lock, flags);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
@@ -120,6 +139,7 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount, gfp_t gfp,
 	raw_spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
+	fbc->limit = 0;
 	fbc->counters = alloc_percpu_gfp(s32, gfp);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -202,6 +222,9 @@ int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
 	s64	count;
 
 	count = percpu_counter_read(fbc);
+	if (READ_ONCE(fbc->limit))
+		goto compare;
+
 	/* Check to see if rough count will be sufficient for comparison */
 	if (abs(count - rhs) > (batch * num_online_cpus())) {
 		if (count > rhs)
@@ -211,6 +234,7 @@ int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
 	}
 	/* Need to use precise count */
 	count = percpu_counter_sum(fbc);
+compare:
 	if (count > rhs)
 		return 1;
 	else if (count < rhs)
@@ -220,6 +244,52 @@ int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
 }
 EXPORT_SYMBOL(__percpu_counter_compare);
 
+/*
+ * Set the limit if the count is less than the given per-cpu limit * # of cpus.
+ *
+ * This function should only be called at initialization time right after
+ * percpu_counter_set(). Limit will only be set if there is more than
+ * 32 cpus in the system and the current counter value is not bigger than
+ * the limit. Once it is set, it can be cleared as soon as the counter
+ * value exceeds the given limit and real per-cpu counters are used again.
+ * However, switching from per-cpu counters back to global counter is not
+ * currently supported as that will slow down the per-cpu counter fastpath.
+ *
+ * The magic number 32 is chosen to be a compromise between the cost of
+ * reading all the per-cpu counters and that of locking. It can be changed
+ * if there is a better value.
+ */
+#define PERCPU_SET_LIMIT_CPU_THRESHOLD	32
+void percpu_counter_set_limit(struct percpu_counter *fbc, u32 percpu_limit)
+{
+	unsigned long flags;
+	int nrcpus = num_possible_cpus();
+	u32 limit;
+
+	if (nrcpus <= PERCPU_SET_LIMIT_CPU_THRESHOLD)
+		return;
+
+	if (!fbc->count) {
+		WARN(1, "percpu_counter_set_limit() called without an initial counter value!\n");
+		return;
+	}
+	/*
+	 * Use default batch size if the given percpu limit is 0.
+	 */
+	if (!percpu_limit)
+		percpu_limit = percpu_counter_batch;
+	limit = percpu_limit * nrcpus;
+
+	/*
+	 * Limit will not be set if the count is large enough
+	 */
+	raw_spin_lock_irqsave(&fbc->lock, flags);
+	if (abs(fbc->count) <= limit)
+		fbc->limit = limit;
+	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+}
+EXPORT_SYMBOL(percpu_counter_set_limit);
+
 static int __init percpu_counter_startup(void)
 {
 	compute_batch_value();
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
