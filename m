Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E95C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 02:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B6865287
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 02:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbhCIChV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 21:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCICgp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 21:36:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A806527B;
        Tue,  9 Mar 2021 02:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615257405;
        bh=qQHYmlWkZZs6ewLR8nlvwAMDxR8k3ky2mNuAH3KZD9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Num+l/mQ21TGLvGCXvKy6BletDkwlzYH0QvJdz4gdyAEyLesCvn3WV2n/hMun7IrY
         cQtlHrdj4W2Pr/WoZKgPJ7P1dsx1lqe8leaKNjaAr9ItQXCyZ7wXPYPGqX93i7OZjE
         albRnkQDE5cglJF6nLebNeyALLwbJP+r7XLlDU3YJBAX5w7BbYiJNaqoDUZNfAuV/B
         fI0Ib+9cHmjvfR1/VFjWTe4CuvhgycVe7gnCvvXOGzvbyE6ewdiV6OprP/sTizTdOy
         HLAGqPcqp2phuq9lhvbkPKWqpCENe/We9cKgRCZJSNd1RWSKTWOR8GW/HNuEro6bxO
         Wt5dL8bTWTj3w==
Date:   Mon, 8 Mar 2021 18:36:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs: pass lv chain length into xlog_write()
Message-ID: <20210309023644.GO3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-28-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-28-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The caller of xlog_write() usually has a close accounting of the
> aggregated vector length contained in the log vector chain passed to
> xlog_write(). There is no need to iterate the chain to calculate he
> length of the data in xlog_write_calculate_len() if the caller is
> already iterating that chain to build it.
> 
> Passing in the vector length avoids doing an extra chain iteration,
> which can be a significant amount of work given that large CIL
> commits can have hundreds of thousands of vectors attached to the
> chain.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 37 ++++++-------------------------------
>  fs/xfs/xfs_log_cil.c  | 18 +++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  2 +-
>  3 files changed, 20 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 412b167d8d0e..22f97914ab99 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -858,7 +858,8 @@ xlog_write_unmount_record(
>  	 */
>  	if (log->l_targ != log->l_mp->m_ddev_targp)
>  		blkdev_issue_flush(log->l_targ->bt_bdev);
> -	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
> +	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS,
> +				reg.i_len);
>  }
>  
>  /*
> @@ -1577,7 +1578,8 @@ xlog_commit_record(
>  
>  	/* account for space used by record data */
>  	ticket->t_curr_res -= reg.i_len;
> -	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
> +	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
> +				reg.i_len);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> @@ -2097,32 +2099,6 @@ xlog_print_trans(
>  	}
>  }
>  
> -/*
> - * Calculate the potential space needed by the log vector. All regions contain
> - * their own opheaders and they are accounted for in region space so we don't
> - * need to add them to the vector length here.
> - */
> -static int
> -xlog_write_calc_vec_length(
> -	struct xlog_ticket	*ticket,
> -	struct xfs_log_vec	*log_vector,
> -	uint			optype)
> -{
> -	struct xfs_log_vec	*lv;
> -	int			len = 0;
> -	int			i;
> -
> -	for (lv = log_vector; lv; lv = lv->lv_next) {
> -		/* we don't write ordered log vectors */
> -		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
> -			continue;
> -
> -		for (i = 0; i < lv->lv_niovecs; i++)
> -			len += lv->lv_iovecp[i].i_len;
> -	}
> -	return len;
> -}
> -
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
>  	struct xlog_op_header	*ophdr,
> @@ -2285,13 +2261,13 @@ xlog_write(
>  	struct xlog_ticket	*ticket,
>  	xfs_lsn_t		*start_lsn,
>  	struct xlog_in_core	**commit_iclog,
> -	uint			optype)
> +	uint			optype,
> +	uint32_t		len)
>  {
>  	struct xlog_in_core	*iclog = NULL;
>  	struct xfs_log_vec	*lv = log_vector;
>  	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
>  	int			index = 0;
> -	int			len;
>  	int			partial_copy = 0;
>  	int			partial_copy_len = 0;
>  	int			contwr = 0;
> @@ -2306,7 +2282,6 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
>  	if (start_lsn)
>  		*start_lsn = 0;
>  	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 7a5e6bdb7876..34abc3bae587 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -710,11 +710,12 @@ xlog_cil_build_trans_hdr(
>  				sizeof(struct xfs_trans_header);
>  	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
>  
> -	tic->t_curr_res -= hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
> -
>  	lvhdr->lv_niovecs = 2;
>  	lvhdr->lv_iovecp = &hdr->lhdr[0];
> +	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;

Er... does this code change belong in an earlier patch?  Or if not, why
wasn't it important to set lv_bytes here?

>  	lvhdr->lv_next = ctx->lv_chain;
> +
> +	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
>  /*
> @@ -742,7 +743,8 @@ xlog_cil_push_work(
>  	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*new_ctx;
>  	struct xlog_in_core	*commit_iclog;
> -	int			num_iovecs;
> +	int			num_iovecs = 0;
> +	int			num_bytes = 0;
>  	int			error = 0;
>  	struct xlog_cil_trans_hdr thdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
> @@ -841,7 +843,6 @@ xlog_cil_push_work(
>  	 * by the flush lock.
>  	 */
>  	lv = NULL;
> -	num_iovecs = 0;
>  	while (!list_empty(&cil->xc_cil)) {
>  		struct xfs_log_item	*item;
>  
> @@ -855,6 +856,10 @@ xlog_cil_push_work(
>  		lv = item->li_lv;
>  		item->li_lv = NULL;
>  		num_iovecs += lv->lv_niovecs;
> +
> +		/* we don't write ordered log vectors */
> +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> +			num_bytes += lv->lv_bytes;
>  	}
>  
>  	/*
> @@ -893,6 +898,9 @@ xlog_cil_push_work(
>  	 * transaction header here as it is not accounted for in xlog_write().
>  	 */
>  	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
> +	num_iovecs += lvhdr.lv_niovecs;
> +	num_bytes += lvhdr.lv_bytes;
> +
>  

No need to have two blank lines here.

--D

>  	/*
>  	 * Before we format and submit the first iclog, we have to ensure that
> @@ -907,7 +915,7 @@ xlog_cil_push_work(
>  	 * write head.
>  	 */
>  	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
> -				XLOG_START_TRANS);
> +				XLOG_START_TRANS, num_bytes);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 8ee6a5f74396..003c11653955 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -462,7 +462,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>  		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> -		struct xlog_in_core **commit_iclog, uint optype);
> +		struct xlog_in_core **commit_iclog, uint optype, uint32_t len);
>  int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>  		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
>  void	xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
> -- 
> 2.28.0
> 
