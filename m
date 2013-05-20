Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 477347F59
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 12:58:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31986304053
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:58:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aGNB8ASuWJWKKwrp for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 10:58:57 -0700 (PDT)
Message-ID: <519A655D.4020001@redhat.com>
Date: Mon, 20 May 2013 14:03:09 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/14] xfs: avoid nesting transactions in
	xfs_qm_scall_setqlim()
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-5-git-send-email-david@fromorbit.com>
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

On 05/19/2013 07:51 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Lockdep reports:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.9.0+ #3 Not tainted
> ---------------------------------------------
> setquota/28368 is trying to acquire lock:
>  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
> 
> but task is already holding lock:
>  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
> 
> from xfs_qm_scall_setqlim()->xfs_dqread() when a dquot needs to be
> allocated.
> 
> xfs_qm_scall_setqlim() is starting a transaction and then not
> passing it into xfs_qm_dqet() and so it starts it's own transaction
> when allocating the dquot.  Splat!
> 
> Fix this by not allocating the dquot in xfs_qm_scall_setqlim()
> inside the setqlim transaction. This requires getting the dquot
> first (and allocating it if necessary) then dropping and relocking
> the dquot before joining it to the setqlim transaction.
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c |   35 ++++++++++++++++++++---------------
>  1 file changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index c41190c..dfa5c05 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -489,31 +489,36 @@ xfs_qm_scall_setqlim(
>  	if ((newlim->d_fieldmask & XFS_DQ_MASK) == 0)
>  		return 0;
>  
> -	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
> -	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
> -				  0, 0, XFS_DEFAULT_LOG_COUNT);
> -	if (error) {
> -		xfs_trans_cancel(tp, 0);
> -		return (error);
> -	}
> -
>  	/*
>  	 * We don't want to race with a quotaoff so take the quotaoff lock.
> -	 * (We don't hold an inode lock, so there's nothing else to stop
> -	 * a quotaoff from happening). (XXXThis doesn't currently happen
> -	 * because we take the vfslock before calling xfs_qm_sysent).
> +	 * We don't hold an inode lock, so there's nothing else to stop
> +	 * a quotaoff from happening.
>  	 */
>  	mutex_lock(&q->qi_quotaofflock);
>  
>  	/*
> -	 * Get the dquot (locked), and join it to the transaction.
> -	 * Allocate the dquot if this doesn't exist.
> +	 * Get the dquot (locked) before we start, as we need to do a
> +	 * transaction to allocate it if it doesn't exist. Once we have the
> +	 * dquot, unlock it so we can start the next transaction safely. We hold
> +	 * a reference to the dquot, so it's safe to do this unlock/lock without
> +	 * it being reclaimed in the mean time.
>  	 */
> -	if ((error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp))) {
> -		xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> +	error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp);
> +	if (error) {
>  		ASSERT(error != ENOENT);
>  		goto out_unlock;
>  	}
> +	xfs_dqunlock(dqp);
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
> +	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
> +				  0, 0, XFS_DEFAULT_LOG_COUNT);
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		goto out_unlock;

By shuffling the transaction allocation and xfs_qm_dqget() around, it
looks like you now have an error path with a referenced dquot. Perhaps
here we should jump to a new label that includes the xfs_qm_dqrele() at
the end of the function?

Brian

> +	}
> +
> +	xfs_dqlock(dqp);
>  	xfs_trans_dqjoin(tp, dqp);
>  	ddq = &dqp->q_core;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
