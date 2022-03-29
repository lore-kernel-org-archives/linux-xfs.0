Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811AAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 00:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiC2Aie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 20:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiC2Aid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 20:38:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E631FAA0C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 17:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A97E061181
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 00:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10709C340EC;
        Tue, 29 Mar 2022 00:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648514211;
        bh=9Iuplo17bBeWx+W9nExliLiTKDwHWNsZtLHVULvDDU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qPvP6RMJ+Gfg8mBIoTzZ8OvUU7sW2lHPQC1HY4Wc+d0ykQBdbPptpeQjpWNuOz1pi
         JA52HpUFjVUaLVXWAmeksU7ch4ZY8Pc6EU692AtO0AwdHcLL6fc9l/30864Ku/stpU
         FX/OY3flLr2BCW0ktq+t0Hoxw1Z/0SzkVoroI7kvAquBtVeeBxrFQL1NLYtgbGe49i
         4vnY1W+uc6PKsOM+nb5dr8M/eRrcA633GxeTlcuhxxSr8w56D6JBPL6yZ+ut88jKDH
         CN6DI3wBqne1SA2kvJPHAKaW+FWHtx2xbhq5ZB6jwId+MK5HginCKzoxK8wGuAOnwG
         Goi34zRUgsu8A==
Date:   Mon, 28 Mar 2022 17:36:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: xfs_trans_commit() path must check for log
 shutdown
Message-ID: <20220329003650.GD27690@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324002103.710477-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 11:21:03AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If a shut races with xfs_trans_commit() and we have shut down the
> filesystem but not the log, we will still cancel the transaction.
> This can result in aborting dirty log items instead of committing and
> pinning them whilst the log is still running. Hence we can end up
> with dirty, unlogged metadata that isn't in the AIL in memory that
> can be flushed to disk via writeback clustering.

...because we cancelled the transaction, leaving (say) an inode with
dirty uncommited changes?  And now iflush for an adjacent inode comes
along and writes it to disk, because we haven't yet told the log to
stop?  And blammo?

> This was discovered from a g/388 trace where an inode log item was
> having IO completed on it and it wasn't in the AIL, hence tripping
> asserts xfs_ail_check(). Inode cluster writeback started long after
> the filesystem shutdown started, and long after the transaction
> containing the dirty inode was aborted and the log item marked
> XFS_LI_ABORTED. The inode was seen as dirty and unpinned, so it
> was flushed. IO completion tried to remove the inode from the AIL,
> at which point stuff went bad:
> 
>  XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xa3/0xf0 (fs/xfs/xfs_fsops.c:500).  Shutting down filesystem.
>  XFS: Assertion failed: in_ail, file: fs/xfs/xfs_trans_ail.c, line: 67
>  XFS (pmem1): Please unmount the filesystem and rectify the problem(s)
>  Workqueue: xfs-buf/pmem1 xfs_buf_ioend_work
>  RIP: 0010:assfail+0x27/0x2d
>  Call Trace:
>   <TASK>
>   xfs_ail_check+0xa8/0x180
>   xfs_ail_delete_one+0x3b/0xf0
>   xfs_buf_inode_iodone+0x329/0x3f0
>   xfs_buf_ioend+0x1f8/0x530
>   xfs_buf_ioend_work+0x15/0x20
>   process_one_work+0x1ac/0x390
>   worker_thread+0x56/0x3c0
>   kthread+0xf6/0x120
>   ret_from_fork+0x1f/0x30
>   </TASK>
> 
> xfs_trans_commit() needs to check log state for shutdown, not mount
> state. It cannot abort dirty log items while the log is still
> running as dirty items must remained pinned in memory until they are
> either committed to the journal or the log has shut down and they
> can be safely tossed away. Hence if the log has not shut down, the
> xfs_trans_commit() path must allow completed transactions to commit
> to the CIL and pin the dirty items even if a mount shutdown has
> started.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

If the answers are {yes, yes, yes} then yikes and:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans.c | 48 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 36a10298742d..c324d96f022d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -836,6 +836,7 @@ __xfs_trans_commit(
>  	bool			regrant)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xlog		*log = mp->m_log;
>  	xfs_csn_t		commit_seq = 0;
>  	int			error = 0;
>  	int			sync = tp->t_flags & XFS_TRANS_SYNC;
> @@ -864,7 +865,13 @@ __xfs_trans_commit(
>  	if (!(tp->t_flags & XFS_TRANS_DIRTY))
>  		goto out_unreserve;
>  
> -	if (xfs_is_shutdown(mp)) {
> +	/*
> +	 * We must check against log shutdown here because we cannot abort log
> +	 * items and leave them dirty, inconsistent and unpinned in memory while
> +	 * the log is active. This leaves them open to being written back to
> +	 * disk, and that will lead to on-disk corruption.
> +	 */
> +	if (xlog_is_shutdown(log)) {
>  		error = -EIO;
>  		goto out_unreserve;
>  	}
> @@ -878,7 +885,7 @@ __xfs_trans_commit(
>  		xfs_trans_apply_sb_deltas(tp);
>  	xfs_trans_apply_dquot_deltas(tp);
>  
> -	xlog_cil_commit(mp->m_log, tp, &commit_seq, regrant);
> +	xlog_cil_commit(log, tp, &commit_seq, regrant);
>  
>  	xfs_trans_free(tp);
>  
> @@ -905,10 +912,10 @@ __xfs_trans_commit(
>  	 */
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  	if (tp->t_ticket) {
> -		if (regrant && !xlog_is_shutdown(mp->m_log))
> -			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
> +		if (regrant && !xlog_is_shutdown(log))
> +			xfs_log_ticket_regrant(log, tp->t_ticket);
>  		else
> -			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
> +			xfs_log_ticket_ungrant(log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  	}
>  	xfs_trans_free_items(tp, !!error);
> @@ -926,18 +933,27 @@ xfs_trans_commit(
>  }
>  
>  /*
> - * Unlock all of the transaction's items and free the transaction.
> - * The transaction must not have modified any of its items, because
> - * there is no way to restore them to their previous state.
> + * Unlock all of the transaction's items and free the transaction.  If the
> + * transaction is dirty, we must shut down the filesystem because there is no
> + * way to restore them to their previous state.
>   *
> - * If the transaction has made a log reservation, make sure to release
> - * it as well.
> + * If the transaction has made a log reservation, make sure to release it as
> + * well.
> + *
> + * This is a high level function (equivalent to xfs_trans_commit()) and so can
> + * be called after the transaction has effectively been aborted due to the mount
> + * being shut down. However, if the mount has not been shut down and the
> + * transaction is dirty we will shut the mount down and, in doing so, that
> + * guarantees that the log is shut down, too. Hence we don't need to be as
> + * careful with shutdown state and dirty items here as we need to be in
> + * xfs_trans_commit().
>   */
>  void
>  xfs_trans_cancel(
>  	struct xfs_trans	*tp)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xlog		*log = mp->m_log;
>  	bool			dirty = (tp->t_flags & XFS_TRANS_DIRTY);
>  
>  	trace_xfs_trans_cancel(tp, _RET_IP_);
> @@ -955,16 +971,18 @@ xfs_trans_cancel(
>  	}
>  
>  	/*
> -	 * See if the caller is relying on us to shut down the
> -	 * filesystem.  This happens in paths where we detect
> -	 * corruption and decide to give up.
> +	 * See if the caller is relying on us to shut down the filesystem. We
> +	 * only want an error report if there isn't already a shutdown in
> +	 * progress, so we only need to check against the mount shutdown state
> +	 * here.
>  	 */
>  	if (dirty && !xfs_is_shutdown(mp)) {
>  		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
>  #ifdef DEBUG
> -	if (!dirty && !xfs_is_shutdown(mp)) {
> +	/* Log items need to be consistent until the log is shut down. */
> +	if (!dirty && !xlog_is_shutdown(log)) {
>  		struct xfs_log_item *lip;
>  
>  		list_for_each_entry(lip, &tp->t_items, li_trans)
> @@ -975,7 +993,7 @@ xfs_trans_cancel(
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  
>  	if (tp->t_ticket) {
> -		xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
> +		xfs_log_ticket_ungrant(log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  	}
>  
> -- 
> 2.35.1
> 
