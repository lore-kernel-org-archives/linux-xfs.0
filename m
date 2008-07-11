Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 20:20:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B3Kea6005508
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 20:20:41 -0700
Message-ID: <4876D1C3.4000006@sgi.com>
Date: Fri, 11 Jul 2008 13:21:39 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com>
In-Reply-To: <4876C9EB.7060601@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: markgw@sgi.com, xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:
> Thanks for the report Eric. This looks very similar to a
> deadlock Lachlan recently hit in the patch for
> "Use atomics for iclog reference counting"
> http://oss.sgi.com/archives/xfs/2008-02/msg00130.html
> 
> It seems this patch can cause deadlocks under heavy log traffic.
> I don't think anyone has a fix yet ... Lachlan is out this week,
> but Tim can follow-up here ...
> 
> Cheers
> -- Mark
> 

Okay, what Mark is talking about is pv#983925.
Details below from the bug - from Lachlan and me.
I'm sorry that this info didn't go out sooner.
I'm not sure if Lachlan got any further with this but he's
been away.

--Tim

Lachlan wrote:
[....stuff deleted...]
> It's the same signature every time with the current iclog in WANT_SYNC state
> and the rest of the iclogs in DO_CALLBACK state.  The current iclog log should
> transition from WANT_SYNC to SYNCING to DONE_SYNC and eventually to ACTIVE so
> the threads above can continue but it's not a happening.
> 
> I suspect this mod is the culprit:
> 
> mod xfs-linux-melb:xfs-kern:30505a header
> ==========================================
>  - SM_Location:  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
>  - Workarea:     chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
>  - xfs-linux-melb:xfs-kern:30505a 02/15/08
>  - PV Incidents affected:        975671
>  - Inspected by:         tes@sgi.com
>  - Description:
>    Use atomics for iclog reference counting
> 
>    Now that we update the log tail LSN less frequently on
>    transaction completion, we pass the contention straight to
>    the global log state lock (l_iclog_lock) during transaction
>    completion.
>    
>    We currently have to take this lock to decrement the iclog
>    reference count. there is a reference count on each iclog,
>    so we need to take &#65533;he global lock for all refcount changes.
>    
>    When large numbers of processes are all doing small trnasctions,
>    the iclog reference counts will be quite high, and the state change
>    that absolutely requires the l_iclog_lock is the except rather than
>    the norm.
>    
>    Change the reference counting on the iclogs to use atomic_inc/dec
>    so that we can use atomic_dec_and_lock during transaction completion
>    and avoid the need for grabbing the l_iclog_lock for every reference
>    count decrement except the one that matters - the last.
>  - Files affected:  xfsidbg.c 1.343, xfs_log.c 1.347,
>    xfs_log_priv.h 1.125
>  - Author:       dgc
>  - xfsidbg.c:
>    use correct atomic accessor for the iclog refcount.
>  - xfs_log.c:
>    Reduce contention on the iclog state lock by using atomic
>    reference counters for the iclogs and only grabbing the
>    iclog lock on transaction completion when the last reference
>    to the iclog is being removed.
>  - xfs_log_priv.h:
>    change ic_refcount to an atomic_t.
> 
> 
> It made this change which moved the refcount 'decrement and test' operation
> outside the l_icloglock spinlock and therefore can race. 
> 
> @@ -2819,18 +2819,21 @@ xlog_state_release_iclog(
>  {
>         int             sync = 0;       /* do we sync? */
>  
> -       spin_lock(&log->l_icloglock);
> +       if (iclog->ic_state & XLOG_STATE_IOERROR)
> +               return XFS_ERROR(EIO);
> +
> +       ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
> +       if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
> +               return 0;
> +
>         if (iclog->ic_state & XLOG_STATE_IOERROR) {
>                 spin_unlock(&log->l_icloglock);
>                 return XFS_ERROR(EIO);
>         }
> 
> The above code will race with this code in xlog_state_get_iclog_space():
> 
> 	spin_lock(&log->l_icloglock);
> 	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
> 
> 	...
> 
> 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
> 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
> 
> 		/* If I'm the only one writing to this iclog, sync it to disk */
> 		if (atomic_read(&iclog->ic_refcnt) == 1) {
> 			spin_unlock(&log->l_icloglock);
> 			if ((error = xlog_state_release_iclog(log, iclog)))
> 				return error;
> 		} else {
> 			atomic_dec(&iclog->ic_refcnt);
> 			spin_unlock(&log->l_icloglock);
> 		}
> 		goto restart;
> 	}
> 
> Previously xlog_state_release_iclog() would wait for the spinlock to be
> released above but will now do the atomic_dec_and_lock() while the above
> code is executing.  The above atomic_read() will return 2, the
> atomic_dec_and_lock() in xlog_state_release_iclog() will return false and
> return without syncing the iclog and then the above code will decrement the
> atomic counter.  The iclog never gets out of WANT_SYNC state and everything
> gets stuck behind it.
> 
> 
> ==========================
> ADDITIONAL INFORMATION (ADD)
> From: tes@sgi.com (BugWorks)
> Date: Jul 01 2008 09:59:49PM
> ==========================
> 
> Hi,
> 
> Okay, I've just been trying to understand what Lachlan was saying
> about the problem and Lachlan kindly gave me an explanation.
> 
> Based on that, below is my understanding so I remember what is going
> wrong here ;-) Correct me if I got this wrong.
> 
> 
> Bad scenario (current code)
> ----------------------------
> Process A has a reference on iclog
> and iclog-refcnt == 1
> 
> Process B tries to get some log space,
> and takes lock and bumps count to 2
> Process B tests to see if its refcnt is just 1
> but it isn't so it moves on, _up_ to the refcnt decrement
> 
> Process A decides to release its iclog
> and calls xlog_state_release_iclog
> It does a decrement WITHOUT taking lock
> The refcnt goes from 2 to 1 and so it just
> returns without sync'ing.
> 
> Process B now does its decrement and takes
> the refcnt from 1 to 0. and releases the lock.
> 
> 
> Good scenario (with previous code)
> -----------------------------------
> Process A has a reference on iclog
> and iclog-refcnt == 1
> 
> Process B tries to get some logspace,
> and takes lock and bumps count to 2.
> Process B tests to see if its refcnt is just 1
> but it isn't so it moves on, _up_ to the refcnt decrement.
> 
> Process A decides to release its iclog
> and calls xlog_state_release_iclog.
> However, it can't get the lock yet and so it waits.
> 
> Process B now decrements its refcnt from 2
> back to 1 and releases the lock.
> 
> Process A now can get its lock and decrements
> the refcnt, finds it goes from 1 to zero and
> can now do the sync'ing.
> -----------------------------------
> 
> --Tim
