Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52240 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfGCNzi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 09:55:38 -0400
Subject: Re: [PATCH] fs: xfs: xfs_log: Change return type from int to void
References: <20190702181547.GA11316@hari-Inspiron-1545>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5d3ee4bb-59aa-b1bb-41b5-4e0d80f1638f@sandeen.net>
Date: Wed, 3 Jul 2019 08:55:35 -0500
MIME-Version: 1.0
In-Reply-To: <20190702181547.GA11316@hari-Inspiron-1545>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 7/2/19 1:15 PM, Hariprasad Kelam wrote:
> Change return types of below functions as they never fails
> xfs_log_mount_cancel
> xlog_recover_cancel
> xlog_recover_cancel_intents
> 
> fix below issue reported by coccicheck
> fs/xfs/xfs_log_recover.c:4886:7-12: Unneeded variable: "error". Return
> "0" on line 4926
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Looks fine, the highest caller in the chain (calling
xfs_log_mount_cancel) doesn't use the return value, either.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_log.c         |  8 ++------
>  fs/xfs/xfs_log.h         |  2 +-
>  fs/xfs/xfs_log_priv.h    |  2 +-
>  fs/xfs/xfs_log_recover.c | 12 +++---------
>  4 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index cbaf348..00e9f5c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -769,16 +769,12 @@ xfs_log_mount_finish(
>   * The mount has failed. Cancel the recovery if it hasn't completed and destroy
>   * the log.
>   */
> -int
> +void
>  xfs_log_mount_cancel(
>  	struct xfs_mount	*mp)
>  {
> -	int			error;
> -
> -	error = xlog_recover_cancel(mp->m_log);
> +	xlog_recover_cancel(mp->m_log);
>  	xfs_log_unmount(mp);
> -
> -	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index f27b1cb..84e0680 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -117,7 +117,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
>  			xfs_daddr_t		start_block,
>  			int		 	num_bblocks);
>  int	  xfs_log_mount_finish(struct xfs_mount *mp);
> -int	xfs_log_mount_cancel(struct xfs_mount *);
> +void	xfs_log_mount_cancel(struct xfs_mount *);
>  xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
>  xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
>  void	  xfs_log_space_wake(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 8acacbc..b880c23 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -418,7 +418,7 @@ xlog_recover(
>  extern int
>  xlog_recover_finish(
>  	struct xlog		*log);
> -extern int
> +extern void
>  xlog_recover_cancel(struct xlog *);
>  
>  extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1fc70ac..13d1d3e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4875,12 +4875,11 @@ xlog_recover_process_intents(
>   * A cancel occurs when the mount has failed and we're bailing out.
>   * Release all pending log intent items so they don't pin the AIL.
>   */
> -STATIC int
> +STATIC void
>  xlog_recover_cancel_intents(
>  	struct xlog		*log)
>  {
>  	struct xfs_log_item	*lip;
> -	int			error = 0;
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_ail		*ailp;
>  
> @@ -4920,7 +4919,6 @@ xlog_recover_cancel_intents(
>  
>  	xfs_trans_ail_cursor_done(&cur);
>  	spin_unlock(&ailp->ail_lock);
> -	return error;
>  }
>  
>  /*
> @@ -5779,16 +5777,12 @@ xlog_recover_finish(
>  	return 0;
>  }
>  
> -int
> +void
>  xlog_recover_cancel(
>  	struct xlog	*log)
>  {
> -	int		error = 0;
> -
>  	if (log->l_flags & XLOG_RECOVERY_NEEDED)
> -		error = xlog_recover_cancel_intents(log);
> -
> -	return error;
> +		xlog_recover_cancel_intents(log);
>  }
>  
>  #if defined(DEBUG)
> 
