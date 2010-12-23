Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN3u323087057 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:56:03 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77582AC017
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:58:02 -0800 (PST)
Subject: [PATCH 2/5] percpu_counter: avoid potential underflow in add_unless_lt
From: Alex Elder <aelder@sgi.com>
Date: Wed, 22 Dec 2010 21:56:27 -0600
Message-ID: <1293076587.2408.431.camel@doink>
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

In __percpu_counter_add_unless_lt(), an assumption is made that
under certain conditions it's possible to determine that an amount
can be safely added to a counter, possibly without having to acquire
the lock.  This assumption is not valid, however.

These lines encode the assumption:
	if (count + amount > threshold + error) {
		__percpu_counter_add(fbc, amount, batch);

Inside __percpu_counter_add(), the addition is performed
without acquiring the lock if the *sum* of the batch size
and the CPU-local delta is within the batch size.  Otherwise
it does the addition after acquiring the lock.

The problem is that *that* sum may actually end up being greater
than the batch size, forcing the addition to be performed under
protection of the lock.  And by the time the lock is acquired, the
value of fbc->count may have been updated such that adding the given
amount allows the result to go negative.

Fix this by open-coding the portion of the __percpu_counter_add()
that avoids the lock.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 lib/percpu_counter.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/lib/percpu_counter.c
===================================================================
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -243,9 +243,14 @@ int __percpu_counter_add_unless_lt(struc
 	 * we can safely add, and might be able to avoid locking.
 	 */
 	if (count + amount > threshold + error) {
-		__percpu_counter_add(fbc, amount, batch);
-		ret = 1;
-		goto out;
+		s32 *pcount = this_cpu_ptr(fbc->counters);
+
+		count = *pcount + amount;
+		if (abs(count) < batch) {
+			*pcount = count;
+			ret = 1;
+			goto out;
+		}
 	}
 
 	/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
