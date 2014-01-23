Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 98F6C7F7D
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 12:40:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E7A68F8033
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 10:40:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6OHDLNBg1TIoZ0OX for
	<xfs@oss.sgi.com>; Thu, 23 Jan 2014 10:40:29 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0NIeReR011029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 13:40:28 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0NIeRt0024318
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 13:40:27 -0500
Message-ID: <52E1621A.6070006@redhat.com>
Date: Thu, 23 Jan 2014 13:40:26 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: convert xfs_log_commit_cil() to void
References: <52E10BED.8090607@oracle.com>
In-Reply-To: <52E10BED.8090607@oracle.com>
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
To: xfs@oss.sgi.com

On 01/23/2014 07:32 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Convert xfs_log_commit_cil() to a void function since it return nothing
> but 0 in any case, after that we can simplify the relative code logic
> in xfs_trans_commit() accordingly.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---

9 less lines. ;)

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.h     |  2 +-
>  fs/xfs/xfs_log_cil.c |  3 +--
>  fs/xfs/xfs_trans.c   | 12 ++----------
>  3 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index e148719..67927c3 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -129,7 +129,7 @@ void	  xlog_iodone(struct xfs_buf *);
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
>  void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
>  
> -int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
> +void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
>  				xfs_lsn_t *commit_lsn, int flags);
>  bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5eb51fc..bb1027a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -740,7 +740,7 @@ xlog_cil_empty(
>   * background commit, returns without it held once background commits are
>   * allowed again.
>   */
> -int
> +void
>  xfs_log_commit_cil(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> @@ -786,7 +786,6 @@ xfs_log_commit_cil(
>  	xlog_cil_push_background(log);
>  
>  	up_read(&cil->xc_ctx_lock);
> -	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index c812c5c..54a5732 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -887,12 +887,7 @@ xfs_trans_commit(
>  		xfs_trans_apply_sb_deltas(tp);
>  	xfs_trans_apply_dquot_deltas(tp);
>  
> -	error = xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
> -	if (error == ENOMEM) {
> -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> -		error = XFS_ERROR(EIO);
> -		goto out_unreserve;
> -	}
> +	xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
>  
>  	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
>  	xfs_trans_free(tp);
> @@ -902,10 +897,7 @@ xfs_trans_commit(
>  	 * log out now and wait for it.
>  	 */
>  	if (sync) {
> -		if (!error) {
> -			error = _xfs_log_force_lsn(mp, commit_lsn,
> -				      XFS_LOG_SYNC, NULL);
> -		}
> +		error = _xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
>  		XFS_STATS_INC(xs_trans_sync);
>  	} else {
>  		XFS_STATS_INC(xs_trans_async);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
