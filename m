Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41065 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdGADEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 23:04:07 -0400
Date: Fri, 30 Jun 2017 20:03:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: add log item pinning error injection tag
Message-ID: <20170701030356.GS5874@birch.djwong.org>
References: <1498574436-57561-1-git-send-email-bfoster@redhat.com>
 <1498574436-57561-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498574436-57561-5-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 27, 2017 at 10:40:36AM -0400, Brian Foster wrote:
> Add an error injection tag to force log items in the AIL to the
> pinned state. This option can be used by test infrastructure to
> induce head behind tail conditions. Specifically, this is intended
> to be used by xfstests to reproduce log recovery problems after
> failed/corrupted log writes overwrite the last good tail LSN in the
> log.
> 
> When enabled, AIL push attempts see log items in the AIL in the
> pinned state. This stalls metadata writeback and thus prevents the
> current tail of the log from moving forward. When disabled,
> subsequent AIL pushes observe the log items in their appropriate
> state and filesystem operation continues as normal.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_error.c     |  3 +++
>  fs/xfs/xfs_error.h     |  4 +++-
>  fs/xfs/xfs_trans_ail.c | 17 ++++++++++++++++-
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 26c32bc..f2f22a8 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_AG_RESV_CRITICAL,
>  	XFS_RANDOM_DROP_WRITES,
>  	XFS_RANDOM_LOG_BAD_CRC,
> +	XFS_RANDOM_LOG_ITEM_PIN,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -161,6 +162,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
>  XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
>  XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
>  XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
> +XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -193,6 +195,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
>  	XFS_ERRORTAG_ATTR_LIST(drop_writes),
>  	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
> +	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
>  	NULL,
>  };
>  
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 0874d6b..43d349c 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -107,8 +107,9 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
>   */
>  #define XFS_ERRTAG_DROP_WRITES				28
>  #define XFS_ERRTAG_LOG_BAD_CRC				29
> +#define XFS_ERRTAG_LOG_ITEM_PIN				30
>  
> -#define XFS_ERRTAG_MAX					30
> +#define XFS_ERRTAG_MAX					31
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -143,6 +144,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
>  #define XFS_RANDOM_AG_RESV_CRITICAL			4
>  #define XFS_RANDOM_DROP_WRITES				1
>  #define XFS_RANDOM_LOG_BAD_CRC				1
> +#define XFS_RANDOM_LOG_ITEM_PIN				1
>  
>  #ifdef DEBUG
>  extern int xfs_errortag_init(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 9056c0f..563b315 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -325,6 +325,21 @@ xfs_ail_delete(
>  	xfs_trans_ail_cursor_clear(ailp, lip);
>  }
>  
> +static inline uint
> +xfsaild_push_item(
> +	struct xfs_ail		*ailp,
> +	struct xfs_log_item	*lip)
> +{
> +	/*
> +	 * If log item pinning is enabled, skip the push and track the item as
> +	 * pinned. This can help induce head-behind-tail conditions.
> +	 */
> +	if (XFS_TEST_ERROR(false, ailp->xa_mount, XFS_ERRTAG_LOG_ITEM_PIN))
> +		return XFS_ITEM_PINNED;
> +
> +	return lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
> +}
> +
>  static long
>  xfsaild_push(
>  	struct xfs_ail		*ailp)
> @@ -382,7 +397,7 @@ xfsaild_push(
>  		 * rely on the AIL cursor implementation to be able to deal with
>  		 * the dropped lock.
>  		 */
> -		lock_result = lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
> +		lock_result = xfsaild_push_item(ailp, lip);
>  		switch (lock_result) {
>  		case XFS_ITEM_SUCCESS:
>  			XFS_STATS_INC(mp, xs_push_ail_success);
> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
