Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB104C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9328023136
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbhAUSq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbhAUSot (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jan 2021 13:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDFA0230F9;
        Thu, 21 Jan 2021 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611254644;
        bh=H0CbSYnWjAJHhRSKs8UlsQIaZCA8OG/ympqTDgHZ3Xk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kqirwdKF/NqRmbPFcAuUTjMPJcPlPGZqc431tY2u/04aBZtoTjtwbc76YdwiqZiin
         /cN1KPqHq1U7IGxa6cEqboMqtT2Z1ESzaQMpBXnm175DTYtEFDdbFMXFOTG+/RCBYw
         mCxNmFdNZcqZZJLlWQRxGR6EK8rm1gtNt/yFTFQHZMYS/R8JbRxOO5vlErXG18txW2
         2K9Uj/BZ+mF8Depz2FE+xgNSPRf/4ut2TrHKWF9cOvedHVo3n+EWWlpohZGEY/Ltbl
         zksI/u+th6GZJhLrc+ELFBrRndQkmp0571HwEyiM6VRMmUk1Mz451RtqGUUIleOeJ6
         jFT268udX6E9Q==
Date:   Thu, 21 Jan 2021 10:44:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/9] xfs: cover the log during log quiesce
Message-ID: <20210121184404.GB1282127@magnolia>
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121154526.1852176-5-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 10:45:21AM -0500, Brian Foster wrote:
> The log quiesce mechanism historically terminates by marking the log
> clean with an unmount record. The primary objective is to indicate
> that log recovery is no longer required after the quiesce has
> flushed all in-core changes and written back filesystem metadata.
> While this is perfectly fine, it is somewhat hacky as currently used
> in certain contexts. For example, filesystem freeze quiesces (i.e.
> cleans) the log and immediately redirties it with a dummy superblock
> transaction to ensure that log recovery runs in the event of a
> crash.
> 
> While this functions correctly, cleaning the log from freeze context
> is clearly superfluous given the current redirtying behavior.
> Instead, the desired behavior can be achieved by simply covering the
> log. This effectively retires all on-disk log items from the active
> range of the log by issuing two synchronous and sequential dummy
> superblock update transactions that serve to update the on-disk log
> head and tail. The subtle difference is that the log technically
> remains dirty due to the lack of an unmount record, though recovery
> is effectively a no-op due to the content of the checkpoints being
> clean (i.e. the unmodified on-disk superblock).
> 
> Log covering currently runs in the background and only triggers once
> the filesystem and log has idled. The purpose of the background
> mechanism is to prevent log recovery from replaying the most
> recently logged items long after those items may have been written
> back. In the quiesce path, the log has been deliberately idled by
> forcing the log and pushing the AIL until empty in a context where
> no further mutable filesystem operations are allowed. Therefore, we
> can cover the log as the final step in the log quiesce codepath to
> reflect that all previously active items have been successfully
> written back.
> 
> This facilitates selective log covering from certain contexts (i.e.
> freeze) that only seek to quiesce, but not necessarily clean the
> log. Note that as a side effect of this change, log covering now
> occurs when cleaning the log as well. This is harmless, facilitates
> subsequent cleanups, and is mostly temporary as various operations
> switch to use explicit log covering.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 49 +++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_log.h |  2 +-
>  2 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0fb26b05edc9..7c31b046e790 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -91,6 +91,9 @@ STATIC int
>  xlog_iclogs_empty(
>  	struct xlog		*log);
>  
> +static int
> +xfs_log_cover(struct xfs_mount *);
> +
>  static void
>  xlog_grant_sub_space(
>  	struct xlog		*log,
> @@ -936,10 +939,9 @@ xfs_log_unmount_write(
>   * To do this, we first need to shut down the background log work so it is not
>   * trying to cover the log as we clean up. We then need to unpin all objects in
>   * the log so we can then flush them out. Once they have completed their IO and
> - * run the callbacks removing themselves from the AIL, we can write the unmount
> - * record.
> + * run the callbacks removing themselves from the AIL, we can cover the log.
>   */
> -void
> +int
>  xfs_log_quiesce(
>  	struct xfs_mount	*mp)
>  {
> @@ -957,6 +959,8 @@ xfs_log_quiesce(
>  	xfs_wait_buftarg(mp->m_ddev_targp);
>  	xfs_buf_lock(mp->m_sb_bp);
>  	xfs_buf_unlock(mp->m_sb_bp);
> +
> +	return xfs_log_cover(mp);
>  }
>  
>  void
> @@ -1092,6 +1096,45 @@ xfs_log_need_covered(
>  	return needed;
>  }
>  
> +/*
> + * Explicitly cover the log. This is similar to background log covering but
> + * intended for usage in quiesce codepaths. The caller is responsible to ensure
> + * the log is idle and suitable for covering. The CIL, iclog buffers and AIL
> + * must all be empty.
> + */
> +static int
> +xfs_log_cover(
> +	struct xfs_mount	*mp)
> +{
> +	struct xlog		*log = mp->m_log;
> +	int			error = 0;
> +
> +	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
> +	        !xfs_ail_min_lsn(log->l_ailp)) ||
> +	       XFS_FORCED_SHUTDOWN(mp));
> +
> +	if (!xfs_log_writable(mp))
> +		return 0;
> +
> +	/*
> +	 * To cover the log, commit the superblock twice (at most) in
> +	 * independent checkpoints. The first serves as a reference for the
> +	 * tail pointer. The sync transaction and AIL push empties the AIL and
> +	 * updates the in-core tail to the LSN of the first checkpoint. The
> +	 * second commit updates the on-disk tail with the in-core LSN,
> +	 * covering the log. Push the AIL one more time to leave it empty, as
> +	 * we found it.
> +	 */
> +	while (xfs_log_need_covered(mp)) {
> +		error = xfs_sync_sb(mp, true);
> +		if (error)
> +			break;
> +		xfs_ail_push_all_sync(mp->m_ail);
> +	}
> +
> +	return error;
> +}
> +
>  /*
>   * We may be holding the log iclog lock upon entering this routine.
>   */
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index b0400589f824..044e02cb8921 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -138,7 +138,7 @@ void	xlog_cil_process_committed(struct list_head *list);
>  bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
>  void	xfs_log_work_queue(struct xfs_mount *mp);
> -void	xfs_log_quiesce(struct xfs_mount *mp);
> +int	xfs_log_quiesce(struct xfs_mount *mp);
>  void	xfs_log_clean(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  bool	xfs_log_in_recovery(struct xfs_mount *);
> -- 
> 2.26.2
> 
