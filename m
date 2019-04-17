Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48993 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728074AbfDQVIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 17:08:55 -0400
Date: Thu, 18 Apr 2019 07:08:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: widen quota block counters to 64-bit integers
Message-ID: <20190417210850.GO29573@dread.disaster.area>
References: <155546518260.176148.16583864799178682873.stgit@magnolia>
 <155546518873.176148.11756573764233413857.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155546518873.176148.11756573764233413857.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 16, 2019 at 06:39:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Widen the incore quota transaction delta structure to treat block
> counters as 64-bit integers.  This is a necessary addition so that we
> can widen the i_delayed_blks counter to be a 64-bit integer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_qm.h          |    8 ++------
>  fs/xfs/xfs_quota.h       |   31 +++++++++++++++++--------------
>  fs/xfs/xfs_trans_dquot.c |   28 ++++++++++++++--------------
>  3 files changed, 33 insertions(+), 34 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 3ccf0fbc9071..b41b75089548 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -113,12 +113,8 @@ xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
>  	return NULL;
>  }
>  
> -extern void	xfs_trans_mod_dquot(struct xfs_trans *,
> -					struct xfs_dquot *, uint, long);
> -extern int	xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
> -			struct xfs_mount *, struct xfs_dquot *,
> -			struct xfs_dquot *, struct xfs_dquot *,
> -			long, long, uint);
> +extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
> +				    uint field, int64_t delta);
>  extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
>  extern void	xfs_trans_log_dquot(struct xfs_trans *, struct xfs_dquot *);
>  
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 55b798265ef7..215cb39e3a04 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -58,30 +58,33 @@ xfs_quota_chkd_flag(
>   */
>  typedef struct xfs_dqtrx {
>  	struct xfs_dquot *qt_dquot;	  /* the dquot this refers to */
> -	ulong		qt_blk_res;	  /* blks reserved on a dquot */
> -	ulong		qt_ino_res;	  /* inode reserved on a dquot */
> -	ulong		qt_ino_res_used;  /* inodes used from the reservation */
> -	long		qt_bcount_delta;  /* dquot blk count changes */
> -	long		qt_delbcnt_delta; /* delayed dquot blk count changes */
> +
> +	uint64_t	qt_blk_res;	  /* blks reserved on a dquot */
> +	int64_t		qt_bcount_delta;  /* dquot blk count changes */
> +	int64_t		qt_delbcnt_delta; /* delayed dquot blk count changes */
> +
> +	uint64_t	qt_rtblk_res;	  /* # blks reserved on a dquot */
> +	uint64_t	qt_rtblk_res_used;/* # blks used from reservation */
> +	int64_t		qt_rtbcount_delta;/* dquot realtime blk changes */
> +	int64_t		qt_delrtb_delta;  /* delayed RT blk count changes */
> +
> +	unsigned long	qt_ino_res;	  /* inode reserved on a dquot */
> +	unsigned long	qt_ino_res_used;  /* inodes used from the reservation */

Canyou get rid of the ulongs here and make them explicit? uint32_t
should be large enough for them, but it might just be simpler to
make everything 64 bit variables.

ANd that....

>  		/*
>  		 * inode reservation
>  		 */
>  	      case XFS_TRANS_DQ_RES_INOS:
> -		qtrx->qt_ino_res += (ulong)delta;
> +		qtrx->qt_ino_res += (unsigned long)delta;
>  		break;
>  
>  		/*
> @@ -245,7 +245,7 @@ xfs_trans_mod_dquot(
>  		 */
>  	      case XFS_TRANS_DQ_ICOUNT:
>  		if (qtrx->qt_ino_res && delta > 0) {
> -			qtrx->qt_ino_res_used += (ulong)delta;
> +			qtrx->qt_ino_res_used += (unsigned long)delta;
>  			ASSERT(qtrx->qt_ino_res >= qtrx->qt_ino_res_used);

would get rid of these casts, too.

But, otherwise, this is a long overdue cleanup :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
