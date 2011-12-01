Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1Jp7Th021487 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 13:51:07 -0600
Date: Thu, 1 Dec 2011 13:51:28 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
Message-ID: <20111201195128.GZ29840@sgi.com>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<20111130235641.GX29840@sgi.com>
	<20111201072149.GA1319@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111201072149.GA1319@infradead.org>
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

On Thu, Dec 01, 2011 at 02:21:49AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 30, 2011 at 05:56:41PM -0600, Ben Myers wrote:
> > Christoph,
> > 
> > I feel that the ordering of the accesses to l_grant_head and the writeq
> > list may be important in the lockless path, and notice that they used to
> > be in opposite order.  It could use a comment explaining why (if) it is
> > ok.
> 
> Do you mean moving the xlog_space_left after the first
> list_empty_careful check in xlog_grant_log_space?

That's what I mean, but I'm not sure I was correct.

> It doesn't matter
> given that we re-check the available space after each wakeup.

2620 STATIC int
2621 xlog_grant_log_space(
2622         struct log              *log,
2623         struct xlog_ticket      *tic)
2624 {
2625         int                     free_bytes, need_bytes;
2626         int                     error = 0;
2627 
2628         ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
2629 
2630         trace_xfs_log_grant_enter(log, tic);
2631 
2632         /*
2633          * If there are other waiters on the queue then give them a chance at
2634          * logspace before us.  Wake up the first waiters, if we do not wake
2635          * up all the waiters then go to sleep waiting for more free space,
2636          * otherwise try to get some space for this transaction.
2637          */
2638         need_bytes = tic->t_unit_res;
2639         if (tic->t_flags & XFS_LOG_PERM_RESERV)
2640                 need_bytes *= tic->t_ocnt;
2641         free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
2642         if (!list_empty_careful(&log->l_reserveq)) {
2643                 spin_lock(&log->l_grant_reserve_lock);
2644                 if (!xlog_reserveq_wake(log, &free_bytes) ||
2645                     free_bytes < need_bytes)
2646                         error = xlog_reserveq_wait(log, tic, need_bytes);
2647                 spin_unlock(&log->l_grant_reserve_lock);
2648         } else if (free_bytes < need_bytes) {
2649                 spin_lock(&log->l_grant_reserve_lock);
2650                 error = xlog_reserveq_wait(log, tic, need_bytes);
2651                 spin_unlock(&log->l_grant_reserve_lock);
2652         }
2653         if (error)
2654                 return error;
2655 
2656         xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
2657         xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
2658         trace_xfs_log_grant_exit(log, tic);
2659         xlog_verify_grant_tail(log);
2660         return 0;
2661 }

Process A reads from the grant reserve head at 2641 (and there currently is enough space)
Process B wakes at either 2646 or 2650, in xlog_reserveq_wait, locks, and reads from the grant reserve head (and currently there is enough space)
Process B removes itself from the list 
Process A reads from the reservq list and finds it to be empty
Process A finds that there was enough space at 2646
Process B returns from xlog_reserveq_wait, unlocks, grants space at 2656, returns
Process A grants log space at 2656, and returns

AFAICS there is nothing that prevents these guys from granting the same
space when you approach free_bytes >= need_bytes concurrently. 

This lockless stuff is always a mind job for me.  I'll take another look at
some of the other aspects of the patch.  Even if it doesn't resolve my
question about the lockless issue, it seems to resolve Chandra's race.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
