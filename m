Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN3u3m9087059 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:56:04 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CAC84AC009
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:58:02 -0800 (PST)
Subject: [PATCH 4/5] percpu_counter: tie error bounds more obviously to
	count values
From: Alex Elder <aelder@sgi.com>
Date: Wed, 22 Dec 2010 21:56:38 -0600
Message-ID: <1293076598.2408.433.camel@doink>
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
To: XFS Mailing List <xfs@oss.sgi.com>

This change simply moves around the computed error bound used
in a few spots so it is more closely associated with the
count value.  This is based on this interpretation of the
correct value of of a percpu_counter:
    percpu_counter->count +/- error

So when thinking about the code, it is useful to think of
(count + error) or (count - error) to represent an upper
or lower bound of the percpu_counter's value.  And this
change simply moves things around to match that way of
thinking.

Doing this made me realize there's another optimization
to be made--namely skipping the per-cpu sum if after
taking the lock we know the result will be below the
threshold.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 lib/percpu_counter.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

Index: b/lib/percpu_counter.c
===================================================================
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -234,16 +234,21 @@ int __percpu_counter_add_unless_lt(struc
 
 	preempt_disable();
 
-	/* Check to see if rough count will be sufficient for comparison */
+	/*
+	 * Check to see if rough count will be sufficient for
+	 * comparison.  First, if the upper bound is too low,
+	 * we're done.
+	 */
 	count = percpu_counter_read(fbc);
-	if (count + amount < threshold - error)
+	if (count + error + amount < threshold)
 		goto out;
 
 	/*
-	 * If the updated counter will be over the threshold we know
-	 * we can safely add, and might be able to avoid locking.
+	 * Next, if the lower bound is above the threshold, we can
+	 * safely add the amount.  See if we can do so without
+	 * locking.
 	 */
-	if (count + amount > threshold + error) {
+	if (count - error + amount > threshold) {
 		s32 *pcount = this_cpu_ptr(fbc->counters);
 
 		count = *pcount + amount;
@@ -255,12 +260,21 @@ int __percpu_counter_add_unless_lt(struc
 	}
 
 	/*
-	 * If the result is over the error threshold, we can just add it
-	 * into the global counter ignoring what is in the per-cpu counters
-	 * as they will not change the result of the calculation.
+	 * We're within the error margin, so we need to be more
+	 * precise.  Take the lock, get the current count value, and
+	 * check once more whether the result will be outside the
+	 * error threshold.
+	 *
+	 * If we find we can safely add, just add the amount into
+	 * the global counter ignoring what is in the per-cpu
+	 * counters as they will not change the result of the
+	 * calculation.
 	 */
 	spin_lock(&fbc->lock);
-	if (fbc->count + amount > threshold + error) {
+	if (fbc->count + error + amount < threshold)
+		goto out_unlock;
+
+	if (fbc->count - error + amount > threshold) {
 		fbc->count += amount;
 		ret = 1;
 		goto out_unlock;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
