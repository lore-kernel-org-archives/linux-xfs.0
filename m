Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8F2C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 07:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B8F64EBB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 07:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBXHRD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 02:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhBXHRC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 02:17:02 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA9EC06174A
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 23:16:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id w18so639020plc.12
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 23:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jAcimEZMrpJNN70yEeGzowxamEJVkgVW4Lv0cmjFx4Q=;
        b=QSP/ZSZ4ODBnO9I4rhkLMmavj+cQyAWsxVCVWuj/VFM1NRg6ci+E08wdREZtQuJshG
         og/9cBkdv5JW2fn4awaLccB43Wau0ZG8NnqEk7qJw492jkifQePVhXGvJEgNq42v5KGN
         N9gsfkjxGbAzb+fi4NLvH/l7uXJ8F5P1DKyPj3MtXwGQlgGTZMhqk6IVvtS+uw1ytKb0
         8JeDOWTlmzHcgchAS7519+CHLBJIb5gNjOoS9MsRQOoCdQSK2lbLnpyuBwgUCsMFVURg
         /SFgP3eKIxq+KUbGv07zKReXKFAAlulVYLObaecj60sFKMFno/py0O2BvRpBW+D0Iwwd
         TJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jAcimEZMrpJNN70yEeGzowxamEJVkgVW4Lv0cmjFx4Q=;
        b=XOEwMbsKlEPZMi9AOUmSkQVwpOZVemxYqJchbcxjMqkFB0ny3YQPlsmyPc2xgzeNVs
         pAGVb/wBDylUoP5zvS9Y/IfSWAbXbVjNgRjDIGYcHptwSVYcOpKmnCPuG7TWntjamdNs
         Q591aVe6vHbTTqIW610hrCD7WciBasmeL+eR4n3trqY9lCoELFQr1o1nkAdITk1kQWDD
         cvbcOVinIvIo95rnChFHZ4YsBrlx+w8wQVyYDItYTooI06TKLfyR1TYxEkdMFYbd/VKV
         Y1udcCU8IiNqkZaI4oGJrweIFLUOTUiG9oacGGU2ht6CSuYfmLr8SdBVxr3ZF6d42thF
         RCrg==
X-Gm-Message-State: AOAM532pBk8wSBIWTW2HHj5X5KNrjyXPj8AcNiNRBOHaLJWkG8+ugjlr
        YY6KuVkXuP2ZtutTprKDkGXFm27cFFM=
X-Google-Smtp-Source: ABdhPJzfAC0boBwZ/sPt0ndLLrHLWbZTUdnLWh5B+dhW7kTK0dmgUYk0SmBrHdplCUHGWwv2zQBYRg==
X-Received: by 2002:a17:90b:1bc6:: with SMTP id oa6mr3181948pjb.86.1614150981783;
        Tue, 23 Feb 2021 23:16:21 -0800 (PST)
Received: from garuda ([122.171.161.92])
        by smtp.gmail.com with ESMTPSA id q7sm1387280pjr.13.2021.02.23.23.16.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 23:16:21 -0800 (PST)
References: <20210223033442.3267258-1-david@fromorbit.com> <20210223033442.3267258-6-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: CIL checkpoint flushes caches unconditionally
In-reply-to: <20210223033442.3267258-6-david@fromorbit.com>
Date:   Wed, 24 Feb 2021 12:46:18 +0530
Message-ID: <87v9aiorzx.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Feb 2021 at 09:04, Dave Chinner wrote:
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

Indeed, a single cache flush of the "data device" that is issued before
writing the first iclog of a CIL context is sufficient to make sure that the
metadata has really reached non-volatile storage.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
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


--
chandan
