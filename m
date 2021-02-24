Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C6FC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF0B64F06
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhBXVOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:14:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229886AbhBXVOU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:14:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7518464F03;
        Wed, 24 Feb 2021 21:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614201218;
        bh=GrtELNmYzdI5H5l1pEpQJScv/My/WFJCFAXewpEc/4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p66KvDXdXvstK7fE4NtQOJF1P5omp46YLvHJESzBRDf56hlFfZiRfAjM26JZjhxXL
         /IyaZxC/gBPkIKbPxi+2YPFsxeRbsW+OmpQs1rYng/SpgX7PBrG+N+VZrB1WxeGJf+
         7UY5Y7v+h9jHlGkhp5Ho4k/Q/HnPVYnVXNuqW83mMFjWh+1mng+eoXCkpD9Fb4MbUC
         3PwKcGSjFZEJFP9lgmck9KetdvdC/s2jFePp6s3T48eODhkKYf0I8lUluRG/NYqZDC
         qOk4O7D/GOZQ3u8ybGI06mXF1xDzHZHQlY8yYpaPsZXshwdyp6rxO8JVKp029zW/yn
         xtVASB0m+eWbg==
Date:   Wed, 24 Feb 2021 13:13:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <20210224211337.GW7272@magnolia>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223080503.GW4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 07:05:03PM +1100, Dave Chinner wrote:
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

If I've gotten this right so far, patch 4 introduces the ability to
flush the data device while we get ready to overwrite parts of the log.
This patch makes it so that writing a commit (or unmount) record to an
iclog causes that iclog write to be issued (to the log device) with at
least FUA set, and possibly PREFLUSH if we've written out more than one
iclog since the last commit?

IOWs, the data device flush is now asynchronous with CIL processing and
we've ripped out all the cache flushes and FUA writes for iclogs except
for the last one in a chain, which should maintain data integrity
requirements 1 and 2?

If that's correct,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

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
>  
>  	xlog_verify_iclog(log, iclog, count);
> -	xlog_write_iclog(log, iclog, bno, count, need_flush);
> +	xlog_write_iclog(log, iclog, bno, count);
>  }
>  
>  /*
> @@ -2469,10 +2471,21 @@ xlog_write(
>  		ASSERT(log_offset <= iclog->ic_size - 1);
>  		ptr = iclog->ic_datap + log_offset;
>  
> -		/* start_lsn is the first lsn written to. That's all we need. */
> +		/* Start_lsn is the first lsn written to. */
>  		if (start_lsn && !*start_lsn)
>  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
> +		/*
> +		 * iclogs containing commit records or unmount records need
> +		 * to issue ordering cache flushes and commit immediately
> +		 * to stable storage to guarantee journal vs metadata ordering
> +		 * is correctly maintained in the storage media.
> +		 */
> +		if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> +			iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH |
> +						XLOG_ICL_NEED_FUA);
> +		}
> +
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
>  		 * of space which was allocated by xlog_state_get_iclog_space().
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4093d2d0db7c..370da7c2bfc8 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -894,10 +894,15 @@ xlog_cil_push_work(
>  
>  	/*
>  	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog.
> +	 * iclogs to complete before we submit the commit_iclog. If it is in the
> +	 * same iclog as the start of the checkpoint, then we can skip the iclog
> +	 * cache flush because there are no other iclogs we need to order
> +	 * against.
>  	 */
>  	if (ctx->start_lsn != commit_lsn)
>  		xlog_wait_on_iclog_lsn(commit_iclog, ctx->start_lsn);
> +	else
> +		commit_iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
>  
>  	/* release the hounds! */
>  	xfs_log_release_iclog(commit_iclog);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 10a41b1dd895..a77e00b7789a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -133,6 +133,9 @@ enum xlog_iclog_state {
>  
>  #define XLOG_COVER_OPS		5
>  
> +#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
> +
>  /* Ticket reservation region accounting */ 
>  #define XLOG_TIC_LEN_MAX	15
>  
> @@ -201,6 +204,7 @@ typedef struct xlog_in_core {
>  	u32			ic_size;
>  	u32			ic_offset;
>  	enum xlog_iclog_state	ic_state;
> +	unsigned int		ic_flags;
>  	char			*ic_datap;	/* pointer to iclog data */
>  
>  	/* Callback structures need their own cacheline */
