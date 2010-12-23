Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN3u3ve087055 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:56:03 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26FFDAC016
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:58:02 -0800 (PST)
Subject: [PATCH 3/5] percpu_counter: fix error bound used in add_unless_lt
	function
From: Alex Elder <aelder@sgi.com>
Date: Wed, 22 Dec 2010 21:56:21 -0600
Message-ID: <1293076581.2408.430.camel@doink>
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

The __percpu_counter_add_unless_lt() function is designed to safely
implement a conditional add operation on a percpu_counter,
succeeding only if the result of the addition would produce a
non-negative result.  It goes to great lengths to avoid the need to
take a spinlock(), but it currently is much more conservative than
it has to be.

The change below is simple, but I feel I need to provide a
foundation of some background to argue that it is correct.

The instantaneous "correct" value of a percpu_counter is the sum of
its "aggregate" count value and all of its per-cpu "delta" counter
values.  This sum, as well as all the counts that comprise it, are
all signed values.  A global batch size, percpu_counter_batch,
is maintained and used to limit how out-of-date the aggregate
value is with the correct value of the percpu_counter.


The aggregate count value is only updated under protection of a
spinlock, and in several places taking the spinlock is avoided
by understanding something about the bounds of what the per-cpu
deltas could contribute to the percpu_counter's value.

The possible range of the correct value of a percpu_counter
can be represented as:
    percpu_counter->count +/- error
where "error" is the current sum of all per-cpu deltas.

The per-cpu delta values are only ever modified in two ways: they
are either zeroed (in percpu_counter_set(), __percpu_counter_add(),
and percpu_counter_hotcpu_callback()), or they are assigned a value
whose absolute value is no more than the batch size (in
__percpu_counter_add()).  Therefore, each per-cpu delta value
contributes no more than +/- the batch size to the value
of the percpu_counter.

And since at most num_online_cpus() deltas are maintained, the
maximum (absolute) value of "error" is:
    num_online_cpus() * percpu_counter_batch

In other words, the correct value of a percpu_counter can be
described as within this range:

    percpu_counter->count +/- num_online_cpus() * percpu_counter_batch

In __percpu_counter_add_unless_lt(), error is computed to
be twice the size it needs to be, and this change fixes that.

While we're at it, tweak percpu_counter_compare() so it uses
a local variable "error" that serves the same purpose as its
counterpart in __percpu_counter_add_unless_lt().

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 lib/percpu_counter.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/lib/percpu_counter.c
===================================================================
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -192,10 +192,11 @@ static int __cpuinit percpu_counter_hotc
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 {
 	s64	count;
+	s64	error = percpu_counter_batch * num_online_cpus();
 
 	count = percpu_counter_read(fbc);
 	/* Check to see if rough count will be sufficient for comparison */
-	if (abs(count - rhs) > percpu_counter_batch * num_online_cpus()) {
+	if (abs(count - rhs) > error) {
 		if (count > rhs)
 			return 1;
 		return -1;
@@ -227,7 +228,7 @@ int __percpu_counter_add_unless_lt(struc
 						s64 threshold, s32 batch)
 {
 	s64	count;
-	s64	error = 2 * batch * num_online_cpus();
+	s64	error = batch * num_online_cpus();
 	int	cpu;
 	int	ret = -1;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
