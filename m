Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9516DC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66A6964FC6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhCJX0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 18:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232571AbhCJXZm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 18:25:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63A4964FC3;
        Wed, 10 Mar 2021 23:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615418742;
        bh=qriNs0WWfWYYn/lA4Gjw4UOFeMOQVukLxQr3sJCTAYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dOjuAsOXWKWD3qSuFXI9Ra7d5fSm7O7GTUFCdat8vD3I7n4C+6WKXbVog//bnIdpt
         3a2ECUInreh92ythPioAZ/l9LXsaqPHw5cbDKdBWLzJcCBZ3GlisYaIt7r8smsc35r
         w1PjSr62Q9RjuI4fY64avVZt2NJAhUReI/sT+jF+0WxAUSuzTi2LNNbiQvjF2p/QQk
         RhFk2sjjR3lR71KxnZcTS4ozqWyaY8IMznLpfISJIQZMYQ8vGzdhE3+Adf3cwqPIte
         H14Lk/I7s+eQn/M+51e1kOZW+rvJqCIMPI48fhy1VrL3swhR0f5LA9G03GHobu9hIK
         4vobY9qmKAb0g==
Date:   Wed, 10 Mar 2021 15:25:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/45] xfs: lift init CIL reservation out of xc_cil_lock
Message-ID: <20210310232541.GG3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-34-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-34-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:31PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xc_cil_lock is the most highly contended lock in XFS now. To
> start the process of getting rid of it, lift the initial reservation
> of the CIL log space out from under the xc_cil_lock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index e6e36488f0c7..50101336a7f4 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -430,23 +430,19 @@ xlog_cil_insert_items(
>  	 */
>  	xlog_cil_insert_format_items(log, tp, &len);
>  
> -	spin_lock(&cil->xc_cil_lock);

Hm, so looking ahead, the next few patches keep kicking this spin_lock
call further and further down in the file, and the commit messages give
me the impression that this might even go away entirely?

Let me see, the CIL locks are:

xc_ctx_lock, which prevents transactions from committing (into the cil)
any time the CIL itself is preparing a new commited item context so that
it can xlog_write (to disk) the log vectors associated with the current
context.

xc_cil_lock, which serializes transactions adding their items to the CIL
in the first place, hence the motivation to reduce this hot lock?

xc_push_lock, which I think is used to coordinate the CIL push worker
with all the upper level callers that want to force log items to disk?

And the locking order of these three locks is...

xc_ctx_lock --> xc_push_lock
    |
    \---------> xc_cil_lock

Assuming I grokked all that, then I guess moving the spin_lock call
works out because the test_and_clear_bit is atomic.  The rest of the
accounting stuff here is just getting moved further down in the file and
is still protected by xc_cil_lock.

If I understood all that,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -
> -	/* attach the transaction to the CIL if it has any busy extents */
> -	if (!list_empty(&tp->t_busy))
> -		list_splice_init(&tp->t_busy, &ctx->busy_extents);
> -
>  	/*
>  	 * We need to take the CIL checkpoint unit reservation on the first
>  	 * commit into the CIL. Test the XLOG_CIL_EMPTY bit first so we don't
> -	 * unnecessarily do an atomic op in the fast path here.
> +	 * unnecessarily do an atomic op in the fast path here. We don't need to
> +	 * hold the xc_cil_lock here to clear the XLOG_CIL_EMPTY bit as we are
> +	 * under the xc_ctx_lock here and that needs to be held exclusively to
> +	 * reset the XLOG_CIL_EMPTY bit.
>  	 */
>  	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) &&
> -	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
> +	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
>  		ctx_res = ctx->ticket->t_unit_res;
> -		ctx->ticket->t_curr_res = ctx_res;
> -		tp->t_ticket->t_curr_res -= ctx_res;
> -	}
> +
> +	spin_lock(&cil->xc_cil_lock);
>  
>  	/* do we need space for more log record headers? */
>  	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> @@ -456,11 +452,9 @@ xlog_cil_insert_items(
>  		/* need to take into account split region headers, too */
>  		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
>  		ctx->ticket->t_unit_res += split_res;
> -		ctx->ticket->t_curr_res += split_res;
> -		tp->t_ticket->t_curr_res -= split_res;
> -		ASSERT(tp->t_ticket->t_curr_res >= len);
>  	}
> -	tp->t_ticket->t_curr_res -= len;
> +	tp->t_ticket->t_curr_res -= split_res + ctx_res + len;
> +	ctx->ticket->t_curr_res += split_res + ctx_res;
>  	ctx->space_used += len;
>  
>  	/*
> @@ -498,6 +492,9 @@ xlog_cil_insert_items(
>  			list_move_tail(&lip->li_cil, &cil->xc_cil);
>  	}
>  
> +	/* attach the transaction to the CIL if it has any busy extents */
> +	if (!list_empty(&tp->t_busy))
> +		list_splice_init(&tp->t_busy, &ctx->busy_extents);
>  	spin_unlock(&cil->xc_cil_lock);
>  
>  	if (tp->t_ticket->t_curr_res < 0)
> -- 
> 2.28.0
> 
