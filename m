Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD37C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDEAD64FC3
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCJXBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 18:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231368AbhCJXBP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 18:01:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED77164F60;
        Wed, 10 Mar 2021 23:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615417275;
        bh=wtn6duQ6Vp1jks7ke0wFBC3MJ/mmuTGEk9wI+wW/10E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=arrvYprXYb/6aVIf7mOx3kwJACY80ZZVhihruuwDVxB/UIB0DcU023MyLtriWgZQp
         1/PvShkfzo266+4CMOUL6Z7djqakp5i8AetGFK1ADDoTMULh54Xg3BDLRZocoZYw9v
         H75oDcznzlNJkCkPrVNb7nQpQJQVdC0K/Lc4u0eziwSdY+LmorNGQhzwjQSshIZHeV
         O4J0KHQsBn379AUUHE2yPaf84OA8KX/h226htnGoeVsAWezitpNLI5wWn2TkSb4tQZ
         g4gNQKhvmFkt/dErw3tvRDviXn69YlM6rCIva4R0a6bUQLl33ALr6qliNb73Y847Yg
         GJUCqAlStEhQw==
Date:   Wed, 10 Mar 2021 15:01:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/45] xfs: use the CIL space used counter for emptiness
 checks
Message-ID: <20210310230111.GF3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-33-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-33-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:30PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In the next patches we are going to make the CIL list itself
> per-cpu, and so we cannot use list_empty() to check is the list is
> empty. Replace the list_empty() checks with a flag in the CIL to
> indicate we have committed at least one transaction to the CIL and
> hence the CIL is not empty.
> 
> We need this flag to be an atomic so that we can clear it without
> holding any locks in the commit fast path, but we also need to be
> careful to avoid atomic operations in the fast path. Hence we use
> the fact that test_bit() is not an atomic op to first check if the
> flag is set and then run the atomic test_and_clear_bit() operation
> to clear it and steal the initial unit reservation for the CIL
> context checkpoint.
> 
> When we are switching to a new context in a push, we place the
> setting of the XLOG_CIL_EMPTY flag under the xc_push_lock. THis
> allows all the other places that need to check whether the CIL is
> empty to use test_bit() and still be serialised correctly with the
> CIL context swaps that set the bit.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 49 +++++++++++++++++++++++--------------------
>  fs/xfs/xfs_log_priv.h |  4 ++++
>  2 files changed, 30 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4047f95a0fc4..e6e36488f0c7 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -70,6 +70,7 @@ xlog_cil_ctx_switch(
>  	struct xfs_cil		*cil,
>  	struct xfs_cil_ctx	*ctx)
>  {
> +	set_bit(XLOG_CIL_EMPTY, &cil->xc_flags);
>  	ctx->sequence = ++cil->xc_current_sequence;
>  	ctx->cil = cil;
>  	cil->xc_ctx = ctx;
> @@ -436,13 +437,12 @@ xlog_cil_insert_items(
>  		list_splice_init(&tp->t_busy, &ctx->busy_extents);
>  
>  	/*
> -	 * Now transfer enough transaction reservation to the context ticket
> -	 * for the checkpoint. The context ticket is special - the unit
> -	 * reservation has to grow as well as the current reservation as we
> -	 * steal from tickets so we can correctly determine the space used
> -	 * during the transaction commit.
> +	 * We need to take the CIL checkpoint unit reservation on the first
> +	 * commit into the CIL. Test the XLOG_CIL_EMPTY bit first so we don't
> +	 * unnecessarily do an atomic op in the fast path here.
>  	 */
> -	if (ctx->ticket->t_curr_res == 0) {
> +	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) &&
> +	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {

Hm, it'll be amusing to see where this goes.  Usually I tell myself in
siutations like these "I think this is ok, let's see where we are in
another 4-5 patches" but now I'm 7 patches out and my brain is getting
close to ENOSPC so I'll tentatively say:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

With the caveat that I could have more to say after the fact...

--D

>  		ctx_res = ctx->ticket->t_unit_res;
>  		ctx->ticket->t_curr_res = ctx_res;
>  		tp->t_ticket->t_curr_res -= ctx_res;
> @@ -771,7 +771,7 @@ xlog_cil_push_work(
>  	 * move on to a new sequence number and so we have to be able to push
>  	 * this sequence again later.
>  	 */
> -	if (list_empty(&cil->xc_cil)) {
> +	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
>  		cil->xc_push_seq = 0;
>  		spin_unlock(&cil->xc_push_lock);
>  		goto out_skip;
> @@ -1019,9 +1019,10 @@ xlog_cil_push_background(
>  
>  	/*
>  	 * The cil won't be empty because we are called while holding the
> -	 * context lock so whatever we added to the CIL will still be there
> +	 * context lock so whatever we added to the CIL will still be there.
>  	 */
>  	ASSERT(!list_empty(&cil->xc_cil));
> +	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
>  
>  	/*
>  	 * Don't do a background push if we haven't used up all the
> @@ -1108,7 +1109,8 @@ xlog_cil_push_now(
>  	 * there's no work we need to do.
>  	 */
>  	spin_lock(&cil->xc_push_lock);
> -	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
> +	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) ||
> +	    push_seq <= cil->xc_push_seq) {
>  		spin_unlock(&cil->xc_push_lock);
>  		return;
>  	}
> @@ -1128,7 +1130,7 @@ xlog_cil_empty(
>  	bool		empty = false;
>  
>  	spin_lock(&cil->xc_push_lock);
> -	if (list_empty(&cil->xc_cil))
> +	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
>  		empty = true;
>  	spin_unlock(&cil->xc_push_lock);
>  	return empty;
> @@ -1289,7 +1291,7 @@ xlog_cil_force_seq(
>  	 * we would have found the context on the committing list.
>  	 */
>  	if (sequence == cil->xc_current_sequence &&
> -	    !list_empty(&cil->xc_cil)) {
> +	    !test_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
>  		spin_unlock(&cil->xc_push_lock);
>  		goto restart;
>  	}
> @@ -1320,21 +1322,19 @@ xlog_cil_force_seq(
>   */
>  bool
>  xfs_log_item_in_current_chkpt(
> -	struct xfs_log_item *lip)
> +	struct xfs_log_item	*lip)
>  {
> -	struct xfs_cil_ctx *ctx;
> +	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
>  
> -	if (list_empty(&lip->li_cil))
> +	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
>  		return false;
>  
> -	ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
> -
>  	/*
>  	 * li_seq is written on the first commit of a log item to record the
>  	 * first checkpoint it is written to. Hence if it is different to the
>  	 * current sequence, we're in a new checkpoint.
>  	 */
> -	if (XFS_LSN_CMP(lip->li_seq, ctx->sequence) != 0)
> +	if (XFS_LSN_CMP(lip->li_seq, cil->xc_ctx->sequence) != 0)
>  		return false;
>  	return true;
>  }
> @@ -1373,13 +1373,16 @@ void
>  xlog_cil_destroy(
>  	struct xlog	*log)
>  {
> -	if (log->l_cilp->xc_ctx) {
> -		if (log->l_cilp->xc_ctx->ticket)
> -			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
> -		kmem_free(log->l_cilp->xc_ctx);
> +	struct xfs_cil	*cil = log->l_cilp;
> +
> +	if (cil->xc_ctx) {
> +		if (cil->xc_ctx->ticket)
> +			xfs_log_ticket_put(cil->xc_ctx->ticket);
> +		kmem_free(cil->xc_ctx);
>  	}
>  
> -	ASSERT(list_empty(&log->l_cilp->xc_cil));
> -	kmem_free(log->l_cilp);
> +	ASSERT(list_empty(&cil->xc_cil));
> +	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
> +	kmem_free(cil);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 003c11653955..b0dc3bc9de59 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -248,6 +248,7 @@ struct xfs_cil_ctx {
>   */
>  struct xfs_cil {
>  	struct xlog		*xc_log;
> +	unsigned long		xc_flags;
>  	struct list_head	xc_cil;
>  	spinlock_t		xc_cil_lock;
>  
> @@ -263,6 +264,9 @@ struct xfs_cil {
>  	wait_queue_head_t	xc_push_wait;	/* background push throttle */
>  } ____cacheline_aligned_in_smp;
>  
> +/* xc_flags bit values */
> +#define	XLOG_CIL_EMPTY		1
> +
>  /*
>   * The amount of log space we allow the CIL to aggregate is difficult to size.
>   * Whatever we choose, we have to make sure we can get a reservation for the
> -- 
> 2.28.0
> 
