Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B433C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 17:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0295A613CE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 17:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhFQRws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 13:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhFQRwr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 13:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C77326101A;
        Thu, 17 Jun 2021 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623952239;
        bh=WizqEekRW7e/y5KVCzOocNFPAR9MBg80pVZj2aIZQwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=abqeKYEBwciTyYqFTXtdi2sxVEaR+m7MAmELEmu/4Py3OC3/K/DaPltz2x75zGdp8
         1Isl4QOi26Hl+yUwgIYiMLaeSy1z+buKkubT686XzZHJDUxWHGTNfHBuZuGg1hne30
         0Ph+qgN0eC3xUk2SJniOVa896MkmpChGBjUVQWyFZEgQGIH0CN1VD5f/S2yw58LOjM
         gLgUYDfr3JBmppTewWTqUeMdGVDU8ohQfn42ppN3zLIppgcb13bJTbl+eMgTwFPt9s
         q/1VHT7vSEJRvtxSNcYv3WknJTtQIzFi4LnvMzcyE5nOPNBtKBFzwHs61TmPfW9GCj
         f/bqPVGT+BzLw==
Date:   Thu, 17 Jun 2021 10:50:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move xlog_commit_record to xfs_log_cil.c
Message-ID: <20210617175039.GU158209@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is only used by the CIL checkpoints, and is the counterpart to
> start record formatting and writing that is already local to
> xfs_log_cil.c.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 41 ---------------------------------------
>  fs/xfs/xfs_log_cil.c  | 45 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_log_priv.h |  2 --
>  3 files changed, 44 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 54fd6a695bb5..cf661c155786 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1563,47 +1563,6 @@ xlog_alloc_log(
>  	return ERR_PTR(error);
>  }	/* xlog_alloc_log */
>  
> -/*
> - * Write out the commit record of a transaction associated with the given
> - * ticket to close off a running log write. Return the lsn of the commit record.
> - */
> -int
> -xlog_commit_record(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	**iclog,
> -	xfs_lsn_t		*lsn)
> -{
> -	struct xlog_op_header	ophdr = {
> -		.oh_clientid = XFS_TRANSACTION,
> -		.oh_tid = cpu_to_be32(ticket->t_tid),
> -		.oh_flags = XLOG_COMMIT_TRANS,
> -	};
> -	struct xfs_log_iovec reg = {
> -		.i_addr = &ophdr,
> -		.i_len = sizeof(struct xlog_op_header),
> -		.i_type = XLOG_REG_TYPE_COMMIT,
> -	};
> -	struct xfs_log_vec vec = {
> -		.lv_niovecs = 1,
> -		.lv_iovecp = &reg,
> -	};
> -	int	error;
> -	LIST_HEAD(lv_chain);
> -	INIT_LIST_HEAD(&vec.lv_list);
> -	list_add(&vec.lv_list, &lv_chain);
> -
> -	if (XLOG_FORCED_SHUTDOWN(log))
> -		return -EIO;
> -
> -	/* account for space used by record data */
> -	ticket->t_curr_res -= reg.i_len;
> -	error = xlog_write(log, &lv_chain, ticket, lsn, iclog, reg.i_len);
> -	if (error)
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> -	return error;
> -}
> -
>  /*
>   * Compute the LSN that we'd need to push the log tail towards in order to have
>   * (a) enough on-disk log space to log the number of bytes specified, (b) at
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 2fb0ab02dda3..2c8b25888c53 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -783,6 +783,48 @@ xlog_cil_build_trans_hdr(
>  	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
> +/*
> + * Write out the commit record of a checkpoint transaction associated with the
> + * given ticket to close off a running log write. Return the lsn of the commit
> + * record.
> + */
> +int

static int, like the robot suggests?

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +xlog_cil_write_commit_record(
> +	struct xlog		*log,
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	**iclog,
> +	xfs_lsn_t		*lsn)
> +{
> +	struct xlog_op_header	ophdr = {
> +		.oh_clientid = XFS_TRANSACTION,
> +		.oh_tid = cpu_to_be32(ticket->t_tid),
> +		.oh_flags = XLOG_COMMIT_TRANS,
> +	};
> +	struct xfs_log_iovec reg = {
> +		.i_addr = &ophdr,
> +		.i_len = sizeof(struct xlog_op_header),
> +		.i_type = XLOG_REG_TYPE_COMMIT,
> +	};
> +	struct xfs_log_vec vec = {
> +		.lv_niovecs = 1,
> +		.lv_iovecp = &reg,
> +	};
> +	int	error;
> +	LIST_HEAD(lv_chain);
> +	INIT_LIST_HEAD(&vec.lv_list);
> +	list_add(&vec.lv_list, &lv_chain);
> +
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		return -EIO;
> +
> +	/* account for space used by record data */
> +	ticket->t_curr_res -= reg.i_len;
> +	error = xlog_write(log, &lv_chain, ticket, lsn, iclog, reg.i_len);
> +	if (error)
> +		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +	return error;
> +}
> +
>  /*
>   * CIL item reordering compare function. We want to order in ascending ID order,
>   * but we want to leave items with the same ID in the order they were added to
> @@ -1041,7 +1083,8 @@ xlog_cil_push_work(
>  	}
>  	spin_unlock(&cil->xc_push_lock);
>  
> -	error = xlog_commit_record(log, ctx->ticket, &commit_iclog, &commit_lsn);
> +	error = xlog_cil_write_commit_record(log, ctx->ticket, &commit_iclog,
> +			&commit_lsn);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 330befd9f6be..26f26769d1c6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -490,8 +490,6 @@ void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct list_head *lv_chain,
>  		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
>  		struct xlog_in_core **commit_iclog, uint32_t len);
> -int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
> -		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
>  
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
> -- 
> 2.31.1
> 
