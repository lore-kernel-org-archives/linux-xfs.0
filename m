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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F19AC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 12:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A3B60234
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 12:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhG0Mq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhG0Mq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 08:46:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26305C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 05:46:57 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so4033504pjb.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 05:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=eiHEMQDUaHOsVqdoai/5mCr3sUUZYfdJgbkg4RX7QLc=;
        b=k3zXkWuSQE9PsWy5eYh0+v6YTJJ71EYHFUQshi9pTiVlsoweMm1aTl/6H9gcNOg/g0
         U7WhjP+XWmM7FB+JENAUyOs/MNkGcqYy/pd6x/e0gSrze+rlS9FhazHc//3uAGqaj9Wd
         I2Kl/gWUX0qK5Q60wxy8GS0SFM+WceB0AwMhQ1P+mG0qqhK0oKeelXNy4bgjFab/ig9n
         zZtcxW/NUe4ElsHNJaySZxQaUaUeuK//6CRKItnbRKinm6oC3QHaCXDRDRxHpUjvqGPN
         PAbpm8R7V9uvY8/W6uIAHsJc3ZraDS8BI8d9B7CqvoZlIZJkBkytAyvVw046Xtxr+7ua
         zX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=eiHEMQDUaHOsVqdoai/5mCr3sUUZYfdJgbkg4RX7QLc=;
        b=jYfR8GlL57ElpqzMQGcg+iJMc3PTf4xayeBICWVR8R/SAEhOxPqsKU9stmMYyjKBm/
         8A6OS8NgJjexAYhUbdpzxHw1KR/gXSb/5qHWQSgno87zGiC6C7pfRE/n8JFVncZNujWo
         +A9WE8tnNSGIPdHvxp0s60v9VJF1sIC2JcfhtIu0sGXpuQGQnvwjB7Jk3DjHLzMuLqda
         AmzitUOkFZpYwRsQeXuLHRoTFuV5Mi/nKtl00FMiyJ37WgtbwRBIFVcVd7eMrxv/cQzI
         Hs86+XUPRZ9iqIwkvnylIYTWnWN9UHsrI4JMjGJQXLcC8ZN8VPDCqoQNkAcWPR7+cBsU
         BPmA==
X-Gm-Message-State: AOAM532gnGt3lwBdL/7epuwqMJk99vMv/UT/MhC/3M6S3Cg/2WsPNNV2
        lgUYFy0Rd2WGGJkvVbqwZSt/s+j/Qi0=
X-Google-Smtp-Source: ABdhPJw7IYPFY3s0NKLhvG0xruaVqESONs1h6vntzFOeYf1Lh3dALQrx1cO249vwikq1NmAqSzEeNA==
X-Received: by 2002:a17:90a:fb85:: with SMTP id cp5mr19703250pjb.214.1627390016499;
        Tue, 27 Jul 2021 05:46:56 -0700 (PDT)
Received: from garuda ([122.171.185.191])
        by smtp.gmail.com with ESMTPSA id o9sm3905506pfh.217.2021.07.27.05.46.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 05:46:56 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-3-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 02/16] xfs: clear log incompat feature bits when the log is idle
In-reply-to: <20210727062053.11129-3-allison.henderson@oracle.com>
Date:   Tue, 27 Jul 2021 18:16:53 +0530
Message-ID: <87a6m7gc02.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
>
> When there are no ongoing transactions and the log contents have been
> checkpointed back into the filesystem, the log performs 'covering',
> which is to say that it log a dummy transaction to record the fact that
> the tail has caught up with the head.  This is a good time to clear log
> incompat feature flags, because they are flags that are temporarily set
> to limit the range of kernels that can replay a dirty log.
>
> Since it's possible that some other higher level thread is about to
> start logging items protected by a log incompat flag, we create a rwsem
> so that upper level threads can coordinate this with the log.  It would
> probably be more performant to use a percpu rwsem, but the ability to
> /try/ taking the write lock during covering is critical, and percpu
> rwsems do not provide that.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_log.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log.h      |  3 +++
>  fs/xfs/xfs_log_priv.h |  3 +++
>  3 files changed, 55 insertions(+)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9254405..c58a0d7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1338,6 +1338,32 @@ xfs_log_work_queue(
>  }
>  
>  /*
> + * Clear the log incompat flags if we have the opportunity.
> + *
> + * This only happens if we're about to log the second dummy transaction as part
> + * of covering the log and we can get the log incompat feature usage lock.
> + */
> +static inline void
> +xlog_clear_incompat(
> +	struct xlog		*log)
> +{
> +	struct xfs_mount	*mp = log->l_mp;
> +
> +	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
> +		return;
> +
> +	if (log->l_covered_state != XLOG_STATE_COVER_DONE2)
> +		return;
> +
> +	if (!down_write_trylock(&log->l_incompat_users))
> +		return;
> +
> +	xfs_clear_incompat_log_features(mp);
> +	up_write(&log->l_incompat_users);
> +}
> +
> +/*
>   * Every sync period we need to unpin all items in the AIL and push them to
>   * disk. If there is nothing dirty, then we might need to cover the log to
>   * indicate that the filesystem is idle.
> @@ -1363,6 +1389,7 @@ xfs_log_worker(
>  		 * synchronously log the superblock instead to ensure the
>  		 * superblock is immediately unpinned and can be written back.
>  		 */
> +		xlog_clear_incompat(log);
>  		xfs_sync_sb(mp, true);
>  	} else
>  		xfs_log_force(mp, 0);
> @@ -1450,6 +1477,8 @@ xlog_alloc_log(
>  	}
>  	log->l_sectBBsize = 1 << log2_size;
>  
> +	init_rwsem(&log->l_incompat_users);
> +
>  	xlog_get_iclog_buffer_size(mp, log);
>  
>  	spin_lock_init(&log->l_icloglock);
> @@ -3895,3 +3924,23 @@ xfs_log_in_recovery(
>  
>  	return log->l_flags & XLOG_ACTIVE_RECOVERY;
>  }
> +
> +/*
> + * Notify the log that we're about to start using a feature that is protected
> + * by a log incompat feature flag.  This will prevent log covering from
> + * clearing those flags.
> + */
> +void
> +xlog_use_incompat_feat(
> +	struct xlog		*log)
> +{
> +	down_read(&log->l_incompat_users);
> +}
> +
> +/* Notify the log that we've finished using log incompat features. */
> +void
> +xlog_drop_incompat_feat(
> +	struct xlog		*log)
> +{
> +	up_read(&log->l_incompat_users);
> +}
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 813b972..b274fb9 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -142,4 +142,7 @@ bool	xfs_log_in_recovery(struct xfs_mount *);
>  
>  xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
>  
> +void xlog_use_incompat_feat(struct xlog *log);
> +void xlog_drop_incompat_feat(struct xlog *log);
> +
>  #endif	/* __XFS_LOG_H__ */
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 4c41bbfa..c507041 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -449,6 +449,9 @@ struct xlog {
>  	xfs_lsn_t		l_recovery_lsn;
>  
>  	uint32_t		l_iclog_roundoff;/* padding roundoff */
> +
> +	/* Users of log incompat features should take a read lock. */
> +	struct rw_semaphore	l_incompat_users;
>  };
>  
>  #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \


-- 
chandan
