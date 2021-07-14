Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF1AC1B08C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94CD86136E
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhGNV5L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhGNV5K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 17:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B230F61362;
        Wed, 14 Jul 2021 21:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626299658;
        bh=GS/N/GXFWH+yyRhW5efGrZUVl4Hq5yuHqBbNjgONR94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lbKd1eqBeVjpWWXs4jtpDgbvNe3MvzI3qxG1cqjiTDlyQVHowEr5Wx7whofo72wCS
         7twttOaApZDjUwW25J9YDm6DvsqPxSUCFsoU0LOtqOaep8c5lAVvaIj52yLrY2DKoP
         kSwfZQGJK4fDSzgOToxcevldCcdtDVRYHXJGrxcj8aSfMcpGm2O3YmnOYeIcDvTDqn
         DYm/lBNw0rU1ZZwgHJkXlqRaBaMSt4oPzNnNU9jHes9wV8nNM9fUG6nZW+mQsQ87kR
         rfBE5IAvgCveD3MxdYO1hVXreo33aMQwAHzJ0Ialub7Vd3DFk0/dWJwpdInN4GmbRz
         rB0j404ZuB1hw==
Date:   Wed, 14 Jul 2021 14:54:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: move recovery needed state updates to
 xfs_log_mount_finish
Message-ID: <20210714215418.GO22402@magnolia>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:19:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_log_mount_finish() needs to know if recovery is needed or not to
> make descisions on whether to flush the log and AIL.  Move the

s/descisions/decisions/

> handling of the NEED_RECOVERY state out to this function rather than
> needing a temporary variable to store this state over the call to
> xlog_recover_finish().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

With that fixed, this looks like a nice cleanup.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c         | 24 ++++++++-----
>  fs/xfs/xfs_log_recover.c | 73 +++++++++++++++-------------------------
>  2 files changed, 43 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 75cc487da578..6760608642cc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -698,9 +698,9 @@ int
>  xfs_log_mount_finish(
>  	struct xfs_mount	*mp)
>  {
> -	int	error = 0;
> -	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> -	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
> +	struct xlog		*log = mp->m_log;
> +	bool			readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> +	int			error = 0;
>  
>  	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> @@ -731,7 +731,8 @@ xfs_log_mount_finish(
>  	 * mount failure occurs.
>  	 */
>  	mp->m_super->s_flags |= SB_ACTIVE;
> -	error = xlog_recover_finish(mp->m_log);
> +	if (log->l_flags & XLOG_RECOVERY_NEEDED)
> +		error = xlog_recover_finish(log);
>  	if (!error)
>  		xfs_log_work_queue(mp);
>  	mp->m_super->s_flags &= ~SB_ACTIVE;
> @@ -746,17 +747,24 @@ xfs_log_mount_finish(
>  	 * Don't push in the error case because the AIL may have pending intents
>  	 * that aren't removed until recovery is cancelled.
>  	 */
> -	if (!error && recovered) {
> -		xfs_log_force(mp, XFS_LOG_SYNC);
> -		xfs_ail_push_all_sync(mp->m_ail);
> +	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
> +		if (!error) {
> +			xfs_log_force(mp, XFS_LOG_SYNC);
> +			xfs_ail_push_all_sync(mp->m_ail);
> +		}
> +		xfs_notice(mp, "Ending recovery (logdev: %s)",
> +				mp->m_logname ? mp->m_logname : "internal");
> +	} else {
> +		xfs_info(mp, "Ending clean mount");
>  	}
>  	xfs_buftarg_drain(mp->m_ddev_targp);
>  
> +	log->l_flags &= ~XLOG_RECOVERY_NEEDED;
>  	if (readonly)
>  		mp->m_flags |= XFS_MOUNT_RDONLY;
>  
>  	/* Make sure the log is dead if we're returning failure. */
> -	ASSERT(!error || (mp->m_log->l_flags & XLOG_IO_ERROR));
> +	ASSERT(!error || xlog_is_shutdown(log));
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 37296f87a435..c384ecdd6389 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3416,62 +3416,43 @@ xlog_recover(
>  }
>  
>  /*
> - * In the first part of recovery we replay inodes and buffers and build
> - * up the list of extent free items which need to be processed.  Here
> - * we process the extent free items and clean up the on disk unlinked
> - * inode lists.  This is separated from the first part of recovery so
> - * that the root and real-time bitmap inodes can be read in from disk in
> - * between the two stages.  This is necessary so that we can free space
> - * in the real-time portion of the file system.
> + * In the first part of recovery we replay inodes and buffers and build up the
> + * list of intents which need to be processed.  Here we process the intents  and
> + * clean up the on disk unlinked inode lists.  This is separated from the first
> + * part of recovery so that the root and real-time bitmap inodes can be read in
> + * from disk in between the two stages.  This is necessary so that we can free
> + * space in the real-time portion of the file system.
>   */
>  int
>  xlog_recover_finish(
>  	struct xlog	*log)
>  {
> -	/*
> -	 * Now we're ready to do the transactions needed for the
> -	 * rest of recovery.  Start with completing all the extent
> -	 * free intent records and then process the unlinked inode
> -	 * lists.  At this point, we essentially run in normal mode
> -	 * except that we're still performing recovery actions
> -	 * rather than accepting new requests.
> -	 */
> -	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
> -		int	error;
> -		error = xlog_recover_process_intents(log);
> -		if (error) {
> -			/*
> -			 * Cancel all the unprocessed intent items now so that
> -			 * we don't leave them pinned in the AIL.  This can
> -			 * cause the AIL to livelock on the pinned item if
> -			 * anyone tries to push the AIL (inode reclaim does
> -			 * this) before we get around to xfs_log_mount_cancel.
> -			 */
> -			xlog_recover_cancel_intents(log);
> -			xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> -			xfs_alert(log->l_mp, "Failed to recover intents");
> -			return error;
> -		}
> +	int	error;
>  
> +	error = xlog_recover_process_intents(log);
> +	if (error) {
>  		/*
> -		 * Sync the log to get all the intents out of the AIL.
> -		 * This isn't absolutely necessary, but it helps in
> -		 * case the unlink transactions would have problems
> -		 * pushing the intents out of the way.
> +		 * Cancel all the unprocessed intent items now so that we don't
> +		 * leave them pinned in the AIL.  This can cause the AIL to
> +		 * livelock on the pinned item if anyone tries to push the AIL
> +		 * (inode reclaim does this) before we get around to
> +		 * xfs_log_mount_cancel.
>  		 */
> -		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
> -
> -		xlog_recover_process_iunlinks(log);
> +		xlog_recover_cancel_intents(log);
> +		xfs_alert(log->l_mp, "Failed to recover intents");
> +		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		return error;
> +	}
>  
> -		xlog_recover_check_summary(log);
> +	/*
> +	 * Sync the log to get all the intents out of the AIL.  This isn't
> +	 * absolutely necessary, but it helps in case the unlink transactions
> +	 * would have problems pushing the intents out of the way.
> +	 */
> +	xfs_log_force(log->l_mp, XFS_LOG_SYNC);
> +	xlog_recover_process_iunlinks(log);
>  
> -		xfs_notice(log->l_mp, "Ending recovery (logdev: %s)",
> -				log->l_mp->m_logname ? log->l_mp->m_logname
> -						     : "internal");
> -		log->l_flags &= ~XLOG_RECOVERY_NEEDED;
> -	} else {
> -		xfs_info(log->l_mp, "Ending clean mount");
> -	}
> +	xlog_recover_check_summary(log);
>  	return 0;
>  }
>  
> -- 
> 2.31.1
> 
