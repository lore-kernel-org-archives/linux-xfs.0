Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJ1Evi1224977 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 19:14:57 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9A2C26332E
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 17:14:54 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lZ0DDskTcrMTQdas for <xfs@oss.sgi.com>;
	Fri, 18 Nov 2011 17:14:54 -0800 (PST)
Date: Sat, 19 Nov 2011 12:14:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove the entries from the queue while waking them
	up.
Message-ID: <20111119011450.GL7046@dastard>
References: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Fri, Nov 18, 2011 at 01:20:54PM -0600, Chandra Seetharaman wrote:
> l_reserveq and l_writeq maintains a list of processes waiting to get log
> space. Processes are supposed to get in the list when the amount of free
> space available in the log is less than what they need.
> 
> When space becomes available current code, wakes up the processes, but
> expect the processes to remove themselves from the queue.
> 
> Since the lock protecting the list is only acquired later by the woken
> up process, there is a window of time were a new process that is looking
> for space can wrongly get into the queue while there is enough space
> available. 
> 
> Since there is enough space available, this process can never be woken
> up, which leads to the hang of the process.

Excellent work, Chandra.

> This was originally reported by Alex Elder <aelder@sgi.com> as hang seen
> in xfstests #234.
> 
> With log of log activities, this problem may not be seen, as some
> process will be pushing the processes along. But, 234 does lot of quota
> operations only, hence the problem was noticed in that test.

Right, and it's only since we made the log reserve path lockless
that we've been tripping over this race condition. I'd say those
changes made it easier to hit, because this race condition has been
there for a long time.

Indeed, the wakeup race was present in the initial commit
for the grant write/reserve head accounting code way back in June of
1994:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=84181026c6c915d7727a4cf316415dd1e8d5805a

This is effectively a zero-day bug you've just got to the bottom of
- it's one of the oldest bugs ever found in the XFS codebase - and
would explain the occasional random log space hangs that have been
seen over the years and we've never been able to reproduce.

> This patch fixes the problem by removing the element from the queue
> (safely) when the process was woken up.
> 
> Reported-by: Alex elder <aelder@sgi.com>
> Signed-Off-by: Chandra Seethraman <sekharan@us.ibm.com>

Couple of comments about the patch below

> ---
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a14cd89..9941fcb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -674,7 +674,7 @@ void
>  xfs_log_move_tail(xfs_mount_t	*mp,
>  		  xfs_lsn_t	tail_lsn)
>  {
> -	xlog_ticket_t	*tic;
> +	xlog_ticket_t	*tic, *tmp;

When we modify such declarations, we normally remove the typedef.
Typically we also only declare one variable per line.  Also, it's
best to avoid variables named "tmp". What it really is used for is
the loop next pointer, so "next" is a much better name for it.

i.e:

-	xlog_ticket_t *tic;
+	struct xlog_ticket *tic;
+	struct xlog_ticket *next;

Can change all the "tmp" variables appropriately?

>  	xlog_t		*log = mp->m_log;
>  	int		need_bytes, free_bytes;
>  
> @@ -695,7 +695,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
>  #endif
>  		spin_lock(&log->l_grant_write_lock);
>  		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
> -		list_for_each_entry(tic, &log->l_writeq, t_queue) {
> +		list_for_each_entry_safe(tic, tmp, &log->l_writeq, t_queue) {
>  			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
>  
>  			if (free_bytes < tic->t_unit_res && tail_lsn != 1)
> @@ -703,6 +703,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
>  			tail_lsn = 0;
>  			free_bytes -= tic->t_unit_res;
>  			trace_xfs_log_regrant_write_wake_up(log, tic);
> +			list_del_init(&tic->t_queue);
>  			wake_up(&tic->t_wait);
>  		}
>  		spin_unlock(&log->l_grant_write_lock);

A comment here describing the reason why we need to remove the
ticket from the queue before issuing the wakeup would be good. We
normally add comments explaining how we've avoided race conditions
in the code so that in a couple of years time we know why the code
was written that way without having to go looking in the commit
history.

> @@ -715,7 +716,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
>  #endif
>  		spin_lock(&log->l_grant_reserve_lock);
>  		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
> -		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
> +		list_for_each_entry_safe(tic, tmp, &log->l_reserveq, t_queue) {
>  			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
>  				need_bytes = tic->t_unit_res*tic->t_cnt;
>  			else
> @@ -725,6 +726,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
>  			tail_lsn = 0;
>  			free_bytes -= need_bytes;
>  			trace_xfs_log_grant_wake_up(log, tic);
> +			list_del_init(&tic->t_queue);
>  			wake_up(&tic->t_wait);
>  		}
>  		spin_unlock(&log->l_grant_reserve_lock);
> @@ -2550,8 +2552,7 @@ redo:
>  	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
>  	if (free_bytes < need_bytes) {
>  		spin_lock(&log->l_grant_reserve_lock);
> -		if (list_empty(&tic->t_queue))
> -			list_add_tail(&tic->t_queue, &log->l_reserveq);
> +		list_add_tail(&tic->t_queue, &log->l_reserveq);
>  
>  		trace_xfs_log_grant_sleep2(log, tic);
>  

Ok, we now have the assumption that when we enter this code the
ticket is not on any queue at all. Can you add an
"ASSERT(list_empty(&tic->t_queue));" to the code before the above
xlog_space_left() call? That way we'll know if we violate that
assumption as potentially corrupt memory....

> @@ -2567,12 +2568,6 @@ redo:
>  		goto redo;
>  	}
>  
> -	if (!list_empty(&tic->t_queue)) {
> -		spin_lock(&log->l_grant_reserve_lock);
> -		list_del_init(&tic->t_queue);
> -		spin_unlock(&log->l_grant_reserve_lock);
> -	}
> -
>  	/* we've got enough space */
>  	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
>  	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
> @@ -2626,30 +2621,28 @@ xlog_regrant_write_log_space(xlog_t	   *log,
>  		goto error_return_unlocked;
>  
>  	/* If there are other waiters on the queue then give them a
> -	 * chance at logspace before us. Wake up the first waiters,
> -	 * if we do not wake up all the waiters then go to sleep waiting
> -	 * for more free space, otherwise try to get some space for
> -	 * this transaction.
> +	 * chance at logspace before us. If we do not wake up all
> +	 * the waiters then go to sleep waiting for more free space,
> +	 * otherwise try to get some space for this transaction.
>  	 */
>  	need_bytes = tic->t_unit_res;
>  	if (!list_empty_careful(&log->l_writeq)) {
> -		struct xlog_ticket *ntic;
> +		struct xlog_ticket *ntic, *tmp;

tmp -> next

And probably need an assert for tic not being in a queue.

>  
>  		spin_lock(&log->l_grant_write_lock);
>  		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
> -		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
> +		list_for_each_entry_safe(ntic, tmp, &log->l_writeq, t_queue) {
>  			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
>  
>  			if (free_bytes < ntic->t_unit_res)
>  				break;
>  			free_bytes -= ntic->t_unit_res;
> +			list_del_init(&ntic->t_queue);
>  			wake_up(&ntic->t_wait);
>  		}
>  
> -		if (ntic != list_first_entry(&log->l_writeq,
> -						struct xlog_ticket, t_queue)) {
> -			if (list_empty(&tic->t_queue))
> -				list_add_tail(&tic->t_queue, &log->l_writeq);
> +		if (!list_empty(&log->l_writeq)) {
> +			list_add_tail(&tic->t_queue, &log->l_writeq);

>  			trace_xfs_log_regrant_write_sleep1(log, tic);
>  
>  			xlog_grant_push_ail(log, need_bytes);
> @@ -2668,8 +2661,7 @@ redo:
>  	free_bytes = xlog_space_left(log, &log->l_grant_write_head);
>  	if (free_bytes < need_bytes) {
>  		spin_lock(&log->l_grant_write_lock);
> -		if (list_empty(&tic->t_queue))
> -			list_add_tail(&tic->t_queue, &log->l_writeq);
> +		list_add_tail(&tic->t_queue, &log->l_writeq);
>  
>  		if (XLOG_FORCED_SHUTDOWN(log))
>  			goto error_return;

Same again - assert above xlog_space_left.

> @@ -2684,12 +2676,6 @@ redo:
>  		goto redo;
>  	}
>  
> -	if (!list_empty(&tic->t_queue)) {
> -		spin_lock(&log->l_grant_write_lock);
> -		list_del_init(&tic->t_queue);
> -		spin_unlock(&log->l_grant_write_lock);
> -	}
> -
>  	/* we've got enough space */
>  	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
>  	trace_xfs_log_regrant_write_exit(log, tic);
> @@ -3621,7 +3607,7 @@ xfs_log_force_umount(
>  	struct xfs_mount	*mp,
>  	int			logerror)
>  {
> -	xlog_ticket_t	*tic;
> +	xlog_ticket_t	*tic, *tmp;
>  	xlog_t		*log;
>  	int		retval;

tmp -> next

>  
> @@ -3690,13 +3676,17 @@ xfs_log_force_umount(
>  	 * action is protected by the grant locks.
>  	 */
>  	spin_lock(&log->l_grant_reserve_lock);
> -	list_for_each_entry(tic, &log->l_reserveq, t_queue)
> +	list_for_each_entry_safe(tic, tmp, &log->l_reserveq, t_queue) {
> +		list_del_init(&tic->t_queue);
>  		wake_up(&tic->t_wait);
> +	}
>  	spin_unlock(&log->l_grant_reserve_lock);
>  
>  	spin_lock(&log->l_grant_write_lock);
> -	list_for_each_entry(tic, &log->l_writeq, t_queue)
> +	list_for_each_entry_safe(tic, tmp, &log->l_writeq, t_queue) {
> +		list_del_init(&tic->t_queue);
>  		wake_up(&tic->t_wait);
> +	}
>  	spin_unlock(&log->l_grant_write_lock);

And comments explaining why we are removing the ticket from the
queue before issuing the wakeup.

I'll run some testing on the patch - it looks like it's correct, but
seeing as this logic hasn't changed for so long a bit more testing
won't hurt. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
