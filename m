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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89560C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 12:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9C1601FF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 12:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhBWMNX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 07:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbhBWMNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 07:13:22 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F84C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 04:12:42 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g20so9719339plo.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 04:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=cNtRQuc9eDYedBW+UMU2NkXbmYAjSFjq8jonVKtpJSk=;
        b=Q3AkiJ5gGn+79QASUtDkB+kw/hRTw43OVx3l5eRkH8GXVM89hW05TtsvzLCfZirjHA
         M6XMyzYTh1JBDT32UIkNZVghz1ALvf/Qfvl46JiCg25f1qk0fmniyXbVaZzffJK0avwg
         Sp00Xg3aaCRpq5/XPGyfiJkiNUJ1DOhcxrB59jdm0OphUNTQjRJi/vKj6hItOJnr3ml/
         H/e74C1fZXuhQyfqawDsSgs70SC/VQL+n1KJOd4D2gBVwpL8O12ovn9W5rsLA+p1w5VG
         NePYx9voTQzR5y3cO0B+O/R0aWIcSyfus1JNJFrx/iSiO4eaUOsDwu9WcFh0dO990KUu
         QyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=cNtRQuc9eDYedBW+UMU2NkXbmYAjSFjq8jonVKtpJSk=;
        b=hbDNOUeLKO+D1lQDoCVLIoBJ/iQcy0UfA2P6e3JpO8NUr6eiZuZH8jQoU0ZDi58IUY
         FITClDjHJDwbmvZVgp3Bl8kD14Q1vW70xHALA1MUee7OkR/k4J/S0QXgtAHqS8tVzLl1
         FAIvDRc/tu6NaDS59a3nvRfJiBVFZBitMxYpvBuaI/f6GNTVkUu4YXuaRV+aROBg04bP
         /EY9k933Sh4JdT8QEjI2jSchn6Fgy30BjsPkJgCEsykNP/OOD5reX1wq3abryGdXbalS
         TQ9GRw6jz5M35dDKgaqFFzZNBvS1VwRKClRkAqBO+C6mqMY9NW3AGLcNI0v6fIpG2T0t
         C9Ow==
X-Gm-Message-State: AOAM530PZPL7LWzUmU585/24jWrbjNF5fYBitJkDTeLOiqk/3uRxu17z
        Hv8ExgGRCCY/nvyrzmpE6ZEp/KgcGGw=
X-Google-Smtp-Source: ABdhPJzij/XWwbvezroGIT8v6ImsL1UiSlI3PCNFzZ5V4fGWQr7nBmzHaLgitJRD4lyjDtEcFl/jBQ==
X-Received: by 2002:a17:90a:c698:: with SMTP id n24mr13024218pjt.81.1614082362157;
        Tue, 23 Feb 2021 04:12:42 -0800 (PST)
Received: from garuda ([122.171.216.250])
        by smtp.gmail.com with ESMTPSA id 188sm14000091pfz.119.2021.02.23.04.12.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 04:12:41 -0800 (PST)
References: <20210223033442.3267258-1-david@fromorbit.com> <20210223033442.3267258-3-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
In-reply-to: <20210223033442.3267258-3-david@fromorbit.com>
Date:   Tue, 23 Feb 2021 17:42:38 +0530
Message-ID: <87h7m3m18p.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Feb 2021 at 09:04, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> To allow for iclog IO device cache flush behaviour to be optimised,
> we first need to separate out the commit record iclog IO from the
> rest of the checkpoint so we can wait for the checkpoint IO to
> complete before we issue the commit record.
>
> This separation is only necessary if the commit record is being
> written into a different iclog to the start of the checkpoint as the
> upcoming cache flushing changes requires completion ordering against
> the other iclogs submitted by the checkpoint.
>
> If the entire checkpoint and commit is in the one iclog, then they
> are both covered by the one set of cache flush primitives on the
> iclog and hence there is no need to separate them for ordering.
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

The changes seem to be logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 55 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_cil.c  |  7 ++++++
>  fs/xfs/xfs_log_priv.h |  2 ++
>  3 files changed, 64 insertions(+)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa284f26d10e..ff26fb46d70f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -808,6 +808,61 @@ xlog_wait_on_iclog(
>  	return 0;
>  }
>  
> +/*
> + * Wait on any iclogs that are still flushing in the range of start_lsn to the
> + * current iclog's lsn. The caller holds a reference to the iclog, but otherwise
> + * holds no log locks.
> + *
> + * We walk backwards through the iclogs to find the iclog with the highest lsn
> + * in the range that we need to wait for and then wait for it to complete.
> + * Completion ordering of iclog IOs ensures that all prior iclogs to the
> + * candidate iclog we need to sleep on have been complete by the time our
> + * candidate has completed it's IO.
> + *
> + * Therefore we only need to find the first iclog that isn't clean within the
> + * span of our flush range. If we come across a clean, newly activated iclog
> + * with a lsn of 0, it means IO has completed on this iclog and all previous
> + * iclogs will be have been completed prior to this one. Hence finding a newly
> + * activated iclog indicates that there are no iclogs in the range we need to
> + * wait on and we are done searching.
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
