Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870DEC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jan 2021 09:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6388864E02
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jan 2021 09:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhA3JOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Jan 2021 04:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbhA3JOd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Jan 2021 04:14:33 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462ADC061352
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jan 2021 01:13:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u15so6843317plf.1
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jan 2021 01:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=MeL6EkMmrhWBM7WwbOoeCrKnJT808SCRmajRgBJbK80=;
        b=rny5pa2/ygutPRjB772oIJbvUITojpBTCkXMeMEEW+w1O+LhWvCqpL/2JzObJYZHML
         JeKHCJe4jkdeQ4prA4Bc5/Ba4YEkswMUcLUBWasCZ5Ej8/odrd6yLzd5gSclAED+3vVG
         pk0YH8X4+Ibjb4oUcxv9l+DTEzspEZ3b5abCGlkkn6+xnKS1ePiNVuGrIhVRs6zX/wKf
         BCF1MZ8vH+fYzcznIdASW+qM/Udd8gjGaTD/y8dQHI39cSjWMP5ELxvQH32LAIN4ijT4
         xlFX2qUY/YOrNEGZe7mSh8Nz0SkDBejj1DWyqgGJW4pH9Ozx4aS260z2khWI2cZ+dbjN
         hr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=MeL6EkMmrhWBM7WwbOoeCrKnJT808SCRmajRgBJbK80=;
        b=iulWvP6jCgTIRpxtX+a4Za55uXKU+2WsaZgp2Uagl6AiQG90bdHUIXgfrB0WdQnTVA
         tA2dTrfT0DrvyKit5fYJv/hL6AtFV8flUvYhrsVCoBsz5Op4tyvjcKbdiTKRVHE7QLjn
         mMHky3KuCX7tIW17IqFPmwuFc37iVeA8I0VdWsy3tL16UfBUvoTCbhWrZ9LsCTnQXTDG
         XnvWZljZ/3zdg9e4BxfJAgoV+ca40QDzeZTyj09N3t4ALApgislEbCx3hUOUydEmAFoM
         pmtpq0hEK1vqZu5xQHxfws9GYnxL2A29tsYrpTMOOjTLlW54M5tmyCXoaw/fhY/P95QM
         yS2g==
X-Gm-Message-State: AOAM531DhMYy1ZVerV3sEcB8e4Sy+nxtOyTd/z+ARJ/IsCPWH9DOZBST
        qkdf03HRaVYOXDpflBTr85ZFq3o9xcg=
X-Google-Smtp-Source: ABdhPJzeXHcgpXfqs8vwLk8XaHm0JvO+/O7Uk3Y8PB+/Twme4xcWugoglqP8WsZrtVOvtzFJCps6DA==
X-Received: by 2002:a17:90a:404c:: with SMTP id k12mr8354280pjg.4.1611998032686;
        Sat, 30 Jan 2021 01:13:52 -0800 (PST)
Received: from garuda ([122.171.163.8])
        by smtp.gmail.com with ESMTPSA id 77sm11500753pfz.100.2021.01.30.01.13.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Jan 2021 01:13:52 -0800 (PST)
References: <20210128044154.806715-1-david@fromorbit.com> <20210128044154.806715-3-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: separate CIL commit record IO
In-reply-to: <20210128044154.806715-3-david@fromorbit.com>
Date:   Sat, 30 Jan 2021 14:43:49 +0530
Message-ID: <878s8ass6q.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jan 2021 at 10:11, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> To allow for iclog IO device cache flush behaviour to be optimised,
> we first need to separate out the commit record iclog IO from the
> rest of the checkpoint so we can wait for the checkpoint IO to
> complete before we issue the commit record.
>
> This separate is only necessary if the commit record is being
> written into a different iclog to the start of the checkpoint. If
> the entire checkpoint and commit is in the one iclog, then they are
> both covered by the one set of cache flush primitives on the iclog
> and hence there is no need to separate them.
>
> Otherwise, we need to wait for all the previous iclogs to complete
> so they are ordered correctly and made stable by the REQ_PREFLUSH
> that the commit record iclog IO issues. This guarantees that if a
> reader sees the commit record in the journal, they will also see the
> entire checkpoint that commit record closes off.
>
> This also provides the guarantee that when the commit record IO
> completes, we can safely unpin all the log items in the checkpoint
> so they can be written back because the entire checkpoint is stable
> in the journal.
>

W.r.t correctness of the changes in this patch,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 47 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_cil.c  |  7 +++++++
>  fs/xfs/xfs_log_priv.h |  2 ++
>  3 files changed, 56 insertions(+)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c5f507c24577..c5e3da23961c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -808,6 +808,53 @@ xlog_wait_on_iclog(
>  	return 0;
>  }
>  
> +/*
> + * Wait on any iclogs that are still flushing in the range of start_lsn to
> + * the current iclog's lsn. The caller holds a reference to the iclog, but
> + * otherwise holds no log locks.
> + *
> + * We walk backwards through the iclogs to find the iclog with the highest lsn
> + * in the range that we need to wait for and then wait for it to complete.
> + * Completion ordering of iclog IOs ensures that all prior iclogs to this IO are
> + * complete by the time our candidate has completed.
> + */
> +int
> +xlog_wait_on_iclog_lsn(
> +	struct xlog_in_core	*iclog,
> +	xfs_lsn_t		start_lsn)
> +{
> +	struct xlog		*log = iclog->ic_log;
> +	struct xlog_in_core	*prev;
> +	int			error = -EIO;
> +
> +	spin_lock(&log->l_icloglock);
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		goto out_unlock;
> +
> +	error = 0;
> +	for (prev = iclog->ic_prev; prev != iclog; prev = prev->ic_prev) {
> +
> +		/* Done if the lsn is before our start lsn */
> +		if (XFS_LSN_CMP(be64_to_cpu(prev->ic_header.h_lsn),
> +				start_lsn) < 0)
> +			break;
> +
> +		/* Don't need to wait on completed, clean iclogs */
> +		if (prev->ic_state == XLOG_STATE_DIRTY ||
> +		    prev->ic_state == XLOG_STATE_ACTIVE) {
> +			continue;
> +		}
> +
> +		/* wait for completion on this iclog */
> +		xlog_wait(&prev->ic_force_wait, &log->l_icloglock);
> +		return 0;
> +	}
> +
> +out_unlock:
> +	spin_unlock(&log->l_icloglock);
> +	return error;
> +}
> +
>  /*
>   * Write out an unmount record using the ticket provided. We have to account for
>   * the data space used in the unmount ticket as this write is not done from a
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b0ef071b3cb5..c5cc1b7ad25e 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -870,6 +870,13 @@ xlog_cil_push_work(
>  	wake_up_all(&cil->xc_commit_wait);
>  	spin_unlock(&cil->xc_push_lock);
>  
> +	/*
> +	 * If the checkpoint spans multiple iclogs, wait for all previous
> +	 * iclogs to complete before we submit the commit_iclog.
> +	 */
> +	if (ctx->start_lsn != commit_lsn)
> +		xlog_wait_on_iclog_lsn(commit_iclog, ctx->start_lsn);
> +
>  	/* release the hounds! */
>  	xfs_log_release_iclog(commit_iclog);
>  	return;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 037950cf1061..a7ac85aaff4e 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -584,6 +584,8 @@ xlog_wait(
>  	remove_wait_queue(wq, &wait);
>  }
>  
> +int xlog_wait_on_iclog_lsn(struct xlog_in_core *iclog, xfs_lsn_t start_lsn);
> +
>  /*
>   * The LSN is valid so long as it is behind the current LSN. If it isn't, this
>   * means that the next log record that includes this metadata could have a


-- 
chandan
