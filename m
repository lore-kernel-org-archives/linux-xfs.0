Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB7A77F3F
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 19:43:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68D6FAC004
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 17:43:04 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	1DsMh8MGxEuqMHlZ for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 17:42:59 -0800 (PST)
Date: Thu, 21 Nov 2013 12:42:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent spurious "head behind tail" warnings
Message-ID: <20131121014255.GZ6188@dastard>
References: <1384900659-22215-1-git-send-email-david@fromorbit.com>
	<528BEF71.1000607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528BEF71.1000607@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 19, 2013 at 05:08:33PM -0600, Mark Tinguely wrote:
> On 11/19/13 16:37, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >When xlog_space_left() cracks the grant head and the log tail, it
> >does so without locking to synchronise the sampling of the
> >variables. It samples the grant head first, so if there is a delay
> >before it smaples the log tail, there is a window where the log tail
> >could have moved onwards and be moved past the sampled value of the
> >grant head. This then leads to the "xlog_space_left: head behind
> >tail" warning message.
> >
> >To avoid spurious output in this situation, swap the order in which
> >the variables are cracked. This means that the head may grant head
> >may move if there is a delay, but the log tail will be stable, hence
> >ensure the tail does not jump the head accidentally.
> >
> >While this avoids the spurious head behind tail problem, it
> >introduces the opposite problem - the head can move more than a full
> >cycle past the tail. The code already handles this case by
> >indicating that the log is full (i.e. zero space available) but
> >that's still (generally) a spurious situation.
> >
> >Hence, if we detect that the head is more than a cycle ahead of the
> >tail or the head is behind the tail, start the calculation again by
> >resampling the variables and trying again. If we get too many
> >resamples, then throw a warning and return a full or empty log
> >appropriately.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> I am still getting the debug message:
> 
>   xlog_verify_grant_tail: space > BBTOB(tail_blocks)

I'm not sure why that is relevant to this patch - it doesn't touch
xlog_verify_grant_tail(), nor does it change the functioning of the
code except to remove false positive warnings.

Further, the comment about xlog_verify_grant_tail() says:

  * This check is run unlocked, so can give false positives. 

That's exactly what this patch addresses for xlog_space_left() -
it prevents false positives when it is run unlocked. So we could do
exactly the same thing to xlog_verify_grant_tail() as well. Patch
attached below.

> This is a real over grant.

Evidence, please.

> It has been a while since I did all the
> tests, but basically the only way to stop it is to have a lock
> between checking for xlog_space_left() and actually reserving the
> space.

Yes, so you demonstrated, but that change also completely destroyed
scalability of the transaction subsystem in the process, hence is a
non-starter, especially just to silence a debug-only false positive.
IOWs, there was no evidence provided that the message was the result
of an actual leak (i.e. a problem in the algorithm) rather than it
being a false positive.

The first step in determining if we really have a problem here is to
cut the false positive rate, and that's exactly what I'm addressing
here. Hence when we see this warning being emitted we will have a
much higher confidence that it is a real problem and not a false
positive.

> I am not a fan of another band-aid on a problem that is caused
> because we are granting space without locks.

Lockless algorithms *by their very nature* involve verifying what
was grabbed without a lock is valid before using it. It's a
fundamental principle underlying lockless algorithms, whether they
be lockless due to use of cmpxchg (like the log grant code) or RCU
(like the xfs inode cache) or just plain old memory barriers to
enforce memory access ordering.

Just because the original code didn't do this doesn't mean doing it
now is a band-aid. I understand lockless algorithms a whole lot
better than I did 3 years ago when I wrote the original algorithm,
and as such can see things I didn't clearly understand back then.
Indeed, the comments indicate that I knew there were problems (i.e.
false positive detection issues), but didn't understand them well
enough to be able to mitigate them. I certainly understand them well
enough now, so I'd hardly call mitigating known issues like this a
band-aid.

Looking at the bigger picture, we're adding lockless algorithms
rapidly throughout the kernel.  Hence it's critical that kernel
developers understand how lockless algorithms work and realise that
locks are no longer the preferred solution to the scalability
problem. If a lockless algorithm is broken, then we need to
understand exactly how it is broken, determine whether it can be
fixed (e.g. is it just missing a critical memory barrier?), and as
a last resort, if it needs to be replaced then we need to design
a new algorithm that scales equivalently well.

We need to start by killing as many false positives the lockless
algorithm throws out and see what remains. We have no real evidence
that there are fundamental problems with the lockless algorithm, so
let's address the issues we know about first and go from there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: prevent spurious "space > BBTOB(tail_blocks)" warnings

When xlog_verify_grant_tail() cracks the grant head and the log
tail, it does so without locking to synchronise the sampling of the
variables. It samples the grant head first, so if there is a delay
before it samples the log tail, there is a window where the log tail
could have moved onwards and be moved past the sampled value of the
grant head. This then leads to the "xlog_verify_grant_tail: space >
BBTOB(tail_blocks)" warning message.

To avoid spurious output in this situation, swap the order in which
the variables are cracked. This means that the head may grant head
may move if there is a delay, but the log tail will be stable, hence
ensure the tail does not jump the head accidentally.

While this avoids the spurious head behind tail problem, it
introduces the opposite problem - the head can move more than a full
cycle past the tail.

Hence, if we detect that the head is more than a cycle ahead of the
tail or the head is behind the tail, start the calculation again by
resampling the variables and trying again. If we get too many
resamples, then throw a warning.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_log.c | 82 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0cfcc20..6857e09 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3682,26 +3682,72 @@ STATIC void
 xlog_verify_grant_tail(
 	struct xlog	*log)
 {
-	int		tail_cycle, tail_blocks;
-	int		cycle, space;
-
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &space);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
-	if (tail_cycle != cycle) {
-		if (cycle - 1 != tail_cycle &&
-		    !(log->l_flags & XLOG_TAIL_WARN)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: cycle - 1 != tail_cycle", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
-		}
+	int		tail_cycle;
+	int		tail_blocks;
+	int		head_cycle;
+	int		head_bytes;
+	int		retries = 0;
+#define XLOG_VERIFY_MAX_RETRIES	5
 
-		if (space > BBTOB(tail_blocks) &&
-		    !(log->l_flags & XLOG_TAIL_WARN)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: space > BBTOB(tail_blocks)", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
-		}
+
+	/*
+	 * If we've already detected an problem here, don't bother checking
+	 * again.
+	 */
+	if (log->l_flags & XLOG_TAIL_WARN)
+		return;
+	do {
+		/*
+		 * sample tail before head to avoid spurious warnings due to
+		 * racing tail updates. We dump a memory barrier here to make
+		 * sure we pick up the latest values that have been written by
+		 * other threads each time through.
+		 */
+		smp_mb();
+		xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle,
+				      &tail_blocks);
+		xlog_crack_grant_head(&log->l_write_head.grant, &head_cycle,
+				      &head_bytes);
+
+		/*
+		 * if the cycles are the same, the head and tail can't be
+		 * overlapping, so everything is ok and we are done.
+		 */
+		if (tail_cycle == head_cycle)
+			return;
+
+		/*
+		 * if the tail is on the previous cycle to the head and the head
+		 * is before the tail, then all is good.
+		 */
+		if (tail_cycle == head_cycle - 1 &&
+		    BBTOB(tail_blocks) >= head_bytes)
+			return;
+
+		/*
+		 * Cycles don't match or the head overlapped the tail.
+		 * Invalid, so let's go around again and resample to ensure this
+		 * isn't a false positive.
+		 */
+	} while (retries++ < XLOG_VERIFY_MAX_RETRIES);
+
+	/*
+	 * OK, we're in trouble now - the head and tail are out of sync. Time to
+	 * issue a warning about it
+	 */
+	if (head_cycle - 1 != tail_cycle) {
+		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
+			"%s: head cycle - 1 != tail_cycle (0x%x/0x%x)",
+			      __func__, head_cycle, tail_cycle);
+	}
+
+	if (head_bytes > BBTOB(tail_blocks)) {
+		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
+			"%s: head_bytes > BBTOB(tail_blocks) (0x%x/0x%x)",
+			      __func__, head_bytes, BBTOB(tail_blocks));
 	}
+
+	log->l_flags |= XLOG_TAIL_WARN;
 }
 
 /* check if it will fit */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
