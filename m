Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15445C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jan 2021 12:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4D664E09
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jan 2021 12:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhA3M50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Jan 2021 07:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhA3M5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Jan 2021 07:57:25 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7175C061573
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jan 2021 04:56:44 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id kx7so7221092pjb.2
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jan 2021 04:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=iW/v3K9W8peIWsZFg5huWmHDc7bFeNwqaBPRqcYM0Lg=;
        b=ghMsdgpJhtG7odqvNCZmfTaNzX0byayIkGCTabhJHInUHLV15zWEDJBzcI03inwV2k
         mFzGr0RVjgdrWFjgF8YoeY303WxcVtc4Wt6sTl+uq68jXjZGXk+67s3VkhOB7ZKWAiu7
         we0s7i/0GebYruEMwengsN0TYLweU96v3KR7unY6/ucgc0gOeSZN37ktAtJhjpV53Fbp
         BkjkMudZqOJfw03jqT9b6aLZmRb35z3zi9EHVC9sRvZdJ9qam+yROdc+G/sKXctLxUFi
         BkzslXNRA+I++s0KJ+9SX861osURY2pO4e2pjW5ZkEKZ9EgxGZojvEXTodX/lpPiKbhq
         a30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=iW/v3K9W8peIWsZFg5huWmHDc7bFeNwqaBPRqcYM0Lg=;
        b=CNfXxmPYUSwCEHO1w1h+zxEIBh6LCfbzJpDKbbTDbxbDX/rlOAP2WX9LoJ1VJXdba9
         ENUYp0OdKmDbWRJMYgIoqHoShkuxaE+e3lQr0vspdZvdo62Y1Xkv/M44DAwqo6zV9rN1
         G7w/1PV0DE1wglMAkmucdhy0uxiw/kBX6ZJ48nJnkKeUCRNLbxSUlwPcI1UgovaIBymG
         9/sRcZLPmZRMZsuG9N+lfKXm/Tjbruy3Lw39bxI3p/5nX/RGK59MuDdktF79Bx1/t7TK
         HSlZqdwZturQ8XOU2tEdBBQKZG9KDQwXBAhN655ZXmDJ0UNbsNlF3GhX7O3KQU0wxSQ9
         F/Kg==
X-Gm-Message-State: AOAM533MioyFDGd19jguiz2JUYhWEBZClnOLu5Busx76IiyTE5y4gTky
        EWXHZBqVauHCmKTbBcbS0TYgG11XT2o=
X-Google-Smtp-Source: ABdhPJyjJ3KqI8YPrLZ/C8znexfmGCin2olhuMMApKfo9xjpBNiJXOLmgySvi7L1P8T/NSW0kzw3xA==
X-Received: by 2002:a17:90b:4c85:: with SMTP id my5mr9228281pjb.225.1612011403930;
        Sat, 30 Jan 2021 04:56:43 -0800 (PST)
Received: from garuda ([122.171.163.8])
        by smtp.gmail.com with ESMTPSA id ob6sm9526932pjb.30.2021.01.30.04.56.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Jan 2021 04:56:43 -0800 (PST)
References: <20210128044154.806715-1-david@fromorbit.com> <20210128044154.806715-4-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: journal IO cache flush reductions
In-reply-to: <20210128044154.806715-4-david@fromorbit.com>
Date:   Sat, 30 Jan 2021 18:26:40 +0530
Message-ID: <877dnushvb.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jan 2021 at 10:11, Dave Chinner wrote:
> From: Steve Lord <lord@sgi.com>
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
> THe ordering guarantees of #1 are provided by REQ_PREFLUSH. This
> causes the journal IO to issue a cache flush and wait for it to
> complete before issuing the write IO to the journal. Hence all
> completed metadata IO is guaranteed to be stable before the journal
> overwrites the old metadata.
>
> THe ordering guarantees of #2 are provided by the REQ_FUA, which
> ensures the journal writes do not complete until they are on stable
> storage. Hence by the time the last journal IO in a checkpoint
> completes, we know that the entire checkpoint is on stable storage
> and we can unpin the dirty metadata and allow it to be written back.
>
> This is the mechanism by which ordering was first implemented in XFS
> way back in 2002 by this commit:
>
> commit 95d97c36e5155075ba2eb22b17562cfcc53fcf96
> Author: Steve Lord <lord@sgi.com>
> Date:   Fri May 24 14:30:21 2002 +0000
>
>     Add support for drive write cache flushing - should the kernel
>     have the infrastructure
>
> A lot has changed since then, most notably we now use delayed
> logging to checkpoint the filesystem to the journal rather than
> write each individual transaction to the journal. Cache flushes on
> journal IO are necessary when individual transactions are wholly
> contained within a single iclog. However, CIL checkpoints are single
> transactions that typically span hundreds to thousands of individual
> journal writes, and so the requirements for device cache flushing
> have changed.
>
> That is, the ordering rules I state above apply to ordering of
> atomic transactions recorded in the journal, not to the journal IO
> itself. Hence we need to ensure metadata is stable before we start
> writing a new transaction to the journal (guarantee #1), and we need
> to ensure the entire transaction is stable in the journal before we
> start metadata writeback (guarantee #2).
>
> Hence we only need a REQ_PREFLUSH on the journal IO that starts a
> new journal transaction to provide #1, and it is not on any other
> journal IO done within the context of that journal transaction.
>
> To ensure that the entire journal transaction is on stable storage
> before we run the completion code that unpins all the dirty metadata
> recorded in the journal transaction, the last write of the
> transaction must also ensure that the entire journal transaction is
> stable. We already know what IO that will be, thanks to the commit
> record we explicitly write to complete the transaction. We can order
> all the previous journal IO for this transaction by waiting for all
> the previous iclogs containing the transaction data to complete
> their IO, then issuing the commit record IO using REQ_PREFLUSH
> | REQ_FUA. The preflush ensures all the previous journal IO is
> stable before the commit record hits the log, and the REQ_FUA
> ensures that the commit record is stable before completion is
> signalled to the filesystem.
>
> Hence using REQ_PREFLUSH on the first IO of a journal transaction,
> and then ordering the journal IO before issuing the commit record
> with REQ_PREFLUSH | REQ_FUA, we get all the same ordering guarantees
> that we currently achieve by issuing all journal IO with cache
> flushes.
>
> As an optimisation, when the commit record lands in the same iclog
> as the journal transaction starts, we don't need to wait for
> anything and can simply issue the journal IO with REQ_PREFLUSH |
> REQ_FUA as we do right now. This means that for fsync() heavy
> workloads, the cache flush behaviour is completely unchanged and
> there is no degradation in performance as a result of optimise the
> multi-IO transaction case.
>
> To further simplify the implementation, we also issue the initial IO
> in a journal transaction with REQ_FUA. THis ensures the journal is
> dirtied by the first IO in a long running transaction as quickly as
> possible. This helps ensure that log recovery will at least have a
> transaction header for the incomplete transaction in the log similar
> to the stable journal write behaviour we have now.
>
> The most notable sign that there is less IO latency on my test
> machine (nvme SSDs) is that the "noiclogs" rate has dropped
> substantially. This metric indicates that the CIL push is blocking
> in xlog_get_iclog_space() waiting for iclog IO completion to occur.
> With 8 iclogs of 256kB, the rate is appoximately 1 noiclog event to
> every 4 iclog writes. IOWs, every 4th call to xlog_get_iclog_space()
> is blocking waiting for log IO. With the changes in this patch, this
> drops to 1 noiclog event for every 100 iclog writes. Hence it is
> clear that log IO is completing much faster than it was previously,
> but it is also clear that for large iclog sizes, this isn't the
> performance limiting factor on this hardware.
>
> With smaller iclogs (32kB), however, there is a sustantial
> difference. With the cache flush modifications, the journal is now
> running at over 4000 write IOPS, and the journal throughput is
> largely identical to the 256kB iclogs and the noiclog event rate
> stays low at about 1:50 iclog writes. The existing code tops out at
> about 2500 IOPS as the number of cache flushes dominate performance
> and latency. The noiclog event rate is about 1:4, and the
> performance variance is quite large as the journal throughput can
> fall to less than half the peak sustained rate when the cache flush
> rate prevents metadata writeback from keeping up and the log runs
> out of space and throttles reservations.
>
> As a result:
>
> 	logbsize	fsmark create rate	rm -rf
> before	32kb		152851+/-5.3e+04	5m28s
> patched	32kb		221533+/-1.1e+04	5m24s
>
> before	256kb		220239+/-6.2e+03	4m58s
> patched	256kb		228286+/-9.2e+03	5m06s
>
> The rm -rf times are included because I ran them, but the
> differences are largely noise. This workload is largely metadata
> read IO latency bound and the changes to the journal cache flushing
> doesn't really make any noticable difference to behaviour apart from
> a reduction in noiclog events from background CIL pushing.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 34 ++++++++++++++++++++++------------
>  fs/xfs/xfs_log_priv.h |  3 +++
>  2 files changed, 25 insertions(+), 12 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c5e3da23961c..8de93893e0e6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1804,8 +1804,7 @@ xlog_write_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog,
>  	uint64_t		bno,
> -	unsigned int		count,
> -	bool			need_flush)
> +	unsigned int		count)
>  {
>  	ASSERT(bno < log->l_logBBsize);
>
> @@ -1843,10 +1842,11 @@ xlog_write_iclog(
>  	 * writeback throttle from throttling log writes behind background
>  	 * metadata writeback and causing priority inversions.
>  	 */
> -	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC |
> -				REQ_IDLE | REQ_FUA;
> -	if (need_flush)
> -		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> +	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
> +	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
> +		iclog->ic_bio.bi_opf |= REQ_PREFLUSH | REQ_FUA;
> +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
> +	}
>
>  	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> @@ -1949,7 +1949,7 @@ xlog_sync(
>  	unsigned int		roundoff;       /* roundoff to BB or stripe */
>  	uint64_t		bno;
>  	unsigned int		size;
> -	bool			need_flush = true, split = false;
> +	bool			split = false;
>
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>
> @@ -2007,13 +2007,14 @@ xlog_sync(
>  	 * synchronously here; for an internal log we can simply use the block
>  	 * layer state machine for preflushes.
>  	 */
> -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> +	if (log->l_targ != log->l_mp->m_ddev_targp ||
> +	    (split && (iclog->ic_flags & XLOG_ICL_NEED_FLUSH))) {
>  		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> -		need_flush = false;
> +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
>  	}

When the log is stored on an external device and say the iclog above contains
the commit record of a multi-IO journal transaction, the "if" statement's
condition evaluates to true. This causes the data device's cache to be
flushed and the flag XLOG_ICL_NEED_FLUSH to be removed from iclog->ic_flags.

The call to xlog_write_iclog() below will result in submitting a bio that does
not have "REQ_PREFLUSH | REQ_FUA" flags set. Hence this causes #2 constraint
to be violated since the log device's cache has not been flushed by the time
filesystem is informed about the completion of IO.


>
>  	xlog_verify_iclog(log, iclog, count);
> -	xlog_write_iclog(log, iclog, bno, count, need_flush);
> +	xlog_write_iclog(log, iclog, bno, count);
>  }
>
>  /*
> @@ -2464,9 +2465,18 @@ xlog_write(
>  		ASSERT(log_offset <= iclog->ic_size - 1);
>  		ptr = iclog->ic_datap + log_offset;
>
> -		/* start_lsn is the first lsn written to. That's all we need. */
> -		if (!*start_lsn)
> +		/*
> +		 * Start_lsn is the first lsn written to. That's all the caller
> +		 * needs to have returned. Setting it indicates the first iclog
> +		 * of a new checkpoint or the commit record for a checkpoint, so
> +		 * also mark the iclog as requiring a pre-flush to ensure all
> +		 * metadata writeback or journal IO in the checkpoint is
> +		 * correctly ordered against this new log write.
> +		 */
> +		if (!*start_lsn) {
>  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> +		}
>
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index a7ac85aaff4e..9f1e627ccb74 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -133,6 +133,8 @@ enum xlog_iclog_state {
>
>  #define XLOG_COVER_OPS		5
>
> +#define XLOG_ICL_NEED_FLUSH     (1 << 0)        /* iclog needs REQ_PREFLUSH */
> +
>  /* Ticket reservation region accounting */
>  #define XLOG_TIC_LEN_MAX	15
>
> @@ -201,6 +203,7 @@ typedef struct xlog_in_core {
>  	u32			ic_size;
>  	u32			ic_offset;
>  	enum xlog_iclog_state	ic_state;
> +	unsigned int		ic_flags;
>  	char			*ic_datap;	/* pointer to iclog data */
>
>  	/* Callback structures need their own cacheline */


--
chandan
