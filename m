Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51736C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38485613CC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhE0ST3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 14:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234756AbhE0ST3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0887613CC;
        Thu, 27 May 2021 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622139475;
        bh=7vNIvyV64C23z8mXC0vkZwiHJ0adA6VZcZeD6RAJmgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJN5amwPvHDm04TRyFk05ACyD21E/RE4VqmbQFF8qyxT+mMLxrEWdsVsPZHDTS1qS
         LwukLYwJ5haRYFxvbDKPPovVQH4AqMyAPbhGJsB5zGSFO0QNh0XJLVspJCtEz+90S3
         RFiVdvTpNJY7ydwZIbAq1ltKmhdE1DqvYmSMEbi6jS5vv94RdDyaHn9IQNyOYSdmqA
         rEF6bj89hufVADhNpVXCWRetJ3G7FnN1WtBVvGxgbpF9uIj8P5ourbhZaB2boDHuNb
         VaJ/4qg2PX8D+7S7ZLtUzLZQxdThvNoyBeeP+jT95GxFl5M2cSULs+3p4gQ2RRNAYU
         3eWBkhGsKIJgQ==
Date:   Thu, 27 May 2021 11:17:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/39] xfs: rework per-iclog header CIL reservation
Message-ID: <20210527181755.GG2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-29-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-29-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For every iclog that a CIL push will use up, we need to ensure we
> have space reserved for the iclog header in each iclog. It is
> extremely difficult to do this accurately with a per-cpu counter
> without expensive summing of the counter in every commit. However,
> we know what the maximum CIL size is going to be because of the
> hard space limit we have, and hence we know exactly how many iclogs
> we are going to need to write out the CIL.
> 
> We are constrained by the requirement that small transactions only
> have reservation space for a single iclog header built into them.
> At commit time we don't know how much of the current transaction
> reservation is made up of iclog header reservations as calculated by
> xfs_log_calc_unit_res() when the ticket was reserved. As larger
> reservations have multiple header spaces reserved, we can steal
> more than one iclog header reservation at a time, but we only steal
> the exact number needed for the given log vector size delta.
> 
> As a result, we don't know exactly when we are going to steal iclog
> header reservations, nor do we know exactly how many we are going to
> need for a given CIL.
> 
> To make things simple, start by calculating the worst case number of
> iclog headers a full CIL push will require. Record this into an
> atomic variable in the CIL. Then add a byte counter to the log
> ticket that records exactly how much iclog header space has been
> reserved in this ticket by xfs_log_calc_unit_res(). This tells us
> exactly how much space we can steal from the ticket at transaction
> commit time.
> 
> Now, at transaction commit time, we can check if the CIL has a full
> iclog header reservation and, if not, steal the entire reservation
> the current ticket holds for iclog headers. This minimises the
> number of times we need to do atomic operations in the fast path,
> but still guarantees we get all the reservations we need.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

No new questions since last time, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      |  9 ++++---
>  fs/xfs/xfs_log_cil.c  | 55 +++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_log_priv.h | 20 +++++++++-------
>  3 files changed, 59 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 65b28fce4db4..77d9ea7daf26 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3307,7 +3307,8 @@ xfs_log_ticket_get(
>  static int
>  xlog_calc_unit_res(
>  	struct xlog		*log,
> -	int			unit_bytes)
> +	int			unit_bytes,
> +	int			*niclogs)
>  {
>  	int			iclog_space;
>  	uint			num_headers;
> @@ -3387,6 +3388,8 @@ xlog_calc_unit_res(
>  	/* roundoff padding for transaction data and one for commit record */
>  	unit_bytes += 2 * log->l_iclog_roundoff;
>  
> +	if (niclogs)
> +		*niclogs = num_headers;
>  	return unit_bytes;
>  }
>  
> @@ -3395,7 +3398,7 @@ xfs_log_calc_unit_res(
>  	struct xfs_mount	*mp,
>  	int			unit_bytes)
>  {
> -	return xlog_calc_unit_res(mp->m_log, unit_bytes);
> +	return xlog_calc_unit_res(mp->m_log, unit_bytes, NULL);
>  }
>  
>  /*
> @@ -3413,7 +3416,7 @@ xlog_ticket_alloc(
>  
>  	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
>  
> -	unit_res = xlog_calc_unit_res(log, unit_bytes);
> +	unit_res = xlog_calc_unit_res(log, unit_bytes, &tic->t_iclog_hdrs);
>  
>  	atomic_set(&tic->t_ref, 1);
>  	tic->t_task		= current;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4637f8711ada..87d4eb321fdc 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -44,9 +44,20 @@ xlog_cil_ticket_alloc(
>  	 * transaction overhead reservation from the first transaction commit.
>  	 */
>  	tic->t_curr_res = 0;
> +	tic->t_iclog_hdrs = 0;
>  	return tic;
>  }
>  
> +static inline void
> +xlog_cil_set_iclog_hdr_count(struct xfs_cil *cil)
> +{
> +	struct xlog	*log = cil->xc_log;
> +
> +	atomic_set(&cil->xc_iclog_hdrs,
> +		   (XLOG_CIL_BLOCKING_SPACE_LIMIT(log) /
> +			(log->l_iclog_size - log->l_iclog_hsize)));
> +}
> +
>  /*
>   * Unavoidable forward declaration - xlog_cil_push_work() calls
>   * xlog_cil_ctx_alloc() itself.
> @@ -70,6 +81,7 @@ xlog_cil_ctx_switch(
>  	struct xfs_cil		*cil,
>  	struct xfs_cil_ctx	*ctx)
>  {
> +	xlog_cil_set_iclog_hdr_count(cil);
>  	set_bit(XLOG_CIL_EMPTY, &cil->xc_flags);
>  	ctx->sequence = ++cil->xc_current_sequence;
>  	ctx->cil = cil;
> @@ -92,6 +104,7 @@ xlog_cil_init_post_recovery(
>  {
>  	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
>  	log->l_cilp->xc_ctx->sequence = 1;
> +	xlog_cil_set_iclog_hdr_count(log->l_cilp);
>  }
>  
>  static inline int
> @@ -419,7 +432,6 @@ xlog_cil_insert_items(
>  	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
> -	int			iclog_space;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
>  
>  	ASSERT(tp);
> @@ -442,19 +454,36 @@ xlog_cil_insert_items(
>  	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
>  		ctx_res = ctx->ticket->t_unit_res;
>  
> -	spin_lock(&cil->xc_cil_lock);
> -
> -	/* do we need space for more log record headers? */
> -	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> -	if (len > 0 && (ctx->space_used / iclog_space !=
> -				(ctx->space_used + len) / iclog_space)) {
> -		split_res = (len + iclog_space - 1) / iclog_space;
> -		/* need to take into account split region headers, too */
> -		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> -		ctx->ticket->t_unit_res += split_res;
> +	/*
> +	 * Check if we need to steal iclog headers. atomic_read() is not a
> +	 * locked atomic operation, so we can check the value before we do any
> +	 * real atomic ops in the fast path. If we've already taken the CIL unit
> +	 * reservation from this commit, we've already got one iclog header
> +	 * space reserved so we have to account for that otherwise we risk
> +	 * overrunning the reservation on this ticket.
> +	 *
> +	 * If the CIL is already at the hard limit, we might need more header
> +	 * space that originally reserved. So steal more header space from every
> +	 * commit that occurs once we are over the hard limit to ensure the CIL
> +	 * push won't run out of reservation space.
> +	 *
> +	 * This can steal more than we need, but that's OK.
> +	 */
> +	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
> +	    ctx->space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> +		int	split_res = log->l_iclog_hsize +
> +					sizeof(struct xlog_op_header);
> +		if (ctx_res)
> +			ctx_res += split_res * (tp->t_ticket->t_iclog_hdrs - 1);
> +		else
> +			ctx_res = split_res * tp->t_ticket->t_iclog_hdrs;
> +		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
>  	}
> -	tp->t_ticket->t_curr_res -= split_res + ctx_res + len;
> -	ctx->ticket->t_curr_res += split_res + ctx_res;
> +
> +	spin_lock(&cil->xc_cil_lock);
> +	tp->t_ticket->t_curr_res -= ctx_res + len;
> +	ctx->ticket->t_unit_res += ctx_res;
> +	ctx->ticket->t_curr_res += ctx_res;
>  	ctx->space_used += len;
>  
>  	/*
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 11606c378b7f..85a85ab569fe 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -137,15 +137,16 @@ enum xlog_iclog_state {
>  #define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
>  
>  typedef struct xlog_ticket {
> -	struct list_head   t_queue;	 /* reserve/write queue */
> -	struct task_struct *t_task;	 /* task that owns this ticket */
> -	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
> -	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
> -	int		   t_curr_res;	 /* current reservation in bytes : 4  */
> -	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
> -	char		   t_ocnt;	 /* original count		 : 1  */
> -	char		   t_cnt;	 /* current count		 : 1  */
> -	char		   t_flags;	 /* properties of reservation	 : 1  */
> +	struct list_head	t_queue;	/* reserve/write queue */
> +	struct task_struct	*t_task;	/* task that owns this ticket */
> +	xlog_tid_t		t_tid;		/* transaction identifier */
> +	atomic_t		t_ref;		/* ticket reference count */
> +	int			t_curr_res;	/* current reservation */
> +	int			t_unit_res;	/* unit reservation */
> +	char			t_ocnt;		/* original count */
> +	char			t_cnt;		/* current count */
> +	char			t_flags;	/* properties of reservation */
> +	int			t_iclog_hdrs;	/* iclog hdrs in t_curr_res */
>  } xlog_ticket_t;
>  
>  /*
> @@ -245,6 +246,7 @@ struct xfs_cil_ctx {
>  struct xfs_cil {
>  	struct xlog		*xc_log;
>  	unsigned long		xc_flags;
> +	atomic_t		xc_iclog_hdrs;
>  	struct list_head	xc_cil;
>  	spinlock_t		xc_cil_lock;
>  
> -- 
> 2.31.1
> 
