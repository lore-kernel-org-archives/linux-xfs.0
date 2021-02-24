Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3ABFC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A103F64E60
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhBXU6Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231843AbhBXU6X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 15:58:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8433660202;
        Wed, 24 Feb 2021 20:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614200262;
        bh=kSoEIi2A0+xDfX1EnICkXHfLf4BaA3Um7Po/wXz3p1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bf0Vcx1TwLU6Bl8avfL5gD+SxwCegbMgAFpWRW8iMeaUlTTC0TZDvHbG4G1EAxfYS
         C9rYj7pRGPMF8qXoain7udU/NLPwJWZPwT29jmZwCekjdi7zAj+XFp5F/v0XfhE/RP
         tsKqbml9Z9NGKpA5F7CahvUK9lAj2x15IkUEvO5Q43Ecc5NaTVpN9lL5GvDsN9uqfF
         a7UY2eNUwRF5af9FNYX/YIaw16aHacGVCUMSmqOSdEW30x2d7qmowKIoKh9I+KEvtH
         4O1XmXchSOYyfSa8vA0+8HE/fWGpFUsnVyPxSpzVZP5un7WuDBeonD1ay1f3wGpVNA
         qML5MbDjwO3iA==
Date:   Wed, 24 Feb 2021 12:57:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: CIL checkpoint flushes caches unconditionally
Message-ID: <20210224205742.GU7272@magnolia>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 02:34:39PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> guarantee the ordering requirements the journal has w.r.t. metadata
> writeback. THe two ordering constraints are:
> 
> 1. we cannot overwrite metadata in the journal until we guarantee
> that the dirty metadata has been written back in place and is
> stable.
> 
> 2. we cannot write back dirty metadata until it has been written to
> the journal and guaranteed to be stable (and hence recoverable) in
> the journal.
> 
> These rules apply to the atomic transactions recorded in the
> journal, not to the journal IO itself. Hence we need to ensure
> metadata is stable before we start writing a new transaction to the
> journal (guarantee #1), and we need to ensure the entire transaction
> is stable in the journal before we start metadata writeback
> (guarantee #2).
> 
> The ordering guarantees of #1 are currently provided by REQ_PREFLUSH
> being added to every iclog IO. This causes the journal IO to issue a
> cache flush and wait for it to complete before issuing the write IO
> to the journal. Hence all completed metadata IO is guaranteed to be
> stable before the journal overwrites the old metadata.
> 
> However, for long running CIL checkpoints that might do a thousand
> journal IOs, we don't need every single one of these iclog IOs to
> issue a cache flush - the cache flush done before the first iclog is
> submitted is sufficient to cover the entire range in the log that
> the checkpoint will overwrite because the CIL space reservation
> guarantees the tail of the log (completed metadata) is already
> beyond the range of the checkpoint write.
> 
> Hence we only need a full cache flush between closing off the CIL
> checkpoint context (i.e. when the push switches it out) and issuing
> the first journal IO. Rather than plumbing this through to the
> journal IO, we can start this cache flush the moment the CIL context
> is owned exclusively by the push worker. The cache flush can be in
> progress while we process the CIL ready for writing, hence
> reducing the latency of the initial iclog write. This is especially
> true for large checkpoints, where we might have to process hundreds
> of thousands of log vectors before we issue the first iclog write.
> In these cases, it is likely the cache flush has already been
> completed by the time we have built the CIL log vector chain.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index c5cc1b7ad25e..8bcacd463f06 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -656,6 +656,7 @@ xlog_cil_push_work(
>  	struct xfs_log_vec	lvhdr = { NULL };
>  	xfs_lsn_t		commit_lsn;
>  	xfs_lsn_t		push_seq;
> +	DECLARE_COMPLETION_ONSTACK(bdev_flush);
>  
>  	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -719,10 +720,24 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
> -	 * pull all the log vectors off the items in the CIL, and
> -	 * remove the items from the CIL. We don't need the CIL lock
> -	 * here because it's only needed on the transaction commit
> -	 * side which is currently locked out by the flush lock.
> +	 * The CIL is stable at this point - nothing new will be added to it
> +	 * because we hold the flush lock exclusively. Hence we can now issue
> +	 * a cache flush to ensure all the completed metadata in the journal we
> +	 * are about to overwrite is on stable storage.
> +	 *
> +	 * This avoids the need to have the iclogs issue REQ_PREFLUSH based
> +	 * cache flushes to provide this ordering guarantee, and hence for CIL
> +	 * checkpoints that require hundreds or thousands of log writes no
> +	 * longer need to issue device cache flushes to provide metadata
> +	 * writeback ordering.
> +	 */
> +	xfs_flush_bdev_async(log->l_mp->m_ddev_targp->bt_bdev, &bdev_flush);
> +
> +	/*
> +	 * Pull all the log vectors off the items in the CIL, and remove the
> +	 * items from the CIL. We don't need the CIL lock here because it's only
> +	 * needed on the transaction commit side which is currently locked out
> +	 * by the flush lock.
>  	 */
>  	lv = NULL;
>  	num_iovecs = 0;
> @@ -806,6 +821,12 @@ xlog_cil_push_work(
>  	lvhdr.lv_iovecp = &lhdr;
>  	lvhdr.lv_next = ctx->lv_chain;
>  
> +	/*
> +	 * Before we format and submit the first iclog, we have to ensure that
> +	 * the metadata writeback ordering cache flush is complete.
> +	 */
> +	wait_for_completion(&bdev_flush);
> +
>  	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
>  	if (error)
>  		goto out_abort_free_ticket;
> -- 
> 2.28.0
> 
