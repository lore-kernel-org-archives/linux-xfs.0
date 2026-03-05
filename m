Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54994354AC7;
	Thu,  5 Mar 2026 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772747396; cv=none; b=DK/J/m/tfx4nqfxiQxm2Vm57d1Gl3WvknzJiBwtaw7I4TpaB7HPKYogDTSGLbKDgBj8QWffml65WI1Pw3en7auTZa6kh/AtVy3SlcD2msZgI7lqI60oKQS42Ia9uySYxvgn5tOV2Ok17F8O3L9VpH9IccMFm9jU0MuMb1RBNQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772747396; c=relaxed/simple;
	bh=3/t4bdbqokSl/X8GtHRwTOf3R8xbOYBso+1WOELuR7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyoccI83vr3ZolFr5EXOfQDrqcWeFZ3c5Honxn0C214E7F6J2sE4d0W8/0DG+ABj4ixczNa2JJz24v0+wDclS5DPdPoLKqY6hWIzG2bjptuaI+i+oldtbrA5Jc7uH+sh3yBBSJteGrA1rgyO+Qv9tgNMPy0FQWR7djkOOc5fQDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsxlvzQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsxlvzQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FDFC116C6;
	Thu,  5 Mar 2026 21:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772747395;
	bh=3/t4bdbqokSl/X8GtHRwTOf3R8xbOYBso+1WOELuR7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UsxlvzQ9KXgtMtIpPJ+zqFJEuvlmuPmSwCwsHOviZBVX8ZtXf0GaldknmJueqrQxu
	 nVAmlJmdUQPrBbScEB8yyDBb2U22ATs1L7brIpCNuKkvZIkOod//2ql9331i2vOnqJ
	 1qVkewAt9KFSZw6mery+wgb39Nh1/KfkjvM/0SgsIpeth3+lTeZ/GcEk18rE9rHXr0
	 tLjvO2Kf2yA9cyv05j78v7Od/o4jqzxK/BNceiRvKHdHU8BqzJvHYkCHSjGK+1A1Lp
	 HYIr4wu7MokP4H/gr4ArtMa/kBmRxGwiTv+PQM/hNlsQPdD2jfvamAkEPxOM9aIZ8j
	 hGe6rqtmtX/Jg==
Date: Fri, 6 Mar 2026 08:49:45 +1100
From: Dave Chinner <dgc@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix use-after-free of log items during AIL
 pushing
Message-ID: <aan6eeNwMnBcRzhn@dread>
References: <20260305185836.56478-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305185836.56478-2-ytohnuki@amazon.com>

On Thu, Mar 05, 2026 at 06:58:37PM +0000, Yuto Ohnuki wrote:
> When a filesystem is shut down, background inode reclaim and the xfsaild
> can race to abort and free dirty inodes. During xfs_iflush_cluster(), if
> the filesystem is shut down, individual inodes are aborted, marked clean
> and removed from the AIL. When the buffer is subsequently failed via
> xfs_buf_ioend_fail(), the buffer is unlocked and pending inode reclaim
> can make progress.
> 
> If the xfsaild is then preempted long enough for reclaim to complete its
> work and the RCU grace period to expire, the inode and its log item are
> freed before the xfsaild reacquires the AIL lock. This results in a
> use-after-free when dereferencing the log item's li_ailp pointer at
> offset 48.
> 
> Since commit 90c60e164012 ("xfs: xfs_iflush() is no longer necessary"),
> xfs_inode_item_push() no longer holds ILOCK_SHARED while flushing,
> removing the protection that prevented the inode from being reclaimed
> during the flush.
> 
> xfs_dquot_item_push() has the same issue, as dquots can be reclaimed
> asynchronously via a memory pressure driven shrinker while the AIL lock
> is temporarily dropped.
> 
> The unmount sequence in xfs_unmount_flush_inodes() also contributes to
> the race by pushing the AIL while background reclaim and inodegc are
> still running.
> 
> Additionally, all tracepoints in the xfsaild_push() switch statement
> dereference the log item after xfsaild_push_item() returns, when the
> item may already be freed. The UAF is most likely when
> xfs_iflush_cluster() returns -EIO and XFS_ITEM_LOCKED is returned.
> 
> Fix this by:
> - Reordering xfs_unmount_flush_inodes() to stop background reclaim and
>   inodegc before pushing the AIL.
> - Saving the ailp pointer in local variables in xfs_inode_item_push()
>   and xfs_dquot_item_push() when the AIL lock is held and the log item
>   is guaranteed to be valid.
> - Capturing log item fields before calling xfsaild_push_item() so that
>   tracepoints do not dereference potentially freed log items.
>   A new xfs_ail_push_class trace event class is introduced for this
>   purpose, while the existing xfs_log_item_class remains unchanged to
>   preserve compatibility.
> - Adding comments documenting that log items must not be referenced
>   after iop_push() returns.

I think this should be broken up into separate commits. Certainly
the unmount changes should be a standalone commit...

> Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
> Changes in v2:
> - Reordered xfs_unmount_flush_inodes() to stop reclaim before pushing
>   AIL suggested by Dave Chinner
> - Introduced xfs_ail_push_class trace event to avoid dereferencing
>   freed log items in tracepoints
> - Added comments documenting that log items must not be referenced
>   after iop_push() returns
> - Saved ailp pointer in local variables in push functions
> - Link to v1: https://lore.kernel.org/all/20260304162405.58017-2-ytohnuki@amazon.com/
> ---
>  fs/xfs/xfs_dquot_item.c | 10 ++++++++--
>  fs/xfs/xfs_inode_item.c |  9 +++++++--
>  fs/xfs/xfs_mount.c      |  4 ++--
>  fs/xfs/xfs_trace.h      | 35 +++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_trans_ail.c  | 28 ++++++++++++++++++++++++----
>  5 files changed, 72 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 491e2a7053a3..223e7162db02 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -125,6 +125,7 @@ xfs_qm_dquot_logitem_push(
>  	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
>  	struct xfs_dquot	*dqp = qlip->qli_dquot;
>  	struct xfs_buf		*bp;
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> @@ -153,7 +154,12 @@ xfs_qm_dquot_logitem_push(
>  		goto out_unlock;
>  	}
>  
> -	spin_unlock(&lip->li_ailp->ail_lock);
> +	/*
> +	 * After dropping the AIL lock, the log item may be freed via
> +	 * memory pressure driven shrinker. Do not reference lip after
> +	 * this point.
> +	 */
> +	spin_unlock(&ailp->ail_lock);

Not true. We hold the buffer lock here, which prevents reclaim from
removing the log item from the buffer. Hence the point at which it
becomes unsafe to reference the log item is when the cluster buffer
lock is dropped. i.e.:

>  
>  	error = xfs_dquot_use_attached_buf(dqp, &bp);
>  	if (error == -EAGAIN) {
> @@ -174,7 +180,7 @@ xfs_qm_dquot_logitem_push(
>  	xfs_buf_relse(bp);
>  
>  out_relock_ail:
> -	spin_lock(&lip->li_ailp->ail_lock);
> +	spin_lock(&ailp->ail_lock);

the log item only becomes unsafe to reference after the call to
xfs_buf_relse() just above the code that regains the AIL lock.

>  out_unlock:
>  	mutex_unlock(&dqp->q_qlock);
>  	return rval;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 8913036b8024..f584e0a2f174 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -746,6 +746,7 @@ xfs_inode_item_push(
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	struct xfs_buf		*bp = lip->li_buf;
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> @@ -771,7 +772,11 @@ xfs_inode_item_push(
>  	if (!xfs_buf_trylock(bp))
>  		return XFS_ITEM_LOCKED;
>  
> -	spin_unlock(&lip->li_ailp->ail_lock);
> +	/*
> +	 * After dropping the AIL lock, the log item may be freed via
> +	 * RCU callback. Do not reference lip after this point.
> +	 */
> +	spin_unlock(&ailp->ail_lock);

Same for the inode log item here - it's when the cluster buffer is
unlocked that the log item can be freed from under us.

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9c295abd0a0a..786e1fc720e5 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -621,9 +621,9 @@ xfs_unmount_flush_inodes(
>  
>  	xfs_set_unmounting(mp);
>  
> -	xfs_ail_push_all_sync(mp->m_ail);
> -	xfs_inodegc_stop(mp);
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> +	xfs_inodegc_stop(mp);
> +	xfs_ail_push_all_sync(mp->m_ail);
>  	xfs_reclaim_inodes(mp);
>  	xfs_health_unmount(mp);
>  	xfs_healthmon_unmount(mp);

This should be in it's own patch.

> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 813e5a9f57eb..ee4b72878f7b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1646,14 +1646,41 @@ TRACE_EVENT(xfs_log_force,
>  		  __entry->lsn, (void *)__entry->caller_ip)
>  )
>  
> +DECLARE_EVENT_CLASS(xfs_ail_push_class,
> +	TP_PROTO(dev_t dev, uint type, unsigned long flags, xfs_lsn_t lsn),
> +	TP_ARGS(dev, type, flags, lsn),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(uint, type)
> +		__field(unsigned long, flags)
> +		__field(xfs_lsn_t, lsn)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = dev;
> +		__entry->type = type;
> +		__entry->flags = flags;
> +		__entry->lsn = lsn;
> +	),
> +	TP_printk("dev %d:%d lsn %d/%d type %s flags %s",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  CYCLE_LSN(__entry->lsn), BLOCK_LSN(__entry->lsn),
> +		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
> +		  __print_flags(__entry->flags, "|", XFS_LI_FLAGS))
> +)
> +
> +#define DEFINE_AIL_PUSH_EVENT(name) \
> +DEFINE_EVENT(xfs_ail_push_class, name, \
> +	TP_PROTO(dev_t dev, uint type, unsigned long flags, xfs_lsn_t lsn), \
> +	TP_ARGS(dev, type, flags, lsn))
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_push);
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_pinned);
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_locked);
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_flushing);
> +
>  #define DEFINE_LOG_ITEM_EVENT(name) \
>  DEFINE_EVENT(xfs_log_item_class, name, \
>  	TP_PROTO(struct xfs_log_item *lip), \
>  	TP_ARGS(lip))
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);

Move the definition of the xfs_ail_push_class to after the
definition of the log item event trace points. i.e. the log item
event definitions should be grouped with the definition of the log
item event class, not have a whole new event class and trace event
definitions between the class definition and event definitions...

> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 923729af4206..48b14146826b 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -387,6 +387,11 @@ xfsaild_push_item(
>  		return XFS_ITEM_PINNED;
>  	if (test_bit(XFS_LI_FAILED, &lip->li_flags))
>  		return xfsaild_resubmit_item(lip, &ailp->ail_buf_list);
> +
> +	/*
> +	 * Once iop_push() returns, the log item may have been freed
> +	 * and must not be dereferenced.
> +	 */
>  	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
>  }

This should really be a comment in the header describing the
funciton behaviour. i.e. something like: "@lip may have been
released and freed by the time this function returns, so callers
must not dereference the log item after calling this function."

>  
> @@ -506,20 +511,35 @@ xfsaild_push(
>  	lsn = lip->li_lsn;
>  	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
>  		int	lock_result;
> +		dev_t dev;
> +		uint type;
> +		unsigned long flags;
> +		xfs_lsn_t item_lsn;
>  
>  		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
>  			goto next_item;
>  
> +		/*
> +		 * Store log item information before pushing, as the item
> +		 * may be freed after dropping the AIL lock.
> +		 */
> +		dev = lip->li_log->l_mp->m_super->s_dev;

Don't need dev - we can get to it from the ailp structure. i.e.
the tracepoints can be passed the ailp and so the dev part of the
tracepoint can remain hidden from this code (as it should be).

> +		type = lip->li_type;
> +		flags = lip->li_flags;
> +		item_lsn = lip->li_lsn;
> +
>  		/*
>  		 * Note that iop_push may unlock and reacquire the AIL lock.  We
>  		 * rely on the AIL cursor implementation to be able to deal with
>  		 * the dropped lock.
> +		 * After this call returns, the log item may have been freed and
> +		 * must not be referenced.
>  		 */
>  		lock_result = xfsaild_push_item(ailp, lip);
>  		switch (lock_result) {
>  		case XFS_ITEM_SUCCESS:
>  			XFS_STATS_INC(mp, xs_push_ail_success);
> -			trace_xfs_ail_push(lip);
> +			trace_xfs_ail_push(dev, type, flags, item_lsn);
>  
>  			ailp->ail_last_pushed_lsn = lsn;
>  			break;
> @@ -537,7 +557,7 @@ xfsaild_push(
>  			 * AIL is being flushed.
>  			 */
>  			XFS_STATS_INC(mp, xs_push_ail_flushing);
> -			trace_xfs_ail_flushing(lip);
> +			trace_xfs_ail_flushing(dev, type, flags, item_lsn);
>  
>  			flushing++;
>  			ailp->ail_last_pushed_lsn = lsn;
> @@ -545,14 +565,14 @@ xfsaild_push(
>  
>  		case XFS_ITEM_PINNED:
>  			XFS_STATS_INC(mp, xs_push_ail_pinned);
> -			trace_xfs_ail_pinned(lip);
> +			trace_xfs_ail_pinned(dev, type, flags, item_lsn);
>  
>  			stuck++;
>  			ailp->ail_log_flush++;
>  			break;
>  		case XFS_ITEM_LOCKED:
>  			XFS_STATS_INC(mp, xs_push_ail_locked);
> -			trace_xfs_ail_locked(lip);
> +			trace_xfs_ail_locked(dev, type, flags, item_lsn);
>  
>  			stuck++;
>  			break;

At this point, xfsaild_push() is getting too long to easily read and
understand.

I think that we should factor the entire loop contents into a
separate function so the loop looks like this:

  	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {

		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);

		count++;
                                                                                 
                /*                                                               
                 * Are there too many items we can't do anything with?           
                 *                                                               
                 * If we are skipping too many items because we can't flush      
                 * them or they are already being flushed, we back off and       
                 * given them time to complete whatever operation is being       
                 * done. i.e. remove pressure from the AIL while we can't make   
                 * progress so traversals don't slow down further inserts and    
                 * removals to/from the AIL.                                     
                 *                                                               
                 * The value of 100 is an arbitrary magic number based on        
                 * observation.                                                  
                 */                                                              
                if (stuck > 100)                                                 
                        break;                                                   
                                                                                 
                lip = xfs_trans_ail_cursor_next(ailp, &cur);                     
                if (lip == NULL)                                                 
                        break;                                                   
                if (lip->li_lsn != lsn && count > 1000)                          
                        break;                                                   
                lsn = lip->li_lsn;                                               
        }                                                                        

Probably worth doing that as a separate patch, then adding the
modifications to fix the bug as a followup patch.

-Dave.

-- 
Dave Chinner
dgc@kernel.org
