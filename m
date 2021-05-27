Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F00C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B98B4613BE
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbhE0SJV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 14:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231226AbhE0SJV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6680613BE;
        Thu, 27 May 2021 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622138867;
        bh=SnlgZNXerzlIDcuHvazZYh6i3U7YLnsAI7RGH8OkL94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iKC9AkKS/gr93rfVfDqtRoPveCW/aFLksreMHf3WnvaO5SRdWjQjdfJag/U8yso8n
         0BKKME2wfAInBWuYnBeKFZqxP2HJv/A66EWomMV7tCmEEYeucnc2rL06GVnfpKQcm3
         gpNeVH/HvNagyuqxKwwwcXQ6p9G9xnJ6Uf+KKDxXhc9YH21AFOcyRK70AXPLkqOe5E
         //CSiJwkpGGIUil74uR/afHQQzBwUoBXr3Hfkd9uTBu7dASYzvFoRTtQlPYsq7ns3g
         jIOn/UHlae2/SoZV+pmz87z4JT70ATZYG8e5EAEBYk+1rHMh0zc84dciRfuKrwf7ug
         bRzuSXaqtZntw==
Date:   Thu, 27 May 2021 11:07:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/39] xfs: xlog_write() doesn't need optype anymore
Message-ID: <20210527180747.GE2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-25-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-25-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So remove it from the interface and callers.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks pretty straightforward.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 14 ++++----------
>  fs/xfs/xfs_log_cil.c  |  2 +-
>  fs/xfs/xfs_log_priv.h |  2 +-
>  3 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 574078985f0a..65b28fce4db4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -863,8 +863,7 @@ xlog_write_unmount_record(
>  	 */
>  	if (log->l_targ != log->l_mp->m_ddev_targp)
>  		blkdev_issue_flush(log->l_targ->bt_bdev);
> -	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS,
> -				reg.i_len);
> +	return xlog_write(log, &vec, ticket, NULL, NULL, reg.i_len);
>  }
>  
>  /*
> @@ -1588,8 +1587,7 @@ xlog_commit_record(
>  
>  	/* account for space used by record data */
>  	ticket->t_curr_res -= reg.i_len;
> -	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
> -				reg.i_len);
> +	error = xlog_write(log, &vec, ticket, lsn, iclog, reg.i_len);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> @@ -2399,7 +2397,6 @@ xlog_write(
>  	struct xlog_ticket	*ticket,
>  	xfs_lsn_t		*start_lsn,
>  	struct xlog_in_core	**commit_iclog,
> -	uint			optype,
>  	uint32_t		len)
>  {
>  	struct xlog_in_core	*iclog = NULL;
> @@ -2431,7 +2428,6 @@ xlog_write(
>  		if (!lv)
>  			break;
>  
> -		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
>  		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
>  					&len, &record_cnt, &data_cnt);
>  		if (IS_ERR_OR_NULL(lv)) {
> @@ -2449,12 +2445,10 @@ xlog_write(
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, 0);
> -	if (commit_iclog) {
> -		ASSERT(optype & XLOG_COMMIT_TRANS);
> +	if (commit_iclog)
>  		*commit_iclog = iclog;
> -	} else {
> +	else
>  		error = xlog_state_release_iclog(log, iclog);
> -	}
>  	spin_unlock(&log->l_icloglock);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 7a6b80666f98..dbe3a8267e2f 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -908,7 +908,7 @@ xlog_cil_push_work(
>  	 * write head.
>  	 */
>  	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
> -				XLOG_START_TRANS, num_bytes);
> +				num_bytes);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index eba905c273b0..a16ffdc8ae97 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -459,7 +459,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>  		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> -		struct xlog_in_core **commit_iclog, uint optype, uint32_t len);
> +		struct xlog_in_core **commit_iclog, uint32_t len);
>  int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>  		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
>  
> -- 
> 2.31.1
> 
