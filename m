Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p450Hr5E103014 for <xfs@oss.sgi.com>; Wed, 4 May 2011 19:17:54 -0500
Date: Thu, 5 May 2011 10:21:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110505002126.GA26797@dastard>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110504005736.GA2958@cucamonga.audible.transient.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110504005736.GA2958@cucamonga.audible.transient.net>
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

On Wed, May 04, 2011 at 12:57:36AM +0000, Jamie Heilman wrote:
> Dave Chinner wrote:
> > OK, so the common elements here appears to be root filesystems
> > with small log sizes, which means they are tail pushing all the
> > time metadata operations are in progress. Definitely seems like a
> > race in the AIL workqueue trigger mechanism. I'll see if I can
> > reproduce this and cook up a patch to fix it.
> 
> Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
> other assorted feedback wrt this issue?  I've had it happen twice now
> myself in the past week or so, though I have no reliable reproduction
> technique.  Just wondering if more data points will help isolate the
> cause, and if so, how to be prepared to get them.
> 
> For whatever its worth, my last lockup was while running
> 2.6.39-rc5-00127-g1be6a1f with a preempt config without cgroups.

Can you all try the patch below? I've managed to trigger a couple of
xlog_wait() lockups in some controlled load tests. The lockups don't
appear to occur with the following patch to he race condition in
the AIL workqueue trigger.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix race condition queuing AIL pushes

From: Dave Chinner <dchinner@redhat.com>

The recent conversion of the xfsaild functionality to a work queue
introduced a hard-to-hit log space grant hang. The problem is that
the use of the XFS_AIL_PUSHING_BIT to determine whether a push is
currently in progress is racy.

When the AIL push work completes, it checked whether the target
changed and cleared the PUSHING bit to allow a new push to be
requeued. The race condition is as follows:

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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index acdb92f..b7606d9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -486,15 +486,19 @@ xfs_ail_worker(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
