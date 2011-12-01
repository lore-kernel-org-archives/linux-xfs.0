Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1Khiow023485 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 14:43:44 -0600
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E13291287729
	for <xfs@oss.sgi.com>; Thu,  1 Dec 2011 12:43:42 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id p4PIhc2TW4u4ybJv for
	<xfs@oss.sgi.com>; Thu, 01 Dec 2011 12:43:42 -0800 (PST)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 1 Dec 2011 15:43:41 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB1KhdMC321288 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 15:43:39 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	pB1Khcns030935 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 18:43:39 -0200
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111201183233.GY29840@sgi.com>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<20111201183233.GY29840@sgi.com>
Date: Thu, 01 Dec 2011 14:43:36 -0600
Message-ID: <1322772216.7115.1552.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Ben,

Yes, that is the race I found thru debugging.

Chandra
On Thu, 2011-12-01 at 12:32 -0600, Ben Myers wrote:
> Hi,
> 
> On Mon, Nov 28, 2011 at 03:17:36AM -0500, Christoph Hellwig wrote:
> > Apply the scheme used in log_regrant_write_log_space to wake up any other
> > threads waiting for log space before the newly added one to
> > log_regrant_write_log_space as well, and factor the code into readable
> > helpers.  For each of the queues we have add two helpers:
> > 
> >  - one to try to wake up all waiting threads.  This helper will also be
> >    usable by xfs_log_move_tail once we remove the current opportunistic
> >    wakeups in it.
> >  - one to sleep on t_wait until enough log space is available, loosely
> >    modelled after Linux waitqueues.
> >  
> > And use them to reimplement the guts of log_regrant_write_log_space and
> > log_regrant_write_log_space.  These two function now use one and the same
> > algorithm for waiting on log space instead of subtly different ones before,
> > with an option to completely unify them in the near future.
> > 
> > Also move the filesystem shutdown handling to the common caller given
> > that we had to touch it anyway.
> > 
> > Based on hard debugging and an earlier patch from
> > Chandra Seetharaman <sekharan@us.ibm.com>.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I'd like to make sure that I understand the race that Chandra
> debugged and reported.
> 
> 2499 STATIC int
> 2500 xlog_grant_log_space(xlog_t        *log,
> 2501                      xlog_ticket_t *tic)
> 2502 {
> 2503         int              free_bytes;
> 2504         int              need_bytes;
> ...
> 2517         /* something is already sleeping; insert new transaction at end */
> 2518         if (!list_empty_careful(&log->l_reserveq)) {
> 2519                 spin_lock(&log->l_grant_reserve_lock);
> 2520                 /* recheck the queue now we are locked */
> 2521                 if (list_empty(&log->l_reserveq)) {
> 2522                         spin_unlock(&log->l_grant_reserve_lock);
> 2523                         goto redo;
> 2524                 }
> 2525                 list_add_tail(&tic->t_queue, &log->l_reserveq);
> 2526 
> 2527                 trace_xfs_log_grant_sleep1(log, tic);
> 2528 
> 2529                 /*
> 2530                  * Gotta check this before going to sleep, while we're
> 2531                  * holding the grant lock.
> 2532                  */
> 2533                 if (XLOG_FORCED_SHUTDOWN(log))
> 2534                         goto error_return;
> 2535 
> 2536                 XFS_STATS_INC(xs_sleep_logspace);
> 2537                 xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
> 2538 
> 2539                 /*
> 2540                  * If we got an error, and the filesystem is shutting down,
> 2541                  * we'll catch it down below. So just continue...
> 2542                  */
> 2543                 trace_xfs_log_grant_wake1(log, tic);
> 2544         }
> 2545 
> 2546 redo:
> 2547         if (XLOG_FORCED_SHUTDOWN(log))
> 2548                 goto error_return_unlocked;
> 2549 
> 2550         free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
> 2551         if (free_bytes < need_bytes) {
> 2552                 spin_lock(&log->l_grant_reserve_lock);
> 2553                 if (list_empty(&tic->t_queue))
> 2554                         list_add_tail(&tic->t_queue, &log->l_reserveq);
> 2555    
> 2556                 trace_xfs_log_grant_sleep2(log, tic);
> 2557 
> 2558                 if (XLOG_FORCED_SHUTDOWN(log))
> 2559                         goto error_return;
> 2560 
> 2561                 xlog_grant_push_ail(log, need_bytes);
> 2562 
> 2563                 XFS_STATS_INC(xs_sleep_logspace);
> 2564                 xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
> 2565 
> 2566                 trace_xfs_log_grant_wake2(log, tic);
> 2567                 goto redo;
> 2568         }
> 2569 
> 2570         if (!list_empty(&tic->t_queue)) {
> 2571                 spin_lock(&log->l_grant_reserve_lock);
> 2572                 list_del_init(&tic->t_queue);
> 2573                 spin_unlock(&log->l_grant_reserve_lock);
> 2574         }
> 
> So the race that we're looking at here is:
> 
> process A was added to the reserve queue at either 2525 or 2554 and, pushes the AIL at 2561,
> xfsaild frees up enough log space for process A (possibly B?), eventually xfs_log_move_tail is called to wake process A,
> process A wakes at line 2564, and he is on the reserveq already,
> process B sees that there are tickets on the queue at 2518 and gets the grant reserve lock at 2519,
> process A spins at 2571 waiting for the grant reserve lock,
> process B adds itself to the queue at 2525, 
> process B drops the grant reserve lock and goes to sleep at 2537
> process A takes the grant reserve lock at 2571 and removes it's ticket from the list.
> 
> ...and there is nothing to wake process B until the ail is pushed by
> some other process.
> 
> Is that about right?
> 
> Thanks,
> Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
