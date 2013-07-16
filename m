Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02B0C7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 19:55:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2B1C8F8033
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 17:55:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	z43smmqpN00wAcdi for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 17:54:59 -0700 (PDT)
Date: Tue, 16 Jul 2013 10:54:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix a deadlock in xfs_log_commit_cil() code path
Message-ID: <20130716005455.GC3920@dastard>
References: <1373928754.20769.41.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373928754.20769.41.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Mon, Jul 15, 2013 at 05:52:34PM -0500, Chandra Seetharaman wrote:
> While testing and rearranging my pquota/gquota code, I stumbled
> on a xfs_shutdown() during a mount. But the mount just hung.
> 
> I debugged and found that there is a deadlock involving
> &log->l_cilp->xc_ctx_lock.
> 
> It is in a code path where &log->l_cilp->xc_ctx_lock is first
> acquired in read mode and some levels down the same semaphore
> is being acquired in write mode causing a deadlock.
> 
> This is the stack:
> xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
>   xlog_print_tic_res
>     xfs_force_shutdown
>       xfs_log_force_umount
>         xlog_cil_force
>           xlog_cil_force_lsn
>             xlog_cil_push_foreground
>               xlog_cil_push - tries to acquire same semaphore in write mode
> 
> This patch fixes the deadlock by not calling xfs_force_shutdown() while
> holding the semaphore, instead calling it after dropping teh semaphore.
> 
> Thanks to Dave for suggesting this solution.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> ---
>  fs/xfs/xfs_log.c      |    6 +++---
>  fs/xfs/xfs_log_cil.c  |   10 ++++++----
>  fs/xfs/xfs_log_priv.h |    2 +-
>  fs/xfs/xfs_trans.c    |    2 +-
>  4 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d852a2b..b9fa2da 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1837,7 +1837,7 @@ xlog_state_finish_copy(
>   * print out info relating to regions written which consume
>   * the reservation
>   */
> -void
> +int
>  xlog_print_tic_res(
>  	struct xfs_mount	*mp,
>  	struct xlog_ticket	*ticket)
> @@ -1941,7 +1941,7 @@ xlog_print_tic_res(
>  
>  	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
>  		"xlog_write: reservation ran out. Need to up reservation");
> -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	return EFSCORRUPTED;

Note the "SHUTDOWN_CORRUPT_INCORE" reason given here....

> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 35a2299..d96022f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1547,7 +1547,7 @@ xfs_trans_commit(
>  	xfs_trans_apply_dquot_deltas(tp);
>  
>  	error = xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
> -	if (error == ENOMEM) {
> +	if (error) {
>  		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);

Which is different to the reason given here. The shutdown reason
should be maintained for this particular error....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
