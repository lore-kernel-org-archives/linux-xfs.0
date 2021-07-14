Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49115C47E48
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B88A613CA
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhGNXOb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXOb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31406613B5;
        Wed, 14 Jul 2021 23:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626304299;
        bh=TSC72VWl6WOmhVpUOYHap0yM8+JArUgEjHIzzsKkEVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dbJwY4HX28ylJFixm79vfZVFTJC2TzNfCEbDSeExQ4cD4vhJAQn18lZnuPLHGOpCK
         a9SidJdrTaqL0T/wEYqi3GsoKW9v6DWC8ujgpU03Tl/v6pPdv4iyRN5vHzn+A6S1sG
         r80TnebYf8ZBvBLsYU6SIUmaPauQERgpmos8Ba3Enrv3n9R5mxgq4uIoTVje1p31nK
         neK8jLNYXWqelEAo8a/na5v/1r7SUw5e3pjJXFovE0ZRLJm1N3QwjV6uI/X3PFIB1B
         l+2H+kg31Fz3ENQxWjvinHChGGqKytaGMteGCsboqqlrHoYOURlAdCuZeNaC1i7eg6
         GqZyIKhf4Kpfg==
Date:   Wed, 14 Jul 2021 16:11:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/16] xfs: replace XFS_FORCED_SHUTDOWN with
 xfs_is_shutdown
Message-ID: <20210714231138.GC22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-10-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:05PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Remove the shouty macro and instead use the inline function that
> matches other state/feature check wrapper naming. This conversion
> was done with sed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

<snip>

> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 0b9b84b31179..d4da6f54e7ae 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -324,7 +324,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
>   * Mount features
>   *
>   * These do not change dynamically - features that can come and go,
> - * such as 32 bit inodes and read-only state, are kept as flags rather than
> + * such as 32 bit inodes and read-only state, are kept as state rather than

I think this comment update belongs in the previous patch?

Otherwise this is a straight conversion, so once that's fixed up, you
may add

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>   * features.
>   */
>  __XFS_HAS_FEAT(noattr2, NOATTR2)
> @@ -373,7 +373,7 @@ __XFS_IS_STATE(readonly, READONLY)
>  #define XFS_MAX_IO_LOG		30	/* 1G */
>  #define XFS_MIN_IO_LOG		PAGE_SHIFT
>  
> -#define XFS_FORCED_SHUTDOWN(mp)		xfs_is_shutdown(mp)
> +#define xfs_is_shutdown(mp)		xfs_is_shutdown(mp)
>  void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  		int lnnum);
>  #define xfs_force_shutdown(m,f)	\
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 956cca24e67f..5e1d29d8b2e7 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -92,7 +92,7 @@ xfs_fs_map_blocks(
>  	uint			lock_flags;
>  	int			error = 0;
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b327b9dcca04..5f24720e0ba2 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -157,7 +157,7 @@ xfs_qm_dqpurge(
>  	}
>  
>  	ASSERT(atomic_read(&dqp->q_pincount) == 0);
> -	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
> +	ASSERT(xfs_is_shutdown(mp) ||
>  		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
>  
>  	xfs_dqfunlock(dqp);
> @@ -829,7 +829,7 @@ xfs_qm_qino_alloc(
>  
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> -		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +		ASSERT(xfs_is_shutdown(mp));
>  		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
>  	}
>  	if (need_alloc)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cc7eb9a73e85..2463848f92ff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -639,7 +639,7 @@ xfs_fs_destroy_inode(
>  
>  	xfs_inactive(ip);
>  
> -	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
> +	if (!xfs_is_shutdown(ip->i_mount) && ip->i_delayed_blks) {
>  		xfs_check_delalloc(ip, XFS_DATA_FORK);
>  		xfs_check_delalloc(ip, XFS_COW_FORK);
>  		ASSERT(0);
> @@ -1010,7 +1010,7 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_icount);
>  	percpu_counter_destroy(&mp->m_ifree);
>  	percpu_counter_destroy(&mp->m_fdblocks);
> -	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
> +	ASSERT(xfs_is_shutdown(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
>  }
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 701a78fbf7a9..fc2c6a404647 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -107,7 +107,7 @@ xfs_readlink(
>  
>  	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> @@ -168,7 +168,7 @@ xfs_symlink(
>  
>  	trace_xfs_symlink(dp, link_name);
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
>  	/*
> @@ -444,7 +444,7 @@ xfs_inactive_symlink_rmt(
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> -		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +		ASSERT(xfs_is_shutdown(mp));
>  		goto error_unlock;
>  	}
>  
> @@ -477,7 +477,7 @@ xfs_inactive_symlink(
>  
>  	trace_xfs_inactive_symlink(ip);
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bc1cad33daf8..c5f111235e44 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -778,7 +778,7 @@ xfs_trans_committed_bulk(
>  		 * object into the AIL as we are in a shutdown situation.
>  		 */
>  		if (aborted) {
> -			ASSERT(XFS_FORCED_SHUTDOWN(ailp->ail_mount));
> +			ASSERT(xfs_is_shutdown(ailp->ail_mount));
>  			if (lip->li_ops->iop_unpin)
>  				lip->li_ops->iop_unpin(lip, 1);
>  			continue;
> @@ -867,7 +867,7 @@ __xfs_trans_commit(
>  	if (!(tp->t_flags & XFS_TRANS_DIRTY))
>  		goto out_unreserve;
>  
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> +	if (xfs_is_shutdown(mp)) {
>  		error = -EIO;
>  		goto out_unreserve;
>  	}
> @@ -953,12 +953,12 @@ xfs_trans_cancel(
>  	 * filesystem.  This happens in paths where we detect
>  	 * corruption and decide to give up.
>  	 */
> -	if (dirty && !XFS_FORCED_SHUTDOWN(mp)) {
> +	if (dirty && !xfs_is_shutdown(mp)) {
>  		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
>  #ifdef DEBUG
> -	if (!dirty && !XFS_FORCED_SHUTDOWN(mp)) {
> +	if (!dirty && !xfs_is_shutdown(mp)) {
>  		struct xfs_log_item *lip;
>  
>  		list_for_each_entry(lip, &tp->t_items, li_trans)
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index dbb69b4bf3ed..fd9b04b6bbb4 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -615,7 +615,7 @@ xfsaild(
>  			 * opportunity to release such buffers from the queue.
>  			 */
>  			ASSERT(list_empty(&ailp->ail_buf_list) ||
> -			       XFS_FORCED_SHUTDOWN(ailp->ail_mount));
> +			       xfs_is_shutdown(ailp->ail_mount));
>  			xfs_buf_delwri_cancel(&ailp->ail_buf_list);
>  			break;
>  		}
> @@ -678,7 +678,7 @@ xfs_ail_push(
>  	struct xfs_log_item	*lip;
>  
>  	lip = xfs_ail_min(ailp);
> -	if (!lip || XFS_FORCED_SHUTDOWN(ailp->ail_mount) ||
> +	if (!lip || xfs_is_shutdown(ailp->ail_mount) ||
>  	    XFS_LSN_CMP(threshold_lsn, ailp->ail_target) <= 0)
>  		return;
>  
> @@ -743,7 +743,7 @@ xfs_ail_update_finish(
>  		return;
>  	}
>  
> -	if (!XFS_FORCED_SHUTDOWN(mp))
> +	if (!xfs_is_shutdown(mp))
>  		xlog_assign_tail_lsn_locked(mp);
>  
>  	if (list_empty(&ailp->ail_head))
> @@ -863,7 +863,7 @@ xfs_trans_ail_delete(
>  	spin_lock(&ailp->ail_lock);
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
> -		if (shutdown_type && !XFS_FORCED_SHUTDOWN(mp)) {
> +		if (shutdown_type && !xfs_is_shutdown(mp)) {
>  			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
>  	"%s: attempting to delete a log item that is not in the AIL",
>  					__func__);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index d11d032da0b4..4ff274ce31c4 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -138,7 +138,7 @@ xfs_trans_get_buf_map(
>  	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
>  	if (bp != NULL) {
>  		ASSERT(xfs_buf_islocked(bp));
> -		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
> +		if (xfs_is_shutdown(tp->t_mountp)) {
>  			xfs_buf_stale(bp);
>  			bp->b_flags |= XBF_DONE;
>  		}
> @@ -244,7 +244,7 @@ xfs_trans_read_buf_map(
>  		 * We never locked this buf ourselves, so we shouldn't
>  		 * brelse it either. Just get out.
>  		 */
> -		if (XFS_FORCED_SHUTDOWN(mp)) {
> +		if (xfs_is_shutdown(mp)) {
>  			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
>  			return -EIO;
>  		}
> @@ -300,7 +300,7 @@ xfs_trans_read_buf_map(
>  		return error;
>  	}
>  
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> +	if (xfs_is_shutdown(mp)) {
>  		xfs_buf_relse(bp);
>  		trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
>  		return -EIO;
> -- 
> 2.31.1
> 
