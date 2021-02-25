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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99FCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 04:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A1464ECB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 04:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhBYEJx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 23:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhBYEJt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 23:09:49 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39229C061574
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 20:09:09 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id m6so2764977pfk.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 20:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=JB1585lJnfy+TUFk5+MmqPYaA60tJGOMVQA/5ksPmi8=;
        b=JJeV8SOMWhCoMIONdR5K665ekXSKFp+5+WBWZxMZnlyiYlDVL5KSysaZs1PhYm/h3V
         7W6KBIV/DrAHOgh7fK+NhS7da4j4idWLRDNqax/6fLsStpvYjzI9/y0VEd2nNi8j36zb
         QX5oIlcfzUyL1AK7i3ZxHJfUxuQI39MDubfNihGABP2QoyvUx366Bt0vForCNijqDOKy
         j0FJwwD0hyn7PcncCDAGgK2CmRx9ASC6pMrzHZSbM2fpI17/kLHiLCH+NAb6rCaHAyFA
         +V/+2vuKJqMEqThmV7RXtgflXQ5JnjLXjtFR27KglcRlM8UfZm1BkZJhepIB6sgDvPw1
         D2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=JB1585lJnfy+TUFk5+MmqPYaA60tJGOMVQA/5ksPmi8=;
        b=Y2LY80uZr6ubXg2raDoR64XrPNTDTh1Q0ARfDMJc0we7bI3SUGBoHPRQNjOORKlBed
         ZyCr9YvXLjNY4MRmjPGTlEVIe/T9E/dZP2IP+CjRPGK0Oa5GZl8EuKoV6CKzL5/aLDYW
         sNn+qZyP+SpxqbhoGuVcxVRnfUg2fBn9OF6xHT+pJdUKZpBlYe0f/KiZzpqKA69IzZKl
         YVc40mfLoHjvM5wac3voL+lL/lUUNCrGsXa4Kgi7fVLpMtFzirE++CjJCMzB2F1e/2kc
         RPjtP4F3Ufw0gwSsxqRvja8Bry2QRc4D4to9Hqy8pTb5F4Jf8m+acniMIESBosP+2Tf6
         NnEQ==
X-Gm-Message-State: AOAM533npUrWaIzT66zn0ZyOZK+MLoD6r8UefpUwCT9iT3oD98Fmo+z0
        7eZZqSfgtiLiVX4otnmbF1yqZUJLujA=
X-Google-Smtp-Source: ABdhPJyOJHAFSRIbWe2uybMGTE2Pnx/DKEZHX0DSq4umtJvJmVQ2ubbL3zAOUbYmJaAdqj5KLcKLLQ==
X-Received: by 2002:a63:ab4f:: with SMTP id k15mr1215384pgp.280.1614226148473;
        Wed, 24 Feb 2021 20:09:08 -0800 (PST)
Received: from garuda ([122.172.177.10])
        by smtp.gmail.com with ESMTPSA id 140sm4427492pfv.83.2021.02.24.20.09.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Feb 2021 20:09:08 -0800 (PST)
References: <20210223033442.3267258-1-david@fromorbit.com> <20210223033442.3267258-8-david@fromorbit.com> <20210223080503.GW4662@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
In-reply-to: <20210223080503.GW4662@dread.disaster.area>
Date:   Thu, 25 Feb 2021 09:39:05 +0530
Message-ID: <8735xk7pr2.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Feb 2021 at 13:35, Dave Chinner wrote:
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
> The ordering guarantees of #1 are provided by REQ_PREFLUSH. This
> causes the journal IO to issue a cache flush and wait for it to
> complete before issuing the write IO to the journal. Hence all
> completed metadata IO is guaranteed to be stable before the journal
> overwrites the old metadata.
>
> The ordering guarantees of #2 are provided by the REQ_FUA, which
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
> The CIL checkpoint already issues a cache flush before it starts
> writing to the log, so we no longer need the iclog IO to issue a
> REQ_REFLUSH for us. Hence if XLOG_START_TRANS is passed
> to xlog_write(), we no longer need to mark the first iclog in
> the log write with REQ_PREFLUSH for this case.
>
> Given the new ordering semantics of commit records for the CIL, we
> need iclogs containing commit to issue a REQ_PREFLUSH. We also
> require unmount records to do this. Hence for both XLOG_COMMIT_TRANS
> and XLOG_UNMOUNT_TRANS xlog_write() calls we need to mark
> the first iclog being written with REQ_PREFLUSH.
>
> For both commit records and unmount records, we also want them
> immediately on stable storage, so we want to also mark the iclogs
> that contain these records to be marked REQ_FUA. That means if a
> record is split across multiple iclogs, they are all marked REQ_FUA
> and not just the last one so that when the transaction is completed
> all the parts of the record are on stable storage.
>
> As an optimisation, when the commit record lands in the same iclog
> as the journal transaction starts, we don't need to wait for
> anything and can simply use REQ_FUA to provide guarantee #2.  This
> means that for fsync() heavy workloads, the cache flush behaviour is
> completely unchanged and there is no degradation in performance as a
> result of optimise the multi-IO transaction case.
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
> Version 2:
> - repost manually without git/guilt mangling the patch author
> - fix bug in XLOG_ICL_NEED_FUA definition that didn't manifest as an
>   ordering bug in generic/45[57] until testing the CIL pipelining
>   changes much later in the series.
>
>  fs/xfs/xfs_log.c      | 33 +++++++++++++++++++++++----------
>  fs/xfs/xfs_log_cil.c  |  7 ++++++-
>  fs/xfs/xfs_log_priv.h |  4 ++++
>  3 files changed, 33 insertions(+), 11 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6c3fb6dcb505..08d68a6161ae 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1806,8 +1806,7 @@ xlog_write_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog,
>  	uint64_t		bno,
> -	unsigned int		count,
> -	bool			need_flush)
> +	unsigned int		count)
>  {
>  	ASSERT(bno < log->l_logBBsize);
>
> @@ -1845,10 +1844,12 @@ xlog_write_iclog(
>  	 * writeback throttle from throttling log writes behind background
>  	 * metadata writeback and causing priority inversions.
>  	 */
> -	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC |
> -				REQ_IDLE | REQ_FUA;
> -	if (need_flush)
> +	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
> +	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH)
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> +	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
> +		iclog->ic_bio.bi_opf |= REQ_FUA;
> +	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>
>  	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> @@ -1951,7 +1952,7 @@ xlog_sync(
>  	unsigned int		roundoff;       /* roundoff to BB or stripe */
>  	uint64_t		bno;
>  	unsigned int		size;
> -	bool			need_flush = true, split = false;
> +	bool			split = false;
>
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>
> @@ -2009,13 +2010,14 @@ xlog_sync(
>  	 * synchronously here; for an internal log we can simply use the block
>  	 * layer state machine for preflushes.
>  	 */
> -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> +	if (log->l_targ != log->l_mp->m_ddev_targp ||
> +	    (split && (iclog->ic_flags & XLOG_ICL_NEED_FLUSH))) {
>  		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
> -		need_flush = false;
> +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
>  	}

If a checkpoint transaction spans across 2 or more iclogs and the log is
stored on an external device, then the above would remove XLOG_ICL_NEED_FLUSH
flag from iclog->ic_flags causing xlog_write_iclog() to include only REQ_FUA
flag in the corresponding bio.

Documentation/block/writeback_cache_control.rst seems to suggest that REQ_FUA
guarantees only that the data associated with the bio is stable on disk before
I/O completion is signalled. So looks like REQ_PREFLUSH is required in this
scenario.

--
chandan
