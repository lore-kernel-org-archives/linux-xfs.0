Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 28F897F3F
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 09:29:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79C0FAC004
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 07:29:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iO60noJrO4HE8T6a (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 07:29:11 -0700 (PDT)
Date: Tue, 9 Sep 2014 09:44:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: xlog_cil_force_lsn doesn't always wait correctly
Message-ID: <20140909134458.GA35182@bfoster.bfoster>
References: <1410226995-15714-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410226995-15714-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 11:43:15AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running a tight mount/unmount loop on an older kernel, RedHat
> QE found that unmount would occasionally hang in
> xfs_buf_unpin_wait() on the superblock buffer. Tracing and other
> debug work by Eric Sandeen indicated that it was hanging on the
> writing of the superblock during unmount immediately after logging
> the superblock counters in a synchronous transaction. Further debug
> indicated that the synchronous transaction was not waiting for
> completion correctly, and we narrowed it down to
> xlog_cil_force_lsn() returning NULLCOMMITLSN and hence not pushing
> the transaction in the iclog buffer to disk correctly.
> 
> While this unmount superblock write code is now very different in
> mainline kernels, the xlog_cil_force_lsn() code is identical, and it
> was bisected to the backport of commit f876e44 ("xfs: always do log
> forces via the workqueue"). This commit made the CIL push
> asynchronous for log forces and hence exposed a race condition that
> couldn't occur on a synchronous push.
> 
> Essentially, the xlog_cil_force_lsn() relied implicitly on the fact
> that the sequence push would be complete by the time
> xlog_cil_push_now() returned, resulting in the context being pushed
> being in the committing list. When it was made asynchronous, it was
> recognised that there was a race condition in detecting whether an
> asynchronous push has started or not and code was added to handle
> it.
> 
> Unfortunately, the fix was not quite right and left a race condition
> where it it would detect an empty CIL while a push was in progress
> before the context had been added to the committing list. This was
> incorrectly seen as a "nothing to do" condition and so would tell
> xfs_log_force_lsn() that there is nothing to wait for, and hence it
> would push the iclogbufs in memory.
> 
> The fix is simple, but explaining the logic and the race condition
> is a lot more complex. The fix is to add the context to the
> committing list before we start emptying the CIL. This allows us to
> detect the difference between an empty "do nothing" push and a push
> that has not started by adding a discrete "emptying the CIL" state
> to avoid the transient, incorrect "empty" condition that the
> (unchanged) waiting code was seeing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Tested-by: Eric Sandeen <esandeen@redhat.com>
> ---

The pusher side queues the work, acquires xc_push_lock, walks the
committing list and then does this:

	if (sequence == cil->xc_current_sequence &&
	    !list_empty(&cil->xc_cil)) {
		spin_unlock(&cil->xc_push_lock);
		goto restart;
	}

... which is effectively peeking into the cil state to see if the push
actually needed to do anything. The purpose is to identify the case
where the push hasn't occurred and the previous committing list
traversal was insufficient.

The "pushee" side drains the cil, updates the current sequence and adds
the ctx to the committing list. The time between the cil drain and
list_add() creates a window where, according to the logic above, the cil
push looks like it wasn't going to do anything from the pusher
perspective. The latter two bits occur under xc_push_lock (spinlock), so
perhaps that widens a window to make this slightly more reproducible.

The pushee work is all done under xc_ctx_lock, so generally this is an
issue because the pusher doesn't acquire xc_ctx_lock, and thus the cil
drain and ctx update are not seen as atomic. I presume this is lockless
by design, so taking the lock is not a desired solution.

Therefore, the order of changes to data structures that the pusher peeks
into is updated on the pushee side to add to the committing list, drain
the cil and update the current sequence number.

For the pusher side, this means the committing list walk and logic above
(all under xc_push_lock) either sees the ctx on the list or not. If the
ctx is on the list, then we waited for it and there is no race. If the
ctx is not on the list, it is either populated and waiting to be added
to the list (e.g., we hold xc_push_lock) or empty and there's nothing to
do (regardless of whether the pusher side has run or not).

That seems sound to me. It would be nice of we could somehow make this
explicitly more simple rather than dependent on complex ordering (e.g.,
a push completion or something of that sort), but that's for another
time. One nit below...

>  fs/xfs/xfs_log_cil.c | 47 ++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f6b79e5..f506c45 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -463,12 +463,40 @@ xlog_cil_push(
>  		spin_unlock(&cil->xc_push_lock);
>  		goto out_skip;
>  	}
> -	spin_unlock(&cil->xc_push_lock);
>  
>  
>  	/* check for a previously pushed seqeunce */
> -	if (push_seq < cil->xc_ctx->sequence)
> +	if (push_seq < cil->xc_ctx->sequence) {
> +		spin_unlock(&cil->xc_push_lock);
>  		goto out_skip;
> +	}
> +

Looks like out_skip could unlock xc_push_lock now.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	/*
> +	 * We are now going to push this context, so add it to the committing
> +	 * list before we do anything else. This ensures that anyone waiting on
> +	 * this push can easily detect the difference between a "push in
> +	 * progress" and "CIL is empty, nothing to do".
> +	 *
> +	 * IOWs, a wait loop can now check for:
> +	 *	the current sequence not being found on the committing list;
> +	 *	an empty CIL; and
> +	 *	an unchanged sequence number
> +	 * to detect a push that had nothing to do and therefore does not need
> +	 * waiting on. If the CIL is not empty, we get put on the committing
> +	 * list before emptying the CIL and bumping the sequence number. Hence
> +	 * an empty CIL and an unchanged sequence number means we jumped out
> +	 * above after doing nothing.
> +	 *
> +	 * Hence the waiter will either find the commit sequence on the
> +	 * committing list or the sequence number will be unchanged and the CIL
> +	 * still dirty. In that latter case, the push has not yet started, and
> +	 * so the waiter will have to continue trying to check the CIL
> +	 * committing list until it is found. In extreme cases of delay, the
> +	 * sequence may fully commit between the attempts the wait makes to wait
> +	 * on the commit sequence.
> +	 */
> +	list_add(&ctx->committing, &cil->xc_committing);
> +	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
>  	 * pull all the log vectors off the items in the CIL, and
> @@ -532,7 +560,6 @@ xlog_cil_push(
>  	 */
>  	spin_lock(&cil->xc_push_lock);
>  	cil->xc_current_sequence = new_ctx->sequence;
> -	list_add(&ctx->committing, &cil->xc_committing);
>  	spin_unlock(&cil->xc_push_lock);
>  	up_write(&cil->xc_ctx_lock);
>  
> @@ -855,13 +882,15 @@ restart:
>  	 * Hence by the time we have got here it our sequence may not have been
>  	 * pushed yet. This is true if the current sequence still matches the
>  	 * push sequence after the above wait loop and the CIL still contains
> -	 * dirty objects.
> +	 * dirty objects. This is guaranteed by the push code first adding the
> +	 * context to the committing list before emptying the CIL.
>  	 *
> -	 * When the push occurs, it will empty the CIL and atomically increment
> -	 * the currect sequence past the push sequence and move it into the
> -	 * committing list. Of course, if the CIL is clean at the time of the
> -	 * push, it won't have pushed the CIL at all, so in that case we should
> -	 * try the push for this sequence again from the start just in case.
> +	 * Hence if we don't find the context in the committing list and the
> +	 * current sequence number is unchanged then the CIL contents are
> +	 * significant.  If the CIL is empty, if means there was nothing to push
> +	 * and that means there is nothing to wait for. If the CIL is not empty,
> +	 * it means we haven't yet started the push, because if it had started
> +	 * we would have found the context on the committing list.
>  	 */
>  	if (sequence == cil->xc_current_sequence &&
>  	    !list_empty(&cil->xc_cil)) {
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
