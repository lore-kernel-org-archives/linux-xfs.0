Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A748C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C1B64EAE
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245621AbhCCDPb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382378AbhCBVps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 16:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614721459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJf1t/FortRO+6YM6EEmW7kqR1gWD06liG/yawaB2H4=;
        b=faDUsDcrVmJ6P3/KiJ+RDtVTpP5RFozdCk/HFDX7s2kyVPWiOFxoUxf9u/CHsGvUJql+5q
        2UbVbi4m0cGMVn6d9I4R3KzpghbJcKtwwnRLJ21i/Fy/SQBq0vinUniUMMwlFepqKy4P1Y
        V0STLv8uBb7g69xTq/s2/YXGW2Lx6gc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-_nNHHn8SOfus5d_2pwfo8A-1; Tue, 02 Mar 2021 16:44:16 -0500
X-MC-Unique: _nNHHn8SOfus5d_2pwfo8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C759107ACE4;
        Tue,  2 Mar 2021 21:44:15 +0000 (UTC)
Received: from bfoster (ovpn-119-215.rdu2.redhat.com [10.10.119.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F40D10023BC;
        Tue,  2 Mar 2021 21:44:14 +0000 (UTC)
Date:   Tue, 2 Mar 2021 16:44:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YD6xrJHgkkHi+7a3@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <20210224232600.GH4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224232600.GH4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 10:26:00AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AIL pushing is stalling on log forces when it comes across
> pinned items. This is happening on removal workloads where the AIL
> is dominated by stale items that are removed from AIL when the
> checkpoint that marks the items stale is committed to the journal.
> This results is relatively few items in the AIL, but those that are
> are often pinned as directories items are being removed from are
> still being logged.
> 
> As a result, many push cycles through the CIL will first issue a
> blocking log force to unpin the items. This can take some time to
> complete, with tracing regularly showing push delays of half a
> second and sometimes up into the range of several seconds. Sequences
> like this aren't uncommon:
> 
...
> 
> In each of these cases, every AIL pass saw 101 log items stuck on
> the AIL (pinned) with very few other items being found. Each pass, a
> log force was issued, and delay between last/first is the sleep time
> + the sync log force time.
> 
> Some of these 101 items pinned the tail of the log. The tail of the
> log does slowly creep forward (first lsn), but the problem is that
> the log is actually out of reservation space because it's been
> running so many transactions that stale items that never reach the
> AIL but consume log space. Hence we have a largely empty AIL, with
> long term pins on items that pin the tail of the log that don't get
> pushed frequently enough to keep log space available.
> 
> The problem is the hundreds of milliseconds that we block in the log
> force pushing the CIL out to disk. The AIL should not be stalled
> like this - it needs to run and flush items that are at the tail of
> the log with minimal latency. What we really need to do is trigger a
> log flush, but then not wait for it at all - we've already done our
> waiting for stuff to complete when we backed off prior to the log
> force being issued.
> 
> Even if we remove the XFS_LOG_SYNC from the xfs_log_force() call, we
> still do a blocking flush of the CIL and that is what is causing the
> issue. Hence we need a new interface for the CIL to trigger an
> immediate background push of the CIL to get it moving faster but not
> to wait on that to occur. While the CIL is pushing, the AIL can also
> be pushing.
> 

So I think I follow what you're describing wrt to the xfsaild delay, but
what I'm not clear on is what changing this behavior actually fixes.
IOW, if the xfsaild is cycling through and finding mostly stuck items,
then we see a delay because of the time spent in a log force (because of
those stuck items), what's the advantage to issue an async force over a
sync force? Won't xfsaild effectively continue to spin on these stuck
items until the log force completes, regardless?

Is the issue not so much the throughput of xfsaild, but just the fact
that the task stalls are large enough to cause other problems? I.e., the
comment you add down in the xfsaild code refers to tail pinning causing
reservation stalls. IOW, the purpose of this patch is then to keep
xfsaild sleeps to a predictable latency to ensure we come around again
quickly enough to keep the tail moving forward (even though the AIL
itself might remain in a state where the majority of items are stuck).
Yes?

> We already have an internal interface to do this -
> xlog_cil_push_now() - but we need a wrapper for it to be used
> externally. xlog_cil_force_seq() can easily be extended to do what
> we need as it already implements the synchronous CIL push via
> xlog_cil_push_now(). Add the necessary flags and "push current
> sequence" semantics to xlog_cil_force_seq() and convert the AIL
> pushing to use it.
> 
> One of the complexities here is that the CIL push does not guarantee
> that the commit record for the CIL checkpoint is written to disk.
> The current log force ensures this by submitting the current ACTIVE
> iclog that the commit record was written to. We need the CIL to
> actually write this commit record to disk for an async push to
> ensure that the checkpoint actually makes it to disk and unpins the
> pinned items in the checkpoint on completion. Hence we need to pass
> down to the CIL push that we are doing an async flush so that it can
> switch out the commit_iclog if necessary to get written to disk when
> the commit iclog is finally released.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> Version 2:
> - ensure the CIL checkpoint issues the commit record to disk for an
>   async push. Fixes generic/530 hang on small logs.
> - increment log force stats when the CIL is forced and also when it
>   sleeps to give insight into the amount of blocking being done when
>   the CIL is forced.
> 
>  fs/xfs/xfs_log.c       | 59 +++++++++++++++++++---------------------------
>  fs/xfs/xfs_log.h       |  2 +-
>  fs/xfs/xfs_log_cil.c   | 64 +++++++++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_log_priv.h  | 10 ++++++--
>  fs/xfs/xfs_sysfs.c     |  1 +
>  fs/xfs/xfs_trace.c     |  1 +
>  fs/xfs/xfs_trans.c     |  2 +-
>  fs/xfs/xfs_trans_ail.c | 11 ++++++---
>  8 files changed, 97 insertions(+), 53 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 2fda8c4513b2..1b46559ef64a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
...
> @@ -1127,13 +1159,22 @@ xlog_cil_force_seq(
>  
>  	ASSERT(sequence <= cil->xc_current_sequence);
>  
> +	if (!sequence)
> +		sequence = cil->xc_current_sequence;
> +trace_printk("seq %llu, curseq %llu, ctxseq %llu pushseq %llu flags 0x%x",
> +		sequence, cil->xc_current_sequence, cil->xc_ctx->sequence,
> +		cil->xc_push_seq, flags);
> +
> +	trace_xfs_log_force(log->l_mp, sequence, _RET_IP_);
>  	/*
>  	 * check to see if we need to force out the current context.
>  	 * xlog_cil_push() handles racing pushes for the same sequence,
>  	 * so no need to deal with it here.
>  	 */
>  restart:
> -	xlog_cil_push_now(log, sequence);
> +	xlog_cil_push_now(log, sequence, flags & XFS_LOG_SYNC);
> +	if (!(flags & XFS_LOG_SYNC))
> +		return commit_lsn;

Hm, so now we have sync and async log force and sync and async CIL push.
A log force always requires a sync CIL push and commit record submit;
the difference is simply whether or not we wait on commit record I/O
completion. The sync CIL push drains the CIL of log items but does not
switch out the commit record iclog, while the async CIL push executes in
the workqueue context so the drain is async, but it does switch out the
commit record iclog before it completes. IOW, the async CIL push is
basically a "more async" async log force.

I can see the need for the behavior of the async CIL push here, but that
leaves a mess of interfaces and behavior matrix. Is there any reason we
couldn't just make async log forces unconditionally behave equivalent to
the async CIL push as defined by this patch? There's only a handful of
existing users and I don't see any obvious reason why they might care
whether the underlying CIL push is synchronous or not...

Brian

>  
>  	/*
>  	 * See if we can find a previous sequence still committing.
> @@ -1157,6 +1198,7 @@ xlog_cil_force_seq(
>  			 * It is still being pushed! Wait for the push to
>  			 * complete, then start again from the beginning.
>  			 */
> +			XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
>  			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
>  			goto restart;
>  		}
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 7e8ec77bc6e6..6b1a251dd013 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -273,6 +273,7 @@ struct xfs_cil {
>  
>  	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
>  	uint64_t		xc_push_seq;
> +	bool			xc_push_async;
>  	struct list_head	xc_committing;
>  	wait_queue_head_t	xc_commit_wait;
>  	uint64_t		xc_current_sequence;
> @@ -487,6 +488,10 @@ int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>  		struct xlog_in_core **commit_iclog, uint optype);
>  int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>  		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
> +void	xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
> +		int eventual_size);
> +int	xlog_state_release_iclog(struct xlog *xlog, struct xlog_in_core *iclog);
> +
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>  
> @@ -558,12 +563,13 @@ void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
>  /*
>   * CIL force routines
>   */
> -xfs_lsn_t xlog_cil_force_seq(struct xlog *log, uint64_t sequence);
> +xfs_lsn_t xlog_cil_force_seq(struct xlog *log, uint32_t flags,
> +				uint64_t sequence);
>  
>  static inline void
>  xlog_cil_force(struct xlog *log)
>  {
> -	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
> +	xlog_cil_force_seq(log, XFS_LOG_SYNC, log->l_cilp->xc_current_sequence);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index f1bc88f4367c..18dc5eca6c04 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_sysfs.h"
> +#include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_mount.h"
>  
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 9b8d703dc9fd..d111a994b7b6 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -20,6 +20,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans.h"
> +#include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_quota.h"
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 697703f3be48..7d05694681e3 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -9,7 +9,6 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> -#include "xfs_log_priv.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_extent_busy.h"
> @@ -17,6 +16,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
>  #include "xfs_defer.h"
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index dbb69b4bf3ed..dfc0206c0d36 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -17,6 +17,7 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  
>  #ifdef DEBUG
>  /*
> @@ -429,8 +430,12 @@ xfsaild_push(
>  
>  	/*
>  	 * If we encountered pinned items or did not finish writing out all
> -	 * buffers the last time we ran, force the log first and wait for it
> -	 * before pushing again.
> +	 * buffers the last time we ran, force a background CIL push to get the
> +	 * items unpinned in the near future. We do not wait on the CIL push as
> +	 * that could stall us for seconds if there is enough background IO
> +	 * load. Stalling for that long when the tail of the log is pinned and
> +	 * needs flushing will hard stop the transaction subsystem when log
> +	 * space runs out.
>  	 */
>  	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
>  	    (!list_empty_careful(&ailp->ail_buf_list) ||
> @@ -438,7 +443,7 @@ xfsaild_push(
>  		ailp->ail_log_flush = 0;
>  
>  		XFS_STATS_INC(mp, xs_push_ail_flush);
> -		xfs_log_force(mp, XFS_LOG_SYNC);
> +		xlog_cil_force_seq(mp->m_log, 0, 0);
>  	}
>  
>  	spin_lock(&ailp->ail_lock);
> 

