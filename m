Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:03:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B43jpO010927
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:03:46 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1239DF4EDD
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:04:50 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Gp5TsKg00B5ZMjrl for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:04:50 -0700 (PDT)
Date: Fri, 11 Jul 2008 14:04:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlocked xfs
Message-ID: <20080711040447.GC11558@disturbed>
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <4876D1C3.4000006@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876D1C3.4000006@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, markgw@sgi.com, xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 11, 2008 at 01:21:39PM +1000, Timothy Shimmin wrote:
> > It made this change which moved the refcount 'decrement and test' operation
> > outside the l_icloglock spinlock and therefore can race. 

Just FYI, this is not a 'decrement and test' operation - it's
an 'decrement and return locked if zero' operation. Best to
 explain it is this comment in lib/dec_and_lock.c:

/*
 * This is an implementation of the notion of "decrement a
 * reference count, and return locked if it decremented to zero".
 *
 * NOTE NOTE NOTE! This is _not_ equivalent to
 *
 *      if (atomic_dec_and_test(&atomic)) {
 *              spin_lock(&lock);
 *              return 1;
 *      }
 *      return 0;
 *
 * because the spin-lock and the decrement must be
 * "atomic".
 */


> > 	spin_lock(&log->l_icloglock);
> > 	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
> > 
> > 	...
> > 
> > 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
> > 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
> > 
> > 		/* If I'm the only one writing to this iclog, sync it to disk */
> > 		if (atomic_read(&iclog->ic_refcnt) == 1) {
> > 			spin_unlock(&log->l_icloglock);
> > 			if ((error = xlog_state_release_iclog(log, iclog)))
> > 				return error;
> > 		} else {
> > 			atomic_dec(&iclog->ic_refcnt);
> > 			spin_unlock(&log->l_icloglock);
> > 		}
> > 		goto restart;
> > 	}

Ok, so all the increments of ic_refcnt are done under l_icloglock.
That means through this section of code we can not ever have teh reference
count increase. It can decrease, but never to zero because that
requires holding the l_icloglock.

> > Previously xlog_state_release_iclog() would wait for the spinlock to be
> > released above but will now do the atomic_dec_and_lock() while the above
> > code is executing.  The above atomic_read() will return 2, the
> > atomic_dec_and_lock() in xlog_state_release_iclog() will return false and
> > return without syncing the iclog and then the above code will decrement the
> > atomic counter.  The iclog never gets out of WANT_SYNC state and everything
> > gets stuck behind it.

So what that means is that need the semantics here to be an
atomic 'decrement unless the count is 1' i.e.:

	if (atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
		spin_unlock(&log->l_icloglock);
		if ((error = xlog_state_release_iclog(log, iclog)))
			return error;
	} else {
			spin_unlock(&log->l_icloglock);
	}

This means that the compare + decrement becomes atomic, thereby
closing the race condition where another unlocked thread can
decrement the reference count in between the compare and decrement
here.

Patch for you to test, Eric, below.

(I haven't been able to test it because UML panics on boot right now.
I need to hoover in the unit-at-atime build patch that Jeff Dike
posted this morning)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Fix reference counting race on log buffers

When we release the iclog, we do an atomic_dec_and_lock to determine
if we are the last reference to enable update of log headers and
writeout. however, in xlog_state_get_iclog_space() we need to check
if we have the last reference count there.  if we do, we release the
log buffer, otherwise we decrement the reference count.

The issue is that the compare and decrement in
xlog_state_get_iclog_space() is not atomic, so both places can see a
reference count of 2 and neither will release the iclog. That leads
to a filesystem hang.

Close the hole replacing the compare and decrement with
atomic_add_unless() to ensure that they are executed atomically.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 760d543..8033f8a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2425,13 +2425,19 @@ restart:
 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
 
-		/* If I'm the only one writing to this iclog, sync it to disk */
-		if (atomic_read(&iclog->ic_refcnt) == 1) {
+		/*
+		 * If I'm the only one writing to this iclog, sync it to disk.
+		 * We need to do an atomic compare and decrement here to avoid
+		 * racing with concurrent atomic_dec_and_lock() calls in
+		 * xlog_state_release_iclog() when there is more than one
+		 * reference to the iclog.
+		 */
+		if (atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
 			spin_unlock(&log->l_icloglock);
-			if ((error = xlog_state_release_iclog(log, iclog)))
+			error = xlog_state_release_iclog(log, iclog);
+			if (error)
 				return error;
 		} else {
-			atomic_dec(&iclog->ic_refcnt);
 			spin_unlock(&log->l_icloglock);
 		}
 		goto restart;
