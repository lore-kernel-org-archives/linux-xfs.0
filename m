Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C99017F54
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 12:30:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B857AC026
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 10:30:22 -0700 (PDT)
Received: from g1t6214.austin.hp.com (g1t6214.austin.hp.com [15.73.96.122]) by
	cuda.sgi.com with ESMTP id 17ixUAB7vDONYyok (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 10:30:20 -0700 (PDT)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Date: Fri,  2 Oct 2015 13:29:57 -0400
Message-Id: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
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
To: Dave Chinner <david@fromorbit.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Cc: Scott J Norton <scott.norton@hpe.com>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com

In __percpu_counter_compare(), if the current imprecise count is
within (batch*nr_cpus) of the input value to be compared, a call
to percpu_counter_sum() will be made to get the precise count. The
percpu_counter_sum() call, however, can be expensive especially on
large systems where there are a lot of CPUs. Large systems also make
it more likely that percpu_counter_sum() will be called.

The xfs_mod_fdblocks() function calls __percpu_counter_compare()
twice. First to see if a smaller batch size should be used for
__percpu_counter_add() and the second call to compare the actual
size needed. This can potentially lead to 2 calls to the expensive
percpu_counter_sum() function.

This patch added an extra argument to __percpu_counter_compare()
to return the precise count, if computed. The caller will need to
initialize it to an invalid value that it can tell if the precise
count is being returned.

The xfs_mod_fdblocks() function was then modified to use the
precise count for comparison, if returned. Otherwise, it will call
__percpu_counter_compare() the second time.

Running the AIM7 disk workload with XFS filesystem, the jobs/min
on a 40-core 80-thread 4-socket Haswell-EX system increases from
3805k to 4276k (12% increase) with this patch applied. As measured
by the perf tool, the %CPU cycle consumed by __percpu_counter_sum()
decreases from 12.64% to 7.08%.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/xfs/xfs_mount.c             |   17 +++++++++++++----
 include/linux/percpu_counter.h |    9 +++++----
 lib/percpu_counter.c           |   11 ++++++++++-
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..8586b62 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1115,7 +1115,7 @@ xfs_mod_icount(
 	int64_t			delta)
 {
 	__percpu_counter_add(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
-	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
+	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH, NULL) < 0) {
 		ASSERT(0);
 		percpu_counter_add(&mp->m_icount, -delta);
 		return -EINVAL;
@@ -1154,6 +1154,7 @@ xfs_mod_fdblocks(
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	s64			pcount;	/* Precise count */
 
 	if (delta > 0) {
 		/*
@@ -1187,15 +1188,23 @@ xfs_mod_fdblocks(
 	 * then make everything serialise as we are real close to
 	 * ENOSPC.
 	 */
+	pcount = -1;
 	if (__percpu_counter_compare(&mp->m_fdblocks, 2 * XFS_FDBLOCKS_BATCH,
-				     XFS_FDBLOCKS_BATCH) < 0)
+				     XFS_FDBLOCKS_BATCH, &pcount) < 0)
 		batch = 1;
 	else
 		batch = XFS_FDBLOCKS_BATCH;
 
 	__percpu_counter_add(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, XFS_ALLOC_SET_ASIDE(mp),
-				     XFS_FDBLOCKS_BATCH) >= 0) {
+	if (pcount >= 0) {
+		/*
+		 * No need to call __percpu_counter_compare() again if the
+		 * precise count has been computed.
+		 */
+		if (pcount + delta >= XFS_ALLOC_SET_ASIDE(mp))
+			return 0;	/* we have space */
+	} else if (__percpu_counter_compare(&mp->m_fdblocks,
+		   XFS_ALLOC_SET_ASIDE(mp), XFS_FDBLOCKS_BATCH, NULL) >= 0) {
 		/* we had space! */
 		return 0;
 	}
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 84a1094..4690143 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -41,11 +41,12 @@ void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
-int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch);
+int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch,
+			     s64 *pcnt);
 
 static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 {
-	return __percpu_counter_compare(fbc, rhs, percpu_counter_batch);
+	return __percpu_counter_compare(fbc, rhs, percpu_counter_batch, NULL);
 }
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
@@ -121,8 +122,8 @@ static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 		return 0;
 }
 
-static inline int
-__percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
+static inline int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs,
+					   s32 batch, s64 *pcnt))
 {
 	return percpu_counter_compare(fbc, rhs);
 }
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index f051d69..37e253c 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -196,8 +196,14 @@ static int percpu_counter_hotcpu_callback(struct notifier_block *nb,
 /*
  * Compare counter against given value.
  * Return 1 if greater, 0 if equal and -1 if less
+ *
+ * The precise count, if computed, will be returned in the location pointed
+ * to by pcnt. The *pcnt value should be properly initialized before calling
+ * this function so that the caller can easily distinguish if the count has
+ * been returned.
  */
-int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
+int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch,
+			     s64 *pcnt)
 {
 	s64	count;
 
@@ -211,6 +217,9 @@ int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
 	}
 	/* Need to use precise count */
 	count = percpu_counter_sum(fbc);
+
+	if (pcnt)
+		*pcnt = count;	/* Store the precise count */
 	if (count > rhs)
 		return 1;
 	else if (count < rhs)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
