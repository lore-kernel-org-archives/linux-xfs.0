Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN3u4iB087069 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:56:04 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3AC05AC016
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:58:03 -0800 (PST)
Subject: [PATCH 5/5] percpu_counter: only disable preemption if needed in
	add_unless_lt()
From: Alex Elder <aelder@sgi.com>
Date: Wed, 22 Dec 2010 21:56:42 -0600
Message-ID: <1293076602.2408.434.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In __percpu_counter_add_unless_lt() we don't need to disable
preemption unless we're manipulating a per-cpu variable.  That only
happens in a limited case, so narrow the scope of that preemption to
surround that case.  This makes the "out" label rather unnecessary,
so replace a couple "goto out" calls to just return.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 lib/percpu_counter.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Index: b/lib/percpu_counter.c
===================================================================
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -232,8 +232,6 @@ int __percpu_counter_add_unless_lt(struc
 	int	cpu;
 	int	ret = -1;
 
-	preempt_disable();
-
 	/*
 	 * Check to see if rough count will be sufficient for
 	 * comparison.  First, if the upper bound is too low,
@@ -241,7 +239,7 @@ int __percpu_counter_add_unless_lt(struc
 	 */
 	count = percpu_counter_read(fbc);
 	if (count + error + amount < threshold)
-		goto out;
+		return -1;
 
 	/*
 	 * Next, if the lower bound is above the threshold, we can
@@ -251,12 +249,15 @@ int __percpu_counter_add_unless_lt(struc
 	if (count - error + amount > threshold) {
 		s32 *pcount = this_cpu_ptr(fbc->counters);
 
+		preempt_disable();
+		pcount = this_cpu_ptr(fbc->counters);
 		count = *pcount + amount;
 		if (abs(count) < batch) {
 			*pcount = count;
-			ret = 1;
-			goto out;
+			preempt_enable();
+			return 1;
 		}
+		preempt_enable();
 	}
 
 	/*
@@ -281,10 +282,9 @@ int __percpu_counter_add_unless_lt(struc
 	}
 
 	/*
-	 * Result is withing the error margin. Run an open-coded sum of the
-	 * per-cpu counters to get the exact value at this point in time,
-	 * and if the result greater than the threshold, add the amount to
-	 * the global counter.
+	 * Now add in all the per-cpu counters to compute the exact
+	 * value at this point in time, and if the result greater
+	 * than the threshold, add the amount to the global counter.
 	 */
 	count = fbc->count;
 	for_each_online_cpu(cpu) {
@@ -301,8 +301,7 @@ int __percpu_counter_add_unless_lt(struc
 	}
 out_unlock:
 	spin_unlock(&fbc->lock);
-out:
-	preempt_enable();
+
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_add_unless_lt);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
