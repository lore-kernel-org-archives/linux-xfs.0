Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04NRpvt155440 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 17:27:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C4A61C2A89A
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 15:28:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	mBGIctfLJ1U1w6cb for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2010 15:28:39 -0800 (PST)
Date: Tue, 5 Jan 2010 10:28:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] XFS: Don't wake the aild once per second
Message-ID: <20100104232835.GM13802@discord.disaster>
References: <1262400215-19443-1-git-send-email-david@fromorbit.com>
	<1262400215-19443-2-git-send-email-david@fromorbit.com>
	<20100104151616.GB24810@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100104151616.GB24810@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 04, 2010 at 10:16:16AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 02, 2010 at 01:43:34PM +1100, Dave Chinner wrote:
> > Now that the AIL push algorithm is traversal safe, we don't need a
> > watchdog function in the xfsaild to catch pushes that fail to make
> > progress. Remove the watchdog timeout and make pushes purely driven
> > by demand. This will remove the once-per-second wakeup that is seen
> > when the filesystem is idle and make laptop power misers happy.
> 
> Looks good, but a few nitpicks below:
> 
> > -	long		tout = 0;
> > +	long		tout = 1000; /* milliseconds */
> 
> Why do we use a timeout when starting up now?  If there's a good reason
> for it the reason at least should be explained in a comment here.

No good reason.

> >  	while (!kthread_should_stop()) {
> > -		if (tout)
> > -			schedule_timeout_interruptible(msecs_to_jiffies(tout));
> > -		tout = 1000;
> > +		tout = !tout ? MAX_SCHEDULE_TIMEOUT : msecs_to_jiffies(tout);
> 
> Why not just:
> 
> 		schedule_timeout_interruptible(tout ?
> 				msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
> 
> that avoids the assignment of different units to the same variable, and
> also the negation.

Much cleaner. Fixed.

> > +	long		tout = 0;
> >  	xfs_lsn_t	last_pushed_lsn = *last_lsn;
> >  	xfs_lsn_t	target =  ailp->xa_target;
> >  	xfs_lsn_t	lsn;
> > @@ -279,7 +280,6 @@ xfsaild_push(
> >  	 * prevents use from spinning when we can't do anything or there is
> >  	 * lots of contention on the AIL lists.
> >  	 */
> > -	tout = 10;
> >  	lsn = lip->li_lsn;
> >  	flush_log = stuck = count = 0;
> >  	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
> > @@ -376,14 +376,14 @@ xfsaild_push(
> >  
> >  	if (!count) {
> >  		/* We're past our target or empty, so idle */
> > -		tout = 1000;
> > +		tout = 0;
> 
> tout always is 0 here already.

Good catch. Hmm - I just noticed that we should be resetting the
last_lsn when we idle. I've fixed that now.

> >  	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
> >  		/*
> >  		 * We reached the target so wait a bit longer for I/O to
> >  		 * complete and remove pushed items from the AIL before we
> >  		 * start the next scan from the start of the AIL.
> >  		 */
> > -		tout += 20;
> > +		tout = 50;
> >  		last_pushed_lsn = 0;
> >  	} else if ((stuck * 100) / count > 90) {
> >  		/*
> > @@ -395,11 +395,14 @@ xfsaild_push(
> >  		 * Backoff a bit more to allow some I/O to complete before
> >  		 * continuing from where we were.
> >  		 */
> > -		tout += 10;
> > +		tout = 20;
> > +	} else {
> > +		/* more to do, but wait a short while before continuing */
> > +		tout = 10;
> >  	}
> >  	*last_lsn = last_pushed_lsn;
> >  	return tout;
> > -}	/* xfsaild_push */
> > +}
> 
> All the += and co here is a bit confusing.  We always return 0 now
> except for those last two cases that return 20 or 10.  So I'd just
> change them to a tout = 10/20;

I'm not sure what you mean - isn't that what this patch does? i.e.
now looks like:

	if idle
		tout = 0
	else if we reach the target
		tout = 50
	else if stuck
		tout = 20
	else
		tout = 10

Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: Don't wake the aild once per second

Now that the AIL push algorithm is traversal safe, we don't need a
watchdog function in the xfsaild to catch pushes that fail to make
progress. Remove the watchdog timeout and make pushes purely driven
by demand. This will remove the once-per-second wakeup that is seen
when the filesystem is idle and make laptop power misers happy.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    7 +++----
 fs/xfs/xfs_trans_ail.c       |   19 +++++++++++--------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 09783cc..0a4fd0e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -877,12 +877,11 @@ xfsaild(
 {
 	struct xfs_ail	*ailp = data;
 	xfs_lsn_t	last_pushed_lsn = 0;
-	long		tout = 0;
+	long		tout = 0; /* milliseconds */
 
 	while (!kthread_should_stop()) {
-		if (tout)
-			schedule_timeout_interruptible(msecs_to_jiffies(tout));
-		tout = 1000;
+		schedule_timeout_interruptible(tout ?
+				msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
 
 		/* swsusp */
 		try_to_freeze();
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2ffc570..063dfbd 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -237,14 +237,15 @@ out:
 }
 
 /*
- * Function that does the work of pushing on the AIL
+ * xfsaild_push does the work of pushing on the AIL.  Returning a timeout of
+ * zero indicates that the caller should sleep until woken.
  */
 long
 xfsaild_push(
 	struct xfs_ail	*ailp,
 	xfs_lsn_t	*last_lsn)
 {
-	long		tout = 1000; /* milliseconds */
+	long		tout = 0;
 	xfs_lsn_t	last_pushed_lsn = *last_lsn;
 	xfs_lsn_t	target =  ailp->xa_target;
 	xfs_lsn_t	lsn;
@@ -262,7 +263,7 @@ xfsaild_push(
 		 */
 		xfs_trans_ail_cursor_done(ailp, cur);
 		spin_unlock(&ailp->xa_lock);
-		last_pushed_lsn = 0;
+		*last_lsn = 0;
 		return tout;
 	}
 
@@ -279,7 +280,6 @@ xfsaild_push(
 	 * prevents use from spinning when we can't do anything or there is
 	 * lots of contention on the AIL lists.
 	 */
-	tout = 10;
 	lsn = lip->li_lsn;
 	flush_log = stuck = count = 0;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
@@ -376,14 +376,14 @@ xfsaild_push(
 
 	if (!count) {
 		/* We're past our target or empty, so idle */
-		tout = 1000;
+		last_pushed_lsn = 0;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
 		 * We reached the target so wait a bit longer for I/O to
 		 * complete and remove pushed items from the AIL before we
 		 * start the next scan from the start of the AIL.
 		 */
-		tout += 20;
+		tout = 50;
 		last_pushed_lsn = 0;
 	} else if ((stuck * 100) / count > 90) {
 		/*
@@ -395,11 +395,14 @@ xfsaild_push(
 		 * Backoff a bit more to allow some I/O to complete before
 		 * continuing from where we were.
 		 */
-		tout += 10;
+		tout = 20;
+	} else {
+		/* more to do, but wait a short while before continuing */
+		tout = 10;
 	}
 	*last_lsn = last_pushed_lsn;
 	return tout;
-}	/* xfsaild_push */
+}
 
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
