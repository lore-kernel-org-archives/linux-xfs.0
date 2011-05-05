Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p45CHsI1131184 for <xfs@oss.sgi.com>; Thu, 5 May 2011 07:17:54 -0500
Date: Thu, 5 May 2011 22:21:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110505122117.GB26837@dastard>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110504005736.GA2958@cucamonga.audible.transient.net>
	<20110505002126.GA26797@dastard> <20110505022613.GA26837@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110505022613.GA26837@dastard>
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
To: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>, Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>

On Thu, May 05, 2011 at 12:26:13PM +1000, Dave Chinner wrote:
> On Thu, May 05, 2011 at 10:21:26AM +1000, Dave Chinner wrote:
> > On Wed, May 04, 2011 at 12:57:36AM +0000, Jamie Heilman wrote:
> > > Dave Chinner wrote:
> > > > OK, so the common elements here appears to be root filesystems
> > > > with small log sizes, which means they are tail pushing all the
> > > > time metadata operations are in progress. Definitely seems like a
> > > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > > reproduce this and cook up a patch to fix it.
> > > 
> > > Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
> > > other assorted feedback wrt this issue?  I've had it happen twice now
> > > myself in the past week or so, though I have no reliable reproduction
> > > technique.  Just wondering if more data points will help isolate the
> > > cause, and if so, how to be prepared to get them.
> > > 
> > > For whatever its worth, my last lockup was while running
> > > 2.6.39-rc5-00127-g1be6a1f with a preempt config without cgroups.
> > 
> > Can you all try the patch below? I've managed to trigger a couple of
> > xlog_wait() lockups in some controlled load tests. The lockups don't
> > appear to occur with the following patch to he race condition in
> > the AIL workqueue trigger.
> 
> They are still there, just harder to hit.
> 
> FWIW, I've also discovered that "echo 2 > /proc/sys/vm/drop_caches"
> gets the system moving again because that changes the push target.
> 
> I've found two more bugs, and now my test case is now reliably
> reproducably a 5-10s pause at ~1M created 1byte files and then
> hanging at about 1.25M files. So there's yet another problem lurking
> that I need to get to the bottom of.

Which, of course, was the real regression. The patch below has
survived a couple of hours of testing, which fixes all 4 of the
problems I found. Please test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix race conditions and regressions in AIL pushing

From: Dave Chinner <dchinner@redhat.com>

The recent conversion of the xfsaild functionality to a work queue
introduced a hard-to-hit log space grant hang. There are four
problems being hit.

The first problem is that the use of the XFS_AIL_PUSHING_BIT to
determine whether a push is currently in progress is racy.  When the
AIL push work completes, it checked whether the target changed and
cleared the PUSHING bit to allow a new push to be requeued. The race
condition is as follows:

	Thread 1		push work

	smp_wmb()
				smp_rmb()
				check ailp->xa_target unchanged
	update ailp->xa_target
	test/set PUSHING bit
	does not queue
				clear PUSHING bit
				does not requeue

Now that the push target is updated, new attempts to push the AIL
will not trigger as the push target will be the same, and hence
despite trying to push the AIL we won't ever wake it again.

The fix is to ensure that the AIL push work clears the PUSHING bit
before it checks if the target is unchanged.

As a result, both push triggers operate on the same test/set bit
criteria, so even if we race in the push work and miss the target
update, the thread requesting the push will still set the PUSHING
bit and queue the push work to occur. For safety sake, the same
queue check is done if the push work detects the target change,
though only one of the two will will queue new work due to the use
of test_and_set_bit() checks.

The second problem is a target mismatch between the item pushing
loop and the target itself. The push trigger checks for the target
increasing (i.e. new target > current) while the push loop only
pushes items that have a LSN < current. As a result, we can get the
situation where the push target is X, the items at the tail of the
AIL have LSN X and they don't get pushed. The push work then
completes thinking it is done, and cannot be restarted until the
push target increases to >= X + 1. If the push target then never
increases (because the tail is not moving), then we never run the
push work again and we stall.

The third problem is that updating the push target is not safe on 32
bit machines. We cannot copy a 64 bit LSN without the possibility of
corrupting the result when racing with another updating thread. We
have function to do this update safely without needing to care about
32/64 bit issues - xfs_trans_ail_copy_lsn() - so use that when
updating the AIL push target.

THe final problem, and the ultimate cause of the regression is that
there are two exit paths from the AIL push work. One does the right
thing with clearing the PUSH bit and rechecking the target, while
the other simply returns if the AIL is empty when the push work
starts. This exit path needs to do the same PUSHING bit clearing and
target checking as the normal other "no more work to be done" path.

Note: this needs to be split into 4 patches to push into mainline.
This is an aggregated patch just for testing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index acdb92f..ab0d045 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -368,8 +368,7 @@ xfs_ail_worker(
 		 */
 		xfs_trans_ail_cursor_done(ailp, cur);
 		spin_unlock(&ailp->xa_lock);
-		ailp->xa_last_pushed_lsn = 0;
-		return;
+		goto out_done;
 	}
 
 	XFS_STATS_INC(xs_push_ail);
@@ -387,7 +386,7 @@ xfs_ail_worker(
 	 */
 	lsn = lip->li_lsn;
 	flush_log = stuck = count = 0;
-	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
+	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
 		int	lock_result;
 		/*
 		 * If we can lock the item without sleeping, unlock the AIL
@@ -482,19 +481,24 @@ xfs_ail_worker(
 	/* assume we have more work to do in a short while */
 	tout = 10;
 	if (!count) {
+out_done:
 		/* We're past our target or empty, so idle */
 		ailp->xa_last_pushed_lsn = 0;
 
 		/*
-		 * Check for an updated push target before clearing the
-		 * XFS_AIL_PUSHING_BIT. If the target changed, we've got more
-		 * work to do. Wait a bit longer before starting that work.
+		 * We clear the XFS_AIL_PUSHING_BIT first before checking
+		 * whether the target has changed. If the target has changed,
+		 * this pushes the requeue race directly onto the result of the
+		 * atomic test/set bit, so we are guaranteed that either the
+		 * the pusher that changed the target or ourselves will requeue
+		 * the work (but not both).
 		 */
+		clear_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags);
 		smp_rmb();
-		if (ailp->xa_target == target) {
-			clear_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags);
+		if (ailp->xa_target == target ||
+		    (test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags)))
 			return;
-		}
+
 		tout = 50;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
@@ -553,7 +557,7 @@ xfs_ail_push(
 	 * the XFS_AIL_PUSHING_BIT.
 	 */
 	smp_wmb();
-	ailp->xa_target = threshold_lsn;
+	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
 	if (!test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags))
 		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, 0);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
