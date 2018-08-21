Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbeHUQnu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Aug 2018 12:43:50 -0400
Date: Tue, 21 Aug 2018 09:23:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/10] xfs: replace XFS_FORCED_SHUTDOWN with
 xfs_is_shut_down
Message-ID: <20180821132339.GE15030@bfoster>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180820044851.414-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 20, 2018 at 02:48:47PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Remove the shouty macro and instead use the inline function that
> matches other state/feature check wrapper naming. This conversion
> was done with sed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Ok, that answers my previous question.. though the new helper should be
in this patch instead of the previous..

>  fs/xfs/libxfs/xfs_alloc.c      |  2 +-
>  fs/xfs/libxfs/xfs_attr.c       |  6 +++---
>  fs/xfs/libxfs/xfs_bmap.c       | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++++----
>  fs/xfs/libxfs/xfs_ialloc.c     |  6 +++---
>  fs/xfs/scrub/scrub.c           |  2 +-
>  fs/xfs/xfs_aops.c              |  8 ++++----
>  fs/xfs/xfs_attr_list.c         |  2 +-
>  fs/xfs/xfs_bmap_util.c         |  8 ++++----
>  fs/xfs/xfs_buf.c               |  2 +-
>  fs/xfs/xfs_buf_item.c          |  4 ++--
>  fs/xfs/xfs_dir2_readdir.c      |  2 +-
>  fs/xfs/xfs_dquot.c             |  2 +-
>  fs/xfs/xfs_file.c              | 12 ++++++------
>  fs/xfs/xfs_fsops.c             |  2 +-
>  fs/xfs/xfs_icache.c            |  4 ++--
>  fs/xfs/xfs_inode.c             | 20 ++++++++++----------
>  fs/xfs/xfs_inode_item.c        |  6 +++---
>  fs/xfs/xfs_ioctl.c             |  8 ++++----
>  fs/xfs/xfs_ioctl32.c           |  2 +-
>  fs/xfs/xfs_iomap.c             |  6 +++---
>  fs/xfs/xfs_iops.c              |  4 ++--
>  fs/xfs/xfs_log_recover.c       |  8 ++++----
>  fs/xfs/xfs_mount.c             |  2 +-
>  fs/xfs/xfs_mount.h             |  4 +---
>  fs/xfs/xfs_pnfs.c              |  2 +-
>  fs/xfs/xfs_qm.c                |  4 ++--
>  fs/xfs/xfs_reflink.c           |  2 +-
>  fs/xfs/xfs_super.c             |  2 +-
>  fs/xfs/xfs_symlink.c           |  8 ++++----
>  fs/xfs/xfs_trans.c             |  8 ++++----
>  fs/xfs/xfs_trans_ail.c         |  8 ++++----
>  fs/xfs/xfs_trans_buf.c         | 10 +++++-----
>  34 files changed, 95 insertions(+), 97 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 03f4681c1ba6..2a7e7ef7c338 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -296,7 +296,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
>   * Mount features
>   *
>   * These do not change dynamically - features that can come and go,
> - * such as 32 bit inodes and read-only state, are kept as flags rather than
> + * such as 32 bit inodes and read-only state, are kept as state rather than

... and this change looks like it should probably be in the previous
patch.

Brian

>   * features.
>   */
>  __XFS_HAS_FEAT(wsync, WSYNC)
> @@ -383,8 +383,6 @@ xfs_preferred_iosize(xfs_mount_t *mp)
>  	return PAGE_SIZE;
>  }
>  
> -#define XFS_FORCED_SHUTDOWN(mp) \
> -		test_bit(XFS_STATE_SHUTDOWN, &(mp)->m_state)
>  void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  		int lnnum);
>  #define xfs_force_shutdown(m,f)	\
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index f44c3599527d..2908dcfa9ecf 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -99,7 +99,7 @@ xfs_fs_map_blocks(
>  	uint			lock_flags;
>  	int			error = 0;
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shut_down(mp))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 9ee840472138..1957042882d5 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -157,7 +157,7 @@ xfs_qm_dqpurge(
>  	}
>  
>  	ASSERT(atomic_read(&dqp->q_pincount) == 0);
> -	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
> +	ASSERT(xfs_is_shut_down(mp) ||
>  		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
>  
>  	xfs_dqfunlock(dqp);
> @@ -815,7 +815,7 @@ xfs_qm_qino_alloc(
>  
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> -		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +		ASSERT(xfs_is_shut_down(mp));
>  		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
>  	}
>  	if (need_alloc)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 66ba7c4446d5..b1196911a8b2 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1221,7 +1221,7 @@ xfs_reflink_remap_range(
>  	if (!xfs_has_reflink(mp))
>  		return -EOPNOTSUPP;
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shut_down(mp))
>  		return -EIO;
>  
>  	/* Lock both files against IO */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 9938d9fb420b..7c1e03539b5e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -949,7 +949,7 @@ xfs_fs_destroy_inode(
>  
>  	xfs_inactive(ip);
>  
> -	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> +	ASSERT(xfs_is_shut_down(ip->i_mount) || ip->i_delayed_blks == 0);
>  	XFS_STATS_INC(ip->i_mount, vn_reclaim);
>  
>  	/*
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 675481028292..41e1054748e5 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -124,7 +124,7 @@ xfs_readlink(
>  
>  	ASSERT(!(ip->i_df.if_flags & XFS_IFINLINE));
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shut_down(mp))
>  		return -EIO;
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> @@ -183,7 +183,7 @@ xfs_symlink(
>  
>  	trace_xfs_symlink(dp, link_name);
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shut_down(mp))
>  		return -EIO;
>  
>  	/*
> @@ -456,7 +456,7 @@ xfs_inactive_symlink_rmt(
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> -		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +		ASSERT(xfs_is_shut_down(mp));
>  		goto error_unlock;
>  	}
>  
> @@ -489,7 +489,7 @@ xfs_inactive_symlink(
>  
>  	trace_xfs_inactive_symlink(ip);
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shut_down(mp))
>  		return -EIO;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index db4367baab34..5c064bc8d49a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -857,7 +857,7 @@ xfs_trans_committed_bulk(
>  		 * object into the AIL as we are in a shutdown situation.
>  		 */
>  		if (aborted) {
> -			ASSERT(XFS_FORCED_SHUTDOWN(ailp->ail_mount));
> +			ASSERT(xfs_is_shut_down(ailp->ail_mount));
>  			lip->li_ops->iop_unpin(lip, 1);
>  			continue;
>  		}
> @@ -944,7 +944,7 @@ __xfs_trans_commit(
>  	if (!(tp->t_flags & XFS_TRANS_DIRTY))
>  		goto out_unreserve;
>  
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> +	if (xfs_is_shut_down(mp)) {
>  		error = -EIO;
>  		goto out_unreserve;
>  	}
> @@ -1031,12 +1031,12 @@ xfs_trans_cancel(
>  	 * filesystem.  This happens in paths where we detect
>  	 * corruption and decide to give up.
>  	 */
> -	if (dirty && !XFS_FORCED_SHUTDOWN(mp)) {
> +	if (dirty && !xfs_is_shut_down(mp)) {
>  		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
>  #ifdef DEBUG
> -	if (!dirty && !XFS_FORCED_SHUTDOWN(mp)) {
> +	if (!dirty && !xfs_is_shut_down(mp)) {
>  		struct xfs_log_item *lip;
>  
>  		list_for_each_entry(lip, &tp->t_items, li_trans)
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 55326f971cb3..19e79d8279fc 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -601,7 +601,7 @@ xfs_ail_push(
>  	xfs_log_item_t	*lip;
>  
>  	lip = xfs_ail_min(ailp);
> -	if (!lip || XFS_FORCED_SHUTDOWN(ailp->ail_mount) ||
> +	if (!lip || xfs_is_shut_down(ailp->ail_mount) ||
>  	    XFS_LSN_CMP(threshold_lsn, ailp->ail_target) <= 0)
>  		return;
>  
> @@ -713,7 +713,7 @@ xfs_trans_ail_update_bulk(
>  		xfs_ail_splice(ailp, cur, &tmp, lsn);
>  
>  	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> +		if (!xfs_is_shut_down(ailp->ail_mount))
>  			xlog_assign_tail_lsn_locked(ailp->ail_mount);
>  		spin_unlock(&ailp->ail_lock);
>  
> @@ -771,7 +771,7 @@ xfs_trans_ail_delete(
>  
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
> -		if (!XFS_FORCED_SHUTDOWN(mp)) {
> +		if (!xfs_is_shut_down(mp)) {
>  			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
>  	"%s: attempting to delete a log item that is not in the AIL",
>  					__func__);
> @@ -782,7 +782,7 @@ xfs_trans_ail_delete(
>  
>  	mlip_changed = xfs_ail_delete_one(ailp, lip);
>  	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(mp))
> +		if (!xfs_is_shut_down(mp))
>  			xlog_assign_tail_lsn_locked(mp);
>  		if (list_empty(&ailp->ail_head))
>  			wake_up_all(&ailp->ail_empty);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 15919f67a88f..f18d5cd0f606 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -137,7 +137,7 @@ xfs_trans_get_buf_map(
>  	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
>  	if (bp != NULL) {
>  		ASSERT(xfs_buf_islocked(bp));
> -		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
> +		if (xfs_is_shut_down(tp->t_mountp)) {
>  			xfs_buf_stale(bp);
>  			bp->b_flags |= XBF_DONE;
>  		}
> @@ -259,7 +259,7 @@ xfs_trans_read_buf_map(
>  		 * We never locked this buf ourselves, so we shouldn't
>  		 * brelse it either. Just get out.
>  		 */
> -		if (XFS_FORCED_SHUTDOWN(mp)) {
> +		if (xfs_is_shut_down(mp)) {
>  			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
>  			return -EIO;
>  		}
> @@ -291,7 +291,7 @@ xfs_trans_read_buf_map(
>  	 */
>  	if (bp->b_error) {
>  		error = bp->b_error;
> -		if (!XFS_FORCED_SHUTDOWN(mp))
> +		if (!xfs_is_shut_down(mp))
>  			xfs_buf_ioerror_alert(bp, __func__);
>  		bp->b_flags &= ~XBF_DONE;
>  		xfs_buf_stale(bp);
> @@ -306,7 +306,7 @@ xfs_trans_read_buf_map(
>  		return error;
>  	}
>  
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> +	if (xfs_is_shut_down(mp)) {
>  		xfs_buf_relse(bp);
>  		trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
>  		return -EIO;
> @@ -418,7 +418,7 @@ xfs_trans_brelse(
>  	 * due to our reference). Since we're already shutdown and need
>  	 * ail_lock, just force remove from the AIL and release the bli here.
>  	 */
> -	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
> +	if (xfs_is_shut_down(tp->t_mountp) && freed) {
>  		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
>  		xfs_buf_item_relse(bp);
>  	} else if (!(bip->bli_flags & XFS_BLI_DIRTY)) {
> -- 
> 2.17.0
> 
