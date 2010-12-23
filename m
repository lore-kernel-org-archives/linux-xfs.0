Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN3u1ML087034 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:56:01 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8625AAC016
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:58:00 -0800 (PST)
Subject: [PATCH 1/5] percpu_counter: fix test in
	__percpu_counter_add_unless_lt()
From: Alex Elder <aelder@sgi.com>
Date: Wed, 22 Dec 2010 21:56:15 -0600
Message-ID: <1293076575.2408.425.camel@doink>
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

In __percpu_counter_add_unless_lt(), there is a test to see if
a call to __percpu_counter_add() can be made, knowing the result
will not be less than the given threshhold and the called function
will do the addition without taking a lock.

Unfortunately, it is using the wrong value in its comparison--the
amount to add is not properly being taken into account.  As a
result, __percpu_counter_add() could end up adding a value when it
should not.  And even if the result will be non-negative, the called
function may take the lock anyway because it does so if the *sum* of
the (percpu) delta count and the given amount (and not just the amount
alone) is greater than the batch size (or less than its negative).

Fix the comparison, and since it __percpu_counter_add() will do
the right thing (and might lock anyway), just call it regardless
of what amount is getting added.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 lib/percpu_counter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/lib/percpu_counter.c
===================================================================
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -239,10 +239,10 @@ int __percpu_counter_add_unless_lt(struc
 		goto out;
 
 	/*
-	 * If the counter is over the threshold and the change is less than the
-	 * batch size, we might be able to avoid locking.
+	 * If the updated counter will be over the threshold we know
+	 * we can safely add, and might be able to avoid locking.
 	 */
-	if (count > threshold + error && abs(amount) < batch) {
+	if (count + amount > threshold + error) {
 		__percpu_counter_add(fbc, amount, batch);
 		ret = 1;
 		goto out;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
